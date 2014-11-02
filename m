Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaKBHbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:31:37 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:63320 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaKBHbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:31:33 -0500
Message-ID: <1414913488.5380.115.camel@marge.simpson.net>
Subject: 3.14.23-rt20 - aio: fix rcu garbage collection might_sleep() splat
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Sun, 02 Nov 2014 08:31:28 +0100
In-Reply-To: <1414910967.5380.81.camel@marge.simpson.net>
References: <20141031170326.1491a63f@gandalf.local.home>
	 <1414910967.5380.81.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(not pretty)

[  172.743098] BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:768
[  172.743116] in_atomic(): 1, irqs_disabled(): 0, pid: 26, name: rcuos/2
[  172.743117] 2 locks held by rcuos/2/26:
[  172.743128]  #0:  (rcu_callback){.+.+..}, at: [<ffffffff810b1a12>] rcu_nocb_kthread+0x1e2/0x380
[  172.743135]  #1:  (rcu_read_lock_sched){.+.+..}, at: [<ffffffff812acd26>] percpu_ref_kill_rcu+0xa6/0x1c0
[  172.743138] Preemption disabled at:[<ffffffff810b1a93>] rcu_nocb_kthread+0x263/0x380
[  172.743138]
[  172.743142] CPU: 0 PID: 26 Comm: rcuos/2 Not tainted 3.14.4-rt5 #31
[  172.743143] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[  172.743148]  ffff8802231aa190 ffff8802231a5d08 ffffffff81582e9e 0000000000000000
[  172.743151]  ffff8802231a5d28 ffffffff81077aeb ffff880209f68140 ffff880209f681c0
[  172.743154]  ffff8802231a5d48 ffffffff81589304 ffff880209f68000 ffff880209f68000
[  172.743155] Call Trace:
[  172.743160]  [<ffffffff81582e9e>] dump_stack+0x4e/0x9c
[  172.743163]  [<ffffffff81077aeb>] __might_sleep+0xfb/0x170
[  172.743167]  [<ffffffff81589304>] rt_spin_lock+0x24/0x70
[  172.743171]  [<ffffffff811c5790>] free_ioctx_users+0x30/0x130
[  172.743174]  [<ffffffff812ace34>] percpu_ref_kill_rcu+0x1b4/0x1c0
[  172.743177]  [<ffffffff812acd26>] ? percpu_ref_kill_rcu+0xa6/0x1c0
[  172.743180]  [<ffffffff812acc80>] ? percpu_ref_kill_and_confirm+0x70/0x70
[  172.743183]  [<ffffffff810b1a93>] rcu_nocb_kthread+0x263/0x380
[  172.743185]  [<ffffffff810b1a12>] ? rcu_nocb_kthread+0x1e2/0x380
[  172.743189]  [<ffffffff810b1830>] ? rcu_report_exp_rnp.isra.52+0xc0/0xc0
[  172.743192]  [<ffffffff8106e046>] kthread+0xd6/0xf0
[  172.743194]  [<ffffffff8158900c>] ? _raw_spin_unlock_irq+0x2c/0x70
[  172.743197]  [<ffffffff8106df70>] ? __kthread_parkme+0x70/0x70
[  172.743200]  [<ffffffff81591eec>] ret_from_fork+0x7c/0xb0
[  172.743203]  [<ffffffff8106df70>] ? __kthread_parkme+0x70/0x70

crash> gdb list *percpu_ref_kill_rcu+0x1b4
0xffffffff812ace34 is in percpu_ref_kill_rcu (include/linux/percpu-refcount.h:169).
164             pcpu_count = ACCESS_ONCE(ref->pcpu_count);
165
166             if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
167                     __this_cpu_dec(*pcpu_count);
168             else if (unlikely(atomic_dec_and_test(&ref->count)))
169                     ref->release(ref);
170
171             rcu_read_unlock_sched();
172     }
173

Ok, so ->release() can't do anything where it may meet a sleeping lock,
but in an -rt kernel, it does that.

Convert struct kioctx ctx_lock/completion_lock to raw_spinlock_t, and
defer final free to a time when we're not under rcu_read_lock_sched().

runltp -f ltp-aio-stress.part1 runs kernel/ltp gripe free.

INFO: ltp-pan reported all tests PASS
LTP Version: 20140422

       ###############################################################

            Done executing testcases.
            LTP Version:  20140422
       ###############################################################


Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
---
 fs/aio.c |   65 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 19 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -130,7 +130,7 @@ struct kioctx {
 	} ____cacheline_aligned_in_smp;
 
 	struct {
-		spinlock_t	ctx_lock;
+		raw_spinlock_t	ctx_lock;
 		struct list_head active_reqs;	/* used for cancellation */
 	} ____cacheline_aligned_in_smp;
 
@@ -142,13 +142,16 @@ struct kioctx {
 	struct {
 		unsigned	tail;
 		unsigned	completed_events;
-		spinlock_t	completion_lock;
+		raw_spinlock_t	completion_lock;
 	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
 	struct file		*aio_ring_file;
 
 	unsigned		id;
+#ifdef CONFIG_PREEMPT_RT_BASE
+	struct rcu_head		rcu;
+#endif
 };
 
 /*------ sysctl variables----*/
@@ -340,11 +343,11 @@ static int aio_migratepage(struct addres
 	 * while the old page is copied to the new.  This prevents new
 	 * events from being lost.
 	 */
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	raw_spin_lock_irqsave(&ctx->completion_lock, flags);
 	migrate_page_copy(new, old);
 	BUG_ON(ctx->ring_pages[idx] != old);
 	ctx->ring_pages[idx] = new;
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	raw_spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	/* The old page is no longer accessible. */
 	put_page(old);
@@ -467,14 +470,14 @@ void kiocb_set_cancel_fn(struct kiocb *r
 	struct kioctx *ctx = req->ki_ctx;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
+	raw_spin_lock_irqsave(&ctx->ctx_lock, flags);
 
 	if (!req->ki_list.next)
 		list_add(&req->ki_list, &ctx->active_reqs);
 
 	req->ki_cancel = cancel;
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	raw_spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
@@ -499,6 +502,7 @@ static int kiocb_cancel(struct kioctx *c
 	return cancel(kiocb);
 }
 
+#ifndef CONFIG_PREEMPT_RT_BASE
 static void free_ioctx(struct work_struct *work)
 {
 	struct kioctx *ctx = container_of(work, struct kioctx, free_work);
@@ -509,6 +513,18 @@ static void free_ioctx(struct work_struc
 	free_percpu(ctx->cpu);
 	kmem_cache_free(kioctx_cachep, ctx);
 }
+#else
+static void free_ioctx_rcu(struct rcu_head *rcu)
+{
+	struct kioctx *ctx = container_of(rcu, struct kioctx, rcu);
+
+	pr_debug("freeing %p\n", ctx);
+
+	aio_free_ring(ctx);
+	free_percpu(ctx->cpu);
+	kmem_cache_free(kioctx_cachep, ctx);
+}
+#endif
 
 static void free_ioctx_reqs(struct percpu_ref *ref)
 {
@@ -518,8 +534,19 @@ static void free_ioctx_reqs(struct percp
 	if (ctx->requests_done)
 		complete(ctx->requests_done);
 
+#ifndef CONFIG_PREEMPT_RT_BASE
 	INIT_WORK(&ctx->free_work, free_ioctx);
 	schedule_work(&ctx->free_work);
+#else
+	/*
+	 * We're in ->release() under rcu_read_lock_sched(), and can't do
+	 * anything that requires taking a sleeping lock, so ->release()
+	 * becomes a two stage rcu process for -rt.  We've now done the
+	 * rcu work that we can under locks made raw to get us this far.
+	 * Defer the freeing bit until we're again allowed to schedule().
+	 */
+	call_rcu(&ctx->rcu, free_ioctx_rcu);
+#endif
 }
 
 /*
@@ -532,7 +559,7 @@ static void free_ioctx_users(struct perc
 	struct kioctx *ctx = container_of(ref, struct kioctx, users);
 	struct kiocb *req;
 
-	spin_lock_irq(&ctx->ctx_lock);
+	raw_spin_lock_irq(&ctx->ctx_lock);
 
 	while (!list_empty(&ctx->active_reqs)) {
 		req = list_first_entry(&ctx->active_reqs,
@@ -542,7 +569,7 @@ static void free_ioctx_users(struct perc
 		kiocb_cancel(ctx, req);
 	}
 
-	spin_unlock_irq(&ctx->ctx_lock);
+	raw_spin_unlock_irq(&ctx->ctx_lock);
 
 	percpu_ref_kill(&ctx->reqs);
 	percpu_ref_put(&ctx->reqs);
@@ -655,8 +682,8 @@ static struct kioctx *ioctx_alloc(unsign
 
 	ctx->max_reqs = nr_events;
 
-	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->completion_lock);
+	raw_spin_lock_init(&ctx->ctx_lock);
+	raw_spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
 	/* Protect against page migration throughout kiotx setup by keeping
 	 * the ring_lock mutex held until setup is complete. */
@@ -925,7 +952,7 @@ static void refill_reqs_available(struct
  */
 static void user_refill_reqs_available(struct kioctx *ctx)
 {
-	spin_lock_irq(&ctx->completion_lock);
+	raw_spin_lock_irq(&ctx->completion_lock);
 	if (ctx->completed_events) {
 		struct aio_ring *ring;
 		unsigned head;
@@ -946,7 +973,7 @@ static void user_refill_reqs_available(s
 		refill_reqs_available(ctx, head, ctx->tail);
 	}
 
-	spin_unlock_irq(&ctx->completion_lock);
+	raw_spin_unlock_irq(&ctx->completion_lock);
 }
 
 /* aio_get_req
@@ -1041,9 +1068,9 @@ void aio_complete(struct kiocb *iocb, lo
 	if (iocb->ki_list.next) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		raw_spin_lock_irqsave(&ctx->ctx_lock, flags);
 		list_del(&iocb->ki_list);
-		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+		raw_spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	}
 
 	/*
@@ -1051,7 +1078,7 @@ void aio_complete(struct kiocb *iocb, lo
 	 * ctx->completion_lock to prevent other code from messing with the tail
 	 * pointer since we might be called from irq context.
 	 */
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	raw_spin_lock_irqsave(&ctx->completion_lock, flags);
 
 	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
@@ -1090,7 +1117,7 @@ void aio_complete(struct kiocb *iocb, lo
 	ctx->completed_events++;
 	if (ctx->completed_events > 1)
 		refill_reqs_available(ctx, head, tail);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	raw_spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
@@ -1631,7 +1658,7 @@ static struct kiocb *lookup_kiocb(struct
 {
 	struct list_head *pos;
 
-	assert_spin_locked(&ctx->ctx_lock);
+	assert_raw_spin_locked(&ctx->ctx_lock);
 
 	if (key != KIOCB_KEY)
 		return NULL;
@@ -1671,7 +1698,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 	if (unlikely(!ctx))
 		return -EINVAL;
 
-	spin_lock_irq(&ctx->ctx_lock);
+	raw_spin_lock_irq(&ctx->ctx_lock);
 
 	kiocb = lookup_kiocb(ctx, iocb, key);
 	if (kiocb)
@@ -1679,7 +1706,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 	else
 		ret = -EINVAL;
 
-	spin_unlock_irq(&ctx->ctx_lock);
+	raw_spin_unlock_irq(&ctx->ctx_lock);
 
 	if (!ret) {
 		/*




