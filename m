Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaIJTbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:31:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:35431 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJTbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:31:09 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround for AM33xx
Date: Wed, 10 Sep 2014 21:30:04 +0200
Message-Id: <1410377411-26656-10-git-send-email-bigeasy@linutronix.de>
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

At least on AM335x the following problem exists: Even if the TX FIFO is
empty and a TX transfer is programmed (and started) the UART does not
trigger the DMA transfer.
After $TRESHOLD number of bytes have been written to the FIFO manually the
UART reevaluates the whole situation and decides that now there is enough
room in the FIFO and so the transfer begins.
This problem has not been seen on DRA7 or beagle board xm (OMAP3). I am not
sure if this is UART-IP core specific or DMA engine.

The workaround is to use a threshold of one byte, program the DMA
transfer minus one byte and then to put the first byte into the FIFO to
kick start the transfer.

v7…v8:
	- fix the problem when get invoked and the FIFO is full.

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h     |  3 +++
 drivers/tty/serial/8250/8250_dma.c | 39 +++++++++++++++++++++++++++++++++++---
 include/uapi/linux/serial_reg.h    |  1 +
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index fbed1636e9c4..09489b391568 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -82,6 +82,9 @@ struct serial8250_config {
 #define UART_BUG_PARITY	(1 << 4)	/* UART mishandles parity if FIFO enabled */
 #define UART_BUG_DMA_RX	(1 << 5)	/* UART needs DMA RX req before there is
 					   data in FIFO */
+#define UART_BUG_DMA_TX	(1 << 6)	/* UART needs one byte in FIFO for
+					   kickstart */
+
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)
 
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 3674900a1f14..48dc57aad0dd 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -83,6 +83,7 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	struct uart_8250_dma		*dma = p->dma;
 	struct circ_buf			*xmit = &p->port.state->xmit;
 	struct dma_async_tx_descriptor	*desc;
+	unsigned int			skip_byte = 0;
 	int ret;
 
 	if (uart_tx_stopped(&p->port) || dma->tx_running ||
@@ -91,10 +92,40 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 
 	dma->tx_size = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 
+	if (p->bugs & UART_BUG_DMA_TX) {
+		u8 tx_lvl;
+
+		/*
+		 * We need to put the first byte into the FIFO in order to start
+		 * the DMA transfer. For transfers smaller than four bytes we
+		 * don't bother doing DMA at all. It seem not matter if there
+		 * are still bytes in the FIFO from the last transfer (in case
+		 * we got here directly from __dma_tx_complete()). Bytes leaving
+		 * the FIFO seem not to trigger the DMA transfer. It is really
+		 * the byte that we put into the FIFO.
+		 * If the FIFO is already full then we most likely got here from
+		 * __dma_tx_complete(). And this means the DMA engine just
+		 * completed its work. We don't have to wait the complete 86us
+		 * at 115200,8n1 but around 60us (not to mention lower
+		 * baudrates). So in that case we take the interrupt and try
+		 * again with an empty FIFO.
+		 */
+		tx_lvl = serial_in(p, UART_OMAP_TX_LVL);
+		if (tx_lvl == p->tx_loadsz) {
+			ret = -EBUSY;
+			goto err;
+		}
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
@@ -118,6 +149,8 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 			serial_out(p, UART_IER, p->ier);
 		}
 	}
+	if (skip_byte)
+		serial_out(p, UART_TX, xmit->buf[xmit->tail]);
 	return 0;
 err:
 	dma->tx_err = 1;
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index df6c9ab6b0cd..53af3b790129 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -359,6 +359,7 @@
 #define UART_OMAP_SYSC		0x15	/* System configuration register */
 #define UART_OMAP_SYSS		0x16	/* System status register */
 #define UART_OMAP_WER		0x17	/* Wake-up enable register */
+#define UART_OMAP_TX_LVL	0x1a	/* TX FIFO level register */
 
 /*
  * These are the definitions for the MDR1 register
-- 
2.1.0

