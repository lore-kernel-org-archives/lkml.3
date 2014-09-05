Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaIET2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:28:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:33954 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIET2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:28:13 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/18] tty: serial: 8250_dma: enqueue RX dma again on completion.
Date: Fri,  5 Sep 2014 21:02:45 +0200
Message-Id: <1409943773-7874-11-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
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
 drivers/tty/serial/8250/8250.h      |  3 ++-
 drivers/tty/serial/8250/8250_core.c |  3 +++
 drivers/tty/serial/8250/8250_dma.c  | 12 +++++++++---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index a63d198f8d03..fbed1636e9c4 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -80,7 +80,8 @@ struct serial8250_config {
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
 #define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
 #define UART_BUG_PARITY	(1 << 4)	/* UART mishandles parity if FIFO enabled */
-
+#define UART_BUG_DMA_RX	(1 << 5)	/* UART needs DMA RX req before there is
+					   data in FIFO */
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)
 
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 2101134e5031..079048db8c81 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1590,6 +1590,9 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 		if (!up->dma || dma_err)
 			status = serial8250_rx_chars(up, status);
+
+		if (dma_err && up->bugs & UART_BUG_DMA_RX)
+			serial8250_rx_dma(up, 0);
 	}
 	serial8250_modem_status(up);
 	if ((!up->dma || (up->dma && up->dma->tx_err)) &&
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 69e54abb6e71..3674900a1f14 100644
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
+	if (!error && p->bugs & UART_BUG_DMA_RX)
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
2.1.0

