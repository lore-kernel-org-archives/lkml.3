Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3GXShl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:37:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44518 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3GXShg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:37:36 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, linux-serial@vger.kernel.org
Subject: [PATCH 4/4] msm_serial: Send more than 1 character at a time on UARTDM
Date: Wed, 24 Jul 2013 11:37:31 -0700
Message-Id: <1374691051-28544-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.837.g0bde8c0
In-Reply-To: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UARTDM cores have a TX fifo that can accept more than one
character per register write, but the msm_serial driver currently
only supports 1 character mode. Add support for this mode of operation
to speed up the transmit path on DM devices.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 51 ++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index cef8f40..97642ec 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -195,10 +195,10 @@ static void handle_rx(struct uart_port *port)
 	tty_flip_buffer_push(tport);
 }
 
-static void reset_dm_count(struct uart_port *port)
+static void reset_dm_count(struct uart_port *port, int count)
 {
 	wait_for_xmitr(port);
-	msm_write(port, 1, UARTDM_NCF_TX);
+	msm_write(port, count, UARTDM_NCF_TX);
 	msm_read(port, UARTDM_NCF_TX);
 }
 
@@ -206,39 +206,52 @@ static void handle_tx(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->state->xmit;
 	struct msm_port *msm_port = UART_TO_MSM(port);
-	int sent_tx;
+	unsigned int tx_count, num_chars;
+	unsigned int tf_pointer = 0;
+
+	tx_count = uart_circ_chars_pending(xmit);
+	tx_count = min3(tx_count, (unsigned int)UART_XMIT_SIZE - xmit->tail,
+			port->fifosize);
 
 	if (port->x_char) {
 		if (msm_port->is_uartdm)
-			reset_dm_count(port);
+			reset_dm_count(port, tx_count + 1);
 
 		msm_write(port, port->x_char,
 			  msm_port->is_uartdm ? UARTDM_TF : UART_TF);
 		port->icount.tx++;
 		port->x_char = 0;
+	} else if (tx_count && msm_port->is_uartdm) {
+		reset_dm_count(port, tx_count);
 	}
 
-	if (msm_port->is_uartdm)
-		reset_dm_count(port);
+	while (tf_pointer < tx_count) {
+		int i;
+		char buf[4] = { 0 };
+		unsigned int *bf = (unsigned int *)&buf;
 
-	while (msm_read(port, UART_SR) & UART_SR_TX_READY) {
-		if (uart_circ_empty(xmit)) {
-			/* disable tx interrupts */
-			msm_port->imr &= ~UART_IMR_TXLEV;
-			msm_write(port, msm_port->imr, UART_IMR);
+		if (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
 			break;
-		}
-		msm_write(port, xmit->buf[xmit->tail],
-			  msm_port->is_uartdm ? UARTDM_TF : UART_TF);
 
 		if (msm_port->is_uartdm)
-			reset_dm_count(port);
+			num_chars = min(tx_count - tf_pointer, sizeof(buf));
+		else
+			num_chars = 1;
 
-		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
-		port->icount.tx++;
-		sent_tx = 1;
+		for (i = 0; i < num_chars; i++) {
+			buf[i] = xmit->buf[xmit->tail + i];
+			port->icount.tx++;
+		}
+
+		msm_write(port, *bf, msm_port->is_uartdm ? UARTDM_TF : UART_TF);
+		xmit->tail = (xmit->tail + num_chars) & (UART_XMIT_SIZE - 1);
+		tf_pointer += num_chars;
 	}
 
+	/* disable tx interrupts if nothing more to send */
+	if (uart_circ_empty(xmit))
+		msm_stop_tx(port);
+
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 }
@@ -757,7 +770,7 @@ static void msm_console_putchar(struct uart_port *port, int c)
 	struct msm_port *msm_port = UART_TO_MSM(port);
 
 	if (msm_port->is_uartdm)
-		reset_dm_count(port);
+		reset_dm_count(port, 1);
 
 	while (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
 		;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

