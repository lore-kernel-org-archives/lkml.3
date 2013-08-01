Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3HAAeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:34:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58823 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3HAAcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:32:21 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 22/23] nohz: Optimize full dynticks state checks with static keys
Date: Thu,  1 Aug 2013 02:31:39 +0200
Message-Id: <1375317100-20651-23-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These APIs are frequenctly accessed and priority is given
to optimize the full dynticks off-case in order to let
distros enable this feature without suffering from
significant performance regressions.

Let's inline these APIs and optimize them with static keys.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 include/linux/tick.h     |   25 +++++++++++++++++++++++--
 kernel/time/tick-sched.c |   14 ++------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 9180f4b..c60b079 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -10,6 +10,8 @@
 #include <linux/irqflags.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
+#include <linux/context_tracking_state.h>
+#include <linux/cpumask.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -158,15 +160,34 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !CONFIG_NO_HZ_COMMON */
 
 #ifdef CONFIG_NO_HZ_FULL
+extern bool tick_nohz_full_running;
+extern cpumask_var_t tick_nohz_full_mask;
+
+static inline bool tick_nohz_full_enabled(void)
+{
+	if (!static_key_false(&context_tracking_enabled))
+		return false;
+
+	return tick_nohz_full_running;
+}
+
+static inline bool tick_nohz_full_cpu(int cpu)
+{
+	if (!tick_nohz_full_enabled())
+		return false;
+
+	return cpumask_test_cpu(cpu, tick_nohz_full_mask);
+}
+
 extern void tick_nohz_init(void);
-extern int tick_nohz_full_cpu(int cpu);
 extern void tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
 extern void tick_nohz_task_switch(struct task_struct *tsk);
 #else
 static inline void tick_nohz_init(void) { }
-static inline int tick_nohz_full_cpu(int cpu) { return 0; }
+static inline bool tick_nohz_full_enabled(void) { return false; }
+static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 71735ea..6d6bd6e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -149,7 +149,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_NO_HZ_FULL
-static cpumask_var_t tick_nohz_full_mask;
+cpumask_var_t tick_nohz_full_mask;
 bool tick_nohz_full_running;
 
 static bool can_stop_full_tick(void)
@@ -269,14 +269,6 @@ out:
 	local_irq_restore(flags);
 }
 
-int tick_nohz_full_cpu(int cpu)
-{
-	if (!tick_nohz_full_running)
-		return 0;
-
-	return cpumask_test_cpu(cpu, tick_nohz_full_mask);
-}
-
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
 static int __init tick_nohz_full_setup(char *str)
 {
@@ -358,8 +350,6 @@ void __init tick_nohz_init(void)
 	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), tick_nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
 }
-#else
-#define tick_nohz_full_running (0)
 #endif
 
 /*
@@ -737,7 +727,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		return false;
 	}
 
-	if (tick_nohz_full_running) {
+	if (tick_nohz_full_enabled()) {
 		/*
 		 * Keep the tick alive to guarantee timekeeping progression
 		 * if there are full dynticks CPUs around
-- 
1.7.5.4

