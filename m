Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaI2SJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:09:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:53241 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaI2SHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:07:00 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 06/13] tty: serial: 8250: allow to use custom DMA implementation
Date: Mon, 29 Sep 2014 20:06:42 +0200
Message-Id: <1412014009-13315-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP has a few corner cases where it needs a share of kindness of
affection to do the right thing. Heikki Krogerus suggested that instead
adding the quirks into the default DMA implementation, OMAP could get
its own copy of the function. And Alan suggested the same thing so here
we go.

This patch provides callbacks for custom TX/RX DMA implementation. If
there are not setup / used, then the default (current) implementation is
used.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h      |  3 +++
 drivers/tty/serial/8250/8250_core.c | 11 ++++++++---
 drivers/tty/serial/8250/8250_dma.c  |  2 --
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index ebab625179d4..4bb831ab5db0 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -16,6 +16,9 @@
 #include <linux/dmaengine.h>
 
 struct uart_8250_dma {
+	int (*tx_dma)(struct uart_8250_port *p);
+	int (*rx_dma)(struct uart_8250_port *p, unsigned int iir);
+
 	dma_filter_fn		fn;
 	void			*rx_param;
 	void			*tx_param;
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index ea57c87f8528..93b0799936fd 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1350,7 +1350,7 @@ static void serial8250_start_tx(struct uart_port *port)
 	struct uart_8250_port *up = up_to_u8250p(port);
 
 	serial8250_rpm_get_tx(up);
-	if (up->dma && !serial8250_tx_dma(up)) {
+	if (up->dma && !up->dma->tx_dma(up)) {
 		return;
 	} else if (!(up->ier & UART_IER_THRI)) {
 		up->ier |= UART_IER_THRI;
@@ -1588,7 +1588,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 	if (status & (UART_LSR_DR | UART_LSR_BI)) {
 		if (up->dma)
-			dma_err = serial8250_rx_dma(up, iir);
+			dma_err = up->dma->rx_dma(up, iir);
 
 		if (!up->dma || dma_err)
 			status = serial8250_rx_chars(up, status);
@@ -3624,8 +3624,13 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 			uart->dl_read = up->dl_read;
 		if (up->dl_write)
 			uart->dl_write = up->dl_write;
-		if (up->dma)
+		if (up->dma) {
 			uart->dma = up->dma;
+			if (!uart->dma->tx_dma)
+				uart->dma->tx_dma = serial8250_tx_dma;
+			if (!uart->dma->rx_dma)
+				uart->dma->rx_dma = serial8250_rx_dma;
+		}
 
 		if (serial8250_isa_config != NULL)
 			serial8250_isa_config(0, &uart->port,
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index db9eda3c12d6..258430b72039 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -118,7 +118,6 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	dma->tx_err = 1;
 	return ret;
 }
-EXPORT_SYMBOL_GPL(serial8250_tx_dma);
 
 int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 {
@@ -165,7 +164,6 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(serial8250_rx_dma);
 
 int serial8250_request_dma(struct uart_8250_port *p)
 {
-- 
2.1.0

