Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3HWMYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:36 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35986 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3HWMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/40] ARM: ux500: Remove USB support when booting using ATAGs
Date: Fri, 23 Aug 2013 13:23:20 +0100
Message-Id: <1377260620-18829-21-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/Makefile         |   2 +-
 arch/arm/mach-ux500/cpu-db8500.c     |  12 ----
 arch/arm/mach-ux500/devices-db8500.h |   5 --
 arch/arm/mach-ux500/usb.c            | 135 -----------------------------------
 4 files changed, 1 insertion(+), 153 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/usb.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index bf9b6be..cac22ba 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y				:= cpu.o devices.o devices-common.o \
-				   id.o usb.o timer.o pm.o
+				   id.o timer.o pm.o
 obj-$(CONFIG_CPU_IDLE)          += cpuidle.o
 obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
 obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 12eee81..30024ff 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -162,17 +162,6 @@ static void __init db8500_add_gpios(struct device *parent)
 	dbx500_add_pinctrl(parent, "pinctrl-db8500", U8500_PRCMU_BASE);
 }
 
-static int usb_db8500_dma_cfg[] = {
-	DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9,
-	DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10,
-	DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11,
-	DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12,
-	DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13,
-	DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14,
-	DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15,
-	DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8
-};
-
 static const char *db8500_read_soc_id(void)
 {
 	void __iomem *uid = __io_address(U8500_BB_UID_BASE);
@@ -204,7 +193,6 @@ struct device * __init u8500_init_devices(void)
 
 	db8500_add_rtc(parent);
 	db8500_add_gpios(parent);
-	db8500_add_usb(parent, usb_db8500_dma_cfg, usb_db8500_dma_cfg);
 
 	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
 		platform_devs[i]->dev.parent = parent;
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index be1d538..9352400 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -8,7 +8,6 @@
 #ifndef __DEVICES_DB8500_H
 #define __DEVICES_DB8500_H
 
-#include <linux/platform_data/usb-musb-ux500.h>
 #include "irqs.h"
 #include "db8500-regs.h"
 #include "devices-common.h"
@@ -30,10 +29,6 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 #define db8500_add_rtc(parent) \
 	dbx500_add_rtc(parent, U8500_RTC_BASE, IRQ_DB8500_RTC);
 
-#define db8500_add_usb(parent, rx_cfg, tx_cfg) \
-	ux500_add_usb(parent, U8500_USBOTG_BASE, \
-		      IRQ_DB8500_USBOTG, rx_cfg, tx_cfg)
-
 #define db8500_add_ssp0(parent, pdata) \
 	db8500_add_ssp(parent, "ssp0", U8500_SSP0_BASE, \
 		       IRQ_DB8500_SSP0, pdata)
diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
deleted file mode 100644
index b7bd8d3..0000000
--- a/arch/arm/mach-ux500/usb.c
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2011
- *
- * Author: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
- * License terms: GNU General Public License (GPL) version 2
- */
-#include <linux/platform_device.h>
-#include <linux/usb/musb.h>
-#include <linux/dma-mapping.h>
-#include <linux/platform_data/usb-musb-ux500.h>
-#include <linux/platform_data/dma-ste-dma40.h>
-
-#include "db8500-regs.h"
-
-#define MUSB_DMA40_RX_CH { \
-		.mode = STEDMA40_MODE_LOGICAL, \
-		.dir = DMA_DEV_TO_MEM, \
-	}
-
-#define MUSB_DMA40_TX_CH { \
-		.mode = STEDMA40_MODE_LOGICAL, \
-		.dir = DMA_MEM_TO_DEV, \
-	}
-
-static struct stedma40_chan_cfg musb_dma_rx_ch[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS]
-	= {
-	MUSB_DMA40_RX_CH,
-	MUSB_DMA40_RX_CH,
-	MUSB_DMA40_RX_CH,
-	MUSB_DMA40_RX_CH,
-	MUSB_DMA40_RX_CH,
-	MUSB_DMA40_RX_CH,
-	MUSB_DMA40_RX_CH,
-	MUSB_DMA40_RX_CH
-};
-
-static struct stedma40_chan_cfg musb_dma_tx_ch[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS]
-	= {
-	MUSB_DMA40_TX_CH,
-	MUSB_DMA40_TX_CH,
-	MUSB_DMA40_TX_CH,
-	MUSB_DMA40_TX_CH,
-	MUSB_DMA40_TX_CH,
-	MUSB_DMA40_TX_CH,
-	MUSB_DMA40_TX_CH,
-	MUSB_DMA40_TX_CH,
-};
-
-static void *ux500_dma_rx_param_array[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS] = {
-	&musb_dma_rx_ch[0],
-	&musb_dma_rx_ch[1],
-	&musb_dma_rx_ch[2],
-	&musb_dma_rx_ch[3],
-	&musb_dma_rx_ch[4],
-	&musb_dma_rx_ch[5],
-	&musb_dma_rx_ch[6],
-	&musb_dma_rx_ch[7]
-};
-
-static void *ux500_dma_tx_param_array[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS] = {
-	&musb_dma_tx_ch[0],
-	&musb_dma_tx_ch[1],
-	&musb_dma_tx_ch[2],
-	&musb_dma_tx_ch[3],
-	&musb_dma_tx_ch[4],
-	&musb_dma_tx_ch[5],
-	&musb_dma_tx_ch[6],
-	&musb_dma_tx_ch[7]
-};
-
-static struct ux500_musb_board_data musb_board_data = {
-	.dma_rx_param_array = ux500_dma_rx_param_array,
-	.dma_tx_param_array = ux500_dma_tx_param_array,
-	.dma_filter = stedma40_filter,
-};
-
-static struct musb_hdrc_platform_data musb_platform_data = {
-	.mode = MUSB_OTG,
-	.board_data = &musb_board_data,
-};
-
-static struct resource usb_resources[] = {
-	[0] = {
-		.name	= "usb-mem",
-		.flags	=  IORESOURCE_MEM,
-	},
-
-	[1] = {
-		.name   = "mc", /* hard-coded in musb */
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device ux500_musb_device = {
-	.name = "musb-ux500",
-	.id = 0,
-	.dev = {
-		.platform_data = &musb_platform_data,
-		.coherent_dma_mask = DMA_BIT_MASK(32),
-	},
-	.num_resources = ARRAY_SIZE(usb_resources),
-	.resource = usb_resources,
-};
-
-static inline void ux500_usb_dma_update_rx_ch_config(int *dev_type)
-{
-	u32 idx;
-
-	for (idx = 0; idx < UX500_MUSB_DMA_NUM_RX_TX_CHANNELS; idx++)
-		musb_dma_rx_ch[idx].dev_type = dev_type[idx];
-}
-
-static inline void ux500_usb_dma_update_tx_ch_config(int *dev_type)
-{
-	u32 idx;
-
-	for (idx = 0; idx < UX500_MUSB_DMA_NUM_RX_TX_CHANNELS; idx++)
-		musb_dma_tx_ch[idx].dev_type = dev_type[idx];
-}
-
-void ux500_add_usb(struct device *parent, resource_size_t base, int irq,
-		   int *dma_rx_cfg, int *dma_tx_cfg)
-{
-	ux500_musb_device.resource[0].start = base;
-	ux500_musb_device.resource[0].end = base + SZ_64K - 1;
-	ux500_musb_device.resource[1].start = irq;
-	ux500_musb_device.resource[1].end = irq;
-
-	ux500_usb_dma_update_rx_ch_config(dma_rx_cfg);
-	ux500_usb_dma_update_tx_ch_config(dma_tx_cfg);
-
-	ux500_musb_device.dev.parent = parent;
-
-	platform_device_register(&ux500_musb_device);
-}
-- 
1.8.1.2

