Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3I0CZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:25:38 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38584 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3I0CZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:25:34 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 5/6] ARM: highbank: adapt to use ARM PSCI calls
Date: Thu, 26 Sep 2013 21:24:53 -0500
Message-Id: <1380248694-13388-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
References: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adapts highbank to use psci for smp_ops and the cpu_suspend function
for suspend/resume.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/mach-highbank/Kconfig    |  1 +
 arch/arm/mach-highbank/Makefile   |  2 --
 arch/arm/mach-highbank/core.h     |  4 ---
 arch/arm/mach-highbank/highbank.c | 16 +--------
 arch/arm/mach-highbank/hotplug.c  | 37 ---------------------
 arch/arm/mach-highbank/platsmp.c  | 68 ---------------------------------------
 arch/arm/mach-highbank/pm.c       | 27 ++++++----------
 7 files changed, 11 insertions(+), 144 deletions(-)
 delete mode 100644 arch/arm/mach-highbank/hotplug.c
 delete mode 100644 arch/arm/mach-highbank/platsmp.c

diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 8e8437d..965623d 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -10,6 +10,7 @@ config ARCH_HIGHBANK
 	select ARM_ERRATA_775420
 	select ARM_ERRATA_798181
 	select ARM_GIC
+	select ARM_PSCI
 	select ARM_TIMER_SP804
 	select CACHE_L2X0
 	select CLKDEV_LOOKUP
diff --git a/arch/arm/mach-highbank/Makefile b/arch/arm/mach-highbank/Makefile
index 8a1ef57..55840f4 100644
--- a/arch/arm/mach-highbank/Makefile
+++ b/arch/arm/mach-highbank/Makefile
@@ -3,6 +3,4 @@ obj-y					:= highbank.o system.o smc.o
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_smc.o				:=-Wa,-march=armv7-a$(plus_sec)
 
-obj-$(CONFIG_SMP)			+= platsmp.o
-obj-$(CONFIG_HOTPLUG_CPU)		+= hotplug.o
 obj-$(CONFIG_PM_SLEEP)			+= pm.o
diff --git a/arch/arm/mach-highbank/core.h b/arch/arm/mach-highbank/core.h
index aea1ec5..7ec5edc 100644
--- a/arch/arm/mach-highbank/core.h
+++ b/arch/arm/mach-highbank/core.h
@@ -3,7 +3,6 @@
 
 #include <linux/reboot.h>
 
-extern void highbank_set_cpu_jump(int cpu, void *jump_addr);
 extern void highbank_restart(enum reboot_mode, const char *);
 extern void __iomem *scu_base_addr;
 
@@ -14,8 +13,5 @@ static inline void highbank_pm_init(void) {}
 #endif
 
 extern void highbank_smc1(int fn, int arg);
-extern void highbank_cpu_die(unsigned int cpu);
-
-extern struct smp_operations highbank_smp_ops;
 
 #endif
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 8e63ccd..d15f24b 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -26,9 +26,7 @@
 #include <linux/amba/bus.h>
 #include <linux/clk-provider.h>
 
-#include <asm/cacheflush.h>
-#include <asm/cputype.h>
-#include <asm/smp_plat.h>
+#include <asm/psci.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -49,17 +47,6 @@ static void __init highbank_scu_map_io(void)
 	scu_base_addr = ioremap(base, SZ_4K);
 }
 
-#define HB_JUMP_TABLE_PHYS(cpu)		(0x40 + (0x10 * (cpu)))
-#define HB_JUMP_TABLE_VIRT(cpu)		phys_to_virt(HB_JUMP_TABLE_PHYS(cpu))
-
-void highbank_set_cpu_jump(int cpu, void *jump_addr)
-{
-	cpu = MPIDR_AFFINITY_LEVEL(cpu_logical_map(cpu), 0);
-	writel(virt_to_phys(jump_addr), HB_JUMP_TABLE_VIRT(cpu));
-	__cpuc_flush_dcache_area(HB_JUMP_TABLE_VIRT(cpu), 16);
-	outer_clean_range(HB_JUMP_TABLE_PHYS(cpu),
-			  HB_JUMP_TABLE_PHYS(cpu) + 15);
-}
 
 static void highbank_l2x0_disable(void)
 {
@@ -174,7 +161,6 @@ DT_MACHINE_START(HIGHBANK, "Highbank")
 #if defined(CONFIG_ZONE_DMA) && defined(CONFIG_ARM_LPAE)
 	.dma_zone_size	= (4ULL * SZ_1G),
 #endif
-	.smp		= smp_ops(highbank_smp_ops),
 	.init_irq	= highbank_init_irq,
 	.init_time	= highbank_timer_init,
 	.init_machine	= highbank_init,
diff --git a/arch/arm/mach-highbank/hotplug.c b/arch/arm/mach-highbank/hotplug.c
deleted file mode 100644
index a019e4e..0000000
--- a/arch/arm/mach-highbank/hotplug.c
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright 2011 Calxeda, Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-#include <linux/kernel.h>
-#include <asm/cacheflush.h>
-
-#include "core.h"
-#include "sysregs.h"
-
-extern void secondary_startup(void);
-
-/*
- * platform-specific code to shutdown a CPU
- *
- */
-void __ref highbank_cpu_die(unsigned int cpu)
-{
-	highbank_set_cpu_jump(cpu, phys_to_virt(0));
-
-	flush_cache_louis();
-	highbank_set_core_pwr();
-
-	while (1)
-		cpu_do_idle();
-}
diff --git a/arch/arm/mach-highbank/platsmp.c b/arch/arm/mach-highbank/platsmp.c
deleted file mode 100644
index 32d75cf5..0000000
--- a/arch/arm/mach-highbank/platsmp.c
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * Copyright 2010-2011 Calxeda, Inc.
- * Based on platsmp.c, Copyright (C) 2002 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/io.h>
-
-#include <asm/smp_scu.h>
-
-#include "core.h"
-
-extern void secondary_startup(void);
-
-static int highbank_boot_secondary(unsigned int cpu, struct task_struct *idle)
-{
-	highbank_set_cpu_jump(cpu, secondary_startup);
-	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
-	return 0;
-}
-
-/*
- * Initialise the CPU possible map early - this describes the CPUs
- * which may be present or become present in the system.
- */
-static void __init highbank_smp_init_cpus(void)
-{
-	unsigned int i, ncores = 4;
-
-	/* sanity check */
-	if (ncores > NR_CPUS) {
-		printk(KERN_WARNING
-		       "highbank: no. of cores (%d) greater than configured "
-		       "maximum of %d - clipping\n",
-		       ncores, NR_CPUS);
-		ncores = NR_CPUS;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-}
-
-static void __init highbank_smp_prepare_cpus(unsigned int max_cpus)
-{
-	if (scu_base_addr)
-		scu_enable(scu_base_addr);
-}
-
-struct smp_operations highbank_smp_ops __initdata = {
-	.smp_init_cpus		= highbank_smp_init_cpus,
-	.smp_prepare_cpus	= highbank_smp_prepare_cpus,
-	.smp_boot_secondary	= highbank_boot_secondary,
-#ifdef CONFIG_HOTPLUG_CPU
-	.cpu_die		= highbank_cpu_die,
-#endif
-};
diff --git a/arch/arm/mach-highbank/pm.c b/arch/arm/mach-highbank/pm.c
index 04eddb4..7f2bd85 100644
--- a/arch/arm/mach-highbank/pm.c
+++ b/arch/arm/mach-highbank/pm.c
@@ -16,27 +16,19 @@
 
 #include <linux/cpu_pm.h>
 #include <linux/init.h>
-#include <linux/io.h>
 #include <linux/suspend.h>
 
-#include <asm/cacheflush.h>
-#include <asm/proc-fns.h>
 #include <asm/suspend.h>
-
-#include "core.h"
-#include "sysregs.h"
+#include <asm/psci.h>
 
 static int highbank_suspend_finish(unsigned long val)
 {
-	outer_flush_all();
-	outer_disable();
-
-	highbank_set_pwr_suspend();
-
-	cpu_do_idle();
+	const struct psci_power_state ps = {
+		.type = PSCI_POWER_STATE_TYPE_POWER_DOWN,
+		.affinity_level = 1,
+	};
 
-	highbank_clear_pwr_request();
-	return 0;
+	return psci_ops.cpu_suspend(ps, __pa(cpu_resume));
 }
 
 static int highbank_pm_enter(suspend_state_t state)
@@ -44,15 +36,11 @@ static int highbank_pm_enter(suspend_state_t state)
 	cpu_pm_enter();
 	cpu_cluster_pm_enter();
 
-	highbank_set_cpu_jump(0, cpu_resume);
 	cpu_suspend(0, highbank_suspend_finish);
 
 	cpu_cluster_pm_exit();
 	cpu_pm_exit();
 
-	highbank_smc1(0x102, 0x1);
-	if (scu_base_addr)
-		scu_enable(scu_base_addr);
 	return 0;
 }
 
@@ -63,5 +51,8 @@ static const struct platform_suspend_ops highbank_pm_ops = {
 
 void __init highbank_pm_init(void)
 {
+	if (!psci_ops.cpu_suspend)
+		return;
+
 	suspend_set_ops(&highbank_pm_ops);
 }
-- 
1.8.1.2

