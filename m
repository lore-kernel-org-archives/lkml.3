Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3DXAH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:07:57 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39569 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3DXAGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:06:20 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 5/9] ARM: mach-shmobile: armadillo800eva: Add backlight support
Date: Wed, 24 Apr 2013 02:06:05 +0200
Message-Id: <1366761969-16759-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flat panel backlight on the Armadillo 800 EVA board is driven by the
TPU PWM output.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms@verge.net.au>
---
 arch/arm/mach-shmobile/board-armadillo800eva.c | 51 +++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index ff04d1e..3c4fcef 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -30,6 +30,8 @@
 #include <linux/gpio_keys.h>
 #include <linux/regulator/driver.h>
 #include <linux/pinctrl/machine.h>
+#include <linux/platform_data/pwm-rmob.h>
+#include <linux/pwm_backlight.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/gpio-regulator.h>
 #include <linux/regulator/machine.h>
@@ -381,7 +383,48 @@ static struct platform_device sh_eth_device = {
 	.num_resources = ARRAY_SIZE(sh_eth_resources),
 };
 
-/* LCDC */
+/* PWM */
+static struct resource pwm_resources[] = {
+	[0] = {
+		.start = 0xe6600000,
+		.end = 0xe66000ff,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct rmob_tpu_pwm_platform_data pwm_device_data = {
+	.channels[2] = {
+		.enabled = true,
+		.active_low = 1,
+	}
+};
+
+static struct platform_device pwm_device = {
+	.name = "rmob_tpu_pwm",
+	.id = -1,
+	.dev = {
+		.platform_data = &pwm_device_data,
+	},
+	.num_resources = ARRAY_SIZE(pwm_resources),
+	.resource = pwm_resources,
+};
+
+/* LCDC and backlight */
+static struct platform_pwm_backlight_data pwm_backlight_data = {
+	.pwm_id = RMOB_TPU_PWM_ID(0, 2),
+	.lth_brightness = 50,
+	.max_brightness = 255,
+	.dft_brightness = 255,
+	.pwm_period_ns = 33333, /* 30kHz */
+};
+
+static struct platform_device pwm_backlight_device = {
+	.name = "pwm-backlight",
+	.dev = {
+		.platform_data = &pwm_backlight_data,
+	},
+};
+
 static struct fb_videomode lcdc0_mode = {
 	.name		= "AMPIER/AM-800480",
 	.xres		= 800,
@@ -1019,6 +1062,8 @@ static struct i2c_board_info i2c2_devices[] = {
  */
 static struct platform_device *eva_devices[] __initdata = {
 	&lcdc0_device,
+	&pwm_device,
+	&pwm_backlight_device,
 	&gpio_keys_device,
 	&sh_eth_device,
 	&vcc_sdhi0,
@@ -1090,6 +1135,9 @@ static const struct pinctrl_map eva_pinctrl_map[] = {
 	/* ST1232 */
 	PIN_MAP_MUX_GROUP_DEFAULT("0-0055", "pfc-r8a7740",
 				  "intc_irq10", "intc"),
+	/* TPU0 */
+	PIN_MAP_MUX_GROUP_DEFAULT("rmob_tpu_pwm", "pfc-r8a7740",
+				  "tpu0_to2_1", "tpu0"),
 	/* USBHS */
 	PIN_MAP_MUX_GROUP_DEFAULT("renesas_usbhs", "pfc-r8a7740",
 				  "intc_irq7_1", "intc"),
@@ -1149,7 +1197,6 @@ static void __init eva_init(void)
 
 	/* LCDC0 */
 	gpio_request_one(61, GPIOF_OUT_INIT_HIGH, NULL); /* LCDDON */
-	gpio_request_one(202, GPIOF_OUT_INIT_LOW, NULL); /* LCD0_LED_CONT */
 
 	/* Touchscreen */
 	gpio_request_one(166, GPIOF_OUT_INIT_HIGH, NULL); /* TP_RST_B */
-- 
1.8.1.5

