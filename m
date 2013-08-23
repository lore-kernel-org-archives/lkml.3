Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3HWMa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:30:56 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:49055 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3HWMY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/40] ARM: ux500: Remove I2C support when booting with ATAG support
Date: Fri, 23 Aug 2013 13:23:17 +0100
Message-Id: <1377260620-18829-18-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c   | 13 -------------
 arch/arm/mach-ux500/board-mop500.h   |  1 -
 arch/arm/mach-ux500/devices-common.h | 14 --------------
 arch/arm/mach-ux500/devices-db8500.h | 11 -----------
 4 files changed, 39 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index fd1e0bc..447d37d 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -14,8 +14,6 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
-#include <linux/i2c.h>
-#include <linux/platform_data/i2c-nomadik.h>
 #include <linux/platform_data/db8500_thermal.h>
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
@@ -54,14 +52,6 @@ struct ab8500_platform_data ab8500_platdata = {
 	.regulator	= &ab8500_regulator_plat_data,
 };
 
-static void __init mop500_i2c_init(struct device *parent)
-{
-	db8500_add_i2c0(parent, NULL);
-	db8500_add_i2c1(parent, NULL);
-	db8500_add_i2c2(parent, NULL);
-	db8500_add_i2c3(parent, NULL);
-}
-
 #ifdef CONFIG_STE_DMA40
 static struct stedma40_chan_cfg ssp0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
@@ -175,7 +165,6 @@ static void __init mop500_init_machine(void)
 	mop500_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_i2c_init(parent);
 	mop500_sdi_init(parent);
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
@@ -193,7 +182,6 @@ static void __init snowball_init_machine(void)
 	snowball_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_i2c_init(parent);
 	snowball_sdi_init(parent);
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
@@ -211,7 +199,6 @@ static void __init hrefv60_init_machine(void)
 	hrefv60_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_i2c_init(parent);
 	hrefv60_sdi_init(parent);
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index cfc553c..341fad1 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -79,7 +79,6 @@
 #define SNOWBALL_EN_3V3_ETH_GPIO	MOP500_AB8500_PIN_GPIO(26)	/* GPIO26 */
 
 struct device;
-struct i2c_board_info;
 extern struct mmci_platform_data mop500_sdi0_data;
 extern struct mmci_platform_data mop500_sdi1_data;
 extern struct mmci_platform_data mop500_sdi2_data;
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 04fa009..34ec2f7 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -12,7 +12,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/sys_soc.h>
 #include <linux/amba/bus.h>
-#include <linux/platform_data/i2c-nomadik.h>
 
 struct spi_master_cntlr;
 
@@ -44,19 +43,6 @@ dbx500_add_uart(struct device *parent, const char *name, resource_size_t base,
 	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0, pdata, 0);
 }
 
-struct nmk_i2c_controller;
-
-static inline struct amba_device *
-dbx500_add_i2c(struct device *parent, int id, resource_size_t base, int irq,
-	       struct nmk_i2c_controller *data)
-{
-	/* Conjure a name similar to what the platform device used to have */
-	char name[16];
-
-	snprintf(name, sizeof(name), "nmk-i2c.%d", id);
-	return amba_apb_device_add(parent, name, base, SZ_4K, irq, 0, data, 0);
-}
-
 static inline struct amba_device *
 dbx500_add_rtc(struct device *parent, resource_size_t base, int irq)
 {
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 3d32668..64667f6 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -42,17 +42,6 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0, pdata, 0);
 }
 
-#define db8500_add_i2c0(parent, pdata) \
-	dbx500_add_i2c(parent, 0, U8500_I2C0_BASE, IRQ_DB8500_I2C0, pdata)
-#define db8500_add_i2c1(parent, pdata) \
-	dbx500_add_i2c(parent, 1, U8500_I2C1_BASE, IRQ_DB8500_I2C1, pdata)
-#define db8500_add_i2c2(parent, pdata) \
-	dbx500_add_i2c(parent, 2, U8500_I2C2_BASE, IRQ_DB8500_I2C2, pdata)
-#define db8500_add_i2c3(parent, pdata) \
-	dbx500_add_i2c(parent, 3, U8500_I2C3_BASE, IRQ_DB8500_I2C3, pdata)
-#define db8500_add_i2c4(parent, pdata) \
-	dbx500_add_i2c(parent, 4, U8500_I2C4_BASE, IRQ_DB8500_I2C4, pdata)
-
 #define db8500_add_rtc(parent) \
 	dbx500_add_rtc(parent, U8500_RTC_BASE, IRQ_DB8500_RTC);
 
-- 
1.8.1.2

