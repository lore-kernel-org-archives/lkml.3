Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaE1XUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:20:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47801 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751924AbaE1XUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:20:49 -0400
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
Subject: [PATCHv2 03/15] ARM: at91: at91sam9263: switch to generic PWM framework
Date: Thu, 29 May 2014 01:20:06 +0200
Message-Id: <1401319218-16772-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the pwm/pwm-atmel driver instead of misc/atmel_pwm

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9263.c         |  1 +
 arch/arm/mach-at91/at91sam9263_devices.c | 11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index f30290572293..f6663d6c01ec 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -199,6 +199,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tcb_clk),
 	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "at91sam9rl-pwm", &pwm_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 953616e5dbcb..4ab8be942f86 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -1131,9 +1131,7 @@ static void __init at91_add_device_watchdog(void) {}
  *  PWM
  * --------------------------------------------------------------------*/
 
-#if defined(CONFIG_ATMEL_PWM)
-static u32 pwm_mask;
-
+#if IS_ENABLED(CONFIG_PWM_ATMEL)
 static struct resource pwm_resources[] = {
 	[0] = {
 		.start	= AT91SAM9263_BASE_PWMC,
@@ -1148,11 +1146,8 @@ static struct resource pwm_resources[] = {
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
@@ -1171,8 +1166,6 @@ void __init at91_add_device_pwm(u32 mask)
 	if (mask & (1 << AT91_PWM3))
 		at91_set_B_periph(AT91_PIN_PB29, 1);	/* enable PWM3 */
 
-	pwm_mask = mask;
-
 	platform_device_register(&at91sam9263_pwm0_device);
 }
 #else
-- 
1.9.1

