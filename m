Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaJPJEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:04:36 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:33391 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaJPJEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:04:34 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty/serial_core: Introduce lock mechanism for RS485
Date: Thu, 16 Oct 2014 11:04:27 +0200
Message-Id: <1413450267-24760-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce an homogeneous lock system between setting and using the rs485
data of the uart_port.

This patch should not be split into multiple ones in order to avoid
leaving the tree in an unstable state.

Suggested-by: Alan Cox <alan@linux.intel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

This patch sits on top of the series: "[PATCH 00/12] Handle
TIOC[GS]RS485 iocts on serial_core"

If there are major changes on the other patches I will resend the whole
patchset with this patch as part of it

v2: Implement changes suggested by Alan:

-The copy needs to go to a temporary before the lock is taken
otherwise we may sleep on a pagefault with irqs off

 drivers/tty/serial/atmel_serial.c | 10 ++++------
 drivers/tty/serial/mcf.c          |  5 +----
 drivers/tty/serial/omap-serial.c  |  3 ---
 drivers/tty/serial/serial_core.c  | 13 ++++++++++++-
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index e8df8e4..32b2a8d 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -293,9 +293,6 @@ static int atmel_config_rs485(struct uart_port *port,
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int mode;
-	unsigned long flags;
-
-	spin_lock_irqsave(&port->lock, flags);
 
 	/* Disable interrupts */
 	UART_PUT_IDR(port, atmel_port->tx_done_mask);
@@ -326,8 +323,6 @@ static int atmel_config_rs485(struct uart_port *port,
 	/* Enable interrupts */
 	UART_PUT_IER(port, atmel_port->tx_done_mask);
 
-	spin_unlock_irqrestore(&port->lock, flags);
-
 	return 0;
 }
 
@@ -2509,6 +2504,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
 	struct atmel_uart_data *pdata = dev_get_platdata(&pdev->dev);
 	void *data;
 	int ret = -ENODEV;
+	bool rs485_enabled;
 
 	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
 
@@ -2556,6 +2552,8 @@ static int atmel_serial_probe(struct platform_device *pdev)
 		port->rx_ring.buf = data;
 	}
 
+	rs485_enabled = port->uart.rs485.flags & SER_RS485_ENABLED;
+
 	ret = uart_add_one_port(&atmel_uart, &port->uart);
 	if (ret)
 		goto err_add_port;
@@ -2574,7 +2572,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
 
-	if (port->uart.rs485.flags & SER_RS485_ENABLED) {
+	if (rs485_enabled) {
 		UART_PUT_MR(&port->uart, ATMEL_US_USMODE_NORMAL);
 		UART_PUT_CR(&port->uart, ATMEL_US_RTSEN);
 	}
diff --git a/drivers/tty/serial/mcf.c b/drivers/tty/serial/mcf.c
index d7be1f1..fdd5c7b 100644
--- a/drivers/tty/serial/mcf.c
+++ b/drivers/tty/serial/mcf.c
@@ -257,12 +257,12 @@ static void mcf_set_termios(struct uart_port *port, struct ktermios *termios,
 		mr2 |= MCFUART_MR2_TXCTS;
 	}
 
+	spin_lock_irqsave(&port->lock, flags);
 	if (port->rs485.flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
 		mr2 |= MCFUART_MR2_TXRTS;
 	}
 
-	spin_lock_irqsave(&port->lock, flags);
 	uart_update_timeout(port, termios->c_cflag, baud);
 	writeb(MCFUART_UCR_CMDRESETRX, port->membase + MCFUART_UCR);
 	writeb(MCFUART_UCR_CMDRESETTX, port->membase + MCFUART_UCR);
@@ -442,10 +442,8 @@ static int mcf_verify_port(struct uart_port *port, struct serial_struct *ser)
 static int mcf_config_rs485(struct uart_port *port, struct serial_rs485 *rs485)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 	unsigned char mr1, mr2;
 
-	spin_lock_irqsave(&port->lock, flags);
 	/* Get mode registers */
 	mr1 = readb(port->membase + MCFUART_UMR);
 	mr2 = readb(port->membase + MCFUART_UMR);
@@ -460,7 +458,6 @@ static int mcf_config_rs485(struct uart_port *port, struct serial_rs485 *rs485)
 	writeb(mr1, port->membase + MCFUART_UMR);
 	writeb(mr2, port->membase + MCFUART_UMR);
 	port->rs485 = *rs485;
-	spin_unlock_irqrestore(&port->lock, flags);
 
 	return 0;
 }
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 9d4726f..6675dbf 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1360,12 +1360,10 @@ static int
 serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
-	unsigned long flags;
 	unsigned int mode;
 	int val;
 
 	pm_runtime_get_sync(up->dev);
-	spin_lock_irqsave(&up->port.lock, flags);
 
 	/* Disable interrupts from this port */
 	mode = up->ier;
@@ -1401,7 +1399,6 @@ serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 		serial_out(up, UART_OMAP_SCR, up->scr);
 	}
 
-	spin_unlock_irqrestore(&up->port.lock, flags);
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b59c925..4d0f1f1 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1154,8 +1154,16 @@ static int uart_get_icount(struct tty_struct *tty,
 static int uart_get_rs485_config(struct uart_port *port,
 			 struct serial_rs485 __user *rs485)
 {
-	if (copy_to_user(rs485, &port->rs485, sizeof(port->rs485)))
+	unsigned long flags;
+	struct serial_rs485 aux;
+
+	spin_lock_irqsave(&port->lock, flags);
+	aux = port->rs485;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (copy_to_user(rs485, &aux, sizeof(aux)))
 		return -EFAULT;
+
 	return 0;
 }
 
@@ -1164,6 +1172,7 @@ static int uart_set_rs485_config(struct uart_port *port,
 {
 	struct serial_rs485 rs485;
 	int ret;
+	unsigned long flags;
 
 	if (!port->rs485_config)
 		return -ENOIOCTLCMD;
@@ -1171,7 +1180,9 @@ static int uart_set_rs485_config(struct uart_port *port,
 	if (copy_from_user(&rs485, rs485_user, sizeof(rs485_user)))
 		return -EFAULT;
 
+	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &rs485);
+	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		return ret;
 
-- 
2.1.1

