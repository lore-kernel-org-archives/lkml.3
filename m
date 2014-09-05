Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaIETDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:03:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:33611 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaIETDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:03:10 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/18] tty: serial: 8250_core: provide a function to export uart_8250_port
Date: Fri,  5 Sep 2014 21:02:36 +0200
Message-Id: <1409943773-7874-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way to access a struct uart_8250_port for a specific
line. This is only required outside of the 8250/uart callbacks like for
devices' suspend & remove callbacks. For those the 8250-core provides a
wrapper like serial8250_unregister_port() which passes the struct
to the proper function based on the line argument.

For run time suspend I need access to this struct not only to make
serial_out() work but also to properly restore up->ier and up->mcr.

Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h      |  2 ++
 drivers/tty/serial/8250/8250_core.c | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 1b08c918cd51..85bfec58d77c 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -112,6 +112,8 @@ static inline void serial_dl_write(struct uart_8250_port *up, int value)
 	up->dl_write(up, value);
 }
 
+struct uart_8250_port *serial8250_get_port(int line);
+
 #if defined(__alpha__) && !defined(CONFIG_PCI)
 /*
  * Digital did something really horribly wrong with the OUT1 and OUT2
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 1d42dba6121d..e2ad13a9aea4 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2880,6 +2880,24 @@ static struct uart_ops serial8250_pops = {
 
 static struct uart_8250_port serial8250_ports[UART_NR];
 
+/**
+ * serial8250_get_port - retrieve struct uart_8250_port
+ * @line: serial line number
+ *
+ * This function retrieves struct uart_8250_port for the specific line.
+ * This struct *must* *not* be used to perform a 8250 or serial core operation
+ * which is not accessible otherwise. Its only purpose is to make the struct
+ * accessible to the runtime-pm callbacks for context suspend/restore.
+ * The lock assumption made here is none because runtime-pm suspend/resume
+ * callbacks should not be invoked if there is any operation performed on the
+ * port.
+ */
+struct uart_8250_port *serial8250_get_port(int line)
+{
+	return &serial8250_ports[line];
+}
+EXPORT_SYMBOL_GPL(serial8250_get_port);
+
 static void (*serial8250_isa_config)(int port, struct uart_port *up,
 	unsigned short *capabilities);
 
-- 
2.1.0

