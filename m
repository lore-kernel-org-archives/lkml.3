Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3DLXsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:48:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43646 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3DLXsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:48:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/12] rcu: Shrink TINY_RCU by moving exit_rcu()
Date: Fri, 12 Apr 2013 16:48:31 -0700
Message-Id: <1365810511-24811-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412234810.GA23678@linux.vnet.ibm.com>
 <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5406-0000-0000-0000076934BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that TINY_PREEMPT_RCU is no more, exit_rcu() is always an empty
function.  But if TINY_RCU is going to have an empty function, it should
be in include/linux/rcutiny.h, where it does not bloat the kernel.
This commit therefore moves exit_rcu() out of kernel/rcupdate.c to
kernel/rcutree_plugin.h, and places a static inline empty function in
include/linux/rcutiny.h in order to shrink TINY_RCU a bit.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  2 --
 include/linux/rcutiny.h  |  4 ++++
 include/linux/rcutree.h  |  2 ++
 kernel/rcupdate.c        | 26 +-------------------------
 kernel/rcutree_plugin.h  | 26 ++++++++++++++++++++++++++
 5 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1c53a9f..1d0145a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -240,8 +240,6 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
-extern void exit_rcu(void);
-
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
  * @a: Code that RCU needs to pay attention to.
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 51230b6..e31005e 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -119,6 +119,10 @@ static inline void rcu_cpu_stall_reset(void)
 {
 }
 
+static inline void exit_rcu(void)
+{
+}
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern int rcu_scheduler_active __read_mostly;
 extern void rcu_scheduler_starting(void);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3f1aa8f..226169d 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -85,6 +85,8 @@ extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
 
+extern void exit_rcu(void);
+
 extern void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 48ab703..0be1fa2 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -104,31 +104,7 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-/*
- * Check for a task exiting while in a preemptible-RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (likely(list_empty(&current->rcu_node_entry)))
-		return;
-	t->rcu_read_lock_nesting = 1;
-	barrier();
-	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
-	__rcu_read_unlock();
-}
-
-#else /* #ifdef CONFIG_PREEMPT_RCU */
-
-void exit_rcu(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e6cf7e5..086daaf 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -931,6 +931,24 @@ static void __init __rcu_init_preempt(void)
 	rcu_init_one(&rcu_preempt_state, &rcu_preempt_data);
 }
 
+/*
+ * Check for a task exiting while in a preemptible-RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.
+ */
+void exit_rcu(void)
+{
+	struct task_struct *t = current;
+
+	if (likely(list_empty(&current->rcu_node_entry)))
+		return;
+	t->rcu_read_lock_nesting = 1;
+	barrier();
+	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
+	__rcu_read_unlock();
+}
+
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static struct rcu_state *rcu_state = &rcu_sched_state;
@@ -1099,6 +1117,14 @@ static void __init __rcu_init_preempt(void)
 {
 }
 
+/*
+ * Because preemptible RCU does not exist, tasks cannot possibly exit
+ * while in preemptible RCU read-side critical sections.
+ */
+void exit_rcu(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_BOOST
-- 
1.8.1.5

