Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaKERnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:43:08 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58480 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbaKERln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:43 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/10] rcu: Make rcu_read_unlock_special() propagate ->qsmaskinit bit clearing
Date: Wed,  5 Nov 2014 09:41:29 -0800
Message-Id: <1415209294-2534-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141105174109.GA1306@linux.vnet.ibm.com>
 <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-0005-0000-0000-0000062477E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit causes rcu_read_unlock_special() to propagate ->qsmaskinit
bit clearing up the rcu_node tree once a given rcu_node structure's
blkd_tasks list becomes empty.  This is the final commit in preparation
for the rework of RCU priority boosting:  It enables preempted tasks to
remain queued on their rcu_node structure even after all of that rcu_node
structure's CPUs have gone offline.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        |  4 ++++
 kernel/rcu/tree_plugin.h | 16 +++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ccaf5ec78a56..fc3e8e574e01 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2297,6 +2297,10 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
 }
 
+static void __maybe_unused rcu_cleanup_dead_rnp(struct rcu_node *rnp_leaf)
+{
+}
+
 static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
 }
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 10d934cab9b3..7bd0088b51c2 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -322,9 +322,10 @@ static bool rcu_preempt_has_tasks(struct rcu_node *rnp)
  */
 void rcu_read_unlock_special(struct task_struct *t)
 {
-	int empty_exp;
-	int empty_norm;
-	int empty_exp_now;
+	bool empty;
+	bool empty_exp;
+	bool empty_norm;
+	bool empty_exp_now;
 	unsigned long flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
@@ -376,6 +377,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
+		empty = !rcu_preempt_has_tasks(rnp);
 		empty_norm = !rcu_preempt_blocked_readers_cgp(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
@@ -396,6 +398,14 @@ void rcu_read_unlock_special(struct task_struct *t)
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
+		 * If this was the last task on the list, go see if we
+		 * need to propagate ->qsmaskinit bit clearing up the
+		 * rcu_node tree.
+		 */
+		if (!empty && !rcu_preempt_has_tasks(rnp))
+			rcu_cleanup_dead_rnp(rnp);
+
+		/*
 		 * If this was the last task on the current list, and if
 		 * we aren't waiting on any CPUs, report the quiescent state.
 		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock,
-- 
1.8.1.5

