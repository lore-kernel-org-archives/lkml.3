Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbaKYM0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:26:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63621 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKYM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:26:04 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-01-5474755ac635
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, ars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 1/2] dma: pl330: improve pl330_tx_status() function
Date: Tue, 25 Nov 2014 13:25:45 +0100
Message-id: <1416918346-2442-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
References: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd2o0pIQg9N7BS0uHOhktJg+9QKj
	xeqpf1ktfk2bxGZxedccNou1R+6yWzw4vJPd4mXffhYHDo/Fe14yeSx5c4jVo2/LKkaPz5vk
	AliiuGxSUnMyy1KL9O0SuDKWLz3GWrBKpmLu70VsDYyfxboYOTgkBEwkdr2V7GLkBDLFJC7c
	W8/WxcjFISQwnVFix4YrLBBOO5PE/JevWEGq2AR0JLZ8n8AIYosISEhsf9bHDlLELHCUUWL6
	3AtsIAlhAWeJ03e3sIBsYBFQlWhYANbLK+AiMXnKLiaIbXISJ49NBotzCrhK9C56CDZTCKhm
	2pGjTBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA6qZ9I7GFc1WBxiFOBgVOLh
	7ThbHCLEmlhWXJl7iFGCg1lJhPdJckmIEG9KYmVValF+fFFpTmrxIUZpDhYlcd4bN3NDhATS
	E0tSs1NTC1KLYLJMHJxSDYycu0Sj21jSToZ87pmxVInj0wbpC5dP2QuviKha3f7dcXN4QN7E
	dxc+BmtWps84UxUWuOuf5jsmxyO/H8zbvXlr3c+vnWWHdhlcr20u6bh1P62ufs7BUPmHk6zf
	Lemw2/x+sVvjXsPn+iErD87TfnPf7Wds9Z992x1svjR7a+w323ra9k3NpgsTlFiKMxINtZiL
	ihMBXHeNICYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds possibility to read residue of DMA transfer. It's useful
when we want to know how many bytes have been transfered before we
terminate channel. It can take place, for example, on timeout interrupt.

Signed-off-by: Lukasz Czerwinski <l.czerwinski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/dma/pl330.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index d5149aa..c32806d 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -437,6 +437,7 @@ struct dma_pl330_chan {
 	/* For D-to-M and M-to-D channels */
 	int burst_sz; /* the peripheral fifo width */
 	int burst_len; /* the number of burst */
+	int transfered;
 	dma_addr_t fifo_addr;
 
 	/* for cyclic capability */
@@ -500,6 +501,9 @@ struct dma_pl330_desc {
 
 	enum desc_status status;
 
+	int bytes_requested;
+	int direction;
+
 	/* The channel which currently holds this desc */
 	struct dma_pl330_chan *pchan;
 
@@ -2156,11 +2160,60 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 	spin_unlock_irqrestore(&pch->lock, flags);
 }
 
+int pl330_get_current_xferred_count(struct dma_pl330_chan *pch,
+		struct dma_pl330_desc *desc)
+{
+	u32 val, addr;
+	struct pl330_thread *thrd = pch->thread;
+	void __iomem *regs = thrd->dmac->base;
+
+	val = addr = 0;
+	switch (desc->direction) {
+	case DMA_MEM_TO_DEV:
+		val = readl(regs + SA(thrd->id));
+		addr = desc->px.src_addr;
+		break;
+	case DMA_DEV_TO_MEM:
+		val = readl(regs + DA(thrd->id));
+		addr = desc->px.dst_addr;
+		break;
+	default:
+		break;
+	}
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
+	struct dma_pl330_desc *desc;
+	struct dma_pl330_chan *pch = to_pchan(chan);
+	unsigned int bytes_transferred;
+	unsigned int residual;
+
+	/* Check in pending list */
+	spin_lock_irqsave(&pch->lock, flags);
+	list_for_each_entry(desc, &pch->work_list, node) {
+		if (desc->txd.cookie == cookie) {
+			bytes_transferred =
+				pl330_get_current_xferred_count(pch, desc);
+			residual =  desc->bytes_requested -
+				bytes_transferred % desc->bytes_requested;
+			dma_set_residue(txstate, residual);
+			ret = desc->status;
+			spin_unlock_irqrestore(&pch->lock, flags);
+			return ret;
+		}
+	}
+	spin_unlock_irqrestore(&pch->lock, flags);
+
+	ret = dma_cookie_status(chan, cookie, txstate);
+	dma_set_residue(txstate,  pch->transfered);
+
+	return ret;
 }
 
 static void pl330_issue_pending(struct dma_chan *chan)
@@ -2421,10 +2474,13 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 			break;
 		}
 
+		desc->direction = direction;
 		desc->rqtype = direction;
 		desc->rqcfg.brst_size = pch->burst_sz;
 		desc->rqcfg.brst_len = 1;
+		desc->bytes_requested = period_len;
 		fill_px(&desc->px, dst, src, period_len);
+		pch->transfered = 0;
 
 		if (!first)
 			first = desc;
@@ -2554,9 +2610,12 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				sg_dma_address(sg), addr, sg_dma_len(sg));
 		}
 
+		desc->direction = direction;
 		desc->rqcfg.brst_size = pch->burst_sz;
 		desc->rqcfg.brst_len = 1;
 		desc->rqtype = direction;
+		desc->bytes_requested = sg_dma_len(sg);
+		pch->transfered = 0;
 	}
 
 	/* Return the last desc in the chain */
-- 
1.9.1

