Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaBNBAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:12 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaBNA7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:16 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 20/27] ARM: shmobile: r8a7790: Switch to new style CMT device
Date: Fri, 14 Feb 2014 01:59:58 +0100
Message-Id: <1392339605-20691-21-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CMT (Compare Match Timer) driver implements a new style of platform
data that handles the timer as a single device with multiple channel.
Switch from the old-style platform data to the new-style platform data.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/mach-shmobile/board-lager-reference.c |  2 +-
 arch/arm/mach-shmobile/clock-r8a7790.c         |  2 +-
 arch/arm/mach-shmobile/setup-r8a7790.c         | 26 ++++++++++++++++----------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-lager-reference.c b/arch/arm/mach-shmobile/board-lager-reference.c
index 35fc0f2..4dd43b1 100644
--- a/arch/arm/mach-shmobile/board-lager-reference.c
+++ b/arch/arm/mach-shmobile/board-lager-reference.c
@@ -38,7 +38,7 @@ static void __init lager_add_standard_devices(void)
 
 	clk = clk_get(NULL, "cmt0");
 	if (!IS_ERR(clk)) {
-		clk_register_clkdev(clk, NULL, "sh_cmt.0");
+		clk_register_clkdev(clk, NULL, "sh-cmt-48-gen2.0");
 		clk_put(clk);
 	}
 #else
diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
index 4b276ef..780466e 100644
--- a/arch/arm/mach-shmobile/clock-r8a7790.c
+++ b/arch/arm/mach-shmobile/clock-r8a7790.c
@@ -357,7 +357,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh_mobile_sdhi.3", &mstp_clks[MSTP311]),
 	CLKDEV_DEV_ID("ee220000.mmc", &mstp_clks[MSTP305]),
 	CLKDEV_DEV_ID("sh_mmcif.1", &mstp_clks[MSTP305]),
-	CLKDEV_DEV_ID("sh_cmt.0", &mstp_clks[MSTP124]),
+	CLKDEV_DEV_ID("sh-cmt-48-gen2.0", &mstp_clks[MSTP124]),
 	CLKDEV_DEV_ID("qspi.0", &mstp_clks[MSTP917]),
 	CLKDEV_DEV_ID("renesas_usbhs", &mstp_clks[MSTP704]),
 	CLKDEV_DEV_ID("pci-rcar-gen2.0", &mstp_clks[MSTP703]),
diff --git a/arch/arm/mach-shmobile/setup-r8a7790.c b/arch/arm/mach-shmobile/setup-r8a7790.c
index b237268..3e5813f 100644
--- a/arch/arm/mach-shmobile/setup-r8a7790.c
+++ b/arch/arm/mach-shmobile/setup-r8a7790.c
@@ -269,20 +269,26 @@ static const struct resource thermal_resources[] __initconst = {
 					thermal_resources,		\
 					ARRAY_SIZE(thermal_resources))
 
-static const struct sh_timer_config cmt00_platform_data __initconst = {
-	.name = "CMT00",
-	.timer_bit = 0,
-	.clockevent_rating = 80,
+static struct sh_timer_channel_config cmt0_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 80,
+	},
 };
 
-static const struct resource cmt00_resources[] __initconst = {
-	DEFINE_RES_MEM(0xffca0510, 0x0c),
-	DEFINE_RES_MEM(0xffca0500, 0x04),
-	DEFINE_RES_IRQ(gic_spi(142)), /* CMT0_0 */
+static struct sh_timer_config cmt0_platform_data = {
+	.channels = cmt0_channels,
+	.num_channels = ARRAY_SIZE(cmt0_channels),
+	.channels_mask = 0x1f,
+};
+
+static struct resource cmt0_resources[] = {
+	DEFINE_RES_MEM(0xffca0000, 0x1004),
+	DEFINE_RES_IRQ(gic_spi(142)),
 };
 
 #define r8a7790_register_cmt(idx)					\
-	platform_device_register_resndata(&platform_bus, "sh_cmt",	\
+	platform_device_register_resndata(&platform_bus, "sh-cmt-48-gen2", \
 					  idx, cmt##idx##_resources,	\
 					  ARRAY_SIZE(cmt##idx##_resources), \
 					  &cmt##idx##_platform_data,	\
@@ -290,7 +296,7 @@ static const struct resource cmt00_resources[] __initconst = {
 
 void __init r8a7790_add_dt_devices(void)
 {
-	r8a7790_register_cmt(00);
+	r8a7790_register_cmt(0);
 }
 
 void __init r8a7790_add_standard_devices(void)
-- 
1.8.3.2

