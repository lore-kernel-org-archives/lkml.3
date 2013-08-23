Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3HWMY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:29 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43161 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab3HWMYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/40] ARM: ux500: Purge SFH7741 Proximity Sensor support when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:16 +0100
Message-Id: <1377260620-18829-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's time to remove all ATAG support from ux500 and rely solely on
Device Tree booting. This patch is part of that endeavour.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c | 75 --------------------------------------
 1 file changed, 75 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index e0db81d..fd1e0bc 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -30,7 +30,6 @@
 #include <linux/mfd/abx500/ab8500-gpio.h>
 #include <linux/platform_data/leds-lp55xx.h>
 #include <linux/input.h>
-#include <linux/gpio_keys.h>
 #include <linux/delay.h>
 #include <linux/leds.h>
 #include <linux/pinctrl/consumer.h>
@@ -63,59 +62,6 @@ static void __init mop500_i2c_init(struct device *parent)
 	db8500_add_i2c3(parent, NULL);
 }
 
-static struct gpio_keys_button mop500_gpio_keys[] = {
-	{
-		.desc			= "SFH7741 Proximity Sensor",
-		.type			= EV_SW,
-		.code			= SW_FRONT_PROXIMITY,
-		.active_low		= 0,
-		.can_disable		= 1,
-	}
-};
-
-static struct regulator *prox_regulator;
-static int mop500_prox_activate(struct device *dev);
-static void mop500_prox_deactivate(struct device *dev);
-
-static struct gpio_keys_platform_data mop500_gpio_keys_data = {
-	.buttons	= mop500_gpio_keys,
-	.nbuttons	= ARRAY_SIZE(mop500_gpio_keys),
-	.enable		= mop500_prox_activate,
-	.disable	= mop500_prox_deactivate,
-};
-
-static struct platform_device mop500_gpio_keys_device = {
-	.name	= "gpio-keys",
-	.id	= 0,
-	.dev	= {
-		.platform_data	= &mop500_gpio_keys_data,
-	},
-};
-
-static int mop500_prox_activate(struct device *dev)
-{
-	prox_regulator = regulator_get(&mop500_gpio_keys_device.dev,
-						"vcc");
-	if (IS_ERR(prox_regulator)) {
-		dev_err(&mop500_gpio_keys_device.dev,
-			"no regulator\n");
-		return PTR_ERR(prox_regulator);
-	}
-
-	return regulator_enable(prox_regulator);
-}
-
-static void mop500_prox_deactivate(struct device *dev)
-{
-	regulator_disable(prox_regulator);
-	regulator_put(prox_regulator);
-}
-
-/* add any platform devices here - TODO */
-static struct platform_device *mop500_platform_devs[] __initdata = {
-	&mop500_gpio_keys_device,
-};
-
 #ifdef CONFIG_STE_DMA40
 static struct stedma40_chan_cfg ssp0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
@@ -223,20 +169,12 @@ static void __init mop500_uart_init(struct device *parent)
 static void __init mop500_init_machine(void)
 {
 	struct device *parent = NULL;
-	int i;
 
 	platform_device_register(&db8500_prcmu_device);
-	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
 
 	mop500_pinmaps_init();
 	parent = u8500_init_devices();
 
-	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
-		mop500_platform_devs[i]->dev.parent = parent;
-
-	platform_add_devices(mop500_platform_devs,
-			ARRAY_SIZE(mop500_platform_devs));
-
 	mop500_i2c_init(parent);
 	mop500_sdi_init(parent);
 	mop500_spi_init(parent);
@@ -267,25 +205,12 @@ static void __init snowball_init_machine(void)
 static void __init hrefv60_init_machine(void)
 {
 	struct device *parent = NULL;
-	int i;
 
 	platform_device_register(&db8500_prcmu_device);
-	/*
-	 * The HREFv60 board removed a GPIO expander and routed
-	 * all these GPIO pins to the internal GPIO controller
-	 * instead.
-	 */
-	mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 
 	hrefv60_pinmaps_init();
 	parent = u8500_init_devices();
 
-	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
-		mop500_platform_devs[i]->dev.parent = parent;
-
-	platform_add_devices(mop500_platform_devs,
-			ARRAY_SIZE(mop500_platform_devs));
-
 	mop500_i2c_init(parent);
 	hrefv60_sdi_init(parent);
 	mop500_spi_init(parent);
-- 
1.8.1.2

