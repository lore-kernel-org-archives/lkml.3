Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3HWMai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:30:38 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55324 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab3HWMY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/40] ARM: ux500: Purge SDI support for ATAG booting
Date: Fri, 23 Aug 2013 13:23:18 +0100
Message-Id: <1377260620-18829-19-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500-sdi.c | 39 ----------------------------------
 arch/arm/mach-ux500/board-mop500.c     |  3 ---
 arch/arm/mach-ux500/board-mop500.h     |  3 ---
 arch/arm/mach-ux500/devices-common.h   | 10 ---------
 arch/arm/mach-ux500/devices-db8500.h   | 19 -----------------
 5 files changed, 74 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 1ae5999..26600a1 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -65,12 +65,6 @@ struct mmci_platform_data mop500_sdi0_data = {
 #endif
 };
 
-static void sdi0_configure(struct device *parent)
-{
-	/* Add the device, force v2 to subrevision 1 */
-	db8500_add_sdi0(parent, &mop500_sdi0_data, U8500_SDI_V2_PERIPHID);
-}
-
 /*
  * SDI1 (SDIO WLAN)
  */
@@ -172,36 +166,3 @@ struct mmci_platform_data mop500_sdi4_data = {
 	.dma_tx_param	= &mop500_sdi4_dma_cfg_tx,
 #endif
 };
-
-void __init mop500_sdi_init(struct device *parent)
-{
-	/* PoP:ed eMMC */
-	db8500_add_sdi2(parent, &mop500_sdi2_data, U8500_SDI_V2_PERIPHID);
-	/* On-board eMMC */
-	db8500_add_sdi4(parent, &mop500_sdi4_data, U8500_SDI_V2_PERIPHID);
-}
-
-void __init snowball_sdi_init(struct device *parent)
-{
-	/* On Snowball MMC_CAP_SD_HIGHSPEED isn't supported (Hardware issue?) */
-	mop500_sdi0_data.capabilities &= ~MMC_CAP_SD_HIGHSPEED;
-	/* On-board eMMC */
-	db8500_add_sdi4(parent, &mop500_sdi4_data, U8500_SDI_V2_PERIPHID);
-	/* External Micro SD slot */
-	mop500_sdi0_data.gpio_cd = SNOWBALL_SDMMC_CD_GPIO;
-	mop500_sdi0_data.cd_invert = true;
-	sdi0_configure(parent);
-}
-
-void __init hrefv60_sdi_init(struct device *parent)
-{
-	/* PoP:ed eMMC */
-	db8500_add_sdi2(parent, &mop500_sdi2_data, U8500_SDI_V2_PERIPHID);
-	/* On-board eMMC */
-	db8500_add_sdi4(parent, &mop500_sdi4_data, U8500_SDI_V2_PERIPHID);
-	/* External Micro SD slot */
-	mop500_sdi0_data.gpio_cd = HREFV60_SDMMC_CD_GPIO;
-	sdi0_configure(parent);
-	/* WLAN SDIO channel */
-	db8500_add_sdi1(parent, &mop500_sdi1_data, U8500_SDI_V2_PERIPHID);
-}
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 447d37d..d53d672 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -165,7 +165,6 @@ static void __init mop500_init_machine(void)
 	mop500_pinmaps_init();
 	parent = u8500_init_devices();
 
-	mop500_sdi_init(parent);
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
@@ -182,7 +181,6 @@ static void __init snowball_init_machine(void)
 	snowball_pinmaps_init();
 	parent = u8500_init_devices();
 
-	snowball_sdi_init(parent);
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
@@ -199,7 +197,6 @@ static void __init hrefv60_init_machine(void)
 	hrefv60_pinmaps_init();
 	parent = u8500_init_devices();
 
-	hrefv60_sdi_init(parent);
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 341fad1..06eb894 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -94,9 +94,6 @@ extern struct amba_pl011_data uart2_plat;
 extern struct pl022_ssp_controller ssp0_plat;
 extern struct stedma40_platform_data dma40_plat_data;
 
-extern void mop500_sdi_init(struct device *parent);
-extern void snowball_sdi_init(struct device *parent);
-extern void hrefv60_sdi_init(struct device *parent);
 void __init mop500_u8500uib_init(void);
 void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 34ec2f7..030f5a0 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -24,16 +24,6 @@ dbx500_add_spi(struct device *parent, const char *name, resource_size_t base,
 				   pdata, periphid);
 }
 
-struct mmci_platform_data;
-
-static inline struct amba_device *
-dbx500_add_sdi(struct device *parent, const char *name, resource_size_t base,
-	       int irq, struct mmci_platform_data *pdata, u32 periphid)
-{
-	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0,
-				   pdata, periphid);
-}
-
 struct amba_pl011_data;
 
 static inline struct amba_device *
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 64667f6..e47039b 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -49,25 +49,6 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 	ux500_add_usb(parent, U8500_USBOTG_BASE, \
 		      IRQ_DB8500_USBOTG, rx_cfg, tx_cfg)
 
-#define db8500_add_sdi0(parent, pdata, pid) \
-	dbx500_add_sdi(parent, "sdi0", U8500_SDI0_BASE, \
-		       IRQ_DB8500_SDMMC0, pdata, pid)
-#define db8500_add_sdi1(parent, pdata, pid) \
-	dbx500_add_sdi(parent, "sdi1", U8500_SDI1_BASE, \
-		       IRQ_DB8500_SDMMC1, pdata, pid)
-#define db8500_add_sdi2(parent, pdata, pid) \
-	dbx500_add_sdi(parent, "sdi2", U8500_SDI2_BASE, \
-		       IRQ_DB8500_SDMMC2, pdata, pid)
-#define db8500_add_sdi3(parent, pdata, pid) \
-	dbx500_add_sdi(parent, "sdi3", U8500_SDI3_BASE, \
-		       IRQ_DB8500_SDMMC3, pdata, pid)
-#define db8500_add_sdi4(parent, pdata, pid) \
-	dbx500_add_sdi(parent, "sdi4", U8500_SDI4_BASE, \
-		       IRQ_DB8500_SDMMC4, pdata, pid)
-#define db8500_add_sdi5(parent, pdata, pid) \
-	dbx500_add_sdi(parent, "sdi5", U8500_SDI5_BASE, \
-		       IRQ_DB8500_SDMMC5, pdata, pid)
-
 #define db8500_add_ssp0(parent, pdata) \
 	db8500_add_ssp(parent, "ssp0", U8500_SSP0_BASE, \
 		       IRQ_DB8500_SSP0, pdata)
-- 
1.8.1.2

