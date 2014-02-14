Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaBNBAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:30 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaBNA7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:19 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 27/27] ARM: shmobile: koelsch-reference: Enable CMT0 in device tree
Date: Fri, 14 Feb 2014 02:00:05 +0100
Message-Id: <1392339605-20691-28-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
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
 arch/arm/boot/dts/r8a7791-koelsch.dts            |  9 +++++++++
 arch/arm/mach-shmobile/board-koelsch-reference.c | 15 +--------------
 arch/arm/mach-shmobile/include/mach/r8a7791.h    |  1 -
 arch/arm/mach-shmobile/setup-r8a7791.c           |  7 +------
 4 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 42fd5eb..36e1c33 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -130,6 +130,15 @@
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
 &sata0 {
 	status = "okay";
 };
diff --git a/arch/arm/mach-shmobile/board-koelsch-reference.c b/arch/arm/mach-shmobile/board-koelsch-reference.c
index e67a4be7..abcb8da 100644
--- a/arch/arm/mach-shmobile/board-koelsch-reference.c
+++ b/arch/arm/mach-shmobile/board-koelsch-reference.c
@@ -30,22 +30,9 @@
 
 static void __init koelsch_add_standard_devices(void)
 {
-#ifdef CONFIG_COMMON_CLK
-	/*
-	 * This is a really crude hack to provide clkdev support to the CMT
-	 * device until they get moved to DT.
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
 	r8a7791_clock_init();
 #endif
-	r8a7791_add_dt_devices();
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
diff --git a/arch/arm/mach-shmobile/include/mach/r8a7791.h b/arch/arm/mach-shmobile/include/mach/r8a7791.h
index 200fa69..57a37f1 100644
--- a/arch/arm/mach-shmobile/include/mach/r8a7791.h
+++ b/arch/arm/mach-shmobile/include/mach/r8a7791.h
@@ -2,7 +2,6 @@
 #define __ASM_R8A7791_H__
 
 void r8a7791_add_standard_devices(void);
-void r8a7791_add_dt_devices(void);
 void r8a7791_clock_init(void);
 void r8a7791_pinmux_init(void);
 void r8a7791_init_early(void);
diff --git a/arch/arm/mach-shmobile/setup-r8a7791.c b/arch/arm/mach-shmobile/setup-r8a7791.c
index a17ebb8..c1e9c0f 100644
--- a/arch/arm/mach-shmobile/setup-r8a7791.c
+++ b/arch/arm/mach-shmobile/setup-r8a7791.c
@@ -189,11 +189,6 @@ static const struct resource thermal_resources[] __initconst = {
 					thermal_resources,		\
 					ARRAY_SIZE(thermal_resources))
 
-void __init r8a7791_add_dt_devices(void)
-{
-	r8a7791_register_cmt(0);
-}
-
 void __init r8a7791_add_standard_devices(void)
 {
 	r8a7791_register_scif(0);
@@ -211,7 +206,7 @@ void __init r8a7791_add_standard_devices(void)
 	r8a7791_register_scif(12);
 	r8a7791_register_scif(13);
 	r8a7791_register_scif(14);
-	r8a7791_add_dt_devices();
+	r8a7791_register_cmt(0);
 	r8a7791_register_irqc(0);
 	r8a7791_register_thermal();
 }
-- 
1.8.3.2

