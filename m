Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaJ2SPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:15:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34175 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaJ2SOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:14:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Frank Rowand <frank.rowand@sonymobile.com>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 2/2] tty: serial: msm: Support sysrq on uartDM devices
Date: Wed, 29 Oct 2014 11:14:38 -0700
Message-Id: <1414606478-13709-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1414606478-13709-1-git-send-email-sboyd@codeaurora.org>
References: <1414606478-13709-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To properly support sysrq on uartDM hardware we need to properly
handle break characters. With the DM hardware the fifo can pack 4
characters at a time, where a break is indicated by an all zero
byte. Unfortunately, we can't differentiate between an all zero
byte for a break and an all zero byte of data, so try and do as
best we can. First unmask the RX break start interrupt and record
the interrupt when it arrives. Then while processing the fifo,
detect the break by searching for an all zero character as long
as we recently received an RX break start interrupt. This should
make sysrq work fairly well.

Cc: Frank Rowand <frank.rowand@sonymobile.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 41 +++++++++++++++++++++++++++++++----------
 drivers/tty/serial/msm_serial.h |  2 ++
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index cedcc36762a2..d44c04976f7a 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -54,6 +54,7 @@ struct msm_port {
 	unsigned int		imr;
 	int			is_uartdm;
 	unsigned int		old_snap_state;
+	bool			break_detected;
 };
 
 static inline void wait_for_xmitr(struct uart_port *port)
@@ -126,23 +127,38 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 
 	while (count > 0) {
 		unsigned char buf[4];
+		int sysrq, r_count, i;
 
 		sr = msm_read(port, UART_SR);
 		if ((sr & UART_SR_RX_READY) == 0) {
 			msm_port->old_snap_state -= count;
 			break;
 		}
+
 		ioread32_rep(port->membase + UARTDM_RF, buf, 1);
-		if (sr & UART_SR_RX_BREAK) {
-			port->icount.brk++;
-			if (uart_handle_break(port))
-				continue;
-		} else if (sr & UART_SR_PAR_FRAME_ERR)
-			port->icount.frame++;
+		r_count = min_t(int, count, sizeof(buf));
+
+		for (i = 0; i < r_count; i++) {
+			char flag = TTY_NORMAL;
 
-		/* TODO: handle sysrq */
-		tty_insert_flip_string(tport, buf, min(count, 4));
-		count -= 4;
+			if (msm_port->break_detected && buf[i] == 0) {
+				port->icount.brk++;
+				flag = TTY_BREAK;
+				msm_port->break_detected = false;
+				if (uart_handle_break(port))
+					continue;
+			}
+
+			if (!(port->read_status_mask & UART_SR_RX_BREAK))
+				flag = TTY_NORMAL;
+
+			spin_unlock(&port->lock);
+			sysrq = uart_handle_sysrq_char(port, buf[i]);
+			spin_lock(&port->lock);
+			if (!sysrq)
+				tty_insert_flip_char(tport, buf[i], flag);
+		}
+		count -= r_count;
 	}
 
 	spin_unlock(&port->lock);
@@ -291,6 +307,11 @@ static irqreturn_t msm_irq(int irq, void *dev_id)
 	misr = msm_read(port, UART_MISR);
 	msm_write(port, 0, UART_IMR); /* disable interrupt */
 
+	if (misr & UART_IMR_RXBREAK_START) {
+		msm_port->break_detected = true;
+		msm_write(port, UART_CR_CMD_RESET_RXBREAK_START, UART_CR);
+	}
+
 	if (misr & (UART_IMR_RXLEV | UART_IMR_RXSTALE)) {
 		if (msm_port->is_uartdm)
 			handle_rx_dm(port, misr);
@@ -496,7 +517,7 @@ static int msm_startup(struct uart_port *port)
 
 	/* turn on RX and CTS interrupts */
 	msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
-			UART_IMR_CURRENT_CTS;
+			UART_IMR_CURRENT_CTS | UART_IMR_RXBREAK_START;
 
 	if (msm_port->is_uartdm) {
 		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index 73d3abe71e79..3e1c7138d8cd 100644
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -65,6 +65,7 @@
 #define UART_CR_TX_ENABLE		(1 << 2)
 #define UART_CR_RX_DISABLE		(1 << 1)
 #define UART_CR_RX_ENABLE		(1 << 0)
+#define UART_CR_CMD_RESET_RXBREAK_START	((1 << 11) | (2 << 4))
 
 #define UART_IMR		0x0014
 #define UART_IMR_TXLEV		(1 << 0)
@@ -72,6 +73,7 @@
 #define UART_IMR_RXLEV		(1 << 4)
 #define UART_IMR_DELTA_CTS	(1 << 5)
 #define UART_IMR_CURRENT_CTS	(1 << 6)
+#define UART_IMR_RXBREAK_START	(1 << 10)
 
 #define UART_IPR_RXSTALE_LAST		0x20
 #define UART_IPR_STALE_LSB		0x1F
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

