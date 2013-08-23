Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3HWMYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:49 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34510 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3HWMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/40] ARM: ux500: Remove UART support when booting without Device Tree
Date: Fri, 23 Aug 2013 13:23:28 +0100
Message-Id: <1377260620-18829-29-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c   | 76 ------------------------------------
 arch/arm/mach-ux500/board-mop500.h   |  3 --
 arch/arm/mach-ux500/devices-common.h | 10 -----
 arch/arm/mach-ux500/devices-db8500.h | 10 -----
 4 files changed, 99 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 0ae083b..db6908a 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -17,7 +17,6 @@
 #include <linux/platform_data/db8500_thermal.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
-#include <linux/amba/serial.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
 #include <linux/regulator/fixed.h>
@@ -79,75 +78,6 @@ struct pl022_ssp_controller ssp0_plat = {
 	.num_chipselect = 5,
 };
 
-#ifdef CONFIG_STE_DMA40
-static struct stedma40_chan_cfg uart0_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type = DB8500_DMA_DEV13_UART0,
-};
-
-static struct stedma40_chan_cfg uart0_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV13_UART0,
-};
-
-static struct stedma40_chan_cfg uart1_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type = DB8500_DMA_DEV12_UART1,
-};
-
-static struct stedma40_chan_cfg uart1_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV12_UART1,
-};
-
-static struct stedma40_chan_cfg uart2_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type = DB8500_DMA_DEV11_UART2,
-};
-
-static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV11_UART2,
-};
-#endif
-
-struct amba_pl011_data uart0_plat = {
-#ifdef CONFIG_STE_DMA40
-	.dma_filter = stedma40_filter,
-	.dma_rx_param = &uart0_dma_cfg_rx,
-	.dma_tx_param = &uart0_dma_cfg_tx,
-#endif
-};
-
-struct amba_pl011_data uart1_plat = {
-#ifdef CONFIG_STE_DMA40
-	.dma_filter = stedma40_filter,
-	.dma_rx_param = &uart1_dma_cfg_rx,
-	.dma_tx_param = &uart1_dma_cfg_tx,
-#endif
-};
-
-struct amba_pl011_data uart2_plat = {
-#ifdef CONFIG_STE_DMA40
-	.dma_filter = stedma40_filter,
-	.dma_rx_param = &uart2_dma_cfg_rx,
-	.dma_tx_param = &uart2_dma_cfg_tx,
-#endif
-};
-
-static void __init mop500_uart_init(struct device *parent)
-{
-	db8500_add_uart0(parent, &uart0_plat);
-	db8500_add_uart1(parent, &uart1_plat);
-	db8500_add_uart2(parent, &uart2_plat);
-}
-
 static void __init mop500_init_machine(void)
 {
 	struct device *parent = NULL;
@@ -156,8 +86,6 @@ static void __init mop500_init_machine(void)
 
 	parent = u8500_init_devices();
 
-	mop500_uart_init(parent);
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
@@ -170,8 +98,6 @@ static void __init snowball_init_machine(void)
 
 	parent = u8500_init_devices();
 
-	mop500_uart_init(parent);
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
@@ -184,8 +110,6 @@ static void __init hrefv60_init_machine(void)
 
 	parent = u8500_init_devices();
 
-	mop500_uart_init(parent);
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 2cced8b..cf6b304 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -87,9 +87,6 @@ extern struct msp_i2s_platform_data msp0_platform_data;
 extern struct msp_i2s_platform_data msp1_platform_data;
 extern struct msp_i2s_platform_data msp2_platform_data;
 extern struct msp_i2s_platform_data msp3_platform_data;
-extern struct amba_pl011_data uart0_plat;
-extern struct amba_pl011_data uart1_plat;
-extern struct amba_pl011_data uart2_plat;
 extern struct pl022_ssp_controller ssp0_plat;
 
 void __init mop500_u8500uib_init(void);
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 15bf1ab..f3f7349 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -11,15 +11,5 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/sys_soc.h>
-#include <linux/amba/bus.h>
-
-struct amba_pl011_data;
-
-static inline struct amba_device *
-dbx500_add_uart(struct device *parent, const char *name, resource_size_t base,
-		int irq, struct amba_pl011_data *pdata)
-{
-	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0, pdata, 0);
-}
 
 #endif
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index e6ac6d2..fc4048f 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -18,14 +18,4 @@ extern struct ab8500_platform_data ab8500_platdata;
 extern struct prcmu_pdata db8500_prcmu_pdata;
 extern struct platform_device db8500_prcmu_device;
 
-#define db8500_add_uart0(parent, pdata) \
-	dbx500_add_uart(parent, "uart0", U8500_UART0_BASE, \
-			IRQ_DB8500_UART0, pdata)
-#define db8500_add_uart1(parent, pdata) \
-	dbx500_add_uart(parent, "uart1", U8500_UART1_BASE, \
-			IRQ_DB8500_UART1, pdata)
-#define db8500_add_uart2(parent, pdata) \
-	dbx500_add_uart(parent, "uart2", U8500_UART2_BASE, \
-			IRQ_DB8500_UART2, pdata)
-
 #endif
-- 
1.8.1.2

