Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaBNBAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:18 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaBNA7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:15 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 19/27] ARM: shmobile: r8a7740: Switch to new style CMT device
Date: Fri, 14 Feb 2014 01:59:57 +0100
Message-Id: <1392339605-20691-20-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
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
 arch/arm/mach-shmobile/clock-r8a7740.c |  2 +-
 arch/arm/mach-shmobile/setup-r8a7740.c | 45 ++++++++++++++++------------------
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index dd989f9..50d3073 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -583,7 +583,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-sci.6",		&mstp_clks[MSTP230]),
 	CLKDEV_DEV_ID("e6cc0000.sci",		&mstp_clks[MSTP230]),
 
-	CLKDEV_DEV_ID("sh_cmt.10",		&mstp_clks[MSTP329]),
+	CLKDEV_DEV_ID("sh-cmt-48.1",		&mstp_clks[MSTP329]),
 	CLKDEV_DEV_ID("sh_fsi2",		&mstp_clks[MSTP328]),
 	CLKDEV_DEV_ID("fe1f0000.sound",		&mstp_clks[MSTP328]),
 	CLKDEV_DEV_ID("i2c-sh_mobile.1",	&mstp_clks[MSTP323]),
diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index 8f3c681..f88856e 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -237,35 +237,32 @@ R8A7740_SCIF(PORT_SCIFA, 7, 0xe6cd0000, gic_spi(107));
 R8A7740_SCIF(PORT_SCIFB, 8, 0xe6c30000, gic_spi(108));
 
 /* CMT */
-static struct sh_timer_config cmt10_platform_data = {
-	.name = "CMT10",
-	.channel_offset = 0x10,
-	.timer_bit = 0,
-	.clockevent_rating = 125,
-	.clocksource_rating = 125,
+static struct sh_timer_channel_config cmt1_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+		.clocksource_rating = 125,
+	},
 };
 
-static struct resource cmt10_resources[] = {
-	[0] = {
-		.name	= "CMT10",
-		.start	= 0xe6138010,
-		.end	= 0xe613801b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= gic_spi(58),
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct sh_timer_config cmt1_platform_data = {
+	.channels = cmt1_channels,
+	.num_channels = ARRAY_SIZE(cmt1_channels),
 };
 
-static struct platform_device cmt10_device = {
-	.name		= "sh_cmt",
-	.id		= 10,
+static struct resource cmt1_resources[] = {
+	DEFINE_RES_MEM(0xe6138000, 0x170),
+	DEFINE_RES_IRQ(gic_spi(58)),
+};
+
+static struct platform_device cmt1_device = {
+	.name		= "sh-cmt-48",
+	.id		= 1,
 	.dev = {
-		.platform_data	= &cmt10_platform_data,
+		.platform_data	= &cmt1_platform_data,
 	},
-	.resource	= cmt10_resources,
-	.num_resources	= ARRAY_SIZE(cmt10_resources),
+	.resource	= cmt1_resources,
+	.num_resources	= ARRAY_SIZE(cmt1_resources),
 };
 
 /* TMU */
@@ -400,7 +397,7 @@ static struct platform_device *r8a7740_devices_dt[] __initdata = {
 	&scif6_device,
 	&scif7_device,
 	&scif8_device,
-	&cmt10_device,
+	&cmt1_device,
 };
 
 static struct platform_device *r8a7740_early_devices[] __initdata = {
-- 
1.8.3.2

