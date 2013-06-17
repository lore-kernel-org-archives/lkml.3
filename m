Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3FQAuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:50:51 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37050 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3FQAuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:50:50 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC] arm: Remove sa1111 special case from arm_mm_memblock_reserve()
Date: Mon, 17 Jun 2013 01:43:19 +0100
Message-Id: <1371429799-7128-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The machine desc structure has a hook for doing machine-specific
memblock code, but the SA1111 still has a platform-specific hook in the
generic code. This patch merely moves the needed memblock_reserve()
into a callback.

This still leaves a special case in mem_init() to call
free_reserved_area() on the same region, but there isn't a suitable hook
in mdesc for making that call so the change is left to another patch.

Compile tested only.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-sa1100/assabet.c    |  1 +
 arch/arm/mach-sa1100/badge4.c     |  1 +
 arch/arm/mach-sa1100/generic.c    | 12 ++++++++++++
 arch/arm/mach-sa1100/generic.h    |  1 +
 arch/arm/mach-sa1100/jornada720.c |  1 +
 arch/arm/mm/mmu.c                 |  8 --------
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index e838ba2..aab247a 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -621,6 +621,7 @@ MACHINE_START(ASSABET, "Intel-Assabet")
 	.fixup		= fixup_assabet,
 	.map_io		= assabet_map_io,
 	.nr_irqs	= SA1100_NR_IRQS,
+	.reserve	= sa1100_reserve,
 	.init_irq	= sa1100_init_irq,
 	.init_time	= sa1100_timer_init,
 	.init_machine	= assabet_init,
diff --git a/arch/arm/mach-sa1100/badge4.c b/arch/arm/mach-sa1100/badge4.c
index 63361b6..9033d74 100644
--- a/arch/arm/mach-sa1100/badge4.c
+++ b/arch/arm/mach-sa1100/badge4.c
@@ -334,6 +334,7 @@ MACHINE_START(BADGE4, "Hewlett-Packard Laboratories BadgePAD 4")
 	.atag_offset	= 0x100,
 	.map_io		= badge4_map_io,
 	.nr_irqs	= SA1100_NR_IRQS,
+	.reserve	= sa1100_reserve,
 	.init_irq	= sa1100_init_irq,
 	.init_late	= sa11x0_init_late,
 	.init_time	= sa1100_timer_init,
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 9db3e98..1e7164e 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/memblock.h>
 #include <linux/pm.h>
 #include <linux/cpufreq.h>
 #include <linux/ioport.h>
@@ -26,6 +27,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
 #include <asm/irq.h>
+#include <asm/pgtable.h>
 #include <asm/system_misc.h>
 
 #include <mach/hardware.h>
@@ -351,6 +353,16 @@ static struct platform_device *sa11x0_devices[] __initdata = {
 	&sa11x0dma_device,
 };
 
+void __init sa1100_reserve(void)
+{
+	/*
+	 * Because of the SA1111 DMA bug, we want to preserve our
+	 * precious DMA-able memory...
+	 */
+	if (IS_ENABLED(CONFIG_SA1111))
+		memblock_reserve(PHYS_OFFSET, __pa(swapper_pg_dir) - PHYS_OFFSET);
+}
+
 static int __init sa1100_init(void)
 {
 	pm_power_off = sa1100_power_off;
diff --git a/arch/arm/mach-sa1100/generic.h b/arch/arm/mach-sa1100/generic.h
index 2abc6a1..5d8398c 100644
--- a/arch/arm/mach-sa1100/generic.h
+++ b/arch/arm/mach-sa1100/generic.h
@@ -5,6 +5,7 @@
  */
 
 extern void sa1100_timer_init(void);
+extern void sa1100_reserve(void);
 extern void __init sa1100_map_io(void);
 extern void __init sa1100_init_irq(void);
 extern void __init sa1100_init_gpio(void);
diff --git a/arch/arm/mach-sa1100/jornada720.c b/arch/arm/mach-sa1100/jornada720.c
index c0b1f5b..d95961a 100644
--- a/arch/arm/mach-sa1100/jornada720.c
+++ b/arch/arm/mach-sa1100/jornada720.c
@@ -345,6 +345,7 @@ MACHINE_START(JORNADA720, "HP Jornada 720")
 	.atag_offset	= 0x100,
 	.map_io		= jornada720_map_io,
 	.nr_irqs	= SA1100_NR_IRQS,
+	.reserve	= sa1100_reserve,
 	.init_irq	= sa1100_init_irq,
 	.init_time	= sa1100_timer_init,
 	.init_machine	= jornada720_mach_init,
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e0d8565..f281a24 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1147,14 +1147,6 @@ void __init arm_mm_memblock_reserve(void)
 	 * and can only be in node 0.
 	 */
 	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_PG_DIR_SIZE);
-
-#ifdef CONFIG_SA1111
-	/*
-	 * Because of the SA1111 DMA bug, we want to preserve our
-	 * precious DMA-able memory...
-	 */
-	memblock_reserve(PHYS_OFFSET, __pa(swapper_pg_dir) - PHYS_OFFSET);
-#endif
 }
 
 /*
-- 
1.8.1.2

