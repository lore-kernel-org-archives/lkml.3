Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaGKQCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:02:43 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:57190 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbaGKQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:01:21 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        linux-spi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 1/2] spi: rspi: Handle dmaengine_prep_slave_sg() failures gracefully
Date: Fri, 11 Jul 2014 18:01:16 +0200
Message-Id: <1405094477-14192-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As typically a shmobile SoC has less DMA channels than devices that can use
DMA, we may want to prioritize access to the DMA channels in the future.
This means that dmaengine_prep_slave_sg() may start failing arbitrarily.

Handle dmaengine_prep_slave_sg() failures gracefully by falling back to
PIO.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2:
  - Add Acked-by
---
 drivers/spi/spi-rspi.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 38fd938d6360..c850dfdfa9e3 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -477,7 +477,7 @@ static int rspi_dma_transfer(struct rspi_data *rspi, struct sg_table *tx,
 					tx->sgl, tx->nents, DMA_TO_DEVICE,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 		if (!desc_tx)
-			return -EIO;
+			goto no_dma;
 
 		irq_mask |= SPCR_SPTIE;
 	}
@@ -486,7 +486,7 @@ static int rspi_dma_transfer(struct rspi_data *rspi, struct sg_table *tx,
 					rx->sgl, rx->nents, DMA_FROM_DEVICE,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 		if (!desc_rx)
-			return -EIO;
+			goto no_dma;
 
 		irq_mask |= SPCR_SPRIE;
 	}
@@ -540,6 +540,12 @@ static int rspi_dma_transfer(struct rspi_data *rspi, struct sg_table *tx,
 		enable_irq(rspi->rx_irq);
 
 	return ret;
+
+no_dma:
+	pr_warn_once("%s %s: DMA not available, falling back to PIO\n",
+		     dev_driver_string(&rspi->master->dev),
+		     dev_name(&rspi->master->dev));
+	return -EAGAIN;
 }
 
 static void rspi_receive_init(const struct rspi_data *rspi)
@@ -593,8 +599,10 @@ static int rspi_common_transfer(struct rspi_data *rspi,
 
 	if (rspi->master->can_dma && __rspi_can_dma(rspi, xfer)) {
 		/* rx_buf can be NULL on RSPI on SH in TX-only Mode */
-		return rspi_dma_transfer(rspi, &xfer->tx_sg,
-					 xfer->rx_buf ? &xfer->rx_sg : NULL);
+		ret = rspi_dma_transfer(rspi, &xfer->tx_sg,
+					xfer->rx_buf ? &xfer->rx_sg : NULL);
+		if (ret != -EAGAIN)
+			return ret;
 	}
 
 	ret = rspi_pio_transfer(rspi, xfer->tx_buf, xfer->rx_buf, xfer->len);
@@ -648,8 +656,11 @@ static int qspi_transfer_out(struct rspi_data *rspi, struct spi_transfer *xfer)
 {
 	int ret;
 
-	if (rspi->master->can_dma && __rspi_can_dma(rspi, xfer))
-		return rspi_dma_transfer(rspi, &xfer->tx_sg, NULL);
+	if (rspi->master->can_dma && __rspi_can_dma(rspi, xfer)) {
+		ret = rspi_dma_transfer(rspi, &xfer->tx_sg, NULL);
+		if (ret != -EAGAIN)
+			return ret;
+	}
 
 	ret = rspi_pio_transfer(rspi, xfer->tx_buf, NULL, xfer->len);
 	if (ret < 0)
@@ -663,8 +674,11 @@ static int qspi_transfer_out(struct rspi_data *rspi, struct spi_transfer *xfer)
 
 static int qspi_transfer_in(struct rspi_data *rspi, struct spi_transfer *xfer)
 {
-	if (rspi->master->can_dma && __rspi_can_dma(rspi, xfer))
-		return rspi_dma_transfer(rspi, NULL, &xfer->rx_sg);
+	if (rspi->master->can_dma && __rspi_can_dma(rspi, xfer)) {
+		int ret = rspi_dma_transfer(rspi, NULL, &xfer->rx_sg);
+		if (ret != -EAGAIN)
+			return ret;
+	}
 
 	return rspi_pio_transfer(rspi, NULL, xfer->rx_buf, xfer->len);
 }
-- 
1.9.1

