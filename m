Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaACPqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:46:07 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:54457 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaACPqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:46:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] arm/smp: Make boot_secondary() static
Date: Fri,  3 Jan 2014 16:45:59 +0100
Message-Id: <1388763959-27491-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

After becoming a mandatory function, boot_secondary() is no longer used
outside arch/arm/kernel/smp.c. Hence make it static.
The code is reshuffled a bit to avoid a forward declaration.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/arm/include/asm/smp.h |    6 ------
 arch/arm/kernel/smp.c      |   18 +++++++++++-------
 2 files changed, 11 insertions(+), 13 deletions(-)

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
index dc894ab3622b..d05259a33d93 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -88,6 +88,17 @@ static unsigned long get_arch_pgd(pgd_t *pgd)
 	return pgdir >> ARCH_PGD_SHIFT;
 }
 
+/*
+ * Boot a secondary CPU, and assign it the specified idle task.
+ * This also gives us the initial stack to use for this CPU.
+ */
+static int boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	if (smp_ops.smp_boot_secondary)
+		return smp_ops.smp_boot_secondary(cpu, idle);
+	return -ENOSYS;
+}
+
 int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
@@ -140,13 +151,6 @@ void __init smp_init_cpus(void)
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

