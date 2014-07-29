Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaG2Q1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:27:32 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:42212 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaG2Q13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:27:29 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/2] serial/8250: Add support for RS485 IOCTLs
Date: Tue, 29 Jul 2014 18:27:21 +0200
Message-Id: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow the users of the 8250 infrastructure to define a
handler for RS485 configration.

If no handler is defined the 8250 driver will work as usual.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/8250/8250_core.c | 39 +++++++++++++++++++++++++++++++++++++
 include/linux/serial_8250.h         |  3 +++
 2 files changed, 42 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 1d42dba..b28ed1b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2843,6 +2843,42 @@ serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return 0;
 }
 
+static int serial8250_ioctl(struct uart_port *port, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	int ret;
+	struct serial_rs485 rs485_config;
+
+	if (!up->rs485_config)
+		return -ENOIOCTLCMD;
+
+	switch (cmd) {
+	case TIOCSRS485:
+		if (copy_from_user(&rs485_config, (void __user *)arg,
+				   sizeof(rs485_config)))
+			return -EFAULT;
+
+		ret = up->rs485_config(up, &rs485_config);
+		if (ret)
+			return ret;
+
+		memcpy(&up->rs485, &rs485_config, sizeof(rs485_config));
+
+		return 0;
+	case TIOCGRS485:
+		if (copy_to_user((void __user *)arg, &up->rs485,
+				 sizeof(up->rs485)))
+			return -EFAULT;
+		return 0;
+	default:
+		break;
+	}
+
+	return -ENOIOCTLCMD;
+}
+
 static const char *
 serial8250_type(struct uart_port *port)
 {
@@ -2872,6 +2908,7 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+	.ioctl		= serial8250_ioctl,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial8250_get_poll_char,
 	.poll_put_char = serial8250_put_poll_char,
@@ -3388,6 +3425,8 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->port.fifosize	= up->port.fifosize;
 		uart->tx_loadsz		= up->tx_loadsz;
 		uart->capabilities	= up->capabilities;
+		uart->rs485_config	= up->rs485_config;
+		uart->rs485		= up->rs485;
 
 		/* Take tx_loadsz from fifosize if it wasn't set separately */
 		if (uart->port.fifosize && !uart->tx_loadsz)
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index f93649e..c022370 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -70,6 +70,7 @@ struct uart_8250_dma;
 
 struct uart_8250_port {
 	struct uart_port	port;
+	struct serial_rs485     rs485;
 	struct timer_list	timer;		/* "no irq" timer */
 	struct list_head	list;		/* ports on this IRQ */
 	unsigned short		capabilities;	/* port capabilities */
@@ -100,6 +101,8 @@ struct uart_8250_port {
 	/* 8250 specific callbacks */
 	int			(*dl_read)(struct uart_8250_port *);
 	void			(*dl_write)(struct uart_8250_port *, int);
+	int			(*rs485_config)(struct uart_8250_port *,
+						struct serial_rs485 *rs485);
 };
 
 static inline struct uart_8250_port *up_to_u8250p(struct uart_port *up)
-- 
2.0.1

