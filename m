Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaERSfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 14:35:04 -0400
Received: from tex.lwn.net ([70.33.254.29]:52318 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaERSe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 14:34:59 -0400
Date: Sun, 18 May 2014 12:36:10 -0600
From: Jake Edge <jake@lwn.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] staging/skein: rename files and clean up directory
 structure
Message-ID: <20140518123610.45c5469c@chukar.edge2.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Clean up file names and locations.  Get rid of include/ directory and move
those up to the top-level.  Rename files to get rid of upper case.  Remove
skeinBlockNo3F.c as it was unused (temporary file or something?).
    
Signed-off-by: Jake Edge <jake@lwn.net>
---

Against next-20140516

Diff appears to be huge because of the rearranging, not that much to it,
really ...

diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index 2bb386e..395454c 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -1,13 +1,11 @@
 #
 # Makefile for the skein secure hash algorithm
 #
-subdir-ccflags-y := -I$(src)/include/
-
 obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
-				skeinApi.o \
+				skein_api.o \
 				skein_block.o
 
-obj-$(CONFIG_CRYPTO_THREEFISH) += threefish1024Block.o \
-				  threefish256Block.o \
-				  threefish512Block.o \
-				  threefishApi.o
+obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_1024_block.o \
+				  threefish_256_block.o \
+				  threefish_512_block.o \
+				  threefish_api.o
diff --git a/drivers/staging/skein/TODO b/drivers/staging/skein/TODO
index f5c167a..1a4ce28 100644
--- a/drivers/staging/skein/TODO
+++ b/drivers/staging/skein/TODO
@@ -2,7 +2,6 @@ skein/threefish TODO
 
  - rename camelcase vars
  - rename camelcase functions
- - rename files
  - move macros into appropriate header files
  - add / pass test vectors
  - module support
diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
deleted file mode 100644
index 0a2abce..0000000
--- a/drivers/staging/skein/include/skein.h
+++ /dev/null
@@ -1,344 +0,0 @@
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
-#ifndef RotL_64
-#define RotL_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
-#endif
-
-/* below two prototype assume we are handed aligned data */
-#define Skein_Put64_LSB_First(dst08, src64, bCnt) memcpy(dst08, src64, bCnt)
-#define Skein_Get64_LSB_First(dst64, src08, wCnt) memcpy(dst64, src08, 8*(wCnt))
-#define Skein_Swap64(w64)  (w64)
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
-#define  SKEIN1024_STATE_WORDS (16)
-#define  SKEIN_MAX_STATE_WORDS (16)
-
-#define  SKEIN_256_STATE_BYTES  (8*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_STATE_BYTES  (8*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_STATE_BYTES  (8*SKEIN1024_STATE_WORDS)
-
-#define  SKEIN_256_STATE_BITS  (64*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_STATE_BITS  (64*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_STATE_BITS  (64*SKEIN1024_STATE_WORDS)
-
-#define  SKEIN_256_BLOCK_BYTES  (8*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_BLOCK_BYTES  (8*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_BLOCK_BYTES  (8*SKEIN1024_STATE_WORDS)
-
-struct skein_ctx_hdr {
-	size_t  hashBitLen;		/* size of hash result, in bits */
-	size_t  bCnt;			/* current byte count in buffer b[] */
-	u64  T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
-};
-
-struct skein_256_ctx { /* 256-bit Skein hash context structure */
-	struct skein_ctx_hdr h;		/* common header context variables */
-	u64  X[SKEIN_256_STATE_WORDS];	/* chaining variables */
-	u8  b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-};
-
-struct skein_512_ctx { /* 512-bit Skein hash context structure */
-	struct skein_ctx_hdr h;		/* common header context variables */
-	u64  X[SKEIN_512_STATE_WORDS];	/* chaining variables */
-	u8  b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-};
-
-struct skein1024_ctx { /* 1024-bit Skein hash context structure */
-	struct skein_ctx_hdr h;		/* common header context variables */
-	u64  X[SKEIN1024_STATE_WORDS];	/* chaining variables */
-	u8  b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-};
-
-/*   Skein APIs for (incremental) "straight hashing" */
-int  Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen);
-int  Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen);
-int  Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen);
-
-int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt);
-int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt);
-int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt);
-
-int  Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal);
-
-/*
-**   Skein APIs for "extended" initialization: MAC keys, tree hashing.
-**   After an InitExt() call, just use Update/Final calls as with Init().
-**
-**   Notes: Same parameters as _Init() calls, plus treeInfo/key/keyBytes.
-**          When keyBytes == 0 and treeInfo == SKEIN_SEQUENTIAL,
-**              the results of InitExt() are identical to calling Init().
-**          The function Init() may be called once to "precompute" the IV for
-**              a given hashBitLen value, then by saving a copy of the context
-**              the IV computation may be avoided in later calls.
-**          Similarly, the function InitExt() may be called once per MAC key
-**              to precompute the MAC IV, then a copy of the context saved and
-**              reused for each new MAC computation.
-**/
-int  Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes);
-
-/*
-**   Skein APIs for MAC and tree hash:
-**      Final_Pad:  pad, do final block, but no OUTPUT type
-**      Output:     do just the output stage
-*/
-int  Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal);
-
-#ifndef SKEIN_TREE_HASH
-#define SKEIN_TREE_HASH (1)
-#endif
-#if  SKEIN_TREE_HASH
-int  Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
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
-/* tweak word T[1]: bit field starting positions */
-#define SKEIN_T1_BIT(BIT)       ((BIT) - 64)      /* second word  */
-
-#define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112) /* 112..118 hash tree level */
-#define SKEIN_T1_POS_BIT_PAD    SKEIN_T1_BIT(119) /* 119 part. final in byte */
-#define SKEIN_T1_POS_BLK_TYPE   SKEIN_T1_BIT(120) /* 120..125 type field `*/
-#define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126) /* 126      first blk flag */
-#define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127) /* 127      final blk flag */
-
-/* tweak word T[1]: flag bit definition(s) */
-#define SKEIN_T1_FLAG_FIRST     (((u64)  1) << SKEIN_T1_POS_FIRST)
-#define SKEIN_T1_FLAG_FINAL     (((u64)  1) << SKEIN_T1_POS_FINAL)
-#define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1) << SKEIN_T1_POS_BIT_PAD)
-
-/* tweak word T[1]: tree level bit field mask */
-#define SKEIN_T1_TREE_LVL_MASK  (((u64)0x7F) << SKEIN_T1_POS_TREE_LVL)
-#define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
-
-/* tweak word T[1]: block type field */
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
-/* bit field definitions in config block treeInfo word */
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
-#define SKEIN_CFG_TREE_INFO(leaf, node, maxLvl)                   \
-	((((u64)(leaf))   << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
-	 (((u64)(node))   << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
-	 (((u64)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
-
-/* use as treeInfo in InitExt() call for sequential processing */
-#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0)
-
-/*
-**   Skein macros for getting/setting tweak words, etc.
-**   These are useful for partial input bytes, hash tree init/update, etc.
-**/
-#define Skein_Get_Tweak(ctxPtr, TWK_NUM)          ((ctxPtr)->h.T[TWK_NUM])
-#define Skein_Set_Tweak(ctxPtr, TWK_NUM, tVal) { \
-		(ctxPtr)->h.T[TWK_NUM] = (tVal); \
-	}
-
-#define Skein_Get_T0(ctxPtr)     Skein_Get_Tweak(ctxPtr, 0)
-#define Skein_Get_T1(ctxPtr)     Skein_Get_Tweak(ctxPtr, 1)
-#define Skein_Set_T0(ctxPtr, T0) Skein_Set_Tweak(ctxPtr, 0, T0)
-#define Skein_Set_T1(ctxPtr, T1) Skein_Set_Tweak(ctxPtr, 1, T1)
-
-/* set both tweak words at once */
-#define Skein_Set_T0_T1(ctxPtr, T0, T1)           \
-	{                                           \
-	Skein_Set_T0(ctxPtr, (T0));                  \
-	Skein_Set_T1(ctxPtr, (T1));                  \
-	}
-
-#define Skein_Set_Type(ctxPtr, BLK_TYPE)         \
-	Skein_Set_T1(ctxPtr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
-
-/*
- * setup for starting with a new type:
- * h.T[0]=0; h.T[1] = NEW_TYPE; h.bCnt=0;
- */
-#define Skein_Start_New_Type(ctxPtr, BLK_TYPE) { \
-		Skein_Set_T0_T1(ctxPtr, 0, SKEIN_T1_FLAG_FIRST | \
-				SKEIN_T1_BLK_TYPE_##BLK_TYPE); \
-		(ctxPtr)->h.bCnt = 0; \
-	}
-
-#define Skein_Clear_First_Flag(hdr) { \
-		(hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST; \
-	}
-#define Skein_Set_Bit_Pad_Flag(hdr) { \
-		(hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
-	}
-
-#define Skein_Set_Tree_Level(hdr, height) { \
-		(hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height); \
-	}
-
-/*****************************************************************
-** "Internal" Skein definitions for debugging and error checking
-******************************************************************/
-#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
-#include "skein_debug.h"
-#else                           /* default is no callouts */
-#define Skein_Show_Block(bits, ctx, X, blkPtr, wPtr, ksEvenPtr, ksOddPtr)
-#define Skein_Show_Round(bits, ctx, r, X)
-#define Skein_Show_R_Ptr(bits, ctx, r, X_ptr)
-#define Skein_Show_Final(bits, ctx, cnt, outPtr)
-#define Skein_Show_Key(bits, ctx, key, keyBytes)
-#endif
-
-#define Skein_Assert(x, retCode)/* ignore all Asserts, for performance */
-#define Skein_assert(x)
-
-/*****************************************************************
-** Skein block function constants (shared across Ref and Opt code)
-******************************************************************/
-enum {
-	    /* Skein_256 round rotation constants */
-	R_256_0_0 = 14, R_256_0_1 = 16,
-	R_256_1_0 = 52, R_256_1_1 = 57,
-	R_256_2_0 = 23, R_256_2_1 = 40,
-	R_256_3_0 =  5, R_256_3_1 = 37,
-	R_256_4_0 = 25, R_256_4_1 = 33,
-	R_256_5_0 = 46, R_256_5_1 = 12,
-	R_256_6_0 = 58, R_256_6_1 = 22,
-	R_256_7_0 = 32, R_256_7_1 = 32,
-
-	    /* Skein_512 round rotation constants */
-	R_512_0_0 = 46, R_512_0_1 = 36, R_512_0_2 = 19, R_512_0_3 = 37,
-	R_512_1_0 = 33, R_512_1_1 = 27, R_512_1_2 = 14, R_512_1_3 = 42,
-	R_512_2_0 = 17, R_512_2_1 = 49, R_512_2_2 = 36, R_512_2_3 = 39,
-	R_512_3_0 = 44, R_512_3_1 =  9, R_512_3_2 = 54, R_512_3_3 = 56,
-	R_512_4_0 = 39, R_512_4_1 = 30, R_512_4_2 = 34, R_512_4_3 = 24,
-	R_512_5_0 = 13, R_512_5_1 = 50, R_512_5_2 = 10, R_512_5_3 = 17,
-	R_512_6_0 = 25, R_512_6_1 = 29, R_512_6_2 = 39, R_512_6_3 = 43,
-	R_512_7_0 =  8, R_512_7_1 = 35, R_512_7_2 = 56, R_512_7_3 = 22,
-
-	    /* Skein1024 round rotation constants */
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
-#define SKEIN1024_ROUNDS_TOTAL (80)
-#else			/* allow command-line define in range 8*(5..14)   */
-#define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
-#define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/10)  + 5) % 10) + 5))
-#define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
-#endif
-
-#endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
deleted file mode 100644
index ace931a..0000000
--- a/drivers/staging/skein/include/skeinApi.h
+++ /dev/null
@@ -1,230 +0,0 @@
-/*
-Copyright (c) 2010 Werner Dittmann
-
-Permission is hereby granted, free of charge, to any person
-obtaining a copy of this software and associated documentation
-files (the "Software"), to deal in the Software without
-restriction, including without limitation the rights to use,
-copy, modify, merge, publish, distribute, sublicense, and/or sell
-copies of the Software, and to permit persons to whom the
-Software is furnished to do so, subject to the following
-conditions:
-
-The above copyright notice and this permission notice shall be
-included in all copies or substantial portions of the Software.
-
-THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-OTHER DEALINGS IN THE SOFTWARE.
-
-*/
-
-#ifndef SKEINAPI_H
-#define SKEINAPI_H
-
-/**
- * @file skeinApi.h
- * @brief A Skein API and its functions.
- * @{
- *
- * This API and the functions that implement this API simplify the usage
- * of Skein. The design and the way to use the functions follow the openSSL
- * design but at the same time take care of some Skein specific behaviour
- * and possibilities.
- *
- * The functions enable applications to create a normal Skein hashes and
- * message authentication codes (MAC).
- *
- * Using these functions is simple and straight forward:
- *
- * @code
- *
- * #include <skeinApi.h>
- *
- * ...
- * struct skein_ctx ctx;             // a Skein hash or MAC context
- *
- * // prepare context, here for a Skein with a state size of 512 bits.
- * skeinCtxPrepare(&ctx, Skein512);
- *
- * // Initialize the context to set the requested hash length in bits
- * // here request a output hash size of 31 bits (Skein supports variable
- * // output sizes even very strange sizes)
- * skeinInit(&ctx, 31);
- *
- * // Now update Skein with any number of message bits. A function that
- * // takes a number of bytes is also available.
- * skeinUpdateBits(&ctx, message, msgLength);
- *
- * // Now get the result of the Skein hash. The output buffer must be
- * // large enough to hold the request number of output bits. The application
- * // may now extract the bits.
- * skeinFinal(&ctx, result);
- * ...
- * @endcode
- *
- * An application may use @c skeinReset to reset a Skein context and use
- * it for creation of another hash with the same Skein state size and output
- * bit length. In this case the API implementation restores some internal
- * internal state data and saves a full Skein initialization round.
- *
- * To create a MAC the application just uses @c skeinMacInit instead of
- * @c skeinInit. All other functions calls remain the same.
- *
- */
-
-#include <linux/types.h>
-#include <skein.h>
-
-/**
- * Which Skein size to use
- */
-enum skein_size {
-	Skein256 = 256,     /*!< Skein with 256 bit state */
-	Skein512 = 512,     /*!< Skein with 512 bit state */
-	Skein1024 = 1024    /*!< Skein with 1024 bit state */
-};
-
-/**
- * Context for Skein.
- *
- * This structure was setup with some know-how of the internal
- * Skein structures, in particular ordering of header and size dependent
- * variables. If Skein implementation changes this, then adapt these
- * structures as well.
- */
-struct skein_ctx {
-	u64 skeinSize;
-	u64  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
-	union {
-		struct skein_ctx_hdr h;
-		struct skein_256_ctx s256;
-		struct skein_512_ctx s512;
-		struct skein1024_ctx s1024;
-	} m;
-};
-
-/**
- * Prepare a Skein context.
- *
- * An application must call this function before it can use the Skein
- * context. The functions clears memory and initializes size dependent
- * variables.
- *
- * @param ctx
- *     Pointer to a Skein context.
- * @param size
- *     Which Skein size to use.
- * @return
- *     SKEIN_SUCESS of SKEIN_FAIL
- */
-int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size);
-
-/**
- * Initialize a Skein context.
- *
- * Initializes the context with this data and saves the resulting Skein
- * state variables for further use.
- *
- * @param ctx
- *     Pointer to a Skein context.
- * @param hashBitLen
- *     Number of MAC hash bits to compute
- * @return
- *     SKEIN_SUCESS of SKEIN_FAIL
- * @see skeinReset
- */
-int skeinInit(struct skein_ctx *ctx, size_t hashBitLen);
-
-/**
- * Resets a Skein context for further use.
- *
- * Restores the saved chaining variables to reset the Skein context.
- * Thus applications can reuse the same setup to  process several
- * messages. This saves a complete Skein initialization cycle.
- *
- * @param ctx
- *     Pointer to a pre-initialized Skein MAC context
- */
-void skeinReset(struct skein_ctx *ctx);
-
-/**
- * Initializes a Skein context for MAC usage.
- *
- * Initializes the context with this data and saves the resulting Skein
- * state variables for further use.
- *
- * Applications call the normal Skein functions to update the MAC and
- * get the final result.
- *
- * @param ctx
- *     Pointer to an empty or preinitialized Skein MAC context
- * @param key
- *     Pointer to key bytes or NULL
- * @param keyLen
- *     Length of the key in bytes or zero
- * @param hashBitLen
- *     Number of MAC hash bits to compute
- * @return
- *     SKEIN_SUCESS of SKEIN_FAIL
- */
-int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
-		 size_t hashBitLen);
-
-/**
- * Update Skein with the next part of the message.
- *
- * @param ctx
- *     Pointer to initialized Skein context
- * @param msg
- *     Pointer to the message.
- * @param msgByteCnt
- *     Length of the message in @b bytes
- * @return
- *     Success or error code.
- */
-int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
-		size_t msgByteCnt);
-
-/**
- * Update the hash with a message bit string.
- *
- * Skein can handle data not only as bytes but also as bit strings of
- * arbitrary length (up to its maximum design size).
- *
- * @param ctx
- *     Pointer to initialized Skein context
- * @param msg
- *     Pointer to the message.
- * @param msgBitCnt
- *     Length of the message in @b bits.
- */
-int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
-		    size_t msgBitCnt);
-
-/**
- * Finalize Skein and return the hash.
- *
- * Before an application can reuse a Skein setup the application must
- * reset the Skein context.
- *
- * @param ctx
- *     Pointer to initialized Skein context
- * @param hash
- *     Pointer to buffer that receives the hash. The buffer must be large
- *     enough to store @c hashBitLen bits.
- * @return
- *     Success or error code.
- * @see skeinReset
- */
-int skeinFinal(struct skein_ctx *ctx, u8 *hash);
-
-/**
- * @}
- */
-#endif
diff --git a/drivers/staging/skein/include/skein_block.h b/drivers/staging/skein/include/skein_block.h
deleted file mode 100644
index b15c079..0000000
--- a/drivers/staging/skein/include/skein_block.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/***********************************************************************
-**
-** Implementation of the Skein hash function.
-**
-** Source code author: Doug Whiting, 2008.
-**
-** This algorithm and source code is released to the public domain.
-**
-************************************************************************/
-#ifndef _SKEIN_BLOCK_H_
-#define _SKEIN_BLOCK_H_
-
-#include <skein.h> /* get the Skein API definitions   */
-
-void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
-void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
-
-#endif
diff --git a/drivers/staging/skein/include/skein_iv.h b/drivers/staging/skein/include/skein_iv.h
deleted file mode 100644
index 8dd5e4d..0000000
--- a/drivers/staging/skein/include/skein_iv.h
+++ /dev/null
@@ -1,186 +0,0 @@
-#ifndef _SKEIN_IV_H_
-#define _SKEIN_IV_H_
-
-#include <skein.h>    /* get Skein macros and types */
-
-/*
-***************** Pre-computed Skein IVs *******************
-**
-** NOTE: these values are not "magic" constants, but
-** are generated using the Threefish block function.
-** They are pre-computed here only for speed; i.e., to
-** avoid the need for a Threefish call during Init().
-**
-** The IV for any fixed hash length may be pre-computed.
-** Only the most common values are included here.
-**
-************************************************************
-**/
-
-#define MK_64 SKEIN_MK_64
-
-/* blkSize =  256 bits. hashSize =  128 bits */
-const u64 SKEIN_256_IV_128[] = {
-	MK_64(0xE1111906, 0x964D7260),
-	MK_64(0x883DAAA7, 0x7C8D811C),
-	MK_64(0x10080DF4, 0x91960F7A),
-	MK_64(0xCCF7DDE5, 0xB45BC1C2)
-};
-
-/* blkSize =  256 bits. hashSize =  160 bits */
-const u64 SKEIN_256_IV_160[] = {
-	MK_64(0x14202314, 0x72825E98),
-	MK_64(0x2AC4E9A2, 0x5A77E590),
-	MK_64(0xD47A5856, 0x8838D63E),
-	MK_64(0x2DD2E496, 0x8586AB7D)
-};
-
-/* blkSize =  256 bits. hashSize =  224 bits */
-const u64 SKEIN_256_IV_224[] = {
-	MK_64(0xC6098A8C, 0x9AE5EA0B),
-	MK_64(0x876D5686, 0x08C5191C),
-	MK_64(0x99CB88D7, 0xD7F53884),
-	MK_64(0x384BDDB1, 0xAEDDB5DE)
-};
-
-/* blkSize =  256 bits. hashSize =  256 bits */
-const u64 SKEIN_256_IV_256[] = {
-	MK_64(0xFC9DA860, 0xD048B449),
-	MK_64(0x2FCA6647, 0x9FA7D833),
-	MK_64(0xB33BC389, 0x6656840F),
-	MK_64(0x6A54E920, 0xFDE8DA69)
-};
-
-/* blkSize =  512 bits. hashSize =  128 bits */
-const u64 SKEIN_512_IV_128[] = {
-	MK_64(0xA8BC7BF3, 0x6FBF9F52),
-	MK_64(0x1E9872CE, 0xBD1AF0AA),
-	MK_64(0x309B1790, 0xB32190D3),
-	MK_64(0xBCFBB854, 0x3F94805C),
-	MK_64(0x0DA61BCD, 0x6E31B11B),
-	MK_64(0x1A18EBEA, 0xD46A32E3),
-	MK_64(0xA2CC5B18, 0xCE84AA82),
-	MK_64(0x6982AB28, 0x9D46982D)
-};
-
-/* blkSize =  512 bits. hashSize =  160 bits */
-const u64 SKEIN_512_IV_160[] = {
-	MK_64(0x28B81A2A, 0xE013BD91),
-	MK_64(0xC2F11668, 0xB5BDF78F),
-	MK_64(0x1760D8F3, 0xF6A56F12),
-	MK_64(0x4FB74758, 0x8239904F),
-	MK_64(0x21EDE07F, 0x7EAF5056),
-	MK_64(0xD908922E, 0x63ED70B8),
-	MK_64(0xB8EC76FF, 0xECCB52FA),
-	MK_64(0x01A47BB8, 0xA3F27A6E)
-};
-
-/* blkSize =  512 bits. hashSize =  224 bits */
-const u64 SKEIN_512_IV_224[] = {
-	MK_64(0xCCD06162, 0x48677224),
-	MK_64(0xCBA65CF3, 0xA92339EF),
-	MK_64(0x8CCD69D6, 0x52FF4B64),
-	MK_64(0x398AED7B, 0x3AB890B4),
-	MK_64(0x0F59D1B1, 0x457D2BD0),
-	MK_64(0x6776FE65, 0x75D4EB3D),
-	MK_64(0x99FBC70E, 0x997413E9),
-	MK_64(0x9E2CFCCF, 0xE1C41EF7)
-};
-
-/* blkSize =  512 bits. hashSize =  256 bits */
-const u64 SKEIN_512_IV_256[] = {
-	MK_64(0xCCD044A1, 0x2FDB3E13),
-	MK_64(0xE8359030, 0x1A79A9EB),
-	MK_64(0x55AEA061, 0x4F816E6F),
-	MK_64(0x2A2767A4, 0xAE9B94DB),
-	MK_64(0xEC06025E, 0x74DD7683),
-	MK_64(0xE7A436CD, 0xC4746251),
-	MK_64(0xC36FBAF9, 0x393AD185),
-	MK_64(0x3EEDBA18, 0x33EDFC13)
-};
-
-/* blkSize =  512 bits. hashSize =  384 bits */
-const u64 SKEIN_512_IV_384[] = {
-	MK_64(0xA3F6C6BF, 0x3A75EF5F),
-	MK_64(0xB0FEF9CC, 0xFD84FAA4),
-	MK_64(0x9D77DD66, 0x3D770CFE),
-	MK_64(0xD798CBF3, 0xB468FDDA),
-	MK_64(0x1BC4A666, 0x8A0E4465),
-	MK_64(0x7ED7D434, 0xE5807407),
-	MK_64(0x548FC1AC, 0xD4EC44D6),
-	MK_64(0x266E1754, 0x6AA18FF8)
-};
-
-/* blkSize =  512 bits. hashSize =  512 bits */
-const u64 SKEIN_512_IV_512[] = {
-	MK_64(0x4903ADFF, 0x749C51CE),
-	MK_64(0x0D95DE39, 0x9746DF03),
-	MK_64(0x8FD19341, 0x27C79BCE),
-	MK_64(0x9A255629, 0xFF352CB1),
-	MK_64(0x5DB62599, 0xDF6CA7B0),
-	MK_64(0xEABE394C, 0xA9D5C3F4),
-	MK_64(0x991112C7, 0x1A75B523),
-	MK_64(0xAE18A40B, 0x660FCC33)
-};
-
-/* blkSize = 1024 bits. hashSize =  384 bits */
-const u64 SKEIN1024_IV_384[] = {
-	MK_64(0x5102B6B8, 0xC1894A35),
-	MK_64(0xFEEBC9E3, 0xFE8AF11A),
-	MK_64(0x0C807F06, 0xE32BED71),
-	MK_64(0x60C13A52, 0xB41A91F6),
-	MK_64(0x9716D35D, 0xD4917C38),
-	MK_64(0xE780DF12, 0x6FD31D3A),
-	MK_64(0x797846B6, 0xC898303A),
-	MK_64(0xB172C2A8, 0xB3572A3B),
-	MK_64(0xC9BC8203, 0xA6104A6C),
-	MK_64(0x65909338, 0xD75624F4),
-	MK_64(0x94BCC568, 0x4B3F81A0),
-	MK_64(0x3EBBF51E, 0x10ECFD46),
-	MK_64(0x2DF50F0B, 0xEEB08542),
-	MK_64(0x3B5A6530, 0x0DBC6516),
-	MK_64(0x484B9CD2, 0x167BBCE1),
-	MK_64(0x2D136947, 0xD4CBAFEA)
-};
-
-/* blkSize = 1024 bits. hashSize =  512 bits */
-const u64 SKEIN1024_IV_512[] = {
-	MK_64(0xCAEC0E5D, 0x7C1B1B18),
-	MK_64(0xA01B0E04, 0x5F03E802),
-	MK_64(0x33840451, 0xED912885),
-	MK_64(0x374AFB04, 0xEAEC2E1C),
-	MK_64(0xDF25A0E2, 0x813581F7),
-	MK_64(0xE4004093, 0x8B12F9D2),
-	MK_64(0xA662D539, 0xC2ED39B6),
-	MK_64(0xFA8B85CF, 0x45D8C75A),
-	MK_64(0x8316ED8E, 0x29EDE796),
-	MK_64(0x053289C0, 0x2E9F91B8),
-	MK_64(0xC3F8EF1D, 0x6D518B73),
-	MK_64(0xBDCEC3C4, 0xD5EF332E),
-	MK_64(0x549A7E52, 0x22974487),
-	MK_64(0x67070872, 0x5B749816),
-	MK_64(0xB9CD28FB, 0xF0581BD1),
-	MK_64(0x0E2940B8, 0x15804974)
-};
-
-/* blkSize = 1024 bits. hashSize = 1024 bits */
-const u64 SKEIN1024_IV_1024[] = {
-	MK_64(0xD593DA07, 0x41E72355),
-	MK_64(0x15B5E511, 0xAC73E00C),
-	MK_64(0x5180E5AE, 0xBAF2C4F0),
-	MK_64(0x03BD41D3, 0xFCBCAFAF),
-	MK_64(0x1CAEC6FD, 0x1983A898),
-	MK_64(0x6E510B8B, 0xCDD0589F),
-	MK_64(0x77E2BDFD, 0xC6394ADA),
-	MK_64(0xC11E1DB5, 0x24DCB0A3),
-	MK_64(0xD6D14AF9, 0xC6329AB5),
-	MK_64(0x6A9B0BFC, 0x6EB67E0D),
-	MK_64(0x9243C60D, 0xCCFF1332),
-	MK_64(0x1A1F1DDE, 0x743F02D4),
-	MK_64(0x0996753C, 0x10ED0BB8),
-	MK_64(0x6572DD22, 0xF2B4969A),
-	MK_64(0x61FD3062, 0xD00A579A),
-	MK_64(0x1DE0536E, 0x8682E539)
-};
-
-#endif /* _SKEIN_IV_H_ */
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
deleted file mode 100644
index e81675d..0000000
--- a/drivers/staging/skein/include/threefishApi.h
+++ /dev/null
@@ -1,164 +0,0 @@
-
-#ifndef THREEFISHAPI_H
-#define THREEFISHAPI_H
-
-/**
- * @file threefishApi.h
- * @brief A Threefish cipher API and its functions.
- * @{
- *
- * This API and the functions that implement this API simplify the usage
- * of the Threefish cipher. The design and the way to use the functions
- * follow the openSSL design but at the same time take care of some Threefish
- * specific behaviour and possibilities.
- *
- * These are the low level functions that deal with Threefisch blocks only.
- * Implementations for cipher modes such as ECB, CFB, or CBC may use these
- * functions.
- *
-@code
-    // Threefish cipher context data
-    struct threefish_key keyCtx;
-
-    // Initialize the context
-    threefishSetKey(&keyCtx, Threefish512, key, tweak);
-
-    // Encrypt
-    threefishEncryptBlockBytes(&keyCtx, input, cipher);
-@endcode
- */
-
-#include <linux/types.h>
-#include <skein.h>
-
-#define KeyScheduleConst 0x1BD11BDAA9FC1A22L
-
-/**
- * Which Threefish size to use
- */
-enum threefish_size {
-	Threefish256 = 256,     /*!< Skein with 256 bit state */
-	Threefish512 = 512,     /*!< Skein with 512 bit state */
-	Threefish1024 = 1024    /*!< Skein with 1024 bit state */
-};
-
-/**
- * Context for Threefish key and tweak words.
- *
- * This structure was setup with some know-how of the internal
- * Skein structures, in particular ordering of header and size dependent
- * variables. If Skein implementation changes this, the adapt these
- * structures as well.
- */
-struct threefish_key {
-	u64 stateSize;
-	u64 key[SKEIN_MAX_STATE_WORDS+1];   /* max number of key words*/
-	u64 tweak[3];
-};
-
-/**
- * Set Threefish key and tweak data.
- *
- * This function sets the key and tweak data for the Threefish cipher of
- * the given size. The key data must have the same length (number of bits)
- * as the state size
- *
- * @param keyCtx
- *     Pointer to a Threefish key structure.
- * @param size
- *     Which Skein size to use.
- * @param keyData
- *     Pointer to the key words (word has 64 bits).
- * @param tweak
- *     Pointer to the two tweak words (word has 64 bits).
- */
-void threefishSetKey(struct threefish_key *keyCtx,
-			enum threefish_size stateSize,
-			u64 *keyData, u64 *tweak);
-
-/**
- * Encrypt Threefisch block (bytes).
- *
- * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
- * of the input buffer, encrypts them and stores the result in the output
- * buffer.
- *
- * @param keyCtx
- *     Pointer to a Threefish key structure.
- * @param in
- *     Poionter to plaintext data buffer.
- * @param out
- *     Pointer to cipher buffer.
- */
-void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
-
-/**
- * Encrypt Threefisch block (words).
- *
- * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
- * of the input buffer, encrypts them and stores the result in the output
- * buffer.
- *
- * The wordsize ist set to 64 bits.
- *
- * @param keyCtx
- *     Pointer to a Threefish key structure.
- * @param in
- *     Poionter to plaintext data buffer.
- * @param out
- *     Pointer to cipher buffer.
- */
-void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out);
-
-/**
- * Decrypt Threefisch block (bytes).
- *
- * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
- * of the input buffer, decrypts them and stores the result in the output
- * buffer
- *
- * @param keyCtx
- *     Pointer to a Threefish key structure.
- * @param in
- *     Poionter to cipher data buffer.
- * @param out
- *     Pointer to plaintext buffer.
- */
-void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
-
-/**
- * Decrypt Threefisch block (words).
- *
- * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
- * of the input buffer, encrypts them and stores the result in the output
- * buffer.
- *
- * The wordsize ist set to 64 bits.
- *
- * @param keyCtx
- *     Pointer to a Threefish key structure.
- * @param in
- *     Poionter to cipher data buffer.
- * @param out
- *     Pointer to plaintext buffer.
- */
-void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out);
-
-void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input,
-			u64 *output);
-void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input,
-			u64 *output);
-/**
- * @}
- */
-#endif
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 096b86b..77cfedd 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -11,9 +11,9 @@
 #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
 
 #include <linux/string.h>       /* get the memcpy/memset functions */
-#include <skein.h> /* get the Skein API definitions   */
-#include <skein_iv.h>    /* get precomputed IVs */
-#include <skein_block.h>
+#include "skein.h" /* get the Skein API definitions   */
+#include "skein_iv.h"    /* get precomputed IVs */
+#include "skein_block.h"
 
 /*****************************************************************/
 /*     256-bit Skein                                             */
diff --git a/drivers/staging/skein/skein.h b/drivers/staging/skein/skein.h
new file mode 100644
index 0000000..0a2abce
--- /dev/null
+++ b/drivers/staging/skein/skein.h
@@ -0,0 +1,344 @@
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
+#ifndef RotL_64
+#define RotL_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
+#endif
+
+/* below two prototype assume we are handed aligned data */
+#define Skein_Put64_LSB_First(dst08, src64, bCnt) memcpy(dst08, src64, bCnt)
+#define Skein_Get64_LSB_First(dst64, src08, wCnt) memcpy(dst64, src08, 8*(wCnt))
+#define Skein_Swap64(w64)  (w64)
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
+#define  SKEIN1024_STATE_WORDS (16)
+#define  SKEIN_MAX_STATE_WORDS (16)
+
+#define  SKEIN_256_STATE_BYTES  (8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_STATE_BYTES  (8*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_STATE_BYTES  (8*SKEIN1024_STATE_WORDS)
+
+#define  SKEIN_256_STATE_BITS  (64*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_STATE_BITS  (64*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_STATE_BITS  (64*SKEIN1024_STATE_WORDS)
+
+#define  SKEIN_256_BLOCK_BYTES  (8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_BLOCK_BYTES  (8*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_BLOCK_BYTES  (8*SKEIN1024_STATE_WORDS)
+
+struct skein_ctx_hdr {
+	size_t  hashBitLen;		/* size of hash result, in bits */
+	size_t  bCnt;			/* current byte count in buffer b[] */
+	u64  T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
+};
+
+struct skein_256_ctx { /* 256-bit Skein hash context structure */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64  X[SKEIN_256_STATE_WORDS];	/* chaining variables */
+	u8  b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+};
+
+struct skein_512_ctx { /* 512-bit Skein hash context structure */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64  X[SKEIN_512_STATE_WORDS];	/* chaining variables */
+	u8  b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+};
+
+struct skein1024_ctx { /* 1024-bit Skein hash context structure */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64  X[SKEIN1024_STATE_WORDS];	/* chaining variables */
+	u8  b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+};
+
+/*   Skein APIs for (incremental) "straight hashing" */
+int  Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen);
+int  Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen);
+int  Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen);
+
+int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt);
+int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt);
+int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt);
+
+int  Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal);
+
+/*
+**   Skein APIs for "extended" initialization: MAC keys, tree hashing.
+**   After an InitExt() call, just use Update/Final calls as with Init().
+**
+**   Notes: Same parameters as _Init() calls, plus treeInfo/key/keyBytes.
+**          When keyBytes == 0 and treeInfo == SKEIN_SEQUENTIAL,
+**              the results of InitExt() are identical to calling Init().
+**          The function Init() may be called once to "precompute" the IV for
+**              a given hashBitLen value, then by saving a copy of the context
+**              the IV computation may be avoided in later calls.
+**          Similarly, the function InitExt() may be called once per MAC key
+**              to precompute the MAC IV, then a copy of the context saved and
+**              reused for each new MAC computation.
+**/
+int  Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes);
+
+/*
+**   Skein APIs for MAC and tree hash:
+**      Final_Pad:  pad, do final block, but no OUTPUT type
+**      Output:     do just the output stage
+*/
+int  Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal);
+
+#ifndef SKEIN_TREE_HASH
+#define SKEIN_TREE_HASH (1)
+#endif
+#if  SKEIN_TREE_HASH
+int  Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
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
+/* tweak word T[1]: bit field starting positions */
+#define SKEIN_T1_BIT(BIT)       ((BIT) - 64)      /* second word  */
+
+#define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112) /* 112..118 hash tree level */
+#define SKEIN_T1_POS_BIT_PAD    SKEIN_T1_BIT(119) /* 119 part. final in byte */
+#define SKEIN_T1_POS_BLK_TYPE   SKEIN_T1_BIT(120) /* 120..125 type field `*/
+#define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126) /* 126      first blk flag */
+#define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127) /* 127      final blk flag */
+
+/* tweak word T[1]: flag bit definition(s) */
+#define SKEIN_T1_FLAG_FIRST     (((u64)  1) << SKEIN_T1_POS_FIRST)
+#define SKEIN_T1_FLAG_FINAL     (((u64)  1) << SKEIN_T1_POS_FINAL)
+#define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1) << SKEIN_T1_POS_BIT_PAD)
+
+/* tweak word T[1]: tree level bit field mask */
+#define SKEIN_T1_TREE_LVL_MASK  (((u64)0x7F) << SKEIN_T1_POS_TREE_LVL)
+#define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
+
+/* tweak word T[1]: block type field */
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
+/* bit field definitions in config block treeInfo word */
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
+#define SKEIN_CFG_TREE_INFO(leaf, node, maxLvl)                   \
+	((((u64)(leaf))   << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
+	 (((u64)(node))   << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
+	 (((u64)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
+
+/* use as treeInfo in InitExt() call for sequential processing */
+#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0)
+
+/*
+**   Skein macros for getting/setting tweak words, etc.
+**   These are useful for partial input bytes, hash tree init/update, etc.
+**/
+#define Skein_Get_Tweak(ctxPtr, TWK_NUM)          ((ctxPtr)->h.T[TWK_NUM])
+#define Skein_Set_Tweak(ctxPtr, TWK_NUM, tVal) { \
+		(ctxPtr)->h.T[TWK_NUM] = (tVal); \
+	}
+
+#define Skein_Get_T0(ctxPtr)     Skein_Get_Tweak(ctxPtr, 0)
+#define Skein_Get_T1(ctxPtr)     Skein_Get_Tweak(ctxPtr, 1)
+#define Skein_Set_T0(ctxPtr, T0) Skein_Set_Tweak(ctxPtr, 0, T0)
+#define Skein_Set_T1(ctxPtr, T1) Skein_Set_Tweak(ctxPtr, 1, T1)
+
+/* set both tweak words at once */
+#define Skein_Set_T0_T1(ctxPtr, T0, T1)           \
+	{                                           \
+	Skein_Set_T0(ctxPtr, (T0));                  \
+	Skein_Set_T1(ctxPtr, (T1));                  \
+	}
+
+#define Skein_Set_Type(ctxPtr, BLK_TYPE)         \
+	Skein_Set_T1(ctxPtr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
+
+/*
+ * setup for starting with a new type:
+ * h.T[0]=0; h.T[1] = NEW_TYPE; h.bCnt=0;
+ */
+#define Skein_Start_New_Type(ctxPtr, BLK_TYPE) { \
+		Skein_Set_T0_T1(ctxPtr, 0, SKEIN_T1_FLAG_FIRST | \
+				SKEIN_T1_BLK_TYPE_##BLK_TYPE); \
+		(ctxPtr)->h.bCnt = 0; \
+	}
+
+#define Skein_Clear_First_Flag(hdr) { \
+		(hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST; \
+	}
+#define Skein_Set_Bit_Pad_Flag(hdr) { \
+		(hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
+	}
+
+#define Skein_Set_Tree_Level(hdr, height) { \
+		(hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height); \
+	}
+
+/*****************************************************************
+** "Internal" Skein definitions for debugging and error checking
+******************************************************************/
+#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
+#include "skein_debug.h"
+#else                           /* default is no callouts */
+#define Skein_Show_Block(bits, ctx, X, blkPtr, wPtr, ksEvenPtr, ksOddPtr)
+#define Skein_Show_Round(bits, ctx, r, X)
+#define Skein_Show_R_Ptr(bits, ctx, r, X_ptr)
+#define Skein_Show_Final(bits, ctx, cnt, outPtr)
+#define Skein_Show_Key(bits, ctx, key, keyBytes)
+#endif
+
+#define Skein_Assert(x, retCode)/* ignore all Asserts, for performance */
+#define Skein_assert(x)
+
+/*****************************************************************
+** Skein block function constants (shared across Ref and Opt code)
+******************************************************************/
+enum {
+	    /* Skein_256 round rotation constants */
+	R_256_0_0 = 14, R_256_0_1 = 16,
+	R_256_1_0 = 52, R_256_1_1 = 57,
+	R_256_2_0 = 23, R_256_2_1 = 40,
+	R_256_3_0 =  5, R_256_3_1 = 37,
+	R_256_4_0 = 25, R_256_4_1 = 33,
+	R_256_5_0 = 46, R_256_5_1 = 12,
+	R_256_6_0 = 58, R_256_6_1 = 22,
+	R_256_7_0 = 32, R_256_7_1 = 32,
+
+	    /* Skein_512 round rotation constants */
+	R_512_0_0 = 46, R_512_0_1 = 36, R_512_0_2 = 19, R_512_0_3 = 37,
+	R_512_1_0 = 33, R_512_1_1 = 27, R_512_1_2 = 14, R_512_1_3 = 42,
+	R_512_2_0 = 17, R_512_2_1 = 49, R_512_2_2 = 36, R_512_2_3 = 39,
+	R_512_3_0 = 44, R_512_3_1 =  9, R_512_3_2 = 54, R_512_3_3 = 56,
+	R_512_4_0 = 39, R_512_4_1 = 30, R_512_4_2 = 34, R_512_4_3 = 24,
+	R_512_5_0 = 13, R_512_5_1 = 50, R_512_5_2 = 10, R_512_5_3 = 17,
+	R_512_6_0 = 25, R_512_6_1 = 29, R_512_6_2 = 39, R_512_6_3 = 43,
+	R_512_7_0 =  8, R_512_7_1 = 35, R_512_7_2 = 56, R_512_7_3 = 22,
+
+	    /* Skein1024 round rotation constants */
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
+#define SKEIN1024_ROUNDS_TOTAL (80)
+#else			/* allow command-line define in range 8*(5..14)   */
+#define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
+#define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/10)  + 5) % 10) + 5))
+#define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
+#endif
+
+#endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
deleted file mode 100644
index dd109bf..0000000
--- a/drivers/staging/skein/skeinApi.c
+++ /dev/null
@@ -1,237 +0,0 @@
-/*
-Copyright (c) 2010 Werner Dittmann
-
-Permission is hereby granted, free of charge, to any person
-obtaining a copy of this software and associated documentation
-files (the "Software"), to deal in the Software without
-restriction, including without limitation the rights to use,
-copy, modify, merge, publish, distribute, sublicense, and/or sell
-copies of the Software, and to permit persons to whom the
-Software is furnished to do so, subject to the following
-conditions:
-
-The above copyright notice and this permission notice shall be
-included in all copies or substantial portions of the Software.
-
-THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-OTHER DEALINGS IN THE SOFTWARE.
-
-*/
-
-#include <linux/string.h>
-#include <skeinApi.h>
-
-int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size)
-{
-	Skein_Assert(ctx && size, SKEIN_FAIL);
-
-	memset(ctx , 0, sizeof(struct skein_ctx));
-	ctx->skeinSize = size;
-
-	return SKEIN_SUCCESS;
-}
-
-int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
-{
-	int ret = SKEIN_FAIL;
-	size_t Xlen = 0;
-	u64 *X = NULL;
-	u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
-
-	Skein_Assert(ctx, SKEIN_FAIL);
-	/*
-	 * The following two lines rely of the fact that the real Skein
-	 * contexts are a union in out context and thus have tha maximum
-	 * memory available.  The beauty of C :-) .
-	 */
-	X = ctx->m.s256.X;
-	Xlen = ctx->skeinSize/8;
-	/*
-	 * If size is the same and hash bit length is zero then reuse
-	 * the save chaining variables.
-	 */
-	switch (ctx->skeinSize) {
-	case Skein256:
-		ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
-					treeInfo, NULL, 0);
-		break;
-	case Skein512:
-		ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
-					treeInfo, NULL, 0);
-		break;
-	case Skein1024:
-		ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
-					treeInfo, NULL, 0);
-		break;
-	}
-
-	if (ret == SKEIN_SUCCESS) {
-		/*
-		 * Save chaining variables for this combination of size and
-		 * hashBitLen
-		 */
-		memcpy(ctx->XSave, X, Xlen);
-	}
-	return ret;
-}
-
-int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
-		size_t hashBitLen)
-{
-	int ret = SKEIN_FAIL;
-	u64 *X = NULL;
-	size_t Xlen = 0;
-	u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
-
-	Skein_Assert(ctx, SKEIN_FAIL);
-
-	X = ctx->m.s256.X;
-	Xlen = ctx->skeinSize/8;
-
-	Skein_Assert(hashBitLen, SKEIN_BAD_HASHLEN);
-
-	switch (ctx->skeinSize) {
-	case Skein256:
-		ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
-					treeInfo,
-					(const u8 *)key, keyLen);
-
-		break;
-	case Skein512:
-		ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
-					treeInfo,
-					(const u8 *)key, keyLen);
-		break;
-	case Skein1024:
-		ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
-					treeInfo,
-					(const u8 *)key, keyLen);
-
-		break;
-	}
-	if (ret == SKEIN_SUCCESS) {
-		/*
-		 * Save chaining variables for this combination of key,
-		 * keyLen, hashBitLen
-		 */
-		memcpy(ctx->XSave, X, Xlen);
-	}
-	return ret;
-}
-
-void skeinReset(struct skein_ctx *ctx)
-{
-	size_t Xlen = 0;
-	u64 *X = NULL;
-
-	/*
-	 * The following two lines rely of the fact that the real Skein
-	 * contexts are a union in out context and thus have tha maximum
-	 * memory available.  The beautiy of C :-) .
-	 */
-	X = ctx->m.s256.X;
-	Xlen = ctx->skeinSize/8;
-	/* Restore the chaing variable, reset byte counter */
-	memcpy(X, ctx->XSave, Xlen);
-
-	/* Setup context to process the message */
-	Skein_Start_New_Type(&ctx->m, MSG);
-}
-
-int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
-		size_t msgByteCnt)
-{
-	int ret = SKEIN_FAIL;
-	Skein_Assert(ctx, SKEIN_FAIL);
-
-	switch (ctx->skeinSize) {
-	case Skein256:
-		ret = Skein_256_Update(&ctx->m.s256, (const u8 *)msg,
-					msgByteCnt);
-		break;
-	case Skein512:
-		ret = Skein_512_Update(&ctx->m.s512, (const u8 *)msg,
-					msgByteCnt);
-		break;
-	case Skein1024:
-		ret = Skein1024_Update(&ctx->m.s1024, (const u8 *)msg,
-					msgByteCnt);
-		break;
-	}
-	return ret;
-
-}
-
-int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
-			size_t msgBitCnt)
-{
-	/*
-	 * I've used the bit pad implementation from skein_test.c (see NIST CD)
-	 * and modified it to use the convenience functions and added some
-	 * pointer arithmetic.
-	 */
-	size_t length;
-	u8 mask;
-	u8 *up;
-
-	/*
-	 * only the final Update() call is allowed do partial bytes, else
-	 * assert an error
-	 */
-	Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 ||
-			msgBitCnt == 0, SKEIN_FAIL);
-
-	/* if number of bits is a multiple of bytes - that's easy */
-	if ((msgBitCnt & 0x7) == 0)
-		return skeinUpdate(ctx, msg, msgBitCnt >> 3);
-
-	skeinUpdate(ctx, msg, (msgBitCnt >> 3) + 1);
-
-	/*
-	 * The next line rely on the fact that the real Skein contexts
-	 * are a union in our context. After the addition the pointer points to
-	 * Skein's real partial block buffer.
-	 * If this layout ever changes we have to adapt this as well.
-	 */
-	up = (u8 *)ctx->m.s256.X + ctx->skeinSize / 8;
-
-	/* set tweak flag for the skeinFinal call */
-	Skein_Set_Bit_Pad_Flag(ctx->m.h);
-
-	/* now "pad" the final partial byte the way NIST likes */
-	/* get the bCnt value (same location for all block sizes) */
-	length = ctx->m.h.bCnt;
-	/* internal sanity check: there IS a partial byte in the buffer! */
-	Skein_assert(length != 0);
-	/* partial byte bit mask */
-	mask = (u8) (1u << (7 - (msgBitCnt & 7)));
-	/* apply bit padding on final byte (in the buffer) */
-	up[length-1]  = (u8)((up[length-1] & (0-mask))|mask);
-
-	return SKEIN_SUCCESS;
-}
-
-int skeinFinal(struct skein_ctx *ctx, u8 *hash)
-{
-	int ret = SKEIN_FAIL;
-	Skein_Assert(ctx, SKEIN_FAIL);
-
-	switch (ctx->skeinSize) {
-	case Skein256:
-		ret = Skein_256_Final(&ctx->m.s256, (u8 *)hash);
-		break;
-	case Skein512:
-		ret = Skein_512_Final(&ctx->m.s512, (u8 *)hash);
-		break;
-	case Skein1024:
-		ret = Skein1024_Final(&ctx->m.s1024, (u8 *)hash);
-		break;
-	}
-	return ret;
-}
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
deleted file mode 100644
index 6917638..0000000
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ /dev/null
@@ -1,175 +0,0 @@
-
-#include <linux/string.h>
-#include <skein.h>
-#include <threefishApi.h>
-
-
-/*****************************  Skein_256 ******************************/
-void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
-{
-	struct threefish_key key;
-	u64 tweak[2];
-	int i;
-	u64  w[SKEIN_256_STATE_WORDS]; /* local copy of input block */
-	u64 words[3];
-
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
-	tweak[0] = ctx->h.T[0];
-	tweak[1] = ctx->h.T[1];
-
-	do  {
-		u64 carry = byteCntAdd;
-
-		words[0] = tweak[0] & 0xffffffffL;
-		words[1] = ((tweak[0] >> 32) & 0xffffffffL);
-		words[2] = (tweak[1] & 0xffffffffL);
-
-		for (i = 0; i < 3; i++) {
-			carry += words[i];
-			words[i] = carry;
-			carry >>= 32;
-		}
-		tweak[0] = words[0] & 0xffffffffL;
-		tweak[0] |= (words[1] & 0xffffffffL) << 32;
-		tweak[1] |= words[2] & 0xffffffffL;
-
-		threefishSetKey(&key, Threefish256, ctx->X, tweak);
-
-		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN_256_STATE_WORDS);
-
-		threefishEncryptBlockWords(&key, w, ctx->X);
-
-		blkPtr += SKEIN_256_BLOCK_BYTES;
-
-		/* do the final "feedforward" xor, update ctx chaining vars */
-		ctx->X[0] = ctx->X[0] ^ w[0];
-		ctx->X[1] = ctx->X[1] ^ w[1];
-		ctx->X[2] = ctx->X[2] ^ w[2];
-		ctx->X[3] = ctx->X[3] ^ w[3];
-
-		tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
-
-	ctx->h.T[0] = tweak[0];
-	ctx->h.T[1] = tweak[1];
-}
-
-void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
-{
-	struct threefish_key key;
-	u64 tweak[2];
-	int i;
-	u64 words[3];
-	u64  w[SKEIN_512_STATE_WORDS]; /* local copy of input block */
-
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
-	tweak[0] = ctx->h.T[0];
-	tweak[1] = ctx->h.T[1];
-
-	do  {
-		u64 carry = byteCntAdd;
-
-		words[0] = tweak[0] & 0xffffffffL;
-		words[1] = ((tweak[0] >> 32) & 0xffffffffL);
-		words[2] = (tweak[1] & 0xffffffffL);
-
-		for (i = 0; i < 3; i++) {
-			carry += words[i];
-			words[i] = carry;
-			carry >>= 32;
-		}
-		tweak[0] = words[0] & 0xffffffffL;
-		tweak[0] |= (words[1] & 0xffffffffL) << 32;
-		tweak[1] |= words[2] & 0xffffffffL;
-
-		threefishSetKey(&key, Threefish512, ctx->X, tweak);
-
-		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN_512_STATE_WORDS);
-
-		threefishEncryptBlockWords(&key, w, ctx->X);
-
-		blkPtr += SKEIN_512_BLOCK_BYTES;
-
-		/* do the final "feedforward" xor, update ctx chaining vars */
-		ctx->X[0] = ctx->X[0] ^ w[0];
-		ctx->X[1] = ctx->X[1] ^ w[1];
-		ctx->X[2] = ctx->X[2] ^ w[2];
-		ctx->X[3] = ctx->X[3] ^ w[3];
-		ctx->X[4] = ctx->X[4] ^ w[4];
-		ctx->X[5] = ctx->X[5] ^ w[5];
-		ctx->X[6] = ctx->X[6] ^ w[6];
-		ctx->X[7] = ctx->X[7] ^ w[7];
-
-		tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
-
-	ctx->h.T[0] = tweak[0];
-	ctx->h.T[1] = tweak[1];
-}
-
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
-{
-	struct threefish_key key;
-	u64 tweak[2];
-	int i;
-	u64 words[3];
-	u64  w[SKEIN1024_STATE_WORDS]; /* local copy of input block */
-
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
-	tweak[0] = ctx->h.T[0];
-	tweak[1] = ctx->h.T[1];
-
-	do  {
-		u64 carry = byteCntAdd;
-
-		words[0] = tweak[0] & 0xffffffffL;
-		words[1] = ((tweak[0] >> 32) & 0xffffffffL);
-		words[2] = (tweak[1] & 0xffffffffL);
-
-		for (i = 0; i < 3; i++) {
-			carry += words[i];
-			words[i] = carry;
-			carry >>= 32;
-		}
-		tweak[0] = words[0] & 0xffffffffL;
-		tweak[0] |= (words[1] & 0xffffffffL) << 32;
-		tweak[1] |= words[2] & 0xffffffffL;
-
-		threefishSetKey(&key, Threefish1024, ctx->X, tweak);
-
-		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN1024_STATE_WORDS);
-
-		threefishEncryptBlockWords(&key, w, ctx->X);
-
-		blkPtr += SKEIN1024_BLOCK_BYTES;
-
-		/* do the final "feedforward" xor, update ctx chaining vars */
-		ctx->X[0]  = ctx->X[0]  ^ w[0];
-		ctx->X[1]  = ctx->X[1]  ^ w[1];
-		ctx->X[2]  = ctx->X[2]  ^ w[2];
-		ctx->X[3]  = ctx->X[3]  ^ w[3];
-		ctx->X[4]  = ctx->X[4]  ^ w[4];
-		ctx->X[5]  = ctx->X[5]  ^ w[5];
-		ctx->X[6]  = ctx->X[6]  ^ w[6];
-		ctx->X[7]  = ctx->X[7]  ^ w[7];
-		ctx->X[8]  = ctx->X[8]  ^ w[8];
-		ctx->X[9]  = ctx->X[9]  ^ w[9];
-		ctx->X[10] = ctx->X[10] ^ w[10];
-		ctx->X[11] = ctx->X[11] ^ w[11];
-		ctx->X[12] = ctx->X[12] ^ w[12];
-		ctx->X[13] = ctx->X[13] ^ w[13];
-		ctx->X[14] = ctx->X[14] ^ w[14];
-		ctx->X[15] = ctx->X[15] ^ w[15];
-
-		tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
-
-	ctx->h.T[0] = tweak[0];
-	ctx->h.T[1] = tweak[1];
-}
diff --git a/drivers/staging/skein/skein_api.c b/drivers/staging/skein/skein_api.c
new file mode 100644
index 0000000..4256365
--- /dev/null
+++ b/drivers/staging/skein/skein_api.c
@@ -0,0 +1,237 @@
+/*
+Copyright (c) 2010 Werner Dittmann
+
+Permission is hereby granted, free of charge, to any person
+obtaining a copy of this software and associated documentation
+files (the "Software"), to deal in the Software without
+restriction, including without limitation the rights to use,
+copy, modify, merge, publish, distribute, sublicense, and/or sell
+copies of the Software, and to permit persons to whom the
+Software is furnished to do so, subject to the following
+conditions:
+
+The above copyright notice and this permission notice shall be
+included in all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+OTHER DEALINGS IN THE SOFTWARE.
+
+*/
+
+#include <linux/string.h>
+#include "skein_api.h"
+
+int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size)
+{
+	Skein_Assert(ctx && size, SKEIN_FAIL);
+
+	memset(ctx , 0, sizeof(struct skein_ctx));
+	ctx->skeinSize = size;
+
+	return SKEIN_SUCCESS;
+}
+
+int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
+{
+	int ret = SKEIN_FAIL;
+	size_t Xlen = 0;
+	u64 *X = NULL;
+	u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+
+	Skein_Assert(ctx, SKEIN_FAIL);
+	/*
+	 * The following two lines rely of the fact that the real Skein
+	 * contexts are a union in out context and thus have tha maximum
+	 * memory available.  The beauty of C :-) .
+	 */
+	X = ctx->m.s256.X;
+	Xlen = ctx->skeinSize/8;
+	/*
+	 * If size is the same and hash bit length is zero then reuse
+	 * the save chaining variables.
+	 */
+	switch (ctx->skeinSize) {
+	case Skein256:
+		ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
+					treeInfo, NULL, 0);
+		break;
+	case Skein512:
+		ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
+					treeInfo, NULL, 0);
+		break;
+	case Skein1024:
+		ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
+					treeInfo, NULL, 0);
+		break;
+	}
+
+	if (ret == SKEIN_SUCCESS) {
+		/*
+		 * Save chaining variables for this combination of size and
+		 * hashBitLen
+		 */
+		memcpy(ctx->XSave, X, Xlen);
+	}
+	return ret;
+}
+
+int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
+		size_t hashBitLen)
+{
+	int ret = SKEIN_FAIL;
+	u64 *X = NULL;
+	size_t Xlen = 0;
+	u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+
+	Skein_Assert(ctx, SKEIN_FAIL);
+
+	X = ctx->m.s256.X;
+	Xlen = ctx->skeinSize/8;
+
+	Skein_Assert(hashBitLen, SKEIN_BAD_HASHLEN);
+
+	switch (ctx->skeinSize) {
+	case Skein256:
+		ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
+					treeInfo,
+					(const u8 *)key, keyLen);
+
+		break;
+	case Skein512:
+		ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
+					treeInfo,
+					(const u8 *)key, keyLen);
+		break;
+	case Skein1024:
+		ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
+					treeInfo,
+					(const u8 *)key, keyLen);
+
+		break;
+	}
+	if (ret == SKEIN_SUCCESS) {
+		/*
+		 * Save chaining variables for this combination of key,
+		 * keyLen, hashBitLen
+		 */
+		memcpy(ctx->XSave, X, Xlen);
+	}
+	return ret;
+}
+
+void skeinReset(struct skein_ctx *ctx)
+{
+	size_t Xlen = 0;
+	u64 *X = NULL;
+
+	/*
+	 * The following two lines rely of the fact that the real Skein
+	 * contexts are a union in out context and thus have tha maximum
+	 * memory available.  The beautiy of C :-) .
+	 */
+	X = ctx->m.s256.X;
+	Xlen = ctx->skeinSize/8;
+	/* Restore the chaing variable, reset byte counter */
+	memcpy(X, ctx->XSave, Xlen);
+
+	/* Setup context to process the message */
+	Skein_Start_New_Type(&ctx->m, MSG);
+}
+
+int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
+		size_t msgByteCnt)
+{
+	int ret = SKEIN_FAIL;
+	Skein_Assert(ctx, SKEIN_FAIL);
+
+	switch (ctx->skeinSize) {
+	case Skein256:
+		ret = Skein_256_Update(&ctx->m.s256, (const u8 *)msg,
+					msgByteCnt);
+		break;
+	case Skein512:
+		ret = Skein_512_Update(&ctx->m.s512, (const u8 *)msg,
+					msgByteCnt);
+		break;
+	case Skein1024:
+		ret = Skein1024_Update(&ctx->m.s1024, (const u8 *)msg,
+					msgByteCnt);
+		break;
+	}
+	return ret;
+
+}
+
+int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
+			size_t msgBitCnt)
+{
+	/*
+	 * I've used the bit pad implementation from skein_test.c (see NIST CD)
+	 * and modified it to use the convenience functions and added some
+	 * pointer arithmetic.
+	 */
+	size_t length;
+	u8 mask;
+	u8 *up;
+
+	/*
+	 * only the final Update() call is allowed do partial bytes, else
+	 * assert an error
+	 */
+	Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 ||
+			msgBitCnt == 0, SKEIN_FAIL);
+
+	/* if number of bits is a multiple of bytes - that's easy */
+	if ((msgBitCnt & 0x7) == 0)
+		return skeinUpdate(ctx, msg, msgBitCnt >> 3);
+
+	skeinUpdate(ctx, msg, (msgBitCnt >> 3) + 1);
+
+	/*
+	 * The next line rely on the fact that the real Skein contexts
+	 * are a union in our context. After the addition the pointer points to
+	 * Skein's real partial block buffer.
+	 * If this layout ever changes we have to adapt this as well.
+	 */
+	up = (u8 *)ctx->m.s256.X + ctx->skeinSize / 8;
+
+	/* set tweak flag for the skeinFinal call */
+	Skein_Set_Bit_Pad_Flag(ctx->m.h);
+
+	/* now "pad" the final partial byte the way NIST likes */
+	/* get the bCnt value (same location for all block sizes) */
+	length = ctx->m.h.bCnt;
+	/* internal sanity check: there IS a partial byte in the buffer! */
+	Skein_assert(length != 0);
+	/* partial byte bit mask */
+	mask = (u8) (1u << (7 - (msgBitCnt & 7)));
+	/* apply bit padding on final byte (in the buffer) */
+	up[length-1]  = (u8)((up[length-1] & (0-mask))|mask);
+
+	return SKEIN_SUCCESS;
+}
+
+int skeinFinal(struct skein_ctx *ctx, u8 *hash)
+{
+	int ret = SKEIN_FAIL;
+	Skein_Assert(ctx, SKEIN_FAIL);
+
+	switch (ctx->skeinSize) {
+	case Skein256:
+		ret = Skein_256_Final(&ctx->m.s256, (u8 *)hash);
+		break;
+	case Skein512:
+		ret = Skein_512_Final(&ctx->m.s512, (u8 *)hash);
+		break;
+	case Skein1024:
+		ret = Skein1024_Final(&ctx->m.s1024, (u8 *)hash);
+		break;
+	}
+	return ret;
+}
diff --git a/drivers/staging/skein/skein_api.h b/drivers/staging/skein/skein_api.h
new file mode 100644
index 0000000..4029b16
--- /dev/null
+++ b/drivers/staging/skein/skein_api.h
@@ -0,0 +1,230 @@
+/*
+Copyright (c) 2010 Werner Dittmann
+
+Permission is hereby granted, free of charge, to any person
+obtaining a copy of this software and associated documentation
+files (the "Software"), to deal in the Software without
+restriction, including without limitation the rights to use,
+copy, modify, merge, publish, distribute, sublicense, and/or sell
+copies of the Software, and to permit persons to whom the
+Software is furnished to do so, subject to the following
+conditions:
+
+The above copyright notice and this permission notice shall be
+included in all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+OTHER DEALINGS IN THE SOFTWARE.
+
+*/
+
+#ifndef SKEINAPI_H
+#define SKEINAPI_H
+
+/**
+ * @file skeinApi.h
+ * @brief A Skein API and its functions.
+ * @{
+ *
+ * This API and the functions that implement this API simplify the usage
+ * of Skein. The design and the way to use the functions follow the openSSL
+ * design but at the same time take care of some Skein specific behaviour
+ * and possibilities.
+ *
+ * The functions enable applications to create a normal Skein hashes and
+ * message authentication codes (MAC).
+ *
+ * Using these functions is simple and straight forward:
+ *
+ * @code
+ *
+ * #include <skeinApi.h>
+ *
+ * ...
+ * struct skein_ctx ctx;             // a Skein hash or MAC context
+ *
+ * // prepare context, here for a Skein with a state size of 512 bits.
+ * skeinCtxPrepare(&ctx, Skein512);
+ *
+ * // Initialize the context to set the requested hash length in bits
+ * // here request a output hash size of 31 bits (Skein supports variable
+ * // output sizes even very strange sizes)
+ * skeinInit(&ctx, 31);
+ *
+ * // Now update Skein with any number of message bits. A function that
+ * // takes a number of bytes is also available.
+ * skeinUpdateBits(&ctx, message, msgLength);
+ *
+ * // Now get the result of the Skein hash. The output buffer must be
+ * // large enough to hold the request number of output bits. The application
+ * // may now extract the bits.
+ * skeinFinal(&ctx, result);
+ * ...
+ * @endcode
+ *
+ * An application may use @c skeinReset to reset a Skein context and use
+ * it for creation of another hash with the same Skein state size and output
+ * bit length. In this case the API implementation restores some internal
+ * internal state data and saves a full Skein initialization round.
+ *
+ * To create a MAC the application just uses @c skeinMacInit instead of
+ * @c skeinInit. All other functions calls remain the same.
+ *
+ */
+
+#include <linux/types.h>
+#include "skein.h"
+
+/**
+ * Which Skein size to use
+ */
+enum skein_size {
+	Skein256 = 256,     /*!< Skein with 256 bit state */
+	Skein512 = 512,     /*!< Skein with 512 bit state */
+	Skein1024 = 1024    /*!< Skein with 1024 bit state */
+};
+
+/**
+ * Context for Skein.
+ *
+ * This structure was setup with some know-how of the internal
+ * Skein structures, in particular ordering of header and size dependent
+ * variables. If Skein implementation changes this, then adapt these
+ * structures as well.
+ */
+struct skein_ctx {
+	u64 skeinSize;
+	u64  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
+	union {
+		struct skein_ctx_hdr h;
+		struct skein_256_ctx s256;
+		struct skein_512_ctx s512;
+		struct skein1024_ctx s1024;
+	} m;
+};
+
+/**
+ * Prepare a Skein context.
+ *
+ * An application must call this function before it can use the Skein
+ * context. The functions clears memory and initializes size dependent
+ * variables.
+ *
+ * @param ctx
+ *     Pointer to a Skein context.
+ * @param size
+ *     Which Skein size to use.
+ * @return
+ *     SKEIN_SUCESS of SKEIN_FAIL
+ */
+int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size);
+
+/**
+ * Initialize a Skein context.
+ *
+ * Initializes the context with this data and saves the resulting Skein
+ * state variables for further use.
+ *
+ * @param ctx
+ *     Pointer to a Skein context.
+ * @param hashBitLen
+ *     Number of MAC hash bits to compute
+ * @return
+ *     SKEIN_SUCESS of SKEIN_FAIL
+ * @see skeinReset
+ */
+int skeinInit(struct skein_ctx *ctx, size_t hashBitLen);
+
+/**
+ * Resets a Skein context for further use.
+ *
+ * Restores the saved chaining variables to reset the Skein context.
+ * Thus applications can reuse the same setup to  process several
+ * messages. This saves a complete Skein initialization cycle.
+ *
+ * @param ctx
+ *     Pointer to a pre-initialized Skein MAC context
+ */
+void skeinReset(struct skein_ctx *ctx);
+
+/**
+ * Initializes a Skein context for MAC usage.
+ *
+ * Initializes the context with this data and saves the resulting Skein
+ * state variables for further use.
+ *
+ * Applications call the normal Skein functions to update the MAC and
+ * get the final result.
+ *
+ * @param ctx
+ *     Pointer to an empty or preinitialized Skein MAC context
+ * @param key
+ *     Pointer to key bytes or NULL
+ * @param keyLen
+ *     Length of the key in bytes or zero
+ * @param hashBitLen
+ *     Number of MAC hash bits to compute
+ * @return
+ *     SKEIN_SUCESS of SKEIN_FAIL
+ */
+int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
+		 size_t hashBitLen);
+
+/**
+ * Update Skein with the next part of the message.
+ *
+ * @param ctx
+ *     Pointer to initialized Skein context
+ * @param msg
+ *     Pointer to the message.
+ * @param msgByteCnt
+ *     Length of the message in @b bytes
+ * @return
+ *     Success or error code.
+ */
+int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
+		size_t msgByteCnt);
+
+/**
+ * Update the hash with a message bit string.
+ *
+ * Skein can handle data not only as bytes but also as bit strings of
+ * arbitrary length (up to its maximum design size).
+ *
+ * @param ctx
+ *     Pointer to initialized Skein context
+ * @param msg
+ *     Pointer to the message.
+ * @param msgBitCnt
+ *     Length of the message in @b bits.
+ */
+int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
+		    size_t msgBitCnt);
+
+/**
+ * Finalize Skein and return the hash.
+ *
+ * Before an application can reuse a Skein setup the application must
+ * reset the Skein context.
+ *
+ * @param ctx
+ *     Pointer to initialized Skein context
+ * @param hash
+ *     Pointer to buffer that receives the hash. The buffer must be large
+ *     enough to store @c hashBitLen bits.
+ * @return
+ *     Success or error code.
+ * @see skeinReset
+ */
+int skeinFinal(struct skein_ctx *ctx, u8 *hash);
+
+/**
+ * @}
+ */
+#endif
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index fd96ca0..7d653a6 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -15,7 +15,7 @@
 ************************************************************************/
 
 #include <linux/string.h>
-#include <skein.h>
+#include "skein.h"
 
 #ifndef SKEIN_USE_ASM
 #define SKEIN_USE_ASM   (0) /* default is all C code (no ASM) */
diff --git a/drivers/staging/skein/skein_block.h b/drivers/staging/skein/skein_block.h
new file mode 100644
index 0000000..b81e968
--- /dev/null
+++ b/drivers/staging/skein/skein_block.h
@@ -0,0 +1,22 @@
+/***********************************************************************
+**
+** Implementation of the Skein hash function.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+************************************************************************/
+#ifndef _SKEIN_BLOCK_H_
+#define _SKEIN_BLOCK_H_
+
+#include "skein.h" /* get the Skein API definitions   */
+
+void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+
+#endif
diff --git a/drivers/staging/skein/skein_iv.h b/drivers/staging/skein/skein_iv.h
new file mode 100644
index 0000000..80d6bce
--- /dev/null
+++ b/drivers/staging/skein/skein_iv.h
@@ -0,0 +1,186 @@
+#ifndef _SKEIN_IV_H_
+#define _SKEIN_IV_H_
+
+#include "skein.h"    /* get Skein macros and types */
+
+/*
+***************** Pre-computed Skein IVs *******************
+**
+** NOTE: these values are not "magic" constants, but
+** are generated using the Threefish block function.
+** They are pre-computed here only for speed; i.e., to
+** avoid the need for a Threefish call during Init().
+**
+** The IV for any fixed hash length may be pre-computed.
+** Only the most common values are included here.
+**
+************************************************************
+**/
+
+#define MK_64 SKEIN_MK_64
+
+/* blkSize =  256 bits. hashSize =  128 bits */
+const u64 SKEIN_256_IV_128[] = {
+	MK_64(0xE1111906, 0x964D7260),
+	MK_64(0x883DAAA7, 0x7C8D811C),
+	MK_64(0x10080DF4, 0x91960F7A),
+	MK_64(0xCCF7DDE5, 0xB45BC1C2)
+};
+
+/* blkSize =  256 bits. hashSize =  160 bits */
+const u64 SKEIN_256_IV_160[] = {
+	MK_64(0x14202314, 0x72825E98),
+	MK_64(0x2AC4E9A2, 0x5A77E590),
+	MK_64(0xD47A5856, 0x8838D63E),
+	MK_64(0x2DD2E496, 0x8586AB7D)
+};
+
+/* blkSize =  256 bits. hashSize =  224 bits */
+const u64 SKEIN_256_IV_224[] = {
+	MK_64(0xC6098A8C, 0x9AE5EA0B),
+	MK_64(0x876D5686, 0x08C5191C),
+	MK_64(0x99CB88D7, 0xD7F53884),
+	MK_64(0x384BDDB1, 0xAEDDB5DE)
+};
+
+/* blkSize =  256 bits. hashSize =  256 bits */
+const u64 SKEIN_256_IV_256[] = {
+	MK_64(0xFC9DA860, 0xD048B449),
+	MK_64(0x2FCA6647, 0x9FA7D833),
+	MK_64(0xB33BC389, 0x6656840F),
+	MK_64(0x6A54E920, 0xFDE8DA69)
+};
+
+/* blkSize =  512 bits. hashSize =  128 bits */
+const u64 SKEIN_512_IV_128[] = {
+	MK_64(0xA8BC7BF3, 0x6FBF9F52),
+	MK_64(0x1E9872CE, 0xBD1AF0AA),
+	MK_64(0x309B1790, 0xB32190D3),
+	MK_64(0xBCFBB854, 0x3F94805C),
+	MK_64(0x0DA61BCD, 0x6E31B11B),
+	MK_64(0x1A18EBEA, 0xD46A32E3),
+	MK_64(0xA2CC5B18, 0xCE84AA82),
+	MK_64(0x6982AB28, 0x9D46982D)
+};
+
+/* blkSize =  512 bits. hashSize =  160 bits */
+const u64 SKEIN_512_IV_160[] = {
+	MK_64(0x28B81A2A, 0xE013BD91),
+	MK_64(0xC2F11668, 0xB5BDF78F),
+	MK_64(0x1760D8F3, 0xF6A56F12),
+	MK_64(0x4FB74758, 0x8239904F),
+	MK_64(0x21EDE07F, 0x7EAF5056),
+	MK_64(0xD908922E, 0x63ED70B8),
+	MK_64(0xB8EC76FF, 0xECCB52FA),
+	MK_64(0x01A47BB8, 0xA3F27A6E)
+};
+
+/* blkSize =  512 bits. hashSize =  224 bits */
+const u64 SKEIN_512_IV_224[] = {
+	MK_64(0xCCD06162, 0x48677224),
+	MK_64(0xCBA65CF3, 0xA92339EF),
+	MK_64(0x8CCD69D6, 0x52FF4B64),
+	MK_64(0x398AED7B, 0x3AB890B4),
+	MK_64(0x0F59D1B1, 0x457D2BD0),
+	MK_64(0x6776FE65, 0x75D4EB3D),
+	MK_64(0x99FBC70E, 0x997413E9),
+	MK_64(0x9E2CFCCF, 0xE1C41EF7)
+};
+
+/* blkSize =  512 bits. hashSize =  256 bits */
+const u64 SKEIN_512_IV_256[] = {
+	MK_64(0xCCD044A1, 0x2FDB3E13),
+	MK_64(0xE8359030, 0x1A79A9EB),
+	MK_64(0x55AEA061, 0x4F816E6F),
+	MK_64(0x2A2767A4, 0xAE9B94DB),
+	MK_64(0xEC06025E, 0x74DD7683),
+	MK_64(0xE7A436CD, 0xC4746251),
+	MK_64(0xC36FBAF9, 0x393AD185),
+	MK_64(0x3EEDBA18, 0x33EDFC13)
+};
+
+/* blkSize =  512 bits. hashSize =  384 bits */
+const u64 SKEIN_512_IV_384[] = {
+	MK_64(0xA3F6C6BF, 0x3A75EF5F),
+	MK_64(0xB0FEF9CC, 0xFD84FAA4),
+	MK_64(0x9D77DD66, 0x3D770CFE),
+	MK_64(0xD798CBF3, 0xB468FDDA),
+	MK_64(0x1BC4A666, 0x8A0E4465),
+	MK_64(0x7ED7D434, 0xE5807407),
+	MK_64(0x548FC1AC, 0xD4EC44D6),
+	MK_64(0x266E1754, 0x6AA18FF8)
+};
+
+/* blkSize =  512 bits. hashSize =  512 bits */
+const u64 SKEIN_512_IV_512[] = {
+	MK_64(0x4903ADFF, 0x749C51CE),
+	MK_64(0x0D95DE39, 0x9746DF03),
+	MK_64(0x8FD19341, 0x27C79BCE),
+	MK_64(0x9A255629, 0xFF352CB1),
+	MK_64(0x5DB62599, 0xDF6CA7B0),
+	MK_64(0xEABE394C, 0xA9D5C3F4),
+	MK_64(0x991112C7, 0x1A75B523),
+	MK_64(0xAE18A40B, 0x660FCC33)
+};
+
+/* blkSize = 1024 bits. hashSize =  384 bits */
+const u64 SKEIN1024_IV_384[] = {
+	MK_64(0x5102B6B8, 0xC1894A35),
+	MK_64(0xFEEBC9E3, 0xFE8AF11A),
+	MK_64(0x0C807F06, 0xE32BED71),
+	MK_64(0x60C13A52, 0xB41A91F6),
+	MK_64(0x9716D35D, 0xD4917C38),
+	MK_64(0xE780DF12, 0x6FD31D3A),
+	MK_64(0x797846B6, 0xC898303A),
+	MK_64(0xB172C2A8, 0xB3572A3B),
+	MK_64(0xC9BC8203, 0xA6104A6C),
+	MK_64(0x65909338, 0xD75624F4),
+	MK_64(0x94BCC568, 0x4B3F81A0),
+	MK_64(0x3EBBF51E, 0x10ECFD46),
+	MK_64(0x2DF50F0B, 0xEEB08542),
+	MK_64(0x3B5A6530, 0x0DBC6516),
+	MK_64(0x484B9CD2, 0x167BBCE1),
+	MK_64(0x2D136947, 0xD4CBAFEA)
+};
+
+/* blkSize = 1024 bits. hashSize =  512 bits */
+const u64 SKEIN1024_IV_512[] = {
+	MK_64(0xCAEC0E5D, 0x7C1B1B18),
+	MK_64(0xA01B0E04, 0x5F03E802),
+	MK_64(0x33840451, 0xED912885),
+	MK_64(0x374AFB04, 0xEAEC2E1C),
+	MK_64(0xDF25A0E2, 0x813581F7),
+	MK_64(0xE4004093, 0x8B12F9D2),
+	MK_64(0xA662D539, 0xC2ED39B6),
+	MK_64(0xFA8B85CF, 0x45D8C75A),
+	MK_64(0x8316ED8E, 0x29EDE796),
+	MK_64(0x053289C0, 0x2E9F91B8),
+	MK_64(0xC3F8EF1D, 0x6D518B73),
+	MK_64(0xBDCEC3C4, 0xD5EF332E),
+	MK_64(0x549A7E52, 0x22974487),
+	MK_64(0x67070872, 0x5B749816),
+	MK_64(0xB9CD28FB, 0xF0581BD1),
+	MK_64(0x0E2940B8, 0x15804974)
+};
+
+/* blkSize = 1024 bits. hashSize = 1024 bits */
+const u64 SKEIN1024_IV_1024[] = {
+	MK_64(0xD593DA07, 0x41E72355),
+	MK_64(0x15B5E511, 0xAC73E00C),
+	MK_64(0x5180E5AE, 0xBAF2C4F0),
+	MK_64(0x03BD41D3, 0xFCBCAFAF),
+	MK_64(0x1CAEC6FD, 0x1983A898),
+	MK_64(0x6E510B8B, 0xCDD0589F),
+	MK_64(0x77E2BDFD, 0xC6394ADA),
+	MK_64(0xC11E1DB5, 0x24DCB0A3),
+	MK_64(0xD6D14AF9, 0xC6329AB5),
+	MK_64(0x6A9B0BFC, 0x6EB67E0D),
+	MK_64(0x9243C60D, 0xCCFF1332),
+	MK_64(0x1A1F1DDE, 0x743F02D4),
+	MK_64(0x0996753C, 0x10ED0BB8),
+	MK_64(0x6572DD22, 0xF2B4969A),
+	MK_64(0x61FD3062, 0xD00A579A),
+	MK_64(0x1DE0536E, 0x8682E539)
+};
+
+#endif /* _SKEIN_IV_H_ */
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
deleted file mode 100644
index fe7517b..0000000
--- a/drivers/staging/skein/threefish1024Block.c
+++ /dev/null
@@ -1,4900 +0,0 @@
-#include <linux/string.h>
-#include <threefishApi.h>
-
-
-void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7],
-	  b8 = input[8], b9 = input[9],
-	  b10 = input[10], b11 = input[11],
-	  b12 = input[12], b13 = input[13],
-	  b14 = input[14], b15 = input[15];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
-	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
-	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
-	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
-	  k16 = keyCtx->key[16];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
-
-	b1 += k1;
-	b0 += b1 + k0;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k3;
-	b2 += b3 + k2;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k5;
-	b4 += b5 + k4;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k7;
-	b6 += b7 + k6;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k9;
-	b8 += b9 + k8;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k11;
-	b10 += b11 + k10;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k13 + t0;
-	b12 += b13 + k12;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k15;
-	b14 += b15 + k14 + t1;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k2;
-	b0 += b1 + k1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k4;
-	b2 += b3 + k3;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k6;
-	b4 += b5 + k5;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k8;
-	b6 += b7 + k7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k10;
-	b8 += b9 + k9;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k12;
-	b10 += b11 + k11;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k14 + t1;
-	b12 += b13 + k13;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k16 + 1;
-	b14 += b15 + k15 + t2;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k3;
-	b0 += b1 + k2;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k5;
-	b2 += b3 + k4;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k7;
-	b4 += b5 + k6;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k9;
-	b6 += b7 + k8;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k11;
-	b8 += b9 + k10;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k13;
-	b10 += b11 + k12;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k15 + t2;
-	b12 += b13 + k14;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k0 + 2;
-	b14 += b15 + k16 + t0;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k4;
-	b0 += b1 + k3;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k6;
-	b2 += b3 + k5;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k8;
-	b4 += b5 + k7;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k10;
-	b6 += b7 + k9;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k12;
-	b8 += b9 + k11;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k14;
-	b10 += b11 + k13;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k16 + t0;
-	b12 += b13 + k15;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k1 + 3;
-	b14 += b15 + k0 + t1;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k5;
-	b0 += b1 + k4;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k7;
-	b2 += b3 + k6;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k9;
-	b4 += b5 + k8;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k11;
-	b6 += b7 + k10;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k13;
-	b8 += b9 + k12;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k15;
-	b10 += b11 + k14;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k0 + t1;
-	b12 += b13 + k16;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k2 + 4;
-	b14 += b15 + k1 + t2;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k6;
-	b0 += b1 + k5;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k8;
-	b2 += b3 + k7;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k10;
-	b4 += b5 + k9;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k12;
-	b6 += b7 + k11;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k14;
-	b8 += b9 + k13;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k16;
-	b10 += b11 + k15;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k1 + t2;
-	b12 += b13 + k0;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k3 + 5;
-	b14 += b15 + k2 + t0;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k7;
-	b0 += b1 + k6;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k9;
-	b2 += b3 + k8;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k11;
-	b4 += b5 + k10;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k13;
-	b6 += b7 + k12;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k15;
-	b8 += b9 + k14;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k0;
-	b10 += b11 + k16;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k2 + t0;
-	b12 += b13 + k1;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k4 + 6;
-	b14 += b15 + k3 + t1;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k8;
-	b0 += b1 + k7;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k10;
-	b2 += b3 + k9;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k12;
-	b4 += b5 + k11;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k14;
-	b6 += b7 + k13;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k16;
-	b8 += b9 + k15;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k1;
-	b10 += b11 + k0;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k3 + t1;
-	b12 += b13 + k2;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k5 + 7;
-	b14 += b15 + k4 + t2;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k9;
-	b0 += b1 + k8;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k11;
-	b2 += b3 + k10;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k13;
-	b4 += b5 + k12;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k15;
-	b6 += b7 + k14;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k0;
-	b8 += b9 + k16;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k2;
-	b10 += b11 + k1;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k4 + t2;
-	b12 += b13 + k3;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k6 + 8;
-	b14 += b15 + k5 + t0;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k10;
-	b0 += b1 + k9;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k12;
-	b2 += b3 + k11;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k14;
-	b4 += b5 + k13;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k16;
-	b6 += b7 + k15;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k1;
-	b8 += b9 + k0;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k3;
-	b10 += b11 + k2;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k5 + t0;
-	b12 += b13 + k4;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k7 + 9;
-	b14 += b15 + k6 + t1;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k11;
-	b0 += b1 + k10;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k13;
-	b2 += b3 + k12;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k15;
-	b4 += b5 + k14;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k0;
-	b6 += b7 + k16;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k2;
-	b8 += b9 + k1;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k4;
-	b10 += b11 + k3;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k6 + t1;
-	b12 += b13 + k5;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k8 + 10;
-	b14 += b15 + k7 + t2;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k12;
-	b0 += b1 + k11;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k14;
-	b2 += b3 + k13;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k16;
-	b4 += b5 + k15;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k1;
-	b6 += b7 + k0;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k3;
-	b8 += b9 + k2;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k5;
-	b10 += b11 + k4;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k7 + t2;
-	b12 += b13 + k6;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k9 + 11;
-	b14 += b15 + k8 + t0;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k13;
-	b0 += b1 + k12;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k15;
-	b2 += b3 + k14;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k0;
-	b4 += b5 + k16;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k2;
-	b6 += b7 + k1;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k4;
-	b8 += b9 + k3;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k6;
-	b10 += b11 + k5;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k8 + t0;
-	b12 += b13 + k7;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k10 + 12;
-	b14 += b15 + k9 + t1;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k14;
-	b0 += b1 + k13;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k16;
-	b2 += b3 + k15;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k1;
-	b4 += b5 + k0;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k3;
-	b6 += b7 + k2;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k5;
-	b8 += b9 + k4;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k7;
-	b10 += b11 + k6;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k9 + t1;
-	b12 += b13 + k8;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k11 + 13;
-	b14 += b15 + k10 + t2;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k15;
-	b0 += b1 + k14;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k0;
-	b2 += b3 + k16;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k2;
-	b4 += b5 + k1;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k4;
-	b6 += b7 + k3;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k6;
-	b8 += b9 + k5;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k8;
-	b10 += b11 + k7;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k10 + t2;
-	b12 += b13 + k9;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k12 + 14;
-	b14 += b15 + k11 + t0;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k16;
-	b0 += b1 + k15;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k1;
-	b2 += b3 + k0;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k3;
-	b4 += b5 + k2;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k5;
-	b6 += b7 + k4;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k7;
-	b8 += b9 + k6;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k9;
-	b10 += b11 + k8;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k11 + t0;
-	b12 += b13 + k10;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k13 + 15;
-	b14 += b15 + k12 + t1;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k0;
-	b0 += b1 + k16;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k2;
-	b2 += b3 + k1;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k4;
-	b4 += b5 + k3;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k6;
-	b6 += b7 + k5;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k8;
-	b8 += b9 + k7;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k10;
-	b10 += b11 + k9;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k12 + t1;
-	b12 += b13 + k11;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k14 + 16;
-	b14 += b15 + k13 + t2;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k1;
-	b0 += b1 + k0;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k3;
-	b2 += b3 + k2;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k5;
-	b4 += b5 + k4;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k7;
-	b6 += b7 + k6;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k9;
-	b8 += b9 + k8;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k11;
-	b10 += b11 + k10;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k13 + t2;
-	b12 += b13 + k12;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k15 + 17;
-	b14 += b15 + k14 + t0;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	b1 += k2;
-	b0 += b1 + k1;
-	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-
-	b3 += k4;
-	b2 += b3 + k3;
-	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-
-	b5 += k6;
-	b4 += b5 + k5;
-	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-
-	b7 += k8;
-	b6 += b7 + k7;
-	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-
-	b9 += k10;
-	b8 += b9 + k9;
-	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-
-	b11 += k12;
-	b10 += b11 + k11;
-	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-
-	b13 += k14 + t0;
-	b12 += b13 + k13;
-	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-
-	b15 += k16 + 18;
-	b14 += b15 + k15 + t1;
-	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-
-	b1 += k3;
-	b0 += b1 + k2;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-
-	b3 += k5;
-	b2 += b3 + k4;
-	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-
-	b5 += k7;
-	b4 += b5 + k6;
-	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-
-	b7 += k9;
-	b6 += b7 + k8;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-
-	b9 += k11;
-	b8 += b9 + k10;
-	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-
-	b11 += k13;
-	b10 += b11 + k12;
-	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-
-	b13 += k15 + t1;
-	b12 += b13 + k14;
-	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-
-	b15 += k0 + 19;
-	b14 += b15 + k16 + t2;
-	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-
-	b0 += b9;
-	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-
-	b2 += b13;
-	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-
-	b6 += b11;
-	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-
-	b4 += b15;
-	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-
-	b10 += b7;
-	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-
-	b12 += b3;
-	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-
-	b14 += b5;
-	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-
-	b8 += b1;
-	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-
-	b0 += b7;
-	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-
-	b6 += b1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-
-	b12 += b15;
-	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-
-	b14 += b13;
-	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-
-	b8 += b11;
-	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-
-	b10 += b9;
-	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-
-	b0 += b15;
-	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-
-	b2 += b11;
-	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-
-	b6 += b13;
-	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-
-	b4 += b9;
-	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-
-	b14 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-
-	b8 += b5;
-	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-
-	b10 += b3;
-	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-
-	b12 += b7;
-	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-
-	output[0] = b0 + k3;
-	output[1] = b1 + k4;
-	output[2] = b2 + k5;
-	output[3] = b3 + k6;
-	output[4] = b4 + k7;
-	output[5] = b5 + k8;
-	output[6] = b6 + k9;
-	output[7] = b7 + k10;
-	output[8] = b8 + k11;
-	output[9] = b9 + k12;
-	output[10] = b10 + k13;
-	output[11] = b11 + k14;
-	output[12] = b12 + k15;
-	output[13] = b13 + k16 + t2;
-	output[14] = b14 + k0 + t0;
-	output[15] = b15 + k1 + 20;
-}
-
-void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7],
-	  b8 = input[8], b9 = input[9],
-	  b10 = input[10], b11 = input[11],
-	  b12 = input[12], b13 = input[13],
-	  b14 = input[14], b15 = input[15];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
-	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
-	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
-	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
-	  k16 = keyCtx->key[16];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
-	u64 tmp;
-
-	b0 -= k3;
-	b1 -= k4;
-	b2 -= k5;
-	b3 -= k6;
-	b4 -= k7;
-	b5 -= k8;
-	b6 -= k9;
-	b7 -= k10;
-	b8 -= k11;
-	b9 -= k12;
-	b10 -= k13;
-	b11 -= k14;
-	b12 -= k15;
-	b13 -= k16 + t2;
-	b14 -= k0 + t0;
-	b15 -= k1 + 20;
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k16 + t2;
-	b15 -= k0 + 19;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k14;
-	b13 -= k15 + t1;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k12;
-	b11 -= k13;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k10;
-	b9 -= k11;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k8;
-	b7 -= k9;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k6;
-	b5 -= k7;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k4;
-	b3 -= k5;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k2;
-	b1 -= k3;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k15 + t1;
-	b15 -= k16 + 18;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k13;
-	b13 -= k14 + t0;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k11;
-	b11 -= k12;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k9;
-	b9 -= k10;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k7;
-	b7 -= k8;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k5;
-	b5 -= k6;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k3;
-	b3 -= k4;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k1;
-	b1 -= k2;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k14 + t0;
-	b15 -= k15 + 17;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k12;
-	b13 -= k13 + t2;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k10;
-	b11 -= k11;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k8;
-	b9 -= k9;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k6;
-	b7 -= k7;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k4;
-	b5 -= k5;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k2;
-	b3 -= k3;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k0;
-	b1 -= k1;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k13 + t2;
-	b15 -= k14 + 16;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k11;
-	b13 -= k12 + t1;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k9;
-	b11 -= k10;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k7;
-	b9 -= k8;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k5;
-	b7 -= k6;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k3;
-	b5 -= k4;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k1;
-	b3 -= k2;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k16;
-	b1 -= k0;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k12 + t1;
-	b15 -= k13 + 15;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k10;
-	b13 -= k11 + t0;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k8;
-	b11 -= k9;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k6;
-	b9 -= k7;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k4;
-	b7 -= k5;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k2;
-	b5 -= k3;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k0;
-	b3 -= k1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k15;
-	b1 -= k16;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k11 + t0;
-	b15 -= k12 + 14;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k9;
-	b13 -= k10 + t2;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k7;
-	b11 -= k8;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k5;
-	b9 -= k6;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k3;
-	b7 -= k4;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k1;
-	b5 -= k2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k16;
-	b3 -= k0;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k14;
-	b1 -= k15;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k10 + t2;
-	b15 -= k11 + 13;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k8;
-	b13 -= k9 + t1;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k6;
-	b11 -= k7;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k4;
-	b9 -= k5;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k2;
-	b7 -= k3;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k0;
-	b5 -= k1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k15;
-	b3 -= k16;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k13;
-	b1 -= k14;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k9 + t1;
-	b15 -= k10 + 12;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k7;
-	b13 -= k8 + t0;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k5;
-	b11 -= k6;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k3;
-	b9 -= k4;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k1;
-	b7 -= k2;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k16;
-	b5 -= k0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k14;
-	b3 -= k15;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k12;
-	b1 -= k13;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k8 + t0;
-	b15 -= k9 + 11;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k6;
-	b13 -= k7 + t2;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k4;
-	b11 -= k5;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k2;
-	b9 -= k3;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k0;
-	b7 -= k1;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k15;
-	b5 -= k16;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k13;
-	b3 -= k14;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k11;
-	b1 -= k12;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k7 + t2;
-	b15 -= k8 + 10;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k5;
-	b13 -= k6 + t1;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k3;
-	b11 -= k4;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k1;
-	b9 -= k2;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k16;
-	b7 -= k0;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k14;
-	b5 -= k15;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k12;
-	b3 -= k13;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k10;
-	b1 -= k11;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k6 + t1;
-	b15 -= k7 + 9;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k4;
-	b13 -= k5 + t0;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k2;
-	b11 -= k3;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k0;
-	b9 -= k1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k15;
-	b7 -= k16;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k13;
-	b5 -= k14;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k11;
-	b3 -= k12;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k9;
-	b1 -= k10;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k5 + t0;
-	b15 -= k6 + 8;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k3;
-	b13 -= k4 + t2;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k1;
-	b11 -= k2;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k16;
-	b9 -= k0;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k14;
-	b7 -= k15;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k12;
-	b5 -= k13;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k10;
-	b3 -= k11;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k8;
-	b1 -= k9;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k4 + t2;
-	b15 -= k5 + 7;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k2;
-	b13 -= k3 + t1;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k0;
-	b11 -= k1;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k15;
-	b9 -= k16;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k13;
-	b7 -= k14;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k11;
-	b5 -= k12;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k9;
-	b3 -= k10;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k7;
-	b1 -= k8;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k3 + t1;
-	b15 -= k4 + 6;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k1;
-	b13 -= k2 + t0;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k16;
-	b11 -= k0;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k14;
-	b9 -= k15;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k12;
-	b7 -= k13;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k10;
-	b5 -= k11;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k8;
-	b3 -= k9;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k6;
-	b1 -= k7;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k2 + t0;
-	b15 -= k3 + 5;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k0;
-	b13 -= k1 + t2;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k15;
-	b11 -= k16;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k13;
-	b9 -= k14;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k11;
-	b7 -= k12;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k9;
-	b5 -= k10;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k7;
-	b3 -= k8;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k5;
-	b1 -= k6;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k1 + t2;
-	b15 -= k2 + 4;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k16;
-	b13 -= k0 + t1;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k14;
-	b11 -= k15;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k12;
-	b9 -= k13;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k10;
-	b7 -= k11;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k8;
-	b5 -= k9;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k6;
-	b3 -= k7;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k4;
-	b1 -= k5;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k0 + t1;
-	b15 -= k1 + 3;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k15;
-	b13 -= k16 + t0;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k13;
-	b11 -= k14;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k11;
-	b9 -= k12;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k9;
-	b7 -= k10;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k7;
-	b5 -= k8;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k5;
-	b3 -= k6;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k3;
-	b1 -= k4;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k16 + t0;
-	b15 -= k0 + 2;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k14;
-	b13 -= k15 + t2;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k12;
-	b11 -= k13;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k10;
-	b9 -= k11;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k8;
-	b7 -= k9;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k6;
-	b5 -= k7;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k4;
-	b3 -= k5;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k2;
-	b1 -= k3;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 20) | (tmp << (64 - 20));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 37) | (tmp << (64 - 37));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 31) | (tmp << (64 - 31));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 52) | (tmp << (64 - 52));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 35) | (tmp << (64 - 35));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 48) | (tmp << (64 - 48));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 25) | (tmp << (64 - 25));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 44) | (tmp << (64 - 44));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 19) | (tmp << (64 - 19));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 47) | (tmp << (64 - 47));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 44) | (tmp << (64 - 44));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 42) | (tmp << (64 - 42));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 53) | (tmp << (64 - 53));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 4) | (tmp << (64 - 4));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 56) | (tmp << (64 - 56));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 34) | (tmp << (64 - 34));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 16) | (tmp << (64 - 16));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 30) | (tmp << (64 - 30));
-	b14 -= b15 + k15 + t2;
-	b15 -= k16 + 1;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 44) | (tmp << (64 - 44));
-	b12 -= b13 + k13;
-	b13 -= k14 + t1;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 47) | (tmp << (64 - 47));
-	b10 -= b11 + k11;
-	b11 -= k12;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 12) | (tmp << (64 - 12));
-	b8 -= b9 + k9;
-	b9 -= k10;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 31) | (tmp << (64 - 31));
-	b6 -= b7 + k7;
-	b7 -= k8;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 37) | (tmp << (64 - 37));
-	b4 -= b5 + k5;
-	b5 -= k6;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 9) | (tmp << (64 - 9));
-	b2 -= b3 + k3;
-	b3 -= k4;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 41) | (tmp << (64 - 41));
-	b0 -= b1 + k1;
-	b1 -= k2;
-
-	tmp = b7 ^ b12;
-	b7 = (tmp >> 25) | (tmp << (64 - 25));
-	b12 -= b7;
-
-	tmp = b3 ^ b10;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b10 -= b3;
-
-	tmp = b5 ^ b8;
-	b5 = (tmp >> 28) | (tmp << (64 - 28));
-	b8 -= b5;
-
-	tmp = b1 ^ b14;
-	b1 = (tmp >> 47) | (tmp << (64 - 47));
-	b14 -= b1;
-
-	tmp = b9 ^ b4;
-	b9 = (tmp >> 41) | (tmp << (64 - 41));
-	b4 -= b9;
-
-	tmp = b13 ^ b6;
-	b13 = (tmp >> 48) | (tmp << (64 - 48));
-	b6 -= b13;
-
-	tmp = b11 ^ b2;
-	b11 = (tmp >> 20) | (tmp << (64 - 20));
-	b2 -= b11;
-
-	tmp = b15 ^ b0;
-	b15 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b15;
-
-	tmp = b9 ^ b10;
-	b9 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b9;
-
-	tmp = b11 ^ b8;
-	b11 = (tmp >> 59) | (tmp << (64 - 59));
-	b8 -= b11;
-
-	tmp = b13 ^ b14;
-	b13 = (tmp >> 41) | (tmp << (64 - 41));
-	b14 -= b13;
-
-	tmp = b15 ^ b12;
-	b15 = (tmp >> 34) | (tmp << (64 - 34));
-	b12 -= b15;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b6 -= b1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 51) | (tmp << (64 - 51));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 4) | (tmp << (64 - 4));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 33) | (tmp << (64 - 33));
-	b0 -= b7;
-
-	tmp = b1 ^ b8;
-	b1 = (tmp >> 52) | (tmp << (64 - 52));
-	b8 -= b1;
-
-	tmp = b5 ^ b14;
-	b5 = (tmp >> 23) | (tmp << (64 - 23));
-	b14 -= b5;
-
-	tmp = b3 ^ b12;
-	b3 = (tmp >> 18) | (tmp << (64 - 18));
-	b12 -= b3;
-
-	tmp = b7 ^ b10;
-	b7 = (tmp >> 49) | (tmp << (64 - 49));
-	b10 -= b7;
-
-	tmp = b15 ^ b4;
-	b15 = (tmp >> 55) | (tmp << (64 - 55));
-	b4 -= b15;
-
-	tmp = b11 ^ b6;
-	b11 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b11;
-
-	tmp = b13 ^ b2;
-	b13 = (tmp >> 19) | (tmp << (64 - 19));
-	b2 -= b13;
-
-	tmp = b9 ^ b0;
-	b9 = (tmp >> 38) | (tmp << (64 - 38));
-	b0 -= b9;
-
-	tmp = b15 ^ b14;
-	b15 = (tmp >> 37) | (tmp << (64 - 37));
-	b14 -= b15 + k14 + t1;
-	b15 -= k15;
-
-	tmp = b13 ^ b12;
-	b13 = (tmp >> 22) | (tmp << (64 - 22));
-	b12 -= b13 + k12;
-	b13 -= k13 + t0;
-
-	tmp = b11 ^ b10;
-	b11 = (tmp >> 17) | (tmp << (64 - 17));
-	b10 -= b11 + k10;
-	b11 -= k11;
-
-	tmp = b9 ^ b8;
-	b9 = (tmp >> 8) | (tmp << (64 - 8));
-	b8 -= b9 + k8;
-	b9 -= k9;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 47) | (tmp << (64 - 47));
-	b6 -= b7 + k6;
-	b7 -= k7;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 8) | (tmp << (64 - 8));
-	b4 -= b5 + k4;
-	b5 -= k5;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b3 + k2;
-	b3 -= k3;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 24) | (tmp << (64 - 24));
-	b0 -= b1 + k0;
-	b1 -= k1;
-
-	output[15] = b15;
-	output[14] = b14;
-	output[13] = b13;
-	output[12] = b12;
-	output[11] = b11;
-	output[10] = b10;
-	output[9] = b9;
-	output[8] = b8;
-	output[7] = b7;
-	output[6] = b6;
-	output[5] = b5;
-	output[4] = b4;
-	output[3] = b3;
-	output[2] = b2;
-	output[1] = b1;
-	output[0] = b0;
-}
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
deleted file mode 100644
index 2ae746a..0000000
--- a/drivers/staging/skein/threefish256Block.c
+++ /dev/null
@@ -1,1137 +0,0 @@
-#include <linux/string.h>
-#include <threefishApi.h>
-
-
-void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
-
-	b1 += k1 + t0;
-	b0 += b1 + k0;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k3;
-	b2 += b3 + k2 + t1;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k2 + t1;
-	b0 += b1 + k1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k4 + 1;
-	b2 += b3 + k3 + t2;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k3 + t2;
-	b0 += b1 + k2;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k0 + 2;
-	b2 += b3 + k4 + t0;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k4 + t0;
-	b0 += b1 + k3;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k1 + 3;
-	b2 += b3 + k0 + t1;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k0 + t1;
-	b0 += b1 + k4;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k2 + 4;
-	b2 += b3 + k1 + t2;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k1 + t2;
-	b0 += b1 + k0;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k3 + 5;
-	b2 += b3 + k2 + t0;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k2 + t0;
-	b0 += b1 + k1;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k4 + 6;
-	b2 += b3 + k3 + t1;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k3 + t1;
-	b0 += b1 + k2;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k0 + 7;
-	b2 += b3 + k4 + t2;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k4 + t2;
-	b0 += b1 + k3;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k1 + 8;
-	b2 += b3 + k0 + t0;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k0 + t0;
-	b0 += b1 + k4;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k2 + 9;
-	b2 += b3 + k1 + t1;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k1 + t1;
-	b0 += b1 + k0;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k3 + 10;
-	b2 += b3 + k2 + t2;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k2 + t2;
-	b0 += b1 + k1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k4 + 11;
-	b2 += b3 + k3 + t0;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k3 + t0;
-	b0 += b1 + k2;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k0 + 12;
-	b2 += b3 + k4 + t1;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k4 + t1;
-	b0 += b1 + k3;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k1 + 13;
-	b2 += b3 + k0 + t2;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k0 + t2;
-	b0 += b1 + k4;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k2 + 14;
-	b2 += b3 + k1 + t0;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k1 + t0;
-	b0 += b1 + k0;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k3 + 15;
-	b2 += b3 + k2 + t1;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-
-	b1 += k2 + t1;
-	b0 += b1 + k1;
-	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-
-	b3 += k4 + 16;
-	b2 += b3 + k3 + t2;
-	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-
-	b1 += k3 + t2;
-	b0 += b1 + k2;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-
-	b3 += k0 + 17;
-	b2 += b3 + k4 + t0;
-	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-
-	b0 += b1;
-	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-
-	b2 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-
-	b0 += b3;
-	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-
-	b2 += b1;
-	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	output[0] = b0 + k3;
-	output[1] = b1 + k4 + t0;
-	output[2] = b2 + k0 + t1;
-	output[3] = b3 + k1 + 18;
-}
-
-void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
-
-	u64 tmp;
-
-	b0 -= k3;
-	b1 -= k4 + t0;
-	b2 -= k0 + t1;
-	b3 -= k1 + 18;
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k2;
-	b1 -= k3 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k4 + t0;
-	b3 -= k0 + 17;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k1;
-	b1 -= k2 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k3 + t2;
-	b3 -= k4 + 16;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k0;
-	b1 -= k1 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k2 + t1;
-	b3 -= k3 + 15;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k4;
-	b1 -= k0 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k1 + t0;
-	b3 -= k2 + 14;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k3;
-	b1 -= k4 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k0 + t2;
-	b3 -= k1 + 13;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k2;
-	b1 -= k3 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k4 + t1;
-	b3 -= k0 + 12;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k1;
-	b1 -= k2 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k3 + t0;
-	b3 -= k4 + 11;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k0;
-	b1 -= k1 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k2 + t2;
-	b3 -= k3 + 10;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k4;
-	b1 -= k0 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k1 + t1;
-	b3 -= k2 + 9;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k3;
-	b1 -= k4 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k0 + t0;
-	b3 -= k1 + 8;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k2;
-	b1 -= k3 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k4 + t2;
-	b3 -= k0 + 7;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k1;
-	b1 -= k2 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k3 + t1;
-	b3 -= k4 + 6;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k0;
-	b1 -= k1 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k2 + t0;
-	b3 -= k3 + 5;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k4;
-	b1 -= k0 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k1 + t2;
-	b3 -= k2 + 4;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k3;
-	b1 -= k4 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k0 + t1;
-	b3 -= k1 + 3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k2;
-	b1 -= k3 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k4 + t0;
-	b3 -= k0 + 2;
-
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 32) | (tmp << (64 - 32));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 32) | (tmp << (64 - 32));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 58) | (tmp << (64 - 58));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 12) | (tmp << (64 - 12));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b0 -= b1 + k1;
-	b1 -= k2 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b3 + k3 + t2;
-	b3 -= k4 + 1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 5) | (tmp << (64 - 5));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 37) | (tmp << (64 - 37));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 23) | (tmp << (64 - 23));
-	b0 -= b1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 40) | (tmp << (64 - 40));
-	b2 -= b3;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 52) | (tmp << (64 - 52));
-	b0 -= b3;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 57) | (tmp << (64 - 57));
-	b2 -= b1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 14) | (tmp << (64 - 14));
-	b0 -= b1 + k0;
-	b1 -= k1 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 16) | (tmp << (64 - 16));
-	b2 -= b3 + k2 + t1;
-	b3 -= k3;
-
-	output[0] = b0;
-	output[1] = b1;
-	output[2] = b2;
-	output[3] = b3;
-}
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
deleted file mode 100644
index f428fd6..0000000
--- a/drivers/staging/skein/threefish512Block.c
+++ /dev/null
@@ -1,2223 +0,0 @@
-#include <linux/string.h>
-#include <threefishApi.h>
-
-
-void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
-
-	b1 += k1;
-	b0 += b1 + k0;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k3;
-	b2 += b3 + k2;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k5 + t0;
-	b4 += b5 + k4;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k7;
-	b6 += b7 + k6 + t1;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k2;
-	b0 += b1 + k1;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k4;
-	b2 += b3 + k3;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k6 + t1;
-	b4 += b5 + k5;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k8 + 1;
-	b6 += b7 + k7 + t2;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k3;
-	b0 += b1 + k2;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k5;
-	b2 += b3 + k4;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k7 + t2;
-	b4 += b5 + k6;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k0 + 2;
-	b6 += b7 + k8 + t0;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k4;
-	b0 += b1 + k3;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k6;
-	b2 += b3 + k5;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k8 + t0;
-	b4 += b5 + k7;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k1 + 3;
-	b6 += b7 + k0 + t1;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k5;
-	b0 += b1 + k4;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k7;
-	b2 += b3 + k6;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k0 + t1;
-	b4 += b5 + k8;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k2 + 4;
-	b6 += b7 + k1 + t2;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k6;
-	b0 += b1 + k5;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k8;
-	b2 += b3 + k7;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k1 + t2;
-	b4 += b5 + k0;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k3 + 5;
-	b6 += b7 + k2 + t0;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k7;
-	b0 += b1 + k6;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k0;
-	b2 += b3 + k8;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k2 + t0;
-	b4 += b5 + k1;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k4 + 6;
-	b6 += b7 + k3 + t1;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k8;
-	b0 += b1 + k7;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k1;
-	b2 += b3 + k0;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k3 + t1;
-	b4 += b5 + k2;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k5 + 7;
-	b6 += b7 + k4 + t2;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k0;
-	b0 += b1 + k8;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k2;
-	b2 += b3 + k1;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k4 + t2;
-	b4 += b5 + k3;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k6 + 8;
-	b6 += b7 + k5 + t0;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k1;
-	b0 += b1 + k0;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k3;
-	b2 += b3 + k2;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k5 + t0;
-	b4 += b5 + k4;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k7 + 9;
-	b6 += b7 + k6 + t1;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k2;
-	b0 += b1 + k1;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k4;
-	b2 += b3 + k3;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k6 + t1;
-	b4 += b5 + k5;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k8 + 10;
-	b6 += b7 + k7 + t2;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k3;
-	b0 += b1 + k2;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k5;
-	b2 += b3 + k4;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k7 + t2;
-	b4 += b5 + k6;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k0 + 11;
-	b6 += b7 + k8 + t0;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k4;
-	b0 += b1 + k3;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k6;
-	b2 += b3 + k5;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k8 + t0;
-	b4 += b5 + k7;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k1 + 12;
-	b6 += b7 + k0 + t1;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k5;
-	b0 += b1 + k4;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k7;
-	b2 += b3 + k6;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k0 + t1;
-	b4 += b5 + k8;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k2 + 13;
-	b6 += b7 + k1 + t2;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k6;
-	b0 += b1 + k5;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k8;
-	b2 += b3 + k7;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k1 + t2;
-	b4 += b5 + k0;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k3 + 14;
-	b6 += b7 + k2 + t0;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k7;
-	b0 += b1 + k6;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k0;
-	b2 += b3 + k8;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k2 + t0;
-	b4 += b5 + k1;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k4 + 15;
-	b6 += b7 + k3 + t1;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	b1 += k8;
-	b0 += b1 + k7;
-	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-
-	b3 += k1;
-	b2 += b3 + k0;
-	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-
-	b5 += k3 + t1;
-	b4 += b5 + k2;
-	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-
-	b7 += k5 + 16;
-	b6 += b7 + k4 + t2;
-	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-
-	b1 += k0;
-	b0 += b1 + k8;
-	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-
-	b3 += k2;
-	b2 += b3 + k1;
-	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-
-	b5 += k4 + t2;
-	b4 += b5 + k3;
-	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-
-	b7 += k6 + 17;
-	b6 += b7 + k5 + t0;
-	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-
-	b2 += b1;
-	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-
-	b4 += b7;
-	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-
-	b6 += b5;
-	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-
-	b0 += b3;
-	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-
-	b4 += b1;
-	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-
-	b6 += b3;
-	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-
-	b0 += b5;
-	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-
-	b2 += b7;
-	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-
-	b6 += b1;
-	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-
-	b0 += b7;
-	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-
-	b2 += b5;
-	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-
-	b4 += b3;
-	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-
-	output[0] = b0 + k0;
-	output[1] = b1 + k1;
-	output[2] = b2 + k2;
-	output[3] = b3 + k3;
-	output[4] = b4 + k4;
-	output[5] = b5 + k5 + t0;
-	output[6] = b6 + k6 + t1;
-	output[7] = b7 + k7 + 18;
-}
-
-void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
-
-	u64 tmp;
-
-	b0 -= k0;
-	b1 -= k1;
-	b2 -= k2;
-	b3 -= k3;
-	b4 -= k4;
-	b5 -= k5 + t0;
-	b6 -= k6 + t1;
-	b7 -= k7 + 18;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k5 + t0;
-	b7 -= k6 + 17;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k3;
-	b5 -= k4 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k1;
-	b3 -= k2;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k8;
-	b1 -= k0;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k4 + t2;
-	b7 -= k5 + 16;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k2;
-	b5 -= k3 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k0;
-	b3 -= k1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k7;
-	b1 -= k8;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k3 + t1;
-	b7 -= k4 + 15;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k1;
-	b5 -= k2 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k8;
-	b3 -= k0;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k6;
-	b1 -= k7;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k2 + t0;
-	b7 -= k3 + 14;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k0;
-	b5 -= k1 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k7;
-	b3 -= k8;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k5;
-	b1 -= k6;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k1 + t2;
-	b7 -= k2 + 13;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k8;
-	b5 -= k0 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k6;
-	b3 -= k7;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k4;
-	b1 -= k5;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k0 + t1;
-	b7 -= k1 + 12;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k7;
-	b5 -= k8 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k5;
-	b3 -= k6;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k3;
-	b1 -= k4;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k8 + t0;
-	b7 -= k0 + 11;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k6;
-	b5 -= k7 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k4;
-	b3 -= k5;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k2;
-	b1 -= k3;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k7 + t2;
-	b7 -= k8 + 10;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k5;
-	b5 -= k6 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k3;
-	b3 -= k4;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k1;
-	b1 -= k2;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k6 + t1;
-	b7 -= k7 + 9;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k4;
-	b5 -= k5 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k2;
-	b3 -= k3;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k0;
-	b1 -= k1;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k5 + t0;
-	b7 -= k6 + 8;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k3;
-	b5 -= k4 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k1;
-	b3 -= k2;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k8;
-	b1 -= k0;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k4 + t2;
-	b7 -= k5 + 7;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k2;
-	b5 -= k3 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k0;
-	b3 -= k1;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k7;
-	b1 -= k8;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k3 + t1;
-	b7 -= k4 + 6;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k1;
-	b5 -= k2 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k8;
-	b3 -= k0;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k6;
-	b1 -= k7;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k2 + t0;
-	b7 -= k3 + 5;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k0;
-	b5 -= k1 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k7;
-	b3 -= k8;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k5;
-	b1 -= k6;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k1 + t2;
-	b7 -= k2 + 4;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k8;
-	b5 -= k0 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k6;
-	b3 -= k7;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k4;
-	b1 -= k5;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k0 + t1;
-	b7 -= k1 + 3;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k7;
-	b5 -= k8 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k5;
-	b3 -= k6;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k3;
-	b1 -= k4;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k8 + t0;
-	b7 -= k0 + 2;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k6;
-	b5 -= k7 + t2;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k4;
-	b3 -= k5;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k2;
-	b1 -= k3;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 22) | (tmp << (64 - 22));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 56) | (tmp << (64 - 56));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 35) | (tmp << (64 - 35));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 8) | (tmp << (64 - 8));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 43) | (tmp << (64 - 43));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 29) | (tmp << (64 - 29));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 25) | (tmp << (64 - 25));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 17) | (tmp << (64 - 17));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 10) | (tmp << (64 - 10));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 50) | (tmp << (64 - 50));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 13) | (tmp << (64 - 13));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 24) | (tmp << (64 - 24));
-	b6 -= b7 + k7 + t2;
-	b7 -= k8 + 1;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 34) | (tmp << (64 - 34));
-	b4 -= b5 + k5;
-	b5 -= k6 + t1;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 30) | (tmp << (64 - 30));
-	b2 -= b3 + k3;
-	b3 -= k4;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 39) | (tmp << (64 - 39));
-	b0 -= b1 + k1;
-	b1 -= k2;
-
-	tmp = b3 ^ b4;
-	b3 = (tmp >> 56) | (tmp << (64 - 56));
-	b4 -= b3;
-
-	tmp = b5 ^ b2;
-	b5 = (tmp >> 54) | (tmp << (64 - 54));
-	b2 -= b5;
-
-	tmp = b7 ^ b0;
-	b7 = (tmp >> 9) | (tmp << (64 - 9));
-	b0 -= b7;
-
-	tmp = b1 ^ b6;
-	b1 = (tmp >> 44) | (tmp << (64 - 44));
-	b6 -= b1;
-
-	tmp = b7 ^ b2;
-	b7 = (tmp >> 39) | (tmp << (64 - 39));
-	b2 -= b7;
-
-	tmp = b5 ^ b0;
-	b5 = (tmp >> 36) | (tmp << (64 - 36));
-	b0 -= b5;
-
-	tmp = b3 ^ b6;
-	b3 = (tmp >> 49) | (tmp << (64 - 49));
-	b6 -= b3;
-
-	tmp = b1 ^ b4;
-	b1 = (tmp >> 17) | (tmp << (64 - 17));
-	b4 -= b1;
-
-	tmp = b3 ^ b0;
-	b3 = (tmp >> 42) | (tmp << (64 - 42));
-	b0 -= b3;
-
-	tmp = b5 ^ b6;
-	b5 = (tmp >> 14) | (tmp << (64 - 14));
-	b6 -= b5;
-
-	tmp = b7 ^ b4;
-	b7 = (tmp >> 27) | (tmp << (64 - 27));
-	b4 -= b7;
-
-	tmp = b1 ^ b2;
-	b1 = (tmp >> 33) | (tmp << (64 - 33));
-	b2 -= b1;
-
-	tmp = b7 ^ b6;
-	b7 = (tmp >> 37) | (tmp << (64 - 37));
-	b6 -= b7 + k6 + t1;
-	b7 -= k7;
-
-	tmp = b5 ^ b4;
-	b5 = (tmp >> 19) | (tmp << (64 - 19));
-	b4 -= b5 + k4;
-	b5 -= k5 + t0;
-
-	tmp = b3 ^ b2;
-	b3 = (tmp >> 36) | (tmp << (64 - 36));
-	b2 -= b3 + k2;
-	b3 -= k3;
-
-	tmp = b1 ^ b0;
-	b1 = (tmp >> 46) | (tmp << (64 - 46));
-	b0 -= b1 + k0;
-	b1 -= k1;
-
-	output[0] = b0;
-	output[1] = b1;
-	output[2] = b2;
-	output[3] = b3;
-
-	output[7] = b7;
-	output[6] = b6;
-	output[5] = b5;
-	output[4] = b4;
-}
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
deleted file mode 100644
index 1e70f66..0000000
--- a/drivers/staging/skein/threefishApi.c
+++ /dev/null
@@ -1,79 +0,0 @@
-
-
-#include <linux/string.h>
-#include <threefishApi.h>
-
-void threefishSetKey(struct threefish_key *keyCtx,
-			enum threefish_size stateSize,
-			u64 *keyData, u64 *tweak)
-{
-	int keyWords = stateSize / 64;
-	int i;
-	u64 parity = KeyScheduleConst;
-
-	keyCtx->tweak[0] = tweak[0];
-	keyCtx->tweak[1] = tweak[1];
-	keyCtx->tweak[2] = tweak[0] ^ tweak[1];
-
-	for (i = 0; i < keyWords; i++) {
-		keyCtx->key[i] = keyData[i];
-		parity ^= keyData[i];
-	}
-	keyCtx->key[i] = parity;
-	keyCtx->stateSize = stateSize;
-}
-
-void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
-				u8 *out)
-{
-	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
-	u64 cipher[SKEIN_MAX_STATE_WORDS];
-
-	Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);
-	threefishEncryptBlockWords(keyCtx, plain, cipher);
-	Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);
-}
-
-void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out)
-{
-	switch (keyCtx->stateSize) {
-	case Threefish256:
-		threefishEncrypt256(keyCtx, in, out);
-		break;
-	case Threefish512:
-		threefishEncrypt512(keyCtx, in, out);
-		break;
-	case Threefish1024:
-		threefishEncrypt1024(keyCtx, in, out);
-		break;
-	}
-}
-
-void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
-				u8 *out)
-{
-	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
-	u64 cipher[SKEIN_MAX_STATE_WORDS];
-
-	Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);
-	threefishDecryptBlockWords(keyCtx, cipher, plain);
-	Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);
-}
-
-void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out)
-{
-	switch (keyCtx->stateSize) {
-	case Threefish256:
-		threefishDecrypt256(keyCtx, in, out);
-		break;
-	case Threefish512:
-		threefishDecrypt512(keyCtx, in, out);
-		break;
-	case Threefish1024:
-		threefishDecrypt1024(keyCtx, in, out);
-		break;
-	}
-}
-
diff --git a/drivers/staging/skein/threefish_1024_block.c b/drivers/staging/skein/threefish_1024_block.c
new file mode 100644
index 0000000..82f7ae60
--- /dev/null
+++ b/drivers/staging/skein/threefish_1024_block.c
@@ -0,0 +1,4900 @@
+#include <linux/string.h>
+#include "threefish_api.h"
+
+
+void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3],
+	  b4 = input[4], b5 = input[5],
+	  b6 = input[6], b7 = input[7],
+	  b8 = input[8], b9 = input[9],
+	  b10 = input[10], b11 = input[11],
+	  b12 = input[12], b13 = input[13],
+	  b14 = input[14], b15 = input[15];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
+	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
+	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
+	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
+	  k16 = keyCtx->key[16];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k5;
+	b4 += b5 + k4;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k7;
+	b6 += b7 + k6;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k9;
+	b8 += b9 + k8;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k11;
+	b10 += b11 + k10;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k13 + t0;
+	b12 += b13 + k12;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k15;
+	b14 += b15 + k14 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k6;
+	b4 += b5 + k5;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k8;
+	b6 += b7 + k7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k10;
+	b8 += b9 + k9;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k12;
+	b10 += b11 + k11;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k14 + t1;
+	b12 += b13 + k13;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k16 + 1;
+	b14 += b15 + k15 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k7;
+	b4 += b5 + k6;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k9;
+	b6 += b7 + k8;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k11;
+	b8 += b9 + k10;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k13;
+	b10 += b11 + k12;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k15 + t2;
+	b12 += b13 + k14;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k0 + 2;
+	b14 += b15 + k16 + t0;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k4;
+	b0 += b1 + k3;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k6;
+	b2 += b3 + k5;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k8;
+	b4 += b5 + k7;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k10;
+	b6 += b7 + k9;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k12;
+	b8 += b9 + k11;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k14;
+	b10 += b11 + k13;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k16 + t0;
+	b12 += b13 + k15;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k1 + 3;
+	b14 += b15 + k0 + t1;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k5;
+	b0 += b1 + k4;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k7;
+	b2 += b3 + k6;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k9;
+	b4 += b5 + k8;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k11;
+	b6 += b7 + k10;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k13;
+	b8 += b9 + k12;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k15;
+	b10 += b11 + k14;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k0 + t1;
+	b12 += b13 + k16;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k2 + 4;
+	b14 += b15 + k1 + t2;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k6;
+	b0 += b1 + k5;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k8;
+	b2 += b3 + k7;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k10;
+	b4 += b5 + k9;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k12;
+	b6 += b7 + k11;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k14;
+	b8 += b9 + k13;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k16;
+	b10 += b11 + k15;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k1 + t2;
+	b12 += b13 + k0;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k3 + 5;
+	b14 += b15 + k2 + t0;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k7;
+	b0 += b1 + k6;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k9;
+	b2 += b3 + k8;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k11;
+	b4 += b5 + k10;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k13;
+	b6 += b7 + k12;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k15;
+	b8 += b9 + k14;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k0;
+	b10 += b11 + k16;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k2 + t0;
+	b12 += b13 + k1;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k4 + 6;
+	b14 += b15 + k3 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k8;
+	b0 += b1 + k7;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k10;
+	b2 += b3 + k9;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k12;
+	b4 += b5 + k11;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k14;
+	b6 += b7 + k13;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k16;
+	b8 += b9 + k15;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k1;
+	b10 += b11 + k0;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k3 + t1;
+	b12 += b13 + k2;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k5 + 7;
+	b14 += b15 + k4 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k9;
+	b0 += b1 + k8;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k11;
+	b2 += b3 + k10;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k13;
+	b4 += b5 + k12;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k15;
+	b6 += b7 + k14;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k0;
+	b8 += b9 + k16;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k2;
+	b10 += b11 + k1;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k4 + t2;
+	b12 += b13 + k3;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k6 + 8;
+	b14 += b15 + k5 + t0;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k10;
+	b0 += b1 + k9;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k12;
+	b2 += b3 + k11;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k14;
+	b4 += b5 + k13;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k16;
+	b6 += b7 + k15;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k1;
+	b8 += b9 + k0;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k3;
+	b10 += b11 + k2;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k5 + t0;
+	b12 += b13 + k4;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k7 + 9;
+	b14 += b15 + k6 + t1;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k11;
+	b0 += b1 + k10;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k13;
+	b2 += b3 + k12;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k15;
+	b4 += b5 + k14;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k0;
+	b6 += b7 + k16;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k2;
+	b8 += b9 + k1;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k4;
+	b10 += b11 + k3;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k6 + t1;
+	b12 += b13 + k5;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k8 + 10;
+	b14 += b15 + k7 + t2;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k12;
+	b0 += b1 + k11;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k14;
+	b2 += b3 + k13;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k16;
+	b4 += b5 + k15;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k1;
+	b6 += b7 + k0;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k3;
+	b8 += b9 + k2;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k5;
+	b10 += b11 + k4;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k7 + t2;
+	b12 += b13 + k6;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k9 + 11;
+	b14 += b15 + k8 + t0;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k13;
+	b0 += b1 + k12;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k15;
+	b2 += b3 + k14;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k0;
+	b4 += b5 + k16;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k2;
+	b6 += b7 + k1;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k4;
+	b8 += b9 + k3;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k6;
+	b10 += b11 + k5;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k8 + t0;
+	b12 += b13 + k7;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k10 + 12;
+	b14 += b15 + k9 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k14;
+	b0 += b1 + k13;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k16;
+	b2 += b3 + k15;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k1;
+	b4 += b5 + k0;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k3;
+	b6 += b7 + k2;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k5;
+	b8 += b9 + k4;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k7;
+	b10 += b11 + k6;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k9 + t1;
+	b12 += b13 + k8;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k11 + 13;
+	b14 += b15 + k10 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k15;
+	b0 += b1 + k14;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k0;
+	b2 += b3 + k16;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k2;
+	b4 += b5 + k1;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k4;
+	b6 += b7 + k3;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k6;
+	b8 += b9 + k5;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k8;
+	b10 += b11 + k7;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k10 + t2;
+	b12 += b13 + k9;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k12 + 14;
+	b14 += b15 + k11 + t0;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k16;
+	b0 += b1 + k15;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k1;
+	b2 += b3 + k0;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k3;
+	b4 += b5 + k2;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k5;
+	b6 += b7 + k4;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k7;
+	b8 += b9 + k6;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k9;
+	b10 += b11 + k8;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k11 + t0;
+	b12 += b13 + k10;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k13 + 15;
+	b14 += b15 + k12 + t1;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k0;
+	b0 += b1 + k16;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k2;
+	b2 += b3 + k1;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k4;
+	b4 += b5 + k3;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k6;
+	b6 += b7 + k5;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k8;
+	b8 += b9 + k7;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k10;
+	b10 += b11 + k9;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k12 + t1;
+	b12 += b13 + k11;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k14 + 16;
+	b14 += b15 + k13 + t2;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k5;
+	b4 += b5 + k4;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k7;
+	b6 += b7 + k6;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k9;
+	b8 += b9 + k8;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k11;
+	b10 += b11 + k10;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k13 + t2;
+	b12 += b13 + k12;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k15 + 17;
+	b14 += b15 + k14 + t0;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k6;
+	b4 += b5 + k5;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k8;
+	b6 += b7 + k7;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k10;
+	b8 += b9 + k9;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k12;
+	b10 += b11 + k11;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k14 + t0;
+	b12 += b13 + k13;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k16 + 18;
+	b14 += b15 + k15 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k7;
+	b4 += b5 + k6;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k9;
+	b6 += b7 + k8;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k11;
+	b8 += b9 + k10;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k13;
+	b10 += b11 + k12;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k15 + t1;
+	b12 += b13 + k14;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k0 + 19;
+	b14 += b15 + k16 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	output[0] = b0 + k3;
+	output[1] = b1 + k4;
+	output[2] = b2 + k5;
+	output[3] = b3 + k6;
+	output[4] = b4 + k7;
+	output[5] = b5 + k8;
+	output[6] = b6 + k9;
+	output[7] = b7 + k10;
+	output[8] = b8 + k11;
+	output[9] = b9 + k12;
+	output[10] = b10 + k13;
+	output[11] = b11 + k14;
+	output[12] = b12 + k15;
+	output[13] = b13 + k16 + t2;
+	output[14] = b14 + k0 + t0;
+	output[15] = b15 + k1 + 20;
+}
+
+void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3],
+	  b4 = input[4], b5 = input[5],
+	  b6 = input[6], b7 = input[7],
+	  b8 = input[8], b9 = input[9],
+	  b10 = input[10], b11 = input[11],
+	  b12 = input[12], b13 = input[13],
+	  b14 = input[14], b15 = input[15];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
+	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
+	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
+	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
+	  k16 = keyCtx->key[16];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+	u64 tmp;
+
+	b0 -= k3;
+	b1 -= k4;
+	b2 -= k5;
+	b3 -= k6;
+	b4 -= k7;
+	b5 -= k8;
+	b6 -= k9;
+	b7 -= k10;
+	b8 -= k11;
+	b9 -= k12;
+	b10 -= k13;
+	b11 -= k14;
+	b12 -= k15;
+	b13 -= k16 + t2;
+	b14 -= k0 + t0;
+	b15 -= k1 + 20;
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k16 + t2;
+	b15 -= k0 + 19;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k14;
+	b13 -= k15 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k12;
+	b11 -= k13;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k10;
+	b9 -= k11;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k8;
+	b7 -= k9;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k6;
+	b5 -= k7;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k15 + t1;
+	b15 -= k16 + 18;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k13;
+	b13 -= k14 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k11;
+	b11 -= k12;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k9;
+	b9 -= k10;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k7;
+	b7 -= k8;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k5;
+	b5 -= k6;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k14 + t0;
+	b15 -= k15 + 17;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k12;
+	b13 -= k13 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k10;
+	b11 -= k11;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k8;
+	b9 -= k9;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k6;
+	b7 -= k7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k4;
+	b5 -= k5;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k2;
+	b3 -= k3;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k0;
+	b1 -= k1;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k13 + t2;
+	b15 -= k14 + 16;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k11;
+	b13 -= k12 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k9;
+	b11 -= k10;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k7;
+	b9 -= k8;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k5;
+	b7 -= k6;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k3;
+	b5 -= k4;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k1;
+	b3 -= k2;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k16;
+	b1 -= k0;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k12 + t1;
+	b15 -= k13 + 15;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k10;
+	b13 -= k11 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k8;
+	b11 -= k9;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k6;
+	b9 -= k7;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k4;
+	b7 -= k5;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k2;
+	b5 -= k3;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k0;
+	b3 -= k1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k15;
+	b1 -= k16;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k11 + t0;
+	b15 -= k12 + 14;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k9;
+	b13 -= k10 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k7;
+	b11 -= k8;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k5;
+	b9 -= k6;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k3;
+	b7 -= k4;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k1;
+	b5 -= k2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k16;
+	b3 -= k0;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k14;
+	b1 -= k15;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k10 + t2;
+	b15 -= k11 + 13;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k8;
+	b13 -= k9 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k6;
+	b11 -= k7;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k4;
+	b9 -= k5;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k2;
+	b7 -= k3;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k0;
+	b5 -= k1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k15;
+	b3 -= k16;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k13;
+	b1 -= k14;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k9 + t1;
+	b15 -= k10 + 12;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k7;
+	b13 -= k8 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k5;
+	b11 -= k6;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k3;
+	b9 -= k4;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k1;
+	b7 -= k2;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k16;
+	b5 -= k0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k14;
+	b3 -= k15;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k12;
+	b1 -= k13;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k8 + t0;
+	b15 -= k9 + 11;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k6;
+	b13 -= k7 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k4;
+	b11 -= k5;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k2;
+	b9 -= k3;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k0;
+	b7 -= k1;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k15;
+	b5 -= k16;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k13;
+	b3 -= k14;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k11;
+	b1 -= k12;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k7 + t2;
+	b15 -= k8 + 10;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k5;
+	b13 -= k6 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k3;
+	b11 -= k4;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k1;
+	b9 -= k2;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k16;
+	b7 -= k0;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k14;
+	b5 -= k15;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k12;
+	b3 -= k13;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k10;
+	b1 -= k11;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k6 + t1;
+	b15 -= k7 + 9;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k4;
+	b13 -= k5 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k2;
+	b11 -= k3;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k0;
+	b9 -= k1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k15;
+	b7 -= k16;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k13;
+	b5 -= k14;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k11;
+	b3 -= k12;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k9;
+	b1 -= k10;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k5 + t0;
+	b15 -= k6 + 8;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k3;
+	b13 -= k4 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k1;
+	b11 -= k2;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k16;
+	b9 -= k0;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k14;
+	b7 -= k15;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k12;
+	b5 -= k13;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k10;
+	b3 -= k11;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k8;
+	b1 -= k9;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k4 + t2;
+	b15 -= k5 + 7;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k2;
+	b13 -= k3 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k0;
+	b11 -= k1;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k15;
+	b9 -= k16;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k13;
+	b7 -= k14;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k11;
+	b5 -= k12;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k9;
+	b3 -= k10;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k7;
+	b1 -= k8;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k3 + t1;
+	b15 -= k4 + 6;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k1;
+	b13 -= k2 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k16;
+	b11 -= k0;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k14;
+	b9 -= k15;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k12;
+	b7 -= k13;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k10;
+	b5 -= k11;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k8;
+	b3 -= k9;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k6;
+	b1 -= k7;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k2 + t0;
+	b15 -= k3 + 5;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k0;
+	b13 -= k1 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k15;
+	b11 -= k16;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k13;
+	b9 -= k14;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k11;
+	b7 -= k12;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k9;
+	b5 -= k10;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k7;
+	b3 -= k8;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k5;
+	b1 -= k6;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k1 + t2;
+	b15 -= k2 + 4;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k16;
+	b13 -= k0 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k14;
+	b11 -= k15;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k12;
+	b9 -= k13;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k10;
+	b7 -= k11;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k8;
+	b5 -= k9;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k6;
+	b3 -= k7;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k4;
+	b1 -= k5;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k0 + t1;
+	b15 -= k1 + 3;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k15;
+	b13 -= k16 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k13;
+	b11 -= k14;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k11;
+	b9 -= k12;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k9;
+	b7 -= k10;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k7;
+	b5 -= k8;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k5;
+	b3 -= k6;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k3;
+	b1 -= k4;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k16 + t0;
+	b15 -= k0 + 2;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k14;
+	b13 -= k15 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k12;
+	b11 -= k13;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k10;
+	b9 -= k11;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k8;
+	b7 -= k9;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k6;
+	b5 -= k7;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k15 + t2;
+	b15 -= k16 + 1;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k13;
+	b13 -= k14 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k11;
+	b11 -= k12;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k9;
+	b9 -= k10;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k7;
+	b7 -= k8;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k5;
+	b5 -= k6;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k14 + t1;
+	b15 -= k15;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k12;
+	b13 -= k13 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k10;
+	b11 -= k11;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k8;
+	b9 -= k9;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k6;
+	b7 -= k7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k4;
+	b5 -= k5;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k2;
+	b3 -= k3;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k0;
+	b1 -= k1;
+
+	output[15] = b15;
+	output[14] = b14;
+	output[13] = b13;
+	output[12] = b12;
+	output[11] = b11;
+	output[10] = b10;
+	output[9] = b9;
+	output[8] = b8;
+	output[7] = b7;
+	output[6] = b6;
+	output[5] = b5;
+	output[4] = b4;
+	output[3] = b3;
+	output[2] = b2;
+	output[1] = b1;
+	output[0] = b0;
+}
diff --git a/drivers/staging/skein/threefish_256_block.c b/drivers/staging/skein/threefish_256_block.c
new file mode 100644
index 0000000..a116bdf
--- /dev/null
+++ b/drivers/staging/skein/threefish_256_block.c
@@ -0,0 +1,1137 @@
+#include <linux/string.h>
+#include "threefish_api.h"
+
+
+void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+
+	b1 += k1 + t0;
+	b0 += b1 + k0;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2 + t1;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k2 + t1;
+	b0 += b1 + k1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k4 + 1;
+	b2 += b3 + k3 + t2;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k3 + t2;
+	b0 += b1 + k2;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k0 + 2;
+	b2 += b3 + k4 + t0;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k4 + t0;
+	b0 += b1 + k3;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k1 + 3;
+	b2 += b3 + k0 + t1;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k0 + t1;
+	b0 += b1 + k4;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k2 + 4;
+	b2 += b3 + k1 + t2;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k1 + t2;
+	b0 += b1 + k0;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k3 + 5;
+	b2 += b3 + k2 + t0;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k2 + t0;
+	b0 += b1 + k1;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k4 + 6;
+	b2 += b3 + k3 + t1;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k3 + t1;
+	b0 += b1 + k2;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k0 + 7;
+	b2 += b3 + k4 + t2;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k4 + t2;
+	b0 += b1 + k3;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k1 + 8;
+	b2 += b3 + k0 + t0;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k0 + t0;
+	b0 += b1 + k4;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k2 + 9;
+	b2 += b3 + k1 + t1;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k1 + t1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k3 + 10;
+	b2 += b3 + k2 + t2;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k2 + t2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k4 + 11;
+	b2 += b3 + k3 + t0;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k3 + t0;
+	b0 += b1 + k2;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k0 + 12;
+	b2 += b3 + k4 + t1;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k4 + t1;
+	b0 += b1 + k3;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k1 + 13;
+	b2 += b3 + k0 + t2;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k0 + t2;
+	b0 += b1 + k4;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k2 + 14;
+	b2 += b3 + k1 + t0;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k1 + t0;
+	b0 += b1 + k0;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k3 + 15;
+	b2 += b3 + k2 + t1;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k2 + t1;
+	b0 += b1 + k1;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k4 + 16;
+	b2 += b3 + k3 + t2;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k3 + t2;
+	b0 += b1 + k2;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k0 + 17;
+	b2 += b3 + k4 + t0;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+	output[0] = b0 + k3;
+	output[1] = b1 + k4 + t0;
+	output[2] = b2 + k0 + t1;
+	output[3] = b3 + k1 + 18;
+}
+
+void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+
+	u64 tmp;
+
+	b0 -= k3;
+	b1 -= k4 + t0;
+	b2 -= k0 + t1;
+	b3 -= k1 + 18;
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k2;
+	b1 -= k3 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k4 + t0;
+	b3 -= k0 + 17;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k1;
+	b1 -= k2 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k3 + t2;
+	b3 -= k4 + 16;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k0;
+	b1 -= k1 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k2 + t1;
+	b3 -= k3 + 15;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k4;
+	b1 -= k0 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k1 + t0;
+	b3 -= k2 + 14;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k3;
+	b1 -= k4 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k0 + t2;
+	b3 -= k1 + 13;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k2;
+	b1 -= k3 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k4 + t1;
+	b3 -= k0 + 12;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k1;
+	b1 -= k2 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k3 + t0;
+	b3 -= k4 + 11;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k0;
+	b1 -= k1 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k2 + t2;
+	b3 -= k3 + 10;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k4;
+	b1 -= k0 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k1 + t1;
+	b3 -= k2 + 9;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k3;
+	b1 -= k4 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k0 + t0;
+	b3 -= k1 + 8;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k2;
+	b1 -= k3 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k4 + t2;
+	b3 -= k0 + 7;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k1;
+	b1 -= k2 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k3 + t1;
+	b3 -= k4 + 6;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k0;
+	b1 -= k1 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k2 + t0;
+	b3 -= k3 + 5;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k4;
+	b1 -= k0 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k1 + t2;
+	b3 -= k2 + 4;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k3;
+	b1 -= k4 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k0 + t1;
+	b3 -= k1 + 3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k2;
+	b1 -= k3 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k4 + t0;
+	b3 -= k0 + 2;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k1;
+	b1 -= k2 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k3 + t2;
+	b3 -= k4 + 1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k0;
+	b1 -= k1 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k2 + t1;
+	b3 -= k3;
+
+	output[0] = b0;
+	output[1] = b1;
+	output[2] = b2;
+	output[3] = b3;
+}
diff --git a/drivers/staging/skein/threefish_512_block.c b/drivers/staging/skein/threefish_512_block.c
new file mode 100644
index 0000000..8450628
--- /dev/null
+++ b/drivers/staging/skein/threefish_512_block.c
@@ -0,0 +1,2223 @@
+#include <linux/string.h>
+#include "threefish_api.h"
+
+
+void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3],
+	  b4 = input[4], b5 = input[5],
+	  b6 = input[6], b7 = input[7];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+	  k8 = keyCtx->key[8];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k5 + t0;
+	b4 += b5 + k4;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k7;
+	b6 += b7 + k6 + t1;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k6 + t1;
+	b4 += b5 + k5;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k8 + 1;
+	b6 += b7 + k7 + t2;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k7 + t2;
+	b4 += b5 + k6;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k0 + 2;
+	b6 += b7 + k8 + t0;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k4;
+	b0 += b1 + k3;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k6;
+	b2 += b3 + k5;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k8 + t0;
+	b4 += b5 + k7;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k1 + 3;
+	b6 += b7 + k0 + t1;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k5;
+	b0 += b1 + k4;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k7;
+	b2 += b3 + k6;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k0 + t1;
+	b4 += b5 + k8;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k2 + 4;
+	b6 += b7 + k1 + t2;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k6;
+	b0 += b1 + k5;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k8;
+	b2 += b3 + k7;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k1 + t2;
+	b4 += b5 + k0;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k3 + 5;
+	b6 += b7 + k2 + t0;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k7;
+	b0 += b1 + k6;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k0;
+	b2 += b3 + k8;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k2 + t0;
+	b4 += b5 + k1;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k4 + 6;
+	b6 += b7 + k3 + t1;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k8;
+	b0 += b1 + k7;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k1;
+	b2 += b3 + k0;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k3 + t1;
+	b4 += b5 + k2;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k5 + 7;
+	b6 += b7 + k4 + t2;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k0;
+	b0 += b1 + k8;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k2;
+	b2 += b3 + k1;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k4 + t2;
+	b4 += b5 + k3;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k6 + 8;
+	b6 += b7 + k5 + t0;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k5 + t0;
+	b4 += b5 + k4;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k7 + 9;
+	b6 += b7 + k6 + t1;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k6 + t1;
+	b4 += b5 + k5;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k8 + 10;
+	b6 += b7 + k7 + t2;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k7 + t2;
+	b4 += b5 + k6;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k0 + 11;
+	b6 += b7 + k8 + t0;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k4;
+	b0 += b1 + k3;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k6;
+	b2 += b3 + k5;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k8 + t0;
+	b4 += b5 + k7;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k1 + 12;
+	b6 += b7 + k0 + t1;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k5;
+	b0 += b1 + k4;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k7;
+	b2 += b3 + k6;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k0 + t1;
+	b4 += b5 + k8;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k2 + 13;
+	b6 += b7 + k1 + t2;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k6;
+	b0 += b1 + k5;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k8;
+	b2 += b3 + k7;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k1 + t2;
+	b4 += b5 + k0;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k3 + 14;
+	b6 += b7 + k2 + t0;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k7;
+	b0 += b1 + k6;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k0;
+	b2 += b3 + k8;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k2 + t0;
+	b4 += b5 + k1;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k4 + 15;
+	b6 += b7 + k3 + t1;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k8;
+	b0 += b1 + k7;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k1;
+	b2 += b3 + k0;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k3 + t1;
+	b4 += b5 + k2;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k5 + 16;
+	b6 += b7 + k4 + t2;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k0;
+	b0 += b1 + k8;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k2;
+	b2 += b3 + k1;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k4 + t2;
+	b4 += b5 + k3;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k6 + 17;
+	b6 += b7 + k5 + t0;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	output[0] = b0 + k0;
+	output[1] = b1 + k1;
+	output[2] = b2 + k2;
+	output[3] = b3 + k3;
+	output[4] = b4 + k4;
+	output[5] = b5 + k5 + t0;
+	output[6] = b6 + k6 + t1;
+	output[7] = b7 + k7 + 18;
+}
+
+void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3],
+	  b4 = input[4], b5 = input[5],
+	  b6 = input[6], b7 = input[7];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+	  k8 = keyCtx->key[8];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+
+	u64 tmp;
+
+	b0 -= k0;
+	b1 -= k1;
+	b2 -= k2;
+	b3 -= k3;
+	b4 -= k4;
+	b5 -= k5 + t0;
+	b6 -= k6 + t1;
+	b7 -= k7 + 18;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k5 + t0;
+	b7 -= k6 + 17;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k3;
+	b5 -= k4 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k1;
+	b3 -= k2;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k8;
+	b1 -= k0;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k4 + t2;
+	b7 -= k5 + 16;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k2;
+	b5 -= k3 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k0;
+	b3 -= k1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k7;
+	b1 -= k8;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k3 + t1;
+	b7 -= k4 + 15;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k1;
+	b5 -= k2 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k8;
+	b3 -= k0;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k6;
+	b1 -= k7;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k2 + t0;
+	b7 -= k3 + 14;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k0;
+	b5 -= k1 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k7;
+	b3 -= k8;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k5;
+	b1 -= k6;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k1 + t2;
+	b7 -= k2 + 13;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k8;
+	b5 -= k0 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k6;
+	b3 -= k7;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k4;
+	b1 -= k5;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k0 + t1;
+	b7 -= k1 + 12;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k7;
+	b5 -= k8 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k5;
+	b3 -= k6;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k3;
+	b1 -= k4;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k8 + t0;
+	b7 -= k0 + 11;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k6;
+	b5 -= k7 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k7 + t2;
+	b7 -= k8 + 10;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k5;
+	b5 -= k6 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k6 + t1;
+	b7 -= k7 + 9;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k4;
+	b5 -= k5 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k2;
+	b3 -= k3;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k0;
+	b1 -= k1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k5 + t0;
+	b7 -= k6 + 8;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k3;
+	b5 -= k4 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k1;
+	b3 -= k2;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k8;
+	b1 -= k0;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k4 + t2;
+	b7 -= k5 + 7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k2;
+	b5 -= k3 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k0;
+	b3 -= k1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k7;
+	b1 -= k8;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k3 + t1;
+	b7 -= k4 + 6;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k1;
+	b5 -= k2 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k8;
+	b3 -= k0;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k6;
+	b1 -= k7;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k2 + t0;
+	b7 -= k3 + 5;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k0;
+	b5 -= k1 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k7;
+	b3 -= k8;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k5;
+	b1 -= k6;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k1 + t2;
+	b7 -= k2 + 4;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k8;
+	b5 -= k0 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k6;
+	b3 -= k7;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k4;
+	b1 -= k5;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k0 + t1;
+	b7 -= k1 + 3;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k7;
+	b5 -= k8 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k5;
+	b3 -= k6;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k3;
+	b1 -= k4;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k8 + t0;
+	b7 -= k0 + 2;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k6;
+	b5 -= k7 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k7 + t2;
+	b7 -= k8 + 1;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k5;
+	b5 -= k6 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k6 + t1;
+	b7 -= k7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k4;
+	b5 -= k5 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k2;
+	b3 -= k3;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k0;
+	b1 -= k1;
+
+	output[0] = b0;
+	output[1] = b1;
+	output[2] = b2;
+	output[3] = b3;
+
+	output[7] = b7;
+	output[6] = b6;
+	output[5] = b5;
+	output[4] = b4;
+}
diff --git a/drivers/staging/skein/threefish_api.c b/drivers/staging/skein/threefish_api.c
new file mode 100644
index 0000000..69ae12c
--- /dev/null
+++ b/drivers/staging/skein/threefish_api.c
@@ -0,0 +1,77 @@
+#include <linux/string.h>
+#include "threefish_api.h"
+
+void threefishSetKey(struct threefish_key *keyCtx,
+			enum threefish_size stateSize,
+			u64 *keyData, u64 *tweak)
+{
+	int keyWords = stateSize / 64;
+	int i;
+	u64 parity = KeyScheduleConst;
+
+	keyCtx->tweak[0] = tweak[0];
+	keyCtx->tweak[1] = tweak[1];
+	keyCtx->tweak[2] = tweak[0] ^ tweak[1];
+
+	for (i = 0; i < keyWords; i++) {
+		keyCtx->key[i] = keyData[i];
+		parity ^= keyData[i];
+	}
+	keyCtx->key[i] = parity;
+	keyCtx->stateSize = stateSize;
+}
+
+void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
+				u8 *out)
+{
+	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
+	u64 cipher[SKEIN_MAX_STATE_WORDS];
+
+	Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);
+	threefishEncryptBlockWords(keyCtx, plain, cipher);
+	Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);
+}
+
+void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+				u64 *out)
+{
+	switch (keyCtx->stateSize) {
+	case Threefish256:
+		threefishEncrypt256(keyCtx, in, out);
+		break;
+	case Threefish512:
+		threefishEncrypt512(keyCtx, in, out);
+		break;
+	case Threefish1024:
+		threefishEncrypt1024(keyCtx, in, out);
+		break;
+	}
+}
+
+void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
+				u8 *out)
+{
+	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
+	u64 cipher[SKEIN_MAX_STATE_WORDS];
+
+	Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);
+	threefishDecryptBlockWords(keyCtx, cipher, plain);
+	Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);
+}
+
+void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+				u64 *out)
+{
+	switch (keyCtx->stateSize) {
+	case Threefish256:
+		threefishDecrypt256(keyCtx, in, out);
+		break;
+	case Threefish512:
+		threefishDecrypt512(keyCtx, in, out);
+		break;
+	case Threefish1024:
+		threefishDecrypt1024(keyCtx, in, out);
+		break;
+	}
+}
+
diff --git a/drivers/staging/skein/threefish_api.h b/drivers/staging/skein/threefish_api.h
new file mode 100644
index 0000000..abf409d
--- /dev/null
+++ b/drivers/staging/skein/threefish_api.h
@@ -0,0 +1,164 @@
+
+#ifndef THREEFISHAPI_H
+#define THREEFISHAPI_H
+
+/**
+ * @file threefishApi.h
+ * @brief A Threefish cipher API and its functions.
+ * @{
+ *
+ * This API and the functions that implement this API simplify the usage
+ * of the Threefish cipher. The design and the way to use the functions
+ * follow the openSSL design but at the same time take care of some Threefish
+ * specific behaviour and possibilities.
+ *
+ * These are the low level functions that deal with Threefisch blocks only.
+ * Implementations for cipher modes such as ECB, CFB, or CBC may use these
+ * functions.
+ *
+@code
+    // Threefish cipher context data
+    struct threefish_key keyCtx;
+
+    // Initialize the context
+    threefishSetKey(&keyCtx, Threefish512, key, tweak);
+
+    // Encrypt
+    threefishEncryptBlockBytes(&keyCtx, input, cipher);
+@endcode
+ */
+
+#include <linux/types.h>
+#include "skein.h"
+
+#define KeyScheduleConst 0x1BD11BDAA9FC1A22L
+
+/**
+ * Which Threefish size to use
+ */
+enum threefish_size {
+	Threefish256 = 256,     /*!< Skein with 256 bit state */
+	Threefish512 = 512,     /*!< Skein with 512 bit state */
+	Threefish1024 = 1024    /*!< Skein with 1024 bit state */
+};
+
+/**
+ * Context for Threefish key and tweak words.
+ *
+ * This structure was setup with some know-how of the internal
+ * Skein structures, in particular ordering of header and size dependent
+ * variables. If Skein implementation changes this, the adapt these
+ * structures as well.
+ */
+struct threefish_key {
+	u64 stateSize;
+	u64 key[SKEIN_MAX_STATE_WORDS+1];   /* max number of key words*/
+	u64 tweak[3];
+};
+
+/**
+ * Set Threefish key and tweak data.
+ *
+ * This function sets the key and tweak data for the Threefish cipher of
+ * the given size. The key data must have the same length (number of bits)
+ * as the state size
+ *
+ * @param keyCtx
+ *     Pointer to a Threefish key structure.
+ * @param size
+ *     Which Skein size to use.
+ * @param keyData
+ *     Pointer to the key words (word has 64 bits).
+ * @param tweak
+ *     Pointer to the two tweak words (word has 64 bits).
+ */
+void threefishSetKey(struct threefish_key *keyCtx,
+			enum threefish_size stateSize,
+			u64 *keyData, u64 *tweak);
+
+/**
+ * Encrypt Threefisch block (bytes).
+ *
+ * The buffer must have at least the same length (number of bits) aas the
+ * state size for this key. The function uses the first @c stateSize bits
+ * of the input buffer, encrypts them and stores the result in the output
+ * buffer.
+ *
+ * @param keyCtx
+ *     Pointer to a Threefish key structure.
+ * @param in
+ *     Poionter to plaintext data buffer.
+ * @param out
+ *     Pointer to cipher buffer.
+ */
+void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
+
+/**
+ * Encrypt Threefisch block (words).
+ *
+ * The buffer must have at least the same length (number of bits) aas the
+ * state size for this key. The function uses the first @c stateSize bits
+ * of the input buffer, encrypts them and stores the result in the output
+ * buffer.
+ *
+ * The wordsize ist set to 64 bits.
+ *
+ * @param keyCtx
+ *     Pointer to a Threefish key structure.
+ * @param in
+ *     Poionter to plaintext data buffer.
+ * @param out
+ *     Pointer to cipher buffer.
+ */
+void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+				u64 *out);
+
+/**
+ * Decrypt Threefisch block (bytes).
+ *
+ * The buffer must have at least the same length (number of bits) aas the
+ * state size for this key. The function uses the first @c stateSize bits
+ * of the input buffer, decrypts them and stores the result in the output
+ * buffer
+ *
+ * @param keyCtx
+ *     Pointer to a Threefish key structure.
+ * @param in
+ *     Poionter to cipher data buffer.
+ * @param out
+ *     Pointer to plaintext buffer.
+ */
+void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
+
+/**
+ * Decrypt Threefisch block (words).
+ *
+ * The buffer must have at least the same length (number of bits) aas the
+ * state size for this key. The function uses the first @c stateSize bits
+ * of the input buffer, encrypts them and stores the result in the output
+ * buffer.
+ *
+ * The wordsize ist set to 64 bits.
+ *
+ * @param keyCtx
+ *     Pointer to a Threefish key structure.
+ * @param in
+ *     Poionter to cipher data buffer.
+ * @param out
+ *     Pointer to plaintext buffer.
+ */
+void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+				u64 *out);
+
+void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
+void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
+void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input,
+			u64 *output);
+void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
+void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
+void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input,
+			u64 *output);
+/**
+ * @}
+ */
+#endif

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
