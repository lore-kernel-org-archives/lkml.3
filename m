Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3HWMcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:32:52 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41482 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3HWMYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/40] ARM: ux500: Deactivate Crypt support when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:10 +0100
Message-Id: <1377260620-18829-11-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c   | 15 ---------------
 arch/arm/mach-ux500/devices-common.h | 26 --------------------------
 arch/arm/mach-ux500/devices-db8500.h |  2 --
 arch/arm/mach-ux500/devices.h        |  1 -
 4 files changed, 44 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index b8b5ebe..f75ac95 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -45,7 +45,6 @@
 #include "setup.h"
 #include "devices.h"
 #include "irqs.h"
-#include <linux/platform_data/crypto-ux500.h>
 
 #include "ste-dma40-db8500.h"
 #include "db8500-regs.h"
@@ -174,19 +173,6 @@ static void mop500_prox_deactivate(struct device *dev)
 	regulator_put(prox_regulator);
 }
 
-static struct cryp_platform_data u8500_cryp1_platform_data = {
-		.mem_to_engine = {
-				.dir = DMA_MEM_TO_DEV,
-				.dev_type = DB8500_DMA_DEV48_CAC1,
-				.mode = STEDMA40_MODE_LOGICAL,
-		},
-		.engine_to_mem = {
-				.dir = DMA_DEV_TO_MEM,
-				.dev_type = DB8500_DMA_DEV48_CAC1,
-				.mode = STEDMA40_MODE_LOGICAL,
-		}
-};
-
 static struct stedma40_chan_cfg u8500_hash_dma_cfg_tx = {
 		.dir = DMA_MEM_TO_DEV,
 		.dev_type = DB8500_DMA_DEV50_HAC1_TX,
@@ -309,7 +295,6 @@ static void __init mop500_uart_init(struct device *parent)
 
 static void __init u8500_cryp1_hash1_init(struct device *parent)
 {
-	db8500_add_cryp1(parent, &u8500_cryp1_platform_data);
 	db8500_add_hash1(parent, &u8500_hash1_platform_data);
 }
 
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 7eb1272..b32f179 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -13,7 +13,6 @@
 #include <linux/sys_soc.h>
 #include <linux/amba/bus.h>
 #include <linux/platform_data/i2c-nomadik.h>
-#include <linux/platform_data/crypto-ux500.h>
 
 struct spi_master_cntlr;
 
@@ -65,31 +64,6 @@ dbx500_add_rtc(struct device *parent, resource_size_t base, int irq)
 				0, NULL, 0);
 }
 
-struct cryp_platform_data;
-
-static inline struct platform_device *
-dbx500_add_cryp1(struct device *parent, int id, resource_size_t base, int irq,
-		struct cryp_platform_data *pdata)
-{
-	struct resource res[] = {
-			DEFINE_RES_MEM(base, SZ_4K),
-			DEFINE_RES_IRQ(irq),
-	};
-
-	struct platform_device_info pdevinfo = {
-			.parent = parent,
-			.name = "cryp1",
-			.id = id,
-			.res = res,
-			.num_res = ARRAY_SIZE(res),
-			.data = pdata,
-			.size_data = sizeof(*pdata),
-			.dma_mask = DMA_BIT_MASK(32),
-	};
-
-	return platform_device_register_full(&pdevinfo);
-}
-
 struct hash_platform_data;
 
 static inline struct platform_device *
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index c393932..7331b7e 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -109,8 +109,6 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 	dbx500_add_uart(parent, "uart2", U8500_UART2_BASE, \
 			IRQ_DB8500_UART2, pdata)
 
-#define db8500_add_cryp1(parent, pdata) \
-	dbx500_add_cryp1(parent, -1, U8500_CRYP1_BASE, IRQ_DB8500_CRYP1, pdata)
 #define db8500_add_hash1(parent, pdata) \
 	dbx500_add_hash1(parent, -1, U8500_HASH1_BASE, pdata)
 #endif
diff --git a/arch/arm/mach-ux500/devices.h b/arch/arm/mach-ux500/devices.h
index cbc6f1e..a5183e3 100644
--- a/arch/arm/mach-ux500/devices.h
+++ b/arch/arm/mach-ux500/devices.h
@@ -15,7 +15,6 @@ extern struct platform_device u8500_gpio_devs[];
 extern struct amba_device ux500_pl031_device;
 
 extern struct platform_device ux500_hash1_device;
-extern struct platform_device ux500_cryp1_device;
 
 extern struct platform_device u8500_dma40_device;
 extern struct platform_device ux500_ske_keypad_device;
-- 
1.8.1.2

