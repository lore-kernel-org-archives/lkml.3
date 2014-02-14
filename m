Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaBNBAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:09 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaBNA7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:13 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 16/27] ARM: shmobile: sh7372: Switch to new style CMT device
Date: Fri, 14 Feb 2014 01:59:54 +0100
Message-Id: <1392339605-20691-17-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
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
 arch/arm/mach-shmobile/clock-sh7372.c |  6 +++---
 arch/arm/mach-shmobile/setup-sh7372.c | 30 ++++++++++++++----------------
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-sh7372.c b/arch/arm/mach-shmobile/clock-sh7372.c
index 2848997..5557b3d 100644
--- a/arch/arm/mach-shmobile/clock-sh7372.c
+++ b/arch/arm/mach-shmobile/clock-sh7372.c
@@ -565,10 +565,10 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("r8a66597_hcd.1", &mstp_clks[MSTP406]), /* USB1 */
 	CLKDEV_DEV_ID("r8a66597_udc.1", &mstp_clks[MSTP406]), /* USB1 */
 	CLKDEV_DEV_ID("renesas_usbhs.1", &mstp_clks[MSTP406]), /* USB1 */
-	CLKDEV_DEV_ID("sh_cmt.4", &mstp_clks[MSTP405]), /* CMT4 */
-	CLKDEV_DEV_ID("sh_cmt.3", &mstp_clks[MSTP404]), /* CMT3 */
+	CLKDEV_DEV_ID("sh-cmt-32-fast.4", &mstp_clks[MSTP405]), /* CMT4 */
+	CLKDEV_DEV_ID("sh-cmt-32-fast.3", &mstp_clks[MSTP404]), /* CMT3 */
 	CLKDEV_DEV_ID("sh_keysc.0", &mstp_clks[MSTP403]), /* KEYSC */
-	CLKDEV_DEV_ID("sh_cmt.2", &mstp_clks[MSTP400]), /* CMT2 */
+	CLKDEV_DEV_ID("sh-cmt-32-fast.2", &mstp_clks[MSTP400]), /* CMT2 */
 
 	/* ICK */
 	CLKDEV_ICK_ID("dsit_clk", "sh-mipi-dsi.0", &div6_clks[DIV6_DSIT]),
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 2730127..3e524d5 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -118,29 +118,27 @@ SH7372_SCIF(PORT_SCIFA, 5, 0xe6cb0000, evt2irq(0x0d40));
 SH7372_SCIF(PORT_SCIFB, 6, 0xe6c30000, evt2irq(0x0d60));
 
 /* CMT */
+static struct sh_timer_channel_config cmt2_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+		.clocksource_rating = 125,
+	},
+};
+
 static struct sh_timer_config cmt2_platform_data = {
-	.name = "CMT2",
-	.channel_offset = 0x40,
-	.timer_bit = 5,
-	.clockevent_rating = 125,
-	.clocksource_rating = 125,
+	.channels = cmt2_channels,
+	.num_channels = ARRAY_SIZE(cmt2_channels),
+	.channels_mask = 0x1f,
 };
 
 static struct resource cmt2_resources[] = {
-	[0] = {
-		.name	= "CMT2",
-		.start	= 0xe6130040,
-		.end	= 0xe613004b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0x0b80), /* CMT2 */
-		.flags	= IORESOURCE_IRQ,
-	},
+	DEFINE_RES_MEM(0xe6130000, 0x50),
+	DEFINE_RES_IRQ(evt2irq(0x0b80)),
 };
 
 static struct platform_device cmt2_device = {
-	.name		= "sh_cmt",
+	.name		= "sh-cmt-32-fast",
 	.id		= 2,
 	.dev = {
 		.platform_data	= &cmt2_platform_data,
-- 
1.8.3.2

