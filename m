Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaHHUjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:39:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55296 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaHHUjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:39:04 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peter@hurleysoftware.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RFC PATCH] serial: uart: update to support hw assisted hw flow control
Date: Fri, 8 Aug 2014 16:39:12 -0400
Message-ID: <1407530352-6937-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 06aa82e498c144c7784a6f3d3b55458b272d6146 serial: uart: add
hw flow control support configuration partially support hw assisted
hw flow control but requires implementation of throttle()/unthrottle()
API as well. Also uart_handle_cts_change() is not expected to be
called with hardware flow control enabled. So add WARN_ON_ONCE() to
flag any misbehaving AFE supported 8250 device.

Only limited testing is done on this patch. Need to get initial feedback
on this. Will test and send the final patch based on the feedback and
test result.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 This is a follow up patch to the discussion against the patch
 "serial: uart: add hw flow control support configuration" 
 drivers/tty/serial/8250/8250_core.c |   26 ++++++++++++++++++++++++++
 drivers/tty/serial/serial_core.c    |    6 ++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 27f7ad6..8fcd218 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1841,6 +1841,30 @@ static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	serial_port_out(port, UART_MCR, mcr);
 }
 
+static void serial8250_throttle(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	unsigned long flags;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	up->ier &= ~(UART_IER_RLSI | UART_IER_RDI);
+	serial_out(up, UART_IER, up->ier);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
+static void serial8250_unthrottle(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	unsigned long flags;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	up->ier |= UART_IER_RLSI | UART_IER_RDI;
+	serial_out(up, UART_IER, up->ier);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
 static void serial8250_break_ctl(struct uart_port *port, int break_state)
 {
 	struct uart_8250_port *up =
@@ -2732,6 +2756,8 @@ static struct uart_ops serial8250_pops = {
 	.tx_empty	= serial8250_tx_empty,
 	.set_mctrl	= serial8250_set_mctrl,
 	.get_mctrl	= serial8250_get_mctrl,
+	.throttle	= serial8250_throttle,
+	.unthrottle	= serial8250_unthrottle,
 	.stop_tx	= serial8250_stop_tx,
 	.start_tx	= serial8250_start_tx,
 	.stop_rx	= serial8250_stop_rx,
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index fbf6c5a..f2dc7f7 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2779,9 +2779,11 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
 
 	uport->icount.cts++;
 
+	/* Not expected to be called if h/w flow control is enabled */
+	WARN_ON_ONCE(uport->flags &  UPF_HARD_FLOW);
+
 	/* skip below code if the hw flow control is supported */
-	if (tty_port_cts_enabled(port) &&
-	    !(uport->flags & UPF_HARD_FLOW)) {
+	if (tty_port_cts_enabled(port)) {
 		if (tty->hw_stopped) {
 			if (status) {
 				tty->hw_stopped = 0;
-- 
1.7.9.5

