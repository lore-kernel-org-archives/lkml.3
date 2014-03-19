Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbaCSNEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:04:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42085 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933813AbaCSND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:03:59 -0400
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
Subject: [PATCH 02/16] ARM: at91: sam9m10g45ek: use generic leds_pwm driver
Date: Wed, 19 Mar 2014 14:03:15 +0100
Message-Id: <1395234209-15546-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the generic leds_pwm driver instead of leds-atmel-pwm.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-sam9m10g45ek.c | 43 ++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index f2f7ce9643ce..a98e92525fdb 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -26,6 +26,8 @@
 #include <linux/leds.h>
 #include <linux/atmel-mci.h>
 #include <linux/delay.h>
+#include <linux/pwm.h>
+#include <linux/leds_pwm.h>
 
 #include <linux/platform_data/at91_adc.h>
 
@@ -415,7 +417,7 @@ static struct gpio_led ek_leds[] = {
 		.active_low		= 1,
 		.default_trigger	= "nand-disk",
 	},
-#if !(defined(CONFIG_LEDS_ATMEL_PWM) || defined(CONFIG_LEDS_ATMEL_PWM_MODULE))
+#if !IS_ENABLED(CONFIG_LEDS_PWM)
 	{	/* "right" led, green, userled1, pwm1 */
 		.name			= "d7",
 		.gpio			= AT91_PIN_PD31,
@@ -429,22 +431,42 @@ static struct gpio_led ek_leds[] = {
 /*
  * PWM Leds
  */
-static struct gpio_led ek_pwm_led[] = {
-#if defined(CONFIG_LEDS_ATMEL_PWM) || defined(CONFIG_LEDS_ATMEL_PWM_MODULE)
+static struct pwm_lookup pwm_lookup[] = {
+	PWM_LOOKUP("at91sam9rl-pwm", 1, "leds_pwm", "d7"),
+};
+
+#if IS_ENABLED(CONFIG_LEDS_PWM)
+static struct led_pwm pwm_leds[] = {
 	{	/* "right" led, green, userled1, pwm1 */
-		.name			= "d7",
-		.gpio			= 1,	/* is PWM channel number */
-		.active_low		= 1,
-		.default_trigger	= "none",
+		.name = "d7",
+		.max_brightness	= 255,
+		.pwm_period_ns	= 5000,
+		.active_low = 1,
 	},
-#endif
 };
 
+static struct led_pwm_platform_data pwm_data = {
+	.num_leds	= ARRAY_SIZE(pwm_leds),
+	.leds		= pwm_leds,
+};
+
+static struct platform_device leds_pwm = {
+	.name	= "leds_pwm",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &pwm_data,
+	},
+};
+#endif
+
 static struct platform_device *devices[] __initdata = {
 #if defined(CONFIG_SOC_CAMERA_OV2640) || \
 	defined(CONFIG_SOC_CAMERA_OV2640_MODULE)
 	&isi_ov2640,
 #endif
+#if IS_ENABLED(CONFIG_LEDS_PWM)
+	&leds_pwm,
+#endif
 };
 
 static void __init ek_board_init(void)
@@ -485,7 +507,10 @@ static void __init ek_board_init(void)
 	at91_add_device_ac97(&ek_ac97_data);
 	/* LEDs */
 	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
-	at91_pwm_leds(ek_pwm_led, ARRAY_SIZE(ek_pwm_led));
+	pwm_add_table(pwm_lookup, ARRAY_SIZE(pwm_lookup));
+#if IS_ENABLED(CONFIG_LEDS_PWM)
+	at91_add_device_pwm(1 << AT91_PWM1);
+#endif
 	/* Other platform devices */
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
-- 
1.8.3.2

