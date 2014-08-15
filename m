Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaHOSE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:04:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:57826 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHOSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:04:55 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 11/15] tty: serial: 8250_dma: handle the when UART response while DMA remains idle
Date: Fri, 15 Aug 2014 19:42:39 +0200
Message-Id: <1408124563-31541-12-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP UART needs the RX-DMA programmed right away. If we receive a BREAK
then we have to cancel the DMA transfer before we can handle the break
condition. Otherwise, after we handled the "break condition" the DMA
engine will start reading bytes from the FIFO while we also purge the
FIFO manually. The order of what we receive is random.

Also sometimes the OMAP UART does not signal the DMA engine to unload
the FIFO. Usually this happens when we have >threshold bytes in the FIFO
and start the DMA transfer. It seems that in those cases the UART won't
trigger the transfer once the requested threshold is reached. In some
rare cases the UART does not trigger the DMA transfer even if programmed
while the FIFO was empty.
In those cases the UART drops an RDI event and we have to empty the FIFO
manually. If we ignore it because the DMA transfer is programmed then we
will enter the function a few times until we receive the RX_TIMEOUT
event. At that point the FIFO is usually full and we risk to overflow
the FIFO.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_dma.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index dc1294b..cfc83d4 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -149,6 +149,13 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 	switch (iir & 0x3f) {
 	case UART_IIR_RLSI:
 		/* 8250_core handles errors and break interrupts */
+		if (p->port.type == PORT_OMAP_16750)
+			/*
+			 * The OMAP has its DMA transfer started before we get
+			 * here. Keeping it enabled will result in data beeing
+			 * read out of order (DMA + manuall FIFO read).
+			 */
+			__dma_rx_do_complete(p, true);
 		return -EIO;
 	case UART_IIR_RX_TIMEOUT:
 		/*
@@ -160,6 +167,21 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 			__dma_rx_do_complete(p, true);
 		}
 		return -ETIMEDOUT;
+	case UART_IIR_RDI:
+		if (p->port.type != PORT_OMAP_16750)
+			break;
+		/*
+		 * The OMAP UART is a special BEAST. If we receive RDI we _have_
+		 * a DMA transfer programmed but it didn't worked. One reason is
+		 * that we were too slow and there were too many bytes in the
+		 * FIFO, the UART counted wrong and never kicked the DMA engine
+		 * to do anything. That means once we receive RDI on OMAP than
+		 * the DMA won't do anything soon so we have to cancel the DMA
+		 * transfer and purge the FIFO manually.
+		 */
+		__dma_rx_do_complete(p, true);
+		return -ETIMEDOUT;
+
 	default:
 		break;
 	}
-- 
2.0.1

