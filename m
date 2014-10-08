Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaJHT6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:58:36 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:44866 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaJHT63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:29 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] drivers/max310: Use the rs485 functions on serial_core
Date: Wed,  8 Oct 2014 21:57:37 +0200
Message-Id: <1412798258-23655-12-git-send-email-ricardo.ribalda@gmail.com>
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
 drivers/tty/serial/max310x.c | 70 +++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 670aba4..5ad9713 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -874,53 +874,37 @@ static void max310x_set_termios(struct uart_port *port,
 	uart_update_timeout(port, termios->c_cflag, baud);
 }
 
-static int max310x_ioctl(struct uart_port *port, unsigned int cmd,
-			 unsigned long arg)
+static int max310x_rs485_config(struct uart_port *port,
+				struct serial_rs485 *rs485)
 {
-	struct serial_rs485 rs485;
 	unsigned int val;
 
-	switch (cmd) {
-	case TIOCSRS485:
-		if (copy_from_user(&rs485, (void __user *)arg, sizeof(rs485)))
-			return -EFAULT;
-		if (rs485.delay_rts_before_send > 0x0f ||
-		    rs485.delay_rts_after_send > 0x0f)
-			return -ERANGE;
-		val = (rs485.delay_rts_before_send << 4) |
-		      rs485.delay_rts_after_send;
-		max310x_port_write(port, MAX310X_HDPIXDELAY_REG, val);
-		if (rs485.flags & SER_RS485_ENABLED) {
-			max310x_port_update(port, MAX310X_MODE1_REG,
-					    MAX310X_MODE1_TRNSCVCTRL_BIT,
-					    MAX310X_MODE1_TRNSCVCTRL_BIT);
-			max310x_port_update(port, MAX310X_MODE2_REG,
-					    MAX310X_MODE2_ECHOSUPR_BIT,
-					    MAX310X_MODE2_ECHOSUPR_BIT);
-		} else {
-			max310x_port_update(port, MAX310X_MODE1_REG,
-					    MAX310X_MODE1_TRNSCVCTRL_BIT, 0);
-			max310x_port_update(port, MAX310X_MODE2_REG,
-					    MAX310X_MODE2_ECHOSUPR_BIT, 0);
-		}
-		return 0;
-	case TIOCGRS485:
-		memset(&rs485, 0, sizeof(rs485));
-		val = max310x_port_read(port, MAX310X_MODE1_REG);
-		rs485.flags = (val & MAX310X_MODE1_TRNSCVCTRL_BIT) ?
-			      SER_RS485_ENABLED : 0;
-		rs485.flags |= SER_RS485_RTS_ON_SEND;
-		val = max310x_port_read(port, MAX310X_HDPIXDELAY_REG);
-		rs485.delay_rts_before_send = val >> 4;
-		rs485.delay_rts_after_send = val & 0x0f;
-		if (copy_to_user((void __user *)arg, &rs485, sizeof(rs485)))
-			return -EFAULT;
-		return 0;
-	default:
-		break;
+	if (rs485->delay_rts_before_send > 0x0f ||
+		    rs485->delay_rts_after_send > 0x0f)
+		return -ERANGE;
+
+	val = (rs485->delay_rts_before_send << 4) |
+		rs485->delay_rts_after_send;
+	max310x_port_write(port, MAX310X_HDPIXDELAY_REG, val);
+	if (rs485->flags & SER_RS485_ENABLED) {
+		max310x_port_update(port, MAX310X_MODE1_REG,
+				MAX310X_MODE1_TRNSCVCTRL_BIT,
+				MAX310X_MODE1_TRNSCVCTRL_BIT);
+		max310x_port_update(port, MAX310X_MODE2_REG,
+				MAX310X_MODE2_ECHOSUPR_BIT,
+				MAX310X_MODE2_ECHOSUPR_BIT);
+	} else {
+		max310x_port_update(port, MAX310X_MODE1_REG,
+				MAX310X_MODE1_TRNSCVCTRL_BIT, 0);
+		max310x_port_update(port, MAX310X_MODE2_REG,
+				MAX310X_MODE2_ECHOSUPR_BIT, 0);
 	}
 
-	return -ENOIOCTLCMD;
+	rs485->flags &= SER_RS485_RTS_ON_SEND | SER_RS485_ENABLED;
+	memset(rs485->padding, 0, sizeof(rs485->padding));
+	port->rs485 = *rs485;
+
+	return 0;
 }
 
 static int max310x_startup(struct uart_port *port)
@@ -1015,7 +999,6 @@ static const struct uart_ops max310x_ops = {
 	.release_port	= max310x_null_void,
 	.config_port	= max310x_config_port,
 	.verify_port	= max310x_verify_port,
-	.ioctl		= max310x_ioctl,
 };
 
 static int __maybe_unused max310x_suspend(struct device *dev)
@@ -1216,6 +1199,7 @@ static int max310x_probe(struct device *dev, struct max310x_devtype *devtype,
 		s->p[i].port.iobase	= i * 0x20;
 		s->p[i].port.membase	= (void __iomem *)~0;
 		s->p[i].port.uartclk	= uartclk;
+		s->p[i].port.rs485_config = max310x_rs485_config;
 		s->p[i].port.ops	= &max310x_ops;
 		/* Disable all interrupts */
 		max310x_port_write(&s->p[i].port, MAX310X_IRQEN_REG, 0);
-- 
2.1.1

