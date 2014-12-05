Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaLEIIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:08:44 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45650 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaLEIIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:08:42 -0500
From: Harini Katakam <harinik@xilinx.com>
To: wsa@the-dreams.de, mark.rutland@arm.com
Cc: michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinik@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: [PATCH v3 1/2] i2c: cadence: Handle > 252 byte transfers
Date: Fri,  5 Dec 2014 13:38:03 +0530
Message-Id: <1417766884-8383-2-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417766884-8383-1-git-send-email-harinik@xilinx.com>
References: <1417766884-8383-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C controller sends a NACK to the slave when transfer size register
reaches zero, irrespective of the hold bit. So, in order to handle transfers
greater than 252 bytes, the transfer size register has to be maintained at a
value >= 1. This patch implements the same.
The interrupt status is cleared at the beginning of the isr instead of
the end, to avoid missing any interrupts.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---

v3:
Add comments

v2:
No changes

---
 drivers/i2c/busses/i2c-cadence.c |  173 ++++++++++++++++++++++----------------
 1 file changed, 100 insertions(+), 73 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 63f3f03..5f5d4fa 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -126,6 +126,7 @@
  * @suspended:		Flag holding the device's PM status
  * @send_count:		Number of bytes still expected to send
  * @recv_count:		Number of bytes still expected to receive
+ * @curr_recv_count:	Number of bytes to be received in current transfer
  * @irq:		IRQ number
  * @input_clk:		Input clock to I2C controller
  * @i2c_clk:		Maximum I2C clock speed
@@ -144,6 +145,7 @@ struct cdns_i2c {
 	u8 suspended;
 	unsigned int send_count;
 	unsigned int recv_count;
+	unsigned int curr_recv_count;
 	int irq;
 	unsigned long input_clk;
 	unsigned int i2c_clk;
@@ -180,14 +182,15 @@ static void cdns_i2c_clear_bus_hold(struct cdns_i2c *id)
  */
 static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 {
-	unsigned int isr_status, avail_bytes;
-	unsigned int bytes_to_recv, bytes_to_send;
+	unsigned int isr_status, avail_bytes, updatetx;
+	unsigned int bytes_to_send;
 	struct cdns_i2c *id = ptr;
 	/* Signal completion only after everything is updated */
 	int done_flag = 0;
 	irqreturn_t status = IRQ_NONE;
 
 	isr_status = cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
+	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
 
 	/* Handling nack and arbitration lost interrupt */
 	if (isr_status & (CDNS_I2C_IXR_NACK | CDNS_I2C_IXR_ARB_LOST)) {
@@ -195,89 +198,112 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 		status = IRQ_HANDLED;
 	}
 
-	/* Handling Data interrupt */
-	if ((isr_status & CDNS_I2C_IXR_DATA) &&
-			(id->recv_count >= CDNS_I2C_DATA_INTR_DEPTH)) {
-		/* Always read data interrupt threshold bytes */
-		bytes_to_recv = CDNS_I2C_DATA_INTR_DEPTH;
-		id->recv_count -= CDNS_I2C_DATA_INTR_DEPTH;
-		avail_bytes = cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
-
-		/*
-		 * if the tranfer size register value is zero, then
-		 * check for the remaining bytes and update the
-		 * transfer size register.
-		 */
-		if (!avail_bytes) {
-			if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
-				cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-			else
-				cdns_i2c_writereg(id->recv_count,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-		}
+	/*
+	 * Check if transfer size register needs to be updated again for a
+	 * large data receive operation.
+	 */
+	updatetx = 0;
+	if (id->recv_count > id->curr_recv_count)
+		updatetx = 1;
+
+	/* When receiving, handle data interrupt and completion interrupt */
+	if (id->p_recv_buf &&
+	    ((isr_status & CDNS_I2C_IXR_COMP) ||
+	     (isr_status & CDNS_I2C_IXR_DATA))) {
+		/* Read data if receive data valid is set */
+		while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) &
+		       CDNS_I2C_SR_RXDV) {
+			/*
+			 * Clear hold bit that was set for FIFO control if
+			 * RX data left is less than FIFO depth, unless
+			 * repeated start is selected.
+			 */
+			if ((id->recv_count < CDNS_I2C_FIFO_DEPTH) &&
+			    !id->bus_hold_flag)
+				cdns_i2c_clear_bus_hold(id);
 
-		/* Process the data received */
-		while (bytes_to_recv--)
 			*(id->p_recv_buf)++ =
 				cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
+			id->recv_count--;
+			id->curr_recv_count--;
 
-		if (!id->bus_hold_flag &&
-				(id->recv_count <= CDNS_I2C_FIFO_DEPTH))
-			cdns_i2c_clear_bus_hold(id);
+			if (updatetx &&
+			    (id->curr_recv_count == CDNS_I2C_FIFO_DEPTH + 1))
+				break;
+		}
 
-		status = IRQ_HANDLED;
-	}
+		/*
+		 * The controller sends NACK to the slave when transfer size
+		 * register reaches zero without considering the HOLD bit.
+		 * This workaround is implemented for large data transfers to
+		 * maintain transfer size non-zero while performing a large
+		 * receive operation.
+		 */
+		if (updatetx &&
+		    (id->curr_recv_count == CDNS_I2C_FIFO_DEPTH + 1)) {
+			/* wait while fifo is full */
+			while (cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET) !=
+			       (id->curr_recv_count - CDNS_I2C_FIFO_DEPTH))
+				;
 
-	/* Handling Transfer Complete interrupt */
-	if (isr_status & CDNS_I2C_IXR_COMP) {
-		if (!id->p_recv_buf) {
 			/*
-			 * If the device is sending data If there is further
-			 * data to be sent. Calculate the available space
-			 * in FIFO and fill the FIFO with that many bytes.
+			 * Check number of bytes to be received against maximum
+			 * transfer size and update register accordingly.
 			 */
-			if (id->send_count) {
-				avail_bytes = CDNS_I2C_FIFO_DEPTH -
-				    cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
-				if (id->send_count > avail_bytes)
-					bytes_to_send = avail_bytes;
-				else
-					bytes_to_send = id->send_count;
-
-				while (bytes_to_send--) {
-					cdns_i2c_writereg(
-						(*(id->p_send_buf)++),
-						 CDNS_I2C_DATA_OFFSET);
-					id->send_count--;
-				}
+			if (((int)(id->recv_count) - CDNS_I2C_FIFO_DEPTH) >
+			    CDNS_I2C_TRANSFER_SIZE) {
+				cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
+						  CDNS_I2C_XFER_SIZE_OFFSET);
+				id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE +
+						      CDNS_I2C_FIFO_DEPTH;
 			} else {
-				/*
-				 * Signal the completion of transaction and
-				 * clear the hold bus bit if there are no
-				 * further messages to be processed.
-				 */
-				done_flag = 1;
+				cdns_i2c_writereg(id->recv_count -
+						  CDNS_I2C_FIFO_DEPTH,
+						  CDNS_I2C_XFER_SIZE_OFFSET);
+				id->curr_recv_count = id->recv_count;
 			}
-			if (!id->send_count && !id->bus_hold_flag)
-				cdns_i2c_clear_bus_hold(id);
-		} else {
+		}
+
+		/* Clear hold (if not repeated start) and signal completion */
+		if ((isr_status & CDNS_I2C_IXR_COMP) && !id->recv_count) {
 			if (!id->bus_hold_flag)
 				cdns_i2c_clear_bus_hold(id);
+			done_flag = 1;
+		}
+
+		status = IRQ_HANDLED;
+	}
+
+	/* When sending, handle transfer complete interrupt */
+	if ((isr_status & CDNS_I2C_IXR_COMP) && !id->p_recv_buf) {
+		/*
+		 * If there is more data to be sent, calculate the
+		 * space available in FIFO and fill with that many bytes.
+		 */
+		if (id->send_count) {
+			avail_bytes = CDNS_I2C_FIFO_DEPTH -
+			    cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
+			if (id->send_count > avail_bytes)
+				bytes_to_send = avail_bytes;
+			else
+				bytes_to_send = id->send_count;
+
+			while (bytes_to_send--) {
+				cdns_i2c_writereg(
+					(*(id->p_send_buf)++),
+					 CDNS_I2C_DATA_OFFSET);
+				id->send_count--;
+			}
+		} else {
 			/*
-			 * If the device is receiving data, then signal
-			 * the completion of transaction and read the data
-			 * present in the FIFO. Signal the completion of
-			 * transaction.
+			 * Signal the completion of transaction and
+			 * clear the hold bus bit if there are no
+			 * further messages to be processed.
 			 */
-			while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) &
-					CDNS_I2C_SR_RXDV) {
-				*(id->p_recv_buf)++ =
-					cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
-				id->recv_count--;
-			}
 			done_flag = 1;
 		}
+		if (!id->send_count && !id->bus_hold_flag)
+			cdns_i2c_clear_bus_hold(id);
 
 		status = IRQ_HANDLED;
 	}
@@ -287,8 +313,6 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 	if (id->err_status)
 		status = IRQ_HANDLED;
 
-	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
-
 	if (done_flag)
 		complete(&id->xfer_done);
 
@@ -314,6 +338,8 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 	if (id->p_msg->flags & I2C_M_RECV_LEN)
 		id->recv_count = I2C_SMBUS_BLOCK_MAX + 1;
 
+	id->curr_recv_count = id->recv_count;
+
 	/*
 	 * Check for the message size against FIFO depth and set the
 	 * 'hold bus' bit if it is greater than FIFO depth.
@@ -333,10 +359,11 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 	 * receive if it is less than transfer size and transfer size if
 	 * it is more. Enable the interrupts.
 	 */
-	if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
+	if (id->recv_count > CDNS_I2C_TRANSFER_SIZE) {
 		cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
 				  CDNS_I2C_XFER_SIZE_OFFSET);
-	else
+		id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE;
+	} else
 		cdns_i2c_writereg(id->recv_count, CDNS_I2C_XFER_SIZE_OFFSET);
 	/* Clear the bus hold flag if bytes to receive is less than FIFO size */
 	if (!id->bus_hold_flag &&
-- 
1.7.9.5

