Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3KRWDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:03:06 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57433 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3KRWDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:03:01 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: Optimize rcu_needs_cpu() for RCU_NOCB_CPU_ALL
Date: Mon, 18 Nov 2013 14:02:50 -0800
Message-Id: <1384812171-23935-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384812171-23935-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131118220220.GA23353@linux.vnet.ibm.com>
 <1384812171-23935-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111822-0928-0000-0000-000003CE717F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If CONFIG_RCU_NOCB_CPU_ALL=y, then rcu_needs_cpu() will always
return false, however, the current version nevertheless checks
for RCU callbacks.  This commit therefore creates a static inline
implementation of rcu_needs_cpu() that unconditionally returns false
when CONFIG_RCU_NOCB_CPU_ALL=y.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 9 +++++++++
 include/linux/rcutiny.h  | 6 ------
 include/linux/rcutree.h  | 2 ++
 kernel/rcu/tree.c        | 2 +-
 kernel/rcu/tree_plugin.h | 4 ++++
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 277d3697f2f3..e6331a6843c4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1027,6 +1027,15 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
+#if defined(CONFIG_TINY_RCU) || defined(CONFIG_RCU_NOCB_CPU_ALL)
+
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+{
+	*delta_jiffies = ULONG_MAX;
+	return 0;
+}
+#endif /* #if defined(CONFIG_TINY_RCU) || defined(CONFIG_RCU_NOCB_CPU_ALL) */
+
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifdef CONFIG_RCU_NOCB_CPU_ALL
 static inline bool rcu_is_nocb_cpu(int cpu) { return true; }
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 6f01771b571c..9524903487d0 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -68,12 +68,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 	call_rcu(head, func);
 }
 
-static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
-{
-	*delta_jiffies = ULONG_MAX;
-	return 0;
-}
-
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 72137ee8c603..81198c84e268 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -31,7 +31,9 @@
 #define __LINUX_RCUTREE_H
 
 void rcu_note_context_switch(int cpu);
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 void rcu_cpu_stall_reset(void);
 
 /*
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7be5efd62fe5..ecca289351e0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2851,7 +2851,7 @@ static int rcu_pending(int cpu)
  * non-NULL, store an indication of whether all callbacks are lazy.
  * (If there are no callbacks, all of them are deemed to be lazy.)
  */
-static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
+static int __maybe_unused rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 {
 	bool al = true;
 	bool hc = false;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 5e7305b40a27..57d98aa2bd21 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1575,11 +1575,13 @@ static void rcu_prepare_kthreads(int cpu)
  * Because we not have RCU_FAST_NO_HZ, just check whether this CPU needs
  * any flavor of RCU.
  */
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
 	return rcu_cpu_has_callbacks(cpu, NULL);
 }
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
  * Because we do not have RCU_FAST_NO_HZ, don't bother cleaning up
@@ -1685,6 +1687,7 @@ static bool rcu_try_advance_all_cbs(void)
  *
  * The caller must have disabled interrupts.
  */
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 int rcu_needs_cpu(int cpu, unsigned long *dj)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
@@ -1715,6 +1718,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
 	}
 	return 0;
 }
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
  * Prepare a CPU for idle from an RCU perspective.  The first major task
-- 
1.8.1.5

