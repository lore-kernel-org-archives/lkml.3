Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaHEBEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:04:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59801 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaHEBEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:04:41 -0400
Message-ID: <53E02DA6.1020609@gmail.com>
Date: Mon, 04 Aug 2014 18:04:38 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [test patch 2/4] add poll_post_exception framework
References: <53E02C7C.4090206@gmail.com>
In-Reply-To: <53E02C7C.4090206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

Add framework to allow serial driver to fixup state after operating in
polled mode, before returning to interrupt mode.

Not-signed-off-by-yet: Frank Rowand <frank.rowand@sonymobile.com>

---
 drivers/tty/serial/kgdboc.c      |    3 +++
 drivers/tty/serial/serial_core.c |   15 +++++++++++++++
 include/linux/serial_core.h      |    1 +
 include/linux/tty_driver.h       |    1 +
 4 files changed, 20 insertions(+)

Index: b/drivers/tty/serial/kgdboc.c
===================================================================
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -302,6 +302,9 @@ static void kgdboc_post_exp_handler(void
 		con_debug_leave();
 	}
 	kgdboc_restore_input();
+
+	if (kgdb_tty_driver->ops->poll_post_exception)
+		kgdb_tty_driver->ops->poll_post_exception(kgdb_tty_driver, kgdb_tty_line);
 }
 
 static struct kgdb_io kgdboc_io_ops = {
Index: b/drivers/tty/serial/serial_core.c
===================================================================
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2237,6 +2237,20 @@ static void uart_poll_put_char(struct tt
 	port = state->uart_port;
 	port->ops->poll_put_char(port, ch);
 }
+
+static void uart_poll_post_exception(struct tty_driver *driver, int line)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->uart_port)
+		return;
+
+	port = state->uart_port;
+	if (port->ops->poll_post_exception)
+		port->ops->poll_post_exception(port);
+}
 #endif
 
 static const struct tty_operations uart_ops = {
@@ -2269,6 +2283,7 @@ static const struct tty_operations uart_
 	.poll_init	= uart_poll_init,
 	.poll_get_char	= uart_poll_get_char,
 	.poll_put_char	= uart_poll_put_char,
+	.poll_post_exception = uart_poll_post_exception,
 #endif
 };
 
Index: b/include/linux/tty_driver.h
===================================================================
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -283,6 +283,7 @@ struct tty_operations {
 	int (*poll_init)(struct tty_driver *driver, int line, char *options);
 	int (*poll_get_char)(struct tty_driver *driver, int line);
 	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
+	void (*poll_post_exception)(struct tty_driver *driver, int line);
 #endif
 	const struct file_operations *proc_fops;
 };
Index: b/include/linux/serial_core.h
===================================================================
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -90,6 +90,7 @@ struct uart_ops {
 	int		(*poll_init)(struct uart_port *);
 	void		(*poll_put_char)(struct uart_port *, unsigned char);
 	int		(*poll_get_char)(struct uart_port *);
+	void		(*poll_post_exception)(struct uart_port *);
 #endif
 };
 
