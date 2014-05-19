Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaESXrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:47:09 -0400
Received: from tex.lwn.net ([70.33.254.29]:58511 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaESXrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:47:08 -0400
Date: Mon, 19 May 2014 17:48:24 -0600
From: Jake Edge <jake@lwn.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Cooper <jason@lakedaemon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Saraev <antonysaraev@gmail.com>
Subject: [PATCH v3 1/1] staging/skein: rename files and clean up directory
 structure
Message-ID: <20140519174824.062bcf53@chukar.edge2.net>
In-Reply-To: <20140519222224.GA9907@kroah.com>
References: <20140518125615.2df48ea9@chukar.edge2.net>
	<20140519222224.GA9907@kroah.com>
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

v3: against staging-next branch of staging tree
v2: use git format-patch -M as suggested by Joe Perches

 drivers/staging/skein/Makefile                     |  12 +-
 drivers/staging/skein/TODO                         |   1 -
 drivers/staging/skein/skein.c                      |   6 +-
 drivers/staging/skein/{include => }/skein.h        |   0
 drivers/staging/skein/skeinBlockNo3F.c             | 175 ---------------------
 drivers/staging/skein/{skeinApi.c => skein_api.c}  |   2 +-
 .../skein/{include/skeinApi.h => skein_api.h}      |   6 +-
 drivers/staging/skein/skein_block.c                |   2 +-
 drivers/staging/skein/{include => }/skein_block.h  |   2 +-
 drivers/staging/skein/{include => }/skein_iv.h     |   2 +-
 ...threefish1024Block.c => threefish_1024_block.c} |   2 +-
 .../{threefish256Block.c => threefish_256_block.c} |   2 +-
 .../{threefish512Block.c => threefish_512_block.c} |   2 +-
 .../skein/{threefishApi.c => threefish_api.c}      |   4 +-
 .../{include/threefishApi.h => threefish_api.h}    |   4 +-
 15 files changed, 21 insertions(+), 201 deletions(-)
 rename drivers/staging/skein/{include => }/skein.h (100%)
 delete mode 100644 drivers/staging/skein/skeinBlockNo3F.c
 rename drivers/staging/skein/{skeinApi.c => skein_api.c} (99%)
 rename drivers/staging/skein/{include/skeinApi.h => skein_api.h} (99%)
 rename drivers/staging/skein/{include => }/skein_block.h (92%)
 rename drivers/staging/skein/{include => }/skein_iv.h (98%)
 rename drivers/staging/skein/{threefish1024Block.c => threefish_1024_block.c} (99%)
 rename drivers/staging/skein/{threefish256Block.c => threefish_256_block.c} (99%)
 rename drivers/staging/skein/{threefish512Block.c => threefish_512_block.c} (99%)
 rename drivers/staging/skein/{threefishApi.c => threefish_api.c} (98%)
 rename drivers/staging/skein/{include/threefishApi.h => threefish_api.h} (99%)

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
index 88a6e81..cd3508d 100644
--- a/drivers/staging/skein/TODO
+++ b/drivers/staging/skein/TODO
@@ -1,6 +1,5 @@
 skein/threefish TODO
 
- - rename files
  - move macros into appropriate header files
  - add / pass test vectors
  - module support
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 2a2da98..f76d585 100644
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
diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/skein.h
similarity index 100%
rename from drivers/staging/skein/include/skein.h
rename to drivers/staging/skein/skein.h
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
deleted file mode 100644
index 4ee7f9f..0000000
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
-void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
-			     size_t blk_cnt, size_t byte_cnt_add)
-{
-	struct threefish_key key;
-	u64 tweak[2];
-	int i;
-	u64 w[SKEIN_256_STATE_WORDS]; /* local copy of input block */
-	u64 words[3];
-
-	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
-	tweak[0] = ctx->h.T[0];
-	tweak[1] = ctx->h.T[1];
-
-	do  {
-		u64 carry = byte_cnt_add;
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
-		threefish_set_key(&key, THREEFISH_256, ctx->X, tweak);
-
-		/* get input block in little-endian format */
-		skein_get64_lsb_first(w, blk_ptr, SKEIN_256_STATE_WORDS);
-
-		threefish_encrypt_block_words(&key, w, ctx->X);
-
-		blk_ptr += SKEIN_256_BLOCK_BYTES;
-
-		/* do the final "feedforward" xor, update ctx chaining vars */
-		ctx->X[0] = ctx->X[0] ^ w[0];
-		ctx->X[1] = ctx->X[1] ^ w[1];
-		ctx->X[2] = ctx->X[2] ^ w[2];
-		ctx->X[3] = ctx->X[3] ^ w[3];
-
-		tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blk_cnt);
-
-	ctx->h.T[0] = tweak[0];
-	ctx->h.T[1] = tweak[1];
-}
-
-void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
-			     size_t blk_cnt, size_t byte_cnt_add)
-{
-	struct threefish_key key;
-	u64 tweak[2];
-	int i;
-	u64 words[3];
-	u64 w[SKEIN_512_STATE_WORDS]; /* local copy of input block */
-
-	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
-	tweak[0] = ctx->h.T[0];
-	tweak[1] = ctx->h.T[1];
-
-	do  {
-		u64 carry = byte_cnt_add;
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
-		threefish_set_key(&key, THREEFISH_512, ctx->X, tweak);
-
-		/* get input block in little-endian format */
-		skein_get64_lsb_first(w, blk_ptr, SKEIN_512_STATE_WORDS);
-
-		threefish_encrypt_block_words(&key, w, ctx->X);
-
-		blk_ptr += SKEIN_512_BLOCK_BYTES;
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
-	} while (--blk_cnt);
-
-	ctx->h.T[0] = tweak[0];
-	ctx->h.T[1] = tweak[1];
-}
-
-void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
-			      size_t blk_cnt, size_t byte_cnt_add)
-{
-	struct threefish_key key;
-	u64 tweak[2];
-	int i;
-	u64 words[3];
-	u64 w[SKEIN_1024_STATE_WORDS]; /* local copy of input block */
-
-	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
-	tweak[0] = ctx->h.T[0];
-	tweak[1] = ctx->h.T[1];
-
-	do  {
-		u64 carry = byte_cnt_add;
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
-		threefish_set_key(&key, THREEFISH_1024, ctx->X, tweak);
-
-		/* get input block in little-endian format */
-		skein_get64_lsb_first(w, blk_ptr, SKEIN_1024_STATE_WORDS);
-
-		threefish_encrypt_block_words(&key, w, ctx->X);
-
-		blk_ptr += SKEIN_1024_BLOCK_BYTES;
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
-	} while (--blk_cnt);
-
-	ctx->h.T[0] = tweak[0];
-	ctx->h.T[1] = tweak[1];
-}
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skein_api.c
similarity index 99%
rename from drivers/staging/skein/skeinApi.c
rename to drivers/staging/skein/skein_api.c
index 16d596b..eaf7af4 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skein_api.c
@@ -25,7 +25,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 */
 
 #include <linux/string.h>
-#include <skeinApi.h>
+#include "skein_api.h"
 
 int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
 {
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/skein_api.h
similarity index 99%
rename from drivers/staging/skein/include/skeinApi.h
rename to drivers/staging/skein/skein_api.h
index b4e879d..db808ae 100644
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/skein_api.h
@@ -28,7 +28,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 #define SKEINAPI_H
 
 /**
- * @file skeinApi.h
+ * @file skein_api.h
  * @brief A Skein API and its functions.
  * @{
  *
@@ -44,7 +44,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  *
  * @code
  *
- * #include <skeinApi.h>
+ * #include "skein_api.h"
  *
  * ...
  * struct skein_ctx ctx;             // a Skein hash or MAC context
@@ -79,7 +79,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  */
 
 #include <linux/types.h>
-#include <skein.h>
+#include "skein.h"
 
 /**
  * Which Skein size to use
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 7b66ec5..76c4113e 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -15,7 +15,7 @@
 ************************************************************************/
 
 #include <linux/string.h>
-#include <skein.h>
+#include "skein.h"
 
 #ifndef SKEIN_USE_ASM
 #define SKEIN_USE_ASM   (0) /* default is all C code (no ASM) */
diff --git a/drivers/staging/skein/include/skein_block.h b/drivers/staging/skein/skein_block.h
similarity index 92%
rename from drivers/staging/skein/include/skein_block.h
rename to drivers/staging/skein/skein_block.h
index a8dd083..bd7bdc3 100644
--- a/drivers/staging/skein/include/skein_block.h
+++ b/drivers/staging/skein/skein_block.h
@@ -10,7 +10,7 @@
 #ifndef _SKEIN_BLOCK_H_
 #define _SKEIN_BLOCK_H_
 
-#include <skein.h> /* get the Skein API definitions   */
+#include "skein.h" /* get the Skein API definitions   */
 
 void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 			     size_t blk_cnt, size_t byte_cnt_add);
diff --git a/drivers/staging/skein/include/skein_iv.h b/drivers/staging/skein/skein_iv.h
similarity index 98%
rename from drivers/staging/skein/include/skein_iv.h
rename to drivers/staging/skein/skein_iv.h
index 7ff93df..a03703d 100644
--- a/drivers/staging/skein/include/skein_iv.h
+++ b/drivers/staging/skein/skein_iv.h
@@ -1,7 +1,7 @@
 #ifndef _SKEIN_IV_H_
 #define _SKEIN_IV_H_
 
-#include <skein.h>    /* get Skein macros and types */
+#include "skein.h"    /* get Skein macros and types */
 
 /*
 ***************** Pre-computed Skein IVs *******************
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish_1024_block.c
similarity index 99%
rename from drivers/staging/skein/threefish1024Block.c
rename to drivers/staging/skein/threefish_1024_block.c
index 827ce1a..dac74e1 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish_1024_block.c
@@ -1,5 +1,5 @@
 #include <linux/string.h>
-#include <threefishApi.h>
+#include "threefish_api.h"
 
 
 void threefish_encrypt_1024(struct threefish_key *key_ctx, u64 *input,
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish_256_block.c
similarity index 99%
rename from drivers/staging/skein/threefish256Block.c
rename to drivers/staging/skein/threefish_256_block.c
index 1329c71..0b33b3f 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish_256_block.c
@@ -1,5 +1,5 @@
 #include <linux/string.h>
-#include <threefishApi.h>
+#include "threefish_api.h"
 
 
 void threefish_encrypt_256(struct threefish_key *key_ctx, u64 *input,
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish_512_block.c
similarity index 99%
rename from drivers/staging/skein/threefish512Block.c
rename to drivers/staging/skein/threefish_512_block.c
index db50d83..1c62bf6 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish_512_block.c
@@ -1,5 +1,5 @@
 #include <linux/string.h>
-#include <threefishApi.h>
+#include "threefish_api.h"
 
 
 void threefish_encrypt_512(struct threefish_key *key_ctx, u64 *input,
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefish_api.c
similarity index 98%
rename from drivers/staging/skein/threefishApi.c
rename to drivers/staging/skein/threefish_api.c
index 0ba42fa..2b649ab 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefish_api.c
@@ -1,7 +1,5 @@
-
-
 #include <linux/string.h>
-#include <threefishApi.h>
+#include "threefish_api.h"
 
 void threefish_set_key(struct threefish_key *key_ctx,
 		       enum threefish_size state_size,
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/threefish_api.h
similarity index 99%
rename from drivers/staging/skein/include/threefishApi.h
rename to drivers/staging/skein/threefish_api.h
index 96cc0e8..2fce154 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/threefish_api.h
@@ -3,7 +3,7 @@
 #define THREEFISHAPI_H
 
 /**
- * @file threefishApi.h
+ * @file threefish_api.h
  * @brief A Threefish cipher API and its functions.
  * @{
  *
@@ -29,7 +29,7 @@
  */
 
 #include <linux/types.h>
-#include <skein.h>
+#include "skein.h"
 
 #define KEY_SCHEDULE_CONST 0x1BD11BDAA9FC1A22L
 
-- 
1.8.4.5



-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
