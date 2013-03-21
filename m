Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3CUPYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:24:39 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:60657 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3CUPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:24:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] nohz: Basic full dynticks interface
Date: Thu, 21 Mar 2013 16:24:18 +0100
Message-Id: <1363879460-21595-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For extreme usecases such as Real Time or HPC, having
the ability to shutdown the tick when a single task runs
on a CPU is a desired feature:

* Reducing the amount of interrupts improves throughput
for CPU-bound tasks. The CPU is less distracted from its
real job, from an execution time and from the cache point
of views.

* This also improve latency response as we have less critical
sections.

Start with introducing a very simple interface to define
full dynticks CPU: use a boot time option defined cpumask
through the "nohz_extended=" kernel parameter. CPUs that
are part of this range will have their tick shutdown
whenever possible: provided they run a single task and
they don't do kernel activity that require the periodic
tick. These details will be later documented in
Documentation/*

An online CPU must be kept outside this range to handle the
timekeeping.

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    6 +++
 include/linux/tick.h                |    7 ++++
 kernel/time/Kconfig                 |   19 +++++++++++
 kernel/time/tick-sched.c            |   62 +++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..231698f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1913,6 +1913,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Valid arguments: on, off
 			Default: on
 
+	nohz_extended=  [KNL,BOOT]
+			In kernels built with CONFIG_NO_HZ_EXTENDED=y, set
+			the specified list of CPUs whose tick will be stopped
+			whenever possible. You need to keep at least one online
+			CPU outside the range to maintain the timekeeping.
+
 	noiotrap	[SH] Disables trapped I/O port accesses.
 
 	noirqdebug	[X86-32] Disables the code which attempts to detect and
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 553272e..44bfa8a 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -157,6 +157,13 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
+#ifdef CONFIG_NO_HZ_EXTENDED
+extern int tick_nohz_extended_cpu(int cpu);
+#else
+static inline int tick_nohz_extended_cpu(int cpu) { return 0; }
+#endif
+
+
 # ifdef CONFIG_CPU_IDLE_GOV_MENU
 extern void menu_hrtimer_cancel(void);
 # else
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 24510d8..5a87c03 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -79,6 +79,25 @@ config NO_HZ
 	  only trigger on an as-needed basis both when the system is
 	  busy and when the system is idle.
 
+config NO_HZ_EXTENDED
+       bool "Full dynticks system"
+       depends on NO_HZ && RCU_USER_QS && VIRT_CPU_ACCOUNTING_GEN && RCU_NOCB_CPU && SMP
+       select CONTEXT_TRACKING_FORCE
+       help
+         Adaptively try to shutdown the tick whenever possible, even when
+	 the CPU is running tasks. Typically this requires running a single
+	 task on the CPU. Chances for running tickless are maximized when
+	 the task mostly runs in userspace and has few kernel activity.
+
+	 You need to fill up the nohz_extended boot parameter with the
+	 desired range of dynticks CPUs.
+
+	 This is implemented at the expense of some overhead in user <-> kernel
+	 transitions: syscalls, exceptions and interrupts. Even when it's
+	 dynamically off.
+
+	 Say N.
+
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a19a399..79c275f0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -142,6 +142,68 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 	profile_tick(CPU_PROFILING);
 }
 
+#ifdef CONFIG_NO_HZ_EXTENDED
+static cpumask_var_t nohz_extended_mask;
+bool have_nohz_extended_mask;
+
+int tick_nohz_extended_cpu(int cpu)
+{
+	if (!have_nohz_extended_mask)
+		return 0;
+
+	return cpumask_test_cpu(cpu, nohz_extended_mask);
+}
+
+/* Parse the boot-time nohz CPU list from the kernel parameters. */
+static int __init tick_nohz_extended_setup(char *str)
+{
+	alloc_bootmem_cpumask_var(&nohz_extended_mask);
+	if (cpulist_parse(str, nohz_extended_mask) < 0)
+		pr_warning("NOHZ: Incorrect nohz_extended cpumask\n");
+	else
+		have_nohz_extended_mask = true;
+	return 1;
+}
+__setup("nohz_extended=", tick_nohz_extended_setup);
+
+static int __init init_tick_nohz_extended(void)
+{
+	cpumask_var_t online_nohz;
+	int cpu;
+
+	if (!have_nohz_extended_mask)
+		return 0;
+
+	if (!zalloc_cpumask_var(&online_nohz, GFP_KERNEL)) {
+		pr_warning("NO_HZ: Not enough memory to check extended nohz mask\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * CPUs can probably not be concurrently offlined on initcall time.
+	 * But we are paranoid, aren't we?
+	 */
+	get_online_cpus();
+
+	/* Ensure we keep a CPU outside the dynticks range for timekeeping */
+	cpumask_and(online_nohz, cpu_online_mask, nohz_extended_mask);
+	if (cpumask_equal(online_nohz, cpu_online_mask)) {
+		cpu = cpumask_any(cpu_online_mask);
+		pr_warning("NO_HZ: Must keep at least one online CPU "
+			   "out of nohz_extended range\n");
+		pr_warning("NO_HZ: Clearing %d from nohz_extended range\n", cpu);
+		cpumask_clear_cpu(cpu, nohz_extended_mask);
+	}
+	put_online_cpus();
+	free_cpumask_var(online_nohz);
+
+	return 0;
+}
+core_initcall(init_tick_nohz_extended);
+#else
+#define have_nohz_extended_mask (0)
+#endif
+
 /*
  * NOHZ - aka dynamic tick functionality
  */
-- 
1.7.5.4

