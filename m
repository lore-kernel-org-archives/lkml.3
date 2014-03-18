Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbaCRViQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:38:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:33114 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751589AbaCRViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:38:11 -0400
Date: Tue, 18 Mar 2014 17:38:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.10.33-rt33
Message-ID: <20140318173808.046e59bc@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.10.33-rt33 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.10-rt
  Head SHA1: bd9f4cee1cdf95e7c0c969fefc7b0e4e5381f28b


Or to build 3.10.33-rt33 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.33.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.33-rt33.patch.xz



You can also build from 3.10.33-rt32 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.33-rt32-rt33.patch.xz



Enjoy,

-- Steve


Changes from v3.10.33-rt32:

---

Marc Kleine-Budde (1):
      net: sched: dev_deactivate_many(): use msleep(1) instead of yield() to wait for outstanding qdisc_run calls

Sebastian Andrzej Siewior (2):
      fs: jbd2: pull your plug when waiting for space
      crypto: Reduce preempt disabled regions, more algos

Steven Rostedt (1):
      cpu_chill: Add a UNINTERRUPTIBLE hrtimer_nanosleep

Steven Rostedt (Red Hat) (1):
      Linux 3.10.33-rt33

----
 arch/x86/crypto/cast5_avx_glue.c | 21 +++++++++------------
 arch/x86/crypto/glue_helper.c    | 31 +++++++++++++++----------------
 fs/jbd2/checkpoint.c             |  2 ++
 kernel/hrtimer.c                 | 25 ++++++++++++++++++-------
 localversion-rt                  |  2 +-
 net/sched/sch_generic.c          |  2 +-
 6 files changed, 46 insertions(+), 37 deletions(-)
---------------------------
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
 
@@ -231,7 +230,7 @@ done:
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
 
@@ -315,7 +313,7 @@ done:
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
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index c78841e..a4d273b 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -125,6 +125,8 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 		if (journal->j_flags & JBD2_ABORT)
 			return;
 		write_unlock(&journal->j_state_lock);
+		if (current->plug)
+			io_schedule();
 		mutex_lock(&journal->j_checkpoint_mutex);
 
 		/*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index eb4c8831c..5291a50 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1766,12 +1766,13 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
 
-static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
+static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode,
+				unsigned long state)
 {
 	hrtimer_init_sleeper(t, current);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(state);
 		hrtimer_start_expires(&t->timer, mode);
 		if (!hrtimer_active(&t->timer))
 			t->task = NULL;
@@ -1815,7 +1816,8 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 				HRTIMER_MODE_ABS);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 
-	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
+	/* cpu_chill() does not care about restart state. */
+	if (do_nanosleep(&t, HRTIMER_MODE_ABS, TASK_INTERRUPTIBLE))
 		goto out;
 
 	rmtp = restart->nanosleep.rmtp;
@@ -1832,8 +1834,10 @@ out:
 	return ret;
 }
 
-long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
-		       const enum hrtimer_mode mode, const clockid_t clockid)
+static long
+__hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
+		    const enum hrtimer_mode mode, const clockid_t clockid,
+		    unsigned long state)
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
@@ -1846,7 +1850,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
-	if (do_nanosleep(&t, mode))
+	if (do_nanosleep(&t, mode, state))
 		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
@@ -1873,6 +1877,12 @@ out:
 	return ret;
 }
 
+long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
+		       const enum hrtimer_mode mode, const clockid_t clockid)
+{
+	return __hrtimer_nanosleep(rqtp, rmtp, mode, clockid, TASK_INTERRUPTIBLE);
+}
+
 SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 		struct timespec __user *, rmtp)
 {
@@ -1899,7 +1909,8 @@ void cpu_chill(void)
 	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
 
 	current->flags |= PF_NOFREEZE;
-	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	__hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC,
+			    TASK_UNINTERRUPTIBLE);
 	if (!freeze_flag)
 		current->flags &= ~PF_NOFREEZE;
 }
diff --git a/localversion-rt b/localversion-rt
index ce6a482..e1d8362 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt32
+-rt33
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a7f838b..f84e69f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -839,7 +839,7 @@ void dev_deactivate_many(struct list_head *head)
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, unreg_list)
 		while (some_qdisc_is_busy(dev))
-			yield();
+			msleep(1);
 }
 
 void dev_deactivate(struct net_device *dev)
