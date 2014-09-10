Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaIJT5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:57:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:35682 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaIJT5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:57:49 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        vinod.koul@intel.com
Subject: [PATCH 11/16] tty: serial: 8250_dma: keep own book keeping about RX transfers
Date: Wed, 10 Sep 2014 21:30:06 +0200
Message-Id: <1410377411-26656-12-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
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
 drivers/tty/serial/8250/8250_dma.c | 14 ++++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 09489b391568..a7581b37f264 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -42,6 +42,7 @@ struct uart_8250_dma {
 
 	unsigned char		tx_running:1;
 	unsigned char		tx_err: 1;
+	unsigned char		rx_running:1;
 };
 
 struct old_serial_port {
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index e836d128e63a..fa1dc966f394 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -60,6 +60,7 @@ static void __dma_rx_do_complete(struct uart_8250_port *p, bool error)
 	dma_sync_single_for_cpu(dma->rxchan->device->dev, dma->rx_addr,
 				dma->rx_size, DMA_FROM_DEVICE);
 
+	dma->rx_running = 0;
 	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
 	dmaengine_terminate_all(dma->rxchan);
 
@@ -173,21 +174,21 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 {
 	struct uart_8250_dma		*dma = p->dma;
 	struct dma_async_tx_descriptor	*desc;
-	struct dma_tx_state		state;
-	int				dma_status;
-
-	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
 
 	switch (iir & 0x3f) {
 	case UART_IIR_RLSI:
 		/* 8250_core handles errors and break interrupts */
+		if (dma->rx_running) {
+			dmaengine_pause(dma->rxchan);
+			__dma_rx_do_complete(p, true);
+		}
 		return -EIO;
 	case UART_IIR_RX_TIMEOUT:
 		/*
 		 * If RCVR FIFO trigger level was not reached, complete the
 		 * transfer and let 8250_core copy the remaining data.
 		 */
-		if (dma_status == DMA_IN_PROGRESS) {
+		if (dma->rx_running) {
 			dmaengine_pause(dma->rxchan);
 			__dma_rx_do_complete(p, true);
 		}
@@ -196,7 +197,7 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 		break;
 	}
 
-	if (dma_status)
+	if (dma->rx_running)
 		return 0;
 
 	desc = dmaengine_prep_slave_single(dma->rxchan, dma->rx_addr,
@@ -205,6 +206,7 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 	if (!desc)
 		return -EBUSY;
 
+	dma->rx_running = 1;
 	desc->callback = __dma_rx_complete;
 	desc->callback_param = p;
 
-- 
2.1.0

