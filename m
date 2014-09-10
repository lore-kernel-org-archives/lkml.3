Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaIJTac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:30:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:35388 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaIJTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:30:29 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 07/16] tty: serial: 8250_dma: handle error on TX submit
Date: Wed, 10 Sep 2014 21:30:02 +0200
Message-Id: <1410377411-26656-8-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now it is possible that serial8250_tx_dma() fails and returns
-EBUSY. The caller (serial8250_start_tx()) will then enable
UART_IER_THRI which will generate an interrupt once the TX FIFO is
empty.
In serial8250_handle_irq() nothing will happen because up->dma is set
and so serial8250_tx_chars() won't be invoked. We end up with plenty of
interrupts and some "too much work for irq" output.

This patch introduces dma_tx_err in struct uart_8250_port to signal that
the last invocation of serial8250_tx_dma() failed so we can fill the TX
FIFO manually. Should the next invocation of serial8250_start_tx()
succeed then the dma_tx_err flag along with the THRI bit is removed and
DMA only usage may continue.

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h      |  1 +
 drivers/tty/serial/8250/8250_core.c |  4 +++-
 drivers/tty/serial/8250/8250_dma.c  | 30 +++++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 1bcb4b2141a6..a63d198f8d03 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -41,6 +41,7 @@ struct uart_8250_dma {
 	size_t			tx_size;
 
 	unsigned char		tx_running:1;
+	unsigned char		tx_err: 1;
 };
 
 struct old_serial_port {
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 139f3d2b8aa9..9f961ea82564 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1594,8 +1594,10 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 			status = serial8250_rx_chars(up, status);
 	}
 	serial8250_modem_status(up);
-	if (!up->dma && (status & UART_LSR_THRE))
+	if ((!up->dma || (up->dma && up->dma->tx_err)) &&
+			(status & UART_LSR_THRE)) {
 		serial8250_tx_chars(up);
+	}
 
 	spin_unlock_irqrestore(&port->lock, flags);
 	return 1;
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 148ffe4c232f..69e54abb6e71 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -36,8 +36,16 @@ static void __dma_tx_complete(void *param)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&p->port);
 
-	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port))
-		serial8250_tx_dma(p);
+	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port)) {
+		int ret;
+
+		ret = serial8250_tx_dma(p);
+		if (ret) {
+			dma->tx_err = 1;
+			p->ier |= UART_IER_THRI;
+			serial_port_out(&p->port, UART_IER, p->ier);
+		}
+	}
 
 	spin_unlock_irqrestore(&p->port.lock, flags);
 }
@@ -69,6 +77,7 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	struct uart_8250_dma		*dma = p->dma;
 	struct circ_buf			*xmit = &p->port.state->xmit;
 	struct dma_async_tx_descriptor	*desc;
+	int ret;
 
 	if (uart_tx_stopped(&p->port) || dma->tx_running ||
 	    uart_circ_empty(xmit))
@@ -80,8 +89,10 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 					   dma->tx_addr + xmit->tail,
 					   dma->tx_size, DMA_MEM_TO_DEV,
 					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-	if (!desc)
-		return -EBUSY;
+	if (!desc) {
+		ret = -EBUSY;
+		goto err;
+	}
 
 	dma->tx_running = 1;
 
@@ -94,8 +105,17 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 				   UART_XMIT_SIZE, DMA_TO_DEVICE);
 
 	dma_async_issue_pending(dma->txchan);
-
+	if (dma->tx_err) {
+		dma->tx_err = 0;
+		if (p->ier & UART_IER_THRI) {
+			p->ier &= ~UART_IER_THRI;
+			serial_out(p, UART_IER, p->ier);
+		}
+	}
 	return 0;
+err:
+	dma->tx_err = 1;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(serial8250_tx_dma);
 
-- 
2.1.0

