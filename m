Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaJHEiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 00:38:12 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:29304 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaJHEiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 00:38:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,674,1406617200"; 
   d="scan'208";a="47521092"
From: Ray Jui <rjui@broadcom.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
        Ray Jui <rjui@broadcom.com>
Subject: [PATCH] spi: pl022: Fix broken spidev when DMA is enabled
Date: Tue, 7 Oct 2014 21:38:47 -0700
Message-ID: <1412743127-4523-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PL022 SPI driver maps the DMA RX buffer before the DMA TX buffer. In
most cases, the sequence of the mapping does not matter. But in cases
where TX and RX happen to use the same buffer, e.g., spidev, it causes
the cached TX data not written to memory, because the same memory has
been marked invalid when dma_map_sg on the RX buffer is called

The solution is to reverse the sequence so it maps the TX buffer before
the RX buffer

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
Tested-by: Scott Branden <sbranden@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/spi/spi-pl022.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 1189cfd..edb7298 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -773,10 +773,10 @@ static void *next_transfer(struct pl022 *pl022)
 static void unmap_free_dma_scatter(struct pl022 *pl022)
 {
 	/* Unmap and free the SG tables */
-	dma_unmap_sg(pl022->dma_tx_channel->device->dev, pl022->sgt_tx.sgl,
-		     pl022->sgt_tx.nents, DMA_TO_DEVICE);
 	dma_unmap_sg(pl022->dma_rx_channel->device->dev, pl022->sgt_rx.sgl,
 		     pl022->sgt_rx.nents, DMA_FROM_DEVICE);
+	dma_unmap_sg(pl022->dma_tx_channel->device->dev, pl022->sgt_tx.sgl,
+		     pl022->sgt_tx.nents, DMA_TO_DEVICE);
 	sg_free_table(&pl022->sgt_rx);
 	sg_free_table(&pl022->sgt_tx);
 }
@@ -1026,16 +1026,16 @@ static int configure_dma(struct pl022 *pl022)
 			  pl022->cur_transfer->len, &pl022->sgt_tx);
 
 	/* Map DMA buffers */
-	rx_sglen = dma_map_sg(rxchan->device->dev, pl022->sgt_rx.sgl,
-			   pl022->sgt_rx.nents, DMA_FROM_DEVICE);
-	if (!rx_sglen)
-		goto err_rx_sgmap;
-
 	tx_sglen = dma_map_sg(txchan->device->dev, pl022->sgt_tx.sgl,
 			   pl022->sgt_tx.nents, DMA_TO_DEVICE);
 	if (!tx_sglen)
 		goto err_tx_sgmap;
 
+	rx_sglen = dma_map_sg(rxchan->device->dev, pl022->sgt_rx.sgl,
+			   pl022->sgt_rx.nents, DMA_FROM_DEVICE);
+	if (!rx_sglen)
+		goto err_rx_sgmap;
+
 	/* Send both scatterlists */
 	rxdesc = dmaengine_prep_slave_sg(rxchan,
 				      pl022->sgt_rx.sgl,
@@ -1070,12 +1070,12 @@ err_txdesc:
 	dmaengine_terminate_all(txchan);
 err_rxdesc:
 	dmaengine_terminate_all(rxchan);
+	dma_unmap_sg(rxchan->device->dev, pl022->sgt_rx.sgl,
+		     pl022->sgt_rx.nents, DMA_FROM_DEVICE);
+err_rx_sgmap:
 	dma_unmap_sg(txchan->device->dev, pl022->sgt_tx.sgl,
 		     pl022->sgt_tx.nents, DMA_TO_DEVICE);
 err_tx_sgmap:
-	dma_unmap_sg(rxchan->device->dev, pl022->sgt_rx.sgl,
-		     pl022->sgt_tx.nents, DMA_FROM_DEVICE);
-err_rx_sgmap:
 	sg_free_table(&pl022->sgt_tx);
 err_alloc_tx_sg:
 	sg_free_table(&pl022->sgt_rx);
-- 
1.7.9.5

