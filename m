Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaKERlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:41:46 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46989 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbaKERlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:42 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/10] rcu: Abstract rcu_cleanup_dead_rnp() from rcu_cleanup_dead_cpu()
Date: Wed,  5 Nov 2014 09:41:28 -0800
Message-Id: <1415209294-2534-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141105174109.GA1306@linux.vnet.ibm.com>
 <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-0029-0000-0000-000005661B81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit abstracts rcu_cleanup_dead_rnp() from rcu_cleanup_dead_cpu()
in preparation for the rework of RCU priority boosting.  This new function
will be invoked from rcu_read_unlock_special() in the reworked scheme,
which is why rcu_cleanup_dead_rnp() assumes that the leaf rcu_node
structure's ->qsmaskinit field has already been updated.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 67 ++++++++++++++++++++++++++++++++++--------------
 kernel/rcu/tree.h        |  1 +
 kernel/rcu/tree_plugin.h | 17 ++++++++++++
 3 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b8dc3f8d80c..ccaf5ec78a56 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2195,6 +2195,46 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 }
 
 /*
+ * All CPUs for the specified rcu_node structure have gone offline,
+ * and all tasks that were preempted within an RCU read-side critical
+ * section while running on one of those CPUs have since exited their RCU
+ * read-side critical section.  Some other CPU is reporting this fact with
+ * the specified rcu_node structure's ->lock held and interrupts disabled.
+ * This function therefore goes up the tree of rcu_node structures,
+ * clearing the corresponding bits in the ->qsmaskinit fields.  Note that
+ * the leaf rcu_node structure's ->qsmaskinit field has already been
+ * updated
+ *
+ * This function does check that the specified rcu_node structure has
+ * all CPUs offline and no blocked tasks, so it is OK to invoke it
+ * prematurely.  That said, invoking it after the fact will cost you
+ * a needless lock acquisition.  So once it has done its work, don't
+ * invoke it again.
+ */
+static void rcu_cleanup_dead_rnp(struct rcu_node *rnp_leaf)
+{
+	long mask;
+	struct rcu_node *rnp = rnp_leaf;
+
+	if (rnp->qsmaskinit || rcu_preempt_has_tasks(rnp))
+		return;
+	for (;;) {
+		mask = rnp->grpmask;
+		rnp = rnp->parent;
+		if (!rnp)
+			break;
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		smp_mb__after_unlock_lock(); /* GP memory ordering. */
+		rnp->qsmaskinit &= ~mask;
+		if (rnp->qsmaskinit) {
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			return;
+		}
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+	}
+}
+
+/*
  * The CPU has been completely removed, and some other CPU is reporting
  * this fact from process context.  Do the remainder of the cleanup,
  * including orphaning the outgoing CPU's RCU callbacks, and also
@@ -2204,7 +2244,6 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	unsigned long mask;
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
@@ -2220,24 +2259,14 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	rcu_send_cbs_to_orphanage(cpu, rsp, rnp, rdp);
 	rcu_adopt_orphan_cbs(rsp, flags);
 
-	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
-	mask = rdp->grpmask;	/* rnp->grplo is constant. */
-	do {
-		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
-		smp_mb__after_unlock_lock();
-		rnp->qsmaskinit &= ~mask;
-		if (rnp->qsmaskinit != 0) {
-			if (rnp != rdp->mynode)
-				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-			break;
-		}
-		if (rnp == rdp->mynode)
-			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
-		else
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-		mask = rnp->grpmask;
-		rnp = rnp->parent;
-	} while (rnp != NULL);
+	/* Remove outgoing CPU from mask in the leaf rcu_node structure. */
+	raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+	smp_mb__after_unlock_lock();	/* Enforce GP memory-order guarantee. */
+	rnp->qsmaskinit &= ~rdp->grpmask;
+	if (rnp->qsmaskinit == 0) {
+		need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+		rcu_cleanup_dead_rnp(rnp);
+	}
 
 	/*
 	 * We still hold the leaf rcu_node structure lock here, and
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8e7b1843896e..bdf53aabaf42 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -553,6 +553,7 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static bool rcu_preempt_has_tasks(struct rcu_node *rnp);
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static int rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3d22f0b2dea9..10d934cab9b3 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -307,6 +307,15 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
 }
 
 /*
+ * Return true if the specified rcu_node structure has tasks that were
+ * preempted within an RCU read-side critical section.
+ */
+static bool rcu_preempt_has_tasks(struct rcu_node *rnp)
+{
+	return !list_empty(&rnp->blkd_tasks);
+}
+
+/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
@@ -970,6 +979,14 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 /*
+ * Because there is no preemptible RCU, there can be no readers blocked.
+ */
+static bool rcu_preempt_has_tasks(struct rcu_node *rnp)
+{
+	return false;
+}
+
+/*
  * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
-- 
1.8.1.5

