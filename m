Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbaBUQgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:36:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:42030 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaBUQgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:36:44 -0500
Date: Fri, 21 Feb 2014 17:36:42 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Don Estabrook <don.estabrook@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RT] crypto: Reduce preempt disabled regions, more algos
Message-ID: <20140221163642.GB12822@linutronix.de>
References: <CABB1KXppwfeZ6ARsRB4qqi--63RpMjQW-fBoWrTbpXyPuEOi4g@mail.gmail.com>
 <alpine.DEB.2.02.1402132352020.21991@ionos.tec.linutronix.de>
 <CABB1KXpPB+zsEZZxwUWkKLA8OifCi6Qf1Q86x6o-bcLgKe8ysg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABB1KXpPB+zsEZZxwUWkKLA8OifCi6Qf1Q86x6o-bcLgKe8ysg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Estabrook reported
| kernel: WARNING: CPU: 2 PID: 858 at kernel/sched/core.c:2428 migrate_disable+0xed/0x100()
| kernel: WARNING: CPU: 2 PID: 858 at kernel/sched/core.c:2462 migrate_enable+0x17b/0x200()
| kernel: WARNING: CPU: 3 PID: 865 at kernel/sched/core.c:2428 migrate_disable+0xed/0x100()

and his backtrace showed some crypto functions which looked fine.

The problem is the following sequence:

glue_xts_crypt_128bit()
{
	blkcipher_walk_virt(); /* normal migrate_disable() */

	glue_fpu_begin(); /* get atomic */

	while (nbytes) {
		__glue_xts_crypt_128bit();
		blkcipher_walk_done(); /* with nbytes = 0, migrate_enable()
					* while we are atomic */
	};
	glue_fpu_end() /* no longer atomic */
}

and this is why the counter get out of sync and the warning is printed.
The other problem is that we are non-preemptible between
glue_fpu_begin() and glue_fpu_end() and the latency grows. To fix this,
I shorten the FPU off region and ensure blkcipher_walk_done() is called
with preemption enabled. This might hurt the performance because we now
enable/disable the FPU state more often but we gain lower latency and
the bug is gone.

Reported-by: Don Estabrook <don.estabrook@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/crypto/cast5_avx_glue.c | 21 +++++++++------------
 arch/x86/crypto/glue_helper.c    | 31 +++++++++++++++----------------
 2 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index c663181..2d48e83 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -60,7 +60,7 @@ static inline void cast5_fpu_end(bool fpu_enabled)
 static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
 		     bool enc)
 {
-	bool fpu_enabled = false;
+	bool fpu_enabled;
 	struct cast5_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	const unsigned int bsize = CAST5_BLOCK_SIZE;
 	unsigned int nbytes;
@@ -76,7 +76,7 @@ static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
 		u8 *wsrc = walk->src.virt.addr;
 		u8 *wdst = walk->dst.virt.addr;
 
-		fpu_enabled = cast5_fpu_begin(fpu_enabled, nbytes);
+		fpu_enabled = cast5_fpu_begin(false, nbytes);
 
 		/* Process multi-block batch */
 		if (nbytes >= bsize * CAST5_PARALLEL_BLOCKS) {
@@ -104,10 +104,9 @@ static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
 		} while (nbytes >= bsize);
 
 done:
+		cast5_fpu_end(fpu_enabled);
 		err = blkcipher_walk_done(desc, walk, nbytes);
 	}
-
-	cast5_fpu_end(fpu_enabled);
 	return err;
 }
 
@@ -231,7 +230,7 @@ static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
 static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
-	bool fpu_enabled = false;
+	bool fpu_enabled;
 	struct blkcipher_walk walk;
 	int err;
 
@@ -240,12 +239,11 @@ static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	while ((nbytes = walk.nbytes)) {
-		fpu_enabled = cast5_fpu_begin(fpu_enabled, nbytes);
+		fpu_enabled = cast5_fpu_begin(false, nbytes);
 		nbytes = __cbc_decrypt(desc, &walk);
+		cast5_fpu_end(fpu_enabled);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
-
-	cast5_fpu_end(fpu_enabled);
 	return err;
 }
 
@@ -315,7 +313,7 @@ static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
 static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		     struct scatterlist *src, unsigned int nbytes)
 {
-	bool fpu_enabled = false;
+	bool fpu_enabled;
 	struct blkcipher_walk walk;
 	int err;
 
@@ -324,13 +322,12 @@ static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	while ((nbytes = walk.nbytes) >= CAST5_BLOCK_SIZE) {
-		fpu_enabled = cast5_fpu_begin(fpu_enabled, nbytes);
+		fpu_enabled = cast5_fpu_begin(false, nbytes);
 		nbytes = __ctr_crypt(desc, &walk);
+		cast5_fpu_end(fpu_enabled);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	cast5_fpu_end(fpu_enabled);
-
 	if (walk.nbytes) {
 		ctr_crypt_final(desc, &walk);
 		err = blkcipher_walk_done(desc, &walk, 0);
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 432f1d76..4a2bd21 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -39,7 +39,7 @@ static int __glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
 	void *ctx = crypto_blkcipher_ctx(desc->tfm);
 	const unsigned int bsize = 128 / 8;
 	unsigned int nbytes, i, func_bytes;
-	bool fpu_enabled = false;
+	bool fpu_enabled;
 	int err;
 
 	err = blkcipher_walk_virt(desc, walk);
@@ -49,7 +49,7 @@ static int __glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
 		u8 *wdst = walk->dst.virt.addr;
 
 		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     desc, fpu_enabled, nbytes);
+					     desc, false, nbytes);
 
 		for (i = 0; i < gctx->num_funcs; i++) {
 			func_bytes = bsize * gctx->funcs[i].num_blocks;
@@ -71,10 +71,10 @@ static int __glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
 		}
 
 done:
+		glue_fpu_end(fpu_enabled);
 		err = blkcipher_walk_done(desc, walk, nbytes);
 	}
 
-	glue_fpu_end(fpu_enabled);
 	return err;
 }
 
@@ -194,7 +194,7 @@ int glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
 			    struct scatterlist *src, unsigned int nbytes)
 {
 	const unsigned int bsize = 128 / 8;
-	bool fpu_enabled = false;
+	bool fpu_enabled;
 	struct blkcipher_walk walk;
 	int err;
 
@@ -203,12 +203,12 @@ int glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
 
 	while ((nbytes = walk.nbytes)) {
 		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     desc, fpu_enabled, nbytes);
+					     desc, false, nbytes);
 		nbytes = __glue_cbc_decrypt_128bit(gctx, desc, &walk);
+		glue_fpu_end(fpu_enabled);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	glue_fpu_end(fpu_enabled);
 	return err;
 }
 EXPORT_SYMBOL_GPL(glue_cbc_decrypt_128bit);
@@ -278,7 +278,7 @@ int glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
 			  struct scatterlist *src, unsigned int nbytes)
 {
 	const unsigned int bsize = 128 / 8;
-	bool fpu_enabled = false;
+	bool fpu_enabled;
 	struct blkcipher_walk walk;
 	int err;
 
@@ -287,13 +287,12 @@ int glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
 
 	while ((nbytes = walk.nbytes) >= bsize) {
 		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     desc, fpu_enabled, nbytes);
+					     desc, false, nbytes);
 		nbytes = __glue_ctr_crypt_128bit(gctx, desc, &walk);
+		glue_fpu_end(fpu_enabled);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	glue_fpu_end(fpu_enabled);
-
 	if (walk.nbytes) {
 		glue_ctr_crypt_final_128bit(
 			gctx->funcs[gctx->num_funcs - 1].fn_u.ctr, desc, &walk);
@@ -348,7 +347,7 @@ int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 			  void *tweak_ctx, void *crypt_ctx)
 {
 	const unsigned int bsize = 128 / 8;
-	bool fpu_enabled = false;
+	bool fpu_enabled;
 	struct blkcipher_walk walk;
 	int err;
 
@@ -361,21 +360,21 @@ int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 
 	/* set minimum length to bsize, for tweak_fn */
 	fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-				     desc, fpu_enabled,
+				     desc, false,
 				     nbytes < bsize ? bsize : nbytes);
-
 	/* calculate first value of T */
 	tweak_fn(tweak_ctx, walk.iv, walk.iv);
+	glue_fpu_end(fpu_enabled);
 
 	while (nbytes) {
+		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+				desc, false, nbytes);
 		nbytes = __glue_xts_crypt_128bit(gctx, crypt_ctx, desc, &walk);
 
+		glue_fpu_end(fpu_enabled);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 		nbytes = walk.nbytes;
 	}
-
-	glue_fpu_end(fpu_enabled);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit);
-- 
1.9.0.rc3

