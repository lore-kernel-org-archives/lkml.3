Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3LPKkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:40:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3LPKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:40:47 -0500
Date: Mon, 16 Dec 2013 02:40:31 -0800
From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Message-ID: <tip-6303b9c87d52eaedc82968d3ff59c471e7682afc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-arch@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-arch@vger.kernel.org
In-Reply-To: <1386799151-2219-7-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1386799151-2219-7-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rcu: Apply smp_mb__after_unlock_lock()
  to preserve grace periods
Git-Commit-ID: 6303b9c87d52eaedc82968d3ff59c471e7682afc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 02:40:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6303b9c87d52eaedc82968d3ff59c471e7682afc
Gitweb:     http://git.kernel.org/tip/6303b9c87d52eaedc82968d3ff59c471e7682afc
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 11 Dec 2013 13:59:10 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Dec 2013 11:36:16 +0100

rcu: Apply smp_mb__after_unlock_lock() to preserve grace periods

RCU must ensure that there is the equivalent of a full memory
barrier between any memory access preceding grace period and any
memory access following that same grace period, regardless of
which CPU(s) happen to execute the two memory accesses.
Therefore, downgrading UNLOCK+LOCK to no longer imply a full
memory barrier requires some adjustments to RCU.

This commit therefore adds smp_mb__after_unlock_lock()
invocations as needed after the RCU lock acquisitions that need
to be part of a full-memory-barrier UNLOCK+LOCK.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-arch@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1386799151-2219-7-git-send-email-paulmck@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/rcu/tree.c        | 18 +++++++++++++++++-
 kernel/rcu/tree_plugin.h | 13 +++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dd08198..a6205a0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1133,8 +1133,10 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 	 * hold it, acquire the root rcu_node structure's lock in order to
 	 * start one (if needed).
 	 */
-	if (rnp != rnp_root)
+	if (rnp != rnp_root) {
 		raw_spin_lock(&rnp_root->lock);
+		smp_mb__after_unlock_lock();
+	}
 
 	/*
 	 * Get a new grace-period number.  If there really is no grace
@@ -1354,6 +1356,7 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 		local_irq_restore(flags);
 		return;
 	}
+	smp_mb__after_unlock_lock();
 	__note_gp_changes(rsp, rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
@@ -1368,6 +1371,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
+	smp_mb__after_unlock_lock();
 	if (rsp->gp_flags == 0) {
 		/* Spurious wakeup, tell caller to go back to sleep.  */
 		raw_spin_unlock_irq(&rnp->lock);
@@ -1409,6 +1413,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
+		smp_mb__after_unlock_lock();
 		rdp = this_cpu_ptr(rsp->rda);
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
@@ -1463,6 +1468,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	/* Clear flag to prevent immediate re-entry. */
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
+		smp_mb__after_unlock_lock();
 		rsp->gp_flags &= ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
 	}
@@ -1480,6 +1486,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	raw_spin_lock_irq(&rnp->lock);
+	smp_mb__after_unlock_lock();
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
@@ -1505,6 +1512,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
+		smp_mb__after_unlock_lock();
 		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
@@ -1515,6 +1523,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
+	smp_mb__after_unlock_lock();
 	rcu_nocb_gp_set(rnp, nocb);
 
 	rsp->completed = rsp->gpnum; /* Declare grace period done. */
@@ -1749,6 +1758,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 		rnp_c = rnp;
 		rnp = rnp->parent;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
@@ -1778,6 +1788,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 
 	rnp = rdp->mynode;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	if (rdp->passed_quiesce == 0 || rdp->gpnum != rnp->gpnum ||
 	    rnp->completed == rnp->gpnum) {
 
@@ -1992,6 +2003,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
 		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+		smp_mb__after_unlock_lock();
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
@@ -2202,6 +2214,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		cond_resched();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		if (!rcu_gp_in_progress(rsp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
@@ -2231,6 +2244,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 	rnp = rcu_get_root(rsp);
 	if (rnp->qsmask == 0) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 	}
 }
@@ -2263,6 +2277,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 
 	/* Reached the root of the rcu_node tree, acquire lock. */
 	raw_spin_lock_irqsave(&rnp_old->lock, flags);
+	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		rsp->n_force_qs_lh++;
@@ -2378,6 +2393,7 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 			struct rcu_node *rnp_root = rcu_get_root(rsp);
 
 			raw_spin_lock(&rnp_root->lock);
+			smp_mb__after_unlock_lock();
 			rcu_start_gp(rsp);
 			raw_spin_unlock(&rnp_root->lock);
 		} else {
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6abb03d..eb161d8 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -204,6 +204,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
 		t->rcu_blocked_node = rnp;
 
@@ -312,6 +313,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	mask = rnp->grpmask;
 	raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	raw_spin_lock(&rnp_p->lock);	/* irqs already disabled. */
+	smp_mb__after_unlock_lock();
 	rcu_report_qs_rnp(mask, &rcu_preempt_state, rnp_p, flags);
 }
 
@@ -381,6 +383,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 		for (;;) {
 			rnp = t->rcu_blocked_node;
 			raw_spin_lock(&rnp->lock);  /* irqs already disabled. */
+			smp_mb__after_unlock_lock();
 			if (rnp == t->rcu_blocked_node)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
@@ -605,6 +608,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	while (!list_empty(lp)) {
 		t = list_entry(lp->next, typeof(*t), rcu_node_entry);
 		raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+		smp_mb__after_unlock_lock();
 		list_del(&t->rcu_node_entry);
 		t->rcu_blocked_node = rnp_root;
 		list_add(&t->rcu_node_entry, lp_root);
@@ -629,6 +633,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * in this case.
 	 */
 	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+	smp_mb__after_unlock_lock();
 	if (rnp_root->boost_tasks != NULL &&
 	    rnp_root->boost_tasks != rnp_root->gp_tasks &&
 	    rnp_root->boost_tasks != rnp_root->exp_tasks)
@@ -772,6 +777,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 	unsigned long mask;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -787,6 +793,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 		rnp = rnp->parent;
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
+		smp_mb__after_unlock_lock();
 		rnp->expmask &= ~mask;
 	}
 }
@@ -806,6 +813,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 	int must_wait = 0;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	if (list_empty(&rnp->blkd_tasks)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else {
@@ -886,6 +894,7 @@ void synchronize_rcu_expedited(void)
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		rnp->expmask = rnp->qsmaskinit;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
@@ -1191,6 +1200,7 @@ static int rcu_boost(struct rcu_node *rnp)
 		return 0;  /* Nothing left to boost. */
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 
 	/*
 	 * Recheck under the lock: all tasks in need of boosting
@@ -1377,6 +1387,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = RCU_BOOST_PRIO;
@@ -1769,6 +1780,7 @@ static void rcu_prepare_for_idle(int cpu)
 			continue;
 		rnp = rdp->mynode;
 		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		smp_mb__after_unlock_lock();
 		rcu_accelerate_cbs(rsp, rnp, rdp);
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
@@ -2209,6 +2221,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	struct rcu_node *rnp = rdp->mynode;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	c = rcu_start_future_gp(rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
