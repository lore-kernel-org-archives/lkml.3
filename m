Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaC1VNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:13:01 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60543 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaC1VMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:12:50 -0400
From: Alex Elder <elder@linaro.org>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, viresh.linux@gmail.com,
        shiraz.hashim@gmail.com, catalin.marinas@arm.com
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/7] ARM: ux500: use generic SMP spin-table routines
Date: Fri, 28 Mar 2014 16:12:59 -0500
Message-Id: <1396041180-29897-7-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396041180-29897-1-git-send-email-elder@linaro.org>
References: <1396041180-29897-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the ux500-specific code that implements the "holding pen"
for secondary CPUs.  Use the code defined in "arch/arm/kernel/smp.c"
instead.

Note:
The original "holding pen" code for this machine used only the
bottom 4 bits of the MPIDR to identify the processor id.  The
common code looks at the bottom 24 bits.  The validity of this
change needs to be verified.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/mach-ux500/Makefile  |    2 +-
 arch/arm/mach-ux500/headsmp.S |   37 ---------------------
 arch/arm/mach-ux500/platsmp.c |   72 ++---------------------------------------
 3 files changed, 4 insertions(+), 107 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/headsmp.S

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index d05ba75..0308fe1 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_MACH_MOP500)	+= board-mop500-sdi.o \
 				board-mop500-regulators.o \
 				board-mop500-pins.o \
 				board-mop500-audio.o
-obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
+obj-$(CONFIG_SMP)		+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 
 CFLAGS_hotplug.o		+= -march=armv7-a
diff --git a/arch/arm/mach-ux500/headsmp.S b/arch/arm/mach-ux500/headsmp.S
deleted file mode 100644
index 9cdea04..0000000
--- a/arch/arm/mach-ux500/headsmp.S
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- *  Copyright (c) 2009 ST-Ericsson
- *	This file is based  ARM Realview platform
- *  Copyright (c) 2003 ARM Limited
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/linkage.h>
-#include <linux/init.h>
-
-/*
- * U8500 specific entry point for secondary CPUs.
- */
-ENTRY(u8500_secondary_startup)
-	mrc	p15, 0, r0, c0, c0, 5
-	and	r0, r0, #15
-	adr	r4, 1f
-	ldmia	r4, {r5, r6}
-	sub	r4, r4, r5
-	add	r6, r6, r4
-pen:	ldr	r7, [r6]
-	cmp	r7, r0
-	bne	pen
-
-	/*
-	 * we've been released from the holding pen: secondary_stack
-	 * should now contain the SVC stack for this core
-	 */
-	b	secondary_startup
-ENDPROC(u8500_secondary_startup)
-
-	.align 2
-1:	.long	.
-	.long	pen_release
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index a44967f..6812aac 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -26,21 +26,6 @@
 #include "db8500-regs.h"
 #include "id.h"
 
-/* This is called from headsmp.S to wakeup the secondary core */
-extern void u8500_secondary_startup(void);
-
-/*
- * Write pen_release in a way that is guaranteed to be visible to all
- * observers, irrespective of whether they're taking part in coherency
- * or not.  This is necessary for the hotplug code to work reliably.
- */
-static void write_pen_release(int val)
-{
-	pen_release = val;
-	smp_wmb();
-	sync_cache_w(&pen_release);
-}
-
 static void __iomem *scu_base_addr(void)
 {
 	if (cpu_is_u8500_family() || cpu_is_ux540_family())
@@ -51,57 +36,6 @@ static void __iomem *scu_base_addr(void)
 	return NULL;
 }
 
-static DEFINE_SPINLOCK(boot_lock);
-
-static void ux500_secondary_init(unsigned int cpu)
-{
-	/*
-	 * let the primary processor know we're out of the
-	 * pen, then head off into the C entry point
-	 */
-	write_pen_release(-1);
-
-	/*
-	 * Synchronise with the boot thread.
-	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
-}
-
-static int ux500_boot_secondary(unsigned int cpu, struct task_struct *idle)
-{
-	unsigned long timeout;
-
-	/*
-	 * set synchronisation state between this boot processor
-	 * and the secondary one
-	 */
-	spin_lock(&boot_lock);
-
-	/*
-	 * The secondary processor is waiting to be released from
-	 * the holding pen - release it, then wait for it to flag
-	 * that it has been released by resetting pen_release.
-	 */
-	write_pen_release(cpu_logical_map(cpu));
-
-	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
-
-	timeout = jiffies + (1 * HZ);
-	while (time_before(jiffies, timeout)) {
-		if (pen_release == -1)
-			break;
-	}
-
-	/*
-	 * now the secondary core is starting up let it run its
-	 * calibrations, then wait for it to finish
-	 */
-	spin_unlock(&boot_lock);
-
-	return pen_release != -1 ? -ENOSYS : 0;
-}
-
 static void __init wakeup_secondary(void)
 {
 	void __iomem *backupram;
@@ -118,7 +52,7 @@ static void __init wakeup_secondary(void)
 	 * is waiting for. This would wake up the secondary core from WFE
 	 */
 #define UX500_CPU1_JUMPADDR_OFFSET 0x1FF4
-	__raw_writel(virt_to_phys(u8500_secondary_startup),
+	__raw_writel(virt_to_phys(secondary_holding_pen),
 		     backupram + UX500_CPU1_JUMPADDR_OFFSET);
 
 #define UX500_CPU1_WAKEMAGIC_OFFSET 0x1FF0
@@ -161,8 +95,8 @@ static void __init ux500_smp_prepare_cpus(unsigned int max_cpus)
 struct smp_operations ux500_smp_ops __initdata = {
 	.smp_init_cpus		= ux500_smp_init_cpus,
 	.smp_prepare_cpus	= ux500_smp_prepare_cpus,
-	.smp_secondary_init	= ux500_secondary_init,
-	.smp_boot_secondary	= ux500_boot_secondary,
+	.smp_boot_secondary	= smp_boot_secondary,
+	.smp_secondary_init	= smp_secondary_init,
 #ifdef CONFIG_HOTPLUG_CPU
 	.cpu_die		= ux500_cpu_die,
 #endif
-- 
1.7.9.5

