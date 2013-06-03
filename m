Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3FCNi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:38:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3FCNi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:38:26 -0400
Date: Mon, 3 Jun 2013 09:38:26 -0400
From: Kyle McMartin <kyle@infradead.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, karthik.manamcheri@gmail.com,
        torvalds@linuxfoundation.org
Subject: Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work correctly"
Message-ID: <20130603133826.GE8270@merlin.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit cfcec52e9781f08948c6eb98198d65c45be75a70.

This regresses a longstanding behaviour on X86 systems, which end up with
PCI serial ports moving between ttyS4 and ttyS0 when you bisect to opposite
sides of this commit, resulting in the need to constantly modify the console
setting in order to bisect across it.

Please revert, we can work on solving this for ARM platforms in a less
disruptive way.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2755,7 +2755,7 @@ static void __init serial8250_isa_init_ports(void)
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
 
-	for (i = 0; i < UART_NR; i++) {
+	for (i = 0; i < nr_uarts; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 		struct uart_port *port = &up->port;
 
@@ -2916,7 +2916,7 @@ static int __init serial8250_console_setup(struct console *co, char *options)
 	 * if so, search for the first available port that does have
 	 * console support.
 	 */
-	if (co->index >= UART_NR)
+	if (co->index >= nr_uarts)
 		co->index = 0;
 	port = &serial8250_ports[co->index].port;
 	if (!port->iobase && !port->membase)
@@ -2957,7 +2957,7 @@ int serial8250_find_port(struct uart_port *p)
 	int line;
 	struct uart_port *port;
 
-	for (line = 0; line < UART_NR; line++) {
+	for (line = 0; line < nr_uarts; line++) {
 		port = &serial8250_ports[line].port;
 		if (uart_match_port(p, port))
 			return line;
@@ -3110,7 +3110,7 @@ static int serial8250_remove(struct platform_device *dev)
 {
 	int i;
 
-	for (i = 0; i < UART_NR; i++) {
+	for (i = 0; i < nr_uarts; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		if (up->port.dev == &dev->dev)
@@ -3178,7 +3178,7 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 	/*
 	 * First, find a port entry which matches.
 	 */
-	for (i = 0; i < UART_NR; i++)
+	for (i = 0; i < nr_uarts; i++)
 		if (uart_match_port(&serial8250_ports[i].port, port))
 			return &serial8250_ports[i];
 
@@ -3187,7 +3187,7 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 	 * free entry.  We look for one which hasn't been previously
 	 * used (indicated by zero iobase).
 	 */
-	for (i = 0; i < UART_NR; i++)
+	for (i = 0; i < nr_uarts; i++)
 		if (serial8250_ports[i].port.type == PORT_UNKNOWN &&
 		    serial8250_ports[i].port.iobase == 0)
 			return &serial8250_ports[i];
@@ -3196,7 +3196,7 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 	 * That also failed.  Last resort is to find any entry which
 	 * doesn't have a real port associated with it.
 	 */
-	for (i = 0; i < UART_NR; i++)
+	for (i = 0; i < nr_uarts; i++)
 		if (serial8250_ports[i].port.type == PORT_UNKNOWN)
 			return &serial8250_ports[i];
 
