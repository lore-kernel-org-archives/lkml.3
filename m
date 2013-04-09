Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935487Ab3DISjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:39:52 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38552 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934655Ab3DISju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:39:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH 1/8] dmaengine: ste_dma40: Assign memcpy channels in the driver
Date: Tue,  9 Apr 2013 19:39:36 +0100
Message-Id: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The channels reserved for memcpy are the same for all currently
supported platforms. With this in mind, we can ease the platform
data passing requirement by moving these assignments out from
platform code and place them directly into the driver.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/devices-db8500.c        |   12 ------------
 drivers/dma/ste_dma40.c                     |   12 +++++++-----
 include/linux/platform_data/dma-ste-dma40.h |    4 ----
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index afa5b04..9b09683 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -146,22 +146,10 @@ static const dma_addr_t dma40_rx_map[DB8500_DMA_NR_DEV] = {
 	[DB8500_DMA_DEV48_CAC1_RX] = U8500_CRYP1_BASE + CRYP1_RX_REG_OFFSET,
 };
 
-/* Reserved event lines for memcpy only */
-static int dma40_memcpy_event[] = {
-	DB8500_DMA_MEMCPY_TX_0,
-	DB8500_DMA_MEMCPY_TX_1,
-	DB8500_DMA_MEMCPY_TX_2,
-	DB8500_DMA_MEMCPY_TX_3,
-	DB8500_DMA_MEMCPY_TX_4,
-	DB8500_DMA_MEMCPY_TX_5,
-};
-
 static struct stedma40_platform_data dma40_plat_data = {
 	.dev_len = DB8500_DMA_NR_DEV,
 	.dev_rx = dma40_rx_map,
 	.dev_tx = dma40_tx_map,
-	.memcpy = dma40_memcpy_event,
-	.memcpy_len = ARRAY_SIZE(dma40_memcpy_event),
 	.memcpy_conf_phy = &dma40_memcpy_conf_phy,
 	.memcpy_conf_log = &dma40_memcpy_conf_log,
 	.disabled_channels = {-1},
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1734fee..12de79e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -55,6 +55,9 @@
 
 #define MAX(a, b) (((a) < (b)) ? (b) : (a))
 
+/* Reserved event lines for memcpy only. */
+static int dma40_memcpy_channels[] = { 56, 57, 58, 59, 60 };
+
 /**
  * enum 40_command - The different commands and/or statuses.
  *
@@ -2014,8 +2017,7 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 	if (dma_has_cap(DMA_MEMCPY, cap) && !dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = *d40c->base->plat_data->memcpy_conf_log;
 		d40c->dma_cfg.src_dev_type = STEDMA40_DEV_SRC_MEMORY;
-		d40c->dma_cfg.dst_dev_type = d40c->base->plat_data->
-			memcpy[d40c->chan.chan_id];
+		d40c->dma_cfg.dst_dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
 
 	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
 		   dma_has_cap(DMA_SLAVE, cap)) {
@@ -2927,7 +2929,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	}
 
 	d40_chan_init(base, &base->dma_memcpy, base->log_chans,
-		      base->num_log_chans, base->plat_data->memcpy_len);
+		      base->num_log_chans, ARRAY_SIZE(dma40_memcpy_channels));
 
 	dma_cap_zero(base->dma_memcpy.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_memcpy.cap_mask);
@@ -3215,7 +3217,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 			num_log_chans++;
 
 	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
-		       (num_phy_chans + num_log_chans + plat_data->memcpy_len) *
+		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
 		       sizeof(struct d40_chan), GFP_KERNEL);
 
 	if (base == NULL) {
@@ -3276,7 +3278,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	if (!base->lookup_phy_chans)
 		goto failure;
 
-	if (num_log_chans + plat_data->memcpy_len) {
+	if (num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) {
 		/*
 		 * The max number of logical channels are event lines for all
 		 * src devices and dst devices
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index 4b78101..a808784 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -141,8 +141,6 @@ struct stedma40_chan_cfg {
  * @dev_len: length of dev_tx and dev_rx
  * @dev_tx: mapping between destination event line and io address
  * @dev_rx: mapping between source event line and io address
- * @memcpy: list of memcpy event lines
- * @memcpy_len: length of memcpy
  * @memcpy_conf_phy: default configuration of physical channel memcpy
  * @memcpy_conf_log: default configuration of logical channel memcpy
  * @disabled_channels: A vector, ending with -1, that marks physical channels
@@ -162,8 +160,6 @@ struct stedma40_platform_data {
 	u32				 dev_len;
 	const dma_addr_t		*dev_tx;
 	const dma_addr_t		*dev_rx;
-	int				*memcpy;
-	u32				 memcpy_len;
 	struct stedma40_chan_cfg	*memcpy_conf_phy;
 	struct stedma40_chan_cfg	*memcpy_conf_log;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
-- 
1.7.10.4

