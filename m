Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbbAVRZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:25:52 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43093 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbbAVRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:24:59 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH 6/7] serial: 8250: Use canary to restart console after suspend
Date: Thu, 22 Jan 2015 12:24:30 -0500
Message-Id: <1421947471-6396-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
References: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using no_console_suspend, the serial console may be powered off
anyway during system sleep. Upon resume, the port may be in its default
power-on state, but is expected to continue console i/o before the device
has received its pm callback. The resultant garbage i/o can cause all
kinds of havoc on the remote end.

Use the scratch register as a canary to discover if the console
has been powered-off. Write a non-zero value to the scratch register
at port suspend and reprogram the port before any console i/o if the
scratch register != canary before port resume.

This workaround is disabled for omap_8250 (which uses different divisor
programming).

Credit to Doug Anderson <dianders@chromium.org> for the idea of using
the scratch register canary to discover port power-down.

Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 35 ++++++++++++++++++++++++++++++++++-
 include/linux/serial_8250.h         |  3 +++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 5240c1a..8fd4b57 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -3244,6 +3244,27 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 	else
 		serial_port_out(port, UART_IER, 0);
 
+	/* check scratch reg to see if port powered off during system sleep */
+	if (up->canary && (up->canary != serial_port_in(port, UART_SCR))) {
+		struct ktermios termios;
+		unsigned int baud, quot, frac = 0;
+
+		termios.c_cflag = port->cons->cflag;
+		if (port->state->port.tty && termios.c_cflag == 0)
+			termios.c_cflag = port->state->port.tty->termios.c_cflag;
+
+		baud = uart_get_baud_rate(port, &termios, NULL,
+					  port->uartclk / 16 / 0xffff,
+					  port->uartclk / 16);
+		quot = serial8250_get_divisor(up, baud, &frac);
+
+		serial8250_set_divisor(port, baud, quot, frac);
+		serial_port_out(port, UART_LCR, up->lcr);
+		serial_port_out(port, UART_MCR, UART_MCR_DTR | UART_MCR_RTS);
+
+		up->canary = 0;
+	}
+
 	uart_console_write(port, s, count, serial8250_console_putchar);
 
 	/*
@@ -3394,7 +3415,17 @@ int __init early_serial_setup(struct uart_port *port)
  */
 void serial8250_suspend_port(int line)
 {
-	uart_suspend_port(&serial8250_reg, &serial8250_ports[line].port);
+	struct uart_8250_port *up = &serial8250_ports[line];
+	struct uart_port *port = &up->port;
+
+	if (!console_suspend_enabled && uart_console(port) &&
+	    port->type != PORT_8250) {
+		unsigned char canary = 0xa5;
+		serial_out(up, UART_SCR, canary);
+		up->canary = canary;
+	}
+
+	uart_suspend_port(&serial8250_reg, port);
 }
 
 /**
@@ -3408,6 +3439,8 @@ void serial8250_resume_port(int line)
 	struct uart_8250_port *up = &serial8250_ports[line];
 	struct uart_port *port = &up->port;
 
+	up->canary = 0;
+
 	if (up->capabilities & UART_NATSEMI) {
 		/* Ensure it's still in high speed mode */
 		serial_port_out(port, UART_LCR, 0xE0);
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 245b959..a8efa23 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -85,6 +85,9 @@ struct uart_8250_port {
 	unsigned char		mcr_force;	/* mask of forced bits */
 	unsigned char		cur_iotype;	/* Running I/O type */
 	unsigned int		rpm_tx_active;
+	unsigned char		canary;		/* non-zero during system sleep
+						 *   if no_console_suspend
+						 */
 
 	/*
 	 * Some bits in registers are cleared on a read, so they must
-- 
2.2.2

