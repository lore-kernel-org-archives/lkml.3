Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaBWSrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 13:47:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:51652 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaBWSra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 13:47:30 -0500
Date: Sun, 23 Feb 2014 19:47:27 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.12-rt19
Message-ID: <20140223184727.GA12442@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.12-rt19 patch set.

Changes since v3.12.12-rt18
- fix of a newly introduced compiler warning in "hwlatdetect" due to the
  checkpatch cleanup. Spotted by Mike and now gone.
- since we use hrtimer in cpu_chill() we migh see a warning if we call
  cpu_chill() with locks hold. The current workaround is to disable the
  freezer while calling hrtimer_nanosleep(). This warning did not happen
  with the msleep() version because it did not invoke the freezer.
- Don Estabrook reported a problem where the migrate counter were not
  getting back to zero properly. The problem was specific to x86's AVX
  crypto driver and has been fixed by makeing the "fpu disable" smaller.

Known issues:

      - bcache is disabled.

The delta patch against v3.12.12-rt18 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.12-rt18-rt19.patch.xz

The RT patch against 3.12.12 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.12-rt19.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.12-rt19.tar.xz

Sebastian

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
diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index 577092b3a..2429c43 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -615,7 +615,7 @@ static ssize_t  debug_enable_fwrite(struct file *filp,
 		return -EFAULT;
 
 	buf[sizeof(buf)-1] = '\0';			/* just in case */
-	err = kstrtoull(buf, 10, &val);
+	err = kstrtoul(buf, 10, &val);
 	if (0 != err)
 		return -EINVAL;
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5c26d2c..083815d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1899,8 +1899,12 @@ void cpu_chill(void)
 	struct timespec tu = {
 		.tv_nsec = NSEC_PER_MSEC,
 	};
+	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
 
+	current->flags |= PF_NOFREEZE;
 	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	if (!freeze_flag)
+		current->flags &= ~PF_NOFREEZE;
 }
 EXPORT_SYMBOL(cpu_chill);
 #endif
diff --git a/localversion-rt b/localversion-rt
index 9e7cd66..483ad77 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt18
+-rt19
