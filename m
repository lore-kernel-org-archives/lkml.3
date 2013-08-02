Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3HAQtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:49:17 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:59417 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3HAQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:49:15 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-serial@vger.kernel.org>
CC: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] serial/arc-uart: Handle Rx Error Interrupts w/o any data
Date: Thu, 1 Aug 2013 21:49:19 -0700
Message-ID: <1375418960-21491-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.9.21.33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, Rx error handling only triggers if there is some Rx data.
Fix that by checking for error - before the data handling.

Reported-by: Mischa Jonker <mjonker@synopsys.com>
Tested-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/tty/serial/arc_uart.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 22f280a..10f981b 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -209,9 +209,9 @@ static void arc_serial_start_tx(struct uart_port *port)
 	arc_serial_tx_chars(uart);
 }
 
-static void arc_serial_rx_chars(struct arc_uart_port *uart)
+static void arc_serial_rx_chars(struct arc_uart_port *uart, unsigned int status)
 {
-	unsigned int status, ch, flg = 0;
+	unsigned int ch, flg = 0;
 
 	/*
 	 * UART has 4 deep RX-FIFO. Driver's recongnition of this fact
@@ -222,11 +222,11 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart)
 	 * before RX-EMPTY=0, implies some sort of buffering going on in the
 	 * controller, which is indeed the Rx-FIFO.
 	 */
-	while (!((status = UART_GET_STATUS(uart)) & RXEMPTY)) {
-
-		ch = UART_GET_DATA(uart);
-		uart->port.icount.rx++;
-
+	do {
+		/*
+		 * This could be an Rx Intr for err (no data),
+		 * so check err and clear that Intr first
+		 */
 		if (unlikely(status & (RXOERR | RXFERR))) {
 			if (status & RXOERR) {
 				uart->port.icount.overrun++;
@@ -242,6 +242,12 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart)
 		} else
 			flg = TTY_NORMAL;
 
+		if (status & RXEMPTY)
+			continue;
+
+		ch = UART_GET_DATA(uart);
+		uart->port.icount.rx++;
+
 		if (unlikely(uart_handle_sysrq_char(&uart->port, ch)))
 			goto done;
 
@@ -249,7 +255,7 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart)
 
 done:
 		tty_flip_buffer_push(&uart->port.state->port);
-	}
+	} while (!((status = UART_GET_STATUS(uart)) & RXEMPTY));
 }
 
 /*
@@ -292,11 +298,11 @@ static irqreturn_t arc_serial_isr(int irq, void *dev_id)
 	 * notifications from the UART Controller.
 	 * To demultiplex between the two, we check the relevant bits
 	 */
-	if ((status & RXIENB) && !(status & RXEMPTY)) {
+	if (status & RXIENB) {
 
 		/* already in ISR, no need of xx_irqsave */
 		spin_lock(&uart->port.lock);
-		arc_serial_rx_chars(uart);
+		arc_serial_rx_chars(uart, status);
 		spin_unlock(&uart->port.lock);
 	}
 
-- 
1.8.1.2

