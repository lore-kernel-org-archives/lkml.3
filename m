Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaJHUAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:00:43 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:56406 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaJHT6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:22 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] serial/sc16is7xx: Use the rs485 functions on serial_core
Date: Wed,  8 Oct 2014 21:57:33 +0200
Message-Id: <1412798258-23655-8-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to unify all the rs485 ioctl handling.
Use the implementation of TIOC[GS]RS485 ioctl handling on serial_core.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/sc16is7xx.c | 53 ++++++++++--------------------------------
 1 file changed, 12 insertions(+), 41 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 3ab5d1b..8c04f59 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -304,8 +304,6 @@ struct sc16is7xx_one {
 	struct uart_port		port;
 	struct work_struct		tx_work;
 	struct work_struct		md_work;
-
-	struct serial_rs485		rs485;
 };
 
 struct sc16is7xx_port {
@@ -657,15 +655,15 @@ static void sc16is7xx_stop_tx(struct uart_port* port)
 	struct circ_buf *xmit = &one->port.state->xmit;
 
 	/* handle rs485 */
-	if (one->rs485.flags & SER_RS485_ENABLED) {
+	if (port->rs485.flags & SER_RS485_ENABLED) {
 		/* do nothing if current tx not yet completed */
 		int lsr = sc16is7xx_port_read(port, SC16IS7XX_LSR_REG);
 		if (!(lsr & SC16IS7XX_LSR_TEMT_BIT))
 			return;
 
 		if (uart_circ_empty(xmit) &&
-		    (one->rs485.delay_rts_after_send > 0))
-			mdelay(one->rs485.delay_rts_after_send);
+		    (port->rs485.delay_rts_after_send > 0))
+			mdelay(port->rs485.delay_rts_after_send);
 	}
 
 	sc16is7xx_port_update(port, SC16IS7XX_IER_REG,
@@ -688,9 +686,9 @@ static void sc16is7xx_start_tx(struct uart_port *port)
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
 	/* handle rs485 */
-	if ((one->rs485.flags & SER_RS485_ENABLED) &&
-	    (one->rs485.delay_rts_before_send > 0)) {
-		mdelay(one->rs485.delay_rts_before_send);
+	if ((port->rs485.flags & SER_RS485_ENABLED) &&
+	    (port->rs485.delay_rts_before_send > 0)) {
+		mdelay(port->rs485.delay_rts_before_send);
 	}
 
 	if (!work_pending(&one->tx_work))
@@ -830,47 +828,20 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	uart_update_timeout(port, termios->c_cflag, baud);
 }
 
-static void sc16is7xx_config_rs485(struct uart_port *port,
+static int sc16is7xx_config_rs485(struct uart_port *port,
 				   struct serial_rs485 *rs485)
 {
-	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
-
-	one->rs485 = *rs485;
-
-	if (one->rs485.flags & SER_RS485_ENABLED) {
+	if (port->rs485.flags & SER_RS485_ENABLED)
 		sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
 				      SC16IS7XX_EFCR_AUTO_RS485_BIT,
 				      SC16IS7XX_EFCR_AUTO_RS485_BIT);
-	} else {
+	else
 		sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
 				      SC16IS7XX_EFCR_AUTO_RS485_BIT,
 				      0);
-	}
-}
-
-static int sc16is7xx_ioctl(struct uart_port *port, unsigned int cmd,
-			   unsigned long arg)
-{
-	struct serial_rs485 rs485;
+	port->rs485 = *rs485;
 
-	switch (cmd) {
-	case TIOCSRS485:
-		if (copy_from_user(&rs485, (void __user *)arg, sizeof(rs485)))
-			return -EFAULT;
-
-		sc16is7xx_config_rs485(port, &rs485);
-		return 0;
-	case TIOCGRS485:
-		if (copy_to_user((void __user *)arg,
-				 &(to_sc16is7xx_one(port, port)->rs485),
-				 sizeof(rs485)))
-			return -EFAULT;
-		return 0;
-	default:
-		break;
-	}
-
-	return -ENOIOCTLCMD;
+	return 0;
 }
 
 static int sc16is7xx_startup(struct uart_port *port)
@@ -996,7 +967,6 @@ static const struct uart_ops sc16is7xx_ops = {
 	.release_port	= sc16is7xx_null_void,
 	.config_port	= sc16is7xx_config_port,
 	.verify_port	= sc16is7xx_verify_port,
-	.ioctl		= sc16is7xx_ioctl,
 	.pm		= sc16is7xx_pm,
 };
 
@@ -1126,6 +1096,7 @@ static int sc16is7xx_probe(struct device *dev,
 		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY;
 		s->p[i].port.iotype	= UPIO_PORT;
 		s->p[i].port.uartclk	= freq;
+		s->p[i].port.rs485_config = sc16is7xx_config_rs485;
 		s->p[i].port.ops	= &sc16is7xx_ops;
 		/* Disable all interrupts */
 		sc16is7xx_port_write(&s->p[i].port, SC16IS7XX_IER_REG, 0);
-- 
2.1.1

