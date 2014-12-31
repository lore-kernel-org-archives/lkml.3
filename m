Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaLaB3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:29:24 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46918 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaLaB3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:29:17 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Peter Hurley <peter@hurleysoftware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] serial: omap_8250: Fix RTS handling
Date: Tue, 30 Dec 2014 20:28:15 -0500
Message-Id: <1419989295-7290-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP3 UART ignores MCR[1] (ie., UART_MCR_RTS) when in autoRTS
mode (UPF_HARD_FLOW + CRTSCTS). This makes it impossible for either
the serial core or userspace to manually flow control the sender.

Disable autoRTS mode when RTS is lowered and restore the previous
mode when RTS is raised.

Note that the OMAP3 UART provides no mechanism for switching from
autoRTS mode without corrupting incoming data; to access the
necessary register, the line control settings must be set to 8-e-2
and thus any data received during that time will be interpreted with
those settings. This corruption has been observed in practice.

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 12 +++++++++++-
 drivers/tty/serial/8250/8250_omap.c | 25 ++++++++++++++++++++++---
 include/linux/serial_8250.h         |  1 +
 include/linux/serial_core.h         |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 11c6685..3bfcfdb 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1924,7 +1924,7 @@ static unsigned int serial8250_get_mctrl(struct uart_port *port)
 	return ret;
 }
 
-static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+void serial8250_do_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned char mcr = 0;
@@ -1944,6 +1944,14 @@ static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	serial_port_out(port, UART_MCR, mcr);
 }
+EXPORT_SYMBOL_GPL(serial8250_do_set_mctrl);
+
+static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	if (port->set_mctrl)
+		return port->set_mctrl(port, mctrl);
+	return serial8250_do_set_mctrl(port, mctrl);
+}
 
 static void serial8250_break_ctl(struct uart_port *port, int break_state)
 {
@@ -3605,6 +3613,8 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		/*  Possibly override set_termios call */
 		if (up->port.set_termios)
 			uart->port.set_termios = up->port.set_termios;
+		if (up->port.set_mctrl)
+			uart->port.set_mctrl = up->port.set_mctrl;
 		if (up->port.startup)
 			uart->port.startup = up->port.startup;
 		if (up->port.shutdown)
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 96b69bf..428f384 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -106,6 +106,27 @@ static u32 uart_read(struct uart_8250_port *up, u32 reg)
 	return readl(up->port.membase + (reg << up->port.regshift));
 }
 
+static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct uart_8250_port *up = up_to_u8250p(port);
+	struct omap8250_priv *priv = up->port.private_data;
+	u8 lcr;
+
+	serial8250_do_set_mctrl(port, mctrl);
+
+	/*
+	 * Turn off autoRTS if RTS is lowered and restore autoRTS setting
+	 * if RTS is raised
+	 */
+	lcr = serial_in(up, UART_LCR);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+	if (mctrl & TIOCM_RTS)
+		serial_out(up, UART_EFR, priv->efr);
+	else
+		serial_out(up, UART_EFR, priv->efr & ~UART_EFR_RTS);
+	serial_out(up, UART_LCR, lcr);
+}
+
 /*
  * Work Around for Errata i202 (2430, 3430, 3630, 4430 and 4460)
  * The access to uart register after MDR1 Access
@@ -400,9 +421,6 @@ static void omap_8250_set_termios(struct uart_port *port,
 	if (termios->c_cflag & CRTSCTS && up->port.flags & UPF_HARD_FLOW) {
 		/* Enable AUTORTS and AUTOCTS */
 		priv->efr |= UART_EFR_CTS | UART_EFR_RTS;
-
-		/* Ensure MCR RTS is asserted */
-		up->mcr |= UART_MCR_RTS;
 	} else	if (up->port.flags & UPF_SOFT_FLOW) {
 		/*
 		 * IXON Flag:
@@ -1007,6 +1025,7 @@ static int omap8250_probe(struct platform_device *pdev)
 	up.capabilities |= UART_CAP_RPM;
 #endif
 	up.port.set_termios = omap_8250_set_termios;
+	up.port.set_mctrl = omap8250_set_mctrl;
 	up.port.pm = omap_8250_pm;
 	up.port.startup = omap_8250_startup;
 	up.port.shutdown = omap_8250_shutdown;
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index e02acf0..245b959 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -126,6 +126,7 @@ extern int serial8250_do_startup(struct uart_port *port);
 extern void serial8250_do_shutdown(struct uart_port *port);
 extern void serial8250_do_pm(struct uart_port *port, unsigned int state,
 			     unsigned int oldstate);
+extern void serial8250_do_set_mctrl(struct uart_port *port, unsigned int mctrl);
 extern int fsl8250_handle_irq(struct uart_port *port);
 int serial8250_handle_irq(struct uart_port *port, unsigned int iir);
 unsigned char serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 057038c..a0c7033 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -123,6 +123,7 @@ struct uart_port {
 	void			(*set_termios)(struct uart_port *,
 				               struct ktermios *new,
 				               struct ktermios *old);
+	void			(*set_mctrl)(struct uart_port *, unsigned int);
 	int			(*startup)(struct uart_port *port);
 	void			(*shutdown)(struct uart_port *port);
 	void			(*throttle)(struct uart_port *port);
-- 
2.2.1

