Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3GIGo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:44:56 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:59202 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab3GIGoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:44:55 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <grant.likely@linaro.org>, <haojian.zhuang@gmail.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF DECLARE
Date: Tue, 9 Jul 2013 14:42:45 +0800
Message-ID: <1373352166-10064-3-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

support CLOCKSOURCE OF DECLARE for mmp timer.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm/mach-mmp/mmp-dt.c  |    5 ++---
 arch/arm/mach-mmp/mmp2-dt.c |    3 +--
 arch/arm/mach-mmp/time.c    |   15 ++-------------
 3 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-mmp/mmp-dt.c b/arch/arm/mach-mmp/mmp-dt.c
index 62c5adb..87ab5ff 100644
--- a/arch/arm/mach-mmp/mmp-dt.c
+++ b/arch/arm/mach-mmp/mmp-dt.c
@@ -20,7 +20,6 @@
 #include "common.h"
 
 extern void __init mmp_dt_irq_init(void);
-extern void __init mmp_dt_init_timer(void);
 
 static const struct of_dev_auxdata pxa168_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
@@ -65,7 +64,7 @@ static const char *mmp_dt_board_compat[] __initdata = {
 DT_MACHINE_START(PXA168_DT, "Marvell PXA168 (Device Tree Support)")
 	.map_io		= mmp_map_io,
 	.init_irq	= mmp_dt_irq_init,
-	.init_time	= mmp_dt_init_timer,
+	.init_time	= clocksource_of_init,
 	.init_machine	= pxa168_dt_init,
 	.dt_compat	= mmp_dt_board_compat,
 MACHINE_END
@@ -73,7 +72,7 @@ MACHINE_END
 DT_MACHINE_START(PXA910_DT, "Marvell PXA910 (Device Tree Support)")
 	.map_io		= mmp_map_io,
 	.init_irq	= mmp_dt_irq_init,
-	.init_time	= mmp_dt_init_timer,
+	.init_time	= clocksource_of_init,
 	.init_machine	= pxa910_dt_init,
 	.dt_compat	= mmp_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-mmp/mmp2-dt.c b/arch/arm/mach-mmp/mmp2-dt.c
index 6523ecf..0ce46f1 100644
--- a/arch/arm/mach-mmp/mmp2-dt.c
+++ b/arch/arm/mach-mmp/mmp2-dt.c
@@ -22,7 +22,6 @@
 #include "common.h"
 
 extern void __init mmp_dt_irq_init(void);
-extern void __init mmp_dt_init_timer(void);
 
 static const struct of_dev_auxdata mmp2_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
@@ -50,7 +49,7 @@ static const char *mmp2_dt_board_compat[] __initdata = {
 DT_MACHINE_START(MMP2_DT, "Marvell MMP2 (Device Tree Support)")
 	.map_io		= mmp_map_io,
 	.init_irq	= mmp_dt_irq_init,
-	.init_time	= mmp_dt_init_timer,
+	.init_time	= clocksource_of_init,
 	.init_machine	= mmp2_dt_init,
 	.dt_compat	= mmp2_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 67e7d5c..8f5d612 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -207,22 +207,10 @@ void __init timer_init(int irq)
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id mmp_timer_dt_ids[] = {
-	{ .compatible = "marvell,mmp-timer", },
-	{}
-};
-
-void __init mmp_dt_init_timer(void)
+static void __init mmp_of_init_timer(struct device_node *np)
 {
-	struct device_node *np;
 	int irq, ret;
 
-	np = of_find_matching_node(NULL, mmp_timer_dt_ids);
-	if (!np) {
-		ret = -ENODEV;
-		goto out;
-	}
-
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq) {
 		ret = -EINVAL;
@@ -238,4 +226,5 @@ void __init mmp_dt_init_timer(void)
 out:
 	pr_err("Failed to get timer from device tree with error:%d\n", ret);
 }
+CLOCKSOURCE_OF_DECLARE(mmp_timer, "marvell,mmp-timer", mmp_of_init_timer);
 #endif
-- 
1.7.4.1

