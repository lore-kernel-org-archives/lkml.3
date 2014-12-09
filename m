Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaLIJZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:25:07 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62438 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaLIJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:48 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 06/15] serial: imx: unmap scatter gather list in imx_flush_buffer
Date: Tue, 9 Dec 2014 18:11:27 +0900
Message-ID: <1418116296-12082-7-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

First, reformat the code to exit immediately. This allows us to add
more code in more readable format.

In case the TX DMA was still running, remove and disable it's resources.

Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
---
 drivers/tty/serial/imx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index a0bfccf..e53a058 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1302,10 +1302,17 @@ static void imx_shutdown(struct uart_port *port)
 static void imx_flush_buffer(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
+	struct scatterlist *sgl = &sport->tx_sgl[0];
 
-	if (sport->dma_is_enabled) {
-		sport->tx_bytes = 0;
-		dmaengine_terminate_all(sport->dma_chan_tx);
+	if (!sport->dma_chan_tx)
+		return;
+
+	sport->tx_bytes = 0;
+	dmaengine_terminate_all(sport->dma_chan_tx);
+	if (sport->dma_is_txing) {
+		dma_unmap_sg(sport->port.dev, sgl, sport->dma_tx_nents,
+			     DMA_TO_DEVICE);
+		sport->dma_is_txing = false;
 	}
 }
 
-- 
1.9.3

