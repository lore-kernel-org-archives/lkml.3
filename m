Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab3LILTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:19:31 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12310 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab3LILTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:19:30 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-5f-52a5a73f944d
From: Lukasz Czerwinski <l.czerwinski@samsung.com>
To: djbw@fb.com, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, m.szyprowski@samsung.com
Subject: [RFC PATCH] dma: pl330: Change pl330_tx_status()
Date: Mon, 09 Dec 2013 12:19:26 +0100
Message-id: <1386587966-27635-1-git-send-email-l.czerwinski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJMWRmVeSWpSXmKPExsVy+t/xK7r2y5cGGTxYIG2xuf8Bm8XlXXPY
	LNYeuctucfhNO6sDi8fE5nfsHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJUx6f9J5oIfMhUb
	eu4xNzCuF+9i5OSQEDCROLF2OQuELSZx4d56ti5GLg4hgaWMEi82vodyupkk/i2YyAZSxSZg
	JDHr7WFmEFtEQFfias8yVhCbGWjSlXk/wCYJC1hKTH63nx3EZhFQlZh/8BNYDa+Ah8S14yuA
	bA6gbQoScybZTGDkXsDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjxOdfdjAuPmZ1iFGA
	g1GJh3cF69IgIdbEsuLK3EOMEhzMSiK8/+cDhXhTEiurUovy44tKc1KLDzEycXBKNTBKinvb
	5hrFif2dPqX82FH2hMnXjL+6HI3Ucwi24zL+d8ljR1BX+Q8OWcYl4uGP7i+fIW7jsyYyI2xJ
	4g3uqrtW2ye3SFc+v97btyOTv499XU3qrvDYotuvl0+2vbnrCd+vR4oNufaO59ZYG3E5Tv/2
	puMdg+q5nHi386ZzZ0qEXJryz75k5j0lluKMREMt5qLiRAB+rGZF1wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds possibility to read status of unfinished transfers
before termination.

Signed-off-by: Lukasz Czerwinski <l.czerwinski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

I tested patch with Exynos4 board. This is only proof of concept.
Any comments are welcome.

Thanks
Lukasz

 drivers/dma/pl330.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 24f8ae3..c88c36e 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -566,6 +566,7 @@ struct dma_pl330_chan {
 	/* For D-to-M and M-to-D channels */
 	int burst_sz; /* the peripheral fifo width */
 	int burst_len; /* the number of burst */
+	int transfered;
 	dma_addr_t fifo_addr;
 
 	/* for cyclic capability */
@@ -602,6 +603,9 @@ struct dma_pl330_desc {
 
 	enum desc_status status;
 
+	int bytes_requested;
+	int direction;
+
 	/* The channel which currently holds this desc */
 	struct dma_pl330_chan *pchan;
 };
@@ -2366,6 +2370,29 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
 	return 1;
 }
 
+int pl330_get_current_xferred_count(struct dma_pl330_chan *pch,
+		struct dma_pl330_desc *desc)
+{
+	u32 val, addr;
+	struct pl330_thread *thrd = pch->pl330_chid;
+	void __iomem *regs = thrd->dmac->pinfo->base;
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
 static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned long arg)
 {
 	struct dma_pl330_chan *pch = to_pchan(chan);
@@ -2446,7 +2473,33 @@ static enum dma_status
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
@@ -2717,9 +2770,12 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 			break;
 		}
 
+		desc->direction = direction;
 		desc->rqcfg.brst_size = pch->burst_sz;
 		desc->rqcfg.brst_len = 1;
+		desc->bytes_requested = period_len;
 		fill_px(&desc->px, dst, src, period_len);
+		pch->transfered = 0;
 
 		if (!first)
 			first = desc;
@@ -2853,8 +2909,11 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				sg_dma_address(sg), addr, sg_dma_len(sg));
 		}
 
+		desc->direction = direction;
 		desc->rqcfg.brst_size = pch->burst_sz;
 		desc->rqcfg.brst_len = 1;
+		desc->bytes_requested = sg_dma_len(sg);
+		pch->transfered = 0;
 	}
 
 	/* Return the last desc in the chain */
-- 
1.7.9.5

