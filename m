Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaIUQuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:50:00 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:61099 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaIUQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:49:58 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] rcu: Remove redundant CONFIG_PREEMPT_RCU option
Date: Sun, 21 Sep 2014 12:49:54 -0400
Message-Id: <1411318194-9433-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_RCU and TREE_PREEMPT_RCU serve the same function after TINY_PREEMPT_RCU
has been removed. This patch removes CONFIG_PREEMPT_RCU and uses
CONFIG_TREE_PREEMPT_RCU in its place.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/xtensa/configs/s6105_defconfig                      |  2 +-
 include/linux/init_task.h                                |  2 +-
 include/linux/rcupdate.h                                 | 16 ++++++++--------
 include/linux/sched.h                                    | 10 +++++-----
 init/Kconfig                                             |  6 ------
 kernel/rcu/update.c                                      |  4 ++--
 tools/testing/selftests/rcutorture/doc/TINY_RCU.txt      |  2 +-
 .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt        |  2 +-
 8 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 12a492a..dab1a99 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -35,7 +35,7 @@ CONFIG_SYSVIPC_SYSCTL=y
 #
 # CONFIG_CLASSIC_RCU is not set
 # CONFIG_TREE_RCU is not set
-CONFIG_PREEMPT_RCU=y
+CONFIG_TREE_PREEMPT_RCU=y
 # CONFIG_RCU_TRACE is not set
 # CONFIG_TREE_RCU_TRACE is not set
 # CONFIG_PREEMPT_RCU_TRACE is not set
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 77fc43f..39600f4 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -108,7 +108,7 @@ extern struct group_info init_groups;
 #else
 #define INIT_TASK_RCU_TREE_PREEMPT(tsk)
 #endif
-#ifdef CONFIG_PREEMPT_RCU
+#ifdef CONFIG_TREE_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special.s = 0,					\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a4a819f..17a15d5 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -103,7 +103,7 @@ void do_trace_rcu_torture_read(const char *rcutorturename,
 
 /* Exported common interfaces */
 
-#ifdef CONFIG_PREEMPT_RCU
+#ifdef CONFIG_TREE_PREEMPT_RCU
 
 /**
  * call_rcu() - Queue an RCU callback for invocation after a grace period.
@@ -140,12 +140,12 @@ void do_trace_rcu_torture_read(const char *rcutorturename,
 void call_rcu(struct rcu_head *head,
 	      void (*func)(struct rcu_head *head));
 
-#else /* #ifdef CONFIG_PREEMPT_RCU */
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 /* In classic RCU, call_rcu() is just call_rcu_sched(). */
 #define	call_rcu	call_rcu_sched
 
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 /**
  * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
@@ -217,7 +217,7 @@ void call_rcu_tasks(struct rcu_head *head, void (*func)(struct rcu_head *head));
 void synchronize_rcu_tasks(void);
 void rcu_barrier_tasks(void);
 
-#ifdef CONFIG_PREEMPT_RCU
+#ifdef CONFIG_TREE_PREEMPT_RCU
 
 void __rcu_read_lock(void);
 void __rcu_read_unlock(void);
@@ -227,12 +227,12 @@ void synchronize_rcu(void);
 /*
  * Defined as a macro as it is a very low level header included from
  * areas that don't even know about current.  This gives the rcu_read_lock()
- * nesting depth, but makes sense only if CONFIG_PREEMPT_RCU -- in other
+ * nesting depth, but makes sense only if CONFIG_TREE_PREEMPT_RCU -- in other
  * types of kernel builds, the rcu_read_lock() nesting depth is unknowable.
  */
 #define rcu_preempt_depth() (current->rcu_read_lock_nesting)
 
-#else /* #ifdef CONFIG_PREEMPT_RCU */
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock(void)
 {
@@ -254,7 +254,7 @@ static inline int rcu_preempt_depth(void)
 	return 0;
 }
 
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 /* Internal to kernel */
 void rcu_init(void);
@@ -530,7 +530,7 @@ static inline int rcu_read_lock_sched_held(void)
 		}							\
 	} while (0)
 
-#if defined(CONFIG_PROVE_RCU) && !defined(CONFIG_PREEMPT_RCU)
+#if defined(CONFIG_PROVE_RCU) && !defined(CONFIG_TREE_PREEMPT_RCU)
 static inline void rcu_preempt_sleep_check(void)
 {
 	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 42888d7..6acaa30 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1269,11 +1269,11 @@ struct task_struct {
 	int nr_cpus_allowed;
 	cpumask_t cpus_allowed;
 
-#ifdef CONFIG_PREEMPT_RCU
+#ifdef CONFIG_TREE_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	union rcu_special rcu_read_unlock_special;
 	struct list_head rcu_node_entry;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
@@ -2014,12 +2014,12 @@ extern void task_clear_jobctl_pending(struct task_struct *task,
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
-#ifdef CONFIG_PREEMPT_RCU
+#ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_read_lock_nesting = 0;
 	p->rcu_read_unlock_special.s = 0;
 	p->rcu_blocked_node = NULL;
 	INIT_LIST_HEAD(&p->rcu_node_entry);
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 #ifdef CONFIG_TASKS_RCU
 	p->rcu_tasks_holdout = false;
 	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
@@ -2752,7 +2752,7 @@ extern int __cond_resched_softirq(void);
 
 static inline void cond_resched_rcu(void)
 {
-#if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
+#if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_TREE_PREEMPT_RCU)
 	rcu_read_unlock();
 	cond_resched();
 	rcu_read_lock();
diff --git a/init/Kconfig b/init/Kconfig
index 8a2b97c..27ad03c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -501,12 +501,6 @@ config TINY_RCU
 
 endchoice
 
-config PREEMPT_RCU
-	def_bool TREE_PREEMPT_RCU
-	help
-	  This option enables preemptible-RCU code that is common between
-	  TREE_PREEMPT_RCU and, in the old days, TINY_PREEMPT_RCU.
-
 config TASKS_RCU
 	bool "Task_based RCU implementation using voluntary context switch"
 	default n
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 3ef8ba5..8848a32 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -62,7 +62,7 @@ MODULE_ALIAS("rcupdate");
 
 module_param(rcu_expedited, int, 0);
 
-#ifdef CONFIG_PREEMPT_RCU
+#ifdef CONFIG_TREE_PREEMPT_RCU
 
 /*
  * Preemptible RCU implementation for rcu_read_lock().
@@ -108,7 +108,7 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
diff --git a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
index 28db67b..4fea92d 100644
--- a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
+++ b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
@@ -31,7 +31,7 @@ CONFIG_RCU_TORTURE_TEST
 
 CONFIG_HOTPLUG_CPU
 CONFIG_PREEMPT
-CONFIG_PREEMPT_RCU
+CONFIG_TREE_PREEMPT_RCU
 CONFIG_SMP
 CONFIG_TINY_RCU
 CONFIG_TREE_PREEMPT_RCU
diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
index f85c45e..081dece 100644
--- a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
+++ b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
@@ -62,7 +62,7 @@ CONFIG_NO_HZ_FULL_SYSIDLE_SMALL
 	Defer until Frederic uses this.
 
 CONFIG_PREEMPT_COUNT
-CONFIG_PREEMPT_RCU
+CONFIG_TREE_PREEMPT_RCU
 
 	Redundant with CONFIG_PREEMPT, ignore.
 
-- 
2.1.0

