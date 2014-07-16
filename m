Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200AbaGPOqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:46:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:56999 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934116AbaGPOpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:45:16 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/5] tty: serial: 8250 core: allow to set ->throttle / ->unthrottle callbacks
Date: Wed, 16 Jul 2014 16:45:01 +0200
Message-Id: <1405521903-5877-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap uart provides support for HW assisted flow control. What is
missing is the support to throttle / unthrottle callbacks which are used
by the omap-serial driver at the moment.
This patch adds the callbacks. It should be safe to add them since they
are only invovked from the serial_core (uart_throttle()) if the feature
flags are set.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 14 ++++++++++++++
 include/linux/serial_core.h         |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index bd0e1897..714f954 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1320,6 +1320,16 @@ static void serial8250_start_tx(struct uart_port *port)
 	}
 }
 
+static void serial8250_throttle(struct uart_port *port)
+{
+	port->throttle(port);
+}
+
+static void serial8250_unthrottle(struct uart_port *port)
+{
+	port->unthrottle(port);
+}
+
 static void serial8250_stop_rx(struct uart_port *port)
 {
 	struct uart_8250_port *up =
@@ -2752,6 +2762,8 @@ static struct uart_ops serial8250_pops = {
 	.get_mctrl	= serial8250_get_mctrl,
 	.stop_tx	= serial8250_stop_tx,
 	.start_tx	= serial8250_start_tx,
+	.throttle	= serial8250_throttle,
+	.unthrottle	= serial8250_unthrottle,
 	.stop_rx	= serial8250_stop_rx,
 	.enable_ms	= serial8250_enable_ms,
 	.break_ctl	= serial8250_break_ctl,
@@ -3300,6 +3312,8 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->port.fifosize	= up->port.fifosize;
 		uart->tx_loadsz		= up->tx_loadsz;
 		uart->capabilities	= up->capabilities;
+		uart->port.throttle	= up->port.throttle;
+		uart->port.unthrottle	= up->port.unthrottle;
 
 		/* Take tx_loadsz from fifosize if it wasn't set separately */
 		if (uart->port.fifosize && !uart->tx_loadsz)
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 6f20ff0..c380af2 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -124,6 +124,8 @@ struct uart_port {
 				               struct ktermios *old);
 	int			(*startup)(struct uart_port *port);
 	void			(*shutdown)(struct uart_port *port);
+	void			(*throttle)(struct uart_port *port);
+	void			(*unthrottle)(struct uart_port *port);
 	int			(*handle_irq)(struct uart_port *);
 	void			(*pm)(struct uart_port *, unsigned int state,
 				      unsigned int old);
-- 
2.0.1

