Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaBNBAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:25 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaBNA7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:18 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 26/27] ARM: shmobile: lager-reference: Enable CMT0 in device tree
Date: Fri, 14 Feb 2014 02:00:04 +0100
Message-Id: <1392339605-20691-27-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the CMT0 device and configure channel 0 as a clock event
provider.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/boot/dts/r8a7790-lager.dts            |  9 +++++++++
 arch/arm/mach-shmobile/board-lager-reference.c | 15 +--------------
 arch/arm/mach-shmobile/include/mach/r8a7790.h  |  1 -
 arch/arm/mach-shmobile/setup-r8a7790.c         |  7 +------
 4 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 4199ae4..54ab17d 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -84,6 +84,15 @@
 	};
 };
 
+&cmt0 {
+	status = "ok";
+
+	channel@0 {
+		reg = <0>;
+		clock-event-rating = <80>;
+	};
+};
+
 &mmcif1 {
 	pinctrl-0 = <&mmc1_pins>;
 	pinctrl-names = "default";
diff --git a/arch/arm/mach-shmobile/board-lager-reference.c b/arch/arm/mach-shmobile/board-lager-reference.c
index 4dd43b1..ee95a8c 100644
--- a/arch/arm/mach-shmobile/board-lager-reference.c
+++ b/arch/arm/mach-shmobile/board-lager-reference.c
@@ -29,23 +29,10 @@
 
 static void __init lager_add_standard_devices(void)
 {
-#ifdef CONFIG_COMMON_CLK
-	/*
-	 * This is a really crude hack to provide clkdev support to the CMT
-	 * device until it gets moved to DT.
-	 */
-	struct clk *clk;
-
-	clk = clk_get(NULL, "cmt0");
-	if (!IS_ERR(clk)) {
-		clk_register_clkdev(clk, NULL, "sh-cmt-48-gen2.0");
-		clk_put(clk);
-	}
-#else
+#ifndef CONFIG_COMMON_CLK
 	r8a7790_clock_init();
 #endif
 
-	r8a7790_add_dt_devices();
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
diff --git a/arch/arm/mach-shmobile/include/mach/r8a7790.h b/arch/arm/mach-shmobile/include/mach/r8a7790.h
index 0b95bab..62b31f3 100644
--- a/arch/arm/mach-shmobile/include/mach/r8a7790.h
+++ b/arch/arm/mach-shmobile/include/mach/r8a7790.h
@@ -29,7 +29,6 @@ enum {
 };
 
 void r8a7790_add_standard_devices(void);
-void r8a7790_add_dt_devices(void);
 void r8a7790_clock_init(void);
 void r8a7790_pinmux_init(void);
 void r8a7790_pm_init(void);
diff --git a/arch/arm/mach-shmobile/setup-r8a7790.c b/arch/arm/mach-shmobile/setup-r8a7790.c
index 3e5813f..462c81f 100644
--- a/arch/arm/mach-shmobile/setup-r8a7790.c
+++ b/arch/arm/mach-shmobile/setup-r8a7790.c
@@ -294,11 +294,6 @@ static struct resource cmt0_resources[] = {
 					  &cmt##idx##_platform_data,	\
 					  sizeof(struct sh_timer_config))
 
-void __init r8a7790_add_dt_devices(void)
-{
-	r8a7790_register_cmt(0);
-}
-
 void __init r8a7790_add_standard_devices(void)
 {
 	r8a7790_register_scif(0);
@@ -311,7 +306,7 @@ void __init r8a7790_add_standard_devices(void)
 	r8a7790_register_scif(7);
 	r8a7790_register_scif(8);
 	r8a7790_register_scif(9);
-	r8a7790_add_dt_devices();
+	r8a7790_register_cmt(0);
 	r8a7790_register_irqc(0);
 	r8a7790_register_thermal();
 }
-- 
1.8.3.2

