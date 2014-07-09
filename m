Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaGIRvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:51:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:43714 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaGIRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:50:09 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/6] tty: serial: 8250-core: reorder serial8250_stop_rx() & serial8250_start_tx()
Date: Wed,  9 Jul 2014 19:49:35 +0200
Message-Id: <1404928177-26554-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the upcomming rs485 support it is required that
serial8250_stop_rx() is called from serial8250_start_tx(). With this
reordering there is no need for a forward declaration of the former
function.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 1a91a89..c7c3bf7 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1306,6 +1306,21 @@ static void serial8250_stop_tx(struct uart_port *port)
 	pm_runtime_put_autosuspend(port->dev);
 }
 
+static void serial8250_stop_rx(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	pm_runtime_get_sync(port->dev);
+
+	up->ier &= ~UART_IER_RLSI;
+	up->port.read_status_mask &= ~UART_LSR_DR;
+	serial_port_out(port, UART_IER, up->ier);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
 static void serial8250_start_tx(struct uart_port *port)
 {
 	struct uart_8250_port *up =
@@ -1339,21 +1354,6 @@ static void serial8250_start_tx(struct uart_port *port)
 	pm_runtime_put_autosuspend(port->dev);
 }
 
-static void serial8250_stop_rx(struct uart_port *port)
-{
-	struct uart_8250_port *up =
-		container_of(port, struct uart_8250_port, port);
-
-	pm_runtime_get_sync(port->dev);
-
-	up->ier &= ~UART_IER_RLSI;
-	up->port.read_status_mask &= ~UART_LSR_DR;
-	serial_port_out(port, UART_IER, up->ier);
-
-	pm_runtime_mark_last_busy(port->dev);
-	pm_runtime_put_autosuspend(port->dev);
-}
-
 static void serial8250_enable_ms(struct uart_port *port)
 {
 	struct uart_8250_port *up =
-- 
2.0.1

