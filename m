Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3F1DLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:11:55 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:10003 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3F1DLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:11:53 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Liang Li <liang.li@windriver.com>,
        Yijing Wang <wangyijing@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH 3.4 stable][PATCH] pch_uart: fix a deadlock when pch_uart as console
Date: Fri, 28 Jun 2013 11:10:39 +0800
Message-ID: <1372389039-29524-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liang Li <liang.li@windriver.com>

commit 384e301e3519599b000c1a2ecd938b533fc15d85 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: stable@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 8b40a1f..10e1a95 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1024,22 +1024,37 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
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
+
+	if (lsr & UART_LSR_FE) {
+		port->icount.frame++;
+		error_msg[i++] = "  Framing Error\n";
+	}
 
-	if (lsr & UART_LSR_FE)
-		dev_err(&priv->pdev->dev, "Framing Error\n");
+	if (lsr & UART_LSR_PE) {
+		port->icount.parity++;
+		error_msg[i++] = "  Parity Error\n";
+	}
 
-	if (lsr & UART_LSR_PE)
-		dev_err(&priv->pdev->dev, "Parity Error\n");
+	if (lsr & UART_LSR_OE) {
+		port->icount.overrun++;
+		error_msg[i++] = "  Overrun Error\n";
+	}
 
-	if (lsr & UART_LSR_OE)
-		dev_err(&priv->pdev->dev, "Overrun Error\n");
+	if (tty == NULL) {
+		for (i = 0; error_msg[i] != NULL; i++)
+			dev_err(&priv->pdev->dev, error_msg[i]);
+	}
 }
 
 static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
-- 
1.7.1


