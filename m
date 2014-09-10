Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaIJTz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:55:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:35641 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaIJTzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:55:54 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/16] tty: serial: 8250_dma: optimize the xmit path due to UART_BUG_DMA_TX
Date: Wed, 10 Sep 2014 21:30:05 +0200
Message-Id: <1410377411-26656-11-git-send-email-bigeasy@linutronix.de>
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

Due to UART_BUG_DMA_TX the am335x has to put the first one byte into the
TX FIFO to get things going. If we get to serial8250_tx_dma() via
__dma_tx_complete() then the DMA engine just finished and the FIFO is
full and we can't put the first byte into the TX FIFO as kick start so
we leave with THRI enabled.
The result is that we end up manually filling the FIFO. We could be a
little better at this and try DMA once again. If it works, it works and
if not we do it manually.

v8…v9:
	- fix receiving THRI interrupts after DMA operation completed and
	  the next one would fail (length < 4 bytes).
	- while at it makes sure we fail with an error for zero lenght
	  transfers with the TX bug or runtime PM
	- make sure THRI is always cleared after DMA is fired.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 17 +++++++++++++++--
 drivers/tty/serial/8250/8250_dma.c  | 27 +++++++++++++++++++--------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 39b1c7318f17..660d19771bbe 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1599,9 +1599,22 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 	serial8250_modem_status(up);
 	if ((!up->dma || (up->dma && up->dma->tx_err)) &&
 			(status & UART_LSR_THRE)) {
-		serial8250_tx_chars(up);
-	}
+		if (!up->dma) {
+			serial8250_tx_chars(up);
+		} else {
+			if (uart_tx_stopped(&up->port) ||
+				uart_circ_empty(&up->port.state->xmit)) {
+				up->dma->tx_err = 0;
+				serial8250_tx_chars(up);
 
+			} else  {
+				/* try again due to UART_BUG_DMA_TX+full fifo */
+				dma_err = serial8250_tx_dma(up);
+				if (dma_err)
+					serial8250_tx_chars(up);
+			}
+		}
+	}
 	spin_unlock_irqrestore(&port->lock, flags);
 	return 1;
 }
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 48dc57aad0dd..e836d128e63a 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -86,12 +86,23 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	unsigned int			skip_byte = 0;
 	int ret;
 
-	if (uart_tx_stopped(&p->port) || dma->tx_running ||
-	    uart_circ_empty(xmit))
+	if (dma->tx_running)
 		return 0;
+	if (uart_tx_stopped(&p->port) || uart_circ_empty(xmit)) {
 
-	dma->tx_size = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
+		/*
+		 * Even if no data, we need to return an error for the two cases
+		 * below so serial8250_tx_chars() is invoked and properly clears
+		 * THRI and/or runtime suspend.
+		 */
+		if (dma->tx_err || p->capabilities & UART_CAP_RPM) {
+			ret = -EBUSY;
+			goto err;
+		}
+		return 0;
+	}
 
+	dma->tx_size = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 	if (p->bugs & UART_BUG_DMA_TX) {
 		u8 tx_lvl;
 
@@ -142,12 +153,12 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 				   UART_XMIT_SIZE, DMA_TO_DEVICE);
 
 	dma_async_issue_pending(dma->txchan);
-	if (dma->tx_err) {
+	if (dma->tx_err)
 		dma->tx_err = 0;
-		if (p->ier & UART_IER_THRI) {
-			p->ier &= ~UART_IER_THRI;
-			serial_out(p, UART_IER, p->ier);
-		}
+
+	if (p->ier & UART_IER_THRI) {
+		p->ier &= ~UART_IER_THRI;
+		serial_out(p, UART_IER, p->ier);
 	}
 	if (skip_byte)
 		serial_out(p, UART_TX, xmit->buf[xmit->tail]);
-- 
2.1.0

