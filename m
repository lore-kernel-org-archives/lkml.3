Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaGIRuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:50:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:43707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaGIRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:50:06 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/6] tty: serial: 8250 core: provide a function to export uart_8250_port
Date: Wed,  9 Jul 2014 19:49:32 +0200
Message-Id: <1404928177-26554-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no access to access a struct uart_8250_port for a specific
line. This is only required outside of the 8250/uart callbacks like for
devices' suspend & remove callbacks. For those the 8250-core provides
wrapper like serial8250_unregister_port() which passes the struct
to the proper function based on the line argument.

For runtime suspend I need access to this struct not only to make
serial_out() work but also to properly restore up->ier and up->mcr.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h      |  2 ++
 drivers/tty/serial/8250/8250_core.c | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 1ebf853..34c3cd1 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -110,6 +110,8 @@ static inline void serial_dl_write(struct uart_8250_port *up, int value)
 	up->dl_write(up, value);
 }
 
+struct uart_8250_port *serial8250_get_port(int line);
+
 #if defined(__alpha__) && !defined(CONFIG_PCI)
 /*
  * Digital did something really horribly wrong with the OUT1 and OUT2
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 7a91c6d..6db2ee2 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2755,6 +2755,23 @@ static struct uart_ops serial8250_pops = {
 
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
+ * callbacks should not be invoked there is any operation performed on the port.
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
2.0.1

