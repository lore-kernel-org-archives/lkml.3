Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3A0FSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 00:18:39 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59744 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3A0FQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 00:16:07 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: Provide RCU CPU stall warnings for tiny RCU
Date: Sat, 26 Jan 2013 16:23:46 -0800
Message-Id: <1359246227-5770-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20130127002328.GA4847@linux.vnet.ibm.com>
References: <20130127002328.GA4847@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012705-3620-0000-0000-000001011217
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Tiny RCU has historically omitted RCU CPU stall warnings in order to
reduce memory requirements, however, lack of these warnings caused
Thomas Gleixner some debugging pain recently.  Therefore, this commit
adds RCU CPU stall warnings to tiny RCU if RCU_TRACE=y.  This keeps
the memory footprint small, while still enabling CPU stall warnings
in kernels built to enable them.

Updated to include Josh Triplett's suggested use of RCU_STALL_COMMON
config variable to simplify #if expressions.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            |    8 ++++++
 kernel/rcu.h            |    7 ++++++
 kernel/rcupdate.c       |   51 ++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny.c        |    6 +++-
 kernel/rcutiny_plugin.h |   56 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree.c        |   46 ++------------------------------------
 kernel/rcutree.h        |    5 ----
 lib/Kconfig.debug       |    2 +-
 8 files changed, 130 insertions(+), 51 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 7d30240..a5e90e1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -486,6 +486,14 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
+config RCU_STALL_COMMON
+	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
+	help
+	  This option enables RCU CPU stall code that is common between
+	  the TINY and TREE variants of RCU.  The purpose is to allow
+	  the tiny variants to disable RCU CPU stall warnings, while
+	  making these warnings mandatory for the tree variants.
+
 config CONTEXT_TRACKING
        bool
 
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 20dfba5..7f8e759 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -111,4 +111,11 @@ static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 
 extern int rcu_expedited;
 
+#ifdef CONFIG_RCU_STALL_COMMON
+
+extern int rcu_cpu_stall_suppress;
+int rcu_jiffies_till_stall_check(void);
+
+#endif /* #ifdef CONFIG_RCU_STALL_COMMON */
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a2cf761..076730d 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -412,3 +412,54 @@ EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
 #else
 #define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
 #endif
+
+#ifdef CONFIG_RCU_STALL_COMMON
+
+#ifdef CONFIG_PROVE_RCU
+#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
+#else
+#define RCU_STALL_DELAY_DELTA	       0
+#endif
+
+int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
+int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
+
+module_param(rcu_cpu_stall_suppress, int, 0644);
+module_param(rcu_cpu_stall_timeout, int, 0644);
+
+int rcu_jiffies_till_stall_check(void)
+{
+	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
+
+	/*
+	 * Limit check must be consistent with the Kconfig limits
+	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
+	 */
+	if (till_stall_check < 3) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
+		till_stall_check = 3;
+	} else if (till_stall_check > 300) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
+		till_stall_check = 300;
+	}
+	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
+}
+
+static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
+{
+	rcu_cpu_stall_suppress = 1;
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rcu_panic_block = {
+	.notifier_call = rcu_panic,
+};
+
+static int __init check_cpu_stall_init(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
+	return 0;
+}
+early_initcall(check_cpu_stall_init);
+
+#endif /* #ifdef CONFIG_RCU_STALL_COMMON */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e7dce58..b899df3 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -51,10 +51,10 @@ static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
 
-#include "rcutiny_plugin.h"
-
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
+#include "rcutiny_plugin.h"
+
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long newval)
 {
@@ -205,6 +205,7 @@ int rcu_is_cpu_rrupt_from_idle(void)
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
+	reset_cpu_stall_ticks(rcp);
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
@@ -251,6 +252,7 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	check_cpu_stalls();
 	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f85016a..8a23300 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -33,6 +33,9 @@ struct rcu_ctrlblk {
 	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
 	struct rcu_head **curtail;	/* ->next pointer of last CB. */
 	RCU_TRACE(long qlen);		/* Number of pending CBs. */
+	RCU_TRACE(unsigned long gp_start); /* Start time for stalls. */
+	RCU_TRACE(unsigned long ticks_this_gp); /* Statistic for stalls. */
+	RCU_TRACE(unsigned long jiffies_stall); /* Jiffies at next stall. */
 	RCU_TRACE(char *name);		/* Name of RCU type. */
 };
 
@@ -54,6 +57,51 @@ int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+#ifdef CONFIG_RCU_TRACE
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	unsigned long j;
+	unsigned long js;
+
+	if (rcu_cpu_stall_suppress)
+		return;
+	rcp->ticks_this_gp++;
+	j = jiffies;
+	js = rcp->jiffies_stall;
+	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
+		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
+		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
+		       jiffies - rcp->gp_start, rcp->qlen);
+		dump_stack();
+	}
+	if (*rcp->curtail && ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies +
+			3 * rcu_jiffies_till_stall_check() + 3;
+	else if (ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+}
+
+static void check_cpu_stall_preempt(void);
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
+static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
+{
+#ifdef CONFIG_RCU_TRACE
+	rcp->ticks_this_gp = 0;
+	rcp->gp_start = jiffies;
+	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+#endif /* #ifdef CONFIG_RCU_TRACE */
+}
+
+static void check_cpu_stalls(void)
+{
+	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
+	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
+	RCU_TRACE(check_cpu_stall_preempt());
+}
+
 #ifdef CONFIG_TINY_PREEMPT_RCU
 
 #include <linux/delay.h>
@@ -448,6 +496,7 @@ static void rcu_preempt_start_gp(void)
 		/* Official start of GP. */
 		rcu_preempt_ctrlblk.gpnum++;
 		RCU_TRACE(rcu_preempt_ctrlblk.n_grace_periods++);
+		reset_cpu_stall_ticks(&rcu_preempt_ctrlblk.rcb);
 
 		/* Any blocked RCU readers block new GP. */
 		if (rcu_preempt_blocked_readers_any())
@@ -1054,4 +1103,11 @@ MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
 MODULE_LICENSE("GPL");
 
+static void check_cpu_stall_preempt(void)
+{
+#ifdef CONFIG_TINY_PREEMPT_RCU
+	check_cpu_stall(&rcu_preempt_ctrlblk.rcb);
+#endif /* #ifdef CONFIG_TINY_PREEMPT_RCU */
+}
+
 #endif /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..d069430 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -217,12 +217,6 @@ module_param(blimit, long, 0444);
 module_param(qhimark, long, 0444);
 module_param(qlowmark, long, 0444);
 
-int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
-int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
-
-module_param(rcu_cpu_stall_suppress, int, 0644);
-module_param(rcu_cpu_stall_timeout, int, 0644);
-
 static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 
@@ -793,28 +787,10 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	return 0;
 }
 
-static int jiffies_till_stall_check(void)
-{
-	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
-
-	/*
-	 * Limit check must be consistent with the Kconfig limits
-	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
-	 */
-	if (till_stall_check < 3) {
-		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
-		till_stall_check = 3;
-	} else if (till_stall_check > 300) {
-		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
-		till_stall_check = 300;
-	}
-	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
-}
-
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
-	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
+	rsp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
 }
 
 /*
@@ -857,7 +833,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
+	rsp->jiffies_stall = jiffies + 3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -935,7 +911,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
 		rsp->jiffies_stall = jiffies +
-				     3 * jiffies_till_stall_check() + 3;
+				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */
@@ -966,12 +942,6 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 }
 
-static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
-{
-	rcu_cpu_stall_suppress = 1;
-	return NOTIFY_DONE;
-}
-
 /**
  * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
  *
@@ -989,15 +959,6 @@ void rcu_cpu_stall_reset(void)
 		rsp->jiffies_stall = jiffies + ULONG_MAX / 2;
 }
 
-static struct notifier_block rcu_panic_block = {
-	.notifier_call = rcu_panic,
-};
-
-static void __init check_cpu_stall_init(void)
-{
-	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
-}
-
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
@@ -3074,7 +3035,6 @@ void __init rcu_init(void)
 	cpu_notifier(rcu_cpu_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-	check_cpu_stall_init();
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4b69291..db9bec8 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -343,11 +343,6 @@ struct rcu_data {
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 
-#ifdef CONFIG_PROVE_RCU
-#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
-#else
-#define RCU_STALL_DELAY_DELTA	       0
-#endif
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
 						/*  scheduling clock irq */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3a35309..a40a36b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -970,7 +970,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE
 	range 3 300
 	default 21
 	help
-- 
1.7.8

