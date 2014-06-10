Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947AbaFJDrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:47:35 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52125 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775AbaFJDrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:47:33 -0400
Message-ID: <1402372048.5124.20.camel@marge.simpson.net>
Subject: [RFC PATCH V2] rt/aio: fix rcu garbage collection might_sleep()
 splat
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Date: Tue, 10 Jun 2014 05:47:28 +0200
In-Reply-To: <5395172E.4010007@cn.fujitsu.com>
References: <1402216538.31630.7.camel@marge.simpson.net>
	 <5395172E.4010007@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 10:08 +0800, Lai Jiangshan wrote: 
> Hi, rt-people
> 
> I don't think it is the correct direction.
> Softirq (including local_bh_disable()) in RT kernel should be preemptible.

How about the below then?

I was sorely tempted to post a tiny variant that dropped taking ctx_lock
in free_ioctx_users() entirely, as someone diddling with no reference
didn't make sense.  Cc Ben, he would know.

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

ref->release() path can't take sleeping locks, but in an rt kernel it does.
Defer ->release() work via call_rcu() to move sleeping locks out from under
rcu_read_lock_sched().

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
---
 fs/aio.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -110,8 +110,6 @@ struct kioctx {
 	struct page		**ring_pages;
 	long			nr_pages;
 
-	struct work_struct	free_work;
-
 	struct {
 		/*
 		 * This counts the number of available slots in the ringbuffer,
@@ -143,6 +141,7 @@ struct kioctx {
 	struct file		*aio_ring_file;
 
 	unsigned		id;
+	struct rcu_head		rcu;
 };
 
 /*------ sysctl variables----*/
@@ -493,9 +492,9 @@ static int kiocb_cancel(struct kioctx *c
 	return cancel(kiocb);
 }
 
-static void free_ioctx(struct work_struct *work)
+static void free_ioctx_rcu(struct rcu_head *rcu)
 {
-	struct kioctx *ctx = container_of(work, struct kioctx, free_work);
+	struct kioctx *ctx = container_of(rcu, struct kioctx, rcu);
 
 	pr_debug("freeing %p\n", ctx);
 
@@ -508,18 +507,12 @@ static void free_ioctx_reqs(struct percp
 {
 	struct kioctx *ctx = container_of(ref, struct kioctx, reqs);
 
-	INIT_WORK(&ctx->free_work, free_ioctx);
-	schedule_work(&ctx->free_work);
+	call_rcu(&ctx->rcu, free_ioctx_rcu);
 }
 
-/*
- * When this function runs, the kioctx has been removed from the "hash table"
- * and ctx->users has dropped to 0, so we know no more kiocbs can be submitted -
- * now it's safe to cancel any that need to be.
- */
-static void free_ioctx_users(struct percpu_ref *ref)
+static void free_ioctx_users_rcu(struct rcu_head *rcu)
 {
-	struct kioctx *ctx = container_of(ref, struct kioctx, users);
+	struct kioctx *ctx = container_of(rcu, struct kioctx, rcu);
 	struct kiocb *req;
 
 	spin_lock_irq(&ctx->ctx_lock);
@@ -538,6 +531,25 @@ static void free_ioctx_users(struct perc
 	percpu_ref_put(&ctx->reqs);
 }
 
+/*
+ * When this function runs, the kioctx has been removed from the "hash table"
+ * and ctx->users has dropped to 0, so we know no more kiocbs can be submitted -
+ * now it's safe to cancel any that need to be.
+ *
+ * NOTE: -rt must defer this to avoid taking sleeping ctx_lock while under
+ * rcu_real_lock_sched() during ->release().
+ */
+static void free_ioctx_users(struct percpu_ref *ref)
+{
+	struct kioctx *ctx = container_of(ref, struct kioctx, users);
+
+#ifdef CONFIG_PREEMPT_RT_BASE
+	call_rcu(&ctx->rcu, free_ioctx_users_rcu);
+#else
+	free_ioctx_users_rcu(&ctx->rcu);
+#endif
+}
+
 static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 {
 	unsigned i, new_nr;



