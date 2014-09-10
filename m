Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIJTal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:30:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:35397 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaIJTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:30:37 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/16] tty: serial: 8250_core: allow to set ->throttle / ->unthrottle callbacks
Date: Wed, 10 Sep 2014 21:29:56 +0200
Message-Id: <1410377411-26656-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP UART provides support for HW assisted flow control. What is
missing is the support to throttle / unthrottle callbacks which are used
by the omap-serial driver at the moment.
This patch adds the callbacks. It should be safe to add them since they
are only invoked from the serial_core (uart_throttle()) if the feature
flags are set.

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 14 ++++++++++++++
 include/linux/serial_core.h         |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index a0c1d64f34c5..68c44d97091b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1319,6 +1319,16 @@ static void serial8250_start_tx(struct uart_port *port)
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
 	struct uart_8250_port *up = up_to_u8250p(port);
@@ -2912,6 +2922,8 @@ static struct uart_ops serial8250_pops = {
 	.get_mctrl	= serial8250_get_mctrl,
 	.stop_tx	= serial8250_stop_tx,
 	.start_tx	= serial8250_start_tx,
+	.throttle	= serial8250_throttle,
+	.unthrottle	= serial8250_unthrottle,
 	.stop_rx	= serial8250_stop_rx,
 	.enable_ms	= serial8250_enable_ms,
 	.break_ctl	= serial8250_break_ctl,
@@ -3462,6 +3474,8 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->capabilities	= up->capabilities;
 		uart->rs485_config	= up->rs485_config;
 		uart->rs485		= up->rs485;
+		uart->port.throttle	= up->port.throttle;
+		uart->port.unthrottle	= up->port.unthrottle;
 
 		/* Take tx_loadsz from fifosize if it wasn't set separately */
 		if (uart->port.fifosize && !uart->tx_loadsz)
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 3bd7d55eebce..80936c68a7d3 100644
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
2.1.0

