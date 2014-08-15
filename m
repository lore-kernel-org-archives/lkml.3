Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaHOSEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:04:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:57819 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOSEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:04:32 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/15] tty: serial: 8250_dma: Add a TX trigger workaround for AM33xx
Date: Fri, 15 Aug 2014 19:42:38 +0200
Message-Id: <1408124563-31541-11-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on AM335x the following problem exists: Even if the TX FIFO is
empty and a TX transfer is programmed (and started) the UART does not
trigger the DMA transfer.
After $TRESHOLD number of bytes have been written to the FIFO manually the
UART reevaluates the whole situation and decides that now there is enough
room in the FIFO and so the transfer begins.
This problem has not been seen on DRA7 or beaglebone (OMAP3).

The workaround is to use a threshold of one byte, program the DMA
transfer minus one byte and then to put the first byte into the FIFO to
kick start the transfer.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h     |  1 +
 drivers/tty/serial/8250/8250_dma.c | 18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 1bcb4b2..d6a3f5c 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -79,6 +79,7 @@ struct serial8250_config {
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
 #define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
 #define UART_BUG_PARITY	(1 << 4)	/* UART mishandles parity if FIFO enabled */
+#define UART_BUG_DMATX	(1 << 5)	/* UART needs one byte in FIFO for kickstart */
 
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 7417ed5..dc1294b 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -83,6 +83,7 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	struct uart_8250_dma		*dma = p->dma;
 	struct circ_buf			*xmit = &p->port.state->xmit;
 	struct dma_async_tx_descriptor	*desc;
+	unsigned int			skip_byte = 0;
 	int ret;
 
 	if (uart_tx_stopped(&p->port) || dma->tx_running ||
@@ -91,10 +92,18 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 
 	dma->tx_size = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 
+	if (p->bugs & UART_BUG_DMATX) {
+		if (dma->tx_size < 4) {
+			ret = -EINVAL;
+			goto err;
+		}
+		skip_byte = 1;
+	}
+
 	desc = dmaengine_prep_slave_single(dma->txchan,
-					   dma->tx_addr + xmit->tail,
-					   dma->tx_size, DMA_MEM_TO_DEV,
-					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			dma->tx_addr + xmit->tail + skip_byte,
+			dma->tx_size - skip_byte, DMA_MEM_TO_DEV,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		ret = -EBUSY;
 		goto err;
@@ -118,6 +127,9 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 			serial_out(p, UART_IER, p->ier);
 		}
 	}
+	if (skip_byte)
+		serial_out(p, UART_TX, xmit->buf[xmit->tail]);
+
 	return 0;
 err:
 	p->dma_tx_err = 1;
-- 
2.0.1

