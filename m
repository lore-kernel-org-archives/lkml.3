Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab3ECOri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:47:38 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34090 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3ECOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/63] dmaengine: ste_dma40: Calculate number of logical channels from physical ones
Date: Fri,  3 May 2013 15:32:03 +0100
Message-Id: <1367591569-32197-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change will cost ~25KB of memory, but it's worth the trade-off,
as it removes a great deal of overhead. It means that instead of only
allocating memory for the logical channels in use, it does so for all
available ones, which is 32 per physical channel. However, this now
means we can remove some platform data and we don't have to worry
about adding vendor specific variables to Device Tree.

Acked-by: Vinod Koul <vnod.koul@intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/devices-db8500.c        |    1 -
 drivers/dma/ste_dma40.c                     |   16 ++++++----------
 include/linux/platform_data/dma-ste-dma40.h |    2 --
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 28308f9..99bc532 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -121,7 +121,6 @@ static const dma_addr_t dma40_rx_map[DB8500_DMA_NR_DEV] = {
 };
 
 static struct stedma40_platform_data dma40_plat_data = {
-	.dev_len = DB8500_DMA_NR_DEV,
 	.dev_rx = dma40_rx_map,
 	.dev_tx = dma40_tx_map,
 	.disabled_channels = {-1},
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 9a04559..0a5f3705 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -45,6 +45,9 @@
 #define D40_LCLA_LINK_PER_EVENT_GRP 128
 #define D40_LCLA_END D40_LCLA_LINK_PER_EVENT_GRP
 
+/* Max number of logical channels per physical channel */
+#define D40_MAX_LOG_CHAN_PER_PHY 32
+
 /* Attempts before giving up to trying to get pages that are aligned */
 #define MAX_LCLA_ALLOC_ATTEMPTS 256
 
@@ -3196,6 +3199,8 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	else
 		num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
 
+	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
+
 	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
 		 rev, res->start, num_phy_chans);
 
@@ -3205,15 +3210,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		goto failure;
 	}
 
-	/* Count the number of logical channels in use */
-	for (i = 0; i < plat_data->dev_len; i++)
-		if (plat_data->dev_rx[i] != 0)
-			num_log_chans++;
-
-	for (i = 0; i < plat_data->dev_len; i++)
-		if (plat_data->dev_tx[i] != 0)
-			num_log_chans++;
-
 	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
 		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
 		       sizeof(struct d40_chan), GFP_KERNEL);
@@ -3281,7 +3277,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		 * The max number of logical channels are event lines for all
 		 * src devices and dst devices
 		 */
-		base->lookup_log_chans = kzalloc(plat_data->dev_len * 2 *
+		base->lookup_log_chans = kzalloc(num_log_chans *
 						 sizeof(struct d40_chan *),
 						 GFP_KERNEL);
 		if (!base->lookup_log_chans)
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index 9e42a67..c54af61 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -136,7 +136,6 @@ struct stedma40_chan_cfg {
 /**
  * struct stedma40_platform_data - Configuration struct for the dma device.
  *
- * @dev_len: length of dev_tx and dev_rx
  * @dev_tx: mapping between destination event line and io address
  * @dev_rx: mapping between source event line and io address
  * @disabled_channels: A vector, ending with -1, that marks physical channels
@@ -153,7 +152,6 @@ struct stedma40_chan_cfg {
  * for 'multiple of 4' channels, like 8.
  */
 struct stedma40_platform_data {
-	u32				 dev_len;
 	const dma_addr_t		*dev_tx;
 	const dma_addr_t		*dev_rx;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
-- 
1.7.10.4

