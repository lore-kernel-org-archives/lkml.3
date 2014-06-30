Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaF3VyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:54:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57871 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbaF3VyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:54:03 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] tty: serial: msm: Support big-endian CPUs
Date: Mon, 30 Jun 2014 14:54:01 -0700
Message-Id: <1404165241-18365-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support big-endian CPUs use the string versions of the io
read/write macros on the TX/RX fifos and the non-raw variants of
the readl/writel macros throughout. This way we don't byteswap
the characters coming from the fifos but we properly deal with
the little-endian nature of the serial hardware while controlling
it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 28 ++++++++++++++++++----------
 drivers/tty/serial/msm_serial.h |  4 ++--
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 72000a6d5af0..abdf73773401 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -125,14 +125,14 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 	port->icount.rx += count;
 
 	while (count > 0) {
-		unsigned int c;
+		unsigned char buf[4];
 
 		sr = msm_read(port, UART_SR);
 		if ((sr & UART_SR_RX_READY) == 0) {
 			msm_port->old_snap_state -= count;
 			break;
 		}
-		c = msm_read(port, UARTDM_RF);
+		ioread32_rep(port->membase + UARTDM_RF, buf, 1);
 		if (sr & UART_SR_RX_BREAK) {
 			port->icount.brk++;
 			if (uart_handle_break(port))
@@ -141,8 +141,7 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 			port->icount.frame++;
 
 		/* TODO: handle sysrq */
-		tty_insert_flip_string(tport, (char *)&c,
-				       (count > 4) ? 4 : count);
+		tty_insert_flip_string(tport, buf, min(count, 4));
 		count -= 4;
 	}
 
@@ -219,6 +218,12 @@ static void handle_tx(struct uart_port *port)
 	struct msm_port *msm_port = UART_TO_MSM(port);
 	unsigned int tx_count, num_chars;
 	unsigned int tf_pointer = 0;
+	void __iomem *tf;
+
+	if (msm_port->is_uartdm)
+		tf = port->membase + UARTDM_TF;
+	else
+		tf = port->membase + UART_TF;
 
 	tx_count = uart_circ_chars_pending(xmit);
 	tx_count = min3(tx_count, (unsigned int)UART_XMIT_SIZE - xmit->tail,
@@ -228,8 +233,7 @@ static void handle_tx(struct uart_port *port)
 		if (msm_port->is_uartdm)
 			reset_dm_count(port, tx_count + 1);
 
-		msm_write(port, port->x_char,
-			  msm_port->is_uartdm ? UARTDM_TF : UART_TF);
+		iowrite8_rep(tf, &port->x_char, 1);
 		port->icount.tx++;
 		port->x_char = 0;
 	} else if (tx_count && msm_port->is_uartdm) {
@@ -239,7 +243,6 @@ static void handle_tx(struct uart_port *port)
 	while (tf_pointer < tx_count) {
 		int i;
 		char buf[4] = { 0 };
-		unsigned int *bf = (unsigned int *)&buf;
 
 		if (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
 			break;
@@ -255,7 +258,7 @@ static void handle_tx(struct uart_port *port)
 			port->icount.tx++;
 		}
 
-		msm_write(port, *bf, msm_port->is_uartdm ? UARTDM_TF : UART_TF);
+		iowrite32_rep(tf, buf, 1);
 		xmit->tail = (xmit->tail + num_chars) & (UART_XMIT_SIZE - 1);
 		tf_pointer += num_chars;
 	}
@@ -861,12 +864,18 @@ static void msm_console_write(struct console *co, const char *s,
 	struct msm_port *msm_port;
 	int num_newlines = 0;
 	bool replaced = false;
+	void __iomem *tf;
 
 	BUG_ON(co->index < 0 || co->index >= UART_NR);
 
 	port = get_port_from_line(co->index);
 	msm_port = UART_TO_MSM(port);
 
+	if (msm_port->is_uartdm)
+		tf = port->membase + UARTDM_TF;
+	else
+		tf = port->membase + UART_TF;
+
 	/* Account for newlines that will get a carriage return added */
 	for (i = 0; i < count; i++)
 		if (s[i] == '\n')
@@ -882,7 +891,6 @@ static void msm_console_write(struct console *co, const char *s,
 		int j;
 		unsigned int num_chars;
 		char buf[4] = { 0 };
-		unsigned int *bf = (unsigned int *)&buf;
 
 		if (msm_port->is_uartdm)
 			num_chars = min(count - i, (unsigned int)sizeof(buf));
@@ -907,7 +915,7 @@ static void msm_console_write(struct console *co, const char *s,
 		while (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
 			cpu_relax();
 
-		msm_write(port, *bf, msm_port->is_uartdm ? UARTDM_TF : UART_TF);
+		iowrite32_rep(tf, buf, 1);
 		i += num_chars;
 	}
 	spin_unlock(&port->lock);
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index d98d45efdf86..73d3abe71e79 100644
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -126,13 +126,13 @@
 static inline
 void msm_write(struct uart_port *port, unsigned int val, unsigned int off)
 {
-	__raw_writel(val, port->membase + off);
+	writel_relaxed(val, port->membase + off);
 }
 
 static inline
 unsigned int msm_read(struct uart_port *port, unsigned int off)
 {
-	return __raw_readl(port->membase + off);
+	return readl_relaxed(port->membase + off);
 }
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

