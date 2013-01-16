Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab3APJLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:11:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:59737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab3APJK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:10:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,478,1355126400"; 
   d="scan'208";a="272675799"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: switch to use dma_pool API
Date: Wed, 16 Jan 2013 11:10:43 +0200
Message-Id: <1358327443-10562-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes the code cleaner and allows developer not to worry about cache
coherency issues. The price for this is a bit slower access to the descriptor
structures.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   81 ++++++++++----------------------------------
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 18 insertions(+), 64 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 561bb9a..8f4dac5 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -98,14 +99,6 @@ static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
 
 /*----------------------------------------------------------------------*/
 
-/*
- * Because we're not relying on writeback from the controller (it may not
- * even be configured into the core!) we don't need to use dma_pool.  These
- * descriptors -- and associated data -- are cacheable.  We do need to make
- * sure their dcache entries are written back before handing them off to
- * the controller, though.
- */
-
 static struct device *chan2dev(struct dma_chan *chan)
 {
 	return &chan->dev->device;
@@ -144,19 +137,6 @@ static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 	return ret;
 }
 
-static void dwc_sync_desc_for_cpu(struct dw_dma_chan *dwc, struct dw_desc *desc)
-{
-	struct dw_desc	*child;
-
-	list_for_each_entry(child, &desc->tx_list, desc_node)
-		dma_sync_single_for_cpu(chan2parent(&dwc->chan),
-				child->txd.phys, sizeof(child->lli),
-				DMA_TO_DEVICE);
-	dma_sync_single_for_cpu(chan2parent(&dwc->chan),
-			desc->txd.phys, sizeof(desc->lli),
-			DMA_TO_DEVICE);
-}
-
 /*
  * Move a descriptor, including any children, to the free list.
  * `desc' must not be on any lists.
@@ -168,8 +148,6 @@ static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	if (desc) {
 		struct dw_desc *child;
 
-		dwc_sync_desc_for_cpu(dwc, desc);
-
 		spin_lock_irqsave(&dwc->lock, flags);
 		list_for_each_entry(child, &desc->tx_list, desc_node)
 			dev_vdbg(chan2dev(&dwc->chan),
@@ -342,8 +320,6 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 		param = txd->callback_param;
 	}
 
-	dwc_sync_desc_for_cpu(dwc, desc);
-
 	/* async_tx_ack */
 	list_for_each_entry(child, &desc->tx_list, desc_node)
 		async_tx_ack(&child->txd);
@@ -777,24 +753,17 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 			first = desc;
 		} else {
 			prev->lli.llp = desc->txd.phys;
-			dma_sync_single_for_device(chan2parent(chan),
-					prev->txd.phys, sizeof(prev->lli),
-					DMA_TO_DEVICE);
 			list_add_tail(&desc->desc_node,
 					&first->tx_list);
 		}
 		prev = desc;
 	}
 
-
 	if (flags & DMA_PREP_INTERRUPT)
 		/* Trigger interrupt after last block */
 		prev->lli.ctllo |= DWC_CTLL_INT_EN;
 
 	prev->lli.llp = 0;
-	dma_sync_single_for_device(chan2parent(chan),
-			prev->txd.phys, sizeof(prev->lli),
-			DMA_TO_DEVICE);
 
 	first->txd.flags = flags;
 	first->len = len;
@@ -883,10 +852,6 @@ slave_sg_todev_fill_desc:
 				first = desc;
 			} else {
 				prev->lli.llp = desc->txd.phys;
-				dma_sync_single_for_device(chan2parent(chan),
-						prev->txd.phys,
-						sizeof(prev->lli),
-						DMA_TO_DEVICE);
 				list_add_tail(&desc->desc_node,
 						&first->tx_list);
 			}
@@ -945,10 +910,6 @@ slave_sg_fromdev_fill_desc:
 				first = desc;
 			} else {
 				prev->lli.llp = desc->txd.phys;
-				dma_sync_single_for_device(chan2parent(chan),
-						prev->txd.phys,
-						sizeof(prev->lli),
-						DMA_TO_DEVICE);
 				list_add_tail(&desc->desc_node,
 						&first->tx_list);
 			}
@@ -968,9 +929,6 @@ slave_sg_fromdev_fill_desc:
 		prev->lli.ctllo |= DWC_CTLL_INT_EN;
 
 	prev->lli.llp = 0;
-	dma_sync_single_for_device(chan2parent(chan),
-			prev->txd.phys, sizeof(prev->lli),
-			DMA_TO_DEVICE);
 
 	first->len = total_len;
 
@@ -1125,7 +1083,6 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	struct dw_desc		*desc;
 	int			i;
 	unsigned long		flags;
-	int			ret;
 
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
@@ -1146,21 +1103,21 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	spin_lock_irqsave(&dwc->lock, flags);
 	i = dwc->descs_allocated;
 	while (dwc->descs_allocated < NR_DESCS_PER_CHANNEL) {
+		dma_addr_t phys;
+
 		spin_unlock_irqrestore(&dwc->lock, flags);
 
-		desc = kzalloc(sizeof(struct dw_desc), GFP_KERNEL);
+		desc = dma_pool_alloc(dw->desc_pool, GFP_ATOMIC, &phys);
 		if (!desc)
 			goto err_desc_alloc;
 
+		memset(desc, 0, sizeof(struct dw_desc));
+
 		INIT_LIST_HEAD(&desc->tx_list);
 		dma_async_tx_descriptor_init(&desc->txd, chan);
 		desc->txd.tx_submit = dwc_tx_submit;
 		desc->txd.flags = DMA_CTRL_ACK;
-		desc->txd.phys = dma_map_single(chan2parent(chan), &desc->lli,
-				sizeof(desc->lli), DMA_TO_DEVICE);
-		ret = dma_mapping_error(chan2parent(chan), desc->txd.phys);
-		if (ret)
-			goto err_desc_alloc;
+		desc->txd.phys = phys;
 
 		dwc_desc_put(dwc, desc);
 
@@ -1171,14 +1128,10 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	dev_dbg(chan2dev(chan), "%s: allocated %d descriptors\n", __func__, i);
-
 	return i;
 
 err_desc_alloc:
-	kfree(desc);
-
 	dev_info(chan2dev(chan), "only allocated %d descriptors\n", i);
-
 	return i;
 }
 
@@ -1211,9 +1164,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
 		dev_vdbg(chan2dev(chan), "  freeing descriptor %p\n", desc);
-		dma_unmap_single(chan2parent(chan), desc->txd.phys,
-				sizeof(desc->lli), DMA_TO_DEVICE);
-		kfree(desc);
+		dma_pool_free(dw->desc_pool, desc, desc->txd.phys);
 	}
 
 	dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
@@ -1458,20 +1409,14 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		desc->lli.ctlhi = (period_len >> reg_width);
 		cdesc->desc[i] = desc;
 
-		if (last) {
+		if (last)
 			last->lli.llp = desc->txd.phys;
-			dma_sync_single_for_device(chan2parent(chan),
-					last->txd.phys, sizeof(last->lli),
-					DMA_TO_DEVICE);
-		}
 
 		last = desc;
 	}
 
 	/* lets make a cyclic list */
 	last->lli.llp = cdesc->desc[0]->txd.phys;
-	dma_sync_single_for_device(chan2parent(chan), last->txd.phys,
-			sizeof(last->lli), DMA_TO_DEVICE);
 
 	dev_dbg(chan2dev(&dwc->chan), "cyclic prepared buf 0x%llx len %zu "
 			"period %zu periods %d\n", (unsigned long long)buf_addr,
@@ -1729,6 +1674,14 @@ static int dw_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dw);
 
+	/* create a pool of consistent memory blocks for hardware descriptors */
+	dw->desc_pool = dmam_pool_create("dw_dmac_desc_pool", &pdev->dev,
+					 sizeof(struct dw_desc), 4, 0);
+	if (!dw->desc_pool) {
+		dev_err(&pdev->dev, "No memory for descriptors dma pool\n");
+		return -ENOMEM;
+	}
+
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
 	INIT_LIST_HEAD(&dw->dma.channels);
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 577f2dd..fef296d 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -235,6 +235,7 @@ static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
 struct dw_dma {
 	struct dma_device	dma;
 	void __iomem		*regs;
+	struct dma_pool		*desc_pool;
 	struct tasklet_struct	tasklet;
 	struct clk		*clk;
 
-- 
1.7.10.4

