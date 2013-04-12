Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3DLXt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:49:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43656 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3DLXsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:48:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/12] rcu: Simplify RCU_TINY RCU callback invocation
Date: Fri, 12 Apr 2013 16:48:25 -0700
Message-Id: <1365810511-24811-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412234810.GA23678@linux.vnet.ibm.com>
 <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5406-0000-0000-0000076934BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

TINY_PREEMPT_RCU could use a kthread to handle RCU callback invocation,
which required an API to abstract kthread vs. softirq invocation.
Now that TINY_PREEMPT_RCU is no longer with us, this commit retires
this API in favor of direct use of the relevant softirq primitives.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  1 +
 include/linux/rcutiny.h  |  4 ----
 include/linux/rcutree.h  |  1 -
 kernel/rcutiny.c         | 14 +++++++++-----
 kernel/rcutiny_plugin.h  | 33 ---------------------------------
 5 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0a8276d..1c53a9f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -216,6 +216,7 @@ static inline int rcu_preempt_depth(void)
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /* Internal to kernel */
+extern void rcu_init(void);
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 4e56a9c..592fad8 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,10 +27,6 @@
 
 #include <linux/cache.h>
 
-static inline void rcu_init(void)
-{
-}
-
 static inline void rcu_barrier_bh(void)
 {
 	wait_rcu_gp(call_rcu_bh);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 952b793..3f1aa8f 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,7 +30,6 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-extern void rcu_init(void);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
 extern void rcu_cpu_stall_reset(void);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 7fc2339..4adc9e2 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -44,7 +44,6 @@
 
 /* Forward declarations for rcutiny_plugin.h. */
 struct rcu_ctrlblk;
-static void invoke_rcu_callbacks(void);
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
 static void rcu_process_callbacks(struct softirq_action *unused);
 static void __call_rcu(struct rcu_head *head,
@@ -227,7 +226,7 @@ void rcu_sched_qs(int cpu)
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_callbacks();
+		raise_softirq(RCU_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -240,7 +239,7 @@ void rcu_bh_qs(int cpu)
 
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_callbacks();
+		raise_softirq(RCU_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -277,7 +276,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 					      ACCESS_ONCE(rcp->rcucblist),
 					      need_resched(),
 					      is_idle_task(current),
-					      rcu_is_callbacks_kthread()));
+					      false));
 		return;
 	}
 
@@ -307,7 +306,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
 	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count, 0, need_resched(),
 				      is_idle_task(current),
-				      rcu_is_callbacks_kthread()));
+				      false));
 }
 
 static void rcu_process_callbacks(struct softirq_action *unused)
@@ -379,3 +378,8 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+void rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index bfe9924..36fd83c 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -102,39 +102,6 @@ static void check_cpu_stalls(void)
 	RCU_TRACE(check_cpu_stall_preempt());
 }
 
-/* Hold off callback invocation until early_initcall() time. */
-static int rcu_scheduler_fully_active __read_mostly;
-
-/*
- * Start up softirq processing of callbacks.
- */
-void invoke_rcu_callbacks(void)
-{
-	if (rcu_scheduler_fully_active)
-		raise_softirq(RCU_SOFTIRQ);
-}
-
-#ifdef CONFIG_RCU_TRACE
-
-/*
- * There is no callback kthread, so this thread is never it.
- */
-static bool rcu_is_callbacks_kthread(void)
-{
-	return false;
-}
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-static int __init rcu_scheduler_really_started(void)
-{
-	rcu_scheduler_fully_active = 1;
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
-	raise_softirq(RCU_SOFTIRQ);  /* Invoke any callbacks from early boot. */
-	return 0;
-}
-early_initcall(rcu_scheduler_really_started);
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #include <linux/kernel_stat.h>
 
-- 
1.8.1.5

