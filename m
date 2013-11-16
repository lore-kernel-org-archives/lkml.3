Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3KPAYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:24:04 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57525 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3KPAXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/16] rcu: Fix and comment ordering around wait_event()
Date: Fri, 15 Nov 2013 16:23:24 -0800
Message-Id: <1384561418-30575-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-7164-0000-0000-0000035AF086
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It is all too easy to forget that wait_event() does not necessarily
imply a full memory barrier.  The case where it does not is where the
condition transitions to true just as wait_event() starts execution.
This is actually a feature: The standard use of wait_event() involves
locking, in which case the locks provide the needed ordering (you hold a
lock across the wake_up() and acquire that same lock after wait_event()
returns).

Given that I did forget that wait_event() does not necessarily imply a
full memory barrier in one case, this commit fixes that case.  This commit
also adds comments calling out the placement of existing memory barriers
relied on by wait_event() calls.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/torture.c     | 8 +++++---
 kernel/rcu/tree.c        | 3 +++
 kernel/rcu/tree_plugin.h | 6 +++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index 3929cd451511..69a4ec80a788 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -1578,6 +1578,7 @@ static int rcu_torture_barrier_cbs(void *arg)
 {
 	long myid = (long)arg;
 	bool lastphase = 0;
+	bool newphase;
 	struct rcu_head rcu;
 
 	init_rcu_head_on_stack(&rcu);
@@ -1585,10 +1586,11 @@ static int rcu_torture_barrier_cbs(void *arg)
 	set_user_nice(current, 19);
 	do {
 		wait_event(barrier_cbs_wq[myid],
-			   barrier_phase != lastphase ||
+			   (newphase =
+			    ACCESS_ONCE(barrier_phase)) != lastphase ||
 			   kthread_should_stop() ||
 			   fullstop != FULLSTOP_DONTSTOP);
-		lastphase = barrier_phase;
+		lastphase = newphase;
 		smp_mb(); /* ensure barrier_phase load before ->call(). */
 		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
 			break;
@@ -1625,7 +1627,7 @@ static int rcu_torture_barrier(void *arg)
 		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
 			break;
 		n_barrier_attempts++;
-		cur_ops->cb_barrier();
+		cur_ops->cb_barrier(); /* Implies smp_mb() for wait_event(). */
 		if (atomic_read(&barrier_cbs_invoked) != n_barrier_cbs) {
 			n_rcu_torture_barrier_error++;
 			WARN_ON_ONCE(1);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e00946e432ae..fa496ea405a1 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1520,6 +1520,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
 			__note_gp_changes(rsp, rnp, rdp);
+		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
@@ -1564,6 +1565,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			wait_event_interruptible(rsp->gp_wq,
 						 ACCESS_ONCE(rsp->gp_flags) &
 						 RCU_GP_FLAG_INIT);
+			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
 			cond_resched();
@@ -1593,6 +1595,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 					(!ACCESS_ONCE(rnp->qsmask) &&
 					 !rcu_preempt_blocked_readers_cgp(rnp)),
 					j);
+			/* Locking provides needed memory barriers. */
 			/* If grace period done, leave loop. */
 			if (!ACCESS_ONCE(rnp->qsmask) &&
 			    !rcu_preempt_blocked_readers_cgp(rnp))
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3822ac0c4b27..c2aab07411dc 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -779,8 +779,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 		}
 		if (rnp->parent == NULL) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			if (wake)
+			if (wake) {
+				smp_mb(); /* EGP done before wake_up(). */
 				wake_up(&sync_rcu_preempt_exp_wq);
+			}
 			break;
 		}
 		mask = rnp->grpmask;
@@ -1852,6 +1854,7 @@ static int rcu_oom_notify(struct notifier_block *self,
 
 	/* Wait for callbacks from earlier instance to complete. */
 	wait_event(oom_callback_wq, atomic_read(&oom_callback_count) == 0);
+	smp_mb(); /* Ensure callback reuse happens after callback invocation. */
 
 	/*
 	 * Prevent premature wakeup: ensure that all increments happen
@@ -2250,6 +2253,7 @@ static int rcu_nocb_kthread(void *arg)
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("Sleep"));
 			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
+			/* Memory barrier provide by xchg() below. */
 		} else if (firsttime) {
 			firsttime = 0;
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-- 
1.8.1.5

