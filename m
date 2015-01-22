Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbbAVR0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:26:12 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42958 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbbAVRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:24:58 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Aaron Sierra <asierra@xes-inc.com>
Subject: [PATCH 5/7] serial: 8250: Refactor XR17V35X divisor calculation
Date: Thu, 22 Jan 2015 12:24:29 -0500
Message-Id: <1421947471-6396-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
References: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exar XR17V35X PCIe uarts support a 4-bit fractional divisor register.
Refactor the divisor calculation from the divisor programming.

Allow a fractional result from serial8250_get_divisor() and pass this
result to serial8250_dl_write().

Simplify the calculation for quot and quot_frac. This was verified
to be identical to the results of the original calculation with a test
jig.

NB: The results were also compared with the divisor value chart
on pg 33 of the Exar XR17V352 datasheet, rev 1.0.3, here:
http://www.exar.com/common/content/document.ashx?id=1585
which differs from the calculated values by 1 in the fractional result.
This is because the calculated values are still rounded in the
fractional result, whereas the table values are truncated. Note
that the data error rate % values in the datasheet are for
rounded fractional results, as the truncated fractional results
have more error.

Cc: Joe Schultz <jschultz@xes-inc.com>
Cc: Aaron Sierra <asierra@xes-inc.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 52 +++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index b8aa6ef..5240c1a 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2390,7 +2390,26 @@ static void serial8250_shutdown(struct uart_port *port)
 		serial8250_do_shutdown(port);
 }
 
-static unsigned int serial8250_get_divisor(struct uart_8250_port *up, unsigned int baud)
+/*
+ * XR17V35x UARTs have an extra fractional divisor register (DLD)
+ * Calculate divisor with extra 4-bit fractional portion
+ */
+static unsigned int xr17v35x_get_divisor(struct uart_8250_port *up,
+					 unsigned int baud,
+					 unsigned int *frac)
+{
+	struct uart_port *port = &up->port;
+	unsigned int quot_16;
+
+	quot_16 = DIV_ROUND_CLOSEST(port->uartclk, baud);
+	*frac = quot_16 & 0x0f;
+
+	return quot_16 >> 4;
+}
+
+static unsigned int serial8250_get_divisor(struct uart_8250_port *up,
+					   unsigned int baud,
+					   unsigned int *frac)
 {
 	struct uart_port *port = &up->port;
 	unsigned int quot;
@@ -2398,6 +2417,7 @@ static unsigned int serial8250_get_divisor(struct uart_8250_port *up, unsigned i
 	/*
 	 * Handle magic divisors for baud rates above baud_base on
 	 * SMSC SuperIO chips.
+	 *
 	 */
 	if ((port->flags & UPF_MAGIC_MULTIPLIER) &&
 	    baud == (port->uartclk/4))
@@ -2405,6 +2425,8 @@ static unsigned int serial8250_get_divisor(struct uart_8250_port *up, unsigned i
 	else if ((port->flags & UPF_MAGIC_MULTIPLIER) &&
 		 baud == (port->uartclk/8))
 		quot = 0x8002;
+	else if (up->port.type == PORT_XR17V35X)
+		quot = xr17v35x_get_divisor(up, baud, frac);
 	else
 		quot = uart_get_divisor(port, baud);
 
@@ -2456,7 +2478,7 @@ static unsigned char serial8250_compute_lcr(struct uart_8250_port *up,
 }
 
 void serial8250_set_divisor(struct uart_port *port, unsigned int baud,
-			    unsigned int quot)
+			    unsigned int quot, unsigned int quot_frac)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 
@@ -2480,23 +2502,9 @@ void serial8250_set_divisor(struct uart_port *port, unsigned int baud,
 
 	serial_dl_write(up, quot);
 
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
+	/* XR17V35x UARTs have an extra fractional divisor register (DLD) */
+	if (up->port.type == PORT_XR17V35X)
+		serial_port_out(port, 0x2, quot_frac);
 }
 
 void
@@ -2506,7 +2514,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned char cval;
 	unsigned long flags;
-	unsigned int baud, quot;
+	unsigned int baud, quot, frac = 0;
 
 	cval = serial8250_compute_lcr(up, termios->c_cflag);
 
@@ -2516,7 +2524,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	baud = uart_get_baud_rate(port, termios, old,
 				  port->uartclk / 16 / 0xffff,
 				  port->uartclk / 16);
-	quot = serial8250_get_divisor(up, baud);
+	quot = serial8250_get_divisor(up, baud, &frac);
 
 	if (up->capabilities & UART_CAP_FIFO && port->fifosize > 1) {
 		/* NOTE: If fifo_bug is not set, a user can set RX_trigger. */
@@ -2613,7 +2621,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 			serial_port_out(port, UART_EFR, efr);
 	}
 
-	serial8250_set_divisor(port, baud, quot);
+	serial8250_set_divisor(port, baud, quot, frac);
 
 	/*
 	 * LCR DLAB must be set to enable 64-byte FIFO mode. If the FCR
-- 
2.2.2

