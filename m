Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbaBDVki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:40:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbaBDVLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Roszko <mark.roszko@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.13 058/140] tty/serial: at91: disable uart timer at start of shutdown
Date: Tue,  4 Feb 2014 13:10:45 -0800
Message-Id: <20140204211038.621883030@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Roszko <mark.roszko@gmail.com>

commit 8bc661bfc0c2d221e209f4205bdaaf574d50100c upstream.

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
[nicolas.ferre@atmel.com: modify commit message, call setup_timer() in any case]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/atmel_serial.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -825,9 +825,6 @@ static void atmel_release_rx_dma(struct
 	atmel_port->desc_rx = NULL;
 	atmel_port->chan_rx = NULL;
 	atmel_port->cookie_rx = -EINVAL;
-
-	if (!atmel_port->is_usart)
-		del_timer_sync(&atmel_port->uart_timer);
 }
 
 static void atmel_rx_from_dma(struct uart_port *port)
@@ -1229,9 +1226,6 @@ static void atmel_release_rx_pdc(struct
 				 DMA_FROM_DEVICE);
 		kfree(pdc->buf);
 	}
-
-	if (!atmel_port->is_usart)
-		del_timer_sync(&atmel_port->uart_timer);
 }
 
 static void atmel_rx_from_pdc(struct uart_port *port)
@@ -1604,12 +1598,13 @@ static int atmel_startup(struct uart_por
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
@@ -1624,9 +1619,6 @@ static int atmel_startup(struct uart_por
 	} else if (atmel_use_dma_rx(port)) {
 		/* set UART timeout */
 		if (!atmel_port->is_usart) {
-			setup_timer(&atmel_port->uart_timer,
-					atmel_uart_timer_callback,
-					(unsigned long)port);
 			mod_timer(&atmel_port->uart_timer,
 					jiffies + uart_poll_timeout(port));
 		/* set USART timeout */
@@ -1652,6 +1644,12 @@ static void atmel_shutdown(struct uart_p
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


