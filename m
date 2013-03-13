Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab3CMSSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:18:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34786 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934043Ab3CMSSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:18:01 -0400
X-IronPort-AV: E=Sophos;i="4.84,838,1355126400"; 
   d="scan'208";a="29403406"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCHv3 10/10] ARM: smp: Remove local timer API
Date: Wed, 13 Mar 2013 11:17:56 -0700
Message-Id: <1363198676-30417-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more users of this API, remove it.

Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig                  | 10 ------
 arch/arm/include/asm/localtimer.h | 34 -------------------
 arch/arm/kernel/smp.c             | 69 ---------------------------------------
 3 files changed, 113 deletions(-)
 delete mode 100644 arch/arm/include/asm/localtimer.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5ad2ccf..f1a4c57 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1647,16 +1647,6 @@ config ARM_PSCI
 	  0022A ("Power State Coordination Interface System Software on
 	  ARM processors").
 
-config LOCAL_TIMERS
-	bool "Use local timer interrupts"
-	depends on SMP
-	default y
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
index 4de4d14..4c49138 100644
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
@@ -269,8 +261,6 @@ static void __cpuinit smp_store_cpu_info(unsigned int cpuid)
 	store_cpu_topology(cpuid);
 }
 
-static void percpu_timer_setup(void);
-
 /*
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
@@ -325,11 +315,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	set_cpu_online(cpu, true);
 	complete(&cpu_running);
 
-	/*
-	 * Setup the percpu timer for this CPU.
-	 */
-	percpu_timer_setup();
-
 	local_irq_enable();
 	local_fiq_enable();
 
@@ -376,12 +361,6 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		max_cpus = ncores;
 	if (ncores > 1 && max_cpus) {
 		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-
-		/*
 		 * Initialise the present map, which describes the set of CPUs
 		 * actually populated at the present time. A platform should
 		 * re-initialize the map in the platforms smp_prepare_cpus()
@@ -457,11 +436,6 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
 	return sum;
 }
 
-/*
- * Timer (local or broadcast) support
- */
-static DEFINE_PER_CPU(struct clock_event_device, percpu_clockevent);
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 void tick_broadcast(const struct cpumask *mask)
 {
@@ -469,49 +443,6 @@ void tick_broadcast(const struct cpumask *mask)
 }
 #endif
 
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
-	if (lt_ops)
-		lt_ops->setup(evt);
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
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

