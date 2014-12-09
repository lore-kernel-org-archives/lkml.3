Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbaLIJ0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:26:36 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62413 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaLIJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:43 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 02/15] serial: imx: use locking to stop concurrent access of UCR1
Date: Tue, 9 Dec 2014 18:11:23 +0900
Message-ID: <1418116296-12082-3-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several places are accessing the UCR1 register without locking.
This probably will cause a race issue when another thread
is accessing the same register.
Add locking to preventing concurrent access of the UCR1 register.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/tty/serial/imx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 4d3fa53..969bc65 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -731,6 +731,9 @@ static int start_rx_dma(struct imx_port *sport);
 static void imx_dma_rxint(struct imx_port *sport)
 {
 	unsigned long temp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sport->port.lock, flags);
 
 	temp = readl(sport->port.membase + USR2);
 	if ((temp & USR2_RDR) && !sport->dma_is_rxing) {
@@ -744,6 +747,8 @@ static void imx_dma_rxint(struct imx_port *sport)
 		/* tell the DMA to receive the data. */
 		start_rx_dma(sport);
 	}
+
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 static irqreturn_t imx_int(int irq, void *dev_id)
@@ -873,6 +878,9 @@ static int imx_setup_ufcr(struct imx_port *sport, unsigned int mode)
 static void imx_rx_dma_done(struct imx_port *sport)
 {
 	unsigned long temp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sport->port.lock, flags);
 
 	/* Enable this interrupt when the RXFIFO is empty. */
 	temp = readl(sport->port.membase + UCR1);
@@ -884,6 +892,8 @@ static void imx_rx_dma_done(struct imx_port *sport)
 	/* Is the shutdown waiting for us? */
 	if (waitqueue_active(&sport->dma_wait))
 		wake_up(&sport->dma_wait);
+
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*
@@ -1235,9 +1245,11 @@ static void imx_shutdown(struct uart_port *port)
 			dmaengine_terminate_all(sport->dma_chan_tx);
 			dmaengine_terminate_all(sport->dma_chan_rx);
 		}
+		spin_lock_irqsave(&sport->port.lock, flags);
 		imx_stop_tx(port);
 		imx_stop_rx(port);
 		imx_disable_dma(sport);
+		spin_unlock_irqrestore(&sport->port.lock, flags);
 		imx_uart_dma_exit(sport);
 	}
 
-- 
1.9.3

