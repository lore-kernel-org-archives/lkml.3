Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbbAUKa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:30:27 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35019 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbAUKaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:30:18 -0500
From: Peter Hung <hpeter@gmail.com>
X-Google-Original-From: Peter Hung <hpeter+linux_kernel@gmail.com>
To: johan@kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: [PATCH v2 3/4] usb: serial: implement function for F81232
Date: Wed, 21 Jan 2015 18:30:14 +0800
Message-Id: <1421836214-25582-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the following function:
set_termios, tiocmset, tiocmget, dtr_rts

Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
---
 drivers/usb/serial/f81232.c | 103 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 84 insertions(+), 19 deletions(-)
 mode change 100644 => 100755 drivers/usb/serial/f81232.c

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index b372975..9a54f56 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -346,27 +346,99 @@ static void f81232_break_ctl(struct tty_struct *tty, int break_state)
 static void f81232_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
-	/* FIXME - Stubbed out for now */
+	u16 divisor;
+	u16 new_lcr = 0;
+	int status;
+	struct ktermios *termios = &tty->termios;
+	struct usb_device *dev = port->serial->dev;
+	unsigned int cflag = termios->c_cflag;
 
-	/* Don't change anything if nothing has changed */
-	if (old_termios && !tty_termios_hw_change(&tty->termios, old_termios))
-		return;
+	divisor = calc_baud_divisor(tty_get_baud_rate(tty));
+
+	status = f81232_set_register(dev, LINE_CONTROL_REGISTER,
+			 UART_LCR_DLAB); /* DLAB */
+
+	status = f81232_set_register(dev, RECEIVE_BUFFER_REGISTER,
+			 divisor & 0x00ff); /* low */
+
+	status = f81232_set_register(dev, INTERRUPT_ENABLE_REGISTER,
+			 (divisor & 0xff00) >> 8); /* high */
+
+	status = f81232_set_register(dev, LINE_CONTROL_REGISTER, 0x00);
+
+
+	if (cflag & PARENB) {
+		if (cflag & PARODD)
+			new_lcr |= UART_LCR_PARITY; /* odd */
+		else
+			new_lcr |= SERIAL_EVEN_PARITY; /* even */
+	}
+
+	if (cflag & CSTOPB)
+		new_lcr |= UART_LCR_STOP;
+	else
+		new_lcr &= ~UART_LCR_STOP;
+
+	switch (cflag & CSIZE) {
+	case CS5:
+		new_lcr |= UART_LCR_WLEN5;
+		break;
+	case CS6:
+		new_lcr |= UART_LCR_WLEN6;
+		break;
+	case CS7:
+		new_lcr |= UART_LCR_WLEN7;
+		break;
+	default:
+	case CS8:
+		new_lcr |= UART_LCR_WLEN8;
+		break;
+	}
+
+	status |= f81232_set_register(dev, LINE_CONTROL_REGISTER, new_lcr);
+
+	status |= f81232_set_register(dev, FIFO_CONTROL_REGISTER,
+			  0x87); /* fifo, trigger8 */
+	status |= f81232_set_register(dev,
+			  INTERRUPT_ENABLE_REGISTER, 0xf); /* IER */
+
+	if (status < 0)
+		dev_err(&port->dev, "LINE_CONTROL_REGISTER set error: %d\n",
+			status);
 
-	/* Do the real work here... */
-	if (old_termios)
-		tty_termios_copy_hw(&tty->termios, old_termios);
 }
 
 static int f81232_tiocmget(struct tty_struct *tty)
 {
-	/* FIXME - Stubbed out for now */
-	return 0;
+	int r;
+	struct usb_serial_port *port = tty->driver_data;
+	struct f81232_private *port_priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	u8 mcr, msr;
+
+	spin_lock_irqsave(&port_priv->lock, flags);
+	mcr = port_priv->line_control;
+	msr = port_priv->line_status;
+	spin_unlock_irqrestore(&port_priv->lock, flags);
+
+	r = (mcr & UART_MCR_DTR ? TIOCM_DTR : 0) |
+		(mcr & UART_MCR_RTS ? TIOCM_RTS : 0) |
+		(msr & UART_MSR_CTS ? TIOCM_CTS : 0) |
+		(msr & UART_MSR_DCD ? TIOCM_CAR : 0) |
+		(msr & UART_MSR_RI ? TIOCM_RI : 0) |
+		(msr & UART_MSR_DSR ? TIOCM_DSR : 0);
+
+	return r;
 }
 
 static int f81232_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear)
 {
-	/* FIXME - Stubbed out for now */
+	struct usb_serial_port *port = tty->driver_data;
+	struct f81232_private *port_priv =
+		usb_get_serial_port_data(port);
+
+	update_mctrl(port_priv, set, clear);
 	return 0;
 }
 
@@ -403,18 +475,11 @@ static void f81232_close(struct usb_serial_port *port)
 static void f81232_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct f81232_private *priv = usb_get_serial_port_data(port);
-	unsigned long flags;
-	u8 control;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	/* Change DTR and RTS */
 	if (on)
-		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
+		update_mctrl(priv, TIOCM_DTR | TIOCM_RTS, 0);
 	else
-		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	control = priv->line_control;
-	spin_unlock_irqrestore(&priv->lock, flags);
-	set_control_lines(port->serial->dev, control);
+		update_mctrl(priv, 0, TIOCM_DTR | TIOCM_RTS);
 }
 
 static int f81232_carrier_raised(struct usb_serial_port *port)
-- 
1.9.1

