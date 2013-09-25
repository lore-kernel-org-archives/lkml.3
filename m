Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3IYBu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:50:28 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45560 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab3IYBuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:50:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/6] rcu: Is it safe to enter an RCU read-side critical section?
Date: Tue, 24 Sep 2013 18:50:14 -0700
Message-Id: <1380073816-32381-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014954.GA32109@linux.vnet.ibm.com>
 <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0928-0000-0000-000001FEF5A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There is currently no way for kernel code to determine whether it
is safe to enter an RCU read-side critical section, in other words,
whether or not RCU is paying attention to the currently running CPU.
Given the large and increasing quantity of code shared by the idle loop
and non-idle code, the this shortcoming is becoming increasingly painful.

This commit therefore adds __rcu_is_watching(), which returns true if
it is safe to enter an RCU read-side critical section on the currently
running CPU.  This function is quite fast, using only a __this_cpu_read().
However, the caller must disable preemption.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  8 ++++----
 include/linux/rcutiny.h  |  9 +++++++++
 include/linux/rcutree.h  |  2 ++
 kernel/rcutiny.c         |  4 ++--
 kernel/rcutree.c         | 13 +++++++++++++
 5 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f1f1bc3..a53a21a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -261,6 +261,10 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 		rcu_irq_exit(); \
 	} while (0)
 
+#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
+extern int rcu_is_cpu_idle(void);
+#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
+
 /*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
@@ -297,10 +301,6 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
-#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP)
-extern int rcu_is_cpu_idle(void);
-#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP) */
-
 #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU)
 bool rcu_lockdep_current_cpu_online(void);
 #else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e31005e..bee6659 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -132,4 +132,13 @@ static inline void rcu_scheduler_starting(void)
 }
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+#ifdef CONFIG_RCU_TRACE
+
+static inline bool __rcu_is_watching(void)
+{
+	return !rcu_is_cpu_idle();
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 226169d..293613d 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -90,4 +90,6 @@ extern void exit_rcu(void);
 extern void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 
+extern bool __rcu_is_watching(void);
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 9ed6075..b4bc618 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -174,7 +174,7 @@ void rcu_irq_enter(void)
 }
 EXPORT_SYMBOL_GPL(rcu_irq_enter);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE)
 
 /*
  * Test whether RCU thinks that the current CPU is idle.
@@ -185,7 +185,7 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+#endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
 
 /*
  * Test whether the current CPU was interrupted from idle.  Nested
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3..910d868 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -671,6 +671,19 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
+/**
+ * __rcu_is_watching - are RCU read-side critical sections safe?
+ *
+ * Return true if RCU is watching the running CPU, which means that
+ * this CPU can safely enter RCU read-side critical sections.  Unlike
+ * rcu_is_cpu_idle(), the caller of __rcu_is_watching() must have at
+ * least disabled preemption.
+ */
+bool __rcu_is_watching(void)
+{
+	return !!(atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1);
+}
+
 #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
 
 /*
-- 
1.8.1.5

