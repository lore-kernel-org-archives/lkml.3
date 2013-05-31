Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3EaPCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:02:21 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:44354 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3EaPCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:02:13 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/2] spi: atmel: convert to dma_request_slave_channel_compat()
Date: Fri, 31 May 2013 17:01:59 +0200
Message-Id: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic DMA DT helper.
Platforms booting with or without DT populated are both supported.

Based on Ludovic Desroches <ludovic.desroches@atmel.com> patchset
"ARM: at91: move to generic DMA device tree binding"

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/spi/spi-atmel.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

rebased on linux-next next-20130531

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 31cfc87..ea1ec00 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -424,10 +424,15 @@ static int atmel_spi_dma_slave_config(struct atmel_spi *as,
 	return err;
 }
 
-static bool filter(struct dma_chan *chan, void *slave)
+static bool filter(struct dma_chan *chan, void *pdata)
 {
-	struct	at_dma_slave *sl = slave;
+	struct atmel_spi_dma *sl_pdata = pdata;
+	struct at_dma_slave *sl;
 
+	if (!sl_pdata)
+		return false;
+
+	sl = &sl_pdata->dma_slave;
 	if (sl->dma_dev == chan->device->dev) {
 		chan->private = sl;
 		return true;
@@ -438,24 +443,31 @@ static bool filter(struct dma_chan *chan, void *slave)
 
 static int atmel_spi_configure_dma(struct atmel_spi *as)
 {
-	struct at_dma_slave *sdata = &as->dma.dma_slave;
 	struct dma_slave_config	slave_config;
+	struct device *dev = &as->pdev->dev;
 	int err;
 
-	if (sdata && sdata->dma_dev) {
-		dma_cap_mask_t mask;
+	dma_cap_mask_t mask;
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
 
-		/* Try to grab two DMA channels */
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-		as->dma.chan_tx = dma_request_channel(mask, filter, sdata);
-		if (as->dma.chan_tx)
-			as->dma.chan_rx =
-				dma_request_channel(mask, filter, sdata);
+	as->dma.chan_tx = dma_request_slave_channel_compat(mask, filter,
+							   &as->dma,
+							   dev, "tx");
+	if (!as->dma.chan_tx) {
+		dev_err(dev,
+			"DMA TX channel not available, SPI unable to use DMA\n");
+		err = -EBUSY;
+		goto error;
 	}
-	if (!as->dma.chan_rx || !as->dma.chan_tx) {
-		dev_err(&as->pdev->dev,
-			"DMA channel not available, SPI unable to use DMA\n");
+
+	as->dma.chan_rx = dma_request_slave_channel_compat(mask, filter,
+							   &as->dma,
+							   dev, "rx");
+
+	if (!as->dma.chan_rx) {
+		dev_err(dev,
+			"DMA RX channel not available, SPI unable to use DMA\n");
 		err = -EBUSY;
 		goto error;
 	}
-- 
1.7.10.4

