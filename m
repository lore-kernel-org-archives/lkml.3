Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaIJT5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:57:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:35662 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaIJT5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:57:00 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 12/16] tty: serial: 8250_dma: handle the UART RDI event while DMA remains idle
Date: Wed, 10 Sep 2014 21:30:07 +0200
Message-Id: <1410377411-26656-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
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

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_dma.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index fa1dc966f394..898a6781d0b3 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -193,6 +193,24 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
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

