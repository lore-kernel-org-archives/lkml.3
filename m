Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaC1VNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:13:06 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52973 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaC1VMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:12:51 -0400
From: Alex Elder <elder@linaro.org>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, viresh.linux@gmail.com,
        shiraz.hashim@gmail.com, catalin.marinas@arm.com
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/7] ARM: spear: use central SMP spin-table routines
Date: Fri, 28 Mar 2014 16:13:00 -0500
Message-Id: <1396041180-29897-8-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396041180-29897-1-git-send-email-elder@linaro.org>
References: <1396041180-29897-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the spear-specific code that implements the "holding pen"
for secondary CPUs.  Use the code defined in "arch/arm/kernel/smp.c"
instead.

Note:
The original "holding pen" code for this machine used only the
bottom 4 bits of the MPIDR to identify the processor id.  The
common code looks at the bottom 24 bits.  The validity of this
change needs to be verified.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/mach-spear/Makefile  |    2 +-
 arch/arm/mach-spear/generic.h |    1 -
 arch/arm/mach-spear/headsmp.S |   47 --------------------------
 arch/arm/mach-spear/platsmp.c |   75 ++---------------------------------------
 4 files changed, 4 insertions(+), 121 deletions(-)
 delete mode 100644 arch/arm/mach-spear/headsmp.S

diff --git a/arch/arm/mach-spear/Makefile b/arch/arm/mach-spear/Makefile
index a946c19..974a417 100644
--- a/arch/arm/mach-spear/Makefile
+++ b/arch/arm/mach-spear/Makefile
@@ -7,7 +7,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
 # Common support
 obj-y	:= restart.o time.o
 
-smp-$(CONFIG_SMP)		+= headsmp.o platsmp.o
+smp-$(CONFIG_SMP)		+= platsmp.o
 smp-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 
 obj-$(CONFIG_ARCH_SPEAR13XX)	+= spear13xx.o $(smp-y)
diff --git a/arch/arm/mach-spear/generic.h b/arch/arm/mach-spear/generic.h
index a99d90a..86189ec 100644
--- a/arch/arm/mach-spear/generic.h
+++ b/arch/arm/mach-spear/generic.h
@@ -36,7 +36,6 @@ void __init spear13xx_l2x0_init(void);
 
 void spear_restart(enum reboot_mode, const char *);
 
-void spear13xx_secondary_startup(void);
 void spear13xx_cpu_die(unsigned int cpu);
 
 extern struct smp_operations spear13xx_smp_ops;
diff --git a/arch/arm/mach-spear/headsmp.S b/arch/arm/mach-spear/headsmp.S
deleted file mode 100644
index ed85473..0000000
--- a/arch/arm/mach-spear/headsmp.S
+++ /dev/null
@@ -1,47 +0,0 @@
-/*
- * arch/arm/mach-spear13XX/headsmp.S
- *
- * Picked from realview
- * Copyright (c) 2012 ST Microelectronics Limited
- * Shiraz Hashim <shiraz.hashim@st.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/linkage.h>
-#include <linux/init.h>
-
-	__INIT
-
-/*
- * spear13xx specific entry point for secondary CPUs. This provides
- * a "holding pen" into which all secondary cores are held until we're
- * ready for them to initialise.
- */
-ENTRY(spear13xx_secondary_startup)
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
-	/* re-enable coherency */
-	mrc	p15, 0, r0, c1, c0, 1
-	orr	r0, r0, #(1 << 6) | (1 << 0)
-	mcr	p15, 0, r0, c1, c0, 1
-	/*
-	 * we've been released from the holding pen: secondary_stack
-	 * should now contain the SVC stack for this core
-	 */
-	b	secondary_startup
-
-	.align
-1:	.long	.
-	.long	pen_release
-ENDPROC(spear13xx_secondary_startup)
diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index e16f779..e97af7d 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -20,77 +20,8 @@
 #include <mach/spear.h>
 #include "generic.h"
 
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
-static DEFINE_SPINLOCK(boot_lock);
-
 static void __iomem *scu_base = IOMEM(VA_SCU_BASE);
 
-static void spear13xx_secondary_init(unsigned int cpu)
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
-static int spear13xx_boot_secondary(unsigned int cpu, struct task_struct *idle)
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
-	 *
-	 * Note that "pen_release" is the hardware CPU ID, whereas
-	 * "cpu" is Linux's internal ID.
-	 */
-	write_pen_release(cpu);
-
-	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
-
-	timeout = jiffies + (1 * HZ);
-	while (time_before(jiffies, timeout)) {
-		smp_rmb();
-		if (pen_release == -1)
-			break;
-
-		udelay(10);
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
 /*
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
@@ -119,14 +50,14 @@ static void __init spear13xx_smp_prepare_cpus(unsigned int max_cpus)
 	 * (presently it is in SRAM). The BootMonitor waits until it receives a
 	 * soft interrupt, and then the secondary CPU branches to this address.
 	 */
-	__raw_writel(virt_to_phys(spear13xx_secondary_startup), SYS_LOCATION);
+	__raw_writel(virt_to_phys(secondary_holding_pen), SYS_LOCATION);
 }
 
 struct smp_operations spear13xx_smp_ops __initdata = {
        .smp_init_cpus		= spear13xx_smp_init_cpus,
        .smp_prepare_cpus	= spear13xx_smp_prepare_cpus,
-       .smp_secondary_init	= spear13xx_secondary_init,
-       .smp_boot_secondary	= spear13xx_boot_secondary,
+       .smp_secondary_init	= smp_secondary_init,
+       .smp_boot_secondary	= smp_boot_secondary,
 #ifdef CONFIG_HOTPLUG_CPU
        .cpu_die			= spear13xx_cpu_die,
 #endif
-- 
1.7.9.5

