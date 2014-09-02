Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaIBVoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:44:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59343 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754897AbaIBVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:40:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 03/26] serial: imx: Fix x_char handling and tx flow control
Date: Tue,  2 Sep 2014 17:39:12 -0400
Message-Id: <1409693975-1028-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serial core expects the UART driver to transmit x_char
(START/STOP chars) even if tx is stopped and before data already
in the tx ring buffer if possible. Also, sending x_char must
not cause additional data in the tx ring buffer to transmit
if tx is stopped.

Cause x_char to be transmitted before any other data is sent.
Auto-stop tx if the tx ring buffer is empty or tx should be stopped.
Only perform one write wakeup if tx ring buffer space is below
threshold.

x_char handling in DMA mode is still broken; add FIXME.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/imx.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 044e86d..c86f153 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -464,9 +464,19 @@ static inline void imx_transmit_buffer(struct imx_port *sport)
 {
 	struct circ_buf *xmit = &sport->port.state->xmit;
 
+	if (sport->port.x_char) {
+		/* Send next char */
+		writel(sport->port.x_char, sport->port.membase + URTX0);
+		return;
+	}
+
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&sport->port)) {
+		imx_stop_tx(&sport->port);
+		return;
+	}
+
 	while (!uart_circ_empty(xmit) &&
-			!(readl(sport->port.membase + uts_reg(sport))
-				& UTS_TXFULL)) {
+	       !(readl(sport->port.membase + uts_reg(sport)) & UTS_TXFULL)) {
 		/* send xmit->buf[xmit->tail]
 		 * out the port here */
 		writel(xmit->buf[xmit->tail], sport->port.membase + URTX0);
@@ -567,9 +577,6 @@ static void imx_start_tx(struct uart_port *port)
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
-	if (uart_circ_empty(&port->state->xmit))
-		return;
-
 	if (USE_IRDA(sport)) {
 		/* half duplex in IrDA mode; have to disable receive mode */
 		temp = readl(sport->port.membase + UCR4);
@@ -604,7 +611,10 @@ static void imx_start_tx(struct uart_port *port)
 	}
 
 	if (sport->dma_is_enabled) {
-		imx_dma_tx(sport);
+		/* FIXME: port->x_char must be transmitted if != 0 */
+		if (!uart_circ_empty(&port->state->xmit) &&
+		    !uart_tx_stopped(port))
+			imx_dma_tx(sport);
 		return;
 	}
 
@@ -632,27 +642,10 @@ static irqreturn_t imx_rtsint(int irq, void *dev_id)
 static irqreturn_t imx_txint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
-	struct circ_buf *xmit = &sport->port.state->xmit;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sport->port.lock, flags);
-	if (sport->port.x_char) {
-		/* Send next char */
-		writel(sport->port.x_char, sport->port.membase + URTX0);
-		goto out;
-	}
-
-	if (uart_circ_empty(xmit) || uart_tx_stopped(&sport->port)) {
-		imx_stop_tx(&sport->port);
-		goto out;
-	}
-
 	imx_transmit_buffer(sport);
-
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
-		uart_write_wakeup(&sport->port);
-
-out:
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 	return IRQ_HANDLED;
 }
-- 
2.1.0

