Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaHKWx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:53:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58734 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaHKWtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:49:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v5 tip/core/rcu 12/16] rcu: Make TASKS_RCU handle nohz_full= CPUs
Date: Mon, 11 Aug 2014 15:49:01 -0700
Message-Id: <1407797345-28227-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081122-6688-0000-0000-000003EF1167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently TASKS_RCU would ignore a CPU running a task in nohz_full=
usermode execution.  There would be neither a context switch nor a
scheduling-clock interrupt to tell TASKS_RCU that the task in question
had passed through a quiescent state.  The grace period would therefore
extend indefinitely.  This commit therefore makes RCU's dyntick-idle
subsystem record the task_struct structure of the task that is running
in dyntick-idle mode on each CPU.  The TASKS_RCU grace period can
then access this information and record a quiescent state on
behalf of any CPU running in dyntick-idle usermode.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |  3 ++-
 include/linux/sched.h     |  2 ++
 kernel/rcu/tree.c         |  2 ++
 kernel/rcu/tree.h         |  2 ++
 kernel/rcu/tree_plugin.h  | 16 ++++++++++++++++
 kernel/rcu/update.c       |  4 +++-
 6 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 78715ea7c30c..642828009324 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -128,7 +128,8 @@ extern struct group_info init_groups;
 #define INIT_TASK_RCU_TASKS(tsk)					\
 	.rcu_tasks_holdout = false,					\
 	.rcu_tasks_holdout_list =					\
-		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),
+		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),		\
+	.rcu_tasks_idle_cpu = -1,
 #else
 #define INIT_TASK_RCU_TASKS(tsk)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3cf124389ec7..5fa041f7a034 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1277,6 +1277,7 @@ struct task_struct {
 	unsigned long rcu_tasks_nvcsw;
 	int rcu_tasks_holdout;
 	struct list_head rcu_tasks_holdout_list;
+	int rcu_tasks_idle_cpu;
 #endif /* #ifdef CONFIG_TASKS_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
@@ -2021,6 +2022,7 @@ static inline void rcu_copy_process(struct task_struct *p)
 #ifdef CONFIG_TASKS_RCU
 	p->rcu_tasks_holdout = false;
 	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
+	p->rcu_tasks_idle_cpu = -1;
 #endif /* #ifdef CONFIG_TASKS_RCU */
 }
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 645a33efc0d4..0d9ee1e4f446 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -526,6 +526,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	rcu_dynticks_task_enter();
 
 	/*
 	 * It is illegal to enter an extended quiescent state while
@@ -642,6 +643,7 @@ void rcu_irq_exit(void)
 static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 			       int user)
 {
+	rcu_dynticks_task_exit();
 	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 0f69a79c5b7d..37ff593b7725 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -579,6 +579,8 @@ static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
+static void rcu_dynticks_task_enter(void);
+static void rcu_dynticks_task_exit(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a86a363ea453..0d8ef5cb1976 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2852,3 +2852,19 @@ static void rcu_bind_gp_kthread(void)
 		set_cpus_allowed_ptr(current, cpumask_of(cpu));
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
+
+/* Record the current task on dyntick-idle entry. */
+static void rcu_dynticks_task_enter(void)
+{
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+	ACCESS_ONCE(current->rcu_tasks_idle_cpu) = smp_processor_id();
+#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+}
+
+/* Record no current task on dyntick-idle exit. */
+static void rcu_dynticks_task_exit(void)
+{
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+	ACCESS_ONCE(current->rcu_tasks_idle_cpu) = -1;
+#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+}
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index d997163c7e92..a4140f25cf1a 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -466,7 +466,9 @@ static void check_holdout_task(struct task_struct *t,
 {
 	if (!ACCESS_ONCE(t->rcu_tasks_holdout) ||
 	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw) ||
-	    !ACCESS_ONCE(t->on_rq)) {
+	    !ACCESS_ONCE(t->on_rq) ||
+	    (IS_ENABLED(CONFIG_NO_HZ_FULL) &&
+	     !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)) {
 		ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
 		list_del_rcu(&t->rcu_tasks_holdout_list);
 		put_task_struct(t);
-- 
1.8.1.5

