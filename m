Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaIET2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:28:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:33962 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaIET2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:28:35 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 14/18] tty: serial: 8250_dma: handle the when UART response while DMA remains idle
Date: Fri,  5 Sep 2014 21:02:49 +0200
Message-Id: <1409943773-7874-15-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the OMAP UART does not signal the DMA engine to unload the FIFO.
Usually this happens when we have >threshold bytes in the FIFO
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
 drivers/tty/serial/8250/8250_dma.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 6cd8a4db609a..f0fce8236279 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -182,6 +182,24 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 			__dma_rx_do_complete(p, true);
 		}
 		return -ETIMEDOUT;
+	case UART_IIR_RDI:
+		if (p->bugs & UART_BUG_DMA_RX)
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
+		if (dma->rx_running) {
+			dmaengine_pause(dma->rxchan);
+			__dma_rx_do_complete(p, true);
+		}
+		return -ETIMEDOUT;
+
 	default:
 		break;
 	}
-- 
2.1.0

