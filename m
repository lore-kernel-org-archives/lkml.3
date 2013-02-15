Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935718Ab3BOKgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:36:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935700Ab3BOKgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:36:35 -0500
Date: Fri, 15 Feb 2013 11:36:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org
Subject: [RFC] ARM: shmobile: add framebuffer and backlight support to
 kzm9g-reference
In-Reply-To: <Pine.LNX.4.64.1302151101140.7446@axis700.grange>
Message-ID: <Pine.LNX.4.64.1302151127010.7446@axis700.grange>
References: <Pine.LNX.4.64.1302151101140.7446@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:87jZHzQhsp+HhLn7HEFApgP+ZisGQYKJ5xNUkNCP6Db
 Q921rJ6sjwp6qaxZdlAJKcSlYrj+700GdydRFkNb8C1iDV+UAW
 hgaB+DXyoOY99x17zT7F0mKvUCJ2AlqHSURjDofdAKpre5YVSA
 KsYFG9bMt9pE2IsYnMU/YeBwHDwU7cnP90p4y1fG40CaZGQQgP
 9ZjsQRI+Jqk2ayVoMUoez+EOv3bBO9sS1lWAx7qRXtPLYDcYng
 gw7s/0SOU6ZtPh5egJ+pE641IJszmisjblJzzFtnxpidmTFJxX
 Y0a8uvgJiBR0UJQvPwaavRm5DyBh8aiFWTT2tMXtGYR44Sid6o
 zHuSsHmYRpGP7QvrujxRQ2P7QLKu9l7NKXWAd3J+9ET7dVZkyU
 n0XSTsvu+7hHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the framebuffer and an AS3711 PMIC, used for supplying
power to the CPU, some peripherals and the backlight.

not-Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

As is clear from the not-Sob line and the RFC in the subject, this is not 
for mainline. This is just an illustration how the recently submitted 
"mfd: as3711: add OF support" patch can be used with the kzm9g board. I 
had to add the framebuffer support to kzm9g, because without it the 
backlight would just be turned on with no image on the LCD, which doesn't 
look pretty. In the future, if needed, we could first only apply the 
regulator part of the .dts, leaving the backlight disabled.

 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts   |   90 ++++++++++++++++++++++++
 arch/arm/mach-shmobile/board-kzm9g-reference.c |   73 +++++++++++++++++++-
 2 files changed, 162 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
index b93b16a..a5810fc 100644
--- a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
+++ b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
@@ -99,6 +99,12 @@
 		toshiba,mmc-wrprotect-disable;
 		toshiba,mmc-has-idle-wait;
 	};
+
+	/* A dummy LCDC DT node for now */
+	lcdc: lcdc@0xfe940000 {
+		compatible = "renesas,sh-mobile-lcdc";
+		reg = <0xfe940000 0x4000>;
+	};
 };
 
 &i2c3 {
@@ -106,6 +112,90 @@
 	pinctrl-0 = <&i2c3_pins>;
 };
 
+&i2c0 {
+	as3711@40 {
+		compatible = "ams,as3711";
+		reg = <0x40>;
+
+		regulators {
+			sd1 {
+				regulator-name = "1.315V CPU";
+				regulator-min-microvolt = <1315000>;
+				regulator-max-microvolt = <1335000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			sd2 {
+				regulator-name = "1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			sd4 {
+				regulator-name = "1.215V";
+				regulator-min-microvolt = <1215000>;
+				regulator-max-microvolt = <1235000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo2 {
+				regulator-name = "2.8V CPU";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo3 {
+				regulator-name = "3.0V CPU";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo4 {
+				regulator-name = "2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo5 {
+				regulator-name = "2.8V #2";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo7 {
+				regulator-name = "1.15V CPU";
+				regulator-min-microvolt = <1150000>;
+				regulator-max-microvolt = <1150000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo8 {
+				regulator-name = "1.15V CPU #2";
+				regulator-min-microvolt = <1150000>;
+				regulator-max-microvolt = <1150000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+		};
+
+		backlight {
+			compatible = "ams,as3711-bl";
+			su2-dev = <&lcdc>;
+			su2-max-uA = <36000>;
+			su2-feedback-curr-auto;
+			su2-fbprot-gpio4;
+			su2-auto-curr1;
+			su2-auto-curr2;
+			su2-auto-curr3;
+		};
+	};
+};
+
 &gpio {
 	sdhi0_pins: pfc_sdhi0_pins {
 		renesas,pins = "sdhi0_data4", "sdhi0_ctrl", "sdhi0_wp", "sdhi0_cd";
diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
index 1490246..9d520ca 100644
--- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
+++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
 #include <linux/smsc911x.h>
+#include <linux/videodev2.h>
 
 #include <mach/irqs.h>
 #include <mach/sh73a0.h>
@@ -39,6 +40,62 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+#include <video/sh_mobile_lcdc.h>
+
+/* LCDC */
+static struct fb_videomode kzm_lcdc_mode = {
+	.name		= "WVGA Panel",
+	.xres		= 800,
+	.yres		= 480,
+	.left_margin	= 220,
+	.right_margin	= 110,
+	.hsync_len	= 70,
+	.upper_margin	= 20,
+	.lower_margin	= 5,
+	.vsync_len	= 5,
+	.sync		= 0,
+};
+
+static struct sh_mobile_lcdc_info lcdc_info = {
+	.clock_source = LCDC_CLK_BUS,
+	.ch[0] = {
+		.chan		= LCDC_CHAN_MAINLCD,
+		.fourcc		= V4L2_PIX_FMT_RGB565,
+		.interface_type	= RGB24,
+		.lcd_modes	= &kzm_lcdc_mode,
+		.num_modes	= 1,
+		.clock_divider	= 5,
+		.flags		= 0,
+		.panel_cfg = {
+			.width	= 152,
+			.height	= 91,
+		},
+	}
+};
+
+static struct resource lcdc_resources[] = {
+	[0] = {
+		.name	= "LCDC",
+		.start	= 0xfe940000,
+		.end	= 0xfe943fff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= intcs_evt2irq(0x580),
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device lcdc_device = {
+	.name		= "sh_mobile_lcdc_fb",
+	.num_resources	= ARRAY_SIZE(lcdc_resources),
+	.resource	= lcdc_resources,
+	.dev	= {
+		.platform_data	= &lcdc_info,
+		.coherent_dma_mask = ~0,
+	},
+};
+
 /* Dummy supplies, where voltage doesn't matter */
 static struct regulator_consumer_supply dummy_supplies[] = {
 	REGULATOR_SUPPLY("vddvario", "smsc911x"),
@@ -79,6 +136,15 @@ static const struct pinctrl_map kzm_pinctrl_map[] = {
 				  "scifa4_data", "scifa4"),
 	PIN_MAP_MUX_GROUP_DEFAULT("sh-sci.4", "e6050000.pfc",
 				  "scifa4_ctrl", "scifa4"),
+	PIN_MAP_MUX_GROUP_DEFAULT("sh_mobile_lcdc_fb.0", "e6050000.pfc",
+				  "lcd_data24", "lcd"),
+	PIN_MAP_MUX_GROUP_DEFAULT("sh_mobile_lcdc_fb.0", "e6050000.pfc",
+				  "lcd_sync", "lcd"),
+};
+
+static struct platform_device *kzm_devices[] __initdata = {
+	&smsc_device,
+	&lcdc_device,
 };
 
 static void __init kzm_init(void)
@@ -88,7 +154,10 @@ static void __init kzm_init(void)
 	pinctrl_register_mappings(kzm_pinctrl_map, ARRAY_SIZE(kzm_pinctrl_map));
 
 	regulator_register_fixed(2, dummy_supplies, ARRAY_SIZE(dummy_supplies));
-	platform_device_register(&smsc_device);
+
+	/* LCDC */
+	gpio_request_one(222, GPIOF_OUT_INIT_HIGH, NULL); /* LCDCDON */
+	gpio_request_one(226, GPIOF_OUT_INIT_HIGH, NULL); /* SC */
 
 	/*
 	 * Enable SD: this is a pseudo-GPIO, it actually only sets bit 28 in
@@ -101,6 +170,8 @@ static void __init kzm_init(void)
 	/* Early BRESP enable, Shared attribute override enable, 64K*8way */
 	l2x0_init(IOMEM(0xf0100000), 0x40460000, 0x82000fff);
 #endif
+
+	platform_add_devices(kzm_devices, ARRAY_SIZE(kzm_devices));
 }
 
 static void kzm9g_restart(char mode, const char *cmd)
-- 
1.7.2.5

