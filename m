Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3FKNq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:46:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35338 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3FKNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:45:43 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v3 3/5] ARM: mach-shmobile: kota2: Use leds-pwm + pwm-rmob
Date: Tue, 11 Jun 2013 15:45:42 +0200
Message-Id: <1370958344-19470-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using the LED-specific TPU PWM driver, switch to the generic
TPU PWM driver with leds-pwm.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm/mach-shmobile/board-kota2.c  | 183 ++++++++++++++++++++--------------
 arch/arm/mach-shmobile/clock-sh73a0.c |   8 +-
 2 files changed, 114 insertions(+), 77 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-kota2.c b/arch/arm/mach-shmobile/board-kota2.c
index ef5ca0e..ffa6baf 100644
--- a/arch/arm/mach-shmobile/board-kota2.c
+++ b/arch/arm/mach-shmobile/board-kota2.c
@@ -26,6 +26,7 @@
 #include <linux/irq.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinconf-generic.h>
+#include <linux/platform_data/pwm-renesas-tpu.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -37,8 +38,8 @@
 #include <linux/input/sh_keysc.h>
 #include <linux/gpio_keys.h>
 #include <linux/leds.h>
+#include <linux/leds_pwm.h>
 #include <linux/irqchip/arm-gic.h>
-#include <linux/platform_data/leds-renesas-tpu.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/sh_mmcif.h>
 #include <linux/mfd/tmio.h>
@@ -186,116 +187,140 @@ static struct platform_device gpio_leds_device = {
 };
 
 /* TPU LED */
-static struct led_renesas_tpu_config led_renesas_tpu12_pdata = {
-	.name		= "V2513",
-	.pin_gpio_fn	= GPIO_FN_TPU1TO2,
-	.pin_gpio	= 153,
-	.channel_offset = 0x90,
-	.timer_bit = 2,
-	.max_brightness = 1000,
+static struct tpu_pwm_platform_data tpu1_pwm_pdata = {
+	.channels[2] = {
+		.enabled = true,
+		.polarity = PWM_POLARITY_NORMAL,
+	},
 };
 
-static struct resource tpu12_resources[] = {
+static struct resource tpu1_pwm_resources[] = {
 	[0] = {
-		.name	= "TPU12",
-		.start	= 0xe6610090,
-		.end	= 0xe66100b5,
+		.start	= 0xe6610000,
+		.end	= 0xe66100ff,
 		.flags	= IORESOURCE_MEM,
 	},
 };
 
-static struct platform_device leds_tpu12_device = {
-	.name = "leds-renesas-tpu",
-	.id = 12,
+static struct platform_device tpu1_pwm_device = {
+	.name = "renesas_tpu_pwm",
+	.id = 1,
 	.dev = {
-		.platform_data  = &led_renesas_tpu12_pdata,
+		.platform_data  = &tpu1_pwm_pdata,
 	},
-	.num_resources	= ARRAY_SIZE(tpu12_resources),
-	.resource	= tpu12_resources,
+	.num_resources	= ARRAY_SIZE(tpu1_pwm_resources),
+	.resource	= tpu1_pwm_resources,
 };
 
-static struct led_renesas_tpu_config led_renesas_tpu41_pdata = {
-	.name		= "V2514",
-	.pin_gpio_fn	= GPIO_FN_TPU4TO1,
-	.pin_gpio	= 199,
-	.channel_offset = 0x50,
-	.timer_bit = 1,
-	.max_brightness = 1000,
+static struct tpu_pwm_platform_data tpu2_pwm_pdata = {
+	.channels[1] = {
+		.enabled = true,
+		.polarity = PWM_POLARITY_NORMAL,
+	},
 };
 
-static struct resource tpu41_resources[] = {
+static struct resource tpu2_pwm_resources[] = {
 	[0] = {
-		.name	= "TPU41",
-		.start	= 0xe6640050,
-		.end	= 0xe6640075,
+		.start	= 0xe6620000,
+		.end	= 0xe66200ff,
 		.flags	= IORESOURCE_MEM,
 	},
 };
 
-static struct platform_device leds_tpu41_device = {
-	.name = "leds-renesas-tpu",
-	.id = 41,
+static struct platform_device tpu2_pwm_device = {
+	.name = "renesas_tpu_pwm",
+	.id = 2,
 	.dev = {
-		.platform_data  = &led_renesas_tpu41_pdata,
+		.platform_data  = &tpu2_pwm_pdata,
 	},
-	.num_resources	= ARRAY_SIZE(tpu41_resources),
-	.resource	= tpu41_resources,
+	.num_resources	= ARRAY_SIZE(tpu2_pwm_resources),
+	.resource	= tpu2_pwm_resources,
 };
 
-static struct led_renesas_tpu_config led_renesas_tpu21_pdata = {
-	.name		= "V2515",
-	.pin_gpio_fn	= GPIO_FN_TPU2TO1,
-	.pin_gpio	= 197,
-	.channel_offset = 0x50,
-	.timer_bit = 1,
-	.max_brightness = 1000,
+static struct tpu_pwm_platform_data tpu3_pwm_pdata = {
+	.channels[0] = {
+		.enabled = true,
+		.polarity = PWM_POLARITY_NORMAL,
+	},
 };
 
-static struct resource tpu21_resources[] = {
+static struct resource tpu3_pwm_resources[] = {
 	[0] = {
-		.name	= "TPU21",
-		.start	= 0xe6620050,
-		.end	= 0xe6620075,
+		.start	= 0xe6630000,
+		.end	= 0xe66300ff,
 		.flags	= IORESOURCE_MEM,
 	},
 };
 
-static struct platform_device leds_tpu21_device = {
-	.name = "leds-renesas-tpu",
-	.id = 21,
+static struct platform_device tpu3_pwm_device = {
+	.name = "renesas_tpu_pwm",
+	.id = 3,
 	.dev = {
-		.platform_data  = &led_renesas_tpu21_pdata,
+		.platform_data  = &tpu3_pwm_pdata,
 	},
-	.num_resources	= ARRAY_SIZE(tpu21_resources),
-	.resource	= tpu21_resources,
+	.num_resources	= ARRAY_SIZE(tpu3_pwm_resources),
+	.resource	= tpu3_pwm_resources,
 };
 
-static struct led_renesas_tpu_config led_renesas_tpu30_pdata = {
-	.name		= "KEYLED",
-	.pin_gpio_fn	= GPIO_FN_TPU3TO0,
-	.pin_gpio	= 163,
-	.channel_offset = 0x10,
-	.timer_bit = 0,
-	.max_brightness = 1000,
+static struct tpu_pwm_platform_data tpu4_pwm_pdata = {
+	.channels[1] = {
+		.enabled = true,
+		.polarity = PWM_POLARITY_NORMAL,
+	},
 };
 
-static struct resource tpu30_resources[] = {
+static struct resource tpu4_pwm_resources[] = {
 	[0] = {
-		.name	= "TPU30",
-		.start	= 0xe6630010,
-		.end	= 0xe6630035,
+		.start	= 0xe6640000,
+		.end	= 0xe66400ff,
 		.flags	= IORESOURCE_MEM,
 	},
 };
 
-static struct platform_device leds_tpu30_device = {
-	.name = "leds-renesas-tpu",
-	.id = 30,
+static struct platform_device tpu4_pwm_device = {
+	.name = "renesas_tpu_pwm",
+	.id = 4,
+	.dev = {
+		.platform_data  = &tpu4_pwm_pdata,
+	},
+	.num_resources	= ARRAY_SIZE(tpu4_pwm_resources),
+	.resource	= tpu4_pwm_resources,
+};
+
+static struct pwm_lookup pwm_lookup[] = {
+	PWM_LOOKUP("renesas_tpu_pwm.1", 2, "leds-pwm.0", "V2513"),
+	PWM_LOOKUP("renesas_tpu_pwm.2", 1, "leds-pwm.0", "V2515"),
+	PWM_LOOKUP("renesas_tpu_pwm.3", 0, "leds-pwm.0", "KEYLED"),
+	PWM_LOOKUP("renesas_tpu_pwm.4", 1, "leds-pwm.0", "V2514"),
+};
+
+static struct led_pwm tpu_pwm_leds[] = {
+	{
+		.name		= "V2513",
+		.max_brightness	= 1000,
+	}, {
+		.name		= "V2515",
+		.max_brightness	= 1000,
+	}, {
+		.name		= "KEYLED",
+		.max_brightness	= 1000,
+	}, {
+		.name		= "V2514",
+		.max_brightness	= 1000,
+	},
+};
+
+static struct led_pwm_platform_data leds_pwm_pdata = {
+	.num_leds = ARRAY_SIZE(tpu_pwm_leds),
+	.leds = tpu_pwm_leds,
+};
+
+static struct platform_device leds_pwm_device = {
+	.name = "leds-pwm",
+	.id = 0,
 	.dev = {
-		.platform_data  = &led_renesas_tpu30_pdata,
+		.platform_data = &leds_pwm_pdata,
 	},
-	.num_resources	= ARRAY_SIZE(tpu30_resources),
-	.resource	= tpu30_resources,
 };
 
 /* Fixed 1.8V regulator to be used by MMCIF */
@@ -426,10 +451,11 @@ static struct platform_device *kota2_devices[] __initdata = {
 	&keysc_device,
 	&gpio_keys_device,
 	&gpio_leds_device,
-	&leds_tpu12_device,
-	&leds_tpu41_device,
-	&leds_tpu21_device,
-	&leds_tpu30_device,
+	&tpu1_pwm_device,
+	&tpu2_pwm_device,
+	&tpu3_pwm_device,
+	&tpu4_pwm_device,
+	&leds_pwm_device,
 	&mmcif_device,
 	&sdhi0_device,
 	&sdhi1_device,
@@ -512,6 +538,15 @@ static const struct pinctrl_map kota2_pinctrl_map[] = {
 				  "bsc_cs5_a", "bsc"),
 	PIN_MAP_MUX_GROUP_DEFAULT("smsc911x.0", "pfc-sh73a0",
 				  "bsc_we0", "bsc"),
+	/* TPU */
+	PIN_MAP_MUX_GROUP_DEFAULT("renesas_tpu_pwm.1", "pfc-sh73a0",
+				  "tpu1_to2", "tpu1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("renesas_tpu_pwm.2", "pfc-sh73a0",
+				  "tpu2_to1", "tpu2"),
+	PIN_MAP_MUX_GROUP_DEFAULT("renesas_tpu_pwm.3", "pfc-sh73a0",
+				  "tpu3_to0", "tpu3"),
+	PIN_MAP_MUX_GROUP_DEFAULT("renesas_tpu_pwm.4", "pfc-sh73a0",
+				  "tpu4_to1", "tpu4"),
 };
 
 static void __init kota2_init(void)
@@ -524,6 +559,8 @@ static void __init kota2_init(void)
 
 	pinctrl_register_mappings(kota2_pinctrl_map,
 				  ARRAY_SIZE(kota2_pinctrl_map));
+	pwm_add_table(pwm_lookup, ARRAY_SIZE(pwm_lookup));
+
 	sh73a0_pinmux_init();
 
 	/* SMSC911X */
diff --git a/arch/arm/mach-shmobile/clock-sh73a0.c b/arch/arm/mach-shmobile/clock-sh73a0.c
index d9fd033..6c04348 100644
--- a/arch/arm/mach-shmobile/clock-sh73a0.c
+++ b/arch/arm/mach-shmobile/clock-sh73a0.c
@@ -669,10 +669,10 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("e6bd0000.mmcif", &mstp_clks[MSTP312]), /* MMCIF0 */
 	CLKDEV_DEV_ID("sh_mobile_sdhi.2", &mstp_clks[MSTP311]), /* SDHI2 */
 	CLKDEV_DEV_ID("ee140000.sdhi", &mstp_clks[MSTP311]), /* SDHI2 */
-	CLKDEV_DEV_ID("leds-renesas-tpu.12", &mstp_clks[MSTP303]), /* TPU1 */
-	CLKDEV_DEV_ID("leds-renesas-tpu.21", &mstp_clks[MSTP302]), /* TPU2 */
-	CLKDEV_DEV_ID("leds-renesas-tpu.30", &mstp_clks[MSTP301]), /* TPU3 */
-	CLKDEV_DEV_ID("leds-renesas-tpu.41", &mstp_clks[MSTP300]), /* TPU4 */
+	CLKDEV_DEV_ID("rmob_tpu_pwm.1", &mstp_clks[MSTP303]), /* TPU1 */
+	CLKDEV_DEV_ID("rmob_tpu_pwm.2", &mstp_clks[MSTP302]), /* TPU2 */
+	CLKDEV_DEV_ID("rmob_tpu_pwm.3", &mstp_clks[MSTP301]), /* TPU3 */
+	CLKDEV_DEV_ID("rmob_tpu_pwm.4", &mstp_clks[MSTP300]), /* TPU4 */
 	CLKDEV_DEV_ID("i2c-sh_mobile.3", &mstp_clks[MSTP411]), /* I2C3 */
 	CLKDEV_DEV_ID("e6826000.i2c", &mstp_clks[MSTP411]), /* I2C3 */
 	CLKDEV_DEV_ID("i2c-sh_mobile.4", &mstp_clks[MSTP410]), /* I2C4 */
-- 
1.8.1.5

