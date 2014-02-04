Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936084AbaBDWhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:37:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58113 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934123AbaBDWhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:37:09 -0500
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: msm: kill off hotplug.c
Date: Tue,  4 Feb 2014 16:36:57 -0600
Message-Id: <1391553421-26914-2-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1391553421-26914-1-git-send-email-galak@codeaurora.org>
References: <1391553421-26914-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now hotplug.c only really implements msm_cpu_die as a wfi.  Just
move that implementation into platsmp.c.  At the same time we use the
existing wfi() instead of inline asm.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/mach-msm/Makefile  |  1 -
 arch/arm/mach-msm/common.h  |  1 -
 arch/arm/mach-msm/hotplug.c | 51 ---------------------------------------------
 arch/arm/mach-msm/platsmp.c |  7 +++++++
 4 files changed, 7 insertions(+), 53 deletions(-)
 delete mode 100644 arch/arm/mach-msm/hotplug.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 721f27f..8327f60 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -18,7 +18,6 @@ obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
 
 CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
 
-obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SMP) += platsmp.o
 
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index 33c7725..0a4899b 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -24,7 +24,6 @@ extern void __iomem *__msm_ioremap_caller(phys_addr_t phys_addr, size_t size,
 					  unsigned int mtype, void *caller);
 
 extern struct smp_operations msm_smp_ops;
-extern void msm_cpu_die(unsigned int cpu);
 
 struct msm_mmc_platform_data;
 
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
deleted file mode 100644
index cea80fc..0000000
--- a/arch/arm/mach-msm/hotplug.c
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- *  Copyright (C) 2002 ARM Ltd.
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/smp.h>
-
-#include <asm/smp_plat.h>
-
-#include "common.h"
-
-static inline void cpu_enter_lowpower(void)
-{
-}
-
-static inline void cpu_leave_lowpower(void)
-{
-}
-
-static inline void platform_do_lowpower(unsigned int cpu)
-{
-	asm("wfi"
-	    :
-	    :
-	    : "memory", "cc");
-}
-
-/*
- * platform-specific code to shutdown a CPU
- *
- * Called with IRQs disabled
- */
-void __ref msm_cpu_die(unsigned int cpu)
-{
-	/*
-	 * we're ready for shutdown now, so do it
-	 */
-	cpu_enter_lowpower();
-	platform_do_lowpower(cpu);
-
-	/*
-	 * bring this CPU back into the world of cache
-	 * coherency, and then restore interrupts
-	 */
-	cpu_leave_lowpower();
-}
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 3721b31..251a91e 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -29,6 +29,13 @@ extern void secondary_startup(void);
 
 static DEFINE_SPINLOCK(boot_lock);
 
+#ifdef CONFIG_HOTPLUG_CPU
+static void __ref msm_cpu_die(unsigned int cpu)
+{
+	wfi();
+}
+#endif
+
 static inline int get_core_count(void)
 {
 	/* 1 + the PART[1:0] field of MIDR */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

