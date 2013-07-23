Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3GWIYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:24:10 -0400
Received: from smtp-out-088.synserver.de ([212.40.185.88]:1072 "EHLO
	smtp-out-088.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3GWIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:24:07 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3807
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        stable@vger.kernel.org
Subject: [PATCH v2] dma: pl330: Fix cyclic transfers
Date: Tue, 23 Jul 2013 10:24:50 +0200
Message-Id: <1374567890-27593-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate a descriptor for each period of a cyclic transfer, not just the first.
Also since the callback needs to be called for each finished period make sure to
initialize the callback and callback_param fields of each descriptor in a cyclic
transfer.

Cc: stable@vger.kernel.org
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
	* Use is_slave_direction() instead of open-coding it
---
 drivers/dma/pl330.c | 93 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 26 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7c02e83..4ad13eb 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2505,6 +2505,10 @@ static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* Assign cookies to all nodes */
 	while (!list_empty(&last->node)) {
 		desc = list_entry(last->node.next, struct dma_pl330_desc, node);
+		if (pch->cyclic) {
+			desc->txd.callback = last->txd.callback;
+			desc->txd.callback_param = last->txd.callback_param;
+		}
 
 		dma_cookie_assign(&desc->txd);
 
@@ -2688,45 +2692,82 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 		size_t period_len, enum dma_transfer_direction direction,
 		unsigned long flags, void *context)
 {
-	struct dma_pl330_desc *desc;
+	struct dma_pl330_desc *desc = NULL, *first = NULL;
 	struct dma_pl330_chan *pch = to_pchan(chan);
+	struct dma_pl330_dmac *pdmac = pch->dmac;
+	unsigned int i;
 	dma_addr_t dst;
 	dma_addr_t src;
 
-	desc = pl330_get_desc(pch);
-	if (!desc) {
-		dev_err(pch->dmac->pif.dev, "%s:%d Unable to fetch desc\n",
-			__func__, __LINE__);
+	if (len % period_len != 0)
 		return NULL;
-	}
 
-	switch (direction) {
-	case DMA_MEM_TO_DEV:
-		desc->rqcfg.src_inc = 1;
-		desc->rqcfg.dst_inc = 0;
-		desc->req.rqtype = MEMTODEV;
-		src = dma_addr;
-		dst = pch->fifo_addr;
-		break;
-	case DMA_DEV_TO_MEM:
-		desc->rqcfg.src_inc = 0;
-		desc->rqcfg.dst_inc = 1;
-		desc->req.rqtype = DEVTOMEM;
-		src = pch->fifo_addr;
-		dst = dma_addr;
-		break;
-	default:
+	if (!is_slave_direction(direction)) {
 		dev_err(pch->dmac->pif.dev, "%s:%d Invalid dma direction\n",
 		__func__, __LINE__);
 		return NULL;
 	}
 
-	desc->rqcfg.brst_size = pch->burst_sz;
-	desc->rqcfg.brst_len = 1;
+	for (i = 0; i < len / period_len; i++) {
+		desc = pl330_get_desc(pch);
+		if (!desc) {
+			dev_err(pch->dmac->pif.dev, "%s:%d Unable to fetch desc\n",
+				__func__, __LINE__);
 
-	pch->cyclic = true;
+			if (!first)
+				return NULL;
+
+			spin_lock_irqsave(&pdmac->pool_lock, flags);
+
+			while (!list_empty(&first->node)) {
+				desc = list_entry(first->node.next,
+						struct dma_pl330_desc, node);
+				list_move_tail(&desc->node, &pdmac->desc_pool);
+			}
+
+			list_move_tail(&first->node, &pdmac->desc_pool);
 
-	fill_px(&desc->px, dst, src, period_len);
+			spin_unlock_irqrestore(&pdmac->pool_lock, flags);
+
+			return NULL;
+		}
+
+		switch (direction) {
+		case DMA_MEM_TO_DEV:
+			desc->rqcfg.src_inc = 1;
+			desc->rqcfg.dst_inc = 0;
+			desc->req.rqtype = MEMTODEV;
+			src = dma_addr;
+			dst = pch->fifo_addr;
+			break;
+		case DMA_DEV_TO_MEM:
+			desc->rqcfg.src_inc = 0;
+			desc->rqcfg.dst_inc = 1;
+			desc->req.rqtype = DEVTOMEM;
+			src = pch->fifo_addr;
+			dst = dma_addr;
+			break;
+		default:
+			break;
+		}
+
+		desc->rqcfg.brst_size = pch->burst_sz;
+		desc->rqcfg.brst_len = 1;
+		fill_px(&desc->px, dst, src, period_len);
+
+		if (!first)
+			first = desc;
+		else
+			list_add_tail(&desc->node, &first->node);
+
+		dma_addr += period_len;
+	}
+
+	if (!desc)
+		return NULL;
+
+	pch->cyclic = true;
+	desc->txd.flags = flags;
 
 	return &desc->txd;
 }
-- 
1.8.0

