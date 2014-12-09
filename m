Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaLIJ0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:26:33 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62428 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIJLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:45 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 04/15] serial: imx: TX DMA: clean up sg initialization
Date: Tue, 9 Dec 2014 18:11:25 +0900
Message-ID: <1418116296-12082-5-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

Inverting the logic of the if statement for the sg initialization
makes the if statement easier and better to read.

No functional change.

Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
---
 drivers/tty/serial/imx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index be05b75..f4b0f6b 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -539,15 +539,15 @@ static void imx_dma_tx(struct imx_port *sport)
 
 	sport->tx_bytes = uart_circ_chars_pending(xmit);
 
-	if (xmit->tail > xmit->head && xmit->head > 0) {
+	if (xmit->tail < xmit->head) {
+		sport->dma_tx_nents = 1;
+		sg_init_one(sgl, xmit->buf + xmit->tail, sport->tx_bytes);
+	} else {
 		sport->dma_tx_nents = 2;
 		sg_init_table(sgl, 2);
 		sg_set_buf(sgl, xmit->buf + xmit->tail,
 				UART_XMIT_SIZE - xmit->tail);
 		sg_set_buf(sgl + 1, xmit->buf, xmit->head);
-	} else {
-		sport->dma_tx_nents = 1;
-		sg_init_one(sgl, xmit->buf + xmit->tail, sport->tx_bytes);
 	}
 
 	ret = dma_map_sg(dev, sgl, sport->dma_tx_nents, DMA_TO_DEVICE);
-- 
1.9.3

