Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaLEI0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:26:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61303 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaLEI0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:26:14 -0500
X-AuditID: cbfee61a-f79c06d000004e71-79-54816c247362
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, padma.kvr@gmail.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 1/2] dma: pl330: improve pl330_tx_status() function
Date: Fri, 05 Dec 2014 09:25:54 +0100
Message-id: <1417767955-5480-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
References: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAV2VnMYQg6VTjS2mT73AaLF66l9W
	i9cvDC3ONr1ht/g1bRKbxZLJ81ktLu+aw2ax9shddov2ZXNYLR4c3slu8bJvP4sDt8fOWXfZ
	PRbvecnkseTNIVaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyliwaS5bwTvFiqez7rE2MP6S
	7mLk5JAQMJGYO3UZK4QtJnHh3nq2LkYuDiGBRYwSJy9MZoZw2pkk5l/5wARSxSagI7Hl+wRG
	EFtEQEJi+7M+dpAiZoGJTBJr+y+ygSSEBdwkVh5YCdTNwcEioCrx8YoESJhXwEVi+ar1UNvk
	JE4emwxmcwq4Slx4ugysVQio5sGkRuYJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+du
	YgQH3zOpHYwrGywOMQpwMCrx8K6QaAwRYk0sK67MPcQowcGsJMJbqAgU4k1JrKxKLcqPLyrN
	SS0+xCjNwaIkznvjZm6IkEB6YklqdmpqQWoRTJaJg1OqgTHPuOBamrPW/QrOTK/mxLTOkib3
	2SuWSTS8qAmJW/vMhy1ddrN2tc7VmZdtxHx535+7fUT6ffvFYzkfXqReO39eelO8Vqr7/HMP
	2PSvbP7e390b90r6/5vJN/auu5nRY5oQHBHht1eyzYKTcck8x9MfbTmvWfbGPl+S4Plps/qr
	voNTXq9KvK/EUpyRaKjFXFScCAAcNLewOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds possibility to read residue of DMA transfer. It's useful
when we want to know how many bytes have been transferred before we
terminate channel. It can take place, for example, on timeout interrupt.

Signed-off-by: Lukasz Czerwinski <l.czerwinski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/dma/pl330.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index b1e581d..04487de 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -504,6 +504,9 @@ struct dma_pl330_desc {
 
 	enum desc_status status;
 
+	int bytes_requested;
+	bool last;
+
 	/* The channel which currently holds this desc */
 	struct dma_pl330_chan *pchan;
 
@@ -2182,11 +2185,68 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 	pm_runtime_put_autosuspend(pch->dmac->ddma.dev);
 }
 
+int pl330_get_current_xferred_count(struct dma_pl330_chan *pch,
+		struct dma_pl330_desc *desc)
+{
+	struct pl330_thread *thrd = pch->thread;
+	struct pl330_dmac *pl330 = pch->dmac;
+	void __iomem *regs = thrd->dmac->base;
+	u32 val, addr;
+
+	pm_runtime_get_sync(pl330->ddma.dev);
+	val = addr = 0;
+	if (desc->rqcfg.src_inc) {
+		val = readl(regs + SA(thrd->id));
+		addr = desc->px.src_addr;
+	} else {
+		val = readl(regs + DA(thrd->id));
+		addr = desc->px.dst_addr;
+	}
+	pm_runtime_put(pl330->ddma.dev);
+	pm_runtime_put_autosuspend(pl330->ddma.dev);
+	return val - addr;
+}
+
 static enum dma_status
 pl330_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 		 struct dma_tx_state *txstate)
 {
-	return dma_cookie_status(chan, cookie, txstate);
+	enum dma_status ret;
+	unsigned long flags;
+	struct dma_pl330_desc *desc, *running = NULL;
+	struct dma_pl330_chan *pch = to_pchan(chan);
+	unsigned int transferred, residual = 0;
+
+	spin_lock_irqsave(&pch->lock, flags);
+
+	if (pch->thread->req_running != -1)
+		running = pch->thread->req[pch->thread->req_running].desc;
+
+	/* Check in pending list */
+	list_for_each_entry(desc, &pch->work_list, node) {
+		if (desc->status == DONE)
+			transferred = desc->bytes_requested;
+		else if (running && desc == running)
+			transferred =
+				pl330_get_current_xferred_count(pch, desc);
+		else
+			transferred = 0;
+		residual += desc->bytes_requested - transferred;
+		if (desc->txd.cookie == cookie) {
+			dma_set_residue(txstate, residual);
+			ret = desc->status;
+			spin_unlock_irqrestore(&pch->lock, flags);
+			return ret;
+		}
+		if (desc->last)
+			residual = 0;
+	}
+	spin_unlock_irqrestore(&pch->lock, flags);
+
+	ret = dma_cookie_status(chan, cookie, txstate);
+	dma_set_residue(txstate, 0);
+
+	return ret;
 }
 
 static void pl330_issue_pending(struct dma_chan *chan)
@@ -2231,12 +2291,14 @@ static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
 			desc->txd.callback = last->txd.callback;
 			desc->txd.callback_param = last->txd.callback_param;
 		}
+		last->last = false;
 
 		dma_cookie_assign(&desc->txd);
 
 		list_move_tail(&desc->node, &pch->submitted_list);
 	}
 
+	last->last = true;
 	cookie = dma_cookie_assign(&last->txd);
 	list_add_tail(&last->node, &pch->submitted_list);
 	spin_unlock_irqrestore(&pch->lock, flags);
@@ -2459,6 +2521,7 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 		desc->rqtype = direction;
 		desc->rqcfg.brst_size = pch->burst_sz;
 		desc->rqcfg.brst_len = 1;
+		desc->bytes_requested = period_len;
 		fill_px(&desc->px, dst, src, period_len);
 
 		if (!first)
@@ -2601,6 +2664,7 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		desc->rqcfg.brst_size = pch->burst_sz;
 		desc->rqcfg.brst_len = 1;
 		desc->rqtype = direction;
+		desc->bytes_requested = sg_dma_len(sg);
 	}
 
 	/* Return the last desc in the chain */
@@ -2631,7 +2695,7 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = false;
 	caps->cmd_terminate = true;
-	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
+	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_SEGMENT;
 
 	return 0;
 }
-- 
1.9.1

