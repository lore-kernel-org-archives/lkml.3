Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaHORnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:43:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:57636 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHORm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:42:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/15] tty: serial: 8250_core: allow to overwrite & export serial8250_startup()
Date: Fri, 15 Aug 2014 19:42:29 +0200
Message-Id: <1408124563-31541-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP version of the 8250 can actually use 1:1 serial8250_startup().
However it needs to be extended by a wake up irq which should to be
requested & enabled at ->startup() time and disabled at ->shutdown() time.

v2…v3: properly copy callbacks
v1…v2: add shutdown callback

Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 26 ++++++++++++++++++++++++--
 include/linux/serial_8250.h         |  2 ++
 include/linux/serial_core.h         |  2 ++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index e2ad13a..dde1331 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1929,7 +1929,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 
 #endif /* CONFIG_CONSOLE_POLL */
 
-static int serial8250_startup(struct uart_port *port)
+int serial8250_do_startup(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned long flags;
@@ -2180,8 +2180,17 @@ static int serial8250_startup(struct uart_port *port)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(serial8250_do_startup);
 
-static void serial8250_shutdown(struct uart_port *port)
+static int serial8250_startup(struct uart_port *port)
+{
+	if (port->startup)
+		return port->startup(port);
+	else
+		return serial8250_do_startup(port);
+}
+
+void serial8250_do_shutdown(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned long flags;
@@ -2231,6 +2240,15 @@ static void serial8250_shutdown(struct uart_port *port)
 	if (port->irq)
 		serial_unlink_irq_chain(up);
 }
+EXPORT_SYMBOL_GPL(serial8250_do_shutdown);
+
+static void serial8250_shutdown(struct uart_port *port)
+{
+	if (port->shutdown)
+		port->shutdown(port);
+	else
+		serial8250_do_shutdown(port);
+}
 
 static unsigned int serial8250_get_divisor(struct uart_port *port, unsigned int baud)
 {
@@ -3428,6 +3446,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		/*  Possibly override set_termios call */
 		if (up->port.set_termios)
 			uart->port.set_termios = up->port.set_termios;
+		if (up->port.startup)
+			uart->port.startup = up->port.startup;
+		if (up->port.shutdown)
+			uart->port.shutdown = up->port.shutdown;
 		if (up->port.pm)
 			uart->port.pm = up->port.pm;
 		if (up->port.handle_break)
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index f93649e..c3aa004 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -121,6 +121,8 @@ extern void serial8250_early_out(struct uart_port *port, int offset, int value);
 extern int setup_early_serial8250_console(char *cmdline);
 extern void serial8250_do_set_termios(struct uart_port *port,
 		struct ktermios *termios, struct ktermios *old);
+extern int serial8250_do_startup(struct uart_port *port);
+extern void serial8250_do_shutdown(struct uart_port *port);
 extern void serial8250_do_pm(struct uart_port *port, unsigned int state,
 			     unsigned int oldstate);
 extern int fsl8250_handle_irq(struct uart_port *port);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index cf3a1e7..f3ea531 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -122,6 +122,8 @@ struct uart_port {
 	void			(*set_termios)(struct uart_port *,
 				               struct ktermios *new,
 				               struct ktermios *old);
+	int			(*startup)(struct uart_port *port);
+	void			(*shutdown)(struct uart_port *port);
 	int			(*handle_irq)(struct uart_port *);
 	void			(*pm)(struct uart_port *, unsigned int state,
 				      unsigned int old);
-- 
2.0.1

