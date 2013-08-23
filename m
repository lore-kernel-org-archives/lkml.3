Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab3HWMYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:45 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:35591 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3HWMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/40] ARM: ux500: Rip out SSP/SPI registration when not booting with Device Tree
Date: Fri, 23 Aug 2013 13:23:26 +0100
Message-Id: <1377260620-18829-27-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c   |  9 ---------
 arch/arm/mach-ux500/devices-common.h | 11 -----------
 arch/arm/mach-ux500/devices-db8500.h | 28 ----------------------------
 3 files changed, 48 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 7763c5b..939ba22 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -18,7 +18,6 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
 #include <linux/amba/serial.h>
-#include <linux/spi/spi.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
 #include <linux/regulator/fixed.h>
@@ -80,11 +79,6 @@ struct pl022_ssp_controller ssp0_plat = {
 	.num_chipselect = 5,
 };
 
-static void __init mop500_spi_init(struct device *parent)
-{
-	db8500_add_ssp0(parent, &ssp0_plat);
-}
-
 #ifdef CONFIG_STE_DMA40
 static struct stedma40_chan_cfg uart0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
@@ -163,7 +157,6 @@ static void __init mop500_init_machine(void)
 	mop500_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
 	/* This board has full regulator constraints */
@@ -179,7 +172,6 @@ static void __init snowball_init_machine(void)
 	snowball_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
 	/* This board has full regulator constraints */
@@ -195,7 +187,6 @@ static void __init hrefv60_init_machine(void)
 	hrefv60_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
 	/* This board has full regulator constraints */
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index ce48a02..15bf1ab 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -13,17 +13,6 @@
 #include <linux/sys_soc.h>
 #include <linux/amba/bus.h>
 
-struct spi_master_cntlr;
-
-static inline struct amba_device *
-dbx500_add_spi(struct device *parent, const char *name, resource_size_t base,
-	       int irq, struct spi_master_cntlr *pdata,
-	       u32 periphid)
-{
-	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0,
-				   pdata, periphid);
-}
-
 struct amba_pl011_data;
 
 static inline struct amba_device *
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 0b523b5..e6ac6d2 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -12,40 +12,12 @@
 #include "db8500-regs.h"
 #include "devices-common.h"
 
-struct pl022_ssp_controller;
 struct platform_device;
 
 extern struct ab8500_platform_data ab8500_platdata;
 extern struct prcmu_pdata db8500_prcmu_pdata;
 extern struct platform_device db8500_prcmu_device;
 
-static inline struct amba_device *
-db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
-	       int irq, struct pl022_ssp_controller *pdata)
-{
-	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0, pdata, 0);
-}
-
-#define db8500_add_ssp0(parent, pdata) \
-	db8500_add_ssp(parent, "ssp0", U8500_SSP0_BASE, \
-		       IRQ_DB8500_SSP0, pdata)
-#define db8500_add_ssp1(parent, pdata) \
-	db8500_add_ssp(parent, "ssp1", U8500_SSP1_BASE, \
-		       IRQ_DB8500_SSP1, pdata)
-
-#define db8500_add_spi0(parent, pdata) \
-	dbx500_add_spi(parent, "spi0", U8500_SPI0_BASE, \
-		       IRQ_DB8500_SPI0, pdata, 0)
-#define db8500_add_spi1(parent, pdata) \
-	dbx500_add_spi(parent, "spi1", U8500_SPI1_BASE, \
-		       IRQ_DB8500_SPI1, pdata, 0)
-#define db8500_add_spi2(parent, pdata) \
-	dbx500_add_spi(parent, "spi2", U8500_SPI2_BASE, \
-		       IRQ_DB8500_SPI2, pdata, 0)
-#define db8500_add_spi3(parent, pdata) \
-	dbx500_add_spi(parent, "spi3", U8500_SPI3_BASE, \
-		       IRQ_DB8500_SPI3, pdata, 0)
-
 #define db8500_add_uart0(parent, pdata) \
 	dbx500_add_uart(parent, "uart0", U8500_UART0_BASE, \
 			IRQ_DB8500_UART0, pdata)
-- 
1.8.1.2

