Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaBXNIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:08:55 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:56317 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaBXNIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:08:54 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2] arm/smp: Absorb boot_secondary()
Date: Mon, 24 Feb 2014 14:08:47 +0100
Message-Id: <1393247328-23163-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

After becoming a mandatory function, boot_secondary() is no longer used
outside arch/arm/kernel/smp.c. Hence remove its public prototype, and,
as suggested by Arnd, let it be absorbed by its single caller.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
This is v2 of "arm/smp: Make boot_secondary() static":
  - Absorb boot_secondary() instead of making it static.

 arch/arm/include/asm/smp.h |    6 ------
 arch/arm/kernel/smp.c      |   12 ++++--------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 22a3b9b5d4a1..0d2c8c6f8d1d 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -49,12 +49,6 @@ extern void smp_init_cpus(void);
 extern void set_smp_cross_call(void (*)(const struct cpumask *, unsigned int));
 
 /*
- * Boot a secondary CPU, and assign it the specified idle task.
- * This also gives us the initial stack to use for this CPU.
- */
-extern int boot_secondary(unsigned int cpu, struct task_struct *);
-
-/*
  * Called from platform specific assembly code, this is the
  * secondary CPU entry point.
  */
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index b7b4c86e338b..6cd72d502f69 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -92,6 +92,9 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
 
+	if (!smp_ops.smp_boot_secondary)
+		return -ENOSYS;
+
 	/*
 	 * We need to tell the secondary core where to find
 	 * its stack and the page tables.
@@ -110,7 +113,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 	/*
 	 * Now bring the CPU into our world.
 	 */
-	ret = boot_secondary(cpu, idle);
+	ret = smp_ops.smp_boot_secondary(cpu, idle);
 	if (ret == 0) {
 		/*
 		 * CPU was successfully started, wait for it
@@ -139,13 +142,6 @@ void __init smp_init_cpus(void)
 		smp_ops.smp_init_cpus();
 }
 
-int boot_secondary(unsigned int cpu, struct task_struct *idle)
-{
-	if (smp_ops.smp_boot_secondary)
-		return smp_ops.smp_boot_secondary(cpu, idle);
-	return -ENOSYS;
-}
-
 int platform_can_cpu_hotplug(void)
 {
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.7.9.5

