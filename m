Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaHBNwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:52:09 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55543 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaHBNwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:52:07 -0400
Date: Sat, 2 Aug 2014 19:22:04 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Stefano Babic <sbabic@denx.de>, Jingoo Han <jg1.han@samsung.com>,
        Christian Pellegrin <chripell@fsfe.org>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] can: mcp251x: Use dmam_alloc_coherent
Message-ID: <20140802135204.GA7635@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the data allocated using dma_alloc_coherent to the
corresponding managed interface and does away with the calls to free the
allocated memory in the probe and remove functions.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/net/can/spi/mcp251x.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 5df239e..c66d699 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1107,10 +1107,10 @@ static int mcp251x_can_probe(struct spi_device *spi)
 		 * Minimum coherent DMA allocation is PAGE_SIZE, so allocate
 		 * that much and share it between Tx and Rx DMA buffers.
 		 */
-		priv->spi_tx_buf = dma_alloc_coherent(&spi->dev,
-						      PAGE_SIZE,
-						      &priv->spi_tx_dma,
-						      GFP_DMA);
+		priv->spi_tx_buf = dmam_alloc_coherent(&spi->dev,
+						       PAGE_SIZE,
+						       &priv->spi_tx_dma,
+						       GFP_DMA);
 
 		if (priv->spi_tx_buf) {
 			priv->spi_rx_buf = (priv->spi_tx_buf + (PAGE_SIZE / 2));
@@ -1156,9 +1156,6 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	return 0;
 
 error_probe:
-	if (mcp251x_enable_dma)
-		dma_free_coherent(&spi->dev, PAGE_SIZE,
-				  priv->spi_tx_buf, priv->spi_tx_dma);
 	mcp251x_power_enable(priv->power, 0);
 
 out_clk:
@@ -1178,11 +1175,6 @@ static int mcp251x_can_remove(struct spi_device *spi)
 
 	unregister_candev(net);
 
-	if (mcp251x_enable_dma) {
-		dma_free_coherent(&spi->dev, PAGE_SIZE,
-				  priv->spi_tx_buf, priv->spi_tx_dma);
-	}
-
 	mcp251x_power_enable(priv->power, 0);
 
 	if (!IS_ERR(priv->clk))
-- 
1.9.1

