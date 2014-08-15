Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaHORnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:43:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:57700 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaHORna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:43:30 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 07/15] tty: serial: 8250_dma: enqueue RX dma again on completion.
Date: Fri, 15 Aug 2014 19:42:35 +0200
Message-Id: <1408124563-31541-8-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap needs a DMA request pending right away. If it is enqueued once
the bytes are in the FIFO then nothing will happen and the FIFO will be
later purged via RX-timeout interrupt.
This patch enqueues RX-DMA request on completion but not if it was
aborted on error. The first enqueue will happen in the driver in
startup.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c |  3 +++
 drivers/tty/serial/8250/8250_dma.c  | 12 +++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 7498ce1..ab2de27 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1598,6 +1598,9 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 		if (!up->dma || dma_err)
 			status = serial8250_rx_chars(up, status);
+
+		if (dma_err && port->type == PORT_OMAP_16750)
+			serial8250_rx_dma(up, 0);
 	}
 	serial8250_modem_status(up);
 	if ((!up->dma || up->dma_tx_err) && (status & UART_LSR_THRE))
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 5c59b15..7417ed5 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -50,9 +50,8 @@ static void __dma_tx_complete(void *param)
 	spin_unlock_irqrestore(&p->port.lock, flags);
 }
 
-static void __dma_rx_complete(void *param)
+static void __dma_rx_do_complete(struct uart_8250_port *p, bool error)
 {
-	struct uart_8250_port	*p = param;
 	struct uart_8250_dma	*dma = p->dma;
 	struct tty_port		*tty_port = &p->port.state->port;
 	struct dma_tx_state	state;
@@ -68,10 +67,17 @@ static void __dma_rx_complete(void *param)
 
 	tty_insert_flip_string(tty_port, dma->rx_buf, count);
 	p->port.icount.rx += count;
+	if (!error && p->port.type == PORT_OMAP_16750)
+		serial8250_rx_dma(p, 0);
 
 	tty_flip_buffer_push(tty_port);
 }
 
+static void __dma_rx_complete(void *param)
+{
+	__dma_rx_do_complete(param, false);
+}
+
 int serial8250_tx_dma(struct uart_8250_port *p)
 {
 	struct uart_8250_dma		*dma = p->dma;
@@ -139,7 +145,7 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 		 */
 		if (dma_status == DMA_IN_PROGRESS) {
 			dmaengine_pause(dma->rxchan);
-			__dma_rx_complete(p);
+			__dma_rx_do_complete(p, true);
 		}
 		return -ETIMEDOUT;
 	default:
-- 
2.0.1

