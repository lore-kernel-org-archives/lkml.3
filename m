Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaIXVFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:05:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52678 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIXVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:05:14 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v2] spi: qup: Fix incorrect block transfers
Date: Wed, 24 Sep 2014 16:04:58 -0500
Message-Id: <1411592698-30952-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a number of errors with the QUP block transfer mode.  Errors
manifested themselves as input underruns, output overruns, and timed out
transactions.

The block mode does not require the priming that occurs in FIFO mode.  At the
moment that the QUP is placed into the RUN state, the QUP will immediately raise
an interrupt if the request is a write.  Therefore, there is no need to prime
the pump.

In addition, the block transfers require that whole blocks of data are
read/written at a time.  The last block of data that completes a transaction may
contain less than a full blocks worth of data.

Each block of data results in an input/output service interrupt accompanied with
a input/output block flag set.  Additional block reads/writes require clearing
of the service flag.  It is ok to check for additional blocks of data in the
ISR, but you have to ack every block you transfer.  Imbalanced acks result in
early return from complete transactions with pending interrupts that still have
to be ack'd.  The next transaction can be affected by these interrupts.

Changes from v1:
- Split out read/write block function.
- Removed extraneous checks for transfer length

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/spi/spi-qup.c |  198 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 146 insertions(+), 52 deletions(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 9f83d29..e08cc26 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -80,6 +80,8 @@
 #define QUP_IO_M_MODE_BAM		3
 
 /* QUP_OPERATIONAL fields */
+#define QUP_OP_IN_BLOCK_READ_REQ	BIT(13)
+#define QUP_OP_OUT_BLOCK_WRITE_REQ	BIT(12)
 #define QUP_OP_MAX_INPUT_DONE_FLAG	BIT(11)
 #define QUP_OP_MAX_OUTPUT_DONE_FLAG	BIT(10)
 #define QUP_OP_IN_SERVICE_FLAG		BIT(9)
@@ -143,6 +145,7 @@ struct spi_qup {
 	int			tx_bytes;
 	int			rx_bytes;
 	int			qup_v1;
+	int			mode;
 };
 
 
@@ -198,30 +201,14 @@ static int spi_qup_set_state(struct spi_qup *controller, u32 state)
 	return 0;
 }
 
-
-static void spi_qup_fifo_read(struct spi_qup *controller,
-			    struct spi_transfer *xfer)
+static void spi_qup_fill_read_buffer(struct spi_qup *controller,
+	struct spi_transfer *xfer, u32 data)
 {
 	u8 *rx_buf = xfer->rx_buf;
-	u32 word, state;
-	int idx, shift, w_size;
-
-	w_size = controller->w_size;
-
-	while (controller->rx_bytes < xfer->len) {
-
-		state = readl_relaxed(controller->base + QUP_OPERATIONAL);
-		if (0 == (state & QUP_OP_IN_FIFO_NOT_EMPTY))
-			break;
-
-		word = readl_relaxed(controller->base + QUP_INPUT_FIFO);
-
-		if (!rx_buf) {
-			controller->rx_bytes += w_size;
-			continue;
-		}
+	int idx, shift;
 
-		for (idx = 0; idx < w_size; idx++, controller->rx_bytes++) {
+	if (rx_buf)
+		for (idx = 0; idx < controller->w_size; idx++) {
 			/*
 			 * The data format depends on bytes per SPI word:
 			 *  4 bytes: 0x12345678
@@ -229,41 +216,139 @@ static void spi_qup_fifo_read(struct spi_qup *controller,
 			 *  1 byte : 0x00000012
 			 */
 			shift = BITS_PER_BYTE;
-			shift *= (w_size - idx - 1);
-			rx_buf[controller->rx_bytes] = word >> shift;
+			shift *= (controller->w_size - idx - 1);
+			rx_buf[controller->rx_bytes + idx] = data >> shift;
 		}
+
+	controller->rx_bytes += controller->w_size;
+}
+
+static void spi_qup_prepare_write_data(struct spi_qup *controller,
+	struct spi_transfer *xfer, u32 *data)
+{
+	const u8 *tx_buf = xfer->tx_buf;
+	u32 val;
+	int idx;
+
+	*data = 0;
+
+	if (tx_buf)
+		for (idx = 0; idx < controller->w_size; idx++) {
+			val = tx_buf[controller->tx_bytes + idx];
+			*data |= val << (BITS_PER_BYTE * (3 - idx));
+		}
+
+	controller->tx_bytes += controller->w_size;
+}
+
+static void spi_qup_fifo_read(struct spi_qup *controller,
+			    struct spi_transfer *xfer)
+{
+	u32 data;
+
+	/* clear service request */
+	writel_relaxed(QUP_OP_IN_SERVICE_FLAG,
+		controller->base + QUP_OPERATIONAL);
+
+	while (controller->rx_bytes < xfer->len) {
+		if (!(readl_relaxed(controller->base + QUP_OPERATIONAL) &
+			QUP_OP_IN_FIFO_NOT_EMPTY))
+			break;
+
+		data = readl_relaxed(controller->base + QUP_INPUT_FIFO);
+
+		spi_qup_fill_read_buffer(controller, xfer, data);
 	}
 }
 
 static void spi_qup_fifo_write(struct spi_qup *controller,
-			    struct spi_transfer *xfer)
+			    struct spi_transfer *xfer, bool irq)
 {
-	const u8 *tx_buf = xfer->tx_buf;
-	u32 word, state, data;
-	int idx, w_size;
+	u32 data;
 
-	w_size = controller->w_size;
+	/* clear service request */
+	writel_relaxed(QUP_OP_OUT_SERVICE_FLAG,
+		controller->base + QUP_OPERATIONAL);
 
 	while (controller->tx_bytes < xfer->len) {
 
-		state = readl_relaxed(controller->base + QUP_OPERATIONAL);
-		if (state & QUP_OP_OUT_FIFO_FULL)
+		if (readl_relaxed(controller->base + QUP_OPERATIONAL) &
+				QUP_OP_OUT_FIFO_FULL)
 			break;
 
-		word = 0;
-		for (idx = 0; idx < w_size; idx++, controller->tx_bytes++) {
+		spi_qup_prepare_write_data(controller, xfer, &data);
+		writel_relaxed(data, controller->base + QUP_OUTPUT_FIFO);
 
-			if (!tx_buf) {
-				controller->tx_bytes += w_size;
-				break;
-			}
+	}
+}
 
-			data = tx_buf[controller->tx_bytes];
-			word |= data << (BITS_PER_BYTE * (3 - idx));
+static void spi_qup_block_read(struct spi_qup *controller,
+	struct spi_transfer *xfer)
+{
+	u32 data;
+	u32 words_per_blk = controller->in_blk_sz >> 2;
+	u32 num_words = (xfer->len - controller->rx_bytes) / controller->w_size;
+	int i;
+
+	do {
+		/* ACK by clearing service flag */
+		writel_relaxed(QUP_OP_IN_SERVICE_FLAG,
+			controller->base + QUP_OPERATIONAL);
+
+		/* transfer up to a block size of data in a single pass */
+		for (i = 0; num_words && i < words_per_blk; i++, num_words--) {
+
+			/* read data and fill up rx buffer */
+			data = readl_relaxed(controller->base + QUP_INPUT_FIFO);
+			spi_qup_fill_read_buffer(controller, xfer, data);
 		}
 
-		writel_relaxed(word, controller->base + QUP_OUTPUT_FIFO);
-	}
+		/* check to see if next block is ready */
+		if (!(readl_relaxed(controller->base + QUP_OPERATIONAL) &
+			QUP_OP_IN_BLOCK_READ_REQ))
+			break;
+
+	} while (num_words);
+
+	/*
+	 * Due to extra stickiness of the QUP_OP_IN_SERVICE_FLAG during block
+	 * reads, it has to be cleared again at the very end
+	 */
+	if (readl_relaxed(controller->base + QUP_OPERATIONAL) &
+		QUP_OP_MAX_INPUT_DONE_FLAG)
+		writel_relaxed(QUP_OP_IN_SERVICE_FLAG,
+			controller->base + QUP_OPERATIONAL);
+
+}
+
+static void spi_qup_block_write(struct spi_qup *controller,
+	struct spi_transfer *xfer)
+{
+	u32 data;
+	u32 words_per_blk = controller->out_blk_sz >> 2;
+	u32 num_words = (xfer->len - controller->tx_bytes) / controller->w_size;
+	int i;
+
+	do {
+		/* ACK by clearing service flag */
+		writel_relaxed(QUP_OP_OUT_SERVICE_FLAG,
+			controller->base + QUP_OPERATIONAL);
+
+		/* transfer up to a block size of data in a single pass */
+		for (i = 0; num_words && i < words_per_blk; i++, num_words--) {
+
+			/* swizzle the bytes for output and write out */
+			spi_qup_prepare_write_data(controller, xfer, &data);
+			writel_relaxed(data,
+				controller->base + QUP_OUTPUT_FIFO);
+		}
+
+		/* check to see if next block is ready */
+		if (!(readl_relaxed(controller->base + QUP_OPERATIONAL) &
+			QUP_OP_OUT_BLOCK_WRITE_REQ))
+			break;
+
+	} while (num_words);
 }
 
 static irqreturn_t spi_qup_qup_irq(int irq, void *dev_id)
@@ -285,9 +370,9 @@ static irqreturn_t spi_qup_qup_irq(int irq, void *dev_id)
 
 	writel_relaxed(qup_err, controller->base + QUP_ERROR_FLAGS);
 	writel_relaxed(spi_err, controller->base + SPI_ERROR_FLAGS);
-	writel_relaxed(opflags, controller->base + QUP_OPERATIONAL);
 
 	if (!xfer) {
+		writel_relaxed(opflags, controller->base + QUP_OPERATIONAL);
 		dev_err_ratelimited(controller->dev, "unexpected irq %08x %08x %08x\n",
 				    qup_err, spi_err, opflags);
 		return IRQ_HANDLED;
@@ -315,11 +400,19 @@ static irqreturn_t spi_qup_qup_irq(int irq, void *dev_id)
 		error = -EIO;
 	}
 
-	if (opflags & QUP_OP_IN_SERVICE_FLAG)
-		spi_qup_fifo_read(controller, xfer);
+	if (opflags & QUP_OP_IN_SERVICE_FLAG) {
+		if (opflags & QUP_OP_IN_BLOCK_READ_REQ)
+			spi_qup_block_read(controller, xfer);
+		else
+			spi_qup_fifo_read(controller, xfer);
+	}
 
-	if (opflags & QUP_OP_OUT_SERVICE_FLAG)
-		spi_qup_fifo_write(controller, xfer);
+	if (opflags & QUP_OP_OUT_SERVICE_FLAG) {
+		if (opflags & QUP_OP_OUT_BLOCK_WRITE_REQ)
+			spi_qup_block_write(controller, xfer);
+		else
+			spi_qup_fifo_write(controller, xfer,1);
+	}
 
 	spin_lock_irqsave(&controller->lock, flags);
 	controller->error = error;
@@ -332,12 +425,11 @@ static irqreturn_t spi_qup_qup_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-
 /* set clock freq ... bits per word */
 static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
 {
 	struct spi_qup *controller = spi_master_get_devdata(spi->master);
-	u32 config, iomode, mode;
+	u32 config, iomode;
 	int ret, n_words, w_size;
 
 	if (spi->mode & SPI_LOOP && xfer->len > controller->in_fifo_sz) {
@@ -368,14 +460,14 @@ static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
 	controller->w_size = w_size;
 
 	if (n_words <= (controller->in_fifo_sz / sizeof(u32))) {
-		mode = QUP_IO_M_MODE_FIFO;
+		controller->mode = QUP_IO_M_MODE_FIFO;
 		writel_relaxed(n_words, controller->base + QUP_MX_READ_CNT);
 		writel_relaxed(n_words, controller->base + QUP_MX_WRITE_CNT);
 		/* must be zero for FIFO */
 		writel_relaxed(0, controller->base + QUP_MX_INPUT_CNT);
 		writel_relaxed(0, controller->base + QUP_MX_OUTPUT_CNT);
 	} else {
-		mode = QUP_IO_M_MODE_BLOCK;
+		controller->mode = QUP_IO_M_MODE_BLOCK;
 		writel_relaxed(n_words, controller->base + QUP_MX_INPUT_CNT);
 		writel_relaxed(n_words, controller->base + QUP_MX_OUTPUT_CNT);
 		/* must be zero for BLOCK and BAM */
@@ -387,8 +479,8 @@ static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
 	/* Set input and output transfer mode */
 	iomode &= ~(QUP_IO_M_INPUT_MODE_MASK | QUP_IO_M_OUTPUT_MODE_MASK);
 	iomode &= ~(QUP_IO_M_PACK_EN | QUP_IO_M_UNPACK_EN);
-	iomode |= (mode << QUP_IO_M_OUTPUT_MODE_MASK_SHIFT);
-	iomode |= (mode << QUP_IO_M_INPUT_MODE_MASK_SHIFT);
+	iomode |= (controller->mode << QUP_IO_M_OUTPUT_MODE_MASK_SHIFT);
+	iomode |= (controller->mode << QUP_IO_M_INPUT_MODE_MASK_SHIFT);
 
 	writel_relaxed(iomode, controller->base + QUP_IO_M_MODES);
 
@@ -462,7 +554,8 @@ static int spi_qup_transfer_one(struct spi_master *master,
 		goto exit;
 	}
 
-	spi_qup_fifo_write(controller, xfer);
+	if (controller->mode == QUP_IO_M_MODE_FIFO)
+		spi_qup_fifo_write(controller, xfer, 0);
 
 	if (spi_qup_set_state(controller, QUP_STATE_RUN)) {
 		dev_warn(controller->dev, "cannot set EXECUTE state\n");
@@ -478,6 +571,7 @@ exit:
 	if (!ret)
 		ret = controller->error;
 	spin_unlock_irqrestore(&controller->lock, flags);
+
 	return ret;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

