Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaK1AXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:23:37 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:54952 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaK1AXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:23:32 -0500
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 1/4] serial: fsl_lpuart: delete timer on shutdown
Date: Fri, 28 Nov 2014 01:23:22 +0100
Message-Id: <1417134205-4400-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417134205-4400-1-git-send-email-stefan@agner.ch>
References: <1417134205-4400-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the serial port gets closed while a RX transfer is in progress,
the timer might fire after the serial port shutdown finished.
Setup the timer on UART startup which allows to delete the timer
unconditionally on shutdown. This also saves the initialization
on each transfer too.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/tty/serial/fsl_lpuart.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 6dd53af..b1905a9 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -506,9 +506,6 @@ static inline void lpuart_prepare_rx(struct lpuart_port *sport)
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
-	init_timer(&sport->lpuart_timer);
-	sport->lpuart_timer.function = lpuart_timer_func;
-	sport->lpuart_timer.data = (unsigned long)sport;
 	sport->lpuart_timer.expires = jiffies + sport->dma_rx_timeout;
 	add_timer(&sport->lpuart_timer);
 
@@ -1106,6 +1103,8 @@ static int lpuart_startup(struct uart_port *port)
 		sport->lpuart_dma_use = false;
 	} else {
 		sport->lpuart_dma_use = true;
+		setup_timer(&sport->lpuart_timer, lpuart_timer_func,
+			    (unsigned long)sport);
 		temp = readb(port->membase + UARTCR5);
 		writeb(temp | UARTCR5_TDMAS, port->membase + UARTCR5);
 	}
@@ -1180,6 +1179,8 @@ static void lpuart_shutdown(struct uart_port *port)
 	devm_free_irq(port->dev, port->irq, sport);
 
 	if (sport->lpuart_dma_use) {
+		del_timer_sync(&sport->lpuart_timer);
+
 		lpuart_dma_tx_free(port);
 		lpuart_dma_rx_free(port);
 	}
-- 
2.1.3

