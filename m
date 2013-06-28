Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3F1X00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:26:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60745 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1X0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:26:23 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: msm: Remove pen_release usage
Date: Fri, 28 Jun 2013 16:25:59 -0700
Message-Id: <1372461962-17197-2-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
References: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pen_release is no longer required as the synchronization
is now managed by generic arm code.
This is done as suggested in https://lkml.org/lkml/2013/6/4/184

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/headsmp.S | 41 -----------------------------------------
 arch/arm/mach-msm/hotplug.c | 31 ++++---------------------------
 arch/arm/mach-msm/platsmp.c | 35 +++--------------------------------
 3 files changed, 7 insertions(+), 100 deletions(-)
 delete mode 100644 arch/arm/mach-msm/headsmp.S

diff --git a/arch/arm/mach-msm/headsmp.S b/arch/arm/mach-msm/headsmp.S
deleted file mode 100644
index bcd5af2..0000000
--- a/arch/arm/mach-msm/headsmp.S
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- *  linux/arch/arm/mach-realview/headsmp.S
- *
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
-	__CPUINIT
-
-/*
- * MSM specific entry point for secondary CPUs.  This provides
- * a "holding pen" into which all secondary cores are held until we're
- * ready for them to initialise.
- */
-ENTRY(msm_secondary_startup)
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
-ENDPROC(msm_secondary_startup)
-
-	.align
-1:	.long	.
-	.long	pen_release
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
index 326a872..cea80fc 100644
--- a/arch/arm/mach-msm/hotplug.c
+++ b/arch/arm/mach-msm/hotplug.c
@@ -24,33 +24,10 @@ static inline void cpu_leave_lowpower(void)
 
 static inline void platform_do_lowpower(unsigned int cpu)
 {
-	/* Just enter wfi for now. TODO: Properly shut off the cpu. */
-	for (;;) {
-		/*
-		 * here's the WFI
-		 */
-		asm("wfi"
-		    :
-		    :
-		    : "memory", "cc");
-
-		if (pen_release == cpu_logical_map(cpu)) {
-			/*
-			 * OK, proper wakeup, we're done
-			 */
-			break;
-		}
-
-		/*
-		 * getting here, means that we have come out of WFI without
-		 * having been woken up - this shouldn't happen
-		 *
-		 * The trouble is, letting people know about this is not really
-		 * possible, since we are currently running incoherently, and
-		 * therefore cannot safely call printk() or anything else
-		 */
-		pr_debug("CPU%u: spurious wakeup call\n", cpu);
-	}
+	asm("wfi"
+	    :
+	    :
+	    : "memory", "cc");
 }
 
 /*
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 00cdb0a..7d48759 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -28,7 +28,7 @@
 #define SCSS_CPU1CORE_RESET 0xD80
 #define SCSS_DBG_STATUS_CORE_PWRDUP 0xE64
 
-extern void msm_secondary_startup(void);
+extern void secondary_startup(void);
 
 static DEFINE_SPINLOCK(boot_lock);
 
@@ -41,13 +41,6 @@ static inline int get_core_count(void)
 static void __cpuinit msm_secondary_init(unsigned int cpu)
 {
 	/*
-	 * let the primary processor know we're out of the
-	 * pen, then head off into the C entry point
-	 */
-	pen_release = -1;
-	smp_wmb();
-
-	/*
 	 * Synchronise with the boot thread.
 	 */
 	spin_lock(&boot_lock);
@@ -57,7 +50,7 @@ static void __cpuinit msm_secondary_init(unsigned int cpu)
 static __cpuinit void prepare_cold_cpu(unsigned int cpu)
 {
 	int ret;
-	ret = scm_set_boot_addr(virt_to_phys(msm_secondary_startup),
+	ret = scm_set_boot_addr(virt_to_phys(secondary_startup),
 				SCM_FLAG_COLDBOOT_CPU1);
 	if (ret == 0) {
 		void __iomem *sc1_base_ptr;
@@ -75,7 +68,6 @@ static __cpuinit void prepare_cold_cpu(unsigned int cpu)
 
 static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
-	unsigned long timeout;
 	static int cold_boot_done;
 
 	/* Only need to bring cpu out of reset this way once */
@@ -91,40 +83,19 @@ static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *id
 	spin_lock(&boot_lock);
 
 	/*
-	 * The secondary processor is waiting to be released from
-	 * the holding pen - release it, then wait for it to flag
-	 * that it has been released by resetting pen_release.
-	 *
-	 * Note that "pen_release" is the hardware CPU ID, whereas
-	 * "cpu" is Linux's internal ID.
-	 */
-	pen_release = cpu_logical_map(cpu);
-	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
-	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
-
-	/*
 	 * Send the secondary CPU a soft interrupt, thereby causing
 	 * the boot monitor to read the system wide flags register,
 	 * and branch to the address found there.
 	 */
 	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
 
-	timeout = jiffies + (1 * HZ);
-	while (time_before(jiffies, timeout)) {
-		smp_rmb();
-		if (pen_release == -1)
-			break;
-
-		udelay(10);
-	}
-
 	/*
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
 	spin_unlock(&boot_lock);
 
-	return pen_release != -1 ? -ENOSYS : 0;
+	return 0;
 }
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

