Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaH1TWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:22:04 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50325 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaH1TUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:20:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v7 tip/core/rcu 04/17] rcu: Make TASKS_RCU handle tasks that are almost done exiting
Date: Thu, 28 Aug 2014 12:19:55 -0700
Message-Id: <1409253608-32538-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-0928-0000-0000-000004685EBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Once a task has passed exit_notify() in the do_exit() code path, it
is no longer on the task lists, and is therefore no longer visible
to rcu_tasks_kthread().  This means that an almost-exited task might
be preempted while within a trampoline, and this task won't be waited
on by rcu_tasks_kthread().  This commit fixes this bug by adding an
srcu_struct.  An exiting task does srcu_read_lock() just before calling
exit_notify(), and does the corresponding srcu_read_unlock() after
doing the final preempt_disable().  This means that rcu_tasks_kthread()
can do synchronize_srcu() to wait for all mostly-exited tasks to reach
their final preempt_disable() region, and then use synchronize_sched()
to wait for those tasks to finish exiting.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  3 +++
 kernel/exit.c            |  3 +++
 kernel/rcu/update.c      | 21 +++++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 640152fedcde..54b2ebb20313 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -321,6 +321,8 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
  * macro rather than an inline function to avoid #include hell.
  */
 #ifdef CONFIG_TASKS_RCU
+#define TASKS_RCU(x) x
+extern struct srcu_struct tasks_rcu_exit_srcu;
 #define rcu_note_voluntary_context_switch(t) \
 	do { \
 		preempt_disable(); /* Exclude synchronize_sched(); */ \
@@ -329,6 +331,7 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 		preempt_enable(); \
 	} while (0)
 #else /* #ifdef CONFIG_TASKS_RCU */
+#define TASKS_RCU(x) do { } while (0)
 #define rcu_note_voluntary_context_switch(t)	do { } while (0)
 #endif /* #else #ifdef CONFIG_TASKS_RCU */
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7433a3..d13f2eec4bb8 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -667,6 +667,7 @@ void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
+	TASKS_RCU(int tasks_rcu_i);
 
 	profile_task_exit(tsk);
 
@@ -775,6 +776,7 @@ void do_exit(long code)
 	 */
 	flush_ptrace_hw_breakpoint(tsk);
 
+	TASKS_RCU(tasks_rcu_i = __srcu_read_lock(&tasks_rcu_exit_srcu));
 	exit_notify(tsk, group_dead);
 	proc_exit_connector(tsk);
 #ifdef CONFIG_NUMA
@@ -814,6 +816,7 @@ void do_exit(long code)
 	if (tsk->nr_dirtied)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
 	exit_rcu();
+	TASKS_RCU(__srcu_read_unlock(&tasks_rcu_exit_srcu, tasks_rcu_i));
 
 	/*
 	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 5fd1ddbfcc55..403fc4ae539e 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -367,6 +367,13 @@ static struct rcu_head *rcu_tasks_cbs_head;
 static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
 static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
 
+/* Track exiting tasks in order to allow them to be waited for. */
+DEFINE_SRCU(tasks_rcu_exit_srcu);
+
+/* Control stall timeouts.  Disable with <= 0, otherwise jiffies till stall. */
+static int rcu_task_stall_timeout __read_mostly = HZ * 60 * 3;
+module_param(rcu_task_stall_timeout, int, 0644);
+
 /* Post an RCU-tasks callback. */
 void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
 {
@@ -518,6 +525,15 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		rcu_read_unlock();
 
 		/*
+		 * Wait for tasks that are in the process of exiting.
+		 * This does only part of the job, ensuring that all
+		 * tasks that were previously exiting reach the point
+		 * where they have disabled preemption, allowing the
+		 * later synchronize_sched() to finish the job.
+		 */
+		synchronize_srcu(&tasks_rcu_exit_srcu);
+
+		/*
 		 * Each pass through the following loop scans the list
 		 * of holdout tasks, removing any that are no longer
 		 * holdouts.  When the list is empty, we are done.
@@ -546,6 +562,11 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		 * ->rcu_tasks_holdout accesses to be within the grace
 		 * period, avoiding the need for memory barriers for
 		 * ->rcu_tasks_holdout accesses.
+		 *
+		 * In addition, this synchronize_sched() waits for exiting
+		 * tasks to complete their final preempt_disable() region
+		 * of execution, cleaning up after the synchronize_srcu()
+		 * above.
 		 */
 		synchronize_sched();
 
-- 
1.8.1.5

