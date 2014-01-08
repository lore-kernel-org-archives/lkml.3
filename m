Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaAHK2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:28:44 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:6338 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAHK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:28:40 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <mark.roszko@gmail.com>, <gregkh@linuxfoundation.org>,
        <leilei.zhao@atmel.com>
CC: <mdeneen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH] tty/serial: at91: disable uart timer at start of shutdown
Date: Wed, 8 Jan 2014 11:28:36 +0100
Message-ID: <1389176916-6114-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <CAJjB1qLBoXA_XeEV+qU6pi0JVS+==kVA7mEDuAufrYup3htU2g@mail.gmail.com>
References: <CAJjB1qLBoXA_XeEV+qU6pi0JVS+==kVA7mEDuAufrYup3htU2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Roszko <mark.roszko@gmail.com>

The uart timer will schedule a tasklet when it fires. It is possible that it
can fire inside _shutdown before it is killed in the dma and pdc cleanup
routines. This causes a tasklet that exists after the port is shutdown, so when
the kernel finally executes it, it panics as the tty port is NULL.

This is a somewhat rare condition but its possible if a program keeps on
opening/closing the port. It has been observed in particular with systemd
boot messages that were causing a kernel panic because of this behavior.

Moving the timer deletion to the beginning of the function stops a tasklet from
being scheduled unexpectedly.

Signed-off-by: Marek Roszko <mark.roszko@gmail.com>
Cc: stable <stable@vger.kernel.org> # v3.12
[nicolas.ferre@atmel.com: modify commit message, call setup_timer() in any case]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Marek,

This is my modified version of your patch.
* I adapted it to the mainline kernel
* I rewrote the commit message
* I used setup_timer() / del_timer_sync() in any case, even the
  !DMA/!PDC case. Otherwise, the time would have been deleted in
  an uninitialized state which may lead to errors (I didn't checked
  though).

Can you please tell me how do you feel with this patch (and the commit message)
and if it solves the issue that you encounter on your side.

Best regards,

 drivers/tty/serial/atmel_serial.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 2b6ac1be00d3..a49f10d269b2 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -825,9 +825,6 @@ static void atmel_release_rx_dma(struct uart_port *port)
 	atmel_port->desc_rx = NULL;
 	atmel_port->chan_rx = NULL;
 	atmel_port->cookie_rx = -EINVAL;
-
-	if (!atmel_port->is_usart)
-		del_timer_sync(&atmel_port->uart_timer);
 }
 
 static void atmel_rx_from_dma(struct uart_port *port)
@@ -1229,9 +1226,6 @@ static void atmel_release_rx_pdc(struct uart_port *port)
 				 DMA_FROM_DEVICE);
 		kfree(pdc->buf);
 	}
-
-	if (!atmel_port->is_usart)
-		del_timer_sync(&atmel_port->uart_timer);
 }
 
 static void atmel_rx_from_pdc(struct uart_port *port)
@@ -1604,12 +1598,13 @@ static int atmel_startup(struct uart_port *port)
 	/* enable xmit & rcvr */
 	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
 
+	setup_timer(&atmel_port->uart_timer,
+			atmel_uart_timer_callback,
+			(unsigned long)port);
+
 	if (atmel_use_pdc_rx(port)) {
 		/* set UART timeout */
 		if (!atmel_port->is_usart) {
-			setup_timer(&atmel_port->uart_timer,
-					atmel_uart_timer_callback,
-					(unsigned long)port);
 			mod_timer(&atmel_port->uart_timer,
 					jiffies + uart_poll_timeout(port));
 		/* set USART timeout */
@@ -1624,9 +1619,6 @@ static int atmel_startup(struct uart_port *port)
 	} else if (atmel_use_dma_rx(port)) {
 		/* set UART timeout */
 		if (!atmel_port->is_usart) {
-			setup_timer(&atmel_port->uart_timer,
-					atmel_uart_timer_callback,
-					(unsigned long)port);
 			mod_timer(&atmel_port->uart_timer,
 					jiffies + uart_poll_timeout(port));
 		/* set USART timeout */
@@ -1652,6 +1644,12 @@ static void atmel_shutdown(struct uart_port *port)
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	/*
+	 * Prevent any tasklets being scheduled during
+	 * cleanup
+	 */
+	del_timer_sync(&atmel_port->uart_timer);
+
+	/*
 	 * Clear out any scheduled tasklets before
 	 * we destroy the buffers
 	 */
-- 
1.8.2.2

