Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbbAVR0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:26:36 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:47305 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbbAVRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:24:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/7] serial: 8250: Refactor divisor programming
Date: Thu, 22 Jan 2015 12:24:28 -0500
Message-Id: <1421947471-6396-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
References: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor divisor register programming into a new function,
serial8250_set_divisor; this allows serial console to reinitialize
early after resume from suspend.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 87 ++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 77afa5f..b8aa6ef 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2455,6 +2455,50 @@ static unsigned char serial8250_compute_lcr(struct uart_8250_port *up,
 	return cval;
 }
 
+void serial8250_set_divisor(struct uart_port *port, unsigned int baud,
+			    unsigned int quot)
+{
+	struct uart_8250_port *up = up_to_u8250p(port);
+
+	/* Workaround to enable 115200 baud on OMAP1510 internal ports */
+	if (is_omap1510_8250(up)) {
+		if (baud == 115200) {
+			quot = 1;
+			serial_port_out(port, UART_OMAP_OSC_12M_SEL, 1);
+		} else
+			serial_port_out(port, UART_OMAP_OSC_12M_SEL, 0);
+	}
+
+	/*
+	 * For NatSemi, switch to bank 2 not bank 1, to avoid resetting EXCR2,
+	 * otherwise just set DLAB
+	 */
+	if (up->capabilities & UART_NATSEMI)
+		serial_port_out(port, UART_LCR, 0xe0);
+	else
+		serial_port_out(port, UART_LCR, up->lcr | UART_LCR_DLAB);
+
+	serial_dl_write(up, quot);
+
+	/*
+	 * XR17V35x UARTs have an extra fractional divisor register (DLD)
+	 *
+	 * We need to recalculate all of the registers, because DLM and DLL
+	 * are already rounded to a whole integer.
+	 *
+	 * When recalculating we use a 32x clock instead of a 16x clock to
+	 * allow 1-bit for rounding in the fractional part.
+	 */
+	if (up->port.type == PORT_XR17V35X) {
+		unsigned int baud_x32 = (port->uartclk * 2) / baud;
+		u16 quot = baud_x32 / 32;
+		u8 quot_frac = DIV_ROUND_CLOSEST(baud_x32 % 32, 2);
+
+		serial_dl_write(up, quot);
+		serial_port_out(port, 0x2, quot_frac & 0xf);
+	}
+}
+
 void
 serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 		          struct ktermios *old)
@@ -2503,6 +2547,8 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	serial8250_rpm_get(up);
 	spin_lock_irqsave(&port->lock, flags);
 
+	up->lcr = cval;					/* Save computed LCR */
+
 	/*
 	 * Update the per-port timeout.
 	 */
@@ -2567,43 +2613,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 			serial_port_out(port, UART_EFR, efr);
 	}
 
-	/* Workaround to enable 115200 baud on OMAP1510 internal ports */
-	if (is_omap1510_8250(up)) {
-		if (baud == 115200) {
-			quot = 1;
-			serial_port_out(port, UART_OMAP_OSC_12M_SEL, 1);
-		} else
-			serial_port_out(port, UART_OMAP_OSC_12M_SEL, 0);
-	}
-
-	/*
-	 * For NatSemi, switch to bank 2 not bank 1, to avoid resetting EXCR2,
-	 * otherwise just set DLAB
-	 */
-	if (up->capabilities & UART_NATSEMI)
-		serial_port_out(port, UART_LCR, 0xe0);
-	else
-		serial_port_out(port, UART_LCR, cval | UART_LCR_DLAB);
-
-	serial_dl_write(up, quot);
-
-	/*
-	 * XR17V35x UARTs have an extra fractional divisor register (DLD)
-	 *
-	 * We need to recalculate all of the registers, because DLM and DLL
-	 * are already rounded to a whole integer.
-	 *
-	 * When recalculating we use a 32x clock instead of a 16x clock to
-	 * allow 1-bit for rounding in the fractional part.
-	 */
-	if (up->port.type == PORT_XR17V35X) {
-		unsigned int baud_x32 = (port->uartclk * 2) / baud;
-		u16 quot = baud_x32 / 32;
-		u8 quot_frac = DIV_ROUND_CLOSEST(baud_x32 % 32, 2);
-
-		serial_dl_write(up, quot);
-		serial_port_out(port, 0x2, quot_frac & 0xf);
-	}
+	serial8250_set_divisor(port, baud, quot);
 
 	/*
 	 * LCR DLAB must be set to enable 64-byte FIFO mode. If the FCR
@@ -2612,8 +2622,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (port->type == PORT_16750)
 		serial_port_out(port, UART_FCR, up->fcr);
 
-	serial_port_out(port, UART_LCR, cval);		/* reset DLAB */
-	up->lcr = cval;					/* Save LCR */
+	serial_port_out(port, UART_LCR, up->lcr);	/* reset DLAB */
 	if (port->type != PORT_16750) {
 		/* emulated UARTs (Lucent Venus 167x) need two steps */
 		if (up->fcr & UART_FCR_ENABLE_FIFO)
-- 
2.2.2

