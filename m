Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaG1W5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:57:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49235 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaG1W42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:56:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 8/9] rcu: Make RCU-tasks track exiting tasks
Date: Mon, 28 Jul 2014 15:56:19 -0700
Message-Id: <1406588180-21933-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072822-9332-0000-0000-00000186F322
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds synchronization with exiting tasks, so that RCU-tasks
avoids waiting on tasks that no longer exist.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Conflicts:
	kernel/rcu/update.c
---
 include/linux/init_task.h |   5 +-
 include/linux/rcupdate.h  |   8 ++
 include/linux/rcutiny.h   |   1 +
 include/linux/sched.h     |   5 +-
 kernel/rcu/tree_plugin.h  |   2 +
 kernel/rcu/update.c       | 345 +++++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 331 insertions(+), 35 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 78715ea7c30c..dd9b2d471270 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -127,8 +127,9 @@ extern struct group_info init_groups;
 #ifdef CONFIG_TASKS_RCU
 #define INIT_TASK_RCU_TASKS(tsk)					\
 	.rcu_tasks_holdout = false,					\
-	.rcu_tasks_holdout_list =					\
-		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),
+	.rcu_tasks_holdout_list.prev = LIST_POISON2,			\
+	.rcu_tasks_lock = __SPIN_LOCK_UNLOCKED(tsk.rcu_tasks_lock),	\
+	.rcu_tasks_exiting = 0,
 #else
 #define INIT_TASK_RCU_TASKS(tsk)
 #endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ecb2198849e0..1c0c286b97df 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -292,6 +292,14 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
+#ifdef CONFIG_TASKS_RCU
+void exit_rcu_tasks(void);
+#else /* #ifdef CONFIG_TASKS_RCU */
+static inline exit_rcu_tasks(void)
+{
+}
+#endif /* #else #ifdef CONFIG_TASKS_RCU */
+
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
  * @a: Code that RCU needs to pay attention to.
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index d40a6a451330..326cd54d0f34 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -129,6 +129,7 @@ static inline void rcu_cpu_stall_reset(void)
 
 static inline void exit_rcu(void)
 {
+	exit_rcu_tasks();
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3e18b7bbe4df..f896b93b29f6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1276,6 +1276,8 @@ struct task_struct {
 #ifdef CONFIG_TASKS_RCU
 	int rcu_tasks_holdout;
 	struct list_head rcu_tasks_holdout_list;
+	spinlock_t rcu_tasks_lock;
+	int rcu_tasks_exiting;
 #endif /* #ifdef CONFIG_TASKS_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
@@ -2019,7 +2021,8 @@ static inline void rcu_copy_process(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 #ifdef CONFIG_TASKS_RCU
 	p->rcu_tasks_holdout = false;
-	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
+	p->rcu_tasks_holdout_list.prev = LIST_POISON2;
+	spin_lock_init(&p->rcu_tasks_lock);
 #endif /* #ifdef CONFIG_TASKS_RCU */
 }
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a86a363ea453..420f4e852c93 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -943,6 +943,7 @@ void exit_rcu(void)
 	barrier();
 	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
 	__rcu_read_unlock();
+	exit_rcu_tasks();
 }
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
@@ -1093,6 +1094,7 @@ static void __init __rcu_init_preempt(void)
  */
 void exit_rcu(void)
 {
+	exit_rcu_tasks();
 }
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 0fd68871a191..7d3e56f7b623 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -367,6 +367,7 @@ early_initcall(check_cpu_stall_init);
 
 /* Lists of tasks that we are still waiting for during this grace period. */
 static LIST_HEAD(rcu_tasks_holdouts);
+static DEFINE_SPINLOCK(rcu_tasks_global_lock);
 
 /* Global list of callbacks and associated lock. */
 static struct rcu_head *rcu_tasks_cbs_head;
@@ -448,13 +449,303 @@ void rcu_barrier_tasks(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 
+/*
+ * Given a ->rcu_tasks_holdout_list list_head structure, return the
+ * corresponding lock.  For the list header, this is whatever default
+ * is passed in, while for task_struct structures, this is the
+ * ->rcu_tasks_lock field.
+ *
+ * The dflt should be NULL if the caller already holds rcu_tasks_global_lock,
+ * or &rcu_tasks_global_lock otherwise.
+ */
+static spinlock_t *list_to_lock(struct list_head *lhp, spinlock_t *dflt)
+{
+	struct task_struct *tp;
+
+	if (lhp == &rcu_tasks_holdouts)
+		return dflt;
+	tp = container_of(lhp, struct task_struct, rcu_tasks_holdout_list);
+	return &tp->rcu_tasks_lock;
+}
+
+/*
+ * A "list lock" structure is a doubly linked list with a per-element
+ * lock and a global lock protecting the list header.  When combined
+ * with RCU traversal, we get a list with serialized addition, but
+ * where independent deletions can proceed concurrently with each other
+ * and with addition.  It is the caller's responsibility to avoid the
+ * ABA problem, where an element is recycled onto the list so that a
+ * given operation might see both the old and the new version of that
+ * element.  This use case avoids this problem by operating in phases,
+ * so that the list must be seen by all as completely empty between
+ * phases.  A given item may only be added once during a given phase.
+ *
+ * To add an element, you must hold the locks of the two adjacent elements
+ * as well as of the element being added.  To remove an element, you must
+ * hold that element's lock as well as those of its two neighbors.
+ */
+
+/*
+ * Add the specified task_struct structure's ->rcu_tasks_holdout_list
+ * field to the rcu_tasks_holdouts list.
+ *
+ * Please note that this function relies on the fact that it is adding
+ * to one end of the list.  A function adding to the middle of the list
+ * would be much more complex.
+ */
+static void list_lock_add_rcu(struct task_struct *t)
+{
+	spinlock_t *sp;
+
+	spin_lock(&rcu_tasks_global_lock);
+	spin_lock(&t->rcu_tasks_lock);
+	/* Because we hold the global lock, last item cannot change. */
+	BUG_ON(rcu_tasks_holdouts.prev->next != &rcu_tasks_holdouts);
+	sp = list_to_lock(rcu_tasks_holdouts.prev, NULL);
+	if (sp)
+		spin_lock(sp);
+	list_add_tail_rcu(&t->rcu_tasks_holdout_list, &rcu_tasks_holdouts);
+	if (sp)
+		spin_unlock(sp);
+	spin_unlock(&t->rcu_tasks_lock);
+	spin_unlock(&rcu_tasks_global_lock);
+}
+
+/*
+ * Remove the specified task_struct structure's ->rcu_tasks_holdout_list
+ * field to the rcu_tasks_holdouts list.  This function is somewhat more
+ * complex due to the need to avoid deadlock and due to the need to handle
+ * concurrent deletion and addition operations.
+ */
+static void list_lock_del_rcu(struct task_struct *t)
+{
+	struct list_head *prevlh;
+	struct task_struct *prev;
+	struct task_struct *prevck;
+	spinlock_t *prevlock;
+	struct task_struct *next;
+	struct task_struct *nextck;
+	spinlock_t *nextlock;
+	int i = 0;
+	bool gbl = false;
+
+	/*
+	 * First, use trylock primitives to acquire the needed locks.
+	 * These are inherently immune to deadlock.
+	 */
+	for (;;) {
+		/* Avoid having tasks freed out from under us. */
+		rcu_read_lock();
+
+		/* Identify locks to acquire. */
+		prevlh = t->rcu_tasks_holdout_list.prev;
+		if (prevlh == LIST_POISON2)
+			goto rcu_ret; /* Already deleted:  Our work is done! */
+		prev = container_of(prevlh,
+				    struct task_struct, rcu_tasks_holdout_list);
+		prevlock = list_to_lock(&prev->rcu_tasks_holdout_list,
+					&rcu_tasks_global_lock);
+		next = container_of(t->rcu_tasks_holdout_list.next,
+				    struct task_struct, rcu_tasks_holdout_list);
+		nextlock = list_to_lock(&next->rcu_tasks_holdout_list,
+					&rcu_tasks_global_lock);
+		if (nextlock == prevlock)
+			nextlock = NULL; /* Last task, don't deadlock. */
+
+		/* Check for malformed list. */
+		BUG_ON(prevlock == &t->rcu_tasks_lock ||
+		       nextlock == &t->rcu_tasks_lock);
+
+		/* Attempt to acquire the locks identified above. */
+		if (!spin_trylock(prevlock))
+			goto retry_prep;
+		if (!spin_trylock(&t->rcu_tasks_lock))
+			goto retry_unlock_1;
+		if (nextlock && !spin_trylock(nextlock))
+			goto retry_unlock_2;
+
+		/* Did the list change while we were acquiring locks? */
+		prevck = container_of(t->rcu_tasks_holdout_list.prev,
+				      struct task_struct,
+				      rcu_tasks_holdout_list);
+		nextck = container_of(t->rcu_tasks_holdout_list.next,
+				      struct task_struct,
+				      rcu_tasks_holdout_list);
+		if (prevck == prev && nextck == next)
+			goto del_return_unlock; /* No, go delete! */
+
+		/*
+		 * List changed or lock acquisition failed, so drop locks
+		 * and retry.
+		 */
+		if (nextlock)
+			spin_unlock(nextlock);
+retry_unlock_2:
+		spin_unlock(&t->rcu_tasks_lock);
+retry_unlock_1:
+		spin_unlock(prevlock);
+retry_prep:
+		rcu_read_unlock();
+
+		/* Allow some time for locks to be released, then retry. */
+		udelay(3);
+		if (++i > 10)
+			break;
+	}
+
+	/*
+	 * Conditionally acquiring locks failed too many times, so no
+	 * more Mr. Nice Guy.  First acquire the global lock, then
+	 * unconditionally acquire the locks we think that we need.
+	 * Because only the holder of the global lock unconditionally
+	 * acquires the per-task_struct locks, deadlock is avoided.
+	 * (I first heard of this trick from Doug Lea.)
+	 *
+	 * Of course, the list might still change, so we still have
+	 * to check and possibly retry.  Can't have everything!
+	 */
+	gbl = true;
+	spin_lock(&rcu_tasks_global_lock);
+	for (;;) {
+		/* Prevent task_struct from being freed. */
+		rcu_read_lock();
+
+		/*
+		 * Identify locks.  We already hold the global lock, hence
+		 * the NULL dflt argument to list_to_lock().
+		 */
+		prevlh = t->rcu_tasks_holdout_list.prev;
+		if (prevlh == LIST_POISON2)
+			goto unlock_gbl_ret; /* Already deleted! */
+		prev = container_of(prevlh,
+				    struct task_struct, rcu_tasks_holdout_list);
+		prevlock = list_to_lock(&prev->rcu_tasks_holdout_list, NULL);
+		next = container_of(t->rcu_tasks_holdout_list.next,
+				    struct task_struct, rcu_tasks_holdout_list);
+		nextlock = list_to_lock(&next->rcu_tasks_holdout_list, NULL);
+
+		/* Acquire the identified locks. */
+		if (prevlock)
+			spin_lock(prevlock);
+		spin_lock(&t->rcu_tasks_lock);
+		if (nextlock)
+			spin_lock(nextlock);
+
+		/* Check to see if the list changed during lock acquisition. */
+		prevck = container_of(t->rcu_tasks_holdout_list.prev,
+				      struct task_struct,
+				      rcu_tasks_holdout_list);
+		nextck = container_of(t->rcu_tasks_holdout_list.next,
+				      struct task_struct,
+				      rcu_tasks_holdout_list);
+		if (prevck == prev && nextck == next)
+			break;  /* No list changes, go do removal. */
+
+		/* Release the locks, wait a bit, and go retry. */
+		if (nextlock)
+			spin_unlock(nextlock);
+		spin_unlock(&t->rcu_tasks_lock);
+		if (prevlock)
+			spin_unlock(prevlock);
+		rcu_read_unlock();
+		udelay(3);
+	}
+
+	/* We get here once we succeed in acquiring the needed locks. */
+del_return_unlock:
+	/* Remove the element from the list. */
+	list_del_rcu(&t->rcu_tasks_holdout_list);
+
+	/* Release the locks, exit the RCU read-side critical section, done! */
+	if (nextlock)
+		spin_unlock(nextlock);
+	spin_unlock(&t->rcu_tasks_lock);
+	if (prevlock)
+		spin_unlock(prevlock);
+unlock_gbl_ret:
+	if (gbl)
+		spin_unlock(&rcu_tasks_global_lock);
+rcu_ret:
+	rcu_read_unlock();
+}
+
+/*
+ * Build the list of tasks that must be waited on for this RCU-tasks
+ * grace period.  Note that we must wait for pre-existing exiting tasks
+ * to finish exiting in order to avoid the ABA problem.
+ */
+static void rcu_tasks_build_list(void)
+{
+	struct task_struct *g, *t;
+	int n_exiting = 0;
+
+	/*
+	 * Wait for all pre-existing t->on_rq transitions to complete.
+	 * Invoking synchronize_sched() suffices because all t->on_rq
+	 * transitions occur with interrupts disabled.
+	 */
+	synchronize_sched();
+
+	/*
+	 * Scan the task list under RCU protection, accumulating
+	 * tasks that are currently running or preempted that are
+	 * not also in the process of exiting.
+	 */
+	rcu_read_lock();
+	do_each_thread(g, t) {
+		/* Acquire this thread's lock to synchronize with exit. */
+		spin_lock(&t->rcu_tasks_lock);
+		if (t->rcu_tasks_exiting) {
+			/*
+			 * Task is exiting, so don't add to list.  Instead,
+			 * set up to wait for its exiting to complete.
+			 */
+			n_exiting++;
+			t->rcu_tasks_exiting = 2;
+			spin_unlock(&t->rcu_tasks_lock);
+			goto next_thread;
+		}
+
+		/* Assume that we must wait for this task. */
+		ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
+		spin_unlock(&t->rcu_tasks_lock);
+		smp_mb();  /* Order ->rcu_tasks_holdout store before "if". */
+		if (t == current || !ACCESS_ONCE(t->on_rq) || is_idle_task(t)) {
+			smp_store_release(&t->rcu_tasks_holdout, 0);
+			goto next_thread;
+		}
+		list_lock_add_rcu(t);
+next_thread:;
+	} while_each_thread(g, t);
+	rcu_read_unlock();
+
+	/*
+	 * OK, we have our candidate list of threads.  Now wait for
+	 * the threads that were in the process of exiting to finish
+	 * doing so.
+	 */
+	while (n_exiting) {
+		n_exiting = 0;
+		rcu_read_lock();
+		do_each_thread(g, t) {
+			if (ACCESS_ONCE(t->rcu_tasks_exiting) == 2) {
+				n_exiting++;
+				goto wait_exit_again;
+			}
+		} while_each_thread(g, t);
+wait_exit_again:
+		rcu_read_unlock();
+		schedule_timeout_uninterruptible(1);
+	}
+}
+
 /* See if tasks are still holding out, complain if so. */
 static void check_holdout_task(struct task_struct *t,
 			       bool needreport, bool *firstreport)
 {
 	if (!smp_load_acquire(&t->rcu_tasks_holdout)) {
 		/* @@@ need to check for usermode on CPU. */
-		list_del_rcu(&t->rcu_tasks_holdout_list);
+		list_lock_del_rcu(t);
 		return;
 	}
 	if (!needreport)
@@ -470,7 +761,7 @@ static void check_holdout_task(struct task_struct *t,
 static int __noreturn rcu_tasks_kthread(void *arg)
 {
 	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *t;
 	unsigned long lastreport;
 	struct rcu_head *list;
 	struct rcu_head *next;
@@ -502,37 +793,10 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 
 		/*
 		 * There were callbacks, so we need to wait for an
-		 * RCU-tasks grace period.  Start off by scanning
-		 * the task list for tasks that are not already
-		 * voluntarily blocked.  Mark these tasks and make
-		 * a list of them in rcu_tasks_holdouts.
+		 * RCU-tasks grace period.  Go build the list of
+		 * tasks that must be waited for.
 		 */
-		rcu_read_lock();
-		do_each_thread(g, t) {
-			if (t != current && ACCESS_ONCE(t->on_rq) &&
-			    !is_idle_task(t)) {
-				t->rcu_tasks_holdout = 1;
-				list_add(&t->rcu_tasks_holdout_list,
-					 &rcu_tasks_holdouts);
-			}
-		} while_each_thread(g, t);
-		rcu_read_unlock();
-
-		/*
-		 * The "t != current" and "!is_idle_task()" comparisons
-		 * above are stable, but the "t->on_rq" value could
-		 * change at any time, and is generally unordered.
-		 * Therefore, we need some ordering.  The trick is
-		 * that t->on_rq is updated with a runqueue lock held,
-		 * and thus with interrupts disabled.  So the following
-		 * synchronize_sched() provides the needed ordering by:
-		 * (1) Waiting for all interrupts-disabled code sections
-		 * to complete and (2) The synchronize_sched() ordering
-		 * guarantees, which provide for a memory barrier on each
-		 * CPU since the completion of its last read-side critical
-		 * section, including interrupt-disabled code sections.
-		 */
-		synchronize_sched();
+		rcu_tasks_build_list();
 
 		/*
 		 * Each pass through the following loop scans the list
@@ -594,4 +858,21 @@ static int __init rcu_spawn_tasks_kthread(void)
 }
 early_initcall(rcu_spawn_tasks_kthread);
 
+/*
+ * RCU-tasks hook for exiting tasks.  This hook prevents the current
+ * task from being added to the RCU-tasks list, and also ensures that
+ * any future RCU-tasks grace period will wait for the current task
+ * to finish exiting.
+ */
+void exit_rcu_tasks(void)
+{
+	struct task_struct *t = current;
+
+	cond_resched();
+	spin_lock(&t->rcu_tasks_lock);
+	t->rcu_tasks_exiting = t->rcu_tasks_holdout + 1;
+	spin_unlock(&t->rcu_tasks_lock);
+	list_lock_del_rcu(t);
+}
+
 #endif /* #ifdef CONFIG_TASKS_RCU */
-- 
1.8.1.5

