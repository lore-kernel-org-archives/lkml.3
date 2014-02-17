Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaBQVlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:41:13 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:51055 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaBQVkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:40:36 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: Optimize rcu_needs_cpu() for RCU_NOCB_CPU_ALL
Date: Mon, 17 Feb 2014 13:40:26 -0800
Message-Id: <1392673227-7066-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392673227-7066-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217214007.GA6609@linux.vnet.ibm.com>
 <1392673227-7066-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-0928-0000-0000-000006841D50
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
index 92365b1fede4..da77ef26b4ac 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1015,6 +1015,15 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
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
index b3d116cd072d..c2c8234a0291 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2880,7 +2880,7 @@ static int rcu_pending(int cpu)
  * non-NULL, store an indication of whether all callbacks are lazy.
  * (If there are no callbacks, all of them are deemed to be lazy.)
  */
-static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
+static int __maybe_unused rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 {
 	bool al = true;
 	bool hc = false;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 39a50b918bff..820b06aefbee 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1586,11 +1586,13 @@ static void rcu_prepare_kthreads(int cpu)
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
@@ -1696,6 +1698,7 @@ static bool rcu_try_advance_all_cbs(void)
  *
  * The caller must have disabled interrupts.
  */
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 int rcu_needs_cpu(int cpu, unsigned long *dj)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
@@ -1726,6 +1729,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
 	}
 	return 0;
 }
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
  * Prepare a CPU for idle from an RCU perspective.  The first major task
-- 
1.8.1.5

