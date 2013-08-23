Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3HWMX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:23:58 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43191 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3HWMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:23:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/40] ARM: ux500: Remove Audio/MSP support when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:01 +0100
Message-Id: <1377260620-18829-2-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500-audio.c | 50 --------------------------------
 arch/arm/mach-ux500/board-mop500.c       |  3 --
 arch/arm/mach-ux500/board-mop500.h       |  1 -
 arch/arm/mach-ux500/devices-common.h     |  9 ------
 arch/arm/mach-ux500/devices-db8500.h     | 13 ---------
 5 files changed, 76 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
index bfe443d..89f7f92 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -69,40 +69,6 @@ static struct stedma40_chan_cfg msp2_dma_tx = {
 	.phy_channel = 1,
 };
 
-static struct platform_device *db8500_add_msp_i2s(struct device *parent,
-			int id,
-			resource_size_t base, int irq,
-			struct msp_i2s_platform_data *pdata)
-{
-	struct platform_device *pdev;
-	struct resource res[] = {
-		DEFINE_RES_MEM(base, SZ_4K),
-		DEFINE_RES_IRQ(irq),
-	};
-
-	pr_info("Register platform-device 'ux500-msp-i2s', id %d, irq %d\n",
-		id, irq);
-	pdev = platform_device_register_resndata(parent, "ux500-msp-i2s", id,
-						res, ARRAY_SIZE(res),
-						pdata, sizeof(*pdata));
-	if (!pdev) {
-		pr_err("Failed to register platform-device 'ux500-msp-i2s.%d'!\n",
-			id);
-		return NULL;
-	}
-
-	return pdev;
-}
-
-/* Platform device for ASoC MOP500 machine */
-static struct platform_device snd_soc_mop500 = {
-	.name = "snd-soc-mop500",
-	.id = 0,
-	.dev = {
-		.platform_data = NULL,
-	},
-};
-
 struct msp_i2s_platform_data msp2_platform_data = {
 	.id = MSP_I2S_2,
 	.msp_i2s_dma_rx = &msp2_dma_rx,
@@ -114,19 +80,3 @@ struct msp_i2s_platform_data msp3_platform_data = {
 	.msp_i2s_dma_rx	= &msp1_dma_rx,
 	.msp_i2s_dma_tx	= NULL,
 };
-
-void mop500_audio_init(struct device *parent)
-{
-	pr_info("%s: Register platform-device 'snd-soc-mop500'.\n", __func__);
-	platform_device_register(&snd_soc_mop500);
-
-	pr_info("Initialize MSP I2S-devices.\n");
-	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
-			   &msp0_platform_data);
-	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
-			   &msp1_platform_data);
-	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
-			   &msp2_platform_data);
-	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
-			   &msp3_platform_data);
-}
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index df5d27a..4fe6aa0 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -586,7 +586,6 @@ static void __init mop500_init_machine(void)
 	mop500_i2c_init(parent);
 	mop500_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	u8500_cryp1_hash1_init(parent);
@@ -623,7 +622,6 @@ static void __init snowball_init_machine(void)
 	mop500_i2c_init(parent);
 	snowball_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	u8500_cryp1_hash1_init(parent);
@@ -661,7 +659,6 @@ static void __init hrefv60_init_machine(void)
 	mop500_i2c_init(parent);
 	hrefv60_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index d6fab16..3bd9b6e 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -104,7 +104,6 @@ void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
-void mop500_audio_init(struct device *parent);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 96fa4ac..7eb1272 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -18,15 +18,6 @@
 struct spi_master_cntlr;
 
 static inline struct amba_device *
-dbx500_add_msp_spi(struct device *parent, const char *name,
-		   resource_size_t base, int irq,
-		   struct spi_master_cntlr *pdata)
-{
-	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0,
-				   pdata, 0);
-}
-
-static inline struct amba_device *
 dbx500_add_spi(struct device *parent, const char *name, resource_size_t base,
 	       int irq, struct spi_master_cntlr *pdata,
 	       u32 periphid)
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 3219983..c393932 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -53,19 +53,6 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 #define db8500_add_i2c4(parent, pdata) \
 	dbx500_add_i2c(parent, 4, U8500_I2C4_BASE, IRQ_DB8500_I2C4, pdata)
 
-#define db8500_add_msp0_spi(parent, pdata) \
-	dbx500_add_msp_spi(parent, "msp0", U8500_MSP0_BASE, \
-			   IRQ_DB8500_MSP0, pdata)
-#define db8500_add_msp1_spi(parent, pdata) \
-	dbx500_add_msp_spi(parent, "msp1", U8500_MSP1_BASE, \
-			   IRQ_DB8500_MSP1, pdata)
-#define db8500_add_msp2_spi(parent, pdata) \
-	dbx500_add_msp_spi(parent, "msp2", U8500_MSP2_BASE, \
-			   IRQ_DB8500_MSP2, pdata)
-#define db8500_add_msp3_spi(parent, pdata) \
-	dbx500_add_msp_spi(parent, "msp3", U8500_MSP3_BASE, \
-			   IRQ_DB8500_MSP1, pdata)
-
 #define db8500_add_rtc(parent) \
 	dbx500_add_rtc(parent, U8500_RTC_BASE, IRQ_DB8500_RTC);
 
-- 
1.8.1.2

