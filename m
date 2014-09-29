Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaI2SIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:08:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:53256 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaI2SHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:07:01 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        vinod.koul@intel.com
Subject: [PATCH 05/13] tty: serial: 8250_dma: keep own book keeping about RX transfers
Date: Mon, 29 Sep 2014 20:06:41 +0200
Message-Id: <1412014009-13315-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After dmaengine_terminate_all() has been invoked then both DMA drivers
(edma and omap-dma) do not invoke dma_cookie_complete() to mark the
transfer as complete. This dma_cookie_complete() is performed by the
Synopsys DesignWare driver which is probably the only one that is used
by omap8250-dma and hence don't see following problem…
…which is that once a RX transfer has been terminated then following
query of channel status reports DMA_IN_PROGRESS (again: the actual
transfer has been canceled, there is nothing going on anymore).

This means that serial8250_rx_dma() never enqueues another DMA transfer
because it (wrongly) assumes that there is a transer already pending.

Vinod Koul refuses to accept a patch which adds this
dma_cookie_complete() to both drivers and so dmaengine_tx_status() would
report DMA_COMPLETE instead (and behave like the Synopsys DesignWare
driver already does). He argues that I am not allowed to use the cookie
to query the status and that the driver already cleaned everything up after
the invokation of dmaengine_terminate_all().

To end this I add a bookkeeping whether or not a RX-transfer has been
started to the 8250-dma code. It has already been done for the TX side.
*Now* we learn about the RX status based on our bookkeeping and don't
need dmaengine_tx_status() for this anymore.

Cc: vinod.koul@intel.com
Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h     |  1 +
 drivers/tty/serial/8250/8250_dma.c | 10 ++++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index a63d198f8d03..ebab625179d4 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -42,6 +42,7 @@ struct uart_8250_dma {
 
 	unsigned char		tx_running:1;
 	unsigned char		tx_err: 1;
+	unsigned char		rx_running:1;
 };
 
 struct old_serial_port {
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 69e54abb6e71..db9eda3c12d6 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -61,6 +61,7 @@ static void __dma_rx_complete(void *param)
 	dma_sync_single_for_cpu(dma->rxchan->device->dev, dma->rx_addr,
 				dma->rx_size, DMA_FROM_DEVICE);
 
+	dma->rx_running = 0;
 	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
 	dmaengine_terminate_all(dma->rxchan);
 
@@ -123,10 +124,6 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 {
 	struct uart_8250_dma		*dma = p->dma;
 	struct dma_async_tx_descriptor	*desc;
-	struct dma_tx_state		state;
-	int				dma_status;
-
-	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
 
 	switch (iir & 0x3f) {
 	case UART_IIR_RLSI:
@@ -137,7 +134,7 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 		 * If RCVR FIFO trigger level was not reached, complete the
 		 * transfer and let 8250_core copy the remaining data.
 		 */
-		if (dma_status == DMA_IN_PROGRESS) {
+		if (dma->rx_running) {
 			dmaengine_pause(dma->rxchan);
 			__dma_rx_complete(p);
 		}
@@ -146,7 +143,7 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 		break;
 	}
 
-	if (dma_status)
+	if (dma->rx_running)
 		return 0;
 
 	desc = dmaengine_prep_slave_single(dma->rxchan, dma->rx_addr,
@@ -155,6 +152,7 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 	if (!desc)
 		return -EBUSY;
 
+	dma->rx_running = 1;
 	desc->callback = __dma_rx_complete;
 	desc->callback_param = p;
 
-- 
2.1.0

