Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3BVH1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:27:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37814 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab3BVH10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:27:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="26425032"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 8/8] ARM: smp: Remove local timer API
Date: Thu, 21 Feb 2013 23:27:19 -0800
Message-Id: <1361518039-16663-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc0.16.g20a599e
In-Reply-To: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more users of this API, remove it.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig                  | 12 +------
 arch/arm/include/asm/localtimer.h | 34 --------------------
 arch/arm/kernel/smp.c             | 67 ++++++---------------------------------
 arch/arm/mach-omap2/Kconfig       |  1 -
 arch/arm/mach-omap2/timer.c       |  7 ----
 5 files changed, 11 insertions(+), 110 deletions(-)
 delete mode 100644 arch/arm/include/asm/localtimer.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dedf02b..7d4338d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1527,6 +1527,7 @@ config SMP
 	depends on HAVE_SMP
 	depends on MMU
 	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
+	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
 	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
@@ -1646,17 +1647,6 @@ config ARM_PSCI
 	  0022A ("Power State Coordination Interface System Software on
 	  ARM processors").
 
-config LOCAL_TIMERS
-	bool "Use local timer interrupts"
-	depends on SMP
-	default y
-	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
-	help
-	  Enable support for local timers on SMP platforms, rather then the
-	  legacy IPI broadcast method.  Local timers allows the system
-	  accounting to be spread across the timer interval, preventing a
-	  "thundering herd" at every timer tick.
-
 config ARCH_NR_GPIO
 	int
 	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
diff --git a/arch/arm/include/asm/localtimer.h b/arch/arm/include/asm/localtimer.h
deleted file mode 100644
index f77ffc1..0000000
--- a/arch/arm/include/asm/localtimer.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- *  arch/arm/include/asm/localtimer.h
- *
- *  Copyright (C) 2004-2005 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_ARM_LOCALTIMER_H
-#define __ASM_ARM_LOCALTIMER_H
-
-#include <linux/errno.h>
-
-struct clock_event_device;
-
-struct local_timer_ops {
-	int  (*setup)(struct clock_event_device *);
-	void (*stop)(struct clock_event_device *);
-};
-
-#ifdef CONFIG_LOCAL_TIMERS
-/*
- * Register a local timer driver
- */
-int local_timer_register(struct local_timer_ops *);
-#else
-static inline int local_timer_register(struct local_timer_ops *ops)
-{
-	return -ENXIO;
-}
-#endif
-
-#endif
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 2d5197d..f628c79 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -41,7 +41,6 @@
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/ptrace.h>
-#include <asm/localtimer.h>
 #include <asm/smp_plat.h>
 #include <asm/virt.h>
 #include <asm/mach/arch.h>
@@ -133,8 +132,6 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void percpu_timer_stop(void);
-
 static int platform_cpu_kill(unsigned int cpu)
 {
 	if (smp_ops.cpu_kill)
@@ -178,11 +175,6 @@ int __cpuinit __cpu_disable(void)
 	migrate_irqs();
 
 	/*
-	 * Stop the local timer for this CPU.
-	 */
-	percpu_timer_stop();
-
-	/*
 	 * Flush user cache and TLB mappings, and then remove this CPU
 	 * from the vm mask set of all processes.
 	 *
@@ -269,7 +261,7 @@ static void __cpuinit smp_store_cpu_info(unsigned int cpuid)
 	store_cpu_topology(cpuid);
 }
 
-static void percpu_timer_setup(void);
+static void broadcast_timer_setup(void);
 
 /*
  * This is the secondary CPU boot entry.  We're using this CPUs
@@ -325,9 +317,9 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	complete(&cpu_running);
 
 	/*
-	 * Setup the percpu timer for this CPU.
+	 * Setup the dummy broadcast timer for this CPU.
 	 */
-	percpu_timer_setup();
+	broadcast_timer_setup();
 
 	local_irq_enable();
 	local_fiq_enable();
@@ -375,10 +367,10 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		max_cpus = ncores;
 	if (ncores > 1 && max_cpus) {
 		/*
-		 * Enable the local timer or broadcast device for the
+		 * Enable the dummy broadcast device for the
 		 * boot CPU, but only if we have more than one CPU.
 		 */
-		percpu_timer_setup();
+		broadcast_timer_setup();
 
 		/*
 		 * Initialise the present map, which describes the set of CPUs
@@ -473,8 +465,12 @@ static void broadcast_timer_set_mode(enum clock_event_mode mode,
 {
 }
 
-static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
+static void __cpuinit broadcast_timer_setup(void)
 {
+	unsigned int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
+
+	evt->cpumask	= cpumask_of(cpu);
 	evt->name	= "dummy_timer";
 	evt->features	= CLOCK_EVT_FEAT_ONESHOT |
 			  CLOCK_EVT_FEAT_PERIODIC |
@@ -486,49 +482,6 @@ static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
 	clockevents_register_device(evt);
 }
 
-static struct local_timer_ops *lt_ops;
-
-#ifdef CONFIG_LOCAL_TIMERS
-int local_timer_register(struct local_timer_ops *ops)
-{
-	if (!is_smp() || !setup_max_cpus)
-		return -ENXIO;
-
-	if (lt_ops)
-		return -EBUSY;
-
-	lt_ops = ops;
-	return 0;
-}
-#endif
-
-static void __cpuinit percpu_timer_setup(void)
-{
-	unsigned int cpu = smp_processor_id();
-	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
-
-	evt->cpumask = cpumask_of(cpu);
-
-	if (!lt_ops || lt_ops->setup(evt))
-		broadcast_timer_setup(evt);
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-/*
- * The generic clock events code purposely does not stop the local timer
- * on CPU_DEAD/CPU_DEAD_FROZEN hotplug events, so we have to do it
- * manually here.
- */
-static void percpu_timer_stop(void)
-{
-	unsigned int cpu = smp_processor_id();
-	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
-
-	if (lt_ops)
-		lt_ops->stop(evt);
-}
-#endif
-
 static DEFINE_RAW_SPINLOCK(stop_lock);
 
 /*
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 49ac3df..6e1f871 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -88,7 +88,6 @@ config ARCH_OMAP4
 	select CACHE_L2X0
 	select CPU_V7
 	select HAVE_SMP
-	select LOCAL_TIMERS if SMP
 	select OMAP_INTERCONNECT
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 2bdd4cf..c00a8f8 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -587,7 +587,6 @@ OMAP_SYS_GP_TIMER_INIT(3_am33xx, 1, OMAP4_MPU_SOURCE, "ti,timer-alwon",
 #ifdef CONFIG_ARCH_OMAP4
 OMAP_SYS_32K_TIMER_INIT(4, 1, OMAP4_32K_SOURCE, "ti,timer-alwon",
 			2, OMAP4_MPU_SOURCE);
-#ifdef CONFIG_LOCAL_TIMERS
 static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, OMAP44XX_LOCAL_TWD_BASE, 29);
 void __init omap4_local_timer_init(void)
 {
@@ -606,12 +605,6 @@ void __init omap4_local_timer_init(void)
 			pr_err("twd_local_timer_register failed %d\n", err);
 	}
 }
-#else /* CONFIG_LOCAL_TIMERS */
-void __init omap4_local_timer_init(void)
-{
-	omap4_sync32k_timer_init();
-}
-#endif /* CONFIG_LOCAL_TIMERS */
 #endif /* CONFIG_ARCH_OMAP4 */
 
 #ifdef CONFIG_SOC_OMAP5
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

