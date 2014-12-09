Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaLIJ0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:26:04 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62433 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaLIJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:46 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 05/15] serial: imx: unmap sg in case of dmaengine_prep_slave_sg() failure
Date: Tue, 9 Dec 2014 18:11:26 +0900
Message-ID: <1418116296-12082-6-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

In case dmaengine_prep_slave_sg() fails, add the missing dma_unmap_sg().

Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Anton Bondarenko <anton_bondarenko@mentor.com>
---
 drivers/tty/serial/imx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index f4b0f6b..a0bfccf 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -558,6 +558,8 @@ static void imx_dma_tx(struct imx_port *sport)
 	desc = dmaengine_prep_slave_sg(chan, sgl, sport->dma_tx_nents,
 					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!desc) {
+		dma_unmap_sg(dev, sgl, sport->dma_tx_nents,
+			     DMA_TO_DEVICE);
 		dev_err(dev, "We cannot prepare for the TX slave dma!\n");
 		return;
 	}
@@ -947,6 +949,7 @@ static int start_rx_dma(struct imx_port *sport)
 	desc = dmaengine_prep_slave_sg(chan, sgl, 1, DMA_DEV_TO_MEM,
 					DMA_PREP_INTERRUPT);
 	if (!desc) {
+		dma_unmap_sg(dev, sgl, 1, DMA_FROM_DEVICE);
 		dev_err(dev, "We cannot prepare for the RX slave dma!\n");
 		return -EINVAL;
 	}
-- 
1.9.3

