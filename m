Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaBNBAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:13 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaBNA7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:13 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 15/27] sh: Switch to new style CMT device
Date: Fri, 14 Feb 2014 01:59:53 +0100
Message-Id: <1392339605-20691-16-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
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
 arch/sh/kernel/cpu/clock-cpg.c         |   3 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c  |  73 +++++-----------
 arch/sh/kernel/cpu/sh2a/clock-sh7264.c |   2 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7269.c |   2 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c |  73 +++++-----------
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c |  73 +++++-----------
 arch/sh/kernel/cpu/sh2a/setup-sh7264.c |  76 +++++-----------
 arch/sh/kernel/cpu/sh2a/setup-sh7269.c |  73 +++++-----------
 arch/sh/kernel/cpu/sh3/setup-sh7720.c  | 155 ++++-----------------------------
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |   2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c |  28 +++---
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |  27 +++---
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |  28 +++---
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |  28 +++---
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |  28 +++---
 19 files changed, 207 insertions(+), 472 deletions(-)

diff --git a/arch/sh/kernel/cpu/clock-cpg.c b/arch/sh/kernel/cpu/clock-cpg.c
index f59b1f3..3f425f5 100644
--- a/arch/sh/kernel/cpu/clock-cpg.c
+++ b/arch/sh/kernel/cpu/clock-cpg.c
@@ -58,7 +58,8 @@ int __init __deprecated cpg_clk_init(void)
 
 	clk_add_alias("tmu_fck", NULL, "peripheral_clk", NULL);
 	clk_add_alias("mtu2_fck", NULL, "peripheral_clk", NULL);
-	clk_add_alias("cmt_fck", NULL, "peripheral_clk", NULL);
+	clk_add_alias(NULL, "sh-cmt-16.0", "peripheral_clk", NULL);
+	clk_add_alias(NULL, "sh-cmt-32.0", "peripheral_clk", NULL);
 	clk_add_alias("sci_ick", NULL, "peripheral_clk", NULL);
 
 	return ret;
diff --git a/arch/sh/kernel/cpu/sh2/setup-sh7619.c b/arch/sh/kernel/cpu/sh2/setup-sh7619.c
index 3860b0b..73bdf66 100644
--- a/arch/sh/kernel/cpu/sh2/setup-sh7619.c
+++ b/arch/sh/kernel/cpu/sh2/setup-sh7619.c
@@ -152,62 +152,35 @@ static struct platform_device eth_device = {
 	.resource = eth_resources,
 };
 
-static struct sh_timer_config cmt0_platform_data = {
-	.channel_offset = 0x02,
-	.timer_bit = 0,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
-};
-
-static struct resource cmt0_resources[] = {
-	[0] = {
-		.start	= 0xf84a0072,
-		.end	= 0xf84a0077,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 86,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt0_device = {
-	.name		= "sh_cmt",
-	.id		= 0,
-	.dev = {
-		.platform_data	= &cmt0_platform_data,
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+	}, {
+		.index = 1,
+		.clockevent_rating = 125,
 	},
-	.resource	= cmt0_resources,
-	.num_resources	= ARRAY_SIZE(cmt0_resources),
 };
 
-static struct sh_timer_config cmt1_platform_data = {
-	.channel_offset = 0x08,
-	.timer_bit = 1,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
+static struct sh_timer_config cmt_platform_data = {
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
 };
 
-static struct resource cmt1_resources[] = {
-	[0] = {
-		.start	= 0xf84a0078,
-		.end	= 0xf84a007d,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 87,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct resource cmt_resources[] = {
+	DEFINE_RES_MEM(0xf84a0078, 0x10),
+	DEFINE_RES_IRQ(86),
+	DEFINE_RES_IRQ(87),
 };
 
-static struct platform_device cmt1_device = {
-	.name		= "sh_cmt",
-	.id		= 1,
+static struct platform_device cmt_device = {
+	.name		= "sh-cmt-16",
+	.id		= 0,
 	.dev = {
-		.platform_data	= &cmt1_platform_data,
+		.platform_data	= &cmt_platform_data,
 	},
-	.resource	= cmt1_resources,
-	.num_resources	= ARRAY_SIZE(cmt1_resources),
+	.resource	= cmt_resources,
+	.num_resources	= ARRAY_SIZE(cmt_resources),
 };
 
 static struct platform_device *sh7619_devices[] __initdata = {
@@ -215,8 +188,7 @@ static struct platform_device *sh7619_devices[] __initdata = {
 	&scif1_device,
 	&scif2_device,
 	&eth_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 };
 
 static int __init sh7619_devices_setup(void)
@@ -235,8 +207,7 @@ static struct platform_device *sh7619_early_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
 	&scif2_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 };
 
 #define STBCR3 0xf80a0000
diff --git a/arch/sh/kernel/cpu/sh2a/clock-sh7264.c b/arch/sh/kernel/cpu/sh2a/clock-sh7264.c
index fdf585c..b8dcd34 100644
--- a/arch/sh/kernel/cpu/sh2a/clock-sh7264.c
+++ b/arch/sh/kernel/cpu/sh2a/clock-sh7264.c
@@ -117,7 +117,7 @@ static struct clk_lookup lookups[] = {
 	/* MSTP clocks */
 	CLKDEV_CON_ID("sci_ick", &mstp_clks[MSTP77]),
 	CLKDEV_CON_ID("vdc3", &mstp_clks[MSTP74]),
-	CLKDEV_CON_ID("cmt_fck", &mstp_clks[MSTP72]),
+	CLKDEV_DEV_ID("sh-cmt-16.0", &mstp_clks[MSTP72]),
 	CLKDEV_CON_ID("usb0", &mstp_clks[MSTP60]),
 	CLKDEV_CON_ID("mtu2_fck", &mstp_clks[MSTP35]),
 	CLKDEV_CON_ID("sdhi0", &mstp_clks[MSTP34]),
diff --git a/arch/sh/kernel/cpu/sh2a/clock-sh7269.c b/arch/sh/kernel/cpu/sh2a/clock-sh7269.c
index 6b78762..f7346b4 100644
--- a/arch/sh/kernel/cpu/sh2a/clock-sh7269.c
+++ b/arch/sh/kernel/cpu/sh2a/clock-sh7269.c
@@ -158,7 +158,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_ICK_ID("sci_fck", "sh-sci.5", &mstp_clks[MSTP42]),
 	CLKDEV_ICK_ID("sci_fck", "sh-sci.6", &mstp_clks[MSTP41]),
 	CLKDEV_ICK_ID("sci_fck", "sh-sci.7", &mstp_clks[MSTP40]),
-	CLKDEV_CON_ID("cmt_fck", &mstp_clks[MSTP72]),
+	CLKDEV_DEV_ID("sh-cmt-16.0", &mstp_clks[MSTP72]),
 	CLKDEV_CON_ID("usb0", &mstp_clks[MSTP60]),
 	CLKDEV_CON_ID("mtu2_fck", &mstp_clks[MSTP35]),
 	CLKDEV_CON_ID("adc0", &mstp_clks[MSTP32]),
diff --git a/arch/sh/kernel/cpu/sh2a/setup-sh7203.c b/arch/sh/kernel/cpu/sh2a/setup-sh7203.c
index d55a0f3..ef9d37a 100644
--- a/arch/sh/kernel/cpu/sh2a/setup-sh7203.c
+++ b/arch/sh/kernel/cpu/sh2a/setup-sh7203.c
@@ -265,62 +265,35 @@ static struct platform_device scif3_device = {
 	},
 };
 
-static struct sh_timer_config cmt0_platform_data = {
-	.channel_offset = 0x02,
-	.timer_bit = 0,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
-};
-
-static struct resource cmt0_resources[] = {
-	[0] = {
-		.start	= 0xfffec002,
-		.end	= 0xfffec007,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 142,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt0_device = {
-	.name		= "sh_cmt",
-	.id		= 0,
-	.dev = {
-		.platform_data	= &cmt0_platform_data,
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+	}, {
+		.index = 1,
+		.clockevent_rating = 125,
 	},
-	.resource	= cmt0_resources,
-	.num_resources	= ARRAY_SIZE(cmt0_resources),
 };
 
-static struct sh_timer_config cmt1_platform_data = {
-	.channel_offset = 0x08,
-	.timer_bit = 1,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
+static struct sh_timer_config cmt_platform_data = {
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
 };
 
-static struct resource cmt1_resources[] = {
-	[0] = {
-		.start	= 0xfffec008,
-		.end	= 0xfffec00d,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 143,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct resource cmt_resources[] = {
+	DEFINE_RES_MEM(0xfffec000, 0x10),
+	DEFINE_RES_IRQ(142),
+	DEFINE_RES_IRQ(143),
 };
 
-static struct platform_device cmt1_device = {
-	.name		= "sh_cmt",
-	.id		= 1,
+static struct platform_device cmt_device = {
+	.name		= "sh-cmt-16",
+	.id		= 0,
 	.dev = {
-		.platform_data	= &cmt1_platform_data,
+		.platform_data	= &cmt_platform_data,
 	},
-	.resource	= cmt1_resources,
-	.num_resources	= ARRAY_SIZE(cmt1_resources),
+	.resource	= cmt_resources,
+	.num_resources	= ARRAY_SIZE(cmt_resources),
 };
 
 static struct sh_timer_config mtu2_0_platform_data = {
@@ -404,8 +377,7 @@ static struct platform_device *sh7203_devices[] __initdata = {
 	&scif1_device,
 	&scif2_device,
 	&scif3_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 	&rtc_device,
@@ -428,8 +400,7 @@ static struct platform_device *sh7203_early_devices[] __initdata = {
 	&scif1_device,
 	&scif2_device,
 	&scif3_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 };
diff --git a/arch/sh/kernel/cpu/sh2a/setup-sh7206.c b/arch/sh/kernel/cpu/sh2a/setup-sh7206.c
index 241e745..f8c93a4 100644
--- a/arch/sh/kernel/cpu/sh2a/setup-sh7206.c
+++ b/arch/sh/kernel/cpu/sh2a/setup-sh7206.c
@@ -217,62 +217,35 @@ static struct platform_device scif3_device = {
 	},
 };
 
-static struct sh_timer_config cmt0_platform_data = {
-	.channel_offset = 0x02,
-	.timer_bit = 0,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
-};
-
-static struct resource cmt0_resources[] = {
-	[0] = {
-		.start	= 0xfffec002,
-		.end	= 0xfffec007,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 140,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt0_device = {
-	.name		= "sh_cmt",
-	.id		= 0,
-	.dev = {
-		.platform_data	= &cmt0_platform_data,
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+	}, {
+		.index = 1,
+		.clockevent_rating = 125,
 	},
-	.resource	= cmt0_resources,
-	.num_resources	= ARRAY_SIZE(cmt0_resources),
 };
 
-static struct sh_timer_config cmt1_platform_data = {
-	.channel_offset = 0x08,
-	.timer_bit = 1,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
+static struct sh_timer_config cmt_platform_data = {
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
 };
 
-static struct resource cmt1_resources[] = {
-	[0] = {
-		.start	= 0xfffec008,
-		.end	= 0xfffec00d,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 144,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct resource cmt_resources[] = {
+	DEFINE_RES_MEM(0xfffec000, 0x10),
+	DEFINE_RES_IRQ(140),
+	DEFINE_RES_IRQ(144),
 };
 
-static struct platform_device cmt1_device = {
-	.name		= "sh_cmt",
-	.id		= 1,
+static struct platform_device cmt_device = {
+	.name		= "sh-cmt-16",
+	.id		= 0,
 	.dev = {
-		.platform_data	= &cmt1_platform_data,
+		.platform_data	= &cmt_platform_data,
 	},
-	.resource	= cmt1_resources,
-	.num_resources	= ARRAY_SIZE(cmt1_resources),
+	.resource	= cmt_resources,
+	.num_resources	= ARRAY_SIZE(cmt_resources),
 };
 
 static struct sh_timer_config mtu2_0_platform_data = {
@@ -364,8 +337,7 @@ static struct platform_device *sh7206_devices[] __initdata = {
 	&scif1_device,
 	&scif2_device,
 	&scif3_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 	&mtu2_2_device,
@@ -388,8 +360,7 @@ static struct platform_device *sh7206_early_devices[] __initdata = {
 	&scif1_device,
 	&scif2_device,
 	&scif3_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 	&mtu2_2_device,
diff --git a/arch/sh/kernel/cpu/sh2a/setup-sh7264.c b/arch/sh/kernel/cpu/sh2a/setup-sh7264.c
index ad5b0f4..838d05f 100644
--- a/arch/sh/kernel/cpu/sh2a/setup-sh7264.c
+++ b/arch/sh/kernel/cpu/sh2a/setup-sh7264.c
@@ -433,65 +433,35 @@ static struct platform_device scif7_device = {
 	},
 };
 
-static struct sh_timer_config cmt0_platform_data = {
-	.channel_offset = 0x02,
-	.timer_bit = 0,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
-};
-
-static struct resource cmt0_resources[] = {
-	[0] = {
-		.name	= "CMT0",
-		.start	= 0xfffec002,
-		.end	= 0xfffec007,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 175,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt0_device = {
-	.name		= "sh_cmt",
-	.id		= 0,
-	.dev = {
-		.platform_data	= &cmt0_platform_data,
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+	}, {
+		.index = 1,
+		.clockevent_rating = 125,
 	},
-	.resource	= cmt0_resources,
-	.num_resources	= ARRAY_SIZE(cmt0_resources),
 };
 
-static struct sh_timer_config cmt1_platform_data = {
-	.name = "CMT1",
-	.channel_offset = 0x08,
-	.timer_bit = 1,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
+static struct sh_timer_config cmt_platform_data = {
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
 };
 
-static struct resource cmt1_resources[] = {
-	[0] = {
-		.name	= "CMT1",
-		.start	= 0xfffec008,
-		.end	= 0xfffec00d,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 176,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct resource cmt_resources[] = {
+	DEFINE_RES_MEM(0xfffec000, 0x10),
+	DEFINE_RES_IRQ(175),
+	DEFINE_RES_IRQ(176),
 };
 
-static struct platform_device cmt1_device = {
-	.name		= "sh_cmt",
-	.id		= 1,
+static struct platform_device cmt_device = {
+	.name		= "sh-cmt-16",
+	.id		= 0,
 	.dev = {
-		.platform_data	= &cmt1_platform_data,
+		.platform_data	= &cmt_platform_data,
 	},
-	.resource	= cmt1_resources,
-	.num_resources	= ARRAY_SIZE(cmt1_resources),
+	.resource	= cmt_resources,
+	.num_resources	= ARRAY_SIZE(cmt_resources),
 };
 
 static struct sh_timer_config mtu2_0_platform_data = {
@@ -620,8 +590,7 @@ static struct platform_device *sh7264_devices[] __initdata = {
 	&scif5_device,
 	&scif6_device,
 	&scif7_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 	&rtc_device,
@@ -649,8 +618,7 @@ static struct platform_device *sh7264_early_devices[] __initdata = {
 	&scif5_device,
 	&scif6_device,
 	&scif7_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 };
diff --git a/arch/sh/kernel/cpu/sh2a/setup-sh7269.c b/arch/sh/kernel/cpu/sh2a/setup-sh7269.c
index 3995119..3e66297 100644
--- a/arch/sh/kernel/cpu/sh2a/setup-sh7269.c
+++ b/arch/sh/kernel/cpu/sh2a/setup-sh7269.c
@@ -455,62 +455,35 @@ static struct platform_device scif7_device = {
 	},
 };
 
-static struct sh_timer_config cmt0_platform_data = {
-	.channel_offset = 0x02,
-	.timer_bit = 0,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
-};
-
-static struct resource cmt0_resources[] = {
-	[0] = {
-		.start	= 0xfffec002,
-		.end	= 0xfffec007,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 188,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt0_device = {
-	.name		= "sh_cmt",
-	.id		= 0,
-	.dev = {
-		.platform_data	= &cmt0_platform_data,
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+	}, {
+		.index = 1,
+		.clockevent_rating = 125,
 	},
-	.resource	= cmt0_resources,
-	.num_resources	= ARRAY_SIZE(cmt0_resources),
 };
 
-static struct sh_timer_config cmt1_platform_data = {
-	.channel_offset = 0x08,
-	.timer_bit = 1,
-	.clockevent_rating = 125,
-	.clocksource_rating = 0, /* disabled due to code generation issues */
+static struct sh_timer_config cmt_platform_data = {
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
 };
 
-static struct resource cmt1_resources[] = {
-	[0] = {
-		.start	= 0xfffec008,
-		.end	= 0xfffec00d,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 189,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct resource cmt_resources[] = {
+	DEFINE_RES_MEM(0xfffec000, 0x10),
+	DEFINE_RES_IRQ(188),
+	DEFINE_RES_IRQ(189),
 };
 
-static struct platform_device cmt1_device = {
-	.name		= "sh_cmt",
-	.id		= 1,
+static struct platform_device cmt_device = {
+	.name		= "sh-cmt-16",
+	.id		= 0,
 	.dev = {
-		.platform_data	= &cmt1_platform_data,
+		.platform_data	= &cmt_platform_data,
 	},
-	.resource	= cmt1_resources,
-	.num_resources	= ARRAY_SIZE(cmt1_resources),
+	.resource	= cmt_resources,
+	.num_resources	= ARRAY_SIZE(cmt_resources),
 };
 
 static struct sh_timer_config mtu2_0_platform_data = {
@@ -629,8 +602,7 @@ static struct platform_device *sh7269_devices[] __initdata = {
 	&scif5_device,
 	&scif6_device,
 	&scif7_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 	&rtc_device,
@@ -658,8 +630,7 @@ static struct platform_device *sh7269_early_devices[] __initdata = {
 	&scif5_device,
 	&scif6_device,
 	&scif7_device,
-	&cmt0_device,
-	&cmt1_device,
+	&cmt_device,
 	&mtu2_0_device,
 	&mtu2_1_device,
 };
diff --git a/arch/sh/kernel/cpu/sh3/setup-sh7720.c b/arch/sh/kernel/cpu/sh3/setup-sh7720.c
index 1d5729d..3cafd93 100644
--- a/arch/sh/kernel/cpu/sh3/setup-sh7720.c
+++ b/arch/sh/kernel/cpu/sh3/setup-sh7720.c
@@ -152,141 +152,32 @@ static struct platform_device usbf_device = {
 	.resource	= usbf_resources,
 };
 
-static struct sh_timer_config cmt0_platform_data = {
-	.channel_offset = 0x10,
-	.timer_bit = 0,
-	.clockevent_rating = 125,
-	.clocksource_rating = 125,
-};
-
-static struct resource cmt0_resources[] = {
-	[0] = {
-		.start	= 0x044a0010,
-		.end	= 0x044a001b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt0_device = {
-	.name		= "sh_cmt",
-	.id		= 0,
-	.dev = {
-		.platform_data	= &cmt0_platform_data,
-	},
-	.resource	= cmt0_resources,
-	.num_resources	= ARRAY_SIZE(cmt0_resources),
-};
-
-static struct sh_timer_config cmt1_platform_data = {
-	.channel_offset = 0x20,
-	.timer_bit = 1,
-};
-
-static struct resource cmt1_resources[] = {
-	[0] = {
-		.start	= 0x044a0020,
-		.end	= 0x044a002b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt1_device = {
-	.name		= "sh_cmt",
-	.id		= 1,
-	.dev = {
-		.platform_data	= &cmt1_platform_data,
-	},
-	.resource	= cmt1_resources,
-	.num_resources	= ARRAY_SIZE(cmt1_resources),
-};
-
-static struct sh_timer_config cmt2_platform_data = {
-	.channel_offset = 0x30,
-	.timer_bit = 2,
-};
-
-static struct resource cmt2_resources[] = {
-	[0] = {
-		.start	= 0x044a0030,
-		.end	= 0x044a003b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+		.clocksource_rating = 125,
 	},
 };
 
-static struct platform_device cmt2_device = {
-	.name		= "sh_cmt",
-	.id		= 2,
-	.dev = {
-		.platform_data	= &cmt2_platform_data,
-	},
-	.resource	= cmt2_resources,
-	.num_resources	= ARRAY_SIZE(cmt2_resources),
+static struct sh_timer_config cmt_platform_data = {
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
 };
 
-static struct sh_timer_config cmt3_platform_data = {
-	.channel_offset = 0x40,
-	.timer_bit = 3,
+static struct resource cmt_resources[] = {
+	DEFINE_RES_MEM(0x044a0000, 0x60),
+	DEFINE_RES_IRQ(evt2irq(0xf00)),
 };
 
-static struct resource cmt3_resources[] = {
-	[0] = {
-		.start	= 0x044a0040,
-		.end	= 0x044a004b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt3_device = {
-	.name		= "sh_cmt",
-	.id		= 3,
-	.dev = {
-		.platform_data	= &cmt3_platform_data,
-	},
-	.resource	= cmt3_resources,
-	.num_resources	= ARRAY_SIZE(cmt3_resources),
-};
-
-static struct sh_timer_config cmt4_platform_data = {
-	.channel_offset = 0x50,
-	.timer_bit = 4,
-};
-
-static struct resource cmt4_resources[] = {
-	[0] = {
-		.start	= 0x044a0050,
-		.end	= 0x044a005b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device cmt4_device = {
-	.name		= "sh_cmt",
-	.id		= 4,
+static struct platform_device cmt_device = {
+	.name		= "sh-cmt-32",
+	.id		= 0,
 	.dev = {
-		.platform_data	= &cmt4_platform_data,
+		.platform_data	= &cmt_platform_data,
 	},
-	.resource	= cmt4_resources,
-	.num_resources	= ARRAY_SIZE(cmt4_resources),
+	.resource	= cmt_resources,
+	.num_resources	= ARRAY_SIZE(cmt_resources),
 };
 
 static struct sh_timer_config tmu0_platform_data = {
@@ -375,11 +266,7 @@ static struct platform_device tmu2_device = {
 static struct platform_device *sh7720_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
-	&cmt0_device,
-	&cmt1_device,
-	&cmt2_device,
-	&cmt3_device,
-	&cmt4_device,
+	&cmt_device,
 	&tmu0_device,
 	&tmu1_device,
 	&tmu2_device,
@@ -398,11 +285,7 @@ arch_initcall(sh7720_devices_setup);
 static struct platform_device *sh7720_early_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
-	&cmt0_device,
-	&cmt1_device,
-	&cmt2_device,
-	&cmt3_device,
-	&cmt4_device,
+	&cmt_device,
 	&tmu0_device,
 	&tmu1_device,
 	&tmu2_device,
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7343.c b/arch/sh/kernel/cpu/sh4a/clock-sh7343.c
index 53638e2..1628f82 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7343.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7343.c
@@ -227,7 +227,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("hudi0", &mstp_clks[MSTP019]),
 	CLKDEV_CON_ID("ubc0", &mstp_clks[MSTP017]),
 	CLKDEV_CON_ID("tmu_fck", &mstp_clks[MSTP015]),
-	CLKDEV_CON_ID("cmt_fck", &mstp_clks[MSTP014]),
+	CLKDEV_DEV_ID("sh-cmt-32.0k", &mstp_clks[MSTP014]),
 	CLKDEV_CON_ID("rwdt0", &mstp_clks[MSTP013]),
 	CLKDEV_CON_ID("mfi0", &mstp_clks[MSTP011]),
 	CLKDEV_CON_ID("flctl0", &mstp_clks[MSTP010]),
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7366.c b/arch/sh/kernel/cpu/sh4a/clock-sh7366.c
index 22e485d..8a9e8af 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7366.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7366.c
@@ -225,7 +225,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("hudi0", &mstp_clks[MSTP019]),
 	CLKDEV_CON_ID("ubc0", &mstp_clks[MSTP017]),
 	CLKDEV_CON_ID("tmu_fck", &mstp_clks[MSTP015]),
-	CLKDEV_CON_ID("cmt_fck", &mstp_clks[MSTP014]),
+	CLKDEV_DEV_ID("sh-cmt-32.0", &mstp_clks[MSTP014]),
 	CLKDEV_CON_ID("rwdt0", &mstp_clks[MSTP013]),
 	CLKDEV_CON_ID("mfi0", &mstp_clks[MSTP011]),
 	CLKDEV_CON_ID("flctl0", &mstp_clks[MSTP010]),
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c b/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
index c4cb740..e40bd2a 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
@@ -207,7 +207,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_ICK_ID("tmu_fck", "sh_tmu.1", &mstp_clks[HWBLK_TMU]),
 	CLKDEV_ICK_ID("tmu_fck", "sh_tmu.2", &mstp_clks[HWBLK_TMU]),
 
-	CLKDEV_CON_ID("cmt_fck", &mstp_clks[HWBLK_CMT]),
+	CLKDEV_DEV_ID("sh-cmt-32.0", &mstp_clks[HWBLK_CMT]),
 	CLKDEV_DEV_ID("sh-wdt.0", &mstp_clks[HWBLK_RWDT]),
 	CLKDEV_CON_ID("flctl0", &mstp_clks[HWBLK_FLCTL]),
 
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7723.c b/arch/sh/kernel/cpu/sh4a/clock-sh7723.c
index 37c41c7..3e0a6d8 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7723.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7723.c
@@ -236,7 +236,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("sh0", &mstp_clks[HWBLK_SHYWAY]),
 	CLKDEV_CON_ID("hudi0", &mstp_clks[HWBLK_HUDI]),
 	CLKDEV_CON_ID("ubc0", &mstp_clks[HWBLK_UBC]),
-	CLKDEV_CON_ID("cmt_fck", &mstp_clks[HWBLK_CMT]),
+	CLKDEV_DEV_ID("sh-cmt-32.0", &mstp_clks[HWBLK_CMT]),
 	CLKDEV_DEV_ID("sh-wdt.0", &mstp_clks[HWBLK_RWDT]),
 	CLKDEV_DEV_ID("sh-dma-engine.1", &mstp_clks[HWBLK_DMAC1]),
 	CLKDEV_CON_ID("flctl0", &mstp_clks[HWBLK_FLCTL]),
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
index 0128af3..e836d64 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
@@ -309,7 +309,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_ICK_ID("tmu_fck", "sh_tmu.2", &mstp_clks[HWBLK_TMU0]),
 	CLKDEV_ICK_ID("tmu_fck", "sh_tmu.3", &mstp_clks[HWBLK_TMU1]),
 
-	CLKDEV_CON_ID("cmt_fck", &mstp_clks[HWBLK_CMT]),
+	CLKDEV_DEV_ID("sh-cmt-16.0", &mstp_clks[HWBLK_CMT]),
 	CLKDEV_DEV_ID("sh-wdt.0", &mstp_clks[HWBLK_RWDT]),
 	CLKDEV_DEV_ID("sh-dma-engine.1", &mstp_clks[HWBLK_DMAC1]),
 
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7343.c b/arch/sh/kernel/cpu/sh4a/setup-sh7343.c
index 245d192..820ce40 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7343.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7343.c
@@ -227,27 +227,27 @@ static struct platform_device jpu_device = {
 	.num_resources	= ARRAY_SIZE(jpu_resources),
 };
 
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+		.clocksource_rating = 200,
+	},
+};
+
 static struct sh_timer_config cmt_platform_data = {
-	.channel_offset = 0x60,
-	.timer_bit = 5,
-	.clockevent_rating = 125,
-	.clocksource_rating = 200,
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
+	.channels_mask = 0x1f,
 };
 
 static struct resource cmt_resources[] = {
-	[0] = {
-		.start	= 0x044a0060,
-		.end	= 0x044a006b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
+	DEFINE_RES_MEM(0x044a0000, 0x70),
+	DEFINE_RES_IRQ(evt2irq(0xf00)),
 };
 
 static struct platform_device cmt_device = {
-	.name		= "sh_cmt",
+	.name		= "sh-cmt-32",
 	.id		= 0,
 	.dev = {
 		.platform_data	= &cmt_platform_data,
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c b/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
index 6f56cbd..c878686 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
@@ -175,27 +175,26 @@ static struct platform_device veu1_device = {
 	.num_resources	= ARRAY_SIZE(veu1_resources),
 };
 
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 5,
+		.clockevent_rating = 125,
+		.clocksource_rating = 200,
+	},
+};
+
 static struct sh_timer_config cmt_platform_data = {
-	.channel_offset = 0x60,
-	.timer_bit = 5,
-	.clockevent_rating = 125,
-	.clocksource_rating = 200,
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
 };
 
 static struct resource cmt_resources[] = {
-	[0] = {
-		.start	= 0x044a0060,
-		.end	= 0x044a006b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
+	DEFINE_RES_MEM(0x044a0000, 0x70),
+	DEFINE_RES_IRQ(evt2irq(0xf00)),
 };
 
 static struct platform_device cmt_device = {
-	.name		= "sh_cmt",
+	.name		= "sh-cmt-32",
 	.id		= 0,
 	.dev = {
 		.platform_data	= &cmt_platform_data,
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
index 5a94efc..1c0e14b 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -412,27 +412,27 @@ static struct platform_device jpu_device = {
 	.num_resources	= ARRAY_SIZE(jpu_resources),
 };
 
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+		.clocksource_rating = 125,
+	},
+};
+
 static struct sh_timer_config cmt_platform_data = {
-	.channel_offset = 0x60,
-	.timer_bit = 5,
-	.clockevent_rating = 125,
-	.clocksource_rating = 125,
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
+	.channels_mask = 0x1f,
 };
 
 static struct resource cmt_resources[] = {
-	[0] = {
-		.start	= 0x044a0060,
-		.end	= 0x044a006b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
+	DEFINE_RES_MEM(0x044a0000, 0x70),
+	DEFINE_RES_IRQ(evt2irq(0xf00)),
 };
 
 static struct platform_device cmt_device = {
-	.name		= "sh_cmt",
+	.name		= "sh-cmt-32",
 	.id		= 0,
 	.dev = {
 		.platform_data	= &cmt_platform_data,
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c b/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
index 3c5eb09..9c08917 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
@@ -244,27 +244,27 @@ static struct platform_device veu1_device = {
 	.num_resources	= ARRAY_SIZE(veu1_resources),
 };
 
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+		.clocksource_rating = 125,
+	},
+};
+
 static struct sh_timer_config cmt_platform_data = {
-	.channel_offset = 0x60,
-	.timer_bit = 5,
-	.clockevent_rating = 125,
-	.clocksource_rating = 125,
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
+	.channels_mask = 0x1f,
 };
 
 static struct resource cmt_resources[] = {
-	[0] = {
-		.start	= 0x044a0060,
-		.end	= 0x044a006b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
+	DEFINE_RES_MEM(0x044a0000, 0x70),
+	DEFINE_RES_IRQ(evt2irq(0xf00)),
 };
 
 static struct platform_device cmt_device = {
-	.name		= "sh_cmt",
+	.name		= "sh-cmt-32",
 	.id		= 0,
 	.dev = {
 		.platform_data	= &cmt_platform_data,
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c b/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
index 60ebbc6..be587a9 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
@@ -647,27 +647,27 @@ static struct platform_device beu1_device = {
 	.num_resources	= ARRAY_SIZE(beu1_resources),
 };
 
+static struct sh_timer_channel_config cmt_channels[] = {
+	{
+		.index = 0,
+		.clockevent_rating = 125,
+		.clocksource_rating = 200,
+	},
+};
+
 static struct sh_timer_config cmt_platform_data = {
-	.channel_offset = 0x60,
-	.timer_bit = 5,
-	.clockevent_rating = 125,
-	.clocksource_rating = 200,
+	.channels = cmt_channels,
+	.num_channels = ARRAY_SIZE(cmt_channels),
+	.channels_mask = 0x1f,
 };
 
 static struct resource cmt_resources[] = {
-	[0] = {
-		.start	= 0x044a0060,
-		.end	= 0x044a006b,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= evt2irq(0xf00),
-		.flags	= IORESOURCE_IRQ,
-	},
+	DEFINE_RES_MEM(0x044a0000, 0x70),
+	DEFINE_RES_IRQ(evt2irq(0xf00)),
 };
 
 static struct platform_device cmt_device = {
-	.name		= "sh_cmt",
+	.name		= "sh-cmt-32",
 	.id		= 0,
 	.dev = {
 		.platform_data	= &cmt_platform_data,
-- 
1.8.3.2

