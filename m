Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab3DOVLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:11:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42961 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3DOVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:10:31 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/5] nohz: Switch from "extended nohz" to "full nohz" based naming
Date: Mon, 15 Apr 2013 23:10:17 +0200
Message-Id: <1366060220-20271-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
References: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Extended nohz" was used as a naming base for the full dynticks
API and Kconfig symbols. It reflects the fact the system tries
to stop the tick in more places than just idle.

But that "extended" name is a bit opaque and vague. Rename it to
"full" makes it clearer what the system tries to do under this
config: try to shutdown the tick anytime it can. The various
constraints that prevent that to happen shouldn't be considered
as fundamental properties of this feature but rather technical
issues that may be solved in the future.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    4 +-
 include/linux/tick.h                |    6 ++--
 kernel/sched/core.c                 |    6 ++--
 kernel/time/Kconfig                 |    4 +-
 kernel/time/tick-broadcast.c        |    2 +-
 kernel/time/tick-common.c           |    2 +-
 kernel/time/tick-sched.c            |   54 +++++++++++++++++-----------------
 7 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 231698f..82365dd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1913,8 +1913,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Valid arguments: on, off
 			Default: on
 
-	nohz_extended=  [KNL,BOOT]
-			In kernels built with CONFIG_NO_HZ_EXTENDED=y, set
+	nohz_full=	[KNL,BOOT]
+			In kernels built with CONFIG_NO_HZ_FULL=y, set
 			the specified list of CPUs whose tick will be stopped
 			whenever possible. You need to keep at least one online
 			CPU outside the range to maintain the timekeeping.
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 5e40333..b4e3b0c 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -157,10 +157,10 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !CONFIG_NO_HZ_COMMON */
 
-#ifdef CONFIG_NO_HZ_EXTENDED
-extern int tick_nohz_extended_cpu(int cpu);
+#ifdef CONFIG_NO_HZ_FULL
+extern int tick_nohz_full_cpu(int cpu);
 #else
-static inline int tick_nohz_extended_cpu(int cpu) { return 0; }
+static inline int tick_nohz_full_cpu(int cpu) { return 0; }
 #endif
 
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9bb397d..0f0a5b3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -617,9 +617,9 @@ static void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
-static bool wake_up_extended_nohz_cpu(int cpu)
+static bool wake_up_full_nohz_cpu(int cpu)
 {
-	if (tick_nohz_extended_cpu(cpu)) {
+	if (tick_nohz_full_cpu(cpu)) {
 		if (cpu != smp_processor_id() ||
 		    tick_nohz_tick_stopped())
 			smp_send_reschedule(cpu);
@@ -631,7 +631,7 @@ static bool wake_up_extended_nohz_cpu(int cpu)
 
 void wake_up_nohz_cpu(int cpu)
 {
-	if (!wake_up_extended_nohz_cpu(cpu))
+	if (!wake_up_full_nohz_cpu(cpu))
 		wake_up_idle_cpu(cpu);
 }
 
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index cbe64be..4a17b50 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -96,7 +96,7 @@ config NO_HZ_IDLE
 
 	  Most of the time you want to say Y here.
 
-config NO_HZ_EXTENDED
+config NO_HZ_FULL
 	bool "Full dynticks system (tickless single task)"
 	# NO_HZ_COMMON dependency
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
@@ -115,7 +115,7 @@ config NO_HZ_EXTENDED
 	 task on the CPU. Chances for running tickless are maximized when
 	 the task mostly runs in userspace and has few kernel activity.
 
-	 You need to fill up the nohz_extended boot parameter with the
+	 You need to fill up the nohz_full boot parameter with the
 	 desired range of dynticks CPUs.
 
 	 This is implemented at the expense of some overhead in user <-> kernel
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 8a6875c..a3a3123 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -573,7 +573,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
 		/* Take the do_timer update */
-		if (!tick_nohz_extended_cpu(cpu))
+		if (!tick_nohz_full_cpu(cpu))
 			tick_do_timer_cpu = cpu;
 
 		/*
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b7dc0cb..83f2bd9 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -163,7 +163,7 @@ static void tick_setup_device(struct tick_device *td,
 		 * this cpu:
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
-			if (!tick_nohz_extended_cpu(cpu))
+			if (!tick_nohz_full_cpu(cpu))
 				tick_do_timer_cpu = cpu;
 			else
 				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e057d33..369b576 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -113,7 +113,7 @@ static void tick_sched_do_timer(ktime_t now)
 	 * jiffies_lock.
 	 */
 	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
-	    && !tick_nohz_extended_cpu(cpu))
+	    && !tick_nohz_full_cpu(cpu))
 		tick_do_timer_cpu = cpu;
 #endif
 
@@ -143,29 +143,29 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 	profile_tick(CPU_PROFILING);
 }
 
-#ifdef CONFIG_NO_HZ_EXTENDED
-static cpumask_var_t nohz_extended_mask;
-bool have_nohz_extended_mask;
+#ifdef CONFIG_NO_HZ_FULL
+static cpumask_var_t nohz_full_mask;
+bool have_nohz_full_mask;
 
-int tick_nohz_extended_cpu(int cpu)
+int tick_nohz_full_cpu(int cpu)
 {
-	if (!have_nohz_extended_mask)
+	if (!have_nohz_full_mask)
 		return 0;
 
-	return cpumask_test_cpu(cpu, nohz_extended_mask);
+	return cpumask_test_cpu(cpu, nohz_full_mask);
 }
 
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
-static int __init tick_nohz_extended_setup(char *str)
+static int __init tick_nohz_full_setup(char *str)
 {
-	alloc_bootmem_cpumask_var(&nohz_extended_mask);
-	if (cpulist_parse(str, nohz_extended_mask) < 0)
-		pr_warning("NOHZ: Incorrect nohz_extended cpumask\n");
+	alloc_bootmem_cpumask_var(&nohz_full_mask);
+	if (cpulist_parse(str, nohz_full_mask) < 0)
+		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
 	else
-		have_nohz_extended_mask = true;
+		have_nohz_full_mask = true;
 	return 1;
 }
-__setup("nohz_extended=", tick_nohz_extended_setup);
+__setup("nohz_full=", tick_nohz_full_setup);
 
 static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 						 unsigned long action,
@@ -179,7 +179,7 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 		 * If we handle the timekeeping duty for full dynticks CPUs,
 		 * we can't safely shutdown that CPU.
 		 */
-		if (have_nohz_extended_mask && tick_do_timer_cpu == cpu)
+		if (have_nohz_full_mask && tick_do_timer_cpu == cpu)
 			return -EINVAL;
 		break;
 	}
@@ -191,20 +191,20 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
  * separations: 0,2,4,6,...
  * This is NR_CPUS + sizeof('\0')
  */
-static char __initdata nohz_ext_buf[NR_CPUS + 1];
+static char __initdata nohz_full_buf[NR_CPUS + 1];
 
-static int __init init_tick_nohz_extended(void)
+static int __init init_tick_nohz_full(void)
 {
 	cpumask_var_t online_nohz;
 	int cpu;
 
-	if (!have_nohz_extended_mask)
+	if (!have_nohz_full_mask)
 		return 0;
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
 
 	if (!zalloc_cpumask_var(&online_nohz, GFP_KERNEL)) {
-		pr_warning("NO_HZ: Not enough memory to check extended nohz mask\n");
+		pr_warning("NO_HZ: Not enough memory to check full nohz mask\n");
 		return -ENOMEM;
 	}
 
@@ -215,31 +215,31 @@ static int __init init_tick_nohz_extended(void)
 	get_online_cpus();
 
 	/* Ensure we keep a CPU outside the dynticks range for timekeeping */
-	cpumask_and(online_nohz, cpu_online_mask, nohz_extended_mask);
+	cpumask_and(online_nohz, cpu_online_mask, nohz_full_mask);
 	if (cpumask_equal(online_nohz, cpu_online_mask)) {
 		pr_warning("NO_HZ: Must keep at least one online CPU "
-			   "out of nohz_extended range\n");
+			   "out of nohz_full range\n");
 		/*
 		 * We know the current CPU doesn't have its tick stopped.
 		 * Let's use it for the timekeeping duty.
 		 */
 		preempt_disable();
 		cpu = smp_processor_id();
-		pr_warning("NO_HZ: Clearing %d from nohz_extended range\n", cpu);
-		cpumask_clear_cpu(cpu, nohz_extended_mask);
+		pr_warning("NO_HZ: Clearing %d from nohz_full range\n", cpu);
+		cpumask_clear_cpu(cpu, nohz_full_mask);
 		preempt_enable();
 	}
 	put_online_cpus();
 	free_cpumask_var(online_nohz);
 
-	cpulist_scnprintf(nohz_ext_buf, sizeof(nohz_ext_buf), nohz_extended_mask);
-	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_ext_buf);
+	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), nohz_full_mask);
+	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
 
 	return 0;
 }
-core_initcall(init_tick_nohz_extended);
+core_initcall(init_tick_nohz_full);
 #else
-#define have_nohz_extended_mask (0)
+#define have_nohz_full_mask (0)
 #endif
 
 /*
@@ -589,7 +589,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		return false;
 	}
 
-	if (have_nohz_extended_mask) {
+	if (have_nohz_full_mask) {
 		/*
 		 * Keep the tick alive to guarantee timekeeping progression
 		 * if there are full dynticks CPUs around
-- 
1.7.5.4

