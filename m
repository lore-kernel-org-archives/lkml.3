Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbaKERmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:42:55 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55438 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaKERlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:45 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/10] rcu: Don't migrate blocked tasks even if all corresponding CPUs offline
Date: Wed,  5 Nov 2014 09:41:30 -0800
Message-Id: <1415209294-2534-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141105174109.GA1306@linux.vnet.ibm.com>
 <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-8236-0000-0000-000006B05A1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When the last CPU associated with a given leaf rcu_node structure
goes offline, something must be done about the tasks queued on that
rcu_node structure.  Each of these tasks has been preempted on one of
the leaf rcu_node structure's CPUs while in an RCU read-side critical
section that it have not yet exited.  Handling these tasks is the job of
rcu_preempt_offline_tasks(), which migrates them from the leaf rcu_node
structure to the root rcu_node structure.

Unfortunately, this migration has to be done one task at a time because
each tasks allegiance must be shifted from the original leaf rcu_node to
the root, so that future attempts to deal with these tasks will acquire
the root rcu_node structure's ->lock rather than that of the leaf.
Worse yet, this migration must be done with interrupts disabled, which
is not so good for realtime response, especially given that there is
no bound on the number of tasks on a given rcu_node structure's list.
(OK, OK, there is a bound, it is just that it is unreasonably large,
especially on 64-bit systems.)  This was not considered a problem back
when rcu_preempt_offline_tasks() was first written because realtime
systems were assumed not to do CPU-hotplug operations while real-time
applications were running.  This assumption has proved of dubious validity
given that people are starting to run multiple realtime applications
on a single SMP system and that it is common practice to offline then
online a CPU before starting its real-time application in order to clear
extraneous processing off of that CPU.  So we now need CPU hotplug
operations to avoid undue latencies.

This commit therefore avoids migrating these tasks, instead letting
them be dequeued one by one from the original leaf rcu_node structure
by rcu_read_unlock_special().  This means that the clearing of bits
from the upper-level rcu_node structures must be deferred until the
last such task has been dequeued, because otherwise subsequent grace
periods won't wait on them.  This commit has the beneficial side effect
of simplifying the CPU-hotplug code for TREE_PREEMPT_RCU, especially in
CONFIG_RCU_BOOST builds.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        |  20 +--------
 kernel/rcu/tree.h        |  12 ------
 kernel/rcu/tree_plugin.h | 103 -----------------------------------------------
 3 files changed, 2 insertions(+), 133 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index fc3e8e574e01..e870b0f5e1b9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2244,7 +2244,6 @@ static void rcu_cleanup_dead_rnp(struct rcu_node *rnp_leaf)
 static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
 
@@ -2263,25 +2262,10 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
 	smp_mb__after_unlock_lock();	/* Enforce GP memory-order guarantee. */
 	rnp->qsmaskinit &= ~rdp->grpmask;
-	if (rnp->qsmaskinit == 0) {
-		need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+	if (rnp->qsmaskinit == 0 && !rcu_preempt_has_tasks(rnp))
 		rcu_cleanup_dead_rnp(rnp);
-	}
-
-	/*
-	 * We still hold the leaf rcu_node structure lock here, and
-	 * irqs are still disabled.  The reason for this subterfuge is
-	 * because invoking rcu_report_unblock_qs_rnp() with ->orphan_lock
-	 * held leads to deadlock.
-	 */
 	raw_spin_unlock(&rsp->orphan_lock); /* irqs remain disabled. */
-	rnp = rdp->mynode;
-	if (need_report & RCU_OFL_TASKS_NORM_GP)
-		rcu_report_unblock_qs_rnp(rnp, flags);
-	else
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	if (need_report & RCU_OFL_TASKS_EXP_GP)
-		rcu_report_exp_rnp(rsp, rnp, true);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	WARN_ONCE(rdp->qlen != 0 || rdp->nxtlist != NULL,
 		  "rcu_cleanup_dead_cpu: Callbacks on offline CPU %d: qlen=%lu, nxtlist=%p\n",
 		  cpu, rdp->qlen, rdp->nxtlist);
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bdf53aabaf42..49b3da7e0c12 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -514,13 +514,6 @@ extern struct list_head rcu_struct_flavors;
 #define for_each_rcu_flavor(rsp) \
 	list_for_each_entry((rsp), &rcu_struct_flavors, flavors)
 
-/* Return values for rcu_preempt_offline_tasks(). */
-
-#define RCU_OFL_TASKS_NORM_GP	0x1		/* Tasks blocking normal */
-						/*  GP were moved to root. */
-#define RCU_OFL_TASKS_EXP_GP	0x2		/* Tasks blocking expedited */
-						/*  GP were moved to root. */
-
 /*
  * RCU implementation internal declarations:
  */
@@ -557,11 +550,6 @@ static bool rcu_preempt_has_tasks(struct rcu_node *rnp);
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static int rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
-#ifdef CONFIG_HOTPLUG_CPU
-static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				     struct rcu_node *rnp,
-				     struct rcu_data *rdp);
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_preempt_check_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PREEMPT_RCU)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7bd0088b51c2..eb05cd805536 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -545,92 +545,6 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-/*
- * Handle tasklist migration for case in which all CPUs covered by the
- * specified rcu_node have gone offline.  Move them up to the root
- * rcu_node.  The reason for not just moving them to the immediate
- * parent is to remove the need for rcu_read_unlock_special() to
- * make more than two attempts to acquire the target rcu_node's lock.
- * Returns true if there were tasks blocking the current RCU grace
- * period.
- *
- * Returns 1 if there was previously a task blocking the current grace
- * period on the specified rcu_node structure.
- *
- * The caller must hold rnp->lock with irqs disabled.
- */
-static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				     struct rcu_node *rnp,
-				     struct rcu_data *rdp)
-{
-	struct list_head *lp;
-	struct list_head *lp_root;
-	int retval = 0;
-	struct rcu_node *rnp_root = rcu_get_root(rsp);
-	struct task_struct *t;
-
-	if (rnp == rnp_root) {
-		WARN_ONCE(1, "Last CPU thought to be offlined?");
-		return 0;  /* Shouldn't happen: at least one CPU online. */
-	}
-
-	/* If we are on an internal node, complain bitterly. */
-	WARN_ON_ONCE(rnp != rdp->mynode);
-
-	/*
-	 * Move tasks up to root rcu_node.  Don't try to get fancy for
-	 * this corner-case operation -- just put this node's tasks
-	 * at the head of the root node's list, and update the root node's
-	 * ->gp_tasks and ->exp_tasks pointers to those of this node's,
-	 * if non-NULL.  This might result in waiting for more tasks than
-	 * absolutely necessary, but this is a good performance/complexity
-	 * tradeoff.
-	 */
-	if (rcu_preempt_blocked_readers_cgp(rnp) && rnp->qsmask == 0)
-		retval |= RCU_OFL_TASKS_NORM_GP;
-	if (rcu_preempted_readers_exp(rnp))
-		retval |= RCU_OFL_TASKS_EXP_GP;
-	lp = &rnp->blkd_tasks;
-	lp_root = &rnp_root->blkd_tasks;
-	while (!list_empty(lp)) {
-		t = list_entry(lp->next, typeof(*t), rcu_node_entry);
-		raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
-		smp_mb__after_unlock_lock();
-		list_del(&t->rcu_node_entry);
-		t->rcu_blocked_node = rnp_root;
-		list_add(&t->rcu_node_entry, lp_root);
-		if (&t->rcu_node_entry == rnp->gp_tasks)
-			rnp_root->gp_tasks = rnp->gp_tasks;
-		if (&t->rcu_node_entry == rnp->exp_tasks)
-			rnp_root->exp_tasks = rnp->exp_tasks;
-#ifdef CONFIG_RCU_BOOST
-		if (&t->rcu_node_entry == rnp->boost_tasks)
-			rnp_root->boost_tasks = rnp->boost_tasks;
-#endif /* #ifdef CONFIG_RCU_BOOST */
-		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
-	}
-
-	rnp->gp_tasks = NULL;
-	rnp->exp_tasks = NULL;
-#ifdef CONFIG_RCU_BOOST
-	rnp->boost_tasks = NULL;
-	/*
-	 * In case root is being boosted and leaf was not.  Make sure
-	 * that we boost the tasks blocking the current grace period
-	 * in this case.
-	 */
-	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
-	smp_mb__after_unlock_lock();
-	if (rnp_root->boost_tasks != NULL &&
-	    rnp_root->boost_tasks != rnp_root->gp_tasks &&
-	    rnp_root->boost_tasks != rnp_root->exp_tasks)
-		rnp_root->boost_tasks = rnp_root->gp_tasks;
-	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
-	return retval;
-}
-
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 /*
@@ -1023,23 +937,6 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-/*
- * Because preemptible RCU does not exist, it never needs to migrate
- * tasks that were blocked within RCU read-side critical sections, and
- * such non-existent tasks cannot possibly have been blocking the current
- * grace period.
- */
-static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				     struct rcu_node *rnp,
-				     struct rcu_data *rdp)
-{
-	return 0;
-}
-
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 /*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
-- 
1.8.1.5

