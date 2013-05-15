Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3EOJwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:52:36 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36064 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3EOJw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/39] ARM: ux500: Remove DMA address look-up table
Date: Wed, 15 May 2013 10:51:32 +0100
Message-Id: <1368611522-9984-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA addresses are now passed as part of the dmaengine API by invoking
dmaengine_slave_config(). So there's no requirement for the DMA40
driver to look them up in a table provided by platform data. This
method does not fit in well using Device Tree either.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/devices-db8500.c        |   80 ---------------------------
 include/linux/platform_data/dma-ste-dma40.h |    2 -
 2 files changed, 82 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index bed25a3..e21ffd8 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -42,87 +42,7 @@ static struct resource dma40_resources[] = {
 	}
 };
 
-/*
- * Mapping between destination event lines and physical device address.
- * The event line is tied to a device and therefore the address is constant.
- * When the address comes from a primecell it will be configured in runtime
- * and we set the address to -1 as a placeholder.
- */
-static const dma_addr_t dma40_tx_map[DB8500_DMA_NR_DEV] = {
-	/* MUSB - these will be runtime-reconfigured */
-	[DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8] = -1,
-	[DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15] = -1,
-	[DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14] = -1,
-	[DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13] = -1,
-	[DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12] = -1,
-	[DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11] = -1,
-	[DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10] = -1,
-	[DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9] = -1,
-	/* PrimeCells - run-time configured */
-	[DB8500_DMA_DEV0_SPI0] = -1,
-	[DB8500_DMA_DEV1_SD_MMC0] = -1,
-	[DB8500_DMA_DEV2_SD_MMC1] = -1,
-	[DB8500_DMA_DEV3_SD_MMC2] = -1,
-	[DB8500_DMA_DEV8_SSP0] = -1,
-	[DB8500_DMA_DEV9_SSP1] = -1,
-	[DB8500_DMA_DEV11_UART2] = -1,
-	[DB8500_DMA_DEV12_UART1] = -1,
-	[DB8500_DMA_DEV13_UART0] = -1,
-	[DB8500_DMA_DEV28_SD_MM2] = -1,
-	[DB8500_DMA_DEV29_SD_MM0] = -1,
-	[DB8500_DMA_DEV32_SD_MM1] = -1,
-	[DB8500_DMA_DEV33_SPI2] = -1,
-	[DB8500_DMA_DEV35_SPI1] = -1,
-	[DB8500_DMA_DEV40_SPI3] = -1,
-	[DB8500_DMA_DEV41_SD_MM3] = -1,
-	[DB8500_DMA_DEV42_SD_MM4] = -1,
-	[DB8500_DMA_DEV43_SD_MM5] = -1,
-	[DB8500_DMA_DEV14_MSP2] = U8500_MSP2_BASE + MSP_TX_RX_REG_OFFSET,
-	[DB8500_DMA_DEV30_MSP1] = U8500_MSP1_BASE + MSP_TX_RX_REG_OFFSET,
-	[DB8500_DMA_DEV31_MSP0_SLIM0_CH0] = U8500_MSP0_BASE + MSP_TX_RX_REG_OFFSET,
-	[DB8500_DMA_DEV48_CAC1] = U8500_CRYP1_BASE + CRYP1_TX_REG_OFFSET,
-	[DB8500_DMA_DEV50_HAC1_TX] = U8500_HASH1_BASE + HASH1_TX_REG_OFFSET,
-};
-
-/* Mapping between source event lines and physical device address */
-static const dma_addr_t dma40_rx_map[DB8500_DMA_NR_DEV] = {
-	/* MUSB - these will be runtime-reconfigured */
-	[DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8] = -1,
-	[DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15] = -1,
-	[DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14] = -1,
-	[DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13] = -1,
-	[DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12] = -1,
-	[DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11] = -1,
-	[DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10] = -1,
-	[DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9] = -1,
-	/* PrimeCells */
-	[DB8500_DMA_DEV0_SPI0] = -1,
-	[DB8500_DMA_DEV1_SD_MMC0] = -1,
-	[DB8500_DMA_DEV2_SD_MMC1] = -1,
-	[DB8500_DMA_DEV3_SD_MMC2] = -1,
-	[DB8500_DMA_DEV8_SSP0] = -1,
-	[DB8500_DMA_DEV9_SSP1] = -1,
-	[DB8500_DMA_DEV11_UART2] = -1,
-	[DB8500_DMA_DEV12_UART1] = -1,
-	[DB8500_DMA_DEV13_UART0] = -1,
-	[DB8500_DMA_DEV28_SD_MM2] = -1,
-	[DB8500_DMA_DEV29_SD_MM0] = -1,
-	[DB8500_DMA_DEV32_SD_MM1] = -1,
-	[DB8500_DMA_DEV33_SPI2] = -1,
-	[DB8500_DMA_DEV35_SPI1] = -1,
-	[DB8500_DMA_DEV40_SPI3] = -1,
-	[DB8500_DMA_DEV41_SD_MM3] = -1,
-	[DB8500_DMA_DEV42_SD_MM4] = -1,
-	[DB8500_DMA_DEV43_SD_MM5] = -1,
-	[DB8500_DMA_DEV14_MSP2] = U8500_MSP2_BASE + MSP_TX_RX_REG_OFFSET,
-	[DB8500_DMA_DEV30_MSP3] = U8500_MSP3_BASE + MSP_TX_RX_REG_OFFSET,
-	[DB8500_DMA_DEV31_MSP0_SLIM0_CH0] = U8500_MSP0_BASE + MSP_TX_RX_REG_OFFSET,
-	[DB8500_DMA_DEV48_CAC1] = U8500_CRYP1_BASE + CRYP1_RX_REG_OFFSET,
-};
-
 struct stedma40_platform_data dma40_plat_data = {
-	.dev_rx = dma40_rx_map,
-	.dev_tx = dma40_tx_map,
 	.disabled_channels = {-1},
 };
 
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index c54af61..af0064e 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -152,8 +152,6 @@ struct stedma40_chan_cfg {
  * for 'multiple of 4' channels, like 8.
  */
 struct stedma40_platform_data {
-	const dma_addr_t		*dev_tx;
-	const dma_addr_t		*dev_rx;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
 	int				*soft_lli_chans;
 	int				 num_of_soft_lli_chans;
-- 
1.7.10.4

