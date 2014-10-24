Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaJXLTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:19:23 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:48026 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbaJXLTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:19:21 -0400
Date: Fri, 24 Oct 2014 06:17:14 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/7] staging: skein: Renames skein to skein_base
Message-ID: <b60dcbe0965eba783e26007d46ed47b0004a65fb.1414149238.git.eric.rost@mybabylon.net>
References: <cover.1414149238.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414149238.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renames skein.c to skein_base.c and skein.h to skein_base.h

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Makefile        |   2 +-
 drivers/staging/skein/skein.c         | 883 ---------------------------------
 drivers/staging/skein/skein.h         | 346 -------------
 drivers/staging/skein/skein_api.h     |   2 +-
 drivers/staging/skein/skein_base.c    | 884 ++++++++++++++++++++++++++++++++++
 drivers/staging/skein/skein_base.h    | 351 ++++++++++++++
 drivers/staging/skein/skein_block.c   |   2 +-
 drivers/staging/skein/skein_block.h   |   2 +-
 drivers/staging/skein/skein_iv.h      |   2 +-
 drivers/staging/skein/threefish_api.h |   2 +-
 10 files changed, 1241 insertions(+), 1235 deletions(-)
 delete mode 100644 drivers/staging/skein/skein.c
 delete mode 100644 drivers/staging/skein/skein.h
 create mode 100644 drivers/staging/skein/skein_base.c
 create mode 100644 drivers/staging/skein/skein_base.h

diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index 4b60171..ca746a9 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the skein secure hash algorithm
 #
-obj-$(CONFIG_CRYPTO_SKEIN) += skein.o \
+obj-$(CONFIG_CRYPTO_SKEIN) += skein_base.o \
 			      skein_api.o \
 			      skein_block.o \
 			      threefish_block.o \
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
deleted file mode 100644
index 8cc8358..0000000
--- a/drivers/staging/skein/skein.c
+++ /dev/null
@@ -1,883 +0,0 @@
-/***********************************************************************
-**
-** Implementation of the Skein hash function.
-**
-** Source code author: Doug Whiting, 2008.
-**
-** This algorithm and source code is released to the public domain.
-**
-************************************************************************/
-
-#define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
-
-#include <linux/string.h>       /* get the memcpy/memset functions */
-#include "skein.h" /* get the Skein API definitions   */
-#include "skein_iv.h"    /* get precomputed IVs */
-#include "skein_block.h"
-
-/*****************************************************************/
-/*     256-bit Skein                                             */
-/*****************************************************************/
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* init the context for a straight hashing operation  */
-int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
-{
-	union {
-		u8 b[SKEIN_256_STATE_BYTES];
-		u64 w[SKEIN_256_STATE_WORDS];
-	} cfg;                              /* config block */
-
-	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
-
-	switch (hash_bit_len) { /* use pre-computed values, where available */
-	case  256:
-		memcpy(ctx->x, SKEIN_256_IV_256, sizeof(ctx->x));
-		break;
-	case  224:
-		memcpy(ctx->x, SKEIN_256_IV_224, sizeof(ctx->x));
-		break;
-	case  160:
-		memcpy(ctx->x, SKEIN_256_IV_160, sizeof(ctx->x));
-		break;
-	case  128:
-		memcpy(ctx->x, SKEIN_256_IV_128, sizeof(ctx->x));
-		break;
-	default:
-		/* here if there is no precomputed IV value available */
-		/*
-		 * build/process the config block, type == CONFIG (could be
-		 * precomputed)
-		 */
-		/* set tweaks: T0=0; T1=CFG | FINAL */
-		skein_start_new_type(ctx, CFG_FINAL);
-
-		/* set the schema, version */
-		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
-		/* hash result length in bits */
-		cfg.w[1] = skein_swap64(hash_bit_len);
-		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-		/* zero pad config block */
-		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
-
-		/* compute the initial chaining values from config block */
-		/* zero the chaining variables */
-		memset(ctx->x, 0, sizeof(ctx->x));
-		skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
-		break;
-	}
-	/* The chaining vars ctx->x are now initialized for hash_bit_len. */
-	/* Set up to process the data message portion of the hash (default) */
-	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* init the context for a MAC and/or tree hash operation */
-/* [identical to skein_256_init() when key_bytes == 0 && \
- *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
-		       u64 tree_info, const u8 *key, size_t key_bytes)
-{
-	union {
-		u8  b[SKEIN_256_STATE_BYTES];
-		u64 w[SKEIN_256_STATE_WORDS];
-	} cfg; /* config block */
-
-	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
-
-	/* compute the initial chaining values ctx->x[], based on key */
-	if (key_bytes == 0) { /* is there a key? */
-		/* no key: use all zeroes as key for config block */
-		memset(ctx->x, 0, sizeof(ctx->x));
-	} else { /* here to pre-process a key */
-		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
-		/* do a mini-Init right here */
-		/* set output hash bit count = state size */
-		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
-		/* set tweaks: T0 = 0; T1 = KEY type */
-		skein_start_new_type(ctx, KEY);
-		/* zero the initial chaining variables */
-		memset(ctx->x, 0, sizeof(ctx->x));
-		/* hash the key */
-		skein_256_update(ctx, key, key_bytes);
-		/* put result into cfg.b[] */
-		skein_256_final_pad(ctx, cfg.b);
-		/* copy over into ctx->x[] */
-		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
-	}
-	/*
-	 * build/process the config block, type == CONFIG (could be
-	 * precomputed for each key)
-	 */
-	/* output hash bit count */
-	ctx->h.hash_bit_len = hash_bit_len;
-	skein_start_new_type(ctx, CFG_FINAL);
-
-	/* pre-pad cfg.w[] with zeroes */
-	memset(&cfg.w, 0, sizeof(cfg.w));
-	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
-	/* hash result length in bits */
-	cfg.w[1] = skein_swap64(hash_bit_len);
-	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = skein_swap64(tree_info);
-
-	skein_show_key(256, &ctx->h, key, key_bytes);
-
-	/* compute the initial chaining values from config block */
-	skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
-
-	/* The chaining vars ctx->x are now initialized */
-	/* Set up to process the data message portion of the hash (default) */
-	skein_start_new_type(ctx, MSG);
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* process the input bytes */
-int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
-		     size_t msg_byte_cnt)
-{
-	size_t n;
-
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* process full blocks, if any */
-	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_256_BLOCK_BYTES) {
-		/* finish up any buffered message data */
-		if (ctx->h.b_cnt) {
-			/* # bytes free in buffer b[] */
-			n = SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt;
-			if (n) {
-				/* check on our logic here */
-				skein_assert(n < msg_byte_cnt);
-				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
-				msg_byte_cnt  -= n;
-				msg         += n;
-				ctx->h.b_cnt += n;
-			}
-			skein_assert(ctx->h.b_cnt == SKEIN_256_BLOCK_BYTES);
-			skein_256_process_block(ctx, ctx->b, 1,
-						SKEIN_256_BLOCK_BYTES);
-			ctx->h.b_cnt = 0;
-		}
-		/*
-		 * now process any remaining full blocks, directly from input
-		 * message data
-		 */
-		if (msg_byte_cnt > SKEIN_256_BLOCK_BYTES) {
-			/* number of full blocks to process */
-			n = (msg_byte_cnt-1) / SKEIN_256_BLOCK_BYTES;
-			skein_256_process_block(ctx, msg, n,
-						SKEIN_256_BLOCK_BYTES);
-			msg_byte_cnt -= n * SKEIN_256_BLOCK_BYTES;
-			msg        += n * SKEIN_256_BLOCK_BYTES;
-		}
-		skein_assert(ctx->h.b_cnt == 0);
-	}
-
-	/* copy any remaining source message data bytes into b[] */
-	if (msg_byte_cnt) {
-		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
-			     SKEIN_256_BLOCK_BYTES);
-		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
-		ctx->h.b_cnt += msg_byte_cnt;
-	}
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* finalize the hash computation and output the result */
-int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
-{
-	size_t i, n, byte_cnt;
-	u64 x[SKEIN_256_STATE_WORDS];
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* tag as the final block */
-	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
-	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt);
-
-	/* process the final block */
-	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
-
-	/* now output the result */
-	/* total number of output bytes */
-	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
-
-	/* run Threefish in "counter mode" to generate output */
-	/* zero out b[], so it can hold the counter */
-	memset(ctx->b, 0, sizeof(ctx->b));
-	/* keep a local copy of counter mode "key" */
-	memcpy(x, ctx->x, sizeof(x));
-	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
-		/* build the counter block */
-		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
-		skein_start_new_type(ctx, OUT_FINAL);
-		/* run "counter mode" */
-		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
-		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN_256_BLOCK_BYTES;
-		if (n >= SKEIN_256_BLOCK_BYTES)
-			n  = SKEIN_256_BLOCK_BYTES;
-		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
-				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_256_BLOCK_BYTES);
-		/* restore the counter mode key for next time */
-		memcpy(ctx->x, x, sizeof(x));
-	}
-	return SKEIN_SUCCESS;
-}
-
-/*****************************************************************/
-/*     512-bit Skein                                             */
-/*****************************************************************/
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* init the context for a straight hashing operation  */
-int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
-{
-	union {
-		u8 b[SKEIN_512_STATE_BYTES];
-		u64 w[SKEIN_512_STATE_WORDS];
-	} cfg;                              /* config block */
-
-	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
-
-	switch (hash_bit_len) { /* use pre-computed values, where available */
-	case  512:
-		memcpy(ctx->x, SKEIN_512_IV_512, sizeof(ctx->x));
-		break;
-	case  384:
-		memcpy(ctx->x, SKEIN_512_IV_384, sizeof(ctx->x));
-		break;
-	case  256:
-		memcpy(ctx->x, SKEIN_512_IV_256, sizeof(ctx->x));
-		break;
-	case  224:
-		memcpy(ctx->x, SKEIN_512_IV_224, sizeof(ctx->x));
-		break;
-	default:
-		/* here if there is no precomputed IV value available */
-		/*
-		 * build/process the config block, type == CONFIG (could be
-		 * precomputed)
-		 */
-		/* set tweaks: T0=0; T1=CFG | FINAL */
-		skein_start_new_type(ctx, CFG_FINAL);
-
-		/* set the schema, version */
-		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
-		/* hash result length in bits */
-		cfg.w[1] = skein_swap64(hash_bit_len);
-		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-		/* zero pad config block */
-		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
-
-		/* compute the initial chaining values from config block */
-		/* zero the chaining variables */
-		memset(ctx->x, 0, sizeof(ctx->x));
-		skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
-		break;
-	}
-
-	/*
-	 * The chaining vars ctx->x are now initialized for the given
-	 * hash_bit_len.
-	 */
-	/* Set up to process the data message portion of the hash (default) */
-	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* init the context for a MAC and/or tree hash operation */
-/* [identical to skein_512_init() when key_bytes == 0 && \
- *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
-		       u64 tree_info, const u8 *key, size_t key_bytes)
-{
-	union {
-		u8 b[SKEIN_512_STATE_BYTES];
-		u64 w[SKEIN_512_STATE_WORDS];
-	} cfg;                              /* config block */
-
-	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
-
-	/* compute the initial chaining values ctx->x[], based on key */
-	if (key_bytes == 0) { /* is there a key? */
-		/* no key: use all zeroes as key for config block */
-		memset(ctx->x, 0, sizeof(ctx->x));
-	} else { /* here to pre-process a key */
-		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
-		/* do a mini-Init right here */
-		/* set output hash bit count = state size */
-		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
-		/* set tweaks: T0 = 0; T1 = KEY type */
-		skein_start_new_type(ctx, KEY);
-		/* zero the initial chaining variables */
-		memset(ctx->x, 0, sizeof(ctx->x));
-		/* hash the key */
-		skein_512_update(ctx, key, key_bytes);
-		/* put result into cfg.b[] */
-		skein_512_final_pad(ctx, cfg.b);
-		/* copy over into ctx->x[] */
-		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
-	}
-	/*
-	 * build/process the config block, type == CONFIG (could be
-	 * precomputed for each key)
-	 */
-	ctx->h.hash_bit_len = hash_bit_len;          /* output hash bit count */
-	skein_start_new_type(ctx, CFG_FINAL);
-
-	/* pre-pad cfg.w[] with zeroes */
-	memset(&cfg.w, 0, sizeof(cfg.w));
-	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
-	/* hash result length in bits */
-	cfg.w[1] = skein_swap64(hash_bit_len);
-	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = skein_swap64(tree_info);
-
-	skein_show_key(512, &ctx->h, key, key_bytes);
-
-	/* compute the initial chaining values from config block */
-	skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
-
-	/* The chaining vars ctx->x are now initialized */
-	/* Set up to process the data message portion of the hash (default) */
-	skein_start_new_type(ctx, MSG);
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* process the input bytes */
-int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
-		     size_t msg_byte_cnt)
-{
-	size_t n;
-
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* process full blocks, if any */
-	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_512_BLOCK_BYTES) {
-		/* finish up any buffered message data */
-		if (ctx->h.b_cnt) {
-			/* # bytes free in buffer b[] */
-			n = SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt;
-			if (n) {
-				/* check on our logic here */
-				skein_assert(n < msg_byte_cnt);
-				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
-				msg_byte_cnt  -= n;
-				msg         += n;
-				ctx->h.b_cnt += n;
-			}
-			skein_assert(ctx->h.b_cnt == SKEIN_512_BLOCK_BYTES);
-			skein_512_process_block(ctx, ctx->b, 1,
-						SKEIN_512_BLOCK_BYTES);
-			ctx->h.b_cnt = 0;
-		}
-		/*
-		 * now process any remaining full blocks, directly from input
-		 * message data
-		 */
-		if (msg_byte_cnt > SKEIN_512_BLOCK_BYTES) {
-			/* number of full blocks to process */
-			n = (msg_byte_cnt-1) / SKEIN_512_BLOCK_BYTES;
-			skein_512_process_block(ctx, msg, n,
-						SKEIN_512_BLOCK_BYTES);
-			msg_byte_cnt -= n * SKEIN_512_BLOCK_BYTES;
-			msg        += n * SKEIN_512_BLOCK_BYTES;
-		}
-		skein_assert(ctx->h.b_cnt == 0);
-	}
-
-	/* copy any remaining source message data bytes into b[] */
-	if (msg_byte_cnt) {
-		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
-			     SKEIN_512_BLOCK_BYTES);
-		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
-		ctx->h.b_cnt += msg_byte_cnt;
-	}
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* finalize the hash computation and output the result */
-int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
-{
-	size_t i, n, byte_cnt;
-	u64 x[SKEIN_512_STATE_WORDS];
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* tag as the final block */
-	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
-	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt);
-
-	/* process the final block */
-	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
-
-	/* now output the result */
-	/* total number of output bytes */
-	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
-
-	/* run Threefish in "counter mode" to generate output */
-	/* zero out b[], so it can hold the counter */
-	memset(ctx->b, 0, sizeof(ctx->b));
-	/* keep a local copy of counter mode "key" */
-	memcpy(x, ctx->x, sizeof(x));
-	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
-		/* build the counter block */
-		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
-		skein_start_new_type(ctx, OUT_FINAL);
-		/* run "counter mode" */
-		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
-		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN_512_BLOCK_BYTES;
-		if (n >= SKEIN_512_BLOCK_BYTES)
-			n  = SKEIN_512_BLOCK_BYTES;
-		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
-				      n);
-		skein_show_final(512, &ctx->h, n,
-				 hash_val+i*SKEIN_512_BLOCK_BYTES);
-		/* restore the counter mode key for next time */
-		memcpy(ctx->x, x, sizeof(x));
-	}
-	return SKEIN_SUCCESS;
-}
-
-/*****************************************************************/
-/*    1024-bit Skein                                             */
-/*****************************************************************/
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* init the context for a straight hashing operation  */
-int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
-{
-	union {
-		u8 b[SKEIN_1024_STATE_BYTES];
-		u64 w[SKEIN_1024_STATE_WORDS];
-	} cfg;                              /* config block */
-
-	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
-
-	switch (hash_bit_len) { /* use pre-computed values, where available */
-	case  512:
-		memcpy(ctx->x, SKEIN_1024_IV_512, sizeof(ctx->x));
-		break;
-	case  384:
-		memcpy(ctx->x, SKEIN_1024_IV_384, sizeof(ctx->x));
-		break;
-	case 1024:
-		memcpy(ctx->x, SKEIN_1024_IV_1024, sizeof(ctx->x));
-		break;
-	default:
-		/* here if there is no precomputed IV value available */
-		/*
-		 * build/process the config block, type == CONFIG
-		 * (could be precomputed)
-		 */
-		/* set tweaks: T0=0; T1=CFG | FINAL */
-		skein_start_new_type(ctx, CFG_FINAL);
-
-		/* set the schema, version */
-		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
-		/* hash result length in bits */
-		cfg.w[1] = skein_swap64(hash_bit_len);
-		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-		/* zero pad config block */
-		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
-
-		/* compute the initial chaining values from config block */
-		/* zero the chaining variables */
-		memset(ctx->x, 0, sizeof(ctx->x));
-		skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
-		break;
-	}
-
-	/* The chaining vars ctx->x are now initialized for the hash_bit_len. */
-	/* Set up to process the data message portion of the hash (default) */
-	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* init the context for a MAC and/or tree hash operation */
-/* [identical to skein_1024_init() when key_bytes == 0 && \
- *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
-			u64 tree_info, const u8 *key, size_t key_bytes)
-{
-	union {
-		u8 b[SKEIN_1024_STATE_BYTES];
-		u64 w[SKEIN_1024_STATE_WORDS];
-	} cfg;                              /* config block */
-
-	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
-
-	/* compute the initial chaining values ctx->x[], based on key */
-	if (key_bytes == 0) { /* is there a key? */
-		/* no key: use all zeroes as key for config block */
-		memset(ctx->x, 0, sizeof(ctx->x));
-	} else { /* here to pre-process a key */
-		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
-		/* do a mini-Init right here */
-		/* set output hash bit count = state size */
-		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
-		/* set tweaks: T0 = 0; T1 = KEY type */
-		skein_start_new_type(ctx, KEY);
-		/* zero the initial chaining variables */
-		memset(ctx->x, 0, sizeof(ctx->x));
-		/* hash the key */
-		skein_1024_update(ctx, key, key_bytes);
-		/* put result into cfg.b[] */
-		skein_1024_final_pad(ctx, cfg.b);
-		/* copy over into ctx->x[] */
-		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
-	}
-	/*
-	 * build/process the config block, type == CONFIG (could be
-	 * precomputed for each key)
-	 */
-	/* output hash bit count */
-	ctx->h.hash_bit_len = hash_bit_len;
-	skein_start_new_type(ctx, CFG_FINAL);
-
-	/* pre-pad cfg.w[] with zeroes */
-	memset(&cfg.w, 0, sizeof(cfg.w));
-	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
-	/* hash result length in bits */
-	cfg.w[1] = skein_swap64(hash_bit_len);
-	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = skein_swap64(tree_info);
-
-	skein_show_key(1024, &ctx->h, key, key_bytes);
-
-	/* compute the initial chaining values from config block */
-	skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
-
-	/* The chaining vars ctx->x are now initialized */
-	/* Set up to process the data message portion of the hash (default) */
-	skein_start_new_type(ctx, MSG);
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* process the input bytes */
-int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
-		      size_t msg_byte_cnt)
-{
-	size_t n;
-
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* process full blocks, if any */
-	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_1024_BLOCK_BYTES) {
-		/* finish up any buffered message data */
-		if (ctx->h.b_cnt) {
-			/* # bytes free in buffer b[] */
-			n = SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt;
-			if (n) {
-				/* check on our logic here */
-				skein_assert(n < msg_byte_cnt);
-				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
-				msg_byte_cnt  -= n;
-				msg         += n;
-				ctx->h.b_cnt += n;
-			}
-			skein_assert(ctx->h.b_cnt == SKEIN_1024_BLOCK_BYTES);
-			skein_1024_process_block(ctx, ctx->b, 1,
-						 SKEIN_1024_BLOCK_BYTES);
-			ctx->h.b_cnt = 0;
-		}
-		/*
-		 * now process any remaining full blocks, directly from input
-		 * message data
-		 */
-		if (msg_byte_cnt > SKEIN_1024_BLOCK_BYTES) {
-			/* number of full blocks to process */
-			n = (msg_byte_cnt-1) / SKEIN_1024_BLOCK_BYTES;
-			skein_1024_process_block(ctx, msg, n,
-						 SKEIN_1024_BLOCK_BYTES);
-			msg_byte_cnt -= n * SKEIN_1024_BLOCK_BYTES;
-			msg        += n * SKEIN_1024_BLOCK_BYTES;
-		}
-		skein_assert(ctx->h.b_cnt == 0);
-	}
-
-	/* copy any remaining source message data bytes into b[] */
-	if (msg_byte_cnt) {
-		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
-			     SKEIN_1024_BLOCK_BYTES);
-		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
-		ctx->h.b_cnt += msg_byte_cnt;
-	}
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* finalize the hash computation and output the result */
-int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
-{
-	size_t i, n, byte_cnt;
-	u64 x[SKEIN_1024_STATE_WORDS];
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* tag as the final block */
-	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
-	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt);
-
-	/* process the final block */
-	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
-
-	/* now output the result */
-	/* total number of output bytes */
-	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
-
-	/* run Threefish in "counter mode" to generate output */
-	/* zero out b[], so it can hold the counter */
-	memset(ctx->b, 0, sizeof(ctx->b));
-	/* keep a local copy of counter mode "key" */
-	memcpy(x, ctx->x, sizeof(x));
-	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
-		/* build the counter block */
-		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
-		skein_start_new_type(ctx, OUT_FINAL);
-		/* run "counter mode" */
-		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
-		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN_1024_BLOCK_BYTES;
-		if (n >= SKEIN_1024_BLOCK_BYTES)
-			n  = SKEIN_1024_BLOCK_BYTES;
-		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
-				      n);
-		skein_show_final(1024, &ctx->h, n,
-				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
-		/* restore the counter mode key for next time */
-		memcpy(ctx->x, x, sizeof(x));
-	}
-	return SKEIN_SUCCESS;
-}
-
-/**************** Functions to support MAC/tree hashing ***************/
-/*   (this code is identical for Optimized and Reference versions)    */
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* finalize the hash computation and output the block, no OUTPUT stage */
-int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
-{
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* tag as the final block */
-	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
-	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt);
-	/* process the final block */
-	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
-
-	/* "output" the state bytes */
-	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_256_BLOCK_BYTES);
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* finalize the hash computation and output the block, no OUTPUT stage */
-int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
-{
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* tag as the final block */
-	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
-	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt);
-	/* process the final block */
-	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
-
-	/* "output" the state bytes */
-	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_512_BLOCK_BYTES);
-
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* finalize the hash computation and output the block, no OUTPUT stage */
-int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val)
-{
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* tag as the final block */
-	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
-	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt);
-	/* process the final block */
-	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
-
-	/* "output" the state bytes */
-	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_1024_BLOCK_BYTES);
-
-	return SKEIN_SUCCESS;
-}
-
-#if SKEIN_TREE_HASH
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* just do the OUTPUT stage                                       */
-int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
-{
-	size_t i, n, byte_cnt;
-	u64 x[SKEIN_256_STATE_WORDS];
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* now output the result */
-	/* total number of output bytes */
-	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
-
-	/* run Threefish in "counter mode" to generate output */
-	/* zero out b[], so it can hold the counter */
-	memset(ctx->b, 0, sizeof(ctx->b));
-	/* keep a local copy of counter mode "key" */
-	memcpy(x, ctx->x, sizeof(x));
-	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
-		/* build the counter block */
-		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
-		skein_start_new_type(ctx, OUT_FINAL);
-		/* run "counter mode" */
-		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
-		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN_256_BLOCK_BYTES;
-		if (n >= SKEIN_256_BLOCK_BYTES)
-			n  = SKEIN_256_BLOCK_BYTES;
-		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
-				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_256_BLOCK_BYTES);
-		/* restore the counter mode key for next time */
-		memcpy(ctx->x, x, sizeof(x));
-	}
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* just do the OUTPUT stage                                       */
-int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
-{
-	size_t i, n, byte_cnt;
-	u64 x[SKEIN_512_STATE_WORDS];
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* now output the result */
-	/* total number of output bytes */
-	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
-
-	/* run Threefish in "counter mode" to generate output */
-	/* zero out b[], so it can hold the counter */
-	memset(ctx->b, 0, sizeof(ctx->b));
-	/* keep a local copy of counter mode "key" */
-	memcpy(x, ctx->x, sizeof(x));
-	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
-		/* build the counter block */
-		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
-		skein_start_new_type(ctx, OUT_FINAL);
-		/* run "counter mode" */
-		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
-		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN_512_BLOCK_BYTES;
-		if (n >= SKEIN_512_BLOCK_BYTES)
-			n  = SKEIN_512_BLOCK_BYTES;
-		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
-				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_512_BLOCK_BYTES);
-		/* restore the counter mode key for next time */
-		memcpy(ctx->x, x, sizeof(x));
-	}
-	return SKEIN_SUCCESS;
-}
-
-/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-/* just do the OUTPUT stage                                       */
-int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
-{
-	size_t i, n, byte_cnt;
-	u64 x[SKEIN_1024_STATE_WORDS];
-	/* catch uninitialized context */
-	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
-
-	/* now output the result */
-	/* total number of output bytes */
-	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
-
-	/* run Threefish in "counter mode" to generate output */
-	/* zero out b[], so it can hold the counter */
-	memset(ctx->b, 0, sizeof(ctx->b));
-	/* keep a local copy of counter mode "key" */
-	memcpy(x, ctx->x, sizeof(x));
-	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
-		/* build the counter block */
-		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
-		skein_start_new_type(ctx, OUT_FINAL);
-		/* run "counter mode" */
-		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
-		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN_1024_BLOCK_BYTES;
-		if (n >= SKEIN_1024_BLOCK_BYTES)
-			n  = SKEIN_1024_BLOCK_BYTES;
-		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
-				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
-		/* restore the counter mode key for next time */
-		memcpy(ctx->x, x, sizeof(x));
-	}
-	return SKEIN_SUCCESS;
-}
-#endif
diff --git a/drivers/staging/skein/skein.h b/drivers/staging/skein/skein.h
deleted file mode 100644
index e6669f1..0000000
--- a/drivers/staging/skein/skein.h
+++ /dev/null
@@ -1,346 +0,0 @@
-#ifndef _SKEIN_H_
-#define _SKEIN_H_     1
-/**************************************************************************
-**
-** Interface declarations and internal definitions for Skein hashing.
-**
-** Source code author: Doug Whiting, 2008.
-**
-** This algorithm and source code is released to the public domain.
-**
-***************************************************************************
-**
-** The following compile-time switches may be defined to control some
-** tradeoffs between speed, code size, error checking, and security.
-**
-** The "default" note explains what happens when the switch is not defined.
-**
-**  SKEIN_DEBUG            -- make callouts from inside Skein code
-**                            to examine/display intermediate values.
-**                            [default: no callouts (no overhead)]
-**
-**  SKEIN_ERR_CHECK        -- how error checking is handled inside Skein
-**                            code. If not defined, most error checking
-**                            is disabled (for performance). Otherwise,
-**                            the switch value is interpreted as:
-**                                0: use assert()      to flag errors
-**                                1: return SKEIN_FAIL to flag errors
-**
-***************************************************************************/
-
-#ifndef rotl_64
-#define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
-#endif
-
-/* below two prototype assume we are handed aligned data */
-#define skein_put64_lsb_first(dst08, src64, b_cnt) memcpy(dst08, src64, b_cnt)
-#define skein_get64_lsb_first(dst64, src08, w_cnt) \
-		memcpy(dst64, src08, 8*(w_cnt))
-#define skein_swap64(w64)  (w64)
-
-enum {
-	SKEIN_SUCCESS         =      0, /* return codes from Skein calls */
-	SKEIN_FAIL            =      1,
-	SKEIN_BAD_HASHLEN     =      2
-};
-
-#define  SKEIN_MODIFIER_WORDS   (2) /* number of modifier (tweak) words */
-
-#define  SKEIN_256_STATE_WORDS  (4)
-#define  SKEIN_512_STATE_WORDS  (8)
-#define  SKEIN_1024_STATE_WORDS (16)
-#define  SKEIN_MAX_STATE_WORDS (16)
-
-#define  SKEIN_256_STATE_BYTES  (8*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_STATE_BYTES  (8*SKEIN_512_STATE_WORDS)
-#define  SKEIN_1024_STATE_BYTES  (8*SKEIN_1024_STATE_WORDS)
-
-#define  SKEIN_256_STATE_BITS  (64*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_STATE_BITS  (64*SKEIN_512_STATE_WORDS)
-#define  SKEIN_1024_STATE_BITS  (64*SKEIN_1024_STATE_WORDS)
-
-#define  SKEIN_256_BLOCK_BYTES  (8*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_BLOCK_BYTES  (8*SKEIN_512_STATE_WORDS)
-#define  SKEIN_1024_BLOCK_BYTES  (8*SKEIN_1024_STATE_WORDS)
-
-struct skein_ctx_hdr {
-	size_t hash_bit_len;		/* size of hash result, in bits */
-	size_t b_cnt;			/* current byte count in buffer b[] */
-	u64 tweak[SKEIN_MODIFIER_WORDS]; /* tweak[0]=byte cnt, tweak[1]=flags */
-};
-
-struct skein_256_ctx { /* 256-bit Skein hash context structure */
-	struct skein_ctx_hdr h;		/* common header context variables */
-	u64 x[SKEIN_256_STATE_WORDS];	/* chaining variables */
-	u8 b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-};
-
-struct skein_512_ctx { /* 512-bit Skein hash context structure */
-	struct skein_ctx_hdr h;		/* common header context variables */
-	u64 x[SKEIN_512_STATE_WORDS];	/* chaining variables */
-	u8 b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-};
-
-struct skein_1024_ctx { /* 1024-bit Skein hash context structure */
-	struct skein_ctx_hdr h;		/* common header context variables */
-	u64 x[SKEIN_1024_STATE_WORDS];	/* chaining variables */
-	u8 b[SKEIN_1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-};
-
-/* Skein APIs for (incremental) "straight hashing" */
-int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len);
-int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len);
-int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len);
-
-int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
-		     size_t msg_byte_cnt);
-int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
-		     size_t msg_byte_cnt);
-int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
-		      size_t msg_byte_cnt);
-
-int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val);
-int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val);
-int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val);
-
-/*
-**   Skein APIs for "extended" initialization: MAC keys, tree hashing.
-**   After an init_ext() call, just use update/final calls as with init().
-**
-**   Notes: Same parameters as _init() calls, plus tree_info/key/key_bytes.
-**          When key_bytes == 0 and tree_info == SKEIN_SEQUENTIAL,
-**              the results of init_ext() are identical to calling init().
-**          The function init() may be called once to "precompute" the IV for
-**              a given hash_bit_len value, then by saving a copy of the context
-**              the IV computation may be avoided in later calls.
-**          Similarly, the function init_ext() may be called once per MAC key
-**              to precompute the MAC IV, then a copy of the context saved and
-**              reused for each new MAC computation.
-**/
-int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
-		       u64 tree_info, const u8 *key, size_t key_bytes);
-int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
-		       u64 tree_info, const u8 *key, size_t key_bytes);
-int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
-			u64 tree_info, const u8 *key, size_t key_bytes);
-
-/*
-**   Skein APIs for MAC and tree hash:
-**      final_pad:  pad, do final block, but no OUTPUT type
-**      output:     do just the output stage
-*/
-int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val);
-int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val);
-int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val);
-
-#ifndef SKEIN_TREE_HASH
-#define SKEIN_TREE_HASH (1)
-#endif
-#if  SKEIN_TREE_HASH
-int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val);
-int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val);
-int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
-#endif
-
-/*****************************************************************
-** "Internal" Skein definitions
-**    -- not needed for sequential hashing API, but will be
-**           helpful for other uses of Skein (e.g., tree hash mode).
-**    -- included here so that they can be shared between
-**           reference and optimized code.
-******************************************************************/
-
-/* tweak word tweak[1]: bit field starting positions */
-#define SKEIN_T1_BIT(BIT)       ((BIT) - 64)      /* second word  */
-
-#define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112) /* 112..118 hash tree level */
-#define SKEIN_T1_POS_BIT_PAD    SKEIN_T1_BIT(119) /* 119 part. final in byte */
-#define SKEIN_T1_POS_BLK_TYPE   SKEIN_T1_BIT(120) /* 120..125 type field `*/
-#define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126) /* 126      first blk flag */
-#define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127) /* 127      final blk flag */
-
-/* tweak word tweak[1]: flag bit definition(s) */
-#define SKEIN_T1_FLAG_FIRST     (((u64)  1) << SKEIN_T1_POS_FIRST)
-#define SKEIN_T1_FLAG_FINAL     (((u64)  1) << SKEIN_T1_POS_FINAL)
-#define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1) << SKEIN_T1_POS_BIT_PAD)
-
-/* tweak word tweak[1]: tree level bit field mask */
-#define SKEIN_T1_TREE_LVL_MASK  (((u64)0x7F) << SKEIN_T1_POS_TREE_LVL)
-#define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
-
-/* tweak word tweak[1]: block type field */
-#define SKEIN_BLK_TYPE_KEY       (0) /* key, for MAC and KDF */
-#define SKEIN_BLK_TYPE_CFG       (4) /* configuration block */
-#define SKEIN_BLK_TYPE_PERS      (8) /* personalization string */
-#define SKEIN_BLK_TYPE_PK       (12) /* pubkey (for digital sigs) */
-#define SKEIN_BLK_TYPE_KDF      (16) /* key identifier for KDF */
-#define SKEIN_BLK_TYPE_NONCE    (20) /* nonce for PRNG */
-#define SKEIN_BLK_TYPE_MSG      (48) /* message processing */
-#define SKEIN_BLK_TYPE_OUT      (63) /* output stage */
-#define SKEIN_BLK_TYPE_MASK     (63) /* bit field mask */
-
-#define SKEIN_T1_BLK_TYPE(T)   (((u64) (SKEIN_BLK_TYPE_##T)) << \
-					SKEIN_T1_POS_BLK_TYPE)
-#define SKEIN_T1_BLK_TYPE_KEY   SKEIN_T1_BLK_TYPE(KEY)  /* for MAC and KDF */
-#define SKEIN_T1_BLK_TYPE_CFG   SKEIN_T1_BLK_TYPE(CFG)  /* config block */
-#define SKEIN_T1_BLK_TYPE_PERS  SKEIN_T1_BLK_TYPE(PERS) /* personalization */
-#define SKEIN_T1_BLK_TYPE_PK    SKEIN_T1_BLK_TYPE(PK)   /* pubkey (for sigs) */
-#define SKEIN_T1_BLK_TYPE_KDF   SKEIN_T1_BLK_TYPE(KDF)  /* key ident for KDF */
-#define SKEIN_T1_BLK_TYPE_NONCE SKEIN_T1_BLK_TYPE(NONCE)/* nonce for PRNG */
-#define SKEIN_T1_BLK_TYPE_MSG   SKEIN_T1_BLK_TYPE(MSG)  /* message processing */
-#define SKEIN_T1_BLK_TYPE_OUT   SKEIN_T1_BLK_TYPE(OUT)  /* output stage */
-#define SKEIN_T1_BLK_TYPE_MASK  SKEIN_T1_BLK_TYPE(MASK) /* field bit mask */
-
-#define SKEIN_T1_BLK_TYPE_CFG_FINAL    (SKEIN_T1_BLK_TYPE_CFG | \
-					SKEIN_T1_FLAG_FINAL)
-#define SKEIN_T1_BLK_TYPE_OUT_FINAL    (SKEIN_T1_BLK_TYPE_OUT | \
-					SKEIN_T1_FLAG_FINAL)
-
-#define SKEIN_VERSION           (1)
-
-#ifndef SKEIN_ID_STRING_LE      /* allow compile-time personalization */
-#define SKEIN_ID_STRING_LE      (0x33414853) /* "SHA3" (little-endian)*/
-#endif
-
-#define SKEIN_MK_64(hi32, lo32)  ((lo32) + (((u64) (hi32)) << 32))
-#define SKEIN_SCHEMA_VER        SKEIN_MK_64(SKEIN_VERSION, SKEIN_ID_STRING_LE)
-#define SKEIN_KS_PARITY         SKEIN_MK_64(0x1BD11BDA, 0xA9FC1A22)
-
-#define SKEIN_CFG_STR_LEN       (4*8)
-
-/* bit field definitions in config block tree_info word */
-#define SKEIN_CFG_TREE_LEAF_SIZE_POS  (0)
-#define SKEIN_CFG_TREE_NODE_SIZE_POS  (8)
-#define SKEIN_CFG_TREE_MAX_LEVEL_POS  (16)
-
-#define SKEIN_CFG_TREE_LEAF_SIZE_MSK (((u64)0xFF) << \
-					SKEIN_CFG_TREE_LEAF_SIZE_POS)
-#define SKEIN_CFG_TREE_NODE_SIZE_MSK (((u64)0xFF) << \
-					SKEIN_CFG_TREE_NODE_SIZE_POS)
-#define SKEIN_CFG_TREE_MAX_LEVEL_MSK (((u64)0xFF) << \
-					SKEIN_CFG_TREE_MAX_LEVEL_POS)
-
-#define SKEIN_CFG_TREE_INFO(leaf, node, max_lvl)                   \
-	((((u64)(leaf))   << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
-	 (((u64)(node))   << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
-	 (((u64)(max_lvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
-
-/* use as tree_info in InitExt() call for sequential processing */
-#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0)
-
-/*
-**   Skein macros for getting/setting tweak words, etc.
-**   These are useful for partial input bytes, hash tree init/update, etc.
-**/
-#define skein_get_tweak(ctx_ptr, TWK_NUM)          ((ctx_ptr)->h.tweak[TWK_NUM])
-#define skein_set_tweak(ctx_ptr, TWK_NUM, t_val) { \
-		(ctx_ptr)->h.tweak[TWK_NUM] = (t_val); \
-	}
-
-#define skein_get_T0(ctx_ptr)     skein_get_tweak(ctx_ptr, 0)
-#define skein_get_T1(ctx_ptr)     skein_get_tweak(ctx_ptr, 1)
-#define skein_set_T0(ctx_ptr, T0) skein_set_tweak(ctx_ptr, 0, T0)
-#define skein_set_T1(ctx_ptr, T1) skein_set_tweak(ctx_ptr, 1, T1)
-
-/* set both tweak words at once */
-#define skein_set_T0_T1(ctx_ptr, T0, T1)           \
-	{                                          \
-	skein_set_T0(ctx_ptr, (T0));               \
-	skein_set_T1(ctx_ptr, (T1));               \
-	}
-
-#define skein_set_type(ctx_ptr, BLK_TYPE)         \
-	skein_set_T1(ctx_ptr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
-
-/*
- * setup for starting with a new type:
- * h.tweak[0]=0; h.tweak[1] = NEW_TYPE; h.b_cnt=0;
- */
-#define skein_start_new_type(ctx_ptr, BLK_TYPE) { \
-		skein_set_T0_T1(ctx_ptr, 0, SKEIN_T1_FLAG_FIRST | \
-				SKEIN_T1_BLK_TYPE_##BLK_TYPE); \
-		(ctx_ptr)->h.b_cnt = 0; \
-	}
-
-#define skein_clear_first_flag(hdr) { \
-		(hdr).tweak[1] &= ~SKEIN_T1_FLAG_FIRST; \
-	}
-#define skein_set_bit_pad_flag(hdr) { \
-		(hdr).tweak[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
-	}
-
-#define skein_set_tree_level(hdr, height) { \
-		(hdr).tweak[1] |= SKEIN_T1_TREE_LEVEL(height); \
-	}
-
-/*****************************************************************
-** "Internal" Skein definitions for debugging and error checking
-******************************************************************/
-#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
-#include "skein_debug.h"
-#else                           /* default is no callouts */
-#define skein_show_block(bits, ctx, x, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
-#define skein_show_round(bits, ctx, r, x)
-#define skein_show_r_ptr(bits, ctx, r, x_ptr)
-#define skein_show_final(bits, ctx, cnt, out_ptr)
-#define skein_show_key(bits, ctx, key, key_bytes)
-#endif
-
-/* ignore all asserts, for performance */
-#define skein_assert_ret(x, ret_code)
-#define skein_assert(x)
-
-/*****************************************************************
-** Skein block function constants (shared across Ref and Opt code)
-******************************************************************/
-enum {
-	    /* SKEIN_256 round rotation constants */
-	R_256_0_0 = 14, R_256_0_1 = 16,
-	R_256_1_0 = 52, R_256_1_1 = 57,
-	R_256_2_0 = 23, R_256_2_1 = 40,
-	R_256_3_0 =  5, R_256_3_1 = 37,
-	R_256_4_0 = 25, R_256_4_1 = 33,
-	R_256_5_0 = 46, R_256_5_1 = 12,
-	R_256_6_0 = 58, R_256_6_1 = 22,
-	R_256_7_0 = 32, R_256_7_1 = 32,
-
-	    /* SKEIN_512 round rotation constants */
-	R_512_0_0 = 46, R_512_0_1 = 36, R_512_0_2 = 19, R_512_0_3 = 37,
-	R_512_1_0 = 33, R_512_1_1 = 27, R_512_1_2 = 14, R_512_1_3 = 42,
-	R_512_2_0 = 17, R_512_2_1 = 49, R_512_2_2 = 36, R_512_2_3 = 39,
-	R_512_3_0 = 44, R_512_3_1 =  9, R_512_3_2 = 54, R_512_3_3 = 56,
-	R_512_4_0 = 39, R_512_4_1 = 30, R_512_4_2 = 34, R_512_4_3 = 24,
-	R_512_5_0 = 13, R_512_5_1 = 50, R_512_5_2 = 10, R_512_5_3 = 17,
-	R_512_6_0 = 25, R_512_6_1 = 29, R_512_6_2 = 39, R_512_6_3 = 43,
-	R_512_7_0 =  8, R_512_7_1 = 35, R_512_7_2 = 56, R_512_7_3 = 22,
-
-	    /* SKEIN_1024 round rotation constants */
-	R1024_0_0 = 24, R1024_0_1 = 13, R1024_0_2 =  8, R1024_0_3 = 47,
-	R1024_0_4 =  8, R1024_0_5 = 17, R1024_0_6 = 22, R1024_0_7 = 37,
-	R1024_1_0 = 38, R1024_1_1 = 19, R1024_1_2 = 10, R1024_1_3 = 55,
-	R1024_1_4 = 49, R1024_1_5 = 18, R1024_1_6 = 23, R1024_1_7 = 52,
-	R1024_2_0 = 33, R1024_2_1 =  4, R1024_2_2 = 51, R1024_2_3 = 13,
-	R1024_2_4 = 34, R1024_2_5 = 41, R1024_2_6 = 59, R1024_2_7 = 17,
-	R1024_3_0 =  5, R1024_3_1 = 20, R1024_3_2 = 48, R1024_3_3 = 41,
-	R1024_3_4 = 47, R1024_3_5 = 28, R1024_3_6 = 16, R1024_3_7 = 25,
-	R1024_4_0 = 41, R1024_4_1 =  9, R1024_4_2 = 37, R1024_4_3 = 31,
-	R1024_4_4 = 12, R1024_4_5 = 47, R1024_4_6 = 44, R1024_4_7 = 30,
-	R1024_5_0 = 16, R1024_5_1 = 34, R1024_5_2 = 56, R1024_5_3 = 51,
-	R1024_5_4 =  4, R1024_5_5 = 53, R1024_5_6 = 42, R1024_5_7 = 41,
-	R1024_6_0 = 31, R1024_6_1 = 44, R1024_6_2 = 47, R1024_6_3 = 46,
-	R1024_6_4 = 19, R1024_6_5 = 42, R1024_6_6 = 44, R1024_6_7 = 25,
-	R1024_7_0 =  9, R1024_7_1 = 48, R1024_7_2 = 35, R1024_7_3 = 52,
-	R1024_7_4 = 23, R1024_7_5 = 31, R1024_7_6 = 37, R1024_7_7 = 20
-};
-
-#ifndef SKEIN_ROUNDS
-#define SKEIN_256_ROUNDS_TOTAL (72)	/* # rounds for diff block sizes */
-#define SKEIN_512_ROUNDS_TOTAL (72)
-#define SKEIN_1024_ROUNDS_TOTAL (80)
-#else			/* allow command-line define in range 8*(5..14)   */
-#define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
-#define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/10)  + 5) % 10) + 5))
-#define SKEIN_1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
-#endif
-
-#endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/skein_api.h b/drivers/staging/skein/skein_api.h
index e02fa19..171b875 100644
--- a/drivers/staging/skein/skein_api.h
+++ b/drivers/staging/skein/skein_api.h
@@ -79,7 +79,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  */
 
 #include <linux/types.h>
-#include "skein.h"
+#include "skein_base.h"
 
 /**
  * Which Skein size to use
diff --git a/drivers/staging/skein/skein_base.c b/drivers/staging/skein/skein_base.c
new file mode 100644
index 0000000..e0994ea
--- /dev/null
+++ b/drivers/staging/skein/skein_base.c
@@ -0,0 +1,884 @@
+/***********************************************************************
+**
+** Implementation of the Skein hash function.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+************************************************************************/
+
+#define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
+
+#include <linux/string.h>       /* get the memcpy/memset functions */
+#include <linux/export.h>
+#include "skein_base.h" /* get the Skein API definitions   */
+#include "skein_iv.h"    /* get precomputed IVs */
+#include "skein_block.h"
+
+/*****************************************************************/
+/*     256-bit Skein                                             */
+/*****************************************************************/
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a straight hashing operation  */
+int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
+{
+	union {
+		u8 b[SKEIN_256_STATE_BYTES];
+		u64 w[SKEIN_256_STATE_WORDS];
+	} cfg;                              /* config block */
+
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
+
+	switch (hash_bit_len) { /* use pre-computed values, where available */
+	case  256:
+		memcpy(ctx->x, SKEIN_256_IV_256, sizeof(ctx->x));
+		break;
+	case  224:
+		memcpy(ctx->x, SKEIN_256_IV_224, sizeof(ctx->x));
+		break;
+	case  160:
+		memcpy(ctx->x, SKEIN_256_IV_160, sizeof(ctx->x));
+		break;
+	case  128:
+		memcpy(ctx->x, SKEIN_256_IV_128, sizeof(ctx->x));
+		break;
+	default:
+		/* here if there is no precomputed IV value available */
+		/*
+		 * build/process the config block, type == CONFIG (could be
+		 * precomputed)
+		 */
+		/* set tweaks: T0=0; T1=CFG | FINAL */
+		skein_start_new_type(ctx, CFG_FINAL);
+
+		/* set the schema, version */
+		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
+		/* hash result length in bits */
+		cfg.w[1] = skein_swap64(hash_bit_len);
+		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+		/* zero pad config block */
+		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
+
+		/* compute the initial chaining values from config block */
+		/* zero the chaining variables */
+		memset(ctx->x, 0, sizeof(ctx->x));
+		skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+		break;
+	}
+	/* The chaining vars ctx->x are now initialized for hash_bit_len. */
+	/* Set up to process the data message portion of the hash (default) */
+	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a MAC and/or tree hash operation */
+/* [identical to skein_256_init() when key_bytes == 0 && \
+ *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes)
+{
+	union {
+		u8  b[SKEIN_256_STATE_BYTES];
+		u64 w[SKEIN_256_STATE_WORDS];
+	} cfg; /* config block */
+
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
+
+	/* compute the initial chaining values ctx->x[], based on key */
+	if (key_bytes == 0) { /* is there a key? */
+		/* no key: use all zeroes as key for config block */
+		memset(ctx->x, 0, sizeof(ctx->x));
+	} else { /* here to pre-process a key */
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
+		/* do a mini-Init right here */
+		/* set output hash bit count = state size */
+		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
+		/* set tweaks: T0 = 0; T1 = KEY type */
+		skein_start_new_type(ctx, KEY);
+		/* zero the initial chaining variables */
+		memset(ctx->x, 0, sizeof(ctx->x));
+		/* hash the key */
+		skein_256_update(ctx, key, key_bytes);
+		/* put result into cfg.b[] */
+		skein_256_final_pad(ctx, cfg.b);
+		/* copy over into ctx->x[] */
+		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
+	}
+	/*
+	 * build/process the config block, type == CONFIG (could be
+	 * precomputed for each key)
+	 */
+	/* output hash bit count */
+	ctx->h.hash_bit_len = hash_bit_len;
+	skein_start_new_type(ctx, CFG_FINAL);
+
+	/* pre-pad cfg.w[] with zeroes */
+	memset(&cfg.w, 0, sizeof(cfg.w));
+	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
+	/* hash result length in bits */
+	cfg.w[1] = skein_swap64(hash_bit_len);
+	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	cfg.w[2] = skein_swap64(tree_info);
+
+	skein_show_key(256, &ctx->h, key, key_bytes);
+
+	/* compute the initial chaining values from config block */
+	skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+
+	/* The chaining vars ctx->x are now initialized */
+	/* Set up to process the data message portion of the hash (default) */
+	skein_start_new_type(ctx, MSG);
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* process the input bytes */
+int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
+		     size_t msg_byte_cnt)
+{
+	size_t n;
+
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* process full blocks, if any */
+	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_256_BLOCK_BYTES) {
+		/* finish up any buffered message data */
+		if (ctx->h.b_cnt) {
+			/* # bytes free in buffer b[] */
+			n = SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt;
+			if (n) {
+				/* check on our logic here */
+				skein_assert(n < msg_byte_cnt);
+				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
+				msg_byte_cnt  -= n;
+				msg         += n;
+				ctx->h.b_cnt += n;
+			}
+			skein_assert(ctx->h.b_cnt == SKEIN_256_BLOCK_BYTES);
+			skein_256_process_block(ctx, ctx->b, 1,
+						SKEIN_256_BLOCK_BYTES);
+			ctx->h.b_cnt = 0;
+		}
+		/*
+		 * now process any remaining full blocks, directly from input
+		 * message data
+		 */
+		if (msg_byte_cnt > SKEIN_256_BLOCK_BYTES) {
+			/* number of full blocks to process */
+			n = (msg_byte_cnt-1) / SKEIN_256_BLOCK_BYTES;
+			skein_256_process_block(ctx, msg, n,
+						SKEIN_256_BLOCK_BYTES);
+			msg_byte_cnt -= n * SKEIN_256_BLOCK_BYTES;
+			msg        += n * SKEIN_256_BLOCK_BYTES;
+		}
+		skein_assert(ctx->h.b_cnt == 0);
+	}
+
+	/* copy any remaining source message data bytes into b[] */
+	if (msg_byte_cnt) {
+		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+			     SKEIN_256_BLOCK_BYTES);
+		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
+		ctx->h.b_cnt += msg_byte_cnt;
+	}
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the result */
+int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
+{
+	size_t i, n, byte_cnt;
+	u64 x[SKEIN_256_STATE_WORDS];
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* tag as the final block */
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt);
+
+	/* process the final block */
+	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
+
+	/* now output the result */
+	/* total number of output bytes */
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
+
+	/* run Threefish in "counter mode" to generate output */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(x, ctx->x, sizeof(x));
+	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
+		/* run "counter mode" */
+		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byte_cnt - i*SKEIN_256_BLOCK_BYTES;
+		if (n >= SKEIN_256_BLOCK_BYTES)
+			n  = SKEIN_256_BLOCK_BYTES;
+		/* "output" the ctr mode bytes */
+		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
+				      n);
+		skein_show_final(256, &ctx->h, n,
+				 hash_val+i*SKEIN_256_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->x, x, sizeof(x));
+	}
+	return SKEIN_SUCCESS;
+}
+
+/*****************************************************************/
+/*     512-bit Skein                                             */
+/*****************************************************************/
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a straight hashing operation  */
+int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
+{
+	union {
+		u8 b[SKEIN_512_STATE_BYTES];
+		u64 w[SKEIN_512_STATE_WORDS];
+	} cfg;                              /* config block */
+
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
+
+	switch (hash_bit_len) { /* use pre-computed values, where available */
+	case  512:
+		memcpy(ctx->x, SKEIN_512_IV_512, sizeof(ctx->x));
+		break;
+	case  384:
+		memcpy(ctx->x, SKEIN_512_IV_384, sizeof(ctx->x));
+		break;
+	case  256:
+		memcpy(ctx->x, SKEIN_512_IV_256, sizeof(ctx->x));
+		break;
+	case  224:
+		memcpy(ctx->x, SKEIN_512_IV_224, sizeof(ctx->x));
+		break;
+	default:
+		/* here if there is no precomputed IV value available */
+		/*
+		 * build/process the config block, type == CONFIG (could be
+		 * precomputed)
+		 */
+		/* set tweaks: T0=0; T1=CFG | FINAL */
+		skein_start_new_type(ctx, CFG_FINAL);
+
+		/* set the schema, version */
+		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
+		/* hash result length in bits */
+		cfg.w[1] = skein_swap64(hash_bit_len);
+		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+		/* zero pad config block */
+		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
+
+		/* compute the initial chaining values from config block */
+		/* zero the chaining variables */
+		memset(ctx->x, 0, sizeof(ctx->x));
+		skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+		break;
+	}
+
+	/*
+	 * The chaining vars ctx->x are now initialized for the given
+	 * hash_bit_len.
+	 */
+	/* Set up to process the data message portion of the hash (default) */
+	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a MAC and/or tree hash operation */
+/* [identical to skein_512_init() when key_bytes == 0 && \
+ *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes)
+{
+	union {
+		u8 b[SKEIN_512_STATE_BYTES];
+		u64 w[SKEIN_512_STATE_WORDS];
+	} cfg;                              /* config block */
+
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
+
+	/* compute the initial chaining values ctx->x[], based on key */
+	if (key_bytes == 0) { /* is there a key? */
+		/* no key: use all zeroes as key for config block */
+		memset(ctx->x, 0, sizeof(ctx->x));
+	} else { /* here to pre-process a key */
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
+		/* do a mini-Init right here */
+		/* set output hash bit count = state size */
+		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
+		/* set tweaks: T0 = 0; T1 = KEY type */
+		skein_start_new_type(ctx, KEY);
+		/* zero the initial chaining variables */
+		memset(ctx->x, 0, sizeof(ctx->x));
+		/* hash the key */
+		skein_512_update(ctx, key, key_bytes);
+		/* put result into cfg.b[] */
+		skein_512_final_pad(ctx, cfg.b);
+		/* copy over into ctx->x[] */
+		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
+	}
+	/*
+	 * build/process the config block, type == CONFIG (could be
+	 * precomputed for each key)
+	 */
+	ctx->h.hash_bit_len = hash_bit_len;          /* output hash bit count */
+	skein_start_new_type(ctx, CFG_FINAL);
+
+	/* pre-pad cfg.w[] with zeroes */
+	memset(&cfg.w, 0, sizeof(cfg.w));
+	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
+	/* hash result length in bits */
+	cfg.w[1] = skein_swap64(hash_bit_len);
+	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	cfg.w[2] = skein_swap64(tree_info);
+
+	skein_show_key(512, &ctx->h, key, key_bytes);
+
+	/* compute the initial chaining values from config block */
+	skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+
+	/* The chaining vars ctx->x are now initialized */
+	/* Set up to process the data message portion of the hash (default) */
+	skein_start_new_type(ctx, MSG);
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* process the input bytes */
+int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
+		     size_t msg_byte_cnt)
+{
+	size_t n;
+
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* process full blocks, if any */
+	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_512_BLOCK_BYTES) {
+		/* finish up any buffered message data */
+		if (ctx->h.b_cnt) {
+			/* # bytes free in buffer b[] */
+			n = SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt;
+			if (n) {
+				/* check on our logic here */
+				skein_assert(n < msg_byte_cnt);
+				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
+				msg_byte_cnt  -= n;
+				msg         += n;
+				ctx->h.b_cnt += n;
+			}
+			skein_assert(ctx->h.b_cnt == SKEIN_512_BLOCK_BYTES);
+			skein_512_process_block(ctx, ctx->b, 1,
+						SKEIN_512_BLOCK_BYTES);
+			ctx->h.b_cnt = 0;
+		}
+		/*
+		 * now process any remaining full blocks, directly from input
+		 * message data
+		 */
+		if (msg_byte_cnt > SKEIN_512_BLOCK_BYTES) {
+			/* number of full blocks to process */
+			n = (msg_byte_cnt-1) / SKEIN_512_BLOCK_BYTES;
+			skein_512_process_block(ctx, msg, n,
+						SKEIN_512_BLOCK_BYTES);
+			msg_byte_cnt -= n * SKEIN_512_BLOCK_BYTES;
+			msg        += n * SKEIN_512_BLOCK_BYTES;
+		}
+		skein_assert(ctx->h.b_cnt == 0);
+	}
+
+	/* copy any remaining source message data bytes into b[] */
+	if (msg_byte_cnt) {
+		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+			     SKEIN_512_BLOCK_BYTES);
+		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
+		ctx->h.b_cnt += msg_byte_cnt;
+	}
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the result */
+int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
+{
+	size_t i, n, byte_cnt;
+	u64 x[SKEIN_512_STATE_WORDS];
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* tag as the final block */
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt);
+
+	/* process the final block */
+	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
+
+	/* now output the result */
+	/* total number of output bytes */
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
+
+	/* run Threefish in "counter mode" to generate output */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(x, ctx->x, sizeof(x));
+	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
+		/* run "counter mode" */
+		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byte_cnt - i*SKEIN_512_BLOCK_BYTES;
+		if (n >= SKEIN_512_BLOCK_BYTES)
+			n  = SKEIN_512_BLOCK_BYTES;
+		/* "output" the ctr mode bytes */
+		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
+				      n);
+		skein_show_final(512, &ctx->h, n,
+				 hash_val+i*SKEIN_512_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->x, x, sizeof(x));
+	}
+	return SKEIN_SUCCESS;
+}
+
+/*****************************************************************/
+/*    1024-bit Skein                                             */
+/*****************************************************************/
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a straight hashing operation  */
+int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
+{
+	union {
+		u8 b[SKEIN_1024_STATE_BYTES];
+		u64 w[SKEIN_1024_STATE_WORDS];
+	} cfg;                              /* config block */
+
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
+
+	switch (hash_bit_len) { /* use pre-computed values, where available */
+	case  512:
+		memcpy(ctx->x, SKEIN_1024_IV_512, sizeof(ctx->x));
+		break;
+	case  384:
+		memcpy(ctx->x, SKEIN_1024_IV_384, sizeof(ctx->x));
+		break;
+	case 1024:
+		memcpy(ctx->x, SKEIN_1024_IV_1024, sizeof(ctx->x));
+		break;
+	default:
+		/* here if there is no precomputed IV value available */
+		/*
+		 * build/process the config block, type == CONFIG
+		 * (could be precomputed)
+		 */
+		/* set tweaks: T0=0; T1=CFG | FINAL */
+		skein_start_new_type(ctx, CFG_FINAL);
+
+		/* set the schema, version */
+		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
+		/* hash result length in bits */
+		cfg.w[1] = skein_swap64(hash_bit_len);
+		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+		/* zero pad config block */
+		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
+
+		/* compute the initial chaining values from config block */
+		/* zero the chaining variables */
+		memset(ctx->x, 0, sizeof(ctx->x));
+		skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+		break;
+	}
+
+	/* The chaining vars ctx->x are now initialized for the hash_bit_len. */
+	/* Set up to process the data message portion of the hash (default) */
+	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a MAC and/or tree hash operation */
+/* [identical to skein_1024_init() when key_bytes == 0 && \
+ *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
+			u64 tree_info, const u8 *key, size_t key_bytes)
+{
+	union {
+		u8 b[SKEIN_1024_STATE_BYTES];
+		u64 w[SKEIN_1024_STATE_WORDS];
+	} cfg;                              /* config block */
+
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
+
+	/* compute the initial chaining values ctx->x[], based on key */
+	if (key_bytes == 0) { /* is there a key? */
+		/* no key: use all zeroes as key for config block */
+		memset(ctx->x, 0, sizeof(ctx->x));
+	} else { /* here to pre-process a key */
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
+		/* do a mini-Init right here */
+		/* set output hash bit count = state size */
+		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
+		/* set tweaks: T0 = 0; T1 = KEY type */
+		skein_start_new_type(ctx, KEY);
+		/* zero the initial chaining variables */
+		memset(ctx->x, 0, sizeof(ctx->x));
+		/* hash the key */
+		skein_1024_update(ctx, key, key_bytes);
+		/* put result into cfg.b[] */
+		skein_1024_final_pad(ctx, cfg.b);
+		/* copy over into ctx->x[] */
+		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
+	}
+	/*
+	 * build/process the config block, type == CONFIG (could be
+	 * precomputed for each key)
+	 */
+	/* output hash bit count */
+	ctx->h.hash_bit_len = hash_bit_len;
+	skein_start_new_type(ctx, CFG_FINAL);
+
+	/* pre-pad cfg.w[] with zeroes */
+	memset(&cfg.w, 0, sizeof(cfg.w));
+	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
+	/* hash result length in bits */
+	cfg.w[1] = skein_swap64(hash_bit_len);
+	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	cfg.w[2] = skein_swap64(tree_info);
+
+	skein_show_key(1024, &ctx->h, key, key_bytes);
+
+	/* compute the initial chaining values from config block */
+	skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+
+	/* The chaining vars ctx->x are now initialized */
+	/* Set up to process the data message portion of the hash (default) */
+	skein_start_new_type(ctx, MSG);
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* process the input bytes */
+int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
+		      size_t msg_byte_cnt)
+{
+	size_t n;
+
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* process full blocks, if any */
+	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_1024_BLOCK_BYTES) {
+		/* finish up any buffered message data */
+		if (ctx->h.b_cnt) {
+			/* # bytes free in buffer b[] */
+			n = SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt;
+			if (n) {
+				/* check on our logic here */
+				skein_assert(n < msg_byte_cnt);
+				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
+				msg_byte_cnt  -= n;
+				msg         += n;
+				ctx->h.b_cnt += n;
+			}
+			skein_assert(ctx->h.b_cnt == SKEIN_1024_BLOCK_BYTES);
+			skein_1024_process_block(ctx, ctx->b, 1,
+						 SKEIN_1024_BLOCK_BYTES);
+			ctx->h.b_cnt = 0;
+		}
+		/*
+		 * now process any remaining full blocks, directly from input
+		 * message data
+		 */
+		if (msg_byte_cnt > SKEIN_1024_BLOCK_BYTES) {
+			/* number of full blocks to process */
+			n = (msg_byte_cnt-1) / SKEIN_1024_BLOCK_BYTES;
+			skein_1024_process_block(ctx, msg, n,
+						 SKEIN_1024_BLOCK_BYTES);
+			msg_byte_cnt -= n * SKEIN_1024_BLOCK_BYTES;
+			msg        += n * SKEIN_1024_BLOCK_BYTES;
+		}
+		skein_assert(ctx->h.b_cnt == 0);
+	}
+
+	/* copy any remaining source message data bytes into b[] */
+	if (msg_byte_cnt) {
+		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+			     SKEIN_1024_BLOCK_BYTES);
+		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
+		ctx->h.b_cnt += msg_byte_cnt;
+	}
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the result */
+int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
+{
+	size_t i, n, byte_cnt;
+	u64 x[SKEIN_1024_STATE_WORDS];
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* tag as the final block */
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt);
+
+	/* process the final block */
+	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
+
+	/* now output the result */
+	/* total number of output bytes */
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
+
+	/* run Threefish in "counter mode" to generate output */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(x, ctx->x, sizeof(x));
+	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
+		/* run "counter mode" */
+		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byte_cnt - i*SKEIN_1024_BLOCK_BYTES;
+		if (n >= SKEIN_1024_BLOCK_BYTES)
+			n  = SKEIN_1024_BLOCK_BYTES;
+		/* "output" the ctr mode bytes */
+		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
+				      n);
+		skein_show_final(1024, &ctx->h, n,
+				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->x, x, sizeof(x));
+	}
+	return SKEIN_SUCCESS;
+}
+
+/**************** Functions to support MAC/tree hashing ***************/
+/*   (this code is identical for Optimized and Reference versions)    */
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the block, no OUTPUT stage */
+int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
+{
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* tag as the final block */
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt);
+	/* process the final block */
+	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
+
+	/* "output" the state bytes */
+	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_256_BLOCK_BYTES);
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the block, no OUTPUT stage */
+int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
+{
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* tag as the final block */
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt);
+	/* process the final block */
+	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
+
+	/* "output" the state bytes */
+	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_512_BLOCK_BYTES);
+
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the block, no OUTPUT stage */
+int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val)
+{
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* tag as the final block */
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt);
+	/* process the final block */
+	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
+
+	/* "output" the state bytes */
+	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_1024_BLOCK_BYTES);
+
+	return SKEIN_SUCCESS;
+}
+
+#if SKEIN_TREE_HASH
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* just do the OUTPUT stage                                       */
+int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
+{
+	size_t i, n, byte_cnt;
+	u64 x[SKEIN_256_STATE_WORDS];
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* now output the result */
+	/* total number of output bytes */
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
+
+	/* run Threefish in "counter mode" to generate output */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(x, ctx->x, sizeof(x));
+	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
+		/* run "counter mode" */
+		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byte_cnt - i*SKEIN_256_BLOCK_BYTES;
+		if (n >= SKEIN_256_BLOCK_BYTES)
+			n  = SKEIN_256_BLOCK_BYTES;
+		/* "output" the ctr mode bytes */
+		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
+				      n);
+		skein_show_final(256, &ctx->h, n,
+				 hash_val+i*SKEIN_256_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->x, x, sizeof(x));
+	}
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* just do the OUTPUT stage                                       */
+int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
+{
+	size_t i, n, byte_cnt;
+	u64 x[SKEIN_512_STATE_WORDS];
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* now output the result */
+	/* total number of output bytes */
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
+
+	/* run Threefish in "counter mode" to generate output */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(x, ctx->x, sizeof(x));
+	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
+		/* run "counter mode" */
+		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byte_cnt - i*SKEIN_512_BLOCK_BYTES;
+		if (n >= SKEIN_512_BLOCK_BYTES)
+			n  = SKEIN_512_BLOCK_BYTES;
+		/* "output" the ctr mode bytes */
+		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
+				      n);
+		skein_show_final(256, &ctx->h, n,
+				 hash_val+i*SKEIN_512_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->x, x, sizeof(x));
+	}
+	return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* just do the OUTPUT stage                                       */
+int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
+{
+	size_t i, n, byte_cnt;
+	u64 x[SKEIN_1024_STATE_WORDS];
+	/* catch uninitialized context */
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
+
+	/* now output the result */
+	/* total number of output bytes */
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
+
+	/* run Threefish in "counter mode" to generate output */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(x, ctx->x, sizeof(x));
+	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
+		/* run "counter mode" */
+		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byte_cnt - i*SKEIN_1024_BLOCK_BYTES;
+		if (n >= SKEIN_1024_BLOCK_BYTES)
+			n  = SKEIN_1024_BLOCK_BYTES;
+		/* "output" the ctr mode bytes */
+		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
+				      n);
+		skein_show_final(256, &ctx->h, n,
+				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->x, x, sizeof(x));
+	}
+	return SKEIN_SUCCESS;
+}
+#endif
diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
new file mode 100644
index 0000000..9f10af9
--- /dev/null
+++ b/drivers/staging/skein/skein_base.h
@@ -0,0 +1,351 @@
+#ifndef _SKEIN_H_
+#define _SKEIN_H_     1
+/**************************************************************************
+**
+** Interface declarations and internal definitions for Skein hashing.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+***************************************************************************
+**
+** The following compile-time switches may be defined to control some
+** tradeoffs between speed, code size, error checking, and security.
+**
+** The "default" note explains what happens when the switch is not defined.
+**
+**  SKEIN_DEBUG            -- make callouts from inside Skein code
+**                            to examine/display intermediate values.
+**                            [default: no callouts (no overhead)]
+**
+**  SKEIN_ERR_CHECK        -- how error checking is handled inside Skein
+**                            code. If not defined, most error checking
+**                            is disabled (for performance). Otherwise,
+**                            the switch value is interpreted as:
+**                                0: use assert()      to flag errors
+**                                1: return SKEIN_FAIL to flag errors
+**
+***************************************************************************/
+
+/*Skein digest sizes for crypto api*/
+#define SKEIN256_DIGEST_BIT_SIZE 256
+#define SKEIN512_DIGEST_BIT_SIZE 512
+#define SKEIN1024_DIGEST_BIT_SIZE 1024
+
+#ifndef rotl_64
+#define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
+#endif
+
+/* below two prototype assume we are handed aligned data */
+#define skein_put64_lsb_first(dst08, src64, b_cnt) memcpy(dst08, src64, b_cnt)
+#define skein_get64_lsb_first(dst64, src08, w_cnt) \
+		memcpy(dst64, src08, 8*(w_cnt))
+#define skein_swap64(w64)  (w64)
+
+enum {
+	SKEIN_SUCCESS         =      0, /* return codes from Skein calls */
+	SKEIN_FAIL            =      1,
+	SKEIN_BAD_HASHLEN     =      2
+};
+
+#define  SKEIN_MODIFIER_WORDS   (2) /* number of modifier (tweak) words */
+
+#define  SKEIN_256_STATE_WORDS  (4)
+#define  SKEIN_512_STATE_WORDS  (8)
+#define  SKEIN_1024_STATE_WORDS (16)
+#define  SKEIN_MAX_STATE_WORDS (16)
+
+#define  SKEIN_256_STATE_BYTES  (8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_STATE_BYTES  (8*SKEIN_512_STATE_WORDS)
+#define  SKEIN_1024_STATE_BYTES  (8*SKEIN_1024_STATE_WORDS)
+
+#define  SKEIN_256_STATE_BITS  (64*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_STATE_BITS  (64*SKEIN_512_STATE_WORDS)
+#define  SKEIN_1024_STATE_BITS  (64*SKEIN_1024_STATE_WORDS)
+
+#define  SKEIN_256_BLOCK_BYTES  (8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_BLOCK_BYTES  (8*SKEIN_512_STATE_WORDS)
+#define  SKEIN_1024_BLOCK_BYTES  (8*SKEIN_1024_STATE_WORDS)
+
+struct skein_ctx_hdr {
+	size_t hash_bit_len;		/* size of hash result, in bits */
+	size_t b_cnt;			/* current byte count in buffer b[] */
+	u64 tweak[SKEIN_MODIFIER_WORDS]; /* tweak[0]=byte cnt, tweak[1]=flags */
+};
+
+struct skein_256_ctx { /* 256-bit Skein hash context structure */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64 x[SKEIN_256_STATE_WORDS];	/* chaining variables */
+	u8 b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+};
+
+struct skein_512_ctx { /* 512-bit Skein hash context structure */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64 x[SKEIN_512_STATE_WORDS];	/* chaining variables */
+	u8 b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+};
+
+struct skein_1024_ctx { /* 1024-bit Skein hash context structure */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64 x[SKEIN_1024_STATE_WORDS];	/* chaining variables */
+	u8 b[SKEIN_1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+};
+
+/* Skein APIs for (incremental) "straight hashing" */
+int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len);
+int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len);
+int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len);
+
+int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
+		     size_t msg_byte_cnt);
+int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
+		     size_t msg_byte_cnt);
+int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
+		      size_t msg_byte_cnt);
+
+int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val);
+int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val);
+int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val);
+
+/*
+**   Skein APIs for "extended" initialization: MAC keys, tree hashing.
+**   After an init_ext() call, just use update/final calls as with init().
+**
+**   Notes: Same parameters as _init() calls, plus tree_info/key/key_bytes.
+**          When key_bytes == 0 and tree_info == SKEIN_SEQUENTIAL,
+**              the results of init_ext() are identical to calling init().
+**          The function init() may be called once to "precompute" the IV for
+**              a given hash_bit_len value, then by saving a copy of the context
+**              the IV computation may be avoided in later calls.
+**          Similarly, the function init_ext() may be called once per MAC key
+**              to precompute the MAC IV, then a copy of the context saved and
+**              reused for each new MAC computation.
+**/
+int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes);
+int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes);
+int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
+			u64 tree_info, const u8 *key, size_t key_bytes);
+
+/*
+**   Skein APIs for MAC and tree hash:
+**      final_pad:  pad, do final block, but no OUTPUT type
+**      output:     do just the output stage
+*/
+int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val);
+int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val);
+int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val);
+
+#ifndef SKEIN_TREE_HASH
+#define SKEIN_TREE_HASH (1)
+#endif
+#if  SKEIN_TREE_HASH
+int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val);
+int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val);
+int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
+#endif
+
+/*****************************************************************
+** "Internal" Skein definitions
+**    -- not needed for sequential hashing API, but will be
+**           helpful for other uses of Skein (e.g., tree hash mode).
+**    -- included here so that they can be shared between
+**           reference and optimized code.
+******************************************************************/
+
+/* tweak word tweak[1]: bit field starting positions */
+#define SKEIN_T1_BIT(BIT)       ((BIT) - 64)      /* second word  */
+
+#define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112) /* 112..118 hash tree level */
+#define SKEIN_T1_POS_BIT_PAD    SKEIN_T1_BIT(119) /* 119 part. final in byte */
+#define SKEIN_T1_POS_BLK_TYPE   SKEIN_T1_BIT(120) /* 120..125 type field `*/
+#define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126) /* 126      first blk flag */
+#define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127) /* 127      final blk flag */
+
+/* tweak word tweak[1]: flag bit definition(s) */
+#define SKEIN_T1_FLAG_FIRST     (((u64)  1) << SKEIN_T1_POS_FIRST)
+#define SKEIN_T1_FLAG_FINAL     (((u64)  1) << SKEIN_T1_POS_FINAL)
+#define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1) << SKEIN_T1_POS_BIT_PAD)
+
+/* tweak word tweak[1]: tree level bit field mask */
+#define SKEIN_T1_TREE_LVL_MASK  (((u64)0x7F) << SKEIN_T1_POS_TREE_LVL)
+#define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
+
+/* tweak word tweak[1]: block type field */
+#define SKEIN_BLK_TYPE_KEY       (0) /* key, for MAC and KDF */
+#define SKEIN_BLK_TYPE_CFG       (4) /* configuration block */
+#define SKEIN_BLK_TYPE_PERS      (8) /* personalization string */
+#define SKEIN_BLK_TYPE_PK       (12) /* pubkey (for digital sigs) */
+#define SKEIN_BLK_TYPE_KDF      (16) /* key identifier for KDF */
+#define SKEIN_BLK_TYPE_NONCE    (20) /* nonce for PRNG */
+#define SKEIN_BLK_TYPE_MSG      (48) /* message processing */
+#define SKEIN_BLK_TYPE_OUT      (63) /* output stage */
+#define SKEIN_BLK_TYPE_MASK     (63) /* bit field mask */
+
+#define SKEIN_T1_BLK_TYPE(T)   (((u64) (SKEIN_BLK_TYPE_##T)) << \
+					SKEIN_T1_POS_BLK_TYPE)
+#define SKEIN_T1_BLK_TYPE_KEY   SKEIN_T1_BLK_TYPE(KEY)  /* for MAC and KDF */
+#define SKEIN_T1_BLK_TYPE_CFG   SKEIN_T1_BLK_TYPE(CFG)  /* config block */
+#define SKEIN_T1_BLK_TYPE_PERS  SKEIN_T1_BLK_TYPE(PERS) /* personalization */
+#define SKEIN_T1_BLK_TYPE_PK    SKEIN_T1_BLK_TYPE(PK)   /* pubkey (for sigs) */
+#define SKEIN_T1_BLK_TYPE_KDF   SKEIN_T1_BLK_TYPE(KDF)  /* key ident for KDF */
+#define SKEIN_T1_BLK_TYPE_NONCE SKEIN_T1_BLK_TYPE(NONCE)/* nonce for PRNG */
+#define SKEIN_T1_BLK_TYPE_MSG   SKEIN_T1_BLK_TYPE(MSG)  /* message processing */
+#define SKEIN_T1_BLK_TYPE_OUT   SKEIN_T1_BLK_TYPE(OUT)  /* output stage */
+#define SKEIN_T1_BLK_TYPE_MASK  SKEIN_T1_BLK_TYPE(MASK) /* field bit mask */
+
+#define SKEIN_T1_BLK_TYPE_CFG_FINAL    (SKEIN_T1_BLK_TYPE_CFG | \
+					SKEIN_T1_FLAG_FINAL)
+#define SKEIN_T1_BLK_TYPE_OUT_FINAL    (SKEIN_T1_BLK_TYPE_OUT | \
+					SKEIN_T1_FLAG_FINAL)
+
+#define SKEIN_VERSION           (1)
+
+#ifndef SKEIN_ID_STRING_LE      /* allow compile-time personalization */
+#define SKEIN_ID_STRING_LE      (0x33414853) /* "SHA3" (little-endian)*/
+#endif
+
+#define SKEIN_MK_64(hi32, lo32)  ((lo32) + (((u64) (hi32)) << 32))
+#define SKEIN_SCHEMA_VER        SKEIN_MK_64(SKEIN_VERSION, SKEIN_ID_STRING_LE)
+#define SKEIN_KS_PARITY         SKEIN_MK_64(0x1BD11BDA, 0xA9FC1A22)
+
+#define SKEIN_CFG_STR_LEN       (4*8)
+
+/* bit field definitions in config block tree_info word */
+#define SKEIN_CFG_TREE_LEAF_SIZE_POS  (0)
+#define SKEIN_CFG_TREE_NODE_SIZE_POS  (8)
+#define SKEIN_CFG_TREE_MAX_LEVEL_POS  (16)
+
+#define SKEIN_CFG_TREE_LEAF_SIZE_MSK (((u64)0xFF) << \
+					SKEIN_CFG_TREE_LEAF_SIZE_POS)
+#define SKEIN_CFG_TREE_NODE_SIZE_MSK (((u64)0xFF) << \
+					SKEIN_CFG_TREE_NODE_SIZE_POS)
+#define SKEIN_CFG_TREE_MAX_LEVEL_MSK (((u64)0xFF) << \
+					SKEIN_CFG_TREE_MAX_LEVEL_POS)
+
+#define SKEIN_CFG_TREE_INFO(leaf, node, max_lvl)                   \
+	((((u64)(leaf))   << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
+	 (((u64)(node))   << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
+	 (((u64)(max_lvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
+
+/* use as tree_info in InitExt() call for sequential processing */
+#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0)
+
+/*
+**   Skein macros for getting/setting tweak words, etc.
+**   These are useful for partial input bytes, hash tree init/update, etc.
+**/
+#define skein_get_tweak(ctx_ptr, TWK_NUM)          ((ctx_ptr)->h.tweak[TWK_NUM])
+#define skein_set_tweak(ctx_ptr, TWK_NUM, t_val) { \
+		(ctx_ptr)->h.tweak[TWK_NUM] = (t_val); \
+	}
+
+#define skein_get_T0(ctx_ptr)     skein_get_tweak(ctx_ptr, 0)
+#define skein_get_T1(ctx_ptr)     skein_get_tweak(ctx_ptr, 1)
+#define skein_set_T0(ctx_ptr, T0) skein_set_tweak(ctx_ptr, 0, T0)
+#define skein_set_T1(ctx_ptr, T1) skein_set_tweak(ctx_ptr, 1, T1)
+
+/* set both tweak words at once */
+#define skein_set_T0_T1(ctx_ptr, T0, T1)           \
+	{                                          \
+	skein_set_T0(ctx_ptr, (T0));               \
+	skein_set_T1(ctx_ptr, (T1));               \
+	}
+
+#define skein_set_type(ctx_ptr, BLK_TYPE)         \
+	skein_set_T1(ctx_ptr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
+
+/*
+ * setup for starting with a new type:
+ * h.tweak[0]=0; h.tweak[1] = NEW_TYPE; h.b_cnt=0;
+ */
+#define skein_start_new_type(ctx_ptr, BLK_TYPE) { \
+		skein_set_T0_T1(ctx_ptr, 0, SKEIN_T1_FLAG_FIRST | \
+				SKEIN_T1_BLK_TYPE_##BLK_TYPE); \
+		(ctx_ptr)->h.b_cnt = 0; \
+	}
+
+#define skein_clear_first_flag(hdr) { \
+		(hdr).tweak[1] &= ~SKEIN_T1_FLAG_FIRST; \
+	}
+#define skein_set_bit_pad_flag(hdr) { \
+		(hdr).tweak[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
+	}
+
+#define skein_set_tree_level(hdr, height) { \
+		(hdr).tweak[1] |= SKEIN_T1_TREE_LEVEL(height); \
+	}
+
+/*****************************************************************
+** "Internal" Skein definitions for debugging and error checking
+******************************************************************/
+#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
+#include "skein_debug.h"
+#else                           /* default is no callouts */
+#define skein_show_block(bits, ctx, x, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
+#define skein_show_round(bits, ctx, r, x)
+#define skein_show_r_ptr(bits, ctx, r, x_ptr)
+#define skein_show_final(bits, ctx, cnt, out_ptr)
+#define skein_show_key(bits, ctx, key, key_bytes)
+#endif
+
+/* ignore all asserts, for performance */
+#define skein_assert_ret(x, ret_code)
+#define skein_assert(x)
+
+/*****************************************************************
+** Skein block function constants (shared across Ref and Opt code)
+******************************************************************/
+enum {
+	    /* SKEIN_256 round rotation constants */
+	R_256_0_0 = 14, R_256_0_1 = 16,
+	R_256_1_0 = 52, R_256_1_1 = 57,
+	R_256_2_0 = 23, R_256_2_1 = 40,
+	R_256_3_0 =  5, R_256_3_1 = 37,
+	R_256_4_0 = 25, R_256_4_1 = 33,
+	R_256_5_0 = 46, R_256_5_1 = 12,
+	R_256_6_0 = 58, R_256_6_1 = 22,
+	R_256_7_0 = 32, R_256_7_1 = 32,
+
+	    /* SKEIN_512 round rotation constants */
+	R_512_0_0 = 46, R_512_0_1 = 36, R_512_0_2 = 19, R_512_0_3 = 37,
+	R_512_1_0 = 33, R_512_1_1 = 27, R_512_1_2 = 14, R_512_1_3 = 42,
+	R_512_2_0 = 17, R_512_2_1 = 49, R_512_2_2 = 36, R_512_2_3 = 39,
+	R_512_3_0 = 44, R_512_3_1 =  9, R_512_3_2 = 54, R_512_3_3 = 56,
+	R_512_4_0 = 39, R_512_4_1 = 30, R_512_4_2 = 34, R_512_4_3 = 24,
+	R_512_5_0 = 13, R_512_5_1 = 50, R_512_5_2 = 10, R_512_5_3 = 17,
+	R_512_6_0 = 25, R_512_6_1 = 29, R_512_6_2 = 39, R_512_6_3 = 43,
+	R_512_7_0 =  8, R_512_7_1 = 35, R_512_7_2 = 56, R_512_7_3 = 22,
+
+	    /* SKEIN_1024 round rotation constants */
+	R1024_0_0 = 24, R1024_0_1 = 13, R1024_0_2 =  8, R1024_0_3 = 47,
+	R1024_0_4 =  8, R1024_0_5 = 17, R1024_0_6 = 22, R1024_0_7 = 37,
+	R1024_1_0 = 38, R1024_1_1 = 19, R1024_1_2 = 10, R1024_1_3 = 55,
+	R1024_1_4 = 49, R1024_1_5 = 18, R1024_1_6 = 23, R1024_1_7 = 52,
+	R1024_2_0 = 33, R1024_2_1 =  4, R1024_2_2 = 51, R1024_2_3 = 13,
+	R1024_2_4 = 34, R1024_2_5 = 41, R1024_2_6 = 59, R1024_2_7 = 17,
+	R1024_3_0 =  5, R1024_3_1 = 20, R1024_3_2 = 48, R1024_3_3 = 41,
+	R1024_3_4 = 47, R1024_3_5 = 28, R1024_3_6 = 16, R1024_3_7 = 25,
+	R1024_4_0 = 41, R1024_4_1 =  9, R1024_4_2 = 37, R1024_4_3 = 31,
+	R1024_4_4 = 12, R1024_4_5 = 47, R1024_4_6 = 44, R1024_4_7 = 30,
+	R1024_5_0 = 16, R1024_5_1 = 34, R1024_5_2 = 56, R1024_5_3 = 51,
+	R1024_5_4 =  4, R1024_5_5 = 53, R1024_5_6 = 42, R1024_5_7 = 41,
+	R1024_6_0 = 31, R1024_6_1 = 44, R1024_6_2 = 47, R1024_6_3 = 46,
+	R1024_6_4 = 19, R1024_6_5 = 42, R1024_6_6 = 44, R1024_6_7 = 25,
+	R1024_7_0 =  9, R1024_7_1 = 48, R1024_7_2 = 35, R1024_7_3 = 52,
+	R1024_7_4 = 23, R1024_7_5 = 31, R1024_7_6 = 37, R1024_7_7 = 20
+};
+
+#ifndef SKEIN_ROUNDS
+#define SKEIN_256_ROUNDS_TOTAL (72)	/* # rounds for diff block sizes */
+#define SKEIN_512_ROUNDS_TOTAL (72)
+#define SKEIN_1024_ROUNDS_TOTAL (80)
+#else			/* allow command-line define in range 8*(5..14)   */
+#define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
+#define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/10)  + 5) % 10) + 5))
+#define SKEIN_1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
+#endif
+
+#endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 88bc718..36b0b40 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -15,7 +15,7 @@
 ************************************************************************/
 
 #include <linux/string.h>
-#include "skein.h"
+#include "skein_base.h"
 #include "skein_block.h"
 
 #ifndef SKEIN_USE_ASM
diff --git a/drivers/staging/skein/skein_block.h b/drivers/staging/skein/skein_block.h
index bd7bdc3..9d40f4a 100644
--- a/drivers/staging/skein/skein_block.h
+++ b/drivers/staging/skein/skein_block.h
@@ -10,7 +10,7 @@
 #ifndef _SKEIN_BLOCK_H_
 #define _SKEIN_BLOCK_H_
 
-#include "skein.h" /* get the Skein API definitions   */
+#include "skein_base.h" /* get the Skein API definitions   */
 
 void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 			     size_t blk_cnt, size_t byte_cnt_add);
diff --git a/drivers/staging/skein/skein_iv.h b/drivers/staging/skein/skein_iv.h
index d9dc1d5..8a06314 100644
--- a/drivers/staging/skein/skein_iv.h
+++ b/drivers/staging/skein/skein_iv.h
@@ -1,7 +1,7 @@
 #ifndef _SKEIN_IV_H_
 #define _SKEIN_IV_H_
 
-#include "skein.h"    /* get Skein macros and types */
+#include "skein_base.h"    /* get Skein macros and types */
 
 /*
 ***************** Pre-computed Skein IVs *******************
diff --git a/drivers/staging/skein/threefish_api.h b/drivers/staging/skein/threefish_api.h
index 8d5ddf8..8e0a0b7 100644
--- a/drivers/staging/skein/threefish_api.h
+++ b/drivers/staging/skein/threefish_api.h
@@ -29,7 +29,7 @@
  */
 
 #include <linux/types.h>
-#include "skein.h"
+#include "skein_base.h"
 
 #define KEY_SCHEDULE_CONST 0x1BD11BDAA9FC1A22L
 
-- 
2.1.1

