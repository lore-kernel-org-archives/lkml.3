Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967742Ab3DRROW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:14:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38362 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967186Ab3DRROV (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 18 Apr 2013 13:14:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@linaro.org>, Arnd Bergman <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi/s3c64xx: Check for errors in dmaengine prepare_transfer()
Date: Thu, 18 Apr 2013 18:14:17 +0100
Message-Id: <1366305257-20942-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't silently ignore errors, report them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi-s3c64xx.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 6d6537d..5000586 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -421,6 +421,7 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
 	dma_filter_fn filter = sdd->cntrlr_info->filter;
 	struct device *dev = &sdd->pdev->dev;
 	dma_cap_mask_t mask;
+	int ret;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
@@ -428,11 +429,34 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
 	/* Acquire DMA channels */
 	sdd->rx_dma.ch = dma_request_slave_channel_compat(mask, filter,
 				(void*)sdd->rx_dma.dmach, dev, "rx");
+	if (!sdd->rx_dma.ch) {
+		dev_err(dev, "Failed to get RX DMA channel\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
 	sdd->tx_dma.ch = dma_request_slave_channel_compat(mask, filter,
 				(void*)sdd->tx_dma.dmach, dev, "tx");
-	pm_runtime_get_sync(&sdd->pdev->dev);
+	if (!sdd->tx_dma.ch) {
+		dev_err(dev, "Failed to get TX DMA channel\n");
+		ret = -EBUSY;
+		goto out_rx;
+	}
+
+	ret = pm_runtime_get_sync(&sdd->pdev->dev);
+	if (ret != 0) {
+		dev_err(dev, "Failed to enable device: %d\n", ret);
+		goto out_tx;
+	}
 
 	return 0;
+
+out_tx:
+	dma_release_channel(sdd->tx_dma.ch);
+out_rx:
+	dma_release_channel(sdd->rx_dma.ch);
+out:
+	return ret;
 }
 
 static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
-- 
1.7.10.4

