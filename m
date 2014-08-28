Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaH1TW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:22:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50312 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaH1TUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:20:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v7 tip/core/rcu 16/17] rcu: Remove local_irq_disable() in rcu_preempt_note_context_switch()
Date: Thu, 28 Aug 2014 12:20:07 -0700
Message-Id: <1409253608-32538-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-0928-0000-0000-000004685EBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_preempt_note_context_switch() function is on a scheduling fast
path, so it would be good to avoid disabling irqs.  The reason that irqs
are disabled is to synchronize process-level and irq-handler access to
the task_struct ->rcu_read_unlock_special bitmask.  This commit therefore
makes ->rcu_read_unlock_special instead be a union of bools with a short
allowing single-access checks in RCU's __rcu_read_unlock().  This results
in the process-level and irq-handler accesses being simple loads and
stores, so that irqs need no longer be disabled.  This commit therefore
removes the irq disabling from rcu_preempt_note_context_switch().

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |  2 +-
 include/linux/sched.h     | 16 +++++++++-------
 kernel/rcu/tree_plugin.h  | 32 +++++++++++++++-----------------
 kernel/rcu/update.c       |  2 +-
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 03b274873b06..77fc43f8fb72 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -111,7 +111,7 @@ extern struct group_info init_groups;
 #ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
 	.rcu_read_lock_nesting = 0,					\
-	.rcu_read_unlock_special = 0,					\
+	.rcu_read_unlock_special.s = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
 	INIT_TASK_RCU_TREE_PREEMPT()
 #else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec8b34722bcc..42888d715fb1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1212,6 +1212,13 @@ struct sched_dl_entity {
 	struct hrtimer dl_timer;
 };
 
+union rcu_special {
+	struct {
+		bool blocked;
+		bool need_qs;
+	} b;
+	short s;
+};
 struct rcu_node;
 
 enum perf_event_task_context {
@@ -1264,7 +1271,7 @@ struct task_struct {
 
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
-	char rcu_read_unlock_special;
+	union rcu_special rcu_read_unlock_special;
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -2005,16 +2012,11 @@ extern void task_clear_jobctl_trapping(struct task_struct *task);
 extern void task_clear_jobctl_pending(struct task_struct *task,
 				      unsigned int mask);
 
-#ifdef CONFIG_PREEMPT_RCU
-#define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
-#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-
 static inline void rcu_copy_process(struct task_struct *p)
 {
 #ifdef CONFIG_PREEMPT_RCU
 	p->rcu_read_lock_nesting = 0;
-	p->rcu_read_unlock_special = 0;
+	p->rcu_read_unlock_special.s = 0;
 	p->rcu_blocked_node = NULL;
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 533d0381927f..471fc77bb146 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -155,9 +155,8 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
  *
- * Unlike the other rcu_*_qs() functions, callers to this function
- * must disable irqs in order to protect the assignment to
- * ->rcu_read_unlock_special.
+ * As with the other rcu_*_qs() functions, callers to this function
+ * must disable preemption.
  */
 static void rcu_preempt_qs(int cpu)
 {
@@ -166,7 +165,7 @@ static void rcu_preempt_qs(int cpu)
 	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period(TPS("rcu_preempt"), rdp->gpnum, TPS("cpuqs"));
 	rdp->passed_quiesce = 1;
-	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	current->rcu_read_unlock_special.b.need_qs = false;
 }
 
 /*
@@ -190,14 +189,14 @@ static void rcu_preempt_note_context_switch(int cpu)
 	struct rcu_node *rnp;
 
 	if (t->rcu_read_lock_nesting > 0 &&
-	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+	    !t->rcu_read_unlock_special.b.blocked) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		smp_mb__after_unlock_lock();
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
+		t->rcu_read_unlock_special.b.blocked = true;
 		t->rcu_blocked_node = rnp;
 
 		/*
@@ -239,7 +238,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else if (t->rcu_read_lock_nesting < 0 &&
-		   t->rcu_read_unlock_special) {
+		   t->rcu_read_unlock_special.s) {
 
 		/*
 		 * Complete exit from RCU read-side critical section on
@@ -257,9 +256,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that we continue to block the current grace period.
 	 */
-	local_irq_save(flags);
 	rcu_preempt_qs(cpu);
-	local_irq_restore(flags);
 }
 
 /*
@@ -340,7 +337,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 	bool drop_boost_mutex = false;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
-	int special;
+	union rcu_special special;
 
 	/* NMI handlers cannot block and cannot safely manipulate state. */
 	if (in_nmi())
@@ -350,12 +347,13 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 	/*
 	 * If RCU core is waiting for this CPU to exit critical section,
-	 * let it know that we have done so.
+	 * let it know that we have done so.  Because irqs are disabled,
+	 * t->rcu_read_unlock_special cannot change.
 	 */
 	special = t->rcu_read_unlock_special;
-	if (special & RCU_READ_UNLOCK_NEED_QS) {
+	if (special.b.need_qs) {
 		rcu_preempt_qs(smp_processor_id());
-		if (!t->rcu_read_unlock_special) {
+		if (!t->rcu_read_unlock_special.s) {
 			local_irq_restore(flags);
 			return;
 		}
@@ -368,8 +366,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 	}
 
 	/* Clean up if blocked during RCU read-side critical section. */
-	if (special & RCU_READ_UNLOCK_BLOCKED) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
+	if (special.b.blocked) {
+		t->rcu_read_unlock_special.b.blocked = false;
 
 		/*
 		 * Remove this task from the list it blocked on.  The
@@ -658,7 +656,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 	}
 	if (t->rcu_read_lock_nesting > 0 &&
 	    per_cpu(rcu_preempt_data, cpu).qs_pending)
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
+		t->rcu_read_unlock_special.b.need_qs = true;
 }
 
 #ifdef CONFIG_RCU_BOOST
@@ -941,7 +939,7 @@ void exit_rcu(void)
 		return;
 	t->rcu_read_lock_nesting = 1;
 	barrier();
-	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
+	t->rcu_read_unlock_special.b.blocked = true;
 	__rcu_read_unlock();
 }
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 9487b4898e51..6fb911558562 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -93,7 +93,7 @@ void __rcu_read_unlock(void)
 		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
-		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special.s)))
 			rcu_read_unlock_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
 		t->rcu_read_lock_nesting = 0;
-- 
1.8.1.5

