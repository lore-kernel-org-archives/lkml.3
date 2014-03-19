Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbaCSNTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:19:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42104 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933877AbaCSNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:04:01 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 04/16] ARM: at91: sam9263ek: use generic leds_pwm driver
Date: Wed, 19 Mar 2014 14:03:17 +0100
Message-Id: <1395234209-15546-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the generic leds_pwm driver instead of leds-atmel-pwm.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-sam9263ek.c | 56 ++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 2f931915c80c..f8496868d9ba 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -32,6 +32,8 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/leds.h>
+#include <linux/pwm.h>
+#include <linux/leds_pwm.h>
 
 #include <video/atmel_lcdc.h>
 
@@ -368,21 +370,48 @@ static struct gpio_led ek_leds[] = {
 		.name			= "ds3",
 		.gpio			= AT91_PIN_PB7,
 		.default_trigger	= "heartbeat",
+	},
+#if !IS_ENABLED(CONFIG_LEDS_PWM)
+	{
+		.name			= "ds1",
+		.gpio			= AT91_PIN_PB8,
+		.active_low		= 1,
+		.default_trigger	= "none",
 	}
+#endif
 };
 
 /*
  * PWM Leds
  */
-static struct gpio_led ek_pwm_led[] = {
-	/* For now only DS1 is PWM-driven (by pwm1) */
+static struct pwm_lookup pwm_lookup[] = {
+	PWM_LOOKUP("at91sam9rl-pwm", 1, "leds_pwm", "ds1"),
+};
+
+#if IS_ENABLED(CONFIG_LEDS_PWM)
+static struct led_pwm pwm_leds[] = {
 	{
-		.name			= "ds1",
-		.gpio			= 1,	/* is PWM channel number */
-		.active_low		= 1,
-		.default_trigger	= "none",
-	}
+		.name = "ds1",
+		.max_brightness = 255,
+		.pwm_period_ns  = 5000,
+		.active_low = 1,
+	},
+};
+
+static struct led_pwm_platform_data pwm_data = {
+	.num_leds       = ARRAY_SIZE(pwm_leds),
+	.leds           = pwm_leds,
+};
+
+static struct platform_device leds_pwm = {
+	.name   = "leds_pwm",
+	.id     = -1,
+	.dev    = {
+		.platform_data = &pwm_data,
+	},
 };
+#endif
+
 
 /*
  * CAN
@@ -402,6 +431,12 @@ static struct at91_can_data ek_can_data = {
 	.transceiver_switch = sam9263ek_transceiver_switch,
 };
 
+static struct platform_device *devices[] __initdata = {
+#if IS_ENABLED(CONFIG_LEDS_PWM)
+	&leds_pwm,
+#endif
+};
+
 static void __init ek_board_init(void)
 {
 	/* Serial */
@@ -436,9 +471,14 @@ static void __init ek_board_init(void)
 	at91_add_device_ac97(&ek_ac97_data);
 	/* LEDs */
 	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
-	at91_pwm_leds(ek_pwm_led, ARRAY_SIZE(ek_pwm_led));
+	pwm_add_table(pwm_lookup, ARRAY_SIZE(pwm_lookup));
+#if IS_ENABLED(CONFIG_LEDS_PWM)
+	at91_add_device_pwm(1 << AT91_PWM1);
+#endif
 	/* CAN */
 	at91_add_device_can(&ek_can_data);
+	/* Other platform devices */
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
 MACHINE_START(AT91SAM9263EK, "Atmel AT91SAM9263-EK")
-- 
1.8.3.2

