Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaGKNCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:02:20 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:43860 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaGKNCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:02:17 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Tobias Klauser <tklauser@distanz.ch>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, nios2-dev@lists.rocketboards.org
Subject: [PATCH] serial: altera: Adopt uart_console_write()
Date: Fri, 11 Jul 2014 14:00:11 +0100
Message-Id: <1405083611-13828-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver does not currently use uart_console_write() and instead
provides is own LF to LFCR conversion in it's console_write() method.
We should use the library function instead.

Cmopile tested only (with ARCH=arm).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: nios2-dev@lists.rocketboards.org
---
 drivers/tty/serial/altera_uart.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 3233766..554e2fa 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -435,7 +435,7 @@ static struct altera_uart altera_uart_ports[CONFIG_SERIAL_ALTERA_UART_MAXPORTS];
 
 #if defined(CONFIG_SERIAL_ALTERA_UART_CONSOLE)
 
-static void altera_uart_console_putc(struct uart_port *port, const char c)
+static void altera_uart_console_putc(struct uart_port *port, int c)
 {
 	while (!(altera_uart_readl(port, ALTERA_UART_STATUS_REG) &
 		 ALTERA_UART_STATUS_TRDY_MSK))
@@ -449,11 +449,7 @@ static void altera_uart_console_write(struct console *co, const char *s,
 {
 	struct uart_port *port = &(altera_uart_ports + co->index)->port;
 
-	for (; count; count--, s++) {
-		altera_uart_console_putc(port, *s);
-		if (*s == '\n')
-			altera_uart_console_putc(port, '\r');
-	}
+	uart_console_write(port, s, count, altera_uart_console_putc);
 }
 
 static int __init altera_uart_console_setup(struct console *co, char *options)
-- 
1.9.3

