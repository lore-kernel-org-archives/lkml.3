Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaJHT7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:59:07 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:54281 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaJHT61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:27 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] serial/omap: Use the rs485 functions on serial_core
Date: Wed,  8 Oct 2014 21:57:36 +0200
Message-Id: <1412798258-23655-11-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to unify all the rs485 ioctl handling
Use the implementation of TIOC[GS]RS485 ioctl handling on serial_core.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/omap-serial.c | 71 +++++++++++++---------------------------
 1 file changed, 23 insertions(+), 48 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 18c30ca..9d4726f 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -163,7 +163,6 @@ struct uart_omap_port {
 	u8			wakeups_enabled;
 	u32			features;
 
-	struct serial_rs485	rs485;
 	int			rts_gpio;
 
 	struct pm_qos_request	pm_qos_request;
@@ -316,7 +315,7 @@ static void serial_omap_stop_tx(struct uart_port *port)
 	pm_runtime_get_sync(up->dev);
 
 	/* Handle RS-485 */
-	if (up->rs485.flags & SER_RS485_ENABLED) {
+	if (port->rs485.flags & SER_RS485_ENABLED) {
 		if (up->scr & OMAP_UART_SCR_TX_EMPTY) {
 			/* THR interrupt is fired when both TX FIFO and TX
 			 * shift register are empty. This means there's nothing
@@ -327,11 +326,13 @@ static void serial_omap_stop_tx(struct uart_port *port)
 			 */
 			up->scr &= ~OMAP_UART_SCR_TX_EMPTY;
 			serial_out(up, UART_OMAP_SCR, up->scr);
-			res = (up->rs485.flags & SER_RS485_RTS_AFTER_SEND) ? 1 : 0;
+			res = (port->rs485.flags & SER_RS485_RTS_AFTER_SEND) ?
+				1 : 0;
 			if (gpio_get_value(up->rts_gpio) != res) {
-				if (up->rs485.delay_rts_after_send > 0)
-					mdelay(up->rs485.delay_rts_after_send);
-				gpio_set_value(up->rts_gpio, res);
+				if (port->rs485.delay_rts_after_send > 0)
+					mdelay(
+					port->rs485.delay_rts_after_send);
+				gpio_set_value(port->rts_gpio, res);
 			}
 		} else {
 			/* We're asked to stop, but there's still stuff in the
@@ -353,8 +354,8 @@ static void serial_omap_stop_tx(struct uart_port *port)
 		serial_out(up, UART_IER, up->ier);
 	}
 
-	if ((up->rs485.flags & SER_RS485_ENABLED) &&
-	    !(up->rs485.flags & SER_RS485_RX_DURING_TX)) {
+	if ((port->rs485.flags & SER_RS485_ENABLED) &&
+	    !(port->rs485.flags & SER_RS485_RX_DURING_TX)) {
 		/*
 		 * Empty the RX FIFO, we are not interested in anything
 		 * received during the half-duplex transmission.
@@ -429,22 +430,22 @@ static void serial_omap_start_tx(struct uart_port *port)
 	pm_runtime_get_sync(up->dev);
 
 	/* Handle RS-485 */
-	if (up->rs485.flags & SER_RS485_ENABLED) {
+	if (port->rs485.flags & SER_RS485_ENABLED) {
 		/* Fire THR interrupts when FIFO is below trigger level */
 		up->scr &= ~OMAP_UART_SCR_TX_EMPTY;
 		serial_out(up, UART_OMAP_SCR, up->scr);
 
 		/* if rts not already enabled */
-		res = (up->rs485.flags & SER_RS485_RTS_ON_SEND) ? 1 : 0;
+		res = (port->rs485.flags & SER_RS485_RTS_ON_SEND) ? 1 : 0;
 		if (gpio_get_value(up->rts_gpio) != res) {
 			gpio_set_value(up->rts_gpio, res);
-			if (up->rs485.delay_rts_before_send > 0)
-				mdelay(up->rs485.delay_rts_before_send);
+			if (port->rs485.delay_rts_before_send > 0)
+				mdelay(port->rs485.delay_rts_before_send);
 		}
 	}
 
-	if ((up->rs485.flags & SER_RS485_ENABLED) &&
-	    !(up->rs485.flags & SER_RS485_RX_DURING_TX))
+	if ((port->rs485.flags & SER_RS485_ENABLED) &&
+	    !(port->rs485.flags & SER_RS485_RX_DURING_TX))
 		serial_omap_stop_rx(port);
 
 	serial_omap_enable_ier_thri(up);
@@ -1355,7 +1356,7 @@ static inline void serial_omap_add_console_port(struct uart_omap_port *up)
 #endif
 
 /* Enable or disable the rs485 support */
-static void
+static int
 serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
@@ -1372,7 +1373,7 @@ serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 	serial_out(up, UART_IER, 0);
 
 	/* store new config */
-	up->rs485 = *rs485conf;
+	port->rs485 = *rs485conf;
 
 	/*
 	 * Just as a precaution, only allow rs485
@@ -1380,12 +1381,12 @@ serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 	 */
 	if (gpio_is_valid(up->rts_gpio)) {
 		/* enable / disable rts */
-		val = (up->rs485.flags & SER_RS485_ENABLED) ?
+		val = (port->rs485.flags & SER_RS485_ENABLED) ?
 			SER_RS485_RTS_AFTER_SEND : SER_RS485_RTS_ON_SEND;
-		val = (up->rs485.flags & val) ? 1 : 0;
+		val = (port->rs485.flags & val) ? 1 : 0;
 		gpio_set_value(up->rts_gpio, val);
 	} else
-		up->rs485.flags &= ~SER_RS485_ENABLED;
+		port->rs485.flags &= ~SER_RS485_ENABLED;
 
 	/* Enable interrupts */
 	up->ier = mode;
@@ -1394,7 +1395,7 @@ serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 	/* If RS-485 is disabled, make sure the THR interrupt is fired when
 	 * TX FIFO is below the trigger level.
 	 */
-	if (!(up->rs485.flags & SER_RS485_ENABLED) &&
+	if (!(port->rs485.flags & SER_RS485_ENABLED) &&
 	    (up->scr & OMAP_UART_SCR_TX_EMPTY)) {
 		up->scr &= ~OMAP_UART_SCR_TX_EMPTY;
 		serial_out(up, UART_OMAP_SCR, up->scr);
@@ -1403,36 +1404,10 @@ serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 	spin_unlock_irqrestore(&up->port.lock, flags);
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
-}
-
-static int
-serial_omap_ioctl(struct uart_port *port, unsigned int cmd, unsigned long arg)
-{
-	struct serial_rs485 rs485conf;
-
-	switch (cmd) {
-	case TIOCSRS485:
-		if (copy_from_user(&rs485conf, (void __user *) arg,
-					sizeof(rs485conf)))
-			return -EFAULT;
 
-		serial_omap_config_rs485(port, &rs485conf);
-		break;
-
-	case TIOCGRS485:
-		if (copy_to_user((void __user *) arg,
-					&(to_uart_omap_port(port)->rs485),
-					sizeof(rs485conf)))
-			return -EFAULT;
-		break;
-
-	default:
-		return -ENOIOCTLCMD;
-	}
 	return 0;
 }
 
-
 static struct uart_ops serial_omap_pops = {
 	.tx_empty	= serial_omap_tx_empty,
 	.set_mctrl	= serial_omap_set_mctrl,
@@ -1453,7 +1428,6 @@ static struct uart_ops serial_omap_pops = {
 	.request_port	= serial_omap_request_port,
 	.config_port	= serial_omap_config_port,
 	.verify_port	= serial_omap_verify_port,
-	.ioctl		= serial_omap_ioctl,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_put_char  = serial_omap_poll_put_char,
 	.poll_get_char  = serial_omap_poll_get_char,
@@ -1587,7 +1561,7 @@ static struct omap_uart_port_info *of_get_uart_port_info(struct device *dev)
 static int serial_omap_probe_rs485(struct uart_omap_port *up,
 				   struct device_node *np)
 {
-	struct serial_rs485 *rs485conf = &up->rs485;
+	struct serial_rs485 *rs485conf = &up->port.rs485;
 	u32 rs485_delay[2];
 	enum of_gpio_flags flags;
 	int ret;
@@ -1702,6 +1676,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 	up->port.membase = base;
 	up->port.flags = omap_up_info->flags;
 	up->port.uartclk = omap_up_info->uartclk;
+	up->port.rs485_config = serial_omap_config_rs485;
 	if (!up->port.uartclk) {
 		up->port.uartclk = DEFAULT_CLK_SPEED;
 		dev_warn(&pdev->dev,
-- 
2.1.1

