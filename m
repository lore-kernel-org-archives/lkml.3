Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaI3GOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:14:47 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44406 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaI3GOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:14:45 -0400
Date: Tue, 30 Sep 2014 01:12:30 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] staging: skein: In progress changes
Message-ID: <c3ad83d6f37a60a7d54d434fbf60914e5bc3cb83.1412056800.git.eric.rost@mybabylon.net>
References: <cover.1412056799.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1412056799.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In progress commit
Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_block.c |  132 +++++++++++++++++++----------------
 1 file changed, 70 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 71c14f5..b8e4bd8 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -42,17 +42,9 @@
 #define debug_save_tweak(ctx)
 #endif
 
-/*****************************  SKEIN_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
-void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
-			     size_t blk_cnt, size_t byte_cnt_add)
-{ /* do it in C */
-	enum {
-		WCNT = SKEIN_256_STATE_WORDS
-	};
 #undef  RCNT
 #define RCNT (SKEIN_256_ROUNDS_TOTAL / 8)
-
 #ifdef SKEIN_LOOP /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_256 (((SKEIN_LOOP) / 100) % 10)
 #else
@@ -63,56 +55,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 #if (RCNT % SKEIN_UNROLL_256)
 #error "Invalid SKEIN_UNROLL_256" /* sanity check on unroll count */
 #endif
-	size_t  r;
-	u64  kw[WCNT+4+RCNT*2]; /* key schedule: chaining vars + tweak + "rot"*/
-#else
-	u64  kw[WCNT+4]; /* key schedule words : chaining vars + tweak */
 #endif
-	u64  X0, X1, X2, X3; /* local copy of context vars, for speed */
-	u64  w[WCNT]; /* local copy of input block */
-#ifdef SKEIN_DEBUG
-	const u64 *X_ptr[4]; /* use for debugging (help cc put Xn in regs) */
-
-	X_ptr[0] = &X0;  X_ptr[1] = &X1;  X_ptr[2] = &X2;  X_ptr[3] = &X3;
-#endif
-	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
-	ts[0] = ctx->h.tweak[0];
-	ts[1] = ctx->h.tweak[1];
-	do  {
-		/*
-		 * this implementation only supports 2**64 input bytes
-		 * (no carry out here)
-		 */
-		ts[0] += byte_cnt_add; /* update processed length */
-
-		/* precompute the key schedule for this block */
-		ks[0] = ctx->x[0];
-		ks[1] = ctx->x[1];
-		ks[2] = ctx->x[2];
-		ks[3] = ctx->x[3];
-		ks[4] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^ SKEIN_KS_PARITY;
-
-		ts[2] = ts[0] ^ ts[1];
-
-		/* get input block in little-endian format */
-		skein_get64_lsb_first(w, blk_ptr, WCNT);
-		debug_save_tweak(ctx);
-		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
-
-		/* do the first full key injection */
-		X0 = w[0] + ks[0];
-		X1 = w[1] + ks[1] + ts[0];
-		X2 = w[2] + ks[2] + ts[1];
-		X3 = w[3] + ks[3];
-
-		/* show starting state values */
-		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 x_ptr);
-
-		blk_ptr += SKEIN_256_BLOCK_BYTES;
-
-		/* run the rounds */
-
 #define ROUND256(p0, p1, p2, p3, ROT, r_num) \
 do {                                         \
 	X##p0 += X##p1;                      \
@@ -159,10 +102,7 @@ do { \
 	ts[r + (R) + 2] = ts[r + (R) - 1];                                \
 	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
-
-	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)
 #endif
-		{
 #define R256_8_ROUNDS(R)                                 \
 do {                                                     \
 		R256(0, 1, 2, 3, R_256_0, 8 * (R) + 1);  \
@@ -177,13 +117,81 @@ do {                                                     \
 		I256(2 * (R) + 1);                       \
 } while (0)
 
-		R256_8_ROUNDS(0);
-
 #define R256_UNROLL_R(NN)                     \
 	((SKEIN_UNROLL_256 == 0 &&            \
 	SKEIN_256_ROUNDS_TOTAL / 8 > (NN)) || \
 	(SKEIN_UNROLL_256 > (NN)))
 
+#endif
+
+
+/*****************************  SKEIN_256 ******************************/
+#if !(SKEIN_USE_ASM & 256)
+void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
+			     size_t blk_cnt, size_t byte_cnt_add)
+{ /* do it in C */
+	enum {
+		WCNT = SKEIN_256_STATE_WORDS
+	};
+
+#if SKEIN_UNROLL_256
+	size_t  r;
+	u64  kw[WCNT+4+RCNT*2]; /* key schedule: chaining vars + tweak + "rot"*/
+#else
+	u64  kw[WCNT+4]; /* key schedule words : chaining vars + tweak */
+#endif
+	u64  X0, X1, X2, X3; /* local copy of context vars, for speed */
+	u64  w[WCNT]; /* local copy of input block */
+#ifdef SKEIN_DEBUG
+	const u64 *X_ptr[4]; /* use for debugging (help cc put Xn in regs) */
+
+	X_ptr[0] = &X0;  X_ptr[1] = &X1;  X_ptr[2] = &X2;  X_ptr[3] = &X3;
+#endif
+	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
+	ts[0] = ctx->h.tweak[0];
+	ts[1] = ctx->h.tweak[1];
+	do  {
+		/*
+		 * this implementation only supports 2**64 input bytes
+		 * (no carry out here)
+		 */
+		ts[0] += byte_cnt_add; /* update processed length */
+
+		/* precompute the key schedule for this block */
+		ks[0] = ctx->x[0];
+		ks[1] = ctx->x[1];
+		ks[2] = ctx->x[2];
+		ks[3] = ctx->x[3];
+		ks[4] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^ SKEIN_KS_PARITY;
+
+		ts[2] = ts[0] ^ ts[1];
+
+		/* get input block in little-endian format */
+		skein_get64_lsb_first(w, blk_ptr, WCNT);
+		debug_save_tweak(ctx);
+		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
+
+		/* do the first full key injection */
+		X0 = w[0] + ks[0];
+		X1 = w[1] + ks[1] + ts[0];
+		X2 = w[2] + ks[2] + ts[1];
+		X3 = w[3] + ks[3];
+
+		/* show starting state values */
+		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
+				 x_ptr);
+
+		blk_ptr += SKEIN_256_BLOCK_BYTES;
+
+		/* run the rounds */
+#if SKEIN_UNROLL_256
+
+	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)
+#endif
+		{
+
+		R256_8_ROUNDS(0);
+
 #if   R256_UNROLL_R(1)
 		R256_8_ROUNDS(1);
 #endif
-- 
1.7.10.4

