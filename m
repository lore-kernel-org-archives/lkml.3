Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3GHQLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:11:46 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.196]:53125 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab3GHQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:11:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1373299897!12335811!9
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 11/11] spi: spi-ep93xx: use master->cur_msg for in-flight message
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>, <hsweeten@visionengravers.com>
Content-Disposition: inline
From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Mon, 8 Jul 2013 09:11:18 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <201307080911.19144.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of carrying the in-flight message in the driver private
data, use the cur_msg pointer that is already setup by the core.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 88 ++++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 40 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 4c9a50c..e85834d 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -76,7 +76,6 @@
  * @min_rate: minimum clock rate (in Hz) supported by the controller
  * @max_rate: maximum clock rate (in Hz) supported by the controller
  * @wait: wait here until given transfer is completed
- * @current_msg: message that is currently processed (or %NULL if none)
  * @tx: current byte in transfer to transmit
  * @rx: current byte in transfer to receive
  * @fifo_level: how full is FIFO (%0..%SPI_FIFO_SIZE - %1). Receiving one
@@ -98,7 +97,6 @@ struct ep93xx_spi {
 	unsigned long			min_rate;
 	unsigned long			max_rate;
 	struct completion		wait;
-	struct spi_message		*current_msg;
 	size_t				tx;
 	size_t				rx;
 	size_t				fifo_level;
@@ -378,7 +376,7 @@ static void ep93xx_do_read(struct ep93xx_spi *espi, struct spi_transfer *t)
 
 /**
  * ep93xx_spi_read_write() - perform next RX/TX transfer
- * @espi: ep93xx SPI controller struct
+ * @master: spi_master struct
  *
  * This function transfers next bytes (or half-words) to/from RX/TX FIFOs. If
  * called several times, the whole transfer will be completed. Returns
@@ -387,9 +385,10 @@ static void ep93xx_do_read(struct ep93xx_spi *espi, struct spi_transfer *t)
  * When this function is finished, RX FIFO should be empty and TX FIFO should be
  * full.
  */
-static int ep93xx_spi_read_write(struct ep93xx_spi *espi)
+static int ep93xx_spi_read_write(struct spi_master *master)
 {
-	struct spi_message *msg = espi->current_msg;
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
+	struct spi_message *msg = master->cur_msg;
 	struct spi_transfer *t = msg->state;
 
 	/* read as long as RX FIFO has frames in it */
@@ -410,13 +409,15 @@ static int ep93xx_spi_read_write(struct ep93xx_spi *espi)
 	return -EINPROGRESS;
 }
 
-static void ep93xx_spi_pio_transfer(struct ep93xx_spi *espi)
+static void ep93xx_spi_pio_transfer(struct spi_master *master)
 {
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
+
 	/*
 	 * Now everything is set up for the current transfer. We prime the TX
 	 * FIFO, enable interrupts, and wait for the transfer to complete.
 	 */
-	if (ep93xx_spi_read_write(espi)) {
+	if (ep93xx_spi_read_write(master)) {
 		ep93xx_spi_enable_interrupts(espi);
 		wait_for_completion(&espi->wait);
 	}
@@ -424,7 +425,7 @@ static void ep93xx_spi_pio_transfer(struct ep93xx_spi *espi)
 
 /**
  * ep93xx_spi_dma_prepare() - prepares a DMA transfer
- * @espi: ep93xx SPI controller struct
+ * @master: spi_master struct
  * @dir: DMA transfer direction
  *
  * Function configures the DMA, maps the buffer and prepares the DMA
@@ -432,9 +433,11 @@ static void ep93xx_spi_pio_transfer(struct ep93xx_spi *espi)
  * in case of failure.
  */
 static struct dma_async_tx_descriptor *
-ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_transfer_direction dir)
+ep93xx_spi_dma_prepare(struct spi_master *master,
+		       enum dma_transfer_direction dir)
 {
-	struct spi_transfer *t = espi->current_msg->state;
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
+	struct spi_transfer *t = master->cur_msg->state;
 	struct dma_async_tx_descriptor *txd;
 	enum dma_slave_buswidth buswidth;
 	struct dma_slave_config conf;
@@ -527,15 +530,16 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_transfer_direction dir)
 
 /**
  * ep93xx_spi_dma_finish() - finishes with a DMA transfer
- * @espi: ep93xx SPI controller struct
+ * @master: spi_master struct
  * @dir: DMA transfer direction
  *
  * Function finishes with the DMA transfer. After this, the DMA buffer is
  * unmapped.
  */
-static void ep93xx_spi_dma_finish(struct ep93xx_spi *espi,
+static void ep93xx_spi_dma_finish(struct spi_master *master,
 				  enum dma_transfer_direction dir)
 {
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
 	struct dma_chan *chan;
 	struct sg_table *sgt;
 
@@ -555,21 +559,22 @@ static void ep93xx_spi_dma_callback(void *callback_param)
 	complete(callback_param);
 }
 
-static void ep93xx_spi_dma_transfer(struct ep93xx_spi *espi)
+static void ep93xx_spi_dma_transfer(struct spi_master *master)
 {
-	struct spi_message *msg = espi->current_msg;
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
+	struct spi_message *msg = master->cur_msg;
 	struct dma_async_tx_descriptor *rxd, *txd;
 
-	rxd = ep93xx_spi_dma_prepare(espi, DMA_DEV_TO_MEM);
+	rxd = ep93xx_spi_dma_prepare(master, DMA_DEV_TO_MEM);
 	if (IS_ERR(rxd)) {
 		dev_err(&espi->pdev->dev, "DMA RX failed: %ld\n", PTR_ERR(rxd));
 		msg->status = PTR_ERR(rxd);
 		return;
 	}
 
-	txd = ep93xx_spi_dma_prepare(espi, DMA_MEM_TO_DEV);
+	txd = ep93xx_spi_dma_prepare(master, DMA_MEM_TO_DEV);
 	if (IS_ERR(txd)) {
-		ep93xx_spi_dma_finish(espi, DMA_DEV_TO_MEM);
+		ep93xx_spi_dma_finish(master, DMA_DEV_TO_MEM);
 		dev_err(&espi->pdev->dev, "DMA TX failed: %ld\n", PTR_ERR(rxd));
 		msg->status = PTR_ERR(txd);
 		return;
@@ -588,13 +593,13 @@ static void ep93xx_spi_dma_transfer(struct ep93xx_spi *espi)
 
 	wait_for_completion(&espi->wait);
 
-	ep93xx_spi_dma_finish(espi, DMA_MEM_TO_DEV);
-	ep93xx_spi_dma_finish(espi, DMA_DEV_TO_MEM);
+	ep93xx_spi_dma_finish(master, DMA_MEM_TO_DEV);
+	ep93xx_spi_dma_finish(master, DMA_DEV_TO_MEM);
 }
 
 /**
  * ep93xx_spi_process_transfer() - processes one SPI transfer
- * @espi: ep93xx SPI controller struct
+ * @master: spi_master struct
  * @msg: current message
  * @t: transfer to process
  *
@@ -602,10 +607,11 @@ static void ep93xx_spi_dma_transfer(struct ep93xx_spi *espi)
  * transfer is complete (may sleep) and updates @msg->status based on whether
  * transfer was successfully processed or not.
  */
-static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
+static void ep93xx_spi_process_transfer(struct spi_master *master,
 					struct spi_message *msg,
 					struct spi_transfer *t)
 {
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
 	struct ep93xx_spi_chip *chip = spi_get_ctldata(msg->spi);
 	int err;
 
@@ -628,9 +634,9 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
 	 * So in these cases we will be using PIO and don't bother for DMA.
 	 */
 	if (espi->dma_rx && t->len > SPI_FIFO_SIZE)
-		ep93xx_spi_dma_transfer(espi);
+		ep93xx_spi_dma_transfer(master);
 	else
-		ep93xx_spi_pio_transfer(espi);
+		ep93xx_spi_pio_transfer(master);
 
 	/*
 	 * In case of error during transmit, we bail out from processing
@@ -665,7 +671,7 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
 
 /*
  * ep93xx_spi_process_message() - process one SPI message
- * @espi: ep93xx SPI controller struct
+ * @master: spi_master struct
  * @msg: message to process
  *
  * This function processes a single SPI message. We go through all transfers in
@@ -675,9 +681,10 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
  * @msg->status contains %0 in case of success or negative error code in case of
  * failure.
  */
-static void ep93xx_spi_process_message(struct ep93xx_spi *espi,
+static void ep93xx_spi_process_message(struct spi_master *master,
 				       struct spi_message *msg)
 {
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
 	unsigned long timeout;
 	struct spi_transfer *t;
 	int err;
@@ -718,7 +725,7 @@ static void ep93xx_spi_process_message(struct ep93xx_spi *espi,
 	ep93xx_spi_cs_control(msg->spi, true);
 
 	list_for_each_entry(t, &msg->transfers, transfer_list) {
-		ep93xx_spi_process_transfer(espi, msg, t);
+		ep93xx_spi_process_transfer(master, msg, t);
 		if (msg->status)
 			break;
 	}
@@ -747,9 +754,7 @@ static int ep93xx_spi_transfer_one_message(struct spi_master *master,
 	msg->status = 0;
 	msg->actual_length = 0;
 
-	espi->current_msg = msg;
-	ep93xx_spi_process_message(espi, msg);
-	espi->current_msg = NULL;
+	ep93xx_spi_process_message(master, msg);
 
 	spi_finalize_current_message(master);
 
@@ -758,7 +763,8 @@ static int ep93xx_spi_transfer_one_message(struct spi_master *master,
 
 static irqreturn_t ep93xx_spi_interrupt(int irq, void *dev_id)
 {
-	struct ep93xx_spi *espi = dev_id;
+	struct spi_master *master = dev_id;
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
 	u8 irq_status = ep93xx_spi_read_u8(espi, SSPIIR);
 
 	/*
@@ -770,13 +776,13 @@ static irqreturn_t ep93xx_spi_interrupt(int irq, void *dev_id)
 		ep93xx_spi_write_u8(espi, SSPICR, 0);
 		dev_warn(&espi->pdev->dev,
 			 "receive overrun, aborting the message\n");
-		espi->current_msg->status = -EIO;
+		master->cur_msg->status = -EIO;
 	} else {
 		/*
 		 * Interrupt is either RX (RIS) or TX (TIS). For both cases we
 		 * simply execute next data transfer.
 		 */
-		if (ep93xx_spi_read_write(espi)) {
+		if (ep93xx_spi_read_write(master)) {
 			/*
 			 * In normal case, there still is some processing left
 			 * for current transfer. Let's wait for the next
@@ -805,8 +811,9 @@ static bool ep93xx_spi_dma_filter(struct dma_chan *chan, void *filter_param)
 	return true;
 }
 
-static int ep93xx_spi_setup_dma(struct ep93xx_spi *espi)
+static int ep93xx_spi_setup_dma(struct spi_master *master)
 {
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
 	dma_cap_mask_t mask;
 	int ret;
 
@@ -850,8 +857,10 @@ fail_free_page:
 	return ret;
 }
 
-static void ep93xx_spi_release_dma(struct ep93xx_spi *espi)
+static void ep93xx_spi_release_dma(struct spi_master *master)
 {
+	struct ep93xx_spi *espi = spi_master_get_devdata(master);
+
 	if (espi->dma_rx) {
 		dma_release_channel(espi->dma_rx);
 		sg_free_table(&espi->rx_sgt);
@@ -930,13 +939,13 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	}
 
 	error = devm_request_irq(&pdev->dev, irq, ep93xx_spi_interrupt,
-				0, "ep93xx-spi", espi);
+				0, "ep93xx-spi", master);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq\n");
 		goto fail_release_master;
 	}
 
-	if (info->use_dma && ep93xx_spi_setup_dma(espi))
+	if (info->use_dma && ep93xx_spi_setup_dma(master))
 		dev_warn(&pdev->dev, "DMA setup failed. Falling back to PIO\n");
 
 	/* make sure that the hardware is disabled */
@@ -954,7 +963,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	return 0;
 
 fail_free_dma:
-	ep93xx_spi_release_dma(espi);
+	ep93xx_spi_release_dma(master);
 fail_release_master:
 	spi_master_put(master);
 
@@ -964,11 +973,10 @@ fail_release_master:
 static int ep93xx_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
-	struct ep93xx_spi *espi = spi_master_get_devdata(master);
-
-	ep93xx_spi_release_dma(espi);
 
+	ep93xx_spi_release_dma(master);
 	spi_unregister_master(master);
+
 	return 0;
 }
 
-- 
1.8.1.4

