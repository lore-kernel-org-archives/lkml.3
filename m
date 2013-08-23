Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3HWMYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:23 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:39700 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3HWMYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/40] ARM: ux500: Remove TC35892 Flexible IO Expander when booting ATAGs
Date: Fri, 23 Aug 2013 13:23:14 +0100
Message-Id: <1377260620-18829-15-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500-sdi.c      | 12 ------
 arch/arm/mach-ux500/board-mop500-u8500uib.c | 64 -----------------------------
 arch/arm/mach-ux500/board-mop500.c          | 46 ---------------------
 arch/arm/mach-ux500/board-mop500.h          |  1 -
 4 files changed, 123 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index b3e61a3..1ae5999 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -71,12 +71,6 @@ static void sdi0_configure(struct device *parent)
 	db8500_add_sdi0(parent, &mop500_sdi0_data, U8500_SDI_V2_PERIPHID);
 }
 
-void mop500_sdi_tc35892_init(struct device *parent)
-{
-	mop500_sdi0_data.gpio_cd = GPIO_SDMMC_CD;
-	sdi0_configure(parent);
-}
-
 /*
  * SDI1 (SDIO WLAN)
  */
@@ -185,12 +179,6 @@ void __init mop500_sdi_init(struct device *parent)
 	db8500_add_sdi2(parent, &mop500_sdi2_data, U8500_SDI_V2_PERIPHID);
 	/* On-board eMMC */
 	db8500_add_sdi4(parent, &mop500_sdi4_data, U8500_SDI_V2_PERIPHID);
-
-	/*
-	 * On boards with the TC35892 GPIO expander, sdi0 will finally
-	 * be added when the TC35892 initializes and calls
-	 * mop500_sdi_tc35892_init() above.
-	 */
 }
 
 void __init snowball_sdi_init(struct device *parent)
diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
index d397c19..6f6553e 100644
--- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
+++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
@@ -9,8 +9,6 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
-#include <linux/mfd/tc3589x.h>
-#include <linux/input/matrix_keypad.h>
 
 #include "irqs.h"
 
@@ -23,70 +21,8 @@ static struct i2c_board_info __initdata mop500_i2c3_devices_u8500[] = {
 	},
 };
 
-/*
- * TC35893
- */
-static const unsigned int u8500_keymap[] = {
-	KEY(3, 1, KEY_END),
-	KEY(4, 1, KEY_POWER),
-	KEY(6, 4, KEY_VOLUMEDOWN),
-	KEY(4, 2, KEY_EMAIL),
-	KEY(3, 3, KEY_RIGHT),
-	KEY(2, 5, KEY_BACKSPACE),
-
-	KEY(6, 7, KEY_MENU),
-	KEY(5, 0, KEY_ENTER),
-	KEY(4, 3, KEY_0),
-	KEY(3, 4, KEY_DOT),
-	KEY(5, 2, KEY_UP),
-	KEY(3, 5, KEY_DOWN),
-
-	KEY(4, 5, KEY_SEND),
-	KEY(0, 5, KEY_BACK),
-	KEY(6, 2, KEY_VOLUMEUP),
-	KEY(1, 3, KEY_SPACE),
-	KEY(7, 6, KEY_LEFT),
-	KEY(5, 5, KEY_SEARCH),
-};
-
-static struct matrix_keymap_data u8500_keymap_data = {
-	.keymap		= u8500_keymap,
-	.keymap_size    = ARRAY_SIZE(u8500_keymap),
-};
-
-static struct tc3589x_keypad_platform_data tc35893_data = {
-	.krow = TC_KPD_ROWS,
-	.kcol = TC_KPD_COLUMNS,
-	.debounce_period = TC_KPD_DEBOUNCE_PERIOD,
-	.settle_time = TC_KPD_SETTLE_TIME,
-	.irqtype = IRQF_TRIGGER_FALLING,
-	.enable_wakeup = true,
-	.keymap_data    = &u8500_keymap_data,
-	.no_autorepeat  = true,
-};
-
-static struct tc3589x_platform_data tc3589x_keypad_data = {
-	.block = TC3589x_BLOCK_KEYPAD,
-	.keypad = &tc35893_data,
-	.irq_base = MOP500_EGPIO_IRQ_BASE,
-};
-
-static struct i2c_board_info __initdata mop500_i2c0_devices_u8500[] = {
-	{
-		I2C_BOARD_INFO("tc3589x", 0x44),
-		.platform_data = &tc3589x_keypad_data,
-		.irq = NOMADIK_GPIO_TO_IRQ(218),
-		.flags = I2C_CLIENT_WAKE,
-	},
-};
-
-
 void __init mop500_u8500uib_init(void)
 {
 	mop500_uib_i2c_add(3, mop500_i2c3_devices_u8500,
 			ARRAY_SIZE(mop500_i2c3_devices_u8500));
-
-	mop500_uib_i2c_add(0, mop500_i2c0_devices_u8500,
-			ARRAY_SIZE(mop500_i2c0_devices_u8500));
-
 }
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 2c4885a..66d466b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -26,7 +26,6 @@
 #include <linux/regulator/ab8500.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/driver.h>
-#include <linux/mfd/tc3589x.h>
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
 #include <linux/platform_data/leds-lp55xx.h>
@@ -56,41 +55,6 @@ struct ab8500_platform_data ab8500_platdata = {
 	.regulator	= &ab8500_regulator_plat_data,
 };
 
-/*
- * TC35892
- */
-
-static void mop500_tc35892_init(struct tc3589x *tc3589x, unsigned int base)
-{
-	struct device *parent = NULL;
-#if 0
-	/* FIXME: Is the sdi actually part of tc3589x? */
-	parent = tc3589x->dev;
-#endif
-	mop500_sdi_tc35892_init(parent);
-}
-
-static struct tc3589x_gpio_platform_data mop500_tc35892_gpio_data = {
-	.gpio_base	= MOP500_EGPIO(0),
-	.setup		= mop500_tc35892_init,
-};
-
-static struct tc3589x_platform_data mop500_tc35892_data = {
-	.block		= TC3589x_BLOCK_GPIO,
-	.gpio		= &mop500_tc35892_gpio_data,
-	.irq_base	= MOP500_EGPIO_IRQ_BASE,
-};
-
-static struct i2c_board_info __initdata mop500_i2c0_devices[] = {
-	{
-		I2C_BOARD_INFO("tc3589x", 0x42),
-		.irq		= NOMADIK_GPIO_TO_IRQ(217),
-		.platform_data  = &mop500_tc35892_data,
-	},
-};
-
-#define NUM_PRE_V60_I2C0_DEVICES 1
-
 static struct i2c_board_info __initdata mop500_i2c2_devices[] = {
 	{
 		/* Light sensor Rohm BH1780GLI */
@@ -266,7 +230,6 @@ static void __init mop500_uart_init(struct device *parent)
 static void __init mop500_init_machine(void)
 {
 	struct device *parent = NULL;
-	int i2c0_devs;
 	int i;
 
 	platform_device_register(&db8500_prcmu_device);
@@ -286,9 +249,6 @@ static void __init mop500_init_machine(void)
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
-	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
-
-	i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
 	i2c_register_board_info(2, mop500_i2c2_devices,
 				ARRAY_SIZE(mop500_i2c2_devices));
 
@@ -317,7 +277,6 @@ static void __init snowball_init_machine(void)
 static void __init hrefv60_init_machine(void)
 {
 	struct device *parent = NULL;
-	int i2c0_devs;
 	int i;
 
 	platform_device_register(&db8500_prcmu_device);
@@ -342,11 +301,6 @@ static void __init hrefv60_init_machine(void)
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
-	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
-
-	i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
-
-	i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
 	i2c_register_board_info(2, mop500_i2c2_devices,
 				ARRAY_SIZE(mop500_i2c2_devices));
 
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 3bd9b6e..cfc553c 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -98,7 +98,6 @@ extern struct stedma40_platform_data dma40_plat_data;
 extern void mop500_sdi_init(struct device *parent);
 extern void snowball_sdi_init(struct device *parent);
 extern void hrefv60_sdi_init(struct device *parent);
-extern void mop500_sdi_tc35892_init(struct device *parent);
 void __init mop500_u8500uib_init(void);
 void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
-- 
1.8.1.2

