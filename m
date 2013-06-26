Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3FZTcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:32:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7114 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3FZTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:30:52 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tPtYYTgkgQQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=c8ecVOARZQgA:10 a=P9ME-VCzj2TN5FCwCKcA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130626193050.204328035@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 26 Jun 2013 15:28:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH RT 4/6] rt,workqueue: Add local_lock_irq() call to put_pwq_unlocked()
References: <20130626192806.107564905@goodmis.org>
Content-Disposition: inline; filename=workqueue-recursive-locallock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitting the following lockdep splat:

[    5.272234] ======================================================
[    5.272234] [ INFO: possible circular locking dependency detected ]
[    5.272237] 3.10.0-rc7-test-rt10+ #58 Not tainted
[    5.272237] -------------------------------------------------------
[    5.272238] umount/413 is trying to acquire lock:
[    5.272247]  ((pendingb_lock).lock#7){+.+...}, at: [<ffffffff8106d5e6>] queue_work_on+0x76/0x1d0
[    5.272248] 
[    5.272248] but task is already holding lock:
[    5.272252]  (&pool->lock/1){+.+...}, at: [<ffffffff8106d803>] put_pwq_unlocked+0x23/0x40
[    5.272252] 
[    5.272252] which lock already depends on the new lock.
[    5.272252] 
[    5.272253] 
[    5.272253] the existing dependency chain (in reverse order) is:
[    5.272255] 
[    5.272255] -> #1 (&pool->lock/1){+.+...}:
[    5.272259]        [<ffffffff810b6817>] lock_acquire+0x87/0x150
[    5.272265]        [<ffffffff81665467>] rt_spin_lock+0x47/0x60
[    5.272267]        [<ffffffff8106d435>] __queue_work+0x295/0x3b0
[    5.272269]        [<ffffffff8106d6d6>] queue_work_on+0x166/0x1d0
[    5.272273]        [<ffffffff813e6cb1>] driver_deferred_probe_trigger.part.2+0x81/0x90
[    5.272275]        [<ffffffff813e6f15>] driver_bound+0x95/0xf0
[    5.272277]        [<ffffffff813e71b8>] driver_probe_device+0x108/0x3b0
[    5.272279]        [<ffffffff813e750b>] __driver_attach+0xab/0xb0
[    5.272281]        [<ffffffff813e517e>] bus_for_each_dev+0x5e/0x90
[    5.272283]        [<ffffffff813e6b9e>] driver_attach+0x1e/0x20
[    5.272285]        [<ffffffff813e6611>] bus_add_driver+0x101/0x290
[    5.272288]        [<ffffffff813e7a8a>] driver_register+0x7a/0x160
[    5.272292]        [<ffffffff8132d4fa>] __pci_register_driver+0x8a/0x90
[    5.272295]        [<ffffffffa01a6041>] 0xffffffffa01a6041
[    5.272300]        [<ffffffff810002ea>] do_one_initcall+0xea/0x1a0
[    5.272303]        [<ffffffff810c4135>] load_module+0x1315/0x1b10
[    5.272305]        [<ffffffff810c4a11>] SyS_init_module+0xe1/0x130
[    5.272310]        [<ffffffff8166dc82>] system_call_fastpath+0x16/0x1b
[    5.272312] 
[    5.272312] -> #0 ((pendingb_lock).lock#7){+.+...}:
[    5.272314]        [<ffffffff810b61d8>] __lock_acquire+0x1c98/0x1ca0
[    5.272316]        [<ffffffff810b6817>] lock_acquire+0x87/0x150
[    5.272319]        [<ffffffff81665467>] rt_spin_lock+0x47/0x60
[    5.272321]        [<ffffffff8106d5e6>] queue_work_on+0x76/0x1d0
[    5.272323]        [<ffffffff8106d7b8>] put_pwq+0x78/0xa0
[    5.272325]        [<ffffffff8106d80b>] put_pwq_unlocked+0x2b/0x40
[    5.272327]        [<ffffffff8106d9f4>] destroy_workqueue+0x1d4/0x250
[    5.272329]        [<ffffffff81247af3>] ext4_put_super+0x53/0x360
[    5.272333]        [<ffffffff811a0e92>] generic_shutdown_super+0x62/0x100
[    5.272336]        [<ffffffff811a0f60>] kill_block_super+0x30/0x80
[    5.272339]        [<ffffffff811a124d>] deactivate_locked_super+0x4d/0x80
[    5.272341]        [<ffffffff811a1ffe>] deactivate_super+0x4e/0x70
[    5.272346]        [<ffffffff811bf0fc>] mntput_no_expire+0xdc/0x140
[    5.272348]        [<ffffffff811c03bf>] SyS_umount+0xaf/0x3a0
[    5.272351]        [<ffffffff8166dc82>] system_call_fastpath+0x16/0x1b
[    5.272351] 
[    5.272351] other info that might help us debug this:
[    5.272351] 
[    5.272352]  Possible unsafe locking scenario:
[    5.272352] 
[    5.272352]        CPU0                    CPU1
[    5.272353]        ----                    ----
[    5.272354]   lock(&pool->lock/1);
[    5.272356]                                lock((pendingb_lock).lock#7);
[    5.272357]                                lock(&pool->lock/1);
[    5.272358]   lock((pendingb_lock).lock#7);
[    5.272359] 
[    5.272359]  *** DEADLOCK ***
[    5.272359] 
[    5.272360] 2 locks held by umount/413:
[    5.272364]  #0:  (&type->s_umount_key#19){+.+...}, at: [<ffffffff811a1ff6>] deactivate_super+0x46/0x70
[    5.272368]  #1:  (&pool->lock/1){+.+...}, at: [<ffffffff8106d803>] put_pwq_unlocked+0x23/0x40


Was caused by put_pwq_unlocked() which grabs the pool->lock and then calls put_pwq()
which does a schedule_work() which will grab the local_lock(pendingb_lock) and 
then later grab another pool->lock. There's a comment in put_pwq() about how the
second pool->lock has a subclass of 1 to get around lockdep complaining, but the
addition of the local_lock() to replace the local_irq_save() in -rt is a real
deadlock scenario.

As local_locks() are recrusive, by grabing the local_lock() before the pool->lock
in put_pwd_unlocked() we keep the correct locking order.

As this is only needed for -rt, a helper function is added called pool_lock_irq()
that grabs the local lock before grabing the pool->lock when PREEMPT_RT_FULL is
defined, and just grabs the pool->lock otherwise.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/workqueue.c
===================================================================
--- linux-rt.git.orig/kernel/workqueue.c
+++ linux-rt.git/kernel/workqueue.c
@@ -1053,6 +1053,33 @@ static void put_pwq(struct pool_workqueu
 	schedule_work(&pwq->unbound_release_work);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * RT uses local_lock instead of disabling interrupts.
+ * put_pwq() may grab this lock within the pool lock, which will
+ * reverse the general order. We need to grab it first before
+ * taking the pool lock.
+ */
+static inline void pool_lock_irq(struct pool_workqueue *pwq)
+{
+	local_lock_irq(pendingb_lock);
+	spin_lock(&pwq->pool->lock);
+}
+static inline void pool_unlock_irq(struct pool_workqueue *pwq)
+{
+	spin_unlock_irq(&pwq->pool->lock);
+	local_unlock_irq(pendingb_lock);
+}
+#else
+static inline void pool_lock_irq(struct pool_workqueue *pwq)
+{
+	spin_lock_irq(&pwq->pool->lock);
+}
+static inline void pool_unlock_irq(struct pool_workqueue *pwq)
+{
+	spin_unlock_irq(&pwq->pool->lock);
+}
+#endif
 /**
  * put_pwq_unlocked - put_pwq() with surrounding pool lock/unlock
  * @pwq: pool_workqueue to put (can be %NULL)
@@ -1066,9 +1093,9 @@ static void put_pwq_unlocked(struct pool
 		 * As both pwqs and pools are sched-RCU protected, the
 		 * following lock operations are safe.
 		 */
-		spin_lock_irq(&pwq->pool->lock);
+		pool_lock_irq(pwq);
 		put_pwq(pwq);
-		spin_unlock_irq(&pwq->pool->lock);
+		pool_unlock_irq(pwq);
 	}
 }
 

