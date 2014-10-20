Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaJTRM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:12:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:30864 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaJTRMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:12:24 -0400
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <nicolas.ferre@atmel.com>, <gregkh@linuxfoundation.org>,
        <wenyou.yang@atmel.com>, <ludovic.desroches@atmel.com>,
        <leilei.zhao@atmel.com>, <voice.shen@atmel.com>, <josh.wu@atmel.com>,
        <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/1] tty/serial: at91: fix rx ring buffer management
Date: Mon, 20 Oct 2014 19:12:20 +0200
Message-ID: <d5c1c9999ad61ebb5805ca27bcb7f83fd753e33f.1413819885.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch swaps the use "tail" and "head" to fit the semantic of the linux
circular buffer documentation:
- head: the point at which the producer (the DMA controller) inserts items.
- tail: the point at which the consumer (the serial framework) finds the next
        item.

Besides the former code of the rx ring buffer didn't manage the case where
head < tail, which might lead to loss of data. To fix this bug the data are now
sent from the DMA buffer to the serial framework in two steps:
1 - First, we test if head < tail. If so, we copy the data from tail to the end
    of the DMA buffer then reset tail to zero.
2 - Finally, we copy data from tail to head then set tail to head.

In addition, since tty_insert_flip_string() may now be called twice,
atmel_flip_buffer_rx_dma() becomes less efficient than moving the calls
dma_sync_sg_for_cpu(), dma_sync_sg_for_device(), tty_insert_flip_string() and
tty_flip_buffer_push() directly into atmel_rx_from_dma().

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c | 94 +++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 39 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index b0603e1..c2a1d4a 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -773,32 +773,6 @@ chan_err:
 	return -EINVAL;
 }
 
-static void atmel_flip_buffer_rx_dma(struct uart_port *port,
-					char *buf, size_t count)
-{
-	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
-	struct tty_port *tport = &port->state->port;
-
-	dma_sync_sg_for_cpu(port->dev,
-				&atmel_port->sg_rx,
-				1,
-				DMA_DEV_TO_MEM);
-
-	tty_insert_flip_string(tport, buf, count);
-
-	dma_sync_sg_for_device(port->dev,
-				&atmel_port->sg_rx,
-				1,
-				DMA_DEV_TO_MEM);
-	/*
-	 * Drop the lock here since it might end up calling
-	 * uart_start(), which takes the lock.
-	 */
-	spin_unlock(&port->lock);
-	tty_flip_buffer_push(tport);
-	spin_lock(&port->lock);
-}
-
 static void atmel_complete_rx_dma(void *arg)
 {
 	struct uart_port *port = arg;
@@ -827,11 +801,12 @@ static void atmel_release_rx_dma(struct uart_port *port)
 static void atmel_rx_from_dma(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	struct tty_port *tport = &port->state->port;
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	struct dma_chan *chan = atmel_port->chan_rx;
 	struct dma_tx_state state;
 	enum dma_status dmastat;
-	size_t pending, count;
+	size_t count;
 
 
 	/* Reset the UART timeout early so that we don't miss one */
@@ -846,27 +821,68 @@ static void atmel_rx_from_dma(struct uart_port *port)
 		tasklet_schedule(&atmel_port->tasklet);
 		return;
 	}
-	/* current transfer size should no larger than dma buffer */
-	pending = sg_dma_len(&atmel_port->sg_rx) - state.residue;
-	BUG_ON(pending > sg_dma_len(&atmel_port->sg_rx));
 
+	/* CPU claims ownership of RX DMA buffer */
+	dma_sync_sg_for_cpu(port->dev,
+			    &atmel_port->sg_rx,
+			    1,
+			    DMA_DEV_TO_MEM);
+
+	/*
+	 * ring->head points to the end of data already written by the DMA.
+	 * ring->tail points to the beginning of data to be read by the
+	 * framework.
+	 * The current transfer size should not be larger than the dma buffer
+	 * length.
+	 */
+	ring->head = sg_dma_len(&atmel_port->sg_rx) - state.residue;
+	BUG_ON(ring->head > sg_dma_len(&atmel_port->sg_rx));
 	/*
-	 * This will take the chars we have so far,
-	 * ring->head will record the transfer size, only new bytes come
-	 * will insert into the framework.
+	 * At this point ring->head may point to the first byte right after the
+	 * last byte of the dma buffer:
+	 * 0 <= ring->head <= sg_dma_len(&atmel_port->sg_rx)
+	 *
+	 * However ring->tail must always points inside the dma buffer:
+	 * 0 <= ring->tail <= sg_dma_len(&atmel_port->sg_rx) - 1
+	 *
+	 * Since we use a ring buffer, we have to handle the case
+	 * where head is lower than tail. In such a case, we first read from
+	 * tail to the end of the buffer then reset tail.
 	 */
-	if (pending > ring->head) {
-		count = pending - ring->head;
+	if (ring->head < ring->tail) {
+		count = sg_dma_len(&atmel_port->sg_rx) - ring->tail;
 
-		atmel_flip_buffer_rx_dma(port, ring->buf + ring->head, count);
+		tty_insert_flip_string(tport, ring->buf + ring->tail, count);
+		ring->tail = 0;
+		port->icount.rx += count;
+	}
 
-		ring->head += count;
-		if (ring->head == sg_dma_len(&atmel_port->sg_rx))
-			ring->head = 0;
+	/* Finally we read data from tail to head */
+	if (ring->tail < ring->head) {
+		count = ring->head - ring->tail;
 
+		tty_insert_flip_string(tport, ring->buf + ring->tail, count);
+		/* Wrap ring->head if needed */
+		if (ring->head >= sg_dma_len(&atmel_port->sg_rx))
+			ring->head = 0;
+		ring->tail = ring->head;
 		port->icount.rx += count;
 	}
 
+	/* USART retreives ownership of RX DMA buffer */
+	dma_sync_sg_for_device(port->dev,
+			       &atmel_port->sg_rx,
+			       1,
+			       DMA_DEV_TO_MEM);
+
+	/*
+	 * Drop the lock here since it might end up calling
+	 * uart_start(), which takes the lock.
+	 */
+	spin_unlock(&port->lock);
+	tty_flip_buffer_push(tport);
+	spin_lock(&port->lock);
+
 	UART_PUT_IER(port, ATMEL_US_TIMEOUT);
 }
 
-- 
1.8.2.2

