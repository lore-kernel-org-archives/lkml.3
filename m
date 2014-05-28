Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaE1XVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:21:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47858 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932364AbaE1XV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:21:26 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 09/15] avr32: MRMT: use generic leds_pwm driver
Date: Thu, 29 May 2014 01:20:12 +0200
Message-Id: <1401319218-16772-10-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the generic leds_pwm driver instead of leds-atmel-pwm.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/boards/atngw100/mrmt.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/avr32/boards/atngw100/mrmt.c b/arch/avr32/boards/atngw100/mrmt.c
index 1ba09e4c02b1..91146b416cdb 100644
--- a/arch/avr32/boards/atngw100/mrmt.c
+++ b/arch/avr32/boards/atngw100/mrmt.c
@@ -17,6 +17,8 @@
 #include <linux/types.h>
 #include <linux/fb.h>
 #include <linux/leds.h>
+#include <linux/pwm.h>
+#include <linux/leds_pwm.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
 #include <linux/atmel_serial.h>
@@ -155,21 +157,28 @@ static struct platform_device rmt_ts_device = {
 
 #ifdef CONFIG_BOARD_MRMT_BL_PWM
 /* PWM LEDs: LCD Backlight, etc */
-static struct gpio_led rmt_pwm_led[] = {
-	/* here the "gpio" is actually a PWM channel */
-	{ .name = "backlight",	.gpio = PWM_CH_BL, },
+static struct pwm_lookup pwm_lookup[] = {
+	PWM_LOOKUP("at91sam9rl-pwm", PWM_CH_BL, "leds_pwm", "ds1",
+		   5000, PWM_POLARITY_INVERSED),
 };
 
-static struct gpio_led_platform_data rmt_pwm_led_data = {
-	.num_leds	= ARRAY_SIZE(rmt_pwm_led),
-	.leds		= rmt_pwm_led,
+static struct led_pwm pwm_leds[] = {
+	{
+		.name = "backlight",
+		.max_brightness = 255,
+	},
+};
+
+static struct led_pwm_platform_data pwm_data = {
+	.num_leds       = ARRAY_SIZE(pwm_leds),
+	.leds           = pwm_leds,
 };
 
-static struct platform_device rmt_pwm_led_dev = {
-	.name		= "leds-atmel-pwm",
-	.id		= -1,
-	.dev		= {
-		.platform_data	= &rmt_pwm_led_data,
+static struct platform_device leds_pwm = {
+	.name   = "leds_pwm",
+	.id     = -1,
+	.dev    = {
+		.platform_data = &pwm_data,
 	},
 };
 #endif
@@ -325,7 +334,8 @@ static int __init mrmt1_init(void)
 #ifdef CONFIG_BOARD_MRMT_BL_PWM
 	/* Use PWM for Backlight controls */
 	at32_add_device_pwm(1 << PWM_CH_BL);
-	platform_device_register(&rmt_pwm_led_dev);
+	pwm_add_table(pwm_lookup, ARRAY_SIZE(pwm_lookup));
+	platform_device_register(&leds_pwm);
 #else
 	/* Backlight always on */
 	udelay( 1 );
-- 
1.9.1

