Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaJHUBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:01:07 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63822 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaJHT6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:21 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] serial/8250: Remove obsolete handling of rs485 ioctls
Date: Wed,  8 Oct 2014 21:57:32 +0200
Message-Id: <1412798258-23655-7-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no more users for this functions. All the 8250 drivers are
using the rs485 handler on serial_core instead.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/8250/8250_core.c | 39 -------------------------------------
 include/linux/serial_8250.h         |  3 ---
 2 files changed, 42 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 6cdd4cf..5d62129 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2975,42 +2975,6 @@ serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return 0;
 }
 
-static int serial8250_ioctl(struct uart_port *port, unsigned int cmd,
-			   unsigned long arg)
-{
-	struct uart_8250_port *up =
-		container_of(port, struct uart_8250_port, port);
-	int ret;
-	struct serial_rs485 rs485_config;
-
-	if (!up->rs485_config)
-		return -ENOIOCTLCMD;
-
-	switch (cmd) {
-	case TIOCSRS485:
-		if (copy_from_user(&rs485_config, (void __user *)arg,
-				   sizeof(rs485_config)))
-			return -EFAULT;
-
-		ret = up->rs485_config(up, &rs485_config);
-		if (ret)
-			return ret;
-
-		memcpy(&up->rs485, &rs485_config, sizeof(rs485_config));
-
-		return 0;
-	case TIOCGRS485:
-		if (copy_to_user((void __user *)arg, &up->rs485,
-				 sizeof(up->rs485)))
-			return -EFAULT;
-		return 0;
-	default:
-		break;
-	}
-
-	return -ENOIOCTLCMD;
-}
-
 static const char *
 serial8250_type(struct uart_port *port)
 {
@@ -3042,7 +3006,6 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
-	.ioctl		= serial8250_ioctl,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial8250_get_poll_char,
 	.poll_put_char = serial8250_put_poll_char,
@@ -3585,8 +3548,6 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->port.fifosize	= up->port.fifosize;
 		uart->tx_loadsz		= up->tx_loadsz;
 		uart->capabilities	= up->capabilities;
-		uart->rs485_config	= up->rs485_config;
-		uart->rs485		= up->rs485;
 		uart->port.throttle	= up->port.throttle;
 		uart->port.unthrottle	= up->port.unthrottle;
 		uart->port.rs485_config	= up->port.rs485_config;
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 3df10d5..e02acf0 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -97,13 +97,10 @@ struct uart_8250_port {
 	unsigned char		msr_saved_flags;
 
 	struct uart_8250_dma	*dma;
-	struct serial_rs485     rs485;
 
 	/* 8250 specific callbacks */
 	int			(*dl_read)(struct uart_8250_port *);
 	void			(*dl_write)(struct uart_8250_port *, int);
-	int			(*rs485_config)(struct uart_8250_port *,
-						struct serial_rs485 *rs485);
 };
 
 static inline struct uart_8250_port *up_to_u8250p(struct uart_port *up)
-- 
2.1.1

