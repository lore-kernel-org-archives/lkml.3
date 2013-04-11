Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935928Ab3DKDjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:39:17 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:47118 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab3DKDjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:39:16 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <haojian.zhuang@gmail.com>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>, Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 4/4] ARM: mmp: add SMP support for pxa988
Date: Thu, 11 Apr 2013 11:39:07 +0800
Message-ID: <1365651547-11583-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SMP support for pxa988.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/mach-mmp/Makefile  |    4 +
 arch/arm/mach-mmp/common.h  |    2 +
 arch/arm/mach-mmp/headsmp.S |  104 ++++++++++++++++++++++++++
 arch/arm/mach-mmp/mmpx-dt.c |    1 +
 arch/arm/mach-mmp/platsmp.c |  170 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-mmp/reset.c   |   66 +++++++++++++++++
 arch/arm/mach-mmp/reset.h   |   29 +++++++
 7 files changed, 376 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mmp/headsmp.S
 create mode 100644 arch/arm/mach-mmp/platsmp.c
 create mode 100644 arch/arm/mach-mmp/reset.c
 create mode 100644 arch/arm/mach-mmp/reset.h

diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index b60065f..e7b6173 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -9,6 +9,10 @@ obj-$(CONFIG_CPU_PXA168)	+= pxa168.o
 obj-$(CONFIG_CPU_PXA910)	+= pxa910.o
 obj-$(CONFIG_CPU_MMP2)		+= mmp2.o sram.o
 
+ifeq ($(CONFIG_SMP),y)
+obj-$(CONFIG_CPU_PXA988)	+= platsmp.o headsmp.o reset.o
+endif
+
 ifeq ($(CONFIG_COMMON_CLK), )
 obj-y				+= clock.o
 obj-$(CONFIG_CPU_PXA168)	+= clock-pxa168.o
diff --git a/arch/arm/mach-mmp/common.h b/arch/arm/mach-mmp/common.h
index 8c9b510..7496cd0 100644
--- a/arch/arm/mach-mmp/common.h
+++ b/arch/arm/mach-mmp/common.h
@@ -1,5 +1,7 @@
 #define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
 
+extern struct smp_operations mmp_smp_ops;
+
 extern void timer_init(int irq);
 
 extern void __init icu_init_irq(void);
diff --git a/arch/arm/mach-mmp/headsmp.S b/arch/arm/mach-mmp/headsmp.S
new file mode 100644
index 0000000..2b6177e
--- /dev/null
+++ b/arch/arm/mach-mmp/headsmp.S
@@ -0,0 +1,104 @@
+/*
+ * linux/arch/arm/mach-mmp/headsmp.S
+ *
+ * Copyright (C) 2012 Marvell, Inc.
+ *
+ * Author: Neil Zhang <zhangwm@marvell.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/memory.h>
+#include <asm/cache.h>
+#include <asm/assembler.h>
+#include <mach/addr-map.h>
+
+	__CPUINIT
+
+/*
+ * Marvell specific entry point for secondary CPUs.
+ * The secondary kernel init calls v7_flush_dcache_all before it enables
+ * the L1; however, the L1 comes out of reset in an undefined state, so
+ * the clean + invalidate performed by v7_flush_dcache_all causes a bunch
+ * of cache lines with uninitialized data and uninitialized tags to get
+ * written out to memory, which does really unpleasant things to the main
+ * processor.  We fix this by performing an invalidate, rather than a
+ * clean + invalidate for secondary core, before jumping into the kernel.
+ *
+ * This funciton is cloned from arch/arm/mach-tegra/headsmp.S, and needs
+ * to be called for both secondary cores startup and primary core resume
+ * procedures.
+ */
+	.align L1_CACHE_SHIFT
+
+
+/*
+ * PXA specific entry point for secondary CPUs.  This provides
+ * a "holding pen" into which all secondary cores are held until we're
+ * ready for them to initialise.
+ */
+ENTRY(mmp_secondary_startup)
+	mrc	p15, 0, r0, c0, c0, 5
+	and	r0, r0, #15
+	adr	r4, 1f
+	ldmia	r4, {r5, r6}
+	sub	r4, r4, r5
+	add	r6, r6, r4
+pen:	ldr	r7, [r6]
+	cmp	r7, r0
+	bne	pen
+
+	/*
+	 * we've been released from the holding pen: secondary_stack
+	 * should now contain the SVC stack for this core
+	 */
+	bl	v7_invalidate_l1
+	b	secondary_startup
+ENDPROC(mmp_secondary_startup)
+
+	.align	2
+1:	.long	.
+	.long	pen_release
+
+
+/*
+ * Note: The following code is located into the .data section. This is to
+ *       allow sw_reset_flag and cpu_plugin_handler to be accessed with a
+ *       relative load while we can't rely on any MMU translation.
+ *       Reference from: arch/arm/kernel/sleep.S
+ */
+
+	.data
+	.align
+
+/*
+ * ROM code jumps to this function while waking up from CPU
+ * OFF or software reset state. Physical address of the function is
+ * stored at CA9_WARM_RESET_VECTOR while system is bring up.
+ */
+ENTRY(mmp_cpu_reset_entry)
+	adr	r1, mmp_entry_vectors
+	mrc	p15, 0, r0, c0, c0, 5
+	and	r0, r0, #15		@ fetch CPUID
+1:
+	ldr	r2, [r1, r0, lsl #2]    @ get the handler addr for this core
+	cmp	r2, #0
+	movne	pc, r2			@ jump to the handler
+	beq	1b
+ENDPROC(mmp_cpu_reset_entry)
+
+	/* Point to the address that save handlers for each core */
+	.global mmp_entry_vectors
+mmp_entry_vectors:
+	.rept   CONFIG_NR_CPUS
+        .long   0                               @ preserve stack phys ptr here
+	.endr
diff --git a/arch/arm/mach-mmp/mmpx-dt.c b/arch/arm/mach-mmp/mmpx-dt.c
index bbc0c50..a5f5501 100644
--- a/arch/arm/mach-mmp/mmpx-dt.c
+++ b/arch/arm/mach-mmp/mmpx-dt.c
@@ -71,6 +71,7 @@ static const char *pxa988_dt_board_compat[] __initdata = {
 };
 
 DT_MACHINE_START(PXA988_DT, "Marvell PXA988 (Device Tree Support)")
+	.smp            = smp_ops(mmp_smp_ops),
 	.map_io		= mmp_map_io,
 	.init_irq	= pxa988_dt_gic_init,
 	.init_time	= pxa988_dt_init_timer,
diff --git a/arch/arm/mach-mmp/platsmp.c b/arch/arm/mach-mmp/platsmp.c
new file mode 100644
index 0000000..a6590a3
--- /dev/null
+++ b/arch/arm/mach-mmp/platsmp.c
@@ -0,0 +1,170 @@
+/*
+ *  linux/arch/arm/mach-mmp/platsmp.c
+ *
+ *  Copyright (C) 2002 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+
+#include <asm/cacheflush.h>
+#include <mach/hardware.h>
+#include <linux/irqchip/arm-gic.h>
+#include <asm/mach-types.h>
+#include <asm/localtimer.h>
+#include <asm/smp_scu.h>
+
+#include <mach/irqs.h>
+#include <mach/addr-map.h>
+
+#include "common.h"
+#include "reset.h"
+
+/*
+ * Write pen_release in a way that is guaranteed to be visible to all
+ * observers, irrespective of whether they're taking part in coherency
+ * or not.  This is necessary for the hotplug code to work reliably.
+ */
+static void __cpuinit write_pen_release(int val)
+{
+	pen_release = val;
+	smp_wmb();
+	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
+	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
+}
+
+#ifdef CONFIG_HAVE_ARM_SCU
+static void __iomem *scu_get_base_addr(void)
+{
+	return SCU_VIRT_BASE;
+}
+#endif
+
+static inline unsigned int get_core_count(void)
+{
+	u32 ret = 1;
+#ifdef CONFIG_HAVE_ARM_SCU
+	ret = scu_get_core_count(scu_get_base_addr());
+#endif
+
+	return ret;
+}
+
+static DEFINE_SPINLOCK(boot_lock);
+
+static void __cpuinit mmp_secondary_init(unsigned int cpu)
+{
+	/*
+	 * if any interrupts are already enabled for the primary
+	 * core (e.g. timer irq), then they will not have been enabled
+	 * for us: do so
+	 */
+	gic_secondary_init(0);
+
+	/*
+	 * let the primary processor know we're out of the
+	 * pen, then head off into the C entry point
+	 */
+	write_pen_release(-1);
+
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+static int __cpuinit mmp_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	/*
+	 * Avoid timer calibration on slave cpus. Use the value calibrated
+	 * on master cpu. Referenced from tegra3
+	 */
+	preset_lpj = loops_per_jiffy;
+
+	/*
+	 * set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+
+	spin_lock(&boot_lock);
+
+	/*
+	 * The secondary processor is waiting to be released from
+	 * the holding pen - release it, then wait for it to flag
+	 * that it has been released by resetting pen_release.
+	 *
+	 * Note that "pen_release" is the hardware CPU ID, whereas
+	 * "cpu" is Linux's internal ID.
+	 */
+	write_pen_release(cpu);
+
+	/* reset the cpu, let it branch to the kernel entry */
+	mmp_cpu_power_up(cpu);
+
+	timeout = jiffies + (1 * HZ);
+	while (time_before(jiffies, timeout)) {
+		smp_rmb();
+		if (pen_release == -1)
+			break;
+
+		udelay(10);
+	}
+
+	/*
+	 * now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	spin_unlock(&boot_lock);
+
+	return pen_release != -1 ? -ENOSYS : 0;
+}
+
+/*
+ * Initialise the CPU possible map early - this describes the CPUs
+ * which may be present or become present in the system.
+ */
+static void __init mmp_smp_init_cpus(void)
+{
+	unsigned int i, ncores = get_core_count();
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+}
+
+static void __init mmp_smp_prepare_cpus(unsigned int max_cpus)
+{
+	int i;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs
+	 * actually populated at the present time.
+	 */
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+
+#ifdef CONFIG_HAVE_ARM_SCU
+	scu_enable(scu_get_base_addr());
+#endif
+
+	mmp_entry_vector_init();
+}
+
+struct smp_operations mmp_smp_ops __initdata = {
+	.smp_init_cpus		= mmp_smp_init_cpus,
+	.smp_prepare_cpus	= mmp_smp_prepare_cpus,
+	.smp_secondary_init	= mmp_secondary_init,
+	.smp_boot_secondary	= mmp_boot_secondary,
+};
diff --git a/arch/arm/mach-mmp/reset.c b/arch/arm/mach-mmp/reset.c
new file mode 100644
index 0000000..b47e400
--- /dev/null
+++ b/arch/arm/mach-mmp/reset.c
@@ -0,0 +1,66 @@
+/*
+ * linux/arch/arm/mach-mmp/reset.c
+ *
+ * Author:	Neil Zhang <zhangwm@marvell.com>
+ * Copyright:	(C) 2012 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/smp.h>
+
+#include <asm/io.h>
+#include <asm/cacheflush.h>
+#include <asm/mach/map.h>
+
+#include <mach/addr-map.h>
+
+#include "reset.h"
+
+#define PMU_CC2_AP			APMU_REG(0x0100)
+#define CIU_CA9_WARM_RESET_VECTOR	CIU_REG(0x00d8)
+
+/*
+ * This function is called from boot_secondary to bootup the secondary cpu.
+ */
+void mmp_cpu_power_up(u32 cpu)
+{
+	u32 tmp;
+
+	BUG_ON(cpu == 0);
+
+	tmp = readl(PMU_CC2_AP);
+	if (tmp & CPU_CORE_RST(cpu)) {
+		/* Release secondary core from reset */
+		tmp &= ~(CPU_CORE_RST(cpu)
+			| CPU_DBG_RST(cpu) | CPU_WDOG_RST(cpu));
+		writel(tmp, PMU_CC2_AP);
+	}
+}
+
+void mmp_set_entry_vector(u32 cpu, u32 addr)
+{
+	BUG_ON(cpu >= CONFIG_NR_CPUS);
+
+	mmp_entry_vectors[cpu] = addr;
+	smp_wmb();
+	__cpuc_flush_dcache_area((void *)&mmp_entry_vectors[cpu],
+				sizeof(mmp_entry_vectors[cpu]));
+	outer_clean_range(__pa(&mmp_entry_vectors[cpu]),
+				__pa(&mmp_entry_vectors[cpu + 1]));
+}
+
+void __init mmp_entry_vector_init(void)
+{
+	int cpu;
+
+	/* We will reset from DDR directly by default */
+	writel(__pa(mmp_cpu_reset_entry), CIU_CA9_WARM_RESET_VECTOR);
+
+	for (cpu = 1; cpu < CONFIG_NR_CPUS; cpu++)
+		mmp_set_entry_vector(cpu, __pa(mmp_secondary_startup));
+}
diff --git a/arch/arm/mach-mmp/reset.h b/arch/arm/mach-mmp/reset.h
new file mode 100644
index 0000000..78d5486
--- /dev/null
+++ b/arch/arm/mach-mmp/reset.h
@@ -0,0 +1,29 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/reset.h
+ *
+ * Author:	Neil Zhang <zhangwm@marvell.com>
+ * Copyright:	(C) 2012 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __RESET_PXA988_H__
+#define __RESET_PXA988_H__
+
+#define CPU_CORE_RST(n)	(1 << ((n) * 4 + 16))
+#define CPU_DBG_RST(n)	(1 << ((n) * 4 + 18))
+#define CPU_WDOG_RST(n)	(1 << ((n) * 4 + 19))
+
+extern u32 mmp_entry_vectors[CONFIG_NR_CPUS];
+
+void mmp_secondary_startup(void);
+void mmp_cpu_reset_entry(void);
+
+void mmp_cpu_power_up(u32 cpu);
+void mmp_set_entry_vector(u32 cpu, u32 addr);
+void __init mmp_entry_vector_init(void);
+
+#endif /* __RESET_PXA988_H__ */
-- 
1.7.4.1

