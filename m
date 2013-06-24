Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3FXTcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:32:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:47518 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3FXTcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:32:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 07/32] arm: delete __cpuinit/__CPUINIT usage from all ARM users
Date: Mon, 24 Jun 2013 15:30:12 -0400
Message-ID: <1372102237-8757-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
and are flagged as __cpuinit  -- so if we remove the __cpuinit from
the arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
related content into no-ops as early as possible, since that will get
rid of these warnings.  In any case, they are temporary and harmless.

This removes all the ARM uses of the __cpuinit macros from C code,
and all __CPUINIT from assembly code.  It also had two ".previous"
section statements that were paired off against __CPUINIT
(aka .section ".cpuinit.text") that also get removed here.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/arm/common/mcpm_platsmp.c            |  4 ++--
 arch/arm/include/asm/arch_timer.h         |  2 +-
 arch/arm/kernel/head-common.S             |  1 -
 arch/arm/kernel/head.S                    |  1 -
 arch/arm/kernel/hw_breakpoint.c           |  4 ++--
 arch/arm/kernel/perf_event_cpu.c          |  6 +++---
 arch/arm/kernel/psci_smp.c                |  3 +--
 arch/arm/kernel/smp.c                     | 18 +++++++++---------
 arch/arm/kernel/smp_twd.c                 |  6 +++---
 arch/arm/lib/delay.c                      |  2 +-
 arch/arm/mach-exynos/headsmp.S            |  2 --
 arch/arm/mach-exynos/platsmp.c            |  4 ++--
 arch/arm/mach-highbank/platsmp.c          |  2 +-
 arch/arm/mach-imx/platsmp.c               |  2 +-
 arch/arm/mach-msm/headsmp.S               |  2 --
 arch/arm/mach-msm/platsmp.c               |  6 +++---
 arch/arm/mach-msm/timer.c                 |  4 ++--
 arch/arm/mach-mvebu/coherency.c           |  2 +-
 arch/arm/mach-mvebu/headsmp.S             |  2 --
 arch/arm/mach-mvebu/platsmp.c             |  5 ++---
 arch/arm/mach-omap2/omap-headsmp.S        |  2 --
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |  2 +-
 arch/arm/mach-omap2/omap-smp.c            |  4 ++--
 arch/arm/mach-omap2/omap-wakeupgen.c      |  4 ++--
 arch/arm/mach-prima2/headsmp.S            |  2 --
 arch/arm/mach-prima2/platsmp.c            |  4 ++--
 arch/arm/mach-shmobile/headsmp-scu.S      |  1 -
 arch/arm/mach-shmobile/headsmp.S          |  2 --
 arch/arm/mach-shmobile/smp-emev2.c        |  2 +-
 arch/arm/mach-shmobile/smp-r8a7779.c      |  2 +-
 arch/arm/mach-shmobile/smp-sh73a0.c       |  2 +-
 arch/arm/mach-socfpga/headsmp.S           |  1 -
 arch/arm/mach-socfpga/platsmp.c           |  2 +-
 arch/arm/mach-spear/generic.h             |  2 +-
 arch/arm/mach-spear/platsmp.c             |  4 ++--
 arch/arm/mach-tegra/platsmp.c             |  4 ++--
 arch/arm/mach-tegra/pm.c                  |  2 +-
 arch/arm/mach-ux500/platsmp.c             |  4 ++--
 arch/arm/mach-zynq/common.h               |  2 +-
 arch/arm/mach-zynq/headsmp.S              |  2 --
 arch/arm/mach-zynq/platsmp.c              |  6 +++---
 arch/arm/mm/proc-arm1020.S                |  2 --
 arch/arm/mm/proc-arm1020e.S               |  2 --
 arch/arm/mm/proc-arm1022.S                |  2 --
 arch/arm/mm/proc-arm1026.S                |  3 ---
 arch/arm/mm/proc-arm720.S                 |  2 --
 arch/arm/mm/proc-arm740.S                 |  2 --
 arch/arm/mm/proc-arm7tdmi.S               |  2 --
 arch/arm/mm/proc-arm920.S                 |  2 --
 arch/arm/mm/proc-arm922.S                 |  2 --
 arch/arm/mm/proc-arm925.S                 |  2 --
 arch/arm/mm/proc-arm926.S                 |  2 --
 arch/arm/mm/proc-arm940.S                 |  2 --
 arch/arm/mm/proc-arm946.S                 |  2 --
 arch/arm/mm/proc-arm9tdmi.S               |  2 --
 arch/arm/mm/proc-fa526.S                  |  2 --
 arch/arm/mm/proc-feroceon.S               |  2 --
 arch/arm/mm/proc-mohawk.S                 |  2 --
 arch/arm/mm/proc-sa110.S                  |  2 --
 arch/arm/mm/proc-sa1100.S                 |  2 --
 arch/arm/mm/proc-v6.S                     |  2 --
 arch/arm/mm/proc-v7-2level.S              |  4 ----
 arch/arm/mm/proc-v7-3level.S              |  4 ----
 arch/arm/mm/proc-v7.S                     |  2 --
 arch/arm/mm/proc-xsc3.S                   |  2 --
 arch/arm/mm/proc-xscale.S                 |  2 --
 arch/arm/plat-versatile/platsmp.c         |  6 +++---
 67 files changed, 60 insertions(+), 135 deletions(-)

diff --git a/arch/arm/common/mcpm_platsmp.c b/arch/arm/common/mcpm_platsmp.c
index 510e5b1..1bc34c7 100644
--- a/arch/arm/common/mcpm_platsmp.c
+++ b/arch/arm/common/mcpm_platsmp.c
@@ -19,7 +19,7 @@
 #include <asm/smp.h>
 #include <asm/smp_plat.h>
 
-static int __cpuinit mcpm_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int mcpm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned int mpidr, pcpu, pcluster, ret;
 	extern void secondary_startup(void);
@@ -40,7 +40,7 @@ static int __cpuinit mcpm_boot_secondary(unsigned int cpu, struct task_struct *i
 	return 0;
 }
 
-static void __cpuinit mcpm_secondary_init(unsigned int cpu)
+static void mcpm_secondary_init(unsigned int cpu)
 {
 	mcpm_cpu_powered_up();
 }
diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index accefe0..e406d57 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -89,7 +89,7 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
 }
 
-static inline void __cpuinit arch_counter_set_user_access(void)
+static inline void arch_counter_set_user_access(void)
 {
 	u32 cntkctl;
 
diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 5b391a6..529ce99 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -146,7 +146,6 @@ ENDPROC(lookup_processor_type)
  *	r5 = proc_info pointer in physical address space
  *	r9 = cpuid (preserved)
  */
-	__CPUINIT
 __lookup_processor_type:
 	adr	r3, __lookup_processor_type_data
 	ldmia	r3, {r4 - r6}
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 45e8935..9cf6063 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -343,7 +343,6 @@ __turn_mmu_on_loc:
 	.long	__turn_mmu_on_end
 
 #if defined(CONFIG_SMP)
-	__CPUINIT
 ENTRY(secondary_startup)
 	/*
 	 * Common entry point for secondary CPUs.
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 1fd749e..7b95de6 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -1020,7 +1020,7 @@ out_mdbgen:
 		cpumask_or(&debug_err_mask, &debug_err_mask, cpumask_of(cpu));
 }
 
-static int __cpuinit dbg_reset_notify(struct notifier_block *self,
+static int dbg_reset_notify(struct notifier_block *self,
 				      unsigned long action, void *cpu)
 {
 	if ((action & ~CPU_TASKS_FROZEN) == CPU_ONLINE)
@@ -1029,7 +1029,7 @@ static int __cpuinit dbg_reset_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata dbg_reset_nb = {
+static struct notifier_block dbg_reset_nb = {
 	.notifier_call = dbg_reset_notify,
 };
 
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 1f2740e..aebe0e9 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -157,8 +157,8 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
  * UNKNOWN at reset, the PMU must be explicitly reset to avoid reading
  * junk values out of them.
  */
-static int __cpuinit cpu_pmu_notify(struct notifier_block *b,
-				    unsigned long action, void *hcpu)
+static int cpu_pmu_notify(struct notifier_block *b, unsigned long action,
+			  void *hcpu)
 {
 	if ((action & ~CPU_TASKS_FROZEN) != CPU_STARTING)
 		return NOTIFY_DONE;
@@ -171,7 +171,7 @@ static int __cpuinit cpu_pmu_notify(struct notifier_block *b,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpu_pmu_hotplug_notifier = {
+static struct notifier_block cpu_pmu_hotplug_notifier = {
 	.notifier_call = cpu_pmu_notify,
 };
 
diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
index 219f1d7..70ded3f 100644
--- a/arch/arm/kernel/psci_smp.c
+++ b/arch/arm/kernel/psci_smp.c
@@ -46,8 +46,7 @@
 
 extern void secondary_startup(void);
 
-static int __cpuinit psci_boot_secondary(unsigned int cpu,
-					 struct task_struct *idle)
+static int psci_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	if (psci_ops.cpu_on)
 		return psci_ops.cpu_on(cpu_logical_map(cpu),
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index c5fb546..c2b4f8f 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -58,7 +58,7 @@ struct secondary_data secondary_data;
  * control for which core is the next to come out of the secondary
  * boot "holding pen"
  */
-volatile int __cpuinitdata pen_release = -1;
+volatile int pen_release = -1;
 
 enum ipi_msg_type {
 	IPI_WAKEUP,
@@ -86,7 +86,7 @@ static unsigned long get_arch_pgd(pgd_t *pgd)
 	return pgdir >> ARCH_PGD_SHIFT;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
 
@@ -138,7 +138,7 @@ void __init smp_init_cpus(void)
 		smp_ops.smp_init_cpus();
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+int boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	if (smp_ops.smp_boot_secondary)
 		return smp_ops.smp_boot_secondary(cpu, idle);
@@ -170,7 +170,7 @@ static int platform_cpu_disable(unsigned int cpu)
 /*
  * __cpu_disable runs on the processor to be shutdown.
  */
-int __cpuinit __cpu_disable(void)
+int __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
 	int ret;
@@ -216,7 +216,7 @@ static DECLARE_COMPLETION(cpu_died);
  * called on the thread which is asking for a CPU to be shutdown -
  * waits until shutdown has completed, or it is timed out.
  */
-void __cpuinit __cpu_die(unsigned int cpu)
+void __cpu_die(unsigned int cpu)
 {
 	if (!wait_for_completion_timeout(&cpu_died, msecs_to_jiffies(5000))) {
 		pr_err("CPU%u: cpu didn't die\n", cpu);
@@ -306,7 +306,7 @@ void __ref cpu_die(void)
  * Called by both boot and secondaries to move global data into
  * per-processor storage.
  */
-static void __cpuinit smp_store_cpu_info(unsigned int cpuid)
+static void smp_store_cpu_info(unsigned int cpuid)
 {
 	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpuid);
 
@@ -322,7 +322,7 @@ static void percpu_timer_setup(void);
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
  */
-asmlinkage void __cpuinit secondary_start_kernel(void)
+asmlinkage void secondary_start_kernel(void)
 {
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu;
@@ -521,7 +521,7 @@ static void broadcast_timer_set_mode(enum clock_event_mode mode,
 {
 }
 
-static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
+static void broadcast_timer_setup(struct clock_event_device *evt)
 {
 	evt->name	= "dummy_timer";
 	evt->features	= CLOCK_EVT_FEAT_ONESHOT |
@@ -550,7 +550,7 @@ int local_timer_register(struct local_timer_ops *ops)
 }
 #endif
 
-static void __cpuinit percpu_timer_setup(void)
+static void percpu_timer_setup(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 90525d9..ed5cb75 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -187,7 +187,7 @@ core_initcall(twd_cpufreq_init);
 
 #endif
 
-static void __cpuinit twd_calibrate_rate(void)
+static void twd_calibrate_rate(void)
 {
 	unsigned long count;
 	u64 waitjiffies;
@@ -265,7 +265,7 @@ static void twd_get_clock(struct device_node *np)
 /*
  * Setup the local clock events for a CPU.
  */
-static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
+static int twd_timer_setup(struct clock_event_device *clk)
 {
 	struct clock_event_device **this_cpu_clk;
 	int cpu = smp_processor_id();
@@ -308,7 +308,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	return 0;
 }
 
-static struct local_timer_ops twd_lt_ops __cpuinitdata = {
+static struct local_timer_ops twd_lt_ops = {
 	.setup	= twd_timer_setup,
 	.stop	= twd_timer_stop,
 };
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 64dbfa5..5306de3 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -86,7 +86,7 @@ void __init register_current_timer_delay(const struct delay_timer *timer)
 	}
 }
 
-unsigned long __cpuinit calibrate_delay_is_known(void)
+unsigned long calibrate_delay_is_known(void)
 {
 	delay_calibrated = true;
 	return lpj_fine;
diff --git a/arch/arm/mach-exynos/headsmp.S b/arch/arm/mach-exynos/headsmp.S
index 5364d4b..cdd9d91 100644
--- a/arch/arm/mach-exynos/headsmp.S
+++ b/arch/arm/mach-exynos/headsmp.S
@@ -13,8 +13,6 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__CPUINIT
-
 /*
  * exynos4 specific entry point for secondary CPUs.  This provides
  * a "holding pen" into which all secondary cores are held until we're
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index deba130..58b43e6 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -75,7 +75,7 @@ static void __iomem *scu_base_addr(void)
 
 static DEFINE_SPINLOCK(boot_lock);
 
-static void __cpuinit exynos_secondary_init(unsigned int cpu)
+static void exynos_secondary_init(unsigned int cpu)
 {
 	/*
 	 * let the primary processor know we're out of the
@@ -90,7 +90,7 @@ static void __cpuinit exynos_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static int __cpuinit exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 	unsigned long phys_cpu = cpu_logical_map(cpu);
diff --git a/arch/arm/mach-highbank/platsmp.c b/arch/arm/mach-highbank/platsmp.c
index a984573..32d75cf5 100644
--- a/arch/arm/mach-highbank/platsmp.c
+++ b/arch/arm/mach-highbank/platsmp.c
@@ -24,7 +24,7 @@
 
 extern void secondary_startup(void);
 
-static int __cpuinit highbank_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int highbank_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	highbank_set_cpu_jump(cpu, secondary_startup);
 	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
diff --git a/arch/arm/mach-imx/platsmp.c b/arch/arm/mach-imx/platsmp.c
index c6e1ab5..1f24c1f 100644
--- a/arch/arm/mach-imx/platsmp.c
+++ b/arch/arm/mach-imx/platsmp.c
@@ -53,7 +53,7 @@ void imx_scu_standby_enable(void)
 	writel_relaxed(val, scu_base);
 }
 
-static int __cpuinit imx_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int imx_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	imx_set_cpu_jump(cpu, v7_secondary_startup);
 	imx_enable_cpu(cpu, true);
diff --git a/arch/arm/mach-msm/headsmp.S b/arch/arm/mach-msm/headsmp.S
index bcd5af2..6c62c3f 100644
--- a/arch/arm/mach-msm/headsmp.S
+++ b/arch/arm/mach-msm/headsmp.S
@@ -11,8 +11,6 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__CPUINIT
-
 /*
  * MSM specific entry point for secondary CPUs.  This provides
  * a "holding pen" into which all secondary cores are held until we're
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 00cdb0a..3f06edc 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -38,7 +38,7 @@ static inline int get_core_count(void)
 	return ((read_cpuid_id() >> 4) & 3) + 1;
 }
 
-static void __cpuinit msm_secondary_init(unsigned int cpu)
+static void msm_secondary_init(unsigned int cpu)
 {
 	/*
 	 * let the primary processor know we're out of the
@@ -54,7 +54,7 @@ static void __cpuinit msm_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static __cpuinit void prepare_cold_cpu(unsigned int cpu)
+static void prepare_cold_cpu(unsigned int cpu)
 {
 	int ret;
 	ret = scm_set_boot_addr(virt_to_phys(msm_secondary_startup),
@@ -73,7 +73,7 @@ static __cpuinit void prepare_cold_cpu(unsigned int cpu)
 				  "address\n");
 }
 
-static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 	static int cold_boot_done;
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index b6418fd..8697cfc 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -139,7 +139,7 @@ static struct clocksource msm_clocksource = {
 };
 
 #ifdef CONFIG_LOCAL_TIMERS
-static int __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
+static int msm_local_timer_setup(struct clock_event_device *evt)
 {
 	/* Use existing clock_event for cpu 0 */
 	if (!smp_processor_id())
@@ -164,7 +164,7 @@ static void msm_local_timer_stop(struct clock_event_device *evt)
 	disable_percpu_irq(evt->irq);
 }
 
-static struct local_timer_ops msm_local_timer_ops __cpuinitdata = {
+static struct local_timer_ops msm_local_timer_ops = {
 	.setup	= msm_local_timer_setup,
 	.stop	= msm_local_timer_stop,
 };
diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index be11759..4c24303 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -28,7 +28,7 @@
 #include <asm/cacheflush.h>
 #include "armada-370-xp.h"
 
-unsigned long __cpuinitdata coherency_phys_base;
+unsigned long coherency_phys_base;
 static void __iomem *coherency_base;
 static void __iomem *coherency_cpu_base;
 
diff --git a/arch/arm/mach-mvebu/headsmp.S b/arch/arm/mach-mvebu/headsmp.S
index 7147300..8a1b0c9 100644
--- a/arch/arm/mach-mvebu/headsmp.S
+++ b/arch/arm/mach-mvebu/headsmp.S
@@ -21,8 +21,6 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__CPUINIT
-
 /*
  * Armada XP specific entry point for secondary CPUs.
  * We add the CPU to the coherency fabric and then jump to secondary
diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index 93f2f3a..ce81d30 100644
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@ -71,13 +71,12 @@ void __init set_secondary_cpus_clock(void)
 	}
 }
 
-static void __cpuinit armada_xp_secondary_init(unsigned int cpu)
+static void armada_xp_secondary_init(unsigned int cpu)
 {
 	armada_xp_mpic_smp_cpu_init();
 }
 
-static int __cpuinit armada_xp_boot_secondary(unsigned int cpu,
-					      struct task_struct *idle)
+static int armada_xp_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	pr_info("Booting CPU %d\n", cpu);
 
diff --git a/arch/arm/mach-omap2/omap-headsmp.S b/arch/arm/mach-omap2/omap-headsmp.S
index 4ea3081..75e9295 100644
--- a/arch/arm/mach-omap2/omap-headsmp.S
+++ b/arch/arm/mach-omap2/omap-headsmp.S
@@ -20,8 +20,6 @@
 
 #include "omap44xx.h"
 
-	__CPUINIT
-
 /* Physical address needed since MMU not enabled yet on secondary core */
 #define AUX_CORE_BOOT0_PA			0x48281800
 
diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index f993a41..f991016 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -291,7 +291,7 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
  * @cpu : CPU ID
  * @power_state: CPU low power state.
  */
-int __cpuinit omap4_hotplug_cpu(unsigned int cpu, unsigned int power_state)
+int omap4_hotplug_cpu(unsigned int cpu, unsigned int power_state)
 {
 	struct omap4_cpu_pm_info *pm_info = &per_cpu(omap4_pm_info, cpu);
 	unsigned int cpu_state = 0;
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 98a1146..8708b2a 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -51,7 +51,7 @@ void __iomem *omap4_get_scu_base(void)
 	return scu_base;
 }
 
-static void __cpuinit omap4_secondary_init(unsigned int cpu)
+static void omap4_secondary_init(unsigned int cpu)
 {
 	/*
 	 * Configure ACTRL and enable NS SMP bit access on CPU1 on HS device.
@@ -72,7 +72,7 @@ static void __cpuinit omap4_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static int __cpuinit omap4_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int omap4_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	static struct clockdomain *cpu1_clkdm;
 	static bool booted;
diff --git a/arch/arm/mach-omap2/omap-wakeupgen.c b/arch/arm/mach-omap2/omap-wakeupgen.c
index f8bb3b9..813c615 100644
--- a/arch/arm/mach-omap2/omap-wakeupgen.c
+++ b/arch/arm/mach-omap2/omap-wakeupgen.c
@@ -323,8 +323,8 @@ static void irq_save_secure_context(void)
 #endif
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int __cpuinit irq_cpu_hotplug_notify(struct notifier_block *self,
-					 unsigned long action, void *hcpu)
+static int irq_cpu_hotplug_notify(struct notifier_block *self,
+				  unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned int)hcpu;
 
diff --git a/arch/arm/mach-prima2/headsmp.S b/arch/arm/mach-prima2/headsmp.S
index 5b8a408d..d86fe33 100644
--- a/arch/arm/mach-prima2/headsmp.S
+++ b/arch/arm/mach-prima2/headsmp.S
@@ -9,8 +9,6 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__CPUINIT
-
 /*
  * SIRFSOC specific entry point for secondary CPUs.  This provides
  * a "holding pen" into which all secondary cores are held until we're
diff --git a/arch/arm/mach-prima2/platsmp.c b/arch/arm/mach-prima2/platsmp.c
index 1c3de7b..3dbcb1a 100644
--- a/arch/arm/mach-prima2/platsmp.c
+++ b/arch/arm/mach-prima2/platsmp.c
@@ -44,7 +44,7 @@ void __init sirfsoc_map_scu(void)
 	scu_base = (void __iomem *)SIRFSOC_VA(base);
 }
 
-static void __cpuinit sirfsoc_secondary_init(unsigned int cpu)
+static void sirfsoc_secondary_init(unsigned int cpu)
 {
 	/*
 	 * let the primary processor know we're out of the
@@ -65,7 +65,7 @@ static struct of_device_id rsc_ids[]  = {
 	{},
 };
 
-static int __cpuinit sirfsoc_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int sirfsoc_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 	struct device_node *np;
diff --git a/arch/arm/mach-shmobile/headsmp-scu.S b/arch/arm/mach-shmobile/headsmp-scu.S
index 6f98654..bfd9200 100644
--- a/arch/arm/mach-shmobile/headsmp-scu.S
+++ b/arch/arm/mach-shmobile/headsmp-scu.S
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 #include <asm/memory.h>
 
-	__CPUINIT
 /*
  * Boot code for secondary CPUs.
  *
diff --git a/arch/arm/mach-shmobile/headsmp.S b/arch/arm/mach-shmobile/headsmp.S
index 559d1ce..a9d2124 100644
--- a/arch/arm/mach-shmobile/headsmp.S
+++ b/arch/arm/mach-shmobile/headsmp.S
@@ -14,8 +14,6 @@
 #include <linux/init.h>
 #include <asm/memory.h>
 
-	__CPUINIT
-
 ENTRY(shmobile_invalidate_start)
 	bl	v7_invalidate_l1
 	b	secondary_startup
diff --git a/arch/arm/mach-shmobile/smp-emev2.c b/arch/arm/mach-shmobile/smp-emev2.c
index 80991b3..22a05a8 100644
--- a/arch/arm/mach-shmobile/smp-emev2.c
+++ b/arch/arm/mach-shmobile/smp-emev2.c
@@ -30,7 +30,7 @@
 
 #define EMEV2_SCU_BASE 0x1e000000
 
-static int __cpuinit emev2_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int emev2_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	arch_send_wakeup_ipi_mask(cpumask_of(cpu_logical_map(cpu)));
 	return 0;
diff --git a/arch/arm/mach-shmobile/smp-r8a7779.c b/arch/arm/mach-shmobile/smp-r8a7779.c
index 526cfaa..9bdf810 100644
--- a/arch/arm/mach-shmobile/smp-r8a7779.c
+++ b/arch/arm/mach-shmobile/smp-r8a7779.c
@@ -81,7 +81,7 @@ static int r8a7779_platform_cpu_kill(unsigned int cpu)
 	return ret ? ret : 1;
 }
 
-static int __cpuinit r8a7779_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int r8a7779_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	struct r8a7779_pm_ch *ch = NULL;
 	int ret = -EIO;
diff --git a/arch/arm/mach-shmobile/smp-sh73a0.c b/arch/arm/mach-shmobile/smp-sh73a0.c
index d613113..d5fc3ed 100644
--- a/arch/arm/mach-shmobile/smp-sh73a0.c
+++ b/arch/arm/mach-shmobile/smp-sh73a0.c
@@ -48,7 +48,7 @@ void __init sh73a0_register_twd(void)
 }
 #endif
 
-static int __cpuinit sh73a0_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int sh73a0_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	cpu = cpu_logical_map(cpu);
 
diff --git a/arch/arm/mach-socfpga/headsmp.S b/arch/arm/mach-socfpga/headsmp.S
index 9004bfb..95c115d 100644
--- a/arch/arm/mach-socfpga/headsmp.S
+++ b/arch/arm/mach-socfpga/headsmp.S
@@ -10,7 +10,6 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__CPUINIT
 	.arch	armv7-a
 
 ENTRY(secondary_trampoline)
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index b51ce8c..5356a72 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -29,7 +29,7 @@
 
 #include "core.h"
 
-static int __cpuinit socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
 
diff --git a/arch/arm/mach-spear/generic.h b/arch/arm/mach-spear/generic.h
index 904f2c9..a99d90a 100644
--- a/arch/arm/mach-spear/generic.h
+++ b/arch/arm/mach-spear/generic.h
@@ -37,7 +37,7 @@ void __init spear13xx_l2x0_init(void);
 void spear_restart(enum reboot_mode, const char *);
 
 void spear13xx_secondary_startup(void);
-void __cpuinit spear13xx_cpu_die(unsigned int cpu);
+void spear13xx_cpu_die(unsigned int cpu);
 
 extern struct smp_operations spear13xx_smp_ops;
 
diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index 9c4c722..5c4a198 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -24,7 +24,7 @@ static DEFINE_SPINLOCK(boot_lock);
 
 static void __iomem *scu_base = IOMEM(VA_SCU_BASE);
 
-static void __cpuinit spear13xx_secondary_init(unsigned int cpu)
+static void spear13xx_secondary_init(unsigned int cpu)
 {
 	/*
 	 * let the primary processor know we're out of the
@@ -40,7 +40,7 @@ static void __cpuinit spear13xx_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static int __cpuinit spear13xx_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int spear13xx_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 24db4ac..97b33a2 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -35,7 +35,7 @@
 
 static cpumask_t tegra_cpu_init_mask;
 
-static void __cpuinit tegra_secondary_init(unsigned int cpu)
+static void tegra_secondary_init(unsigned int cpu)
 {
 	cpumask_set_cpu(cpu, &tegra_cpu_init_mask);
 }
@@ -167,7 +167,7 @@ static int tegra114_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	return ret;
 }
 
-static int __cpuinit tegra_boot_secondary(unsigned int cpu,
+static int tegra_boot_secondary(unsigned int cpu,
 					  struct task_struct *idle)
 {
 	if (IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC) && tegra_chip_id == TEGRA20)
diff --git a/arch/arm/mach-tegra/pm.c b/arch/arm/mach-tegra/pm.c
index 94e69be..261fec1 100644
--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -191,7 +191,7 @@ static const char *lp_state[TEGRA_MAX_SUSPEND_MODE] = {
 	[TEGRA_SUSPEND_LP0] = "LP0",
 };
 
-static int __cpuinit tegra_suspend_enter(suspend_state_t state)
+static int tegra_suspend_enter(suspend_state_t state)
 {
 	enum tegra_suspend_mode mode = tegra_pmc_get_suspend_mode();
 
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index 14d9046..1f296e7 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -54,7 +54,7 @@ static void __iomem *scu_base_addr(void)
 
 static DEFINE_SPINLOCK(boot_lock);
 
-static void __cpuinit ux500_secondary_init(unsigned int cpu)
+static void ux500_secondary_init(unsigned int cpu)
 {
 	/*
 	 * let the primary processor know we're out of the
@@ -69,7 +69,7 @@ static void __cpuinit ux500_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static int __cpuinit ux500_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int ux500_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index fbbd0e2..3040d21 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -27,7 +27,7 @@ extern void secondary_startup(void);
 extern char zynq_secondary_trampoline;
 extern char zynq_secondary_trampoline_jump;
 extern char zynq_secondary_trampoline_end;
-extern int __cpuinit zynq_cpun_start(u32 address, int cpu);
+extern int zynq_cpun_start(u32 address, int cpu);
 extern struct smp_operations zynq_smp_ops __initdata;
 #endif
 
diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.S
index d183cd2..d4cd5f3 100644
--- a/arch/arm/mach-zynq/headsmp.S
+++ b/arch/arm/mach-zynq/headsmp.S
@@ -9,8 +9,6 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__CPUINIT
-
 ENTRY(zynq_secondary_trampoline)
 	ldr	r0, [pc]
 	bx	r0
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 023f225..689fbbc 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -30,11 +30,11 @@
 /*
  * Store number of cores in the system
  * Because of scu_get_core_count() must be in __init section and can't
- * be called from zynq_cpun_start() because it is in __cpuinit section.
+ * be called from zynq_cpun_start() because it is not in __init section.
  */
 static int ncores;
 
-int __cpuinit zynq_cpun_start(u32 address, int cpu)
+int zynq_cpun_start(u32 address, int cpu)
 {
 	u32 trampoline_code_size = &zynq_secondary_trampoline_end -
 						&zynq_secondary_trampoline;
@@ -92,7 +92,7 @@ int __cpuinit zynq_cpun_start(u32 address, int cpu)
 }
 EXPORT_SYMBOL(zynq_cpun_start);
 
-static int __cpuinit zynq_boot_secondary(unsigned int cpu,
+static int zynq_boot_secondary(unsigned int cpu,
 						struct task_struct *idle)
 {
 	return zynq_cpun_start(virt_to_phys(secondary_startup), cpu);
diff --git a/arch/arm/mm/proc-arm1020.S b/arch/arm/mm/proc-arm1020.S
index 2bb61e7..d1a2d05 100644
--- a/arch/arm/mm/proc-arm1020.S
+++ b/arch/arm/mm/proc-arm1020.S
@@ -443,8 +443,6 @@ ENTRY(cpu_arm1020_set_pte_ext)
 #endif /* CONFIG_MMU */
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__arm1020_setup, #function
 __arm1020_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm1020e.S b/arch/arm/mm/proc-arm1020e.S
index 8f96aa4..9d89405 100644
--- a/arch/arm/mm/proc-arm1020e.S
+++ b/arch/arm/mm/proc-arm1020e.S
@@ -425,8 +425,6 @@ ENTRY(cpu_arm1020e_set_pte_ext)
 #endif /* CONFIG_MMU */
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__arm1020e_setup, #function
 __arm1020e_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm1022.S b/arch/arm/mm/proc-arm1022.S
index 8ebe4a4..6f01a0a 100644
--- a/arch/arm/mm/proc-arm1022.S
+++ b/arch/arm/mm/proc-arm1022.S
@@ -407,8 +407,6 @@ ENTRY(cpu_arm1022_set_pte_ext)
 #endif /* CONFIG_MMU */
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__arm1022_setup, #function
 __arm1022_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm1026.S b/arch/arm/mm/proc-arm1026.S
index 093fc7e..4799a24 100644
--- a/arch/arm/mm/proc-arm1026.S
+++ b/arch/arm/mm/proc-arm1026.S
@@ -396,9 +396,6 @@ ENTRY(cpu_arm1026_set_pte_ext)
 #endif /* CONFIG_MMU */
 	mov	pc, lr
 
-
-	__CPUINIT
-
 	.type	__arm1026_setup, #function
 __arm1026_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm720.S b/arch/arm/mm/proc-arm720.S
index 0ac908c..d42c37f 100644
--- a/arch/arm/mm/proc-arm720.S
+++ b/arch/arm/mm/proc-arm720.S
@@ -116,8 +116,6 @@ ENTRY(cpu_arm720_reset)
 ENDPROC(cpu_arm720_reset)
 		.popsection
 
-	__CPUINIT
-
 	.type	__arm710_setup, #function
 __arm710_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm740.S b/arch/arm/mm/proc-arm740.S
index fde2d2a..9b0ae90 100644
--- a/arch/arm/mm/proc-arm740.S
+++ b/arch/arm/mm/proc-arm740.S
@@ -60,8 +60,6 @@ ENTRY(cpu_arm740_reset)
 ENDPROC(cpu_arm740_reset)
 	.popsection
 
-	__CPUINIT
-
 	.type	__arm740_setup, #function
 __arm740_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm7tdmi.S b/arch/arm/mm/proc-arm7tdmi.S
index 6ddea3e..f6cc3f6 100644
--- a/arch/arm/mm/proc-arm7tdmi.S
+++ b/arch/arm/mm/proc-arm7tdmi.S
@@ -51,8 +51,6 @@ ENTRY(cpu_arm7tdmi_reset)
 ENDPROC(cpu_arm7tdmi_reset)
 		.popsection
 
-		__CPUINIT
-
 		.type	__arm7tdmi_setup, #function
 __arm7tdmi_setup:
 		mov	pc, lr
diff --git a/arch/arm/mm/proc-arm920.S b/arch/arm/mm/proc-arm920.S
index 2556cf1..549557d 100644
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -410,8 +410,6 @@ ENTRY(cpu_arm920_do_resume)
 ENDPROC(cpu_arm920_do_resume)
 #endif
 
-	__CPUINIT
-
 	.type	__arm920_setup, #function
 __arm920_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm922.S b/arch/arm/mm/proc-arm922.S
index 4464c49..2a758b0 100644
--- a/arch/arm/mm/proc-arm922.S
+++ b/arch/arm/mm/proc-arm922.S
@@ -388,8 +388,6 @@ ENTRY(cpu_arm922_set_pte_ext)
 #endif /* CONFIG_MMU */
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__arm922_setup, #function
 __arm922_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm925.S b/arch/arm/mm/proc-arm925.S
index 281eb9b..97448c3 100644
--- a/arch/arm/mm/proc-arm925.S
+++ b/arch/arm/mm/proc-arm925.S
@@ -438,8 +438,6 @@ ENTRY(cpu_arm925_set_pte_ext)
 #endif /* CONFIG_MMU */
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__arm925_setup, #function
 __arm925_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm926.S b/arch/arm/mm/proc-arm926.S
index 344c8a5..0f098f4 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -425,8 +425,6 @@ ENTRY(cpu_arm926_do_resume)
 ENDPROC(cpu_arm926_do_resume)
 #endif
 
-	__CPUINIT
-
 	.type	__arm926_setup, #function
 __arm926_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm940.S b/arch/arm/mm/proc-arm940.S
index 8da189d..1c39a70 100644
--- a/arch/arm/mm/proc-arm940.S
+++ b/arch/arm/mm/proc-arm940.S
@@ -273,8 +273,6 @@ ENDPROC(arm940_dma_unmap_area)
 	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
 	define_cache_functions arm940
 
-	__CPUINIT
-
 	.type	__arm940_setup, #function
 __arm940_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm946.S b/arch/arm/mm/proc-arm946.S
index f666cf3..0289cd9 100644
--- a/arch/arm/mm/proc-arm946.S
+++ b/arch/arm/mm/proc-arm946.S
@@ -326,8 +326,6 @@ ENTRY(cpu_arm946_dcache_clean_area)
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__arm946_setup, #function
 __arm946_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-arm9tdmi.S b/arch/arm/mm/proc-arm9tdmi.S
index 8881391..f51197b 100644
--- a/arch/arm/mm/proc-arm9tdmi.S
+++ b/arch/arm/mm/proc-arm9tdmi.S
@@ -51,8 +51,6 @@ ENTRY(cpu_arm9tdmi_reset)
 ENDPROC(cpu_arm9tdmi_reset)
 		.popsection
 
-		__CPUINIT
-
 		.type	__arm9tdmi_setup, #function
 __arm9tdmi_setup:
 		mov	pc, lr
diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
index d217e97..824f70d 100644
--- a/arch/arm/mm/proc-fa526.S
+++ b/arch/arm/mm/proc-fa526.S
@@ -136,8 +136,6 @@ ENTRY(cpu_fa526_set_pte_ext)
 #endif
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__fa526_setup, #function
 __fa526_setup:
 	/* On return of this routine, r0 must carry correct flags for CFG register */
diff --git a/arch/arm/mm/proc-feroceon.S b/arch/arm/mm/proc-feroceon.S
index 4106b09..d5146b9 100644
--- a/arch/arm/mm/proc-feroceon.S
+++ b/arch/arm/mm/proc-feroceon.S
@@ -514,8 +514,6 @@ ENTRY(cpu_feroceon_set_pte_ext)
 #endif
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__feroceon_setup, #function
 __feroceon_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index 0b60dd3..40acba5 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -383,8 +383,6 @@ ENTRY(cpu_mohawk_do_resume)
 ENDPROC(cpu_mohawk_do_resume)
 #endif
 
-	__CPUINIT
-
 	.type	__mohawk_setup, #function
 __mohawk_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-sa110.S b/arch/arm/mm/proc-sa110.S
index 775d70f..c45319c 100644
--- a/arch/arm/mm/proc-sa110.S
+++ b/arch/arm/mm/proc-sa110.S
@@ -159,8 +159,6 @@ ENTRY(cpu_sa110_set_pte_ext)
 #endif
 	mov	pc, lr
 
-	__CPUINIT
-
 	.type	__sa110_setup, #function
 __sa110_setup:
 	mov	r10, #0
diff --git a/arch/arm/mm/proc-sa1100.S b/arch/arm/mm/proc-sa1100.S
index d92dfd0..09d241a 100644
--- a/arch/arm/mm/proc-sa1100.S
+++ b/arch/arm/mm/proc-sa1100.S
@@ -198,8 +198,6 @@ ENTRY(cpu_sa1100_do_resume)
 ENDPROC(cpu_sa1100_do_resume)
 #endif
 
-	__CPUINIT
-
 	.type	__sa1100_setup, #function
 __sa1100_setup:
 	mov	r0, #0
diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index 2d1ef87..1128064 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -180,8 +180,6 @@ ENDPROC(cpu_v6_do_resume)
 
 	.align
 
-	__CPUINIT
-
 /*
  *	__v6_setup
  *
diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index 9704097..f64afb9 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -160,8 +160,6 @@ ENDPROC(cpu_v7_set_pte_ext)
 	mcr	p15, 0, \ttbr1, c2, c0, 1	@ load TTB1
 	.endm
 
-	__CPUINIT
-
 	/*   AT
 	 *  TFR   EV X F   I D LR    S
 	 * .EEE ..EE PUI. .T.T 4RVI ZWRS BLDP WCAM
@@ -172,5 +170,3 @@ ENDPROC(cpu_v7_set_pte_ext)
 	.type	v7_crval, #object
 v7_crval:
 	crval	clear=0x2120c302, mmuset=0x10c03c7d, ucset=0x00c01c7c
-
-	.previous
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 5ffe195..c36ac69 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -140,8 +140,6 @@ ENDPROC(cpu_v7_set_pte_ext)
 	mcrr	p15, 0, \ttbr0, \zero, c2			@ load TTBR0
 	.endm
 
-	__CPUINIT
-
 	/*
 	 *   AT
 	 *  TFR   EV X F   IHD LR    S
@@ -153,5 +151,3 @@ ENDPROC(cpu_v7_set_pte_ext)
 	.type	v7_crval, #object
 v7_crval:
 	crval	clear=0x0120c302, mmuset=0x30c23c7d, ucset=0x00c01c7c
-
-	.previous
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index aacb8ca..64b3acb 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -144,8 +144,6 @@ ENTRY(cpu_v7_do_resume)
 ENDPROC(cpu_v7_do_resume)
 #endif
 
-	__CPUINIT
-
 /*
  *	__v7_setup
  *
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index e8efd83..dc16458 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -446,8 +446,6 @@ ENTRY(cpu_xsc3_do_resume)
 ENDPROC(cpu_xsc3_do_resume)
 #endif
 
-	__CPUINIT
-
 	.type	__xsc3_setup, #function
 __xsc3_setup:
 	mov	r0, #PSR_F_BIT|PSR_I_BIT|SVC_MODE
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index e766f88..d19b1cf 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -558,8 +558,6 @@ ENTRY(cpu_xscale_do_resume)
 ENDPROC(cpu_xscale_do_resume)
 #endif
 
-	__CPUINIT
-
 	.type	__xscale_setup, #function
 __xscale_setup:
 	mcr	p15, 0, ip, c7, c7, 0		@ invalidate I, D caches & BTB
diff --git a/arch/arm/plat-versatile/platsmp.c b/arch/arm/plat-versatile/platsmp.c
index 1e1b2d7..39895d8 100644
--- a/arch/arm/plat-versatile/platsmp.c
+++ b/arch/arm/plat-versatile/platsmp.c
@@ -23,7 +23,7 @@
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
  */
-static void __cpuinit write_pen_release(int val)
+static void write_pen_release(int val)
 {
 	pen_release = val;
 	smp_wmb();
@@ -33,7 +33,7 @@ static void __cpuinit write_pen_release(int val)
 
 static DEFINE_SPINLOCK(boot_lock);
 
-void __cpuinit versatile_secondary_init(unsigned int cpu)
+void versatile_secondary_init(unsigned int cpu)
 {
 	/*
 	 * let the primary processor know we're out of the
@@ -48,7 +48,7 @@ void __cpuinit versatile_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit versatile_boot_secondary(unsigned int cpu, struct task_struct *idle)
+int versatile_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
-- 
1.8.1.2

