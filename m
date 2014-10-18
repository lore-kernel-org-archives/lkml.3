Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaJRAaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:30:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38563 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaJRA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:28:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5/7] rcu: use simple wait queues where possible in rcutree
Date: Fri, 17 Oct 2014 20:23:00 -0400
Message-ID: <1413591782-23453-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit dae6e64d2bcfd4b06304ab864c7e3a4f6b5fedf4 ("rcu: Introduce
proper blocking to no-CBs kthreads GP waits") the RCU subsystem started
making use of wait queues.

Here we convert all additions of RCU wait queues to use simple wait queues,
since they don't need the extra overhead of the full wait queue features.

Originally this was done for RT kernels[1], since we would get things like...

  BUG: sleeping function called from invalid context at kernel/rtmutex.c:659
  in_atomic(): 1, irqs_disabled(): 1, pid: 8, name: rcu_preempt
  Pid: 8, comm: rcu_preempt Not tainted
  Call Trace:
   [<ffffffff8106c8d0>] __might_sleep+0xd0/0xf0
   [<ffffffff817d77b4>] rt_spin_lock+0x24/0x50
   [<ffffffff8106fcf6>] __wake_up+0x36/0x70
   [<ffffffff810c4542>] rcu_gp_kthread+0x4d2/0x680
   [<ffffffff8105f910>] ? __init_waitqueue_head+0x50/0x50
   [<ffffffff810c4070>] ? rcu_gp_fqs+0x80/0x80
   [<ffffffff8105eabb>] kthread+0xdb/0xe0
   [<ffffffff8106b912>] ? finish_task_switch+0x52/0x100
   [<ffffffff817e0754>] kernel_thread_helper+0x4/0x10
   [<ffffffff8105e9e0>] ? __init_kthread_worker+0x60/0x60
   [<ffffffff817e0750>] ? gs_change+0xb/0xb

...and hence simple wait queues were deployed on RT out of necessity
(as simple wait uses a raw lock), but mainline might as well take
advantage of the more streamline support as well.

[1] This is a carry forward of work from v3.10-rt; the original conversion
was by Thomas on an earlier -rt version, and Sebastian extended it to
additional post-3.10 added RCU waiters; here I've added a commit log and
unified the RCU changes into one, and uprev'd it to match mainline RCU.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b70cb6fbe3c..b8dc49c6bd4d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1398,7 +1398,7 @@ static void rcu_gp_kthread_wake(struct rcu_state *rsp)
 	    !ACCESS_ONCE(rsp->gp_flags) ||
 	    !rsp->gp_kthread)
 		return;
-	wake_up(&rsp->gp_wq);
+	swake_up(&rsp->gp_wq);
 }
 
 /*
@@ -1779,9 +1779,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("reqwait"));
 			rsp->gp_state = RCU_GP_WAIT_GPS;
-			wait_event_interruptible(rsp->gp_wq,
-						 ACCESS_ONCE(rsp->gp_flags) &
-						 RCU_GP_FLAG_INIT);
+			swait_event_interruptible(rsp->gp_wq,
+						  ACCESS_ONCE(rsp->gp_flags) &
+						  RCU_GP_FLAG_INIT);
 			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
@@ -1807,7 +1807,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("fqswait"));
 			rsp->gp_state = RCU_GP_WAIT_FQS;
-			ret = wait_event_interruptible_timeout(rsp->gp_wq,
+			ret = swait_event_interruptible_timeout(rsp->gp_wq,
 					((gf = ACCESS_ONCE(rsp->gp_flags)) &
 					 RCU_GP_FLAG_FQS) ||
 					(!ACCESS_ONCE(rnp->qsmask) &&
@@ -1928,7 +1928,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	swake_up(&rsp->gp_wq);  /* Memory barrier implied by swake_up() path. */
 }
 
 /*
@@ -2507,7 +2507,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	}
 	ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	swake_up(&rsp->gp_wq); /* Memory barrier implied by swake_up() path. */
 }
 
 /*
@@ -3630,7 +3630,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 	}
 
 	rsp->rda = rda;
-	init_waitqueue_head(&rsp->gp_wq);
+	init_swait_head(&rsp->gp_wq);
 	rnp = rsp->level[rcu_num_lvls - 1];
 	for_each_possible_cpu(i) {
 		while (i > rnp->grphi)
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 6a86eb7bac45..e44c58cf1200 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -208,7 +208,7 @@ struct rcu_node {
 				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 #ifdef CONFIG_RCU_NOCB_CPU
-	wait_queue_head_t nocb_gp_wq[2];
+	struct swait_head nocb_gp_wq[2];
 				/* Place for rcu_nocb_kthread() to wait GP. */
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 	int need_future_gp[2];
@@ -348,7 +348,7 @@ struct rcu_data {
 	atomic_long_t nocb_follower_count_lazy; /*  (approximate). */
 	int nocb_p_count;		/* # CBs being invoked by kthread */
 	int nocb_p_count_lazy;		/*  (approximate). */
-	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
+	struct swait_head nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
 	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
 
@@ -434,7 +434,7 @@ struct rcu_state {
 	unsigned long gpnum;			/* Current gp number. */
 	unsigned long completed;		/* # of last completed gp. */
 	struct task_struct *gp_kthread;		/* Task for grace periods. */
-	wait_queue_head_t gp_wq;		/* Where GP task waits. */
+	struct swait_head gp_wq;		/* Where GP task waits. */
 	short gp_flags;				/* Commands for GP task. */
 	short gp_state;				/* GP kthread sleep state. */
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a7997e272564..2da4755dc2a8 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2033,7 +2033,7 @@ early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
  */
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-	wake_up_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
+	swake_up_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
 }
 
 /*
@@ -2051,8 +2051,8 @@ static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
 
 static void rcu_init_one_nocb(struct rcu_node *rnp)
 {
-	init_waitqueue_head(&rnp->nocb_gp_wq[0]);
-	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
+	init_swait_head(&rnp->nocb_gp_wq[0]);
+	init_swait_head(&rnp->nocb_gp_wq[1]);
 }
 
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
@@ -2077,7 +2077,7 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
 	if (ACCESS_ONCE(rdp_leader->nocb_leader_sleep) || force) {
 		/* Prior xchg orders against prior callback enqueue. */
 		ACCESS_ONCE(rdp_leader->nocb_leader_sleep) = false;
-		wake_up(&rdp_leader->nocb_wq);
+		swake_up(&rdp_leader->nocb_wq);
 	}
 }
 
@@ -2224,7 +2224,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	 */
 	trace_rcu_future_gp(rnp, rdp, c, TPS("StartWait"));
 	for (;;) {
-		wait_event_interruptible(
+		swait_event_interruptible(
 			rnp->nocb_gp_wq[c & 0x1],
 			(d = ULONG_CMP_GE(ACCESS_ONCE(rnp->completed), c)));
 		if (likely(d))
@@ -2353,7 +2353,7 @@ static void nocb_follower_wait(struct rcu_data *rdp)
 		if (!rcu_nocb_poll) {
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    "FollowerSleep");
-			wait_event_interruptible(rdp->nocb_wq,
+			swait_event_interruptible(rdp->nocb_wq,
 						 ACCESS_ONCE(rdp->nocb_follower_head));
 		} else if (firsttime) {
 			/* Don't drown trace log with "Poll"! */
@@ -2455,7 +2455,7 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 	rdp->nocb_tail = &rdp->nocb_head;
-	init_waitqueue_head(&rdp->nocb_wq);
+	init_swait_head(&rdp->nocb_wq);
 	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
 }
 
-- 
1.9.2

