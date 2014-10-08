Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaJHT6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:58:22 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:44904 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaJHT6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:17 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] serial_core: Handle TIOC[GS]RS485 ioctls.
Date: Wed,  8 Oct 2014 21:57:29 +0200
Message-Id: <1412798258-23655-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following drivers: 8250_core, atmel_serial, max310x, mcf, omap-serial
and sci16is7xx implement code to handle RS485 ioctls.

In order to avoid code duplication, we implement a simple ioctl handler
on the serial_core layer.

This handler can be used by all the other drivers instead of duplicating
code.

Until this is the only RS485 ioctl handler, it will try first the
rs485_config callback and if it is not present it will call the driver
specific ioctl.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/serial_core.c | 45 ++++++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h      |  3 +++
 2 files changed, 48 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index df3a8c7..6015fd2 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1151,6 +1151,39 @@ static int uart_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
+static int uart_get_rs485_config(struct uart_port *port,
+			 struct serial_rs485 __user *rs485)
+{
+	if (!port->rs485_config)
+		return -ENOIOCTLCMD;
+
+	if (copy_to_user(rs485, &port->rs485, sizeof(port->rs485)))
+		return -EFAULT;
+	return 0;
+}
+
+static int uart_set_rs485_config(struct uart_port *port,
+			 struct serial_rs485 __user *rs485_user)
+{
+	struct serial_rs485 rs485;
+	int ret;
+
+	if (!port->rs485_config)
+		return -ENOIOCTLCMD;
+
+	if (copy_from_user(&rs485, rs485_user, sizeof(rs485_user)))
+		return -EFAULT;
+
+	ret = port->rs485_config(port, &rs485);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(rs485_user, &port->rs485, sizeof(port->rs485)))
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  * Called via sys_ioctl.  We can use spin_lock_irq() here.
  */
@@ -1218,6 +1251,18 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd,
 	 * protected against the tty being hung up.
 	 */
 	switch (cmd) {
+	case TIOCGRS485:
+		ret = uart_get_rs485_config(state->uart_port, uarg);
+		break;
+
+	case TIOCSRS485:
+		ret = uart_set_rs485_config(state->uart_port, uarg);
+		break;
+	}
+	if (ret != -ENOIOCTLCMD)
+		goto out;
+
+	switch (cmd) {
 	case TIOCSERGETLSR: /* Get line status register */
 		ret = uart_get_lsr_info(tty, state, uarg);
 		break;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 21c2e05..60a4ebf 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -131,6 +131,8 @@ struct uart_port {
 	void			(*pm)(struct uart_port *, unsigned int state,
 				      unsigned int old);
 	void			(*handle_break)(struct uart_port *);
+	int			(*rs485_config)(struct uart_port *,
+						struct serial_rs485 *rs485);
 	unsigned int		irq;			/* irq number */
 	unsigned long		irqflags;		/* irq flags  */
 	unsigned int		uartclk;		/* base uart clock */
@@ -214,6 +216,7 @@ struct uart_port {
 	unsigned char		unused[2];
 	struct attribute_group	*attr_group;		/* port specific attributes */
 	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
+	struct serial_rs485     rs485;
 	void			*private_data;		/* generic platform data pointer */
 };
 
-- 
2.1.1

