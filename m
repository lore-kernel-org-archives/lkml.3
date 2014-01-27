Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaA0OXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:23:50 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:41827 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaA0OXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:23:48 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <jouko.haapaluoma@wapice.com>
CC: <Sami.Pietikainen@wapice.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <vinod.koul@intel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] dmaengine: at_hdmac: remove the call to issue_pending from tx_status
Date: Mon, 27 Jan 2014 15:23:23 +0100
Message-ID: <5c82568028640530b39e52155f87fdcd51ebbc48.1390832343.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1390832343.git.nicolas.ferre@atmel.com>
References: <cover.1390832343.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Triggering the dmaengine from tx_status call seems awkward.
If data are remaining in the DMA FIFO, the normal operations
should drain them anyway.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index e2c04dc81e2a..b28759b6d1ca 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -268,8 +268,6 @@ static struct at_desc *atc_get_current_descriptors(struct at_dma_chan *atchan,
 static int atc_get_bytes_left(struct dma_chan *chan)
 {
 	struct at_dma_chan      *atchan = to_at_dma_chan(chan);
-	struct at_dma           *atdma = to_at_dma(chan->device);
-	int	chan_id = atchan->chan_common.chan_id;
 	struct at_desc *desc_first = atc_first_active(atchan);
 	struct at_desc *desc_cur;
 	int ret = 0, count = 0;
@@ -311,11 +309,6 @@ static int atc_get_bytes_left(struct dma_chan *chan)
 				<< (desc_first->tx_width);
 		ret = atchan->remain_desc - count;
 	}
-	/*
-	 * Check fifo empty.
-	 */
-	if (!(dma_readl(atdma, CHSR) & AT_DMA_EMPT(chan_id)))
-		atc_issue_pending(chan);
 
 out:
 	return ret;
-- 
1.8.2.2

