Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaGIPCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:02:08 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:60881 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaGIPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:02:06 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3] arm/smp: Absorb boot_secondary()
Date: Wed,  9 Jul 2014 17:01:59 +0200
Message-Id: <1404918119-3676-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After becoming a mandatory function, boot_secondary() is no longer used
outside arch/arm/kernel/smp.c. Hence remove its public prototype, and,
as suggested by Arnd, let it be absorbed by its single caller.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
v3:
  - Add Acked-by

v2:
  - This is v2 of "arm/smp: Make boot_secondary() static"
  - Absorb boot_secondary() instead of making it static.
---
 arch/arm/include/asm/smp.h |  6 ------
 arch/arm/kernel/smp.c      | 12 ++++--------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 2ec765c39ab4..18f5a554134f 100644
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
index 7c4fada440f0..2cf681bccd6f 100644
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
1.9.1

