Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3AQMAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:00:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3AQMAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:00:22 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: shmobile: sh73a0: Use generic irqchip_init()
Date: Thu, 17 Jan 2013 13:00:13 +0100
Message-Id: <1358424013-31306-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:ILS0Rq05wPYMhVy7HqVC2Qg3rr55/gjr1a8PxLHT7e4
 ILmV+PoWE3oVv9amSP5VSOireyNCUYRhPtqHgtvjWPOf4upQvc
 BqgU2hKFBQP/Q9FsmRWpbWSBqMiC6ZEGrBsEp35WZrZHgux025
 nkT3MiNGWRcDFXfpXcuccTGd50J7k//mUpRX6ms+A3XLgMpp+H
 WwmUuB2ycOy1JRgSNzpRqKwQsBcCKmP5aLgvHa6GMi/6sN3sk7
 vM5eeilItdT95/+yQnAd1D78O4P/YAl9PrN3yGAfq+I7dkTCsn
 4D/ptlaMZ4zIcvjTa5L3rd9aptDf2CJMbNV9Clfdc7hCb43pqN
 GnNtGxi6mehBTagq9AZuxuBQ+UFUNG7ldECjhIX2D8kpcEmSfi
 4JbSVY2INpT5DIUVCMDk6mQlPEYPR0AXyGh1VVEhU278c60a+G
 20u4y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm/hardware/gic.h header does no longer exist and the corresponding
functionality was moved to linux/irqchip.h and linux/irqchip/arm-gic.h
respectively. gic_handle_irq() and of_irq_init() are no longer available
either and have been replaced by irqchip_init().

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mach-shmobile/board-kzm9g-reference.c | 1 -
 arch/arm/mach-shmobile/intc-sh73a0.c           | 9 ++-------
 arch/arm/mach-shmobile/setup-sh73a0.c          | 2 --
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
index 04e9ae5..08c95dd 100644
--- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
+++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
@@ -90,7 +90,6 @@ DT_MACHINE_START(KZM9G_DT, "kzm9g-reference")
 	.init_early	= sh73a0_add_early_devices_dt,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= sh73a0_init_irq_dt,
-	.handle_irq	= gic_handle_irq,
 	.init_machine	= kzm_init,
 	.init_late	= shmobile_init_late,
 	.init_time	= shmobile_timer_init,
diff --git a/arch/arm/mach-shmobile/intc-sh73a0.c b/arch/arm/mach-shmobile/intc-sh73a0.c
index fc7c8da..91faba6 100644
--- a/arch/arm/mach-shmobile/intc-sh73a0.c
+++ b/arch/arm/mach-shmobile/intc-sh73a0.c
@@ -21,9 +21,9 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/irq.h>
-#include <linux/of_irq.h>
 #include <linux/io.h>
 #include <linux/sh_intc.h>
+#include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic.h>
 #include <mach/intc.h>
 #include <mach/irqs.h>
@@ -462,14 +462,9 @@ void __init sh73a0_init_irq(void)
 }
 
 #ifdef CONFIG_OF
-static const struct of_device_id irq_of_match[] __initconst = {
-	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
-	{ },
-};
-
 void __init sh73a0_init_irq_dt(void)
 {
-	of_irq_init(irq_of_match);
+	irqchip_init();
 	gic_arch_extn.irq_set_wake = sh73a0_set_wake;
 }
 #endif
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index abf1eb0..2ecd668 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -36,7 +36,6 @@
 #include <mach/irqs.h>
 #include <mach/sh73a0.h>
 #include <mach/common.h>
-#include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
 #include <asm/mach/map.h>
 #include <asm/mach/arch.h>
@@ -892,7 +891,6 @@ DT_MACHINE_START(SH73A0_DT, "Generic SH73A0 (Flattened Device Tree)")
 	.init_early	= sh73a0_add_early_devices_dt,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= sh73a0_init_irq_dt,
-	.handle_irq	= gic_handle_irq,
 	.init_machine	= sh73a0_add_standard_devices_dt,
 	.init_time	= shmobile_timer_init,
 	.dt_compat	= sh73a0_boards_compat_dt,
-- 
1.8.1.1

