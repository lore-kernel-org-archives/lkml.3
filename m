Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3CEOb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:31:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:51558 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3CEOb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:31:27 -0500
From: Liang Li <liang.li@windriver.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>
CC: <jason.wessel@windriver.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial: pch_uart: add console poll support
Date: Tue, 5 Mar 2013 22:30:38 +0800
Message-ID: <1362493838-17456-1-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement console poll for pch_uart, this could enable KGDBoC when
on pch-uart console.

Signed-off-by: Liang Li <liang.li@windriver.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/tty/serial/pch_uart.c | 103 ++++++++++++++++++++++++++++++++----------
 1 file changed, 79 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 7f72e34..34a6192 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1512,29 +1512,6 @@ static int pch_uart_verify_port(struct uart_port *port,
 	return 0;
 }
 
-static struct uart_ops pch_uart_ops = {
-	.tx_empty = pch_uart_tx_empty,
-	.set_mctrl = pch_uart_set_mctrl,
-	.get_mctrl = pch_uart_get_mctrl,
-	.stop_tx = pch_uart_stop_tx,
-	.start_tx = pch_uart_start_tx,
-	.stop_rx = pch_uart_stop_rx,
-	.enable_ms = pch_uart_enable_ms,
-	.break_ctl = pch_uart_break_ctl,
-	.startup = pch_uart_startup,
-	.shutdown = pch_uart_shutdown,
-	.set_termios = pch_uart_set_termios,
-/*	.pm		= pch_uart_pm,		Not supported yet */
-/*	.set_wake	= pch_uart_set_wake,	Not supported yet */
-	.type = pch_uart_type,
-	.release_port = pch_uart_release_port,
-	.request_port = pch_uart_request_port,
-	.config_port = pch_uart_config_port,
-	.verify_port = pch_uart_verify_port
-};
-
-#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
-
 /*
  *	Wait for transmitter & holding register to empty
  */
@@ -1566,6 +1543,84 @@ static void wait_for_xmitr(struct eg20t_port *up, int bits)
 	}
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for communicate via uart while
+ * in an interrupt or debug context.
+ */
+static int pch_uart_get_poll_char(struct uart_port *port)
+{
+	struct eg20t_port *priv =
+		container_of(port, struct eg20t_port, port);
+	u8 lsr = ioread8(priv->membase + UART_LSR);
+
+	if (!(lsr & UART_LSR_DR))
+		return NO_POLL_CHAR;
+
+	return ioread8(priv->membase + PCH_UART_RBR);
+}
+
+
+static void pch_uart_put_poll_char(struct uart_port *port,
+			 unsigned char c)
+{
+	unsigned int ier;
+	struct eg20t_port *priv =
+		container_of(port, struct eg20t_port, port);
+
+	/*
+	 * First save the IER then disable the interrupts
+	 */
+	ier = ioread8(priv->membase + UART_IER);
+	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_ALL_INT);
+
+	wait_for_xmitr(priv, UART_LSR_THRE);
+	/*
+	 * Send the character out.
+	 * If a LF, also do CR...
+	 */
+	iowrite8(c, priv->membase + PCH_UART_THR);
+	if (c == 10) {
+		wait_for_xmitr(priv, UART_LSR_THRE);
+		iowrite8(13, priv->membase + PCH_UART_THR);
+	}
+
+	/*
+	 * Finally, wait for transmitter to become empty
+	 * and restore the IER
+	 */
+	wait_for_xmitr(priv, BOTH_EMPTY);
+	iowrite8(ier, priv->membase + UART_IER);
+}
+#endif /* CONFIG_CONSOLE_POLL */
+
+static struct uart_ops pch_uart_ops = {
+	.tx_empty = pch_uart_tx_empty,
+	.set_mctrl = pch_uart_set_mctrl,
+	.get_mctrl = pch_uart_get_mctrl,
+	.stop_tx = pch_uart_stop_tx,
+	.start_tx = pch_uart_start_tx,
+	.stop_rx = pch_uart_stop_rx,
+	.enable_ms = pch_uart_enable_ms,
+	.break_ctl = pch_uart_break_ctl,
+	.startup = pch_uart_startup,
+	.shutdown = pch_uart_shutdown,
+	.set_termios = pch_uart_set_termios,
+/*	.pm		= pch_uart_pm,		Not supported yet */
+/*	.set_wake	= pch_uart_set_wake,	Not supported yet */
+	.type = pch_uart_type,
+	.release_port = pch_uart_release_port,
+	.request_port = pch_uart_request_port,
+	.config_port = pch_uart_config_port,
+	.verify_port = pch_uart_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = pch_uart_get_poll_char,
+	.poll_put_char = pch_uart_put_poll_char,
+#endif
+};
+
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+
 static void pch_console_putchar(struct uart_port *port, int ch)
 {
 	struct eg20t_port *priv =
@@ -1674,7 +1729,7 @@ static struct console pch_console = {
 #define PCH_CONSOLE	(&pch_console)
 #else
 #define PCH_CONSOLE	NULL
-#endif
+#endif	/* CONFIG_SERIAL_PCH_UART_CONSOLE */
 
 static struct uart_driver pch_uart_driver = {
 	.owner = THIS_MODULE,
-- 
1.7.11.4

