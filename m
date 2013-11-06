Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab3KFKGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:06:12 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57715 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3KFKGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:06:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/7] ARM: ux500: Remove ATAG support for SDI (MMC)
Date: Wed,  6 Nov 2013 10:05:44 +0000
Message-Id: <1383732348-18576-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hasn't been used since we moved over to a Device Tree only platform.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Makefile           |   3 +-
 arch/arm/mach-ux500/board-mop500-sdi.c | 166 ---------------------------------
 arch/arm/mach-ux500/board-mop500.h     |   4 -
 3 files changed, 1 insertion(+), 172 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/board-mop500-sdi.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 66f351f..e34c010 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -5,8 +5,7 @@
 obj-y				:= cpu.o devices.o id.o timer.o pm.o
 obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
 obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o
-obj-$(CONFIG_MACH_MOP500)	+= board-mop500-sdi.o \
-				board-mop500-regulators.o \
+obj-$(CONFIG_MACH_MOP500)	+= board-mop500-regulators.o \
 				board-mop500-pins.o \
 				board-mop500-audio.o
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
deleted file mode 100644
index fcbf3a1..0000000
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ /dev/null
@@ -1,166 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Hanumath Prasad <hanumath.prasad@stericsson.com>
- * License terms: GNU General Public License (GPL) version 2
- */
-
-#include <linux/kernel.h>
-#include <linux/gpio.h>
-#include <linux/amba/bus.h>
-#include <linux/amba/mmci.h>
-#include <linux/mmc/host.h>
-#include <linux/platform_device.h>
-#include <linux/platform_data/dma-ste-dma40.h>
-
-#include <asm/mach-types.h>
-
-#include "db8500-regs.h"
-#include "board-mop500.h"
-#include "ste-dma40-db8500.h"
-
-/*
- * v2 has a new version of this block that need to be forced, the number found
- * in hardware is incorrect
- */
-#define U8500_SDI_V2_PERIPHID 0x10480180
-
-/*
- * SDI 0 (MicroSD slot)
- */
-
-#ifdef CONFIG_STE_DMA40
-struct stedma40_chan_cfg mop500_sdi0_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type = DB8500_DMA_DEV29_SD_MM0,
-};
-
-static struct stedma40_chan_cfg mop500_sdi0_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV29_SD_MM0,
-};
-#endif
-
-struct mmci_platform_data mop500_sdi0_data = {
-	.f_max		= 100000000,
-	.capabilities	= MMC_CAP_4_BIT_DATA |
-				MMC_CAP_SD_HIGHSPEED |
-				MMC_CAP_MMC_HIGHSPEED |
-				MMC_CAP_ERASE |
-				MMC_CAP_UHS_SDR12 |
-				MMC_CAP_UHS_SDR25,
-	.gpio_wp	= -1,
-	.sigdir		= MCI_ST_FBCLKEN |
-				MCI_ST_CMDDIREN |
-				MCI_ST_DATA0DIREN |
-				MCI_ST_DATA2DIREN,
-#ifdef CONFIG_STE_DMA40
-	.dma_filter	= stedma40_filter,
-	.dma_rx_param	= &mop500_sdi0_dma_cfg_rx,
-	.dma_tx_param	= &mop500_sdi0_dma_cfg_tx,
-#endif
-};
-
-/*
- * SDI1 (SDIO WLAN)
- */
-#ifdef CONFIG_STE_DMA40
-static struct stedma40_chan_cfg sdi1_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type = DB8500_DMA_DEV32_SD_MM1,
-};
-
-static struct stedma40_chan_cfg sdi1_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV32_SD_MM1,
-};
-#endif
-
-struct mmci_platform_data mop500_sdi1_data = {
-	.ocr_mask	= MMC_VDD_29_30,
-	.f_max		= 100000000,
-	.capabilities	= MMC_CAP_4_BIT_DATA |
-				MMC_CAP_NONREMOVABLE,
-	.gpio_cd	= -1,
-	.gpio_wp	= -1,
-#ifdef CONFIG_STE_DMA40
-	.dma_filter	= stedma40_filter,
-	.dma_rx_param	= &sdi1_dma_cfg_rx,
-	.dma_tx_param	= &sdi1_dma_cfg_tx,
-#endif
-};
-
-/*
- * SDI 2 (POP eMMC, not on DB8500ed)
- */
-
-#ifdef CONFIG_STE_DMA40
-struct stedma40_chan_cfg mop500_sdi2_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type =  DB8500_DMA_DEV28_SD_MM2,
-};
-
-static struct stedma40_chan_cfg mop500_sdi2_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV28_SD_MM2,
-};
-#endif
-
-struct mmci_platform_data mop500_sdi2_data = {
-	.ocr_mask	= MMC_VDD_165_195,
-	.f_max		= 100000000,
-	.capabilities	= MMC_CAP_4_BIT_DATA |
-				MMC_CAP_8_BIT_DATA |
-				MMC_CAP_NONREMOVABLE |
-				MMC_CAP_MMC_HIGHSPEED |
-				MMC_CAP_ERASE |
-				MMC_CAP_CMD23,
-	.gpio_cd	= -1,
-	.gpio_wp	= -1,
-#ifdef CONFIG_STE_DMA40
-	.dma_filter	= stedma40_filter,
-	.dma_rx_param	= &mop500_sdi2_dma_cfg_rx,
-	.dma_tx_param	= &mop500_sdi2_dma_cfg_tx,
-#endif
-};
-
-/*
- * SDI 4 (on-board eMMC)
- */
-
-#ifdef CONFIG_STE_DMA40
-struct stedma40_chan_cfg mop500_sdi4_dma_cfg_rx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_DEV_TO_MEM,
-	.dev_type =  DB8500_DMA_DEV42_SD_MM4,
-};
-
-static struct stedma40_chan_cfg mop500_sdi4_dma_cfg_tx = {
-	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = DMA_MEM_TO_DEV,
-	.dev_type = DB8500_DMA_DEV42_SD_MM4,
-};
-#endif
-
-struct mmci_platform_data mop500_sdi4_data = {
-	.f_max		= 100000000,
-	.capabilities	= MMC_CAP_4_BIT_DATA |
-				MMC_CAP_8_BIT_DATA |
-				MMC_CAP_NONREMOVABLE |
-				MMC_CAP_MMC_HIGHSPEED |
-				MMC_CAP_ERASE |
-				MMC_CAP_CMD23,
-	.gpio_cd	= -1,
-	.gpio_wp	= -1,
-#ifdef CONFIG_STE_DMA40
-	.dma_filter	= stedma40_filter,
-	.dma_rx_param	= &mop500_sdi4_dma_cfg_rx,
-	.dma_tx_param	= &mop500_sdi4_dma_cfg_tx,
-#endif
-};
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index d48e866..78861f6 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -79,10 +79,6 @@
 #define SNOWBALL_EN_3V3_ETH_GPIO	MOP500_AB8500_PIN_GPIO(26)	/* GPIO26 */
 
 struct device;
-extern struct mmci_platform_data mop500_sdi0_data;
-extern struct mmci_platform_data mop500_sdi1_data;
-extern struct mmci_platform_data mop500_sdi2_data;
-extern struct mmci_platform_data mop500_sdi4_data;
 extern struct msp_i2s_platform_data msp0_platform_data;
 extern struct msp_i2s_platform_data msp1_platform_data;
 extern struct msp_i2s_platform_data msp2_platform_data;
-- 
1.8.1.2

