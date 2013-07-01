Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab3GAULe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:11:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3GAUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liang Li <liang.li@windriver.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [ 8/8] pch_uart: fix a deadlock when pch_uart as console
Date: Mon,  1 Jul 2013 13:10:40 -0700
Message-Id: <20130701200235.066253757@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200232.909858308@linuxfoundation.org>
References: <20130701200232.909858308@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Li <liang.li@windriver.com>

commit 384e301e3519599b000c1a2ecd938b533fc15d85 upstream.

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
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pch_uart.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -935,22 +935,37 @@ static unsigned int dma_handle_tx(struct
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
-
-	if (lsr & UART_LSR_PE)
-		dev_err(&priv->pdev->dev, "Parity Error\n");
-
-	if (lsr & UART_LSR_OE)
-		dev_err(&priv->pdev->dev, "Overrun Error\n");
+	if (lsr & UART_LSR_FE) {
+		port->icount.frame++;
+		error_msg[i++] = "  Framing Error\n";
+	}
+
+	if (lsr & UART_LSR_PE) {
+		port->icount.parity++;
+		error_msg[i++] = "  Parity Error\n";
+	}
+
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


