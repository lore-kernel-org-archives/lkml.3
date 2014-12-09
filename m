Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaLIJL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:11:59 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62467 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaLIJLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:54 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 10/15] serial: imx: disable TDMAEN in imx_flush_buffer()
Date: Tue, 9 Dec 2014 18:11:31 +0900
Message-ID: <1418116296-12082-11-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

Terminating the DMA, make sure the interrupt is disabled, too.
This fixes random kernel Oops due to dma_tx_call() called for
invalid transmissions.

If we disable the TDMAEN, make sure it's enabled again if a TX
DMA is started.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
---
 drivers/tty/serial/imx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index c9e6891..d501628 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -502,11 +502,16 @@ static void dma_tx_callback(void *data)
 	struct scatterlist *sgl = &sport->tx_sgl[0];
 	struct circ_buf *xmit = &sport->port.state->xmit;
 	unsigned long flags;
+	unsigned long temp;
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	dma_unmap_sg(sport->port.dev, sgl, sport->dma_tx_nents, DMA_TO_DEVICE);
 
+	temp = readl(sport->port.membase + UCR1);
+	temp &= ~UCR1_TDMAEN;
+	writel(temp, sport->port.membase + UCR1);
+
 	/* update the stat */
 	xmit->tail = (xmit->tail + sport->tx_bytes) & (UART_XMIT_SIZE - 1);
 	sport->port.icount.tx += sport->tx_bytes;
@@ -539,6 +544,7 @@ static void imx_dma_tx(struct imx_port *sport)
 	struct dma_async_tx_descriptor *desc;
 	struct dma_chan	*chan = sport->dma_chan_tx;
 	struct device *dev = sport->port.dev;
+	unsigned long temp;
 	int ret;
 
 	if (sport->dma_is_txing)
@@ -575,6 +581,11 @@ static void imx_dma_tx(struct imx_port *sport)
 
 	dev_dbg(dev, "TX: prepare to send %lu bytes by DMA.\n",
 			uart_circ_chars_pending(xmit));
+
+	temp = readl(sport->port.membase + UCR1);
+	temp |= UCR1_TDMAEN;
+	writel(temp, sport->port.membase + UCR1);
+
 	/* fire it */
 	sport->dma_is_txing = 1;
 	dmaengine_submit(desc);
@@ -1310,6 +1321,7 @@ static void imx_flush_buffer(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	struct scatterlist *sgl = &sport->tx_sgl[0];
+	unsigned long temp;
 
 	if (!sport->dma_chan_tx)
 		return;
@@ -1319,6 +1331,9 @@ static void imx_flush_buffer(struct uart_port *port)
 	if (sport->dma_is_txing) {
 		dma_unmap_sg(sport->port.dev, sgl, sport->dma_tx_nents,
 			     DMA_TO_DEVICE);
+		temp = readl(sport->port.membase + UCR1);
+		temp &= ~UCR1_TDMAEN;
+		writel(temp, sport->port.membase + UCR1);
 		sport->dma_is_txing = false;
 	}
 }
-- 
1.9.3

