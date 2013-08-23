Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3HWMYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:15 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45606 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3HWMYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/40] ARM: ux500: Purge SDI regulator support when booting with ATAGs enable
Date: Fri, 23 Aug 2013 13:23:09 +0100
Message-Id: <1377260620-18829-10-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c | 53 --------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index deda6a1..b8b5ebe 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -26,7 +26,6 @@
 #include <linux/regulator/ab8500.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/driver.h>
-#include <linux/regulator/gpio-regulator.h>
 #include <linux/mfd/tc3589x.h>
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
@@ -54,37 +53,6 @@
 #include "board-mop500.h"
 #include "board-mop500-regulators.h"
 
-/* Dynamically populated. */
-static struct gpio sdi0_reg_gpios[] = {
-	{ 0, GPIOF_OUT_INIT_LOW, "mmci_vsel" },
-};
-
-static struct gpio_regulator_state sdi0_reg_states[] = {
-	{ .value = 2900000, .gpios = (0 << 0) },
-	{ .value = 1800000, .gpios = (1 << 0) },
-};
-
-static struct gpio_regulator_config sdi0_reg_info = {
-	.supply_name		= "ext-mmc-level-shifter",
-	.gpios			= sdi0_reg_gpios,
-	.nr_gpios		= ARRAY_SIZE(sdi0_reg_gpios),
-	.states			= sdi0_reg_states,
-	.nr_states		= ARRAY_SIZE(sdi0_reg_states),
-	.type			= REGULATOR_VOLTAGE,
-	.enable_high		= 1,
-	.enabled_at_boot	= 0,
-	.init_data		= &sdi0_reg_init_data,
-	.startup_delay		= 100,
-};
-
-static struct platform_device sdi0_regulator = {
-	.name = "gpio-regulator",
-	.id   = -1,
-	.dev  = {
-		.platform_data = &sdi0_reg_info,
-	},
-};
-
 static struct abx500_gpio_platform_data ab8500_gpio_pdata = {
 	.gpio_base		= MOP500_AB8500_PIN_GPIO(1),
 };
@@ -233,7 +201,6 @@ static struct hash_platform_data u8500_hash1_platform_data = {
 /* add any platform devices here - TODO */
 static struct platform_device *mop500_platform_devs[] __initdata = {
 	&mop500_gpio_keys_device,
-	&sdi0_regulator,
 };
 
 #ifdef CONFIG_STE_DMA40
@@ -346,10 +313,6 @@ static void __init u8500_cryp1_hash1_init(struct device *parent)
 	db8500_add_hash1(parent, &u8500_hash1_platform_data);
 }
 
-static struct platform_device *snowball_platform_devs[] __initdata = {
-	&sdi0_regulator,
-};
-
 static void __init mop500_init_machine(void)
 {
 	struct device *parent = NULL;
@@ -359,9 +322,6 @@ static void __init mop500_init_machine(void)
 	platform_device_register(&db8500_prcmu_device);
 	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
 
-	sdi0_reg_info.enable_gpio = GPIO_SDMMC_EN;
-	sdi0_reg_info.gpios[0].gpio = GPIO_SDMMC_1V8_3V_SEL;
-
 	mop500_pinmaps_init();
 	parent = u8500_init_devices();
 
@@ -391,22 +351,12 @@ static void __init mop500_init_machine(void)
 static void __init snowball_init_machine(void)
 {
 	struct device *parent = NULL;
-	int i;
 
 	platform_device_register(&db8500_prcmu_device);
 
-	sdi0_reg_info.enable_gpio = SNOWBALL_SDMMC_EN_GPIO;
-	sdi0_reg_info.gpios[0].gpio = SNOWBALL_SDMMC_1V8_3V_GPIO;
-
 	snowball_pinmaps_init();
 	parent = u8500_init_devices();
 
-	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
-		snowball_platform_devs[i]->dev.parent = parent;
-
-	platform_add_devices(snowball_platform_devs,
-			ARRAY_SIZE(snowball_platform_devs));
-
 	mop500_i2c_init(parent);
 	snowball_sdi_init(parent);
 	mop500_spi_init(parent);
@@ -432,9 +382,6 @@ static void __init hrefv60_init_machine(void)
 	 */
 	mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 
-	sdi0_reg_info.enable_gpio = HREFV60_SDMMC_EN_GPIO;
-	sdi0_reg_info.gpios[0].gpio = HREFV60_SDMMC_1V8_3V_GPIO;
-
 	hrefv60_pinmaps_init();
 	parent = u8500_init_devices();
 
-- 
1.8.1.2

