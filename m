Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaLIJMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:12:06 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62495 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaLIJMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:12:02 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 15/15] serial: imx: Support sw flow control in DMA mode
Date: Tue, 9 Dec 2014 18:11:36 +0900
Message-ID: <1418116296-12082-16-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Software flow control support in DMA mode.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/tty/serial/imx.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 301cf8c..642e88e 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -464,9 +464,11 @@ static void imx_enable_ms(struct uart_port *port)
 	mod_timer(&sport->timer, jiffies);
 }
 
+static void imx_dma_tx(struct imx_port *sport);
 static inline void imx_transmit_buffer(struct imx_port *sport)
 {
 	struct circ_buf *xmit = &sport->port.state->xmit;
+	unsigned long temp;
 
 	if (sport->port.x_char) {
 		/* Send next char */
@@ -481,6 +483,22 @@ static inline void imx_transmit_buffer(struct imx_port *sport)
 		return;
 	}
 
+	if (sport->dma_is_enabled) {
+		/*
+		 * We've just sent a X-char Ensure the TX DMA is enabled
+		 * and the TX IRQ is disabled.
+		 **/
+		temp = readl(sport->port.membase + UCR1);
+		temp &= ~UCR1_TXMPTYEN;
+		if (sport->dma_is_txing) {
+			temp |= UCR1_TDMAEN;
+			writel(temp, sport->port.membase + UCR1);
+		} else {
+			writel(temp, sport->port.membase + UCR1);
+			imx_dma_tx(sport);
+		}
+	}
+
 	while (!uart_circ_empty(xmit) &&
 	       !(readl(sport->port.membase + uts_reg(sport)) & UTS_TXFULL)) {
 		/* send xmit->buf[xmit->tail]
@@ -497,7 +515,6 @@ static inline void imx_transmit_buffer(struct imx_port *sport)
 		imx_stop_tx(&sport->port);
 }
 
-static void imx_dma_tx(struct imx_port *sport);
 static void dma_tx_callback(void *data)
 {
 	struct imx_port *sport = data;
@@ -630,7 +647,16 @@ static void imx_start_tx(struct uart_port *port)
 	}
 
 	if (sport->dma_is_enabled) {
-		/* FIXME: port->x_char must be transmitted if != 0 */
+		if (sport->port.x_char) {
+			/* We have X-char to send, so enable TX IRQ and
+			 * disable TX DMA to let TX interrupt to send X-char */
+			temp = readl(sport->port.membase + UCR1);
+			temp &= ~UCR1_TDMAEN;
+			temp |= UCR1_TXMPTYEN;
+			writel(temp, sport->port.membase + UCR1);
+			return;
+		}
+
 		if (!uart_circ_empty(&port->state->xmit) &&
 		    !uart_tx_stopped(port))
 			imx_dma_tx(sport);
-- 
1.9.3

