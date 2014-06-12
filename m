Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346AbaFLKdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:33:12 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:51844 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbaFLKdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:33:02 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/9] serial/arc: use uart_console_write() helper
Date: Thu, 12 Jun 2014 16:01:31 +0530
Message-ID: <1402569099-9900-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 drivers/tty/serial/arc_uart.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index c9f5c9dcc15c..32fb8b94ff7c 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -478,14 +478,14 @@ static void arc_serial_config_port(struct uart_port *port, int flags)
 
 #if defined(CONFIG_CONSOLE_POLL) || defined(CONFIG_SERIAL_ARC_CONSOLE)
 
-static void arc_serial_poll_putchar(struct uart_port *port, unsigned char chr)
+static void arc_serial_poll_putchar(struct uart_port *port, int chr)
 {
 	struct arc_uart_port *uart = to_arc_port(port);
 
 	while (!(UART_GET_STATUS(uart) & TXEMPTY))
 		cpu_relax();
 
-	UART_SET_DATA(uart, chr);
+	UART_SET_DATA(uart, (unsigned char)chr);
 }
 #endif
 
@@ -622,11 +622,6 @@ static int arc_serial_console_setup(struct console *co, char *options)
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
-static void arc_serial_console_putchar(struct uart_port *port, int ch)
-{
-	arc_serial_poll_putchar(port, (unsigned char)ch);
-}
-
 /*
  * Interrupts are disabled on entering
  */
@@ -637,7 +632,7 @@ static void arc_serial_console_write(struct console *co, const char *s,
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	uart_console_write(port, s, count, arc_serial_console_putchar);
+	uart_console_write(port, s, count, arc_serial_poll_putchar);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -655,13 +650,8 @@ static __init void early_serial_write(struct console *con, const char *s,
 					unsigned int n)
 {
 	struct uart_port *port = &arc_uart_ports[con->index].port;
-	unsigned int i;
 
-	for (i = 0; i < n; i++, s++) {
-		if (*s == '\n')
-			arc_serial_poll_putchar(port, '\r');
-		arc_serial_poll_putchar(port, *s);
-	}
+	uart_console_write(port, s, n, arc_serial_poll_putchar);
 }
 
 static struct console arc_early_serial_console __initdata = {
-- 
1.8.3.2

