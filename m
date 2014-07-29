Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaG2TBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:01:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:50355 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaG2TAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:00:18 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/7] serial: 8250_dma: continue TX dma on dma error
Date: Tue, 29 Jul 2014 20:59:00 +0200
Message-Id: <1406660344-25307-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After TX dma completes the code will queue another DMA transfer. If
serial8250_tx_dma() fails then there is no plan B to continue the
transfer manually.
This patch enables the TX-fifo empty event so it can be tried again via
DMA or use the manual fallback in case it fails.

Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_dma.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 148ffe4..f9ef69f 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -36,8 +36,15 @@ static void __dma_tx_complete(void *param)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&p->port);
 
-	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port))
-		serial8250_tx_dma(p);
+	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port)) {
+		int ret;
+
+		ret = serial8250_tx_dma(p);
+		if (ret && !(p->ier & UART_IER_THRI)) {
+			p->ier |= UART_IER_THRI;
+			serial_port_out(&p->port, UART_IER, p->ier);
+		}
+	}
 
 	spin_unlock_irqrestore(&p->port.lock, flags);
 }
-- 
2.0.1

