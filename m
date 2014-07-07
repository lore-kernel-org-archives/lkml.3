Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaGGWkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57490 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaGGWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/17] rcu: Simplify priority boosting by putting rt_mutex in rcu_node
Date: Mon,  7 Jul 2014 15:38:14 -0700
Message-Id: <1404772701-8804-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-8236-0000-0000-000003A71C86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU priority boosting currently checks for boosting via a pointer in
task_struct.  However, this is not needed: As Oleg noted, if the
rt_mutex is placed in the rcu_node instead of on the booster's stack,
the boostee can simply check it see if it owns the lock.  This commit
makes this change, shrinking task_struct by one pointer and the kernel
by thirteen lines.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |  9 +--------
 include/linux/sched.h     |  6 ------
 kernel/rcu/tree.h         |  3 +++
 kernel/rcu/tree_plugin.h  | 25 +++++++++++--------------
 4 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6df7f9fe0d01..2bb4c4f3531a 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -102,12 +102,6 @@ extern struct group_info init_groups;
 #define INIT_IDS
 #endif
 
-#ifdef CONFIG_RCU_BOOST
-#define INIT_TASK_RCU_BOOST()						\
-	.rcu_boost_mutex = NULL,
-#else
-#define INIT_TASK_RCU_BOOST()
-#endif
 #ifdef CONFIG_TREE_PREEMPT_RCU
 #define INIT_TASK_RCU_TREE_PREEMPT()					\
 	.rcu_blocked_node = NULL,
@@ -119,8 +113,7 @@ extern struct group_info init_groups;
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
-	INIT_TASK_RCU_TREE_PREEMPT()					\
-	INIT_TASK_RCU_BOOST()
+	INIT_TASK_RCU_TREE_PREEMPT()
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0c987a..3cfbc05e66e6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1270,9 +1270,6 @@ struct task_struct {
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rcu_boost_mutex;
-#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -2009,9 +2006,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	p->rcu_boost_mutex = NULL;
-#endif /* #ifdef CONFIG_RCU_BOOST */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 3eeb919e26a2..60fb0eaa2d16 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -177,6 +177,9 @@ struct rcu_node {
 				/*  to carry out the boosting is fully */
 				/*  released with no future boostee accesses */
 				/*  before that rt_mutex is re-initialized. */
+	struct rt_mutex boost_mtx;
+				/* Used only for the priority-boosting */
+				/*  side effect, not as a lock. */
 	unsigned long boost_time;
 				/* When to start boosting (jiffies). */
 	struct task_struct *boost_kthread_task;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 9c811879d31e..719587af7b10 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -33,6 +33,7 @@
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
+#include "../locking/rtmutex_common.h"
 #define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
 #else
 #define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
@@ -336,7 +337,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 	unsigned long flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rbmp = NULL;
+	bool drop_boost_mutex = false;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
 	int special;
@@ -398,11 +399,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
-		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
-		if (t->rcu_boost_mutex) {
-			rbmp = t->rcu_boost_mutex;
-			t->rcu_boost_mutex = NULL;
-		}
+		/* Snapshot ->boost_mtx ownership with rcu_node lock held. */
+		drop_boost_mutex = rt_mutex_owner(&rnp->boost_mtx) == t;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -427,8 +425,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (rbmp) {
-			rt_mutex_unlock(rbmp);
+		if (drop_boost_mutex) {
+			rt_mutex_unlock(&rnp->boost_mtx);
 			complete(&rnp->boost_completion);
 		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
@@ -1151,7 +1149,6 @@ static void rcu_wake_cond(struct task_struct *t, int status)
 static int rcu_boost(struct rcu_node *rnp)
 {
 	unsigned long flags;
-	struct rt_mutex mtx;
 	struct task_struct *t;
 	struct list_head *tb;
 
@@ -1202,14 +1199,14 @@ static int rcu_boost(struct rcu_node *rnp)
 	 * section.
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
-	rt_mutex_init_proxy_locked(&mtx, t);
-	t->rcu_boost_mutex = &mtx;
+	rt_mutex_init_proxy_locked(&rnp->boost_mtx, t);
 	init_completion(&rnp->boost_completion);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
-	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+	/* Lock only for side effect: boosts task t's priority. */
+	rt_mutex_lock(&rnp->boost_mtx);
+	rt_mutex_unlock(&rnp->boost_mtx);  /* Then keep lockdep happy. */
 
-	/* Wait until boostee is done accessing mtx before reinitializing. */
+	/* Wait for boostee to be done w/boost_mtx before reinitializing. */
 	wait_for_completion(&rnp->boost_completion);
 
 	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||
-- 
1.8.1.5

