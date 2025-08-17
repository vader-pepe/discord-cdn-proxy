# ----------------------------
# Stage 1: Build & Cache Dependencies
# ----------------------------
FROM denoland/deno:latest AS builder
WORKDIR /app

# Cache dependencies by pre-caching the entry point
COPY deno/index.ts ./deno/index.ts
RUN deno cache deno/index.ts

# Copy the rest of the source code
COPY . .

# ----------------------------
# Stage 2: Production Runtime
# ----------------------------
FROM denoland/deno:latest
WORKDIR /app

# Copy the full app from builder (deno_dir is already inside image layer)
COPY --from=builder /app /app

# Switch to non-root user for better security
USER deno

# Expose default port (adjust if needed)
EXPOSE 8000

# Run the proxy with necessary permissions
CMD ["deno", "run", "--allow-net", "--allow-env", "./deno/index.ts"]
