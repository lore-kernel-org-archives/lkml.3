Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaAHF4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 00:56:55 -0500
Received: from nasmtp02.atmel.com ([204.2.163.16]:31732 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754901AbaAHF4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 00:56:35 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2014 00:56:34 EST
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <richard.genoud@gmail.com>,
        <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <wenyou.yang@atmel.com>
Subject: [PATCH] spi: atmel: Refactor spi-atmel to use SPI framework queue
Date: Wed, 8 Jan 2014 13:49:48 +0800
Message-ID: <1389160188-4030-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the deprecated master->transfer with transfer_one_message()
and allow the SPI subsystem handle all the queuing of messages.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
Hi Mark,

The patch is based on for-next branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git

It is tested on sama5d3xek and at91sam9m10g45ek board.

Best Regards,
Wenyou Yang

 drivers/spi/spi-atmel.c |  681 +++++++++++++++--------------------------------
 1 file changed, 220 insertions(+), 461 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 57fa738..2a8c1d0 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -189,6 +189,8 @@
  */
 #define DMA_MIN_BYTES	16
 
+#define SPI_DMA_TIMEOUT		(msecs_to_jiffies(1000))
+
 struct atmel_spi_dma {
 	struct dma_chan			*chan_rx;
 	struct dma_chan			*chan_tx;
@@ -220,17 +222,14 @@ struct atmel_spi {
 	int			irq;
 	struct clk		*clk;
 	struct platform_device	*pdev;
-	struct spi_device	*stay;
 
 	u8			stopping;
-	struct list_head	queue;
-	struct tasklet_struct	tasklet;
 	struct spi_transfer	*current_transfer;
 	unsigned long		current_remaining_bytes;
-	struct spi_transfer	*next_transfer;
-	unsigned long		next_remaining_bytes;
 	int			done_status;
 
+	struct completion	xfer_completion;
+
 	/* scratch buffer */
 	void			*buffer;
 	dma_addr_t		buffer_dma;
@@ -376,17 +375,6 @@ static inline bool atmel_spi_use_dma(struct atmel_spi *as,
 	return as->use_dma && xfer->len >= DMA_MIN_BYTES;
 }
 
-static inline int atmel_spi_xfer_is_last(struct spi_message *msg,
-					struct spi_transfer *xfer)
-{
-	return msg->transfers.prev == &xfer->transfer_list;
-}
-
-static inline int atmel_spi_xfer_can_be_chained(struct spi_transfer *xfer)
-{
-	return xfer->delay_usecs == 0 && !xfer->cs_change;
-}
-
 static int atmel_spi_dma_slave_config(struct atmel_spi *as,
 				struct dma_slave_config *slave_config,
 				u8 bits_per_word)
@@ -507,29 +495,28 @@ static void atmel_spi_release_dma(struct atmel_spi *as)
 		dma_release_channel(as->dma.chan_tx);
 }
 
-/* This function is called by the DMA driver from tasklet context */
+/* This function is called by the DMA driver */
 static void dma_callback(void *data)
 {
 	struct spi_master	*master = data;
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 
-	/* trigger SPI tasklet */
-	tasklet_schedule(&as->tasklet);
+	atmel_spi_lock(as);
+	complete(&as->xfer_completion);
+	atmel_spi_unlock(as);
 }
 
 /*
  * Next transfer using PIO.
- * lock is held, spi tasklet is blocked
  */
 static void atmel_spi_next_xfer_pio(struct spi_master *master,
 				struct spi_transfer *xfer)
 {
 	struct atmel_spi	*as = spi_master_get_devdata(master);
+	unsigned long xfer_pos = xfer->len - as->current_remaining_bytes;
 
 	dev_vdbg(master->dev.parent, "atmel_spi_next_xfer_pio\n");
 
-	as->current_remaining_bytes = xfer->len;
-
 	/* Make sure data is not remaining in RDR */
 	spi_readl(as, RDR);
 	while (spi_readl(as, SR) & SPI_BIT(RDRF)) {
@@ -537,13 +524,14 @@ static void atmel_spi_next_xfer_pio(struct spi_master *master,
 		cpu_relax();
 	}
 
-	if (xfer->tx_buf)
+	if (xfer->tx_buf) {
 		if (xfer->bits_per_word > 8)
-			spi_writel(as, TDR, *(u16 *)(xfer->tx_buf));
+			spi_writel(as, TDR, *(u16 *)(xfer->tx_buf + xfer_pos));
 		else
-			spi_writel(as, TDR, *(u8 *)(xfer->tx_buf));
-	else
+			spi_writel(as, TDR, *(u8 *)(xfer->tx_buf + xfer_pos));
+	} else {
 		spi_writel(as, TDR, 0);
+	}
 
 	dev_dbg(master->dev.parent,
 		"  start pio xfer %p: len %u tx %p rx %p bitpw %d\n",
@@ -556,7 +544,6 @@ static void atmel_spi_next_xfer_pio(struct spi_master *master,
 
 /*
  * Submit next transfer for DMA.
- * lock is held, spi tasklet is blocked
  */
 static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 				struct spi_transfer *xfer,
@@ -696,72 +683,39 @@ static void atmel_spi_next_xfer_data(struct spi_master *master,
 
 /*
  * Submit next transfer for PDC.
- * lock is held, spi irq is blocked
  */
 static void atmel_spi_pdc_next_xfer(struct spi_master *master,
-				struct spi_message *msg)
+					struct spi_message *msg,
+					struct spi_transfer *xfer)
 {
 	struct atmel_spi	*as = spi_master_get_devdata(master);
-	struct spi_transfer	*xfer;
-	u32			len, remaining;
-	u32			ieval;
+	u32			len;
 	dma_addr_t		tx_dma, rx_dma;
 
-	if (!as->current_transfer)
-		xfer = list_entry(msg->transfers.next,
-				struct spi_transfer, transfer_list);
-	else if (!as->next_transfer)
-		xfer = list_entry(as->current_transfer->transfer_list.next,
-				struct spi_transfer, transfer_list);
-	else
-		xfer = NULL;
+	spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
 
-	if (xfer) {
-		spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
+	len = as->current_remaining_bytes;
+	atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
+	as->current_remaining_bytes -= len;
 
-		len = xfer->len;
-		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
-		remaining = xfer->len - len;
+	spi_writel(as, RPR, rx_dma);
+	spi_writel(as, TPR, tx_dma);
 
-		spi_writel(as, RPR, rx_dma);
-		spi_writel(as, TPR, tx_dma);
+	if (msg->spi->bits_per_word > 8)
+		len >>= 1;
+	spi_writel(as, RCR, len);
+	spi_writel(as, TCR, len);
 
-		if (msg->spi->bits_per_word > 8)
-			len >>= 1;
-		spi_writel(as, RCR, len);
-		spi_writel(as, TCR, len);
-
-		dev_dbg(&msg->spi->dev,
-			"  start xfer %p: len %u tx %p/%08llx rx %p/%08llx\n",
-			xfer, xfer->len, xfer->tx_buf,
-			(unsigned long long)xfer->tx_dma, xfer->rx_buf,
-			(unsigned long long)xfer->rx_dma);
-	} else {
-		xfer = as->next_transfer;
-		remaining = as->next_remaining_bytes;
-	}
-
-	as->current_transfer = xfer;
-	as->current_remaining_bytes = remaining;
-
-	if (remaining > 0)
-		len = remaining;
-	else if (!atmel_spi_xfer_is_last(msg, xfer)
-			&& atmel_spi_xfer_can_be_chained(xfer)) {
-		xfer = list_entry(xfer->transfer_list.next,
-				struct spi_transfer, transfer_list);
-		len = xfer->len;
-	} else
-		xfer = NULL;
+	dev_dbg(&msg->spi->dev,
+		"  start xfer %p: len %u tx %p/%08llx rx %p/%08llx\n",
+		xfer, xfer->len, xfer->tx_buf,
+		(unsigned long long)xfer->tx_dma, xfer->rx_buf,
+		(unsigned long long)xfer->rx_dma);
 
-	as->next_transfer = xfer;
-
-	if (xfer) {
-		u32	total;
-
-		total = len;
+	if (as->current_remaining_bytes) {
+		len = as->current_remaining_bytes;
 		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
-		as->next_remaining_bytes = total - len;
+		as->current_remaining_bytes -= len;
 
 		spi_writel(as, RNPR, rx_dma);
 		spi_writel(as, TNPR, tx_dma);
@@ -776,11 +730,6 @@ static void atmel_spi_pdc_next_xfer(struct spi_master *master,
 			xfer, xfer->len, xfer->tx_buf,
 			(unsigned long long)xfer->tx_dma, xfer->rx_buf,
 			(unsigned long long)xfer->rx_dma);
-		ieval = SPI_BIT(ENDRX) | SPI_BIT(OVRES);
-	} else {
-		spi_writel(as, RNCR, 0);
-		spi_writel(as, TNCR, 0);
-		ieval = SPI_BIT(RXBUFF) | SPI_BIT(ENDRX) | SPI_BIT(OVRES);
 	}
 
 	/* REVISIT: We're waiting for ENDRX before we start the next
@@ -793,83 +742,11 @@ static void atmel_spi_pdc_next_xfer(struct spi_master *master,
 	 *
 	 * It should be doable, though. Just not now...
 	 */
-	spi_writel(as, IER, ieval);
+	spi_writel(as, IER, SPI_BIT(ENDRX) | SPI_BIT(OVRES));
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
 }
 
 /*
- * Choose way to submit next transfer and start it.
- * lock is held, spi tasklet is blocked
- */
-static void atmel_spi_dma_next_xfer(struct spi_master *master,
-				struct spi_message *msg)
-{
-	struct atmel_spi	*as = spi_master_get_devdata(master);
-	struct spi_transfer	*xfer;
-	u32	remaining, len;
-
-	remaining = as->current_remaining_bytes;
-	if (remaining) {
-		xfer = as->current_transfer;
-		len = remaining;
-	} else {
-		if (!as->current_transfer)
-			xfer = list_entry(msg->transfers.next,
-				struct spi_transfer, transfer_list);
-		else
-			xfer = list_entry(
-				as->current_transfer->transfer_list.next,
-					struct spi_transfer, transfer_list);
-
-		as->current_transfer = xfer;
-		len = xfer->len;
-	}
-
-	if (atmel_spi_use_dma(as, xfer)) {
-		u32 total = len;
-		if (!atmel_spi_next_xfer_dma_submit(master, xfer, &len)) {
-			as->current_remaining_bytes = total - len;
-			return;
-		} else {
-			dev_err(&msg->spi->dev, "unable to use DMA, fallback to PIO\n");
-		}
-	}
-
-	/* use PIO if error appened using DMA */
-	atmel_spi_next_xfer_pio(master, xfer);
-}
-
-static void atmel_spi_next_message(struct spi_master *master)
-{
-	struct atmel_spi	*as = spi_master_get_devdata(master);
-	struct spi_message	*msg;
-	struct spi_device	*spi;
-
-	BUG_ON(as->current_transfer);
-
-	msg = list_entry(as->queue.next, struct spi_message, queue);
-	spi = msg->spi;
-
-	dev_dbg(master->dev.parent, "start message %p for %s\n",
-			msg, dev_name(&spi->dev));
-
-	/* select chip if it's not still active */
-	if (as->stay) {
-		if (as->stay != spi) {
-			cs_deactivate(as, as->stay);
-			cs_activate(as, spi);
-		}
-		as->stay = NULL;
-	} else
-		cs_activate(as, spi);
-
-	if (as->use_pdc)
-		atmel_spi_pdc_next_xfer(master, msg);
-	else
-		atmel_spi_dma_next_xfer(master, msg);
-}
-
-/*
  * For DMA, tx_buf/tx_dma have the same relationship as rx_buf/rx_dma:
  *  - The buffer is either valid for CPU access, else NULL
  *  - If the buffer is valid, so is its DMA address
@@ -924,41 +801,7 @@ static void atmel_spi_disable_pdc_transfer(struct atmel_spi *as)
 	spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
 }
 
-static void
-atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
-		struct spi_message *msg, int stay)
-{
-	if (!stay || as->done_status < 0)
-		cs_deactivate(as, msg->spi);
-	else
-		as->stay = msg->spi;
-
-	list_del(&msg->queue);
-	msg->status = as->done_status;
-
-	dev_dbg(master->dev.parent,
-		"xfer complete: %u bytes transferred\n",
-		msg->actual_length);
-
-	atmel_spi_unlock(as);
-	msg->complete(msg->context);
-	atmel_spi_lock(as);
-
-	as->current_transfer = NULL;
-	as->next_transfer = NULL;
-	as->done_status = 0;
-
-	/* continue if needed */
-	if (list_empty(&as->queue) || as->stopping) {
-		if (as->use_pdc)
-			atmel_spi_disable_pdc_transfer(as);
-	} else {
-		atmel_spi_next_message(master);
-	}
-}
-
 /* Called from IRQ
- * lock is held
  *
  * Must update "current_remaining_bytes" to keep track of data
  * to transfer.
@@ -966,9 +809,7 @@ atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
 static void
 atmel_spi_pump_pio_data(struct atmel_spi *as, struct spi_transfer *xfer)
 {
-	u8		*txp;
 	u8		*rxp;
-	u16		*txp16;
 	u16		*rxp16;
 	unsigned long	xfer_pos = xfer->len - as->current_remaining_bytes;
 
@@ -990,96 +831,12 @@ atmel_spi_pump_pio_data(struct atmel_spi *as, struct spi_transfer *xfer)
 	} else {
 		as->current_remaining_bytes--;
 	}
-
-	if (as->current_remaining_bytes) {
-		if (xfer->tx_buf) {
-			if (xfer->bits_per_word > 8) {
-				txp16 = (u16 *)(((u8 *)xfer->tx_buf)
-							+ xfer_pos + 2);
-				spi_writel(as, TDR, *txp16);
-			} else {
-				txp = ((u8 *)xfer->tx_buf) + xfer_pos + 1;
-				spi_writel(as, TDR, *txp);
-			}
-		} else {
-			spi_writel(as, TDR, 0);
-		}
-	}
-}
-
-/* Tasklet
- * Called from DMA callback + pio transfer and overrun IRQ.
- */
-static void atmel_spi_tasklet_func(unsigned long data)
-{
-	struct spi_master	*master = (struct spi_master *)data;
-	struct atmel_spi	*as = spi_master_get_devdata(master);
-	struct spi_message	*msg;
-	struct spi_transfer	*xfer;
-
-	dev_vdbg(master->dev.parent, "atmel_spi_tasklet_func\n");
-
-	atmel_spi_lock(as);
-
-	xfer = as->current_transfer;
-
-	if (xfer == NULL)
-		/* already been there */
-		goto tasklet_out;
-
-	msg = list_entry(as->queue.next, struct spi_message, queue);
-
-	if (as->current_remaining_bytes == 0) {
-		if (as->done_status < 0) {
-			/* error happened (overrun) */
-			if (atmel_spi_use_dma(as, xfer))
-				atmel_spi_stop_dma(as);
-		} else {
-			/* only update length if no error */
-			msg->actual_length += xfer->len;
-		}
-
-		if (atmel_spi_use_dma(as, xfer))
-			if (!msg->is_dma_mapped)
-				atmel_spi_dma_unmap_xfer(master, xfer);
-
-		if (xfer->delay_usecs)
-			udelay(xfer->delay_usecs);
-
-		if (atmel_spi_xfer_is_last(msg, xfer) || as->done_status < 0) {
-			/* report completed (or erroneous) message */
-			atmel_spi_msg_done(master, as, msg, xfer->cs_change);
-		} else {
-			if (xfer->cs_change) {
-				cs_deactivate(as, msg->spi);
-				udelay(1);
-				cs_activate(as, msg->spi);
-			}
-
-			/*
-			 * Not done yet. Submit the next transfer.
-			 *
-			 * FIXME handle protocol options for xfer
-			 */
-			atmel_spi_dma_next_xfer(master, msg);
-		}
-	} else {
-		/*
-		 * Keep going, we still have data to send in
-		 * the current transfer.
-		 */
-		atmel_spi_dma_next_xfer(master, msg);
-	}
-
-tasklet_out:
-	atmel_spi_unlock(as);
 }
 
 /* Interrupt
  *
  * No need for locking in this Interrupt handler: done_status is the
- * only information modified. What we need is the update of this field
- * before tasklet runs. This is ensured by using barrier.
+ * only information modified.
  */
 static irqreturn_t
 atmel_spi_pio_interrupt(int irq, void *dev_id)
@@ -1107,8 +864,6 @@ atmel_spi_pio_interrupt(int irq, void *dev_id)
 		 *
 		 * We will also not process any remaning transfers in
 		 * the message.
-		 *
-		 * All actions are done in tasklet with done_status indication
 		 */
 		as->done_status = -EIO;
 		smp_wmb();
@@ -1116,7 +871,9 @@ atmel_spi_pio_interrupt(int irq, void *dev_id)
 		/* Clear any overrun happening while cleaning up */
 		spi_readl(as, SR);
 
-		tasklet_schedule(&as->tasklet);
+		atmel_spi_lock(as);
+		complete(&as->xfer_completion);
+		atmel_spi_unlock(as);
 
 	} else if (pending & SPI_BIT(RDRF)) {
 		atmel_spi_lock(as);
@@ -1125,11 +882,10 @@ atmel_spi_pio_interrupt(int irq, void *dev_id)
 			ret = IRQ_HANDLED;
 			xfer = as->current_transfer;
 			atmel_spi_pump_pio_data(as, xfer);
-			if (!as->current_remaining_bytes) {
-				/* no more data to xfer, kick tasklet */
+			if (!as->current_remaining_bytes)
 				spi_writel(as, IDR, pending);
-				tasklet_schedule(&as->tasklet);
-			}
+
+			complete(&as->xfer_completion);
 		}
 
 		atmel_spi_unlock(as);
@@ -1147,116 +903,37 @@ atmel_spi_pdc_interrupt(int irq, void *dev_id)
 {
 	struct spi_master	*master = dev_id;
 	struct atmel_spi	*as = spi_master_get_devdata(master);
-	struct spi_message	*msg;
-	struct spi_transfer	*xfer;
 	u32			status, pending, imr;
 	int			ret = IRQ_NONE;
 
-	atmel_spi_lock(as);
-
-	xfer = as->current_transfer;
-	msg = list_entry(as->queue.next, struct spi_message, queue);
-
 	imr = spi_readl(as, IMR);
 	status = spi_readl(as, SR);
 	pending = status & imr;
 
 	if (pending & SPI_BIT(OVRES)) {
-		int timeout;
-
 		ret = IRQ_HANDLED;
 
 		spi_writel(as, IDR, (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX)
 				     | SPI_BIT(OVRES)));
 
-		/*
-		 * When we get an overrun, we disregard the current
-		 * transfer. Data will not be copied back from any
-		 * bounce buffer and msg->actual_len will not be
-		 * updated with the last xfer.
-		 *
-		 * We will also not process any remaning transfers in
-		 * the message.
-		 *
-		 * First, stop the transfer and unmap the DMA buffers.
-		 */
-		spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
-		if (!msg->is_dma_mapped)
-			atmel_spi_dma_unmap_xfer(master, xfer);
-
-		/* REVISIT: udelay in irq is unfriendly */
-		if (xfer->delay_usecs)
-			udelay(xfer->delay_usecs);
-
-		dev_warn(master->dev.parent, "overrun (%u/%u remaining)\n",
-			 spi_readl(as, TCR), spi_readl(as, RCR));
-
-		/*
-		 * Clean up DMA registers and make sure the data
-		 * registers are empty.
-		 */
-		spi_writel(as, RNCR, 0);
-		spi_writel(as, TNCR, 0);
-		spi_writel(as, RCR, 0);
-		spi_writel(as, TCR, 0);
-		for (timeout = 1000; timeout; timeout--)
-			if (spi_readl(as, SR) & SPI_BIT(TXEMPTY))
-				break;
-		if (!timeout)
-			dev_warn(master->dev.parent,
-				 "timeout waiting for TXEMPTY");
-		while (spi_readl(as, SR) & SPI_BIT(RDRF))
-			spi_readl(as, RDR);
-
 		/* Clear any overrun happening while cleaning up */
 		spi_readl(as, SR);
 
+		atmel_spi_lock(as);
 		as->done_status = -EIO;
-		atmel_spi_msg_done(master, as, msg, 0);
+		complete(&as->xfer_completion);
+		atmel_spi_unlock(as);
+
 	} else if (pending & (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX))) {
 		ret = IRQ_HANDLED;
 
 		spi_writel(as, IDR, pending);
 
-		if (as->current_remaining_bytes == 0) {
-			msg->actual_length += xfer->len;
-
-			if (!msg->is_dma_mapped)
-				atmel_spi_dma_unmap_xfer(master, xfer);
-
-			/* REVISIT: udelay in irq is unfriendly */
-			if (xfer->delay_usecs)
-				udelay(xfer->delay_usecs);
-
-			if (atmel_spi_xfer_is_last(msg, xfer)) {
-				/* report completed message */
-				atmel_spi_msg_done(master, as, msg,
-						xfer->cs_change);
-			} else {
-				if (xfer->cs_change) {
-					cs_deactivate(as, msg->spi);
-					udelay(1);
-					cs_activate(as, msg->spi);
-				}
-
-				/*
-				 * Not done yet. Submit the next transfer.
-				 *
-				 * FIXME handle protocol options for xfer
-				 */
-				atmel_spi_pdc_next_xfer(master, msg);
-			}
-		} else {
-			/*
-			 * Keep going, we still have data to send in
-			 * the current transfer.
-			 */
-			atmel_spi_pdc_next_xfer(master, msg);
-		}
+		atmel_spi_lock(as);
+		complete(&as->xfer_completion);
+		atmel_spi_unlock(as);
 	}
 
-	atmel_spi_unlock(as);
-
 	return ret;
 }
 
@@ -1352,12 +1029,6 @@ static int atmel_spi_setup(struct spi_device *spi)
 		asd->npcs_pin = npcs_pin;
 		spi->controller_state = asd;
 		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
-	} else {
-		atmel_spi_lock(as);
-		if (as->stay == spi)
-			as->stay = NULL;
-		cs_deactivate(as, spi);
-		atmel_spi_unlock(as);
 	}
 
 	asd->csr = csr;
@@ -1372,103 +1043,211 @@ static int atmel_spi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
+static int atmel_spi_one_transfer(struct spi_master *master,
+					struct spi_message *msg,
+					struct spi_transfer *xfer)
 {
-	struct atmel_spi	*as;
-	struct spi_transfer	*xfer;
-	struct device		*controller = spi->master->dev.parent;
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+	struct spi_device	*spi = msg->spi;
 	u8			bits;
+	u32			len;
 	struct atmel_spi_device	*asd;
+	int			timeout;
+	int			ret;
 
-	as = spi_master_get_devdata(spi->master);
-
-	dev_dbg(controller, "new message %p submitted for %s\n",
-			msg, dev_name(&spi->dev));
-
-	if (unlikely(list_empty(&msg->transfers)))
+	if (!(xfer->tx_buf || xfer->rx_buf) && xfer->len) {
+		dev_dbg(&spi->dev, "missing rx or tx buf\n");
 		return -EINVAL;
+	}
 
-	if (as->stopping)
-		return -ESHUTDOWN;
+	if (xfer->bits_per_word) {
+		asd = spi->controller_state;
+		bits = (asd->csr >> 4) & 0xf;
+		if (bits != xfer->bits_per_word - 8) {
+			dev_dbg(&spi->dev,
+			"you can't yet change bits_per_word in transfers\n");
+			return -ENOPROTOOPT;
+		}
+	}
 
-	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		if (!(xfer->tx_buf || xfer->rx_buf) && xfer->len) {
-			dev_dbg(&spi->dev, "missing rx or tx buf\n");
+	if (xfer->bits_per_word > 8) {
+		if (xfer->len % 2) {
+			dev_dbg(&spi->dev,
+			"buffer len should be 16 bits aligned\n");
 			return -EINVAL;
 		}
+	}
 
-		if (xfer->bits_per_word) {
-			asd = spi->controller_state;
-			bits = (asd->csr >> 4) & 0xf;
-			if (bits != xfer->bits_per_word - 8) {
-				dev_dbg(&spi->dev,
-					"you can't yet change bits_per_word in transfers\n");
-				return -ENOPROTOOPT;
-			}
-		}
+	/* FIXME implement these protocol options!! */
+	if (xfer->speed_hz < spi->max_speed_hz) {
+		dev_dbg(&spi->dev, "can't change speed in transfer\n");
+		return -ENOPROTOOPT;
+	}
 
-		if (xfer->bits_per_word > 8) {
-			if (xfer->len % 2) {
-				dev_dbg(&spi->dev, "buffer len should be 16 bits aligned\n");
-				return -EINVAL;
+	/*
+	 * DMA map early, for performance (empties dcache ASAP) and
+	 * better fault reporting.
+	 */
+	if ((!msg->is_dma_mapped)
+		&& (atmel_spi_use_dma(as, xfer)	|| as->use_pdc)) {
+		if (atmel_spi_dma_map_xfer(as, xfer) < 0)
+			return -ENOMEM;
+	}
+
+	as->done_status = 0;
+	as->current_transfer = xfer;
+	as->current_remaining_bytes = xfer->len;
+	while (as->current_remaining_bytes) {
+		reinit_completion(&as->xfer_completion);
+
+		if (as->use_pdc) {
+			atmel_spi_pdc_next_xfer(master, msg, xfer);
+		} else if (atmel_spi_use_dma(as, xfer)) {
+			len = as->current_remaining_bytes;
+			ret = atmel_spi_next_xfer_dma_submit(master,
+								xfer, &len);
+			if (ret) {
+				dev_err(&spi->dev,
+					"unable to use DMA, fallback to PIO\n");
+				atmel_spi_next_xfer_pio(master, xfer);
+			} else {
+				as->current_remaining_bytes -= len;
 			}
+		} else {
+			atmel_spi_next_xfer_pio(master, xfer);
 		}
 
-		/* FIXME implement these protocol options!! */
-		if (xfer->speed_hz < spi->max_speed_hz) {
-			dev_dbg(&spi->dev, "can't change speed in transfer\n");
-			return -ENOPROTOOPT;
+		ret = wait_for_completion_timeout(&as->xfer_completion,
+							SPI_DMA_TIMEOUT);
+		if (WARN_ON(ret == 0)) {
+			dev_err(&spi->dev,
+				"spi trasfer timeout, err %d\n", ret);
+			as->done_status = -EIO;
+		} else {
+			ret = 0;
 		}
 
-		/*
-		 * DMA map early, for performance (empties dcache ASAP) and
-		 * better fault reporting.
-		 */
-		if ((!msg->is_dma_mapped) && (atmel_spi_use_dma(as, xfer)
-			|| as->use_pdc)) {
-			if (atmel_spi_dma_map_xfer(as, xfer) < 0)
-				return -ENOMEM;
+		if (as->done_status)
+			break;
+	}
+
+	if (as->done_status) {
+		if (as->use_pdc) {
+			dev_warn(master->dev.parent,
+				"overrun (%u/%u remaining)\n",
+				spi_readl(as, TCR), spi_readl(as, RCR));
+
+			/*
+			 * Clean up DMA registers and make sure the data
+			 * registers are empty.
+			 */
+			spi_writel(as, RNCR, 0);
+			spi_writel(as, TNCR, 0);
+			spi_writel(as, RCR, 0);
+			spi_writel(as, TCR, 0);
+			for (timeout = 1000; timeout; timeout--)
+				if (spi_readl(as, SR) & SPI_BIT(TXEMPTY))
+					break;
+			if (!timeout)
+				dev_warn(master->dev.parent,
+					 "timeout waiting for TXEMPTY");
+			while (spi_readl(as, SR) & SPI_BIT(RDRF))
+				spi_readl(as, RDR);
+
+			/* Clear any overrun happening while cleaning up */
+			spi_readl(as, SR);
+
+		} else if (atmel_spi_use_dma(as, xfer)) {
+			atmel_spi_stop_dma(as);
 		}
+
+		if (!msg->is_dma_mapped
+			&& (atmel_spi_use_dma(as, xfer) || as->use_pdc))
+			atmel_spi_dma_unmap_xfer(master, xfer);
+
+		return 0;
+
+	} else {
+		/* only update length if no error */
+		msg->actual_length += xfer->len;
+	}
+
+	if (!msg->is_dma_mapped
+		&& (atmel_spi_use_dma(as, xfer) || as->use_pdc))
+		atmel_spi_dma_unmap_xfer(master, xfer);
+
+	if (xfer->delay_usecs)
+		udelay(xfer->delay_usecs);
+
+	if (xfer->cs_change) {
+		cs_deactivate(as, msg->spi);
+		udelay(1);
+		cs_activate(as, msg->spi);
+	}
+
+	return 0;
+}
+
+static int atmel_spi_transfer_one_message(struct spi_master *master,
+						struct spi_message *msg)
+{
+	struct atmel_spi *as;
+	struct spi_transfer *xfer;
+	struct spi_device *spi = msg->spi;
+	int ret = 0;
+
+	as = spi_master_get_devdata(master);
+
+	dev_dbg(&spi->dev, "new message %p submitted for %s\n",
+					msg, dev_name(&spi->dev));
+
+	if (unlikely(list_empty(&msg->transfers)))
+		return -EINVAL;
+
+	if (as->stopping)
+		return -ESHUTDOWN;
+
+	atmel_spi_lock(as);
+	cs_activate(as, spi);
+
+	msg->status = 0;
+	msg->actual_length = 0;
+
+	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
+		ret = atmel_spi_one_transfer(master, msg, xfer);
+		if (ret)
+			goto msg_done;
 	}
 
-#ifdef VERBOSE
+	if (as->use_pdc)
+		atmel_spi_disable_pdc_transfer(as);
+
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		dev_dbg(controller,
+		dev_dbg(&spi->dev,
 			"  xfer %p: len %u tx %p/%08x rx %p/%08x\n",
 			xfer, xfer->len,
 			xfer->tx_buf, xfer->tx_dma,
 			xfer->rx_buf, xfer->rx_dma);
 	}
-#endif
 
-	msg->status = -EINPROGRESS;
-	msg->actual_length = 0;
-
-	atmel_spi_lock(as);
-	list_add_tail(&msg->queue, &as->queue);
-	if (!as->current_transfer)
-		atmel_spi_next_message(spi->master);
+msg_done:
+	cs_deactivate(as, msg->spi);
 	atmel_spi_unlock(as);
 
-	return 0;
+	msg->status = as->done_status;
+	spi_finalize_current_message(spi->master);
+
+	return ret;
 }
 
 static void atmel_spi_cleanup(struct spi_device *spi)
 {
-	struct atmel_spi	*as = spi_master_get_devdata(spi->master);
 	struct atmel_spi_device	*asd = spi->controller_state;
 	unsigned		gpio = (unsigned) spi->controller_data;
 
 	if (!asd)
 		return;
 
-	atmel_spi_lock(as);
-	if (as->stay == spi) {
-		as->stay = NULL;
-		cs_deactivate(as, spi);
-	}
-	atmel_spi_unlock(as);
-
 	spi->controller_state = NULL;
 	gpio_free(gpio);
 	kfree(asd);
@@ -1527,7 +1306,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->num_chipselect = master->dev.of_node ? 0 : 4;
 	master->setup = atmel_spi_setup;
-	master->transfer = atmel_spi_transfer;
+	master->transfer_one_message = atmel_spi_transfer_one_message;
 	master->cleanup = atmel_spi_cleanup;
 	platform_set_drvdata(pdev, master);
 
@@ -1543,7 +1322,6 @@ static int atmel_spi_probe(struct platform_device *pdev)
 		goto out_free;
 
 	spin_lock_init(&as->lock);
-	INIT_LIST_HEAD(&as->queue);
 
 	as->pdev = pdev;
 	as->regs = devm_ioremap_resource(&pdev->dev, regs);
@@ -1555,6 +1333,8 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	as->irq = irq;
 	as->clk = clk;
 
+	init_completion(&as->xfer_completion);
+
 	atmel_get_caps(as);
 
 	as->use_dma = false;
@@ -1573,9 +1353,6 @@ static int atmel_spi_probe(struct platform_device *pdev)
 		ret = devm_request_irq(&pdev->dev, irq, atmel_spi_pdc_interrupt,
 					0, dev_name(&pdev->dev), master);
 	} else {
-		tasklet_init(&as->tasklet, atmel_spi_tasklet_func,
-					(unsigned long)master);
-
 		ret = devm_request_irq(&pdev->dev, irq, atmel_spi_pio_interrupt,
 					0, dev_name(&pdev->dev), master);
 	}
@@ -1619,8 +1396,6 @@ out_free_dma:
 out_free_irq:
 out_unmap_regs:
 out_free_buffer:
-	if (!as->use_pdc)
-		tasklet_kill(&as->tasklet);
 	dma_free_coherent(&pdev->dev, BUFFER_SIZE, as->buffer,
 			as->buffer_dma);
 out_free:
@@ -1632,8 +1407,6 @@ static int atmel_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master	*master = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
-	struct spi_message	*msg;
-	struct spi_transfer	*xfer;
 
 	/* reset the hardware and block queue progress */
 	spin_lock_irq(&as->lock);
@@ -1648,20 +1421,6 @@ static int atmel_spi_remove(struct platform_device *pdev)
 	spi_readl(as, SR);
 	spin_unlock_irq(&as->lock);
 
-	/* Terminate remaining queued transfers */
-	list_for_each_entry(msg, &as->queue, queue) {
-		list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-			if (!msg->is_dma_mapped
-				&& (atmel_spi_use_dma(as, xfer)
-					|| as->use_pdc))
-				atmel_spi_dma_unmap_xfer(master, xfer);
-		}
-		msg->status = -ESHUTDOWN;
-		msg->complete(msg->context);
-	}
-
-	if (!as->use_pdc)
-		tasklet_kill(&as->tasklet);
 	dma_free_coherent(&pdev->dev, BUFFER_SIZE, as->buffer,
 			as->buffer_dma);
 
-- 
1.7.9.5

