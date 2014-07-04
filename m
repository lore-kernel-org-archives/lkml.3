Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbaGDQeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:34:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:35606 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaGDQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:34:29 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 2/4] tty: serial: 8250 core: allow to overwrite & export serial8250_startup()
Date: Fri,  4 Jul 2014 18:34:09 +0200
Message-Id: <1404491651-1388-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP version of the 8250 can actually use 1:1 serial8250_startup().
However it needs to be extended by a wakeup irq which should to be
requested & enabled at ->startup() time.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 11 ++++++++++-
 include/linux/serial_8250.h         |  1 +
 include/linux/serial_core.h         |  1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 0c90160..f731fff 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1939,7 +1939,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 
 #endif /* CONFIG_CONSOLE_POLL */
 
-static int serial8250_startup(struct uart_port *port)
+int serial8250_do_startup(struct uart_port *port)
 {
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
@@ -2191,6 +2191,15 @@ static int serial8250_startup(struct uart_port *port)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(serial8250_do_startup);
+
+static int serial8250_startup(struct uart_port *port)
+{
+	if (port->startup)
+		return port->startup(port);
+	else
+		return serial8250_do_startup(port);
+}
 
 static void serial8250_shutdown(struct uart_port *port)
 {
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index af47a8a..9afed1e 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -114,6 +114,7 @@ extern void serial8250_early_out(struct uart_port *port, int offset, int value);
 extern int setup_early_serial8250_console(char *cmdline);
 extern void serial8250_do_set_termios(struct uart_port *port,
 		struct ktermios *termios, struct ktermios *old);
+extern int serial8250_do_startup(struct uart_port *port);
 extern void serial8250_do_pm(struct uart_port *port, unsigned int state,
 			     unsigned int oldstate);
 extern int fsl8250_handle_irq(struct uart_port *port);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 5bbb809..77acd73 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -122,6 +122,7 @@ struct uart_port {
 	void			(*set_termios)(struct uart_port *,
 				               struct ktermios *new,
 				               struct ktermios *old);
+	int			(*startup)(struct uart_port *port);
 	int			(*handle_irq)(struct uart_port *);
 	void			(*pm)(struct uart_port *, unsigned int state,
 				      unsigned int old);
-- 
2.0.0

