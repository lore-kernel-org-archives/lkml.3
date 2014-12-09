Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaLIJXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:23:48 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62445 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaLIJLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:49 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 07/15] serial: imx: use dma_is_txing to synchronize dma_tx_callback and imx_dma_tx
Date: Tue, 9 Dec 2014 18:11:28 +0900
Message-ID: <1418116296-12082-8-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

To synchronize between dma_tx_callback() and imx_dma_tx() use the same
variable, dma_is_txing. This prevents any race between these two functions
and ensures that a new DMA can start only after the first has been
finished.

Before the new DMA can be set up, update the circular buffer logic, first.
Therefore, change dma_is_txing after that update, instead of before.

While doing this, in dma_tx_callback() extend the locking to dma_unmap_sg()
and the update of dma_is_txing.

Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
---
 drivers/tty/serial/imx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index e53a058..3db6a5b 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -502,18 +502,20 @@ static void dma_tx_callback(void *data)
 	struct circ_buf *xmit = &sport->port.state->xmit;
 	unsigned long flags;
 
-	dma_unmap_sg(sport->port.dev, sgl, sport->dma_tx_nents, DMA_TO_DEVICE);
+	spin_lock_irqsave(&sport->port.lock, flags);
 
-	sport->dma_is_txing = 0;
+	dma_unmap_sg(sport->port.dev, sgl, sport->dma_tx_nents, DMA_TO_DEVICE);
 
 	/* update the stat */
-	spin_lock_irqsave(&sport->port.lock, flags);
 	xmit->tail = (xmit->tail + sport->tx_bytes) & (UART_XMIT_SIZE - 1);
 	sport->port.icount.tx += sport->tx_bytes;
-	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	dev_dbg(sport->port.dev, "we finish the TX DMA.\n");
 
+	sport->dma_is_txing = 0;
+
+	spin_unlock_irqrestore(&sport->port.lock, flags);
+
 	uart_write_wakeup(&sport->port);
 
 	if (waitqueue_active(&sport->dma_wait)) {
@@ -530,11 +532,9 @@ static void imx_dma_tx(struct imx_port *sport)
 	struct dma_async_tx_descriptor *desc;
 	struct dma_chan	*chan = sport->dma_chan_tx;
 	struct device *dev = sport->port.dev;
-	enum dma_status status;
 	int ret;
 
-	status = dmaengine_tx_status(chan, (dma_cookie_t)0, NULL);
-	if (DMA_IN_PROGRESS == status)
+	if (sport->dma_is_txing)
 		return;
 
 	sport->tx_bytes = uart_circ_chars_pending(xmit);
-- 
1.9.3

