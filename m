Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3HWMcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:32:07 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52661 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3HWMYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/40] ARM: ux500: Rip out Hash support when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:11 +0100
Message-Id: <1377260620-18829-12-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c   | 20 --------------------
 arch/arm/mach-ux500/devices-common.h | 24 ------------------------
 arch/arm/mach-ux500/devices-db8500.h |  2 --
 arch/arm/mach-ux500/devices.h        |  2 --
 4 files changed, 48 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index f75ac95..fec8733 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -173,17 +173,6 @@ static void mop500_prox_deactivate(struct device *dev)
 	regulator_put(prox_regulator);
 }
 
-static struct stedma40_chan_cfg u8500_hash_dma_cfg_tx = {
-		.dir = DMA_MEM_TO_DEV,
-		.dev_type = DB8500_DMA_DEV50_HAC1_TX,
-		.mode = STEDMA40_MODE_LOGICAL,
-};
-
-static struct hash_platform_data u8500_hash1_platform_data = {
-		.mem_to_engine = &u8500_hash_dma_cfg_tx,
-		.dma_filter = stedma40_filter,
-};
-
 /* add any platform devices here - TODO */
 static struct platform_device *mop500_platform_devs[] __initdata = {
 	&mop500_gpio_keys_device,
@@ -293,11 +282,6 @@ static void __init mop500_uart_init(struct device *parent)
 	db8500_add_uart2(parent, &uart2_plat);
 }
 
-static void __init u8500_cryp1_hash1_init(struct device *parent)
-{
-	db8500_add_hash1(parent, &u8500_hash1_platform_data);
-}
-
 static void __init mop500_init_machine(void)
 {
 	struct device *parent = NULL;
@@ -321,8 +305,6 @@ static void __init mop500_init_machine(void)
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
-	u8500_cryp1_hash1_init(parent);
-
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 
 	i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
@@ -347,8 +329,6 @@ static void __init snowball_init_machine(void)
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
-	u8500_cryp1_hash1_init(parent);
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index b32f179..04fa009 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -64,30 +64,6 @@ dbx500_add_rtc(struct device *parent, resource_size_t base, int irq)
 				0, NULL, 0);
 }
 
-struct hash_platform_data;
-
-static inline struct platform_device *
-dbx500_add_hash1(struct device *parent, int id, resource_size_t base,
-		struct hash_platform_data *pdata)
-{
-	struct resource res[] = {
-			DEFINE_RES_MEM(base, SZ_4K),
-	};
-
-	struct platform_device_info pdevinfo = {
-			.parent = parent,
-			.name = "hash1",
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
 struct nmk_gpio_platform_data;
 
 void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 7331b7e..3d32668 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -109,6 +109,4 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 	dbx500_add_uart(parent, "uart2", U8500_UART2_BASE, \
 			IRQ_DB8500_UART2, pdata)
 
-#define db8500_add_hash1(parent, pdata) \
-	dbx500_add_hash1(parent, -1, U8500_HASH1_BASE, pdata)
 #endif
diff --git a/arch/arm/mach-ux500/devices.h b/arch/arm/mach-ux500/devices.h
index a5183e3..9b5eb69 100644
--- a/arch/arm/mach-ux500/devices.h
+++ b/arch/arm/mach-ux500/devices.h
@@ -14,8 +14,6 @@ extern struct platform_device u8500_gpio_devs[];
 
 extern struct amba_device ux500_pl031_device;
 
-extern struct platform_device ux500_hash1_device;
-
 extern struct platform_device u8500_dma40_device;
 extern struct platform_device ux500_ske_keypad_device;
 
-- 
1.8.1.2

