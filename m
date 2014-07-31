Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaGaAkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:40:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50606 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbaGaAjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:39:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 10/10] rcu: Make RCU-tasks track exiting tasks
Date: Wed, 30 Jul 2014 17:39:42 -0700
Message-Id: <1406767182-4356-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073100-0928-0000-0000-000003C70761
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds synchronization with exiting tasks, so that RCU-tasks
avoids waiting on tasks that no longer exist.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |   6 +-
 include/linux/rcupdate.h  |   8 +++
 include/linux/sched.h     |   7 ++-
 kernel/exit.c             |   1 +
 kernel/rcu/update.c       | 155 +++++++++++++++++++++++++++++++++++-----------
 5 files changed, 138 insertions(+), 39 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 78715ea7c30c..26322200937d 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -127,8 +127,10 @@ extern struct group_info init_groups;
 #ifdef CONFIG_TASKS_RCU
 #define INIT_TASK_RCU_TASKS(tsk)					\
 	.rcu_tasks_holdout = false,					\
-	.rcu_tasks_holdout_list =					\
-		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),
+	.rcu_tasks_holdout_list.prev = LIST_POISON2,			\
+	.rcu_tasks_lock = __SPIN_LOCK_UNLOCKED(tsk.rcu_tasks_lock),	\
+	.rcu_tasks_exiting = 0,						\
+	.rcu_tasks_exit_wq = NULL,
 #else
 #define INIT_TASK_RCU_TASKS(tsk)
 #endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ecb2198849e0..0805a74f88ca 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -292,6 +292,14 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
+#ifdef CONFIG_TASKS_RCU
+void exit_rcu_tasks(void);
+#else /* #ifdef CONFIG_TASKS_RCU */
+static inline void exit_rcu_tasks(void)
+{
+}
+#endif /* #else #ifdef CONFIG_TASKS_RCU */
+
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
  * @a: Code that RCU needs to pay attention to.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3cf124389ec7..8c02508c9e47 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1277,6 +1277,9 @@ struct task_struct {
 	unsigned long rcu_tasks_nvcsw;
 	int rcu_tasks_holdout;
 	struct list_head rcu_tasks_holdout_list;
+	spinlock_t rcu_tasks_lock;
+	int rcu_tasks_exiting;
+	wait_queue_head_t *rcu_tasks_exit_wq;
 #endif /* #ifdef CONFIG_TASKS_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
@@ -2020,7 +2023,9 @@ static inline void rcu_copy_process(struct task_struct *p)
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TASKS_RCU
 	p->rcu_tasks_holdout = false;
-	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
+	p->rcu_tasks_holdout_list.prev = LIST_POISON2;
+	spin_lock_init(&p->rcu_tasks_lock);
+	p->rcu_tasks_exit_wq = NULL;
 #endif /* #ifdef CONFIG_TASKS_RCU */
 }
 
diff --git a/kernel/exit.c b/kernel/exit.c
index e5c4668f1799..b50b1afc4092 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -805,6 +805,7 @@ void do_exit(long code)
 		put_page(tsk->task_frag.page);
 
 	validate_creds_for_do_exit(tsk);
+	exit_rcu_tasks();
 
 	check_stack_usage();
 	preempt_disable();
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 030494690c93..9d2cf41f3161 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -453,15 +453,103 @@ void rcu_barrier_tasks(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 
+/*
+ * Note a RCU-tasks quiescent state, which might require interacting
+ * with an exiting task.
+ */
+static void rcu_tasks_note_qs(struct task_struct *t)
+{
+	spin_lock(&t->rcu_tasks_lock);
+	list_del_rcu(&t->rcu_tasks_holdout_list);
+	t->rcu_tasks_holdout = 0;
+	if (t->rcu_tasks_exit_wq)
+		wake_up(t->rcu_tasks_exit_wq);
+	spin_unlock(&t->rcu_tasks_lock);
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
+	for_each_process_thread(g, t) {
+		/* Acquire this thread's lock to synchronize with exit. */
+		spin_lock(&t->rcu_tasks_lock);
+		/* Assume that we must wait for this task. */
+		t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
+		ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
+		if (t->rcu_tasks_exiting) {
+			/*
+			 * Task is exiting, so don't add to list.  Instead,
+			 * set up to wait for its exiting to complete.
+			 */
+			n_exiting++;
+			t->rcu_tasks_exiting = 1; /* Task already exiting. */
+			spin_unlock(&t->rcu_tasks_lock);
+			goto next_thread;
+		}
+
+		spin_unlock(&t->rcu_tasks_lock);
+		smp_mb();  /* Order ->rcu_tasks_holdout store before "if". */
+		if (t == current || !ACCESS_ONCE(t->on_rq) || is_idle_task(t))
+			smp_store_release(&t->rcu_tasks_holdout, 0);
+		else
+			list_add_tail_rcu(&t->rcu_tasks_holdout_list,
+					  &rcu_tasks_holdouts);
+next_thread:;
+	}
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
+		for_each_process_thread(g, t) {
+			int am_exiting = ACCESS_ONCE(t->rcu_tasks_exiting);
+
+			if (am_exiting == 1 &&
+			    ACCESS_ONCE(t->rcu_tasks_holdout)) {
+				n_exiting++; /* Started exit before GP. */
+			} else if (am_exiting == 2) {
+				/* Holdout exited after GP, dequeue & wake. */
+				rcu_tasks_note_qs(t);
+			}
+		}
+		rcu_read_unlock();
+		schedule_timeout_interruptible(HZ / 10);
+	}
+}
+
 /* See if tasks are still holding out, complain if so. */
 static void check_holdout_task(struct task_struct *t,
 			       bool needreport, bool *firstreport)
 {
 	if (!smp_load_acquire(&t->rcu_tasks_holdout) ||
-	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw)) {
-		ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
-		/* @@@ need to check for usermode on CPU. */
-		list_del_rcu(&t->rcu_tasks_holdout_list);
+	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw) ||
+	    !ACCESS_ONCE(t->on_rq)) {
+		rcu_tasks_note_qs(t);
 		return;
 	}
 	if (!needreport)
@@ -477,7 +565,7 @@ static void check_holdout_task(struct task_struct *t,
 static int __noreturn rcu_tasks_kthread(void *arg)
 {
 	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *t;
 	unsigned long lastreport;
 	struct rcu_head *list;
 	struct rcu_head *next;
@@ -513,38 +601,10 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 
 		/*
 		 * There were callbacks, so we need to wait for an
-		 * RCU-tasks grace period.  Start off by scanning
-		 * the task list for tasks that are not already
-		 * voluntarily blocked.  Mark these tasks and make
-		 * a list of them in rcu_tasks_holdouts.
-		 */
-		rcu_read_lock();
-		for_each_process_thread(g, t) {
-			if (t != current && ACCESS_ONCE(t->on_rq) &&
-			    !is_idle_task(t)) {
-				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
-				t->rcu_tasks_holdout = 1;
-				list_add(&t->rcu_tasks_holdout_list,
-					 &rcu_tasks_holdouts);
-			}
-		}
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
+		 * RCU-tasks grace period.  Go build the list of
+		 * tasks that must be waited for.
 		 */
-		synchronize_sched();
+		rcu_tasks_build_list();
 
 		/*
 		 * Each pass through the following loop scans the list
@@ -608,4 +668,27 @@ static int __init rcu_spawn_tasks_kthread(void)
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
+	int exitcode;
+	struct task_struct *t = current;
+	DECLARE_WAIT_QUEUE_HEAD(wq);
+
+	spin_lock(&t->rcu_tasks_lock);
+	exitcode = t->rcu_tasks_holdout + 1;
+	t->rcu_tasks_exiting = exitcode;
+	if (exitcode)
+		t->rcu_tasks_exit_wq = &wq;
+	spin_unlock(&t->rcu_tasks_lock);
+	wait_event(wq,
+		   ACCESS_ONCE(t->rcu_tasks_holdout_list.prev) == LIST_POISON2);
+	t->rcu_tasks_exit_wq = NULL;
+}
+
 #endif /* #ifdef CONFIG_TASKS_RCU */
-- 
1.8.1.5

