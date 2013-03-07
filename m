Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab3CGDey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:34:54 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:26606 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3CGDex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:34:53 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 09/16] spi/spi-atmel: fix spi-atmel driver to adapt to slave_config changes
Date: Thu, 7 Mar 2013 11:32:16 +0800
Message-ID: <1362627136-8123-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

This is the following of the patch e2b35f3dbfc080f15b72834d08f04f0269dbe9be

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: BUG: dmaengine mode when enable both spi0 and spi1, spi0 doesn't work]
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/spi/spi-atmel.c |   61 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index f6ef86b..40fd8786 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -387,6 +387,37 @@ static inline int atmel_spi_xfer_can_be_chained(struct spi_transfer *xfer)
 	return xfer->delay_usecs == 0 && !xfer->cs_change;
 }
 
+static int atmel_spi_dma_slave_config(struct atmel_spi *as,
+				struct dma_slave_config *slave_config)
+{
+	int err = 0;
+
+	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+
+	slave_config->dst_addr = (dma_addr_t)as->phybase + SPI_TDR;
+	slave_config->src_addr = (dma_addr_t)as->phybase + SPI_RDR;
+	slave_config->src_maxburst = 1;
+	slave_config->dst_maxburst = 1;
+	slave_config->device_fc = false;
+
+	slave_config->direction = DMA_MEM_TO_DEV;
+	if (dmaengine_slave_config(as->dma.chan_tx, slave_config)) {
+		dev_err(&as->pdev->dev,
+			"failed to configure tx dma channel\n");
+		err = -EINVAL;
+	}
+
+	slave_config->direction = DMA_DEV_TO_MEM;
+	if (dmaengine_slave_config(as->dma.chan_rx, slave_config)) {
+		dev_err(&as->pdev->dev,
+			"failed to configure rx dma channel\n");
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 static bool filter(struct dma_chan *chan, void *slave)
 {
 	struct	at_dma_slave *sl = slave;
@@ -402,14 +433,12 @@ static bool filter(struct dma_chan *chan, void *slave)
 static int atmel_spi_configure_dma(struct atmel_spi *as)
 {
 	struct at_dma_slave *sdata = &as->dma.dma_slave;
+	struct dma_slave_config	slave_config;
+	int err;
 
 	if (sdata && sdata->dma_dev) {
 		dma_cap_mask_t mask;
 
-		/* setup DMA addresses */
-		sdata->rx_reg = (dma_addr_t)as->phybase + SPI_RDR;
-		sdata->tx_reg = (dma_addr_t)as->phybase + SPI_TDR;
-
 		/* Try to grab two DMA channels */
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
@@ -419,21 +448,27 @@ static int atmel_spi_configure_dma(struct atmel_spi *as)
 				dma_request_channel(mask, filter, sdata);
 	}
 	if (!as->dma.chan_rx || !as->dma.chan_tx) {
-		if (as->dma.chan_rx)
-			dma_release_channel(as->dma.chan_rx);
-		if (as->dma.chan_tx)
-			dma_release_channel(as->dma.chan_tx);
 		dev_err(&as->pdev->dev,
 			"DMA channel not available, unable to use SPI\n");
-		return -EBUSY;
+		err = -EBUSY;
+		goto error;
 	}
 
+	err = atmel_spi_dma_slave_config(as, &slave_config);
+	if (err)
+		goto error;
+
 	dev_info(&as->pdev->dev,
 			"Using %s (tx) and %s (rx) for DMA transfers\n",
 			dma_chan_name(as->dma.chan_tx),
 			dma_chan_name(as->dma.chan_rx));
-
 	return 0;
+error:
+	if (as->dma.chan_rx)
+		dma_release_channel(as->dma.chan_rx);
+	if (as->dma.chan_tx)
+		dma_release_channel(as->dma.chan_tx);
+	return err;
 }
 
 static void atmel_spi_stop_dma(struct atmel_spi *as)
@@ -510,6 +545,7 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 	struct dma_chan		*txchan = as->dma.chan_tx;
 	struct dma_async_tx_descriptor *rxdesc;
 	struct dma_async_tx_descriptor *txdesc;
+	struct dma_slave_config	slave_config;
 	dma_cookie_t		cookie;
 	u32	len = *plen;
 
@@ -548,6 +584,10 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 
 	*plen = len;
 
+	if (atmel_spi_dma_slave_config(as, &slave_config))
+		goto err_exit;
+
+
 	/* Send both scatterlists */
 	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
 					&as->dma.sgrx,
@@ -596,6 +636,7 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 err_dma:
 	spi_writel(as, IDR, SPI_BIT(OVRES));
 	atmel_spi_stop_dma(as);
+err_exit:
 	atmel_spi_lock(as);
 	return -ENOMEM;
 }
-- 
1.7.9.5

