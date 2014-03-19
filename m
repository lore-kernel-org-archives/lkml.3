Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbaCSNTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:19:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42094 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933859AbaCSNEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:04:00 -0400
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
Subject: [PATCH 03/16] ARM: at91: at91sam9263: switch to generic PWM framework
Date: Wed, 19 Mar 2014 14:03:16 +0100
Message-Id: <1395234209-15546-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the pwm/pwm-atmel driver instead of misc/atmel_pwm

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9263.c         |  1 +
 arch/arm/mach-at91/at91sam9263_devices.c | 11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 37b90f4b990c..d0c2d4955cd7 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -198,6 +198,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tcb_clk),
 	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "at91sam9rl-pwm", &pwm_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 4aeadddbc181..160acd96cdda 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -1129,9 +1129,7 @@ static void __init at91_add_device_watchdog(void) {}
  *  PWM
  * --------------------------------------------------------------------*/
 
-#if defined(CONFIG_ATMEL_PWM)
-static u32 pwm_mask;
-
+#if IS_ENABLED(CONFIG_PWM_ATMEL)
 static struct resource pwm_resources[] = {
 	[0] = {
 		.start	= AT91SAM9263_BASE_PWMC,
@@ -1146,11 +1144,8 @@ static struct resource pwm_resources[] = {
 };
 
 static struct platform_device at91sam9263_pwm0_device = {
-	.name	= "atmel_pwm",
+	.name	= "at91sam9rl-pwm",
 	.id	= -1,
-	.dev	= {
-		.platform_data		= &pwm_mask,
-	},
 	.resource	= pwm_resources,
 	.num_resources	= ARRAY_SIZE(pwm_resources),
 };
@@ -1169,8 +1164,6 @@ void __init at91_add_device_pwm(u32 mask)
 	if (mask & (1 << AT91_PWM3))
 		at91_set_B_periph(AT91_PIN_PB29, 1);	/* enable PWM3 */
 
-	pwm_mask = mask;
-
 	platform_device_register(&at91sam9263_pwm0_device);
 }
 #else
-- 
1.8.3.2

