Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885Ab3JQVIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:08:50 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51553 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762847Ab3JQVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:08:48 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Suneel <suneelg@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 05/10] tty: xuartps: support 64 byte FIFO size
Date: Thu, 17 Oct 2013 14:08:08 -0700
Message-Id: <1382044093-29905-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suneel <suneelg@xilinx.com>

Changes to use the 64 byte FIFO depth and fix the issue
by clearing the txempty interrupt in isr status for tx
after filling in data in start_tx function

Signed-off-by: Suneel Garapati <suneelg@xilinx.com>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
I fixed some style issues of the original patch.
---
 drivers/tty/serial/xilinx_uartps.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 62259f37ddda..6e8ec6e9d5a2 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -33,12 +33,22 @@
 #define XUARTPS_MAJOR		0	/* use dynamic node allocation */
 #define XUARTPS_MINOR		0	/* works best with devtmpfs */
 #define XUARTPS_NR_PORTS	2
-#define XUARTPS_FIFO_SIZE	16	/* FIFO size */
+#define XUARTPS_FIFO_SIZE	64	/* FIFO size */
 #define XUARTPS_REGISTER_SPACE	0xFFF
 
 #define xuartps_readl(offset)		ioread32(port->membase + offset)
 #define xuartps_writel(val, offset)	iowrite32(val, port->membase + offset)
 
+/* Rx Trigger level */
+static int rx_trigger_level = 56;
+module_param(rx_trigger_level, uint, S_IRUGO);
+MODULE_PARM_DESC(rx_trigger_level, "Rx trigger level, 1-63 bytes");
+
+/* Rx Timeout */
+static int rx_timeout = 10;
+module_param(rx_timeout, uint, S_IRUGO);
+MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
+
 /********************************Register Map********************************/
 /** UART
  *
@@ -394,7 +404,7 @@ static void xuartps_start_tx(struct uart_port *port)
 		port->state->xmit.tail = (port->state->xmit.tail + 1) &
 					(UART_XMIT_SIZE - 1);
 	}
-
+	xuartps_writel(XUARTPS_IXR_TXEMPTY, XUARTPS_ISR_OFFSET);
 	/* Enable the TX Empty interrupt */
 	xuartps_writel(XUARTPS_IXR_TXEMPTY, XUARTPS_IER_OFFSET);
 
@@ -528,7 +538,7 @@ static void xuartps_set_termios(struct uart_port *port,
 			| (XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN),
 			XUARTPS_CR_OFFSET);
 
-	xuartps_writel(10, XUARTPS_RXTOUT_OFFSET);
+	xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
 
 	port->read_status_mask = XUARTPS_IXR_TXEMPTY | XUARTPS_IXR_RXTRIG |
 			XUARTPS_IXR_OVERRUN | XUARTPS_IXR_TOUT;
@@ -631,11 +641,17 @@ static int xuartps_startup(struct uart_port *port)
 		| XUARTPS_MR_PARITY_NONE | XUARTPS_MR_CHARLEN_8_BIT,
 		 XUARTPS_MR_OFFSET);
 
-	/* Set the RX FIFO Trigger level to 14 assuming FIFO size as 16 */
-	xuartps_writel(14, XUARTPS_RXWM_OFFSET);
+	/*
+	 * Set the RX FIFO Trigger level to use most of the FIFO, but it
+	 * can be tuned with a module parameter
+	 */
+	xuartps_writel(rx_trigger_level, XUARTPS_RXWM_OFFSET);
 
-	/* Receive Timeout register is enabled with value of 10 */
-	xuartps_writel(10, XUARTPS_RXTOUT_OFFSET);
+	/*
+	 * Receive Timeout register is enabled but it
+	 * can be tuned with a module parameter
+	 */
+	xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
 
 	/* Clear out any pending interrupts before enabling them */
 	xuartps_writel(xuartps_readl(XUARTPS_ISR_OFFSET), XUARTPS_ISR_OFFSET);
-- 
1.8.4.1

