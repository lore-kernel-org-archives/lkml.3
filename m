Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3ASJw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:52:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:39741 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3ASJwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:52:23 -0500
From: Liang Li <liang.li@windriver.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <liang.li@windriver.com>, <dvhart@linux.intel.com>,
        <bruce.ashfield@windriver.com>, <tomoya.rohm@gmail.com>,
        <feng.tang@intel.com>, <alan@linux.intel.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] pch_uart: fix a deadlock when pch_uart as console
Date: Sat, 19 Jan 2013 17:52:10 +0800
Message-ID: <1358589131-28187-2-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1358589131-28187-1-git-send-email-liang.li@windriver.com>
References: <1358589131-28187-1-git-send-email-liang.li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we use pch_uart as system console like 'console=ttyPCH0,115200',
then 'send break' to it. We'll encounter the deadlock on a cpu/core,
with interrupts disabled on the core. When we happen to have all irqs
affinity to cpu0 then the deadlock on cpu0 actually deadlock whole
system.

In pch_uart_interrupt, we have spin_lock_irqsave(&priv->lock, flags)
then call pch_uart_err_ir when break is received. Then the call to
dev_err would actually call to pch_console_write then we'll run into
another spin_lock(&priv->lock), with interrupts disabled.

So in the call sequence lead by pch_uart_interrupt, we should be
carefully to call functions that will 'print message to console' only
in case the uart port is not being used as serial console.

Signed-off-by: Liang Li <liang.li@windriver.com>
---
 drivers/tty/serial/pch_uart.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 7d47514..2e99f79 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1034,22 +1034,37 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 static void pch_uart_err_ir(struct eg20t_port *priv, unsigned int lsr)
 {
 	u8 fcr = ioread8(priv->membase + UART_FCR);
+	struct uart_port *port = &priv->port;
+	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	char   *error_msg[5] = {};
+	int    i = 0;
 
 	/* Reset FIFO */
 	fcr |= UART_FCR_CLEAR_RCVR;
 	iowrite8(fcr, priv->membase + UART_FCR);
 
 	if (lsr & PCH_UART_LSR_ERR)
-		dev_err(&priv->pdev->dev, "Error data in FIFO\n");
+		error_msg[i++] = "Error data in FIFO\n";
 
-	if (lsr & UART_LSR_FE)
-		dev_err(&priv->pdev->dev, "Framing Error\n");
+	if (lsr & UART_LSR_FE) {
+		port->icount.frame++;
+		error_msg[i++] = "  Framing Error\n";
+	}
 
-	if (lsr & UART_LSR_PE)
-		dev_err(&priv->pdev->dev, "Parity Error\n");
+	if (lsr & UART_LSR_PE) {
+		port->icount.parity++;
+		error_msg[i++] = "  Parity Error\n";
+	}
 
-	if (lsr & UART_LSR_OE)
-		dev_err(&priv->pdev->dev, "Overrun Error\n");
+	if (lsr & UART_LSR_OE) {
+		port->icount.overrun++;
+		error_msg[i++] = "  Overrun Error\n";
+	}
+
+	if (tty == NULL) {
+		for (i = 0; error_msg[i] != NULL; i++)
+			dev_err(&priv->pdev->dev, error_msg[i]);
+	}
 }
 
 static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
-- 
1.7.11.4

