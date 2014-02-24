Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBXQFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:05:21 -0500
Received: from mxout1.idt.com ([157.165.5.25]:34260 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbaBXQFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:05:19 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rapidio/tsi721_dma: optimize use of BDMA descriptors
Date: Mon, 24 Feb 2014 11:04:42 -0500
Message-Id: <1393257882-7445-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine SG entries describing single contiguous memory block into one Tsi721
BDMA descriptor. This reduces number of hardware descriptors required for large
data transfers and improves performance on the PCIe side by reducing number of
descriptor fetch requests.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
---
 drivers/rapidio/devices/tsi721.h     |    4 +
 drivers/rapidio/devices/tsi721_dma.c |  111 ++++++++++++++++++++++++----------
 2 files changed, 82 insertions(+), 33 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.h b/drivers/rapidio/devices/tsi721.h
index 7061ac0..0305675 100644
--- a/drivers/rapidio/devices/tsi721.h
+++ b/drivers/rapidio/devices/tsi721.h
@@ -644,6 +644,9 @@ enum tsi721_smsg_int_flag {
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
+#define TSI721_BDMA_BD_RING_SZ	128
+#define TSI721_BDMA_MAX_BCOUNT	(TSI721_DMAD_BCOUNT1 + 1)
+
 struct tsi721_tx_desc {
 	struct dma_async_tx_descriptor	txd;
 	struct tsi721_dma_desc		*hw_desc;
@@ -652,6 +655,7 @@ struct tsi721_tx_desc {
 	u64				rio_addr;
 	/* upper 2-bits of 66-bit RIO address */
 	u8				rio_addr_u;
+	u32				bcount;
 	bool				interrupt;
 	struct list_head		desc_node;
 	struct list_head		tx_list;
diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index b57f650..7bf1e3f 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -304,35 +304,17 @@ struct tsi721_tx_desc *tsi721_desc_get(struct tsi721_bdma_chan *bdma_chan)
 }
 
 static int
-tsi721_fill_desc(struct tsi721_bdma_chan *bdma_chan,
-	struct tsi721_tx_desc *desc, struct scatterlist *sg,
+tsi721_desc_fill_init(struct tsi721_tx_desc *desc, struct scatterlist *sg,
 	enum dma_rtype rtype, u32 sys_size)
 {
 	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
 	u64 rio_addr;
 
-	if (sg_dma_len(sg) > TSI721_DMAD_BCOUNT1 + 1) {
-		dev_err(bdma_chan->dchan.device->dev,
-			"SG element is too large\n");
-		return -EINVAL;
-	}
-
-	dev_dbg(bdma_chan->dchan.device->dev,
-		"desc: 0x%llx, addr: 0x%llx len: 0x%x\n",
-		(u64)desc->txd.phys, (unsigned long long)sg_dma_address(sg),
-		sg_dma_len(sg));
-
-	dev_dbg(bdma_chan->dchan.device->dev,
-		"bd_ptr = %p did=%d raddr=0x%llx\n",
-		bd_ptr, desc->destid, desc->rio_addr);
-
 	/* Initialize DMA descriptor */
 	bd_ptr->type_id = cpu_to_le32((DTYPE1 << 29) |
 					(rtype << 19) | desc->destid);
-	if (desc->interrupt)
-		bd_ptr->type_id |= cpu_to_le32(TSI721_DMAD_IOF);
 	bd_ptr->bcount = cpu_to_le32(((desc->rio_addr & 0x3) << 30) |
-					(sys_size << 26) | sg_dma_len(sg));
+				     (sys_size << 26));
 	rio_addr = (desc->rio_addr >> 2) |
 				((u64)(desc->rio_addr_u & 0x3) << 62);
 	bd_ptr->raddr_lo = cpu_to_le32(rio_addr & 0xffffffff);
@@ -346,6 +328,20 @@ tsi721_fill_desc(struct tsi721_bdma_chan *bdma_chan,
 	return 0;
 }
 
+static int
+tsi721_desc_fill_end(struct tsi721_tx_desc *desc)
+{
+	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
+
+	/* Update DMA descriptor */
+	if (desc->interrupt)
+		bd_ptr->type_id |= cpu_to_le32(TSI721_DMAD_IOF);
+	bd_ptr->bcount |= cpu_to_le32(desc->bcount & TSI721_DMAD_BCOUNT1);
+
+	return 0;
+}
+
+
 static void tsi721_dma_chain_complete(struct tsi721_bdma_chan *bdma_chan,
 				      struct tsi721_tx_desc *desc)
 {
@@ -676,6 +672,7 @@ struct dma_async_tx_descriptor *tsi721_prep_rio_sg(struct dma_chan *dchan,
 	unsigned int i;
 	u32 sys_size = dma_to_mport(dchan->device)->sys_size;
 	enum dma_rtype rtype;
+	dma_addr_t next_addr = -1;
 
 	if (!sgl || !sg_len) {
 		dev_err(dchan->device->dev, "%s: No SG list\n", __func__);
@@ -706,36 +703,84 @@ struct dma_async_tx_descriptor *tsi721_prep_rio_sg(struct dma_chan *dchan,
 	for_each_sg(sgl, sg, sg_len, i) {
 		int err;
 
-		dev_dbg(dchan->device->dev, "%s: sg #%d\n", __func__, i);
+		if (sg_dma_len(sg) > TSI721_BDMA_MAX_BCOUNT) {
+			dev_err(dchan->device->dev,
+				"%s: SG entry %d is too large\n", __func__, i);
+			goto err_desc_put;
+		}
+
+		/*
+		 * If this sg entry forms contiguous block with previous one,
+		 * try to merge it into existing DMA descriptor
+		 */
+		if (desc) {
+			if (next_addr == sg_dma_address(sg) &&
+			    desc->bcount + sg_dma_len(sg) <=
+						TSI721_BDMA_MAX_BCOUNT) {
+				/* Adjust byte count of the descriptor */
+				desc->bcount += sg_dma_len(sg);
+				goto entry_done;
+			}
+
+			/*
+			 * Finalize this descriptor using total
+			 * byte count value.
+			 */
+			tsi721_desc_fill_end(desc);
+			dev_dbg(dchan->device->dev, "%s: desc final len: %d\n",
+				__func__, desc->bcount);
+		}
+
+		/*
+		 * Obtain and initialize a new descriptor
+		 */
 		desc = tsi721_desc_get(bdma_chan);
 		if (!desc) {
 			dev_err(dchan->device->dev,
-				"Not enough descriptors available\n");
-			goto err_desc_get;
+				"%s: Failed to get new descriptor for SG %d\n",
+				__func__, i);
+			goto err_desc_put;
 		}
 
-		if (sg_is_last(sg))
-			desc->interrupt = (flags & DMA_PREP_INTERRUPT) != 0;
-		else
-			desc->interrupt = false;
-
 		desc->destid = rext->destid;
 		desc->rio_addr = rio_addr;
 		desc->rio_addr_u = 0;
+		desc->bcount = sg_dma_len(sg);
+
+		dev_dbg(dchan->device->dev,
+			"sg%d desc: 0x%llx, addr: 0x%llx len: %d\n",
+			i, (u64)desc->txd.phys,
+			(unsigned long long)sg_dma_address(sg),
+			sg_dma_len(sg));
+
+		dev_dbg(dchan->device->dev,
+			"bd_ptr = %p did=%d raddr=0x%llx\n",
+			desc->hw_desc, desc->destid, desc->rio_addr);
 
-		err = tsi721_fill_desc(bdma_chan, desc, sg, rtype, sys_size);
+		err = tsi721_desc_fill_init(desc, sg, rtype, sys_size);
 		if (err) {
 			dev_err(dchan->device->dev,
 				"Failed to build desc: %d\n", err);
-			goto err_desc_get;
+			goto err_desc_put;
 		}
 
-		rio_addr += sg_dma_len(sg);
+		next_addr = sg_dma_address(sg);
 
 		if (!first)
 			first = desc;
 		else
 			list_add_tail(&desc->desc_node, &first->tx_list);
+
+entry_done:
+		if (sg_is_last(sg)) {
+			desc->interrupt = (flags & DMA_PREP_INTERRUPT) != 0;
+			tsi721_desc_fill_end(desc);
+			dev_dbg(dchan->device->dev, "%s: desc final len: %d\n",
+				__func__, desc->bcount);
+		} else {
+			rio_addr += sg_dma_len(sg);
+			next_addr += sg_dma_len(sg);
+		}
 	}
 
 	first->txd.cookie = -EBUSY;
@@ -743,7 +788,7 @@ struct dma_async_tx_descriptor *tsi721_prep_rio_sg(struct dma_chan *dchan,
 
 	return &first->txd;
 
-err_desc_get:
+err_desc_put:
 	tsi721_desc_put(bdma_chan, first);
 	return NULL;
 }
@@ -794,7 +839,7 @@ int tsi721_register_dma(struct tsi721_device *priv)
 		if (i == TSI721_DMACH_MAINT)
 			continue;
 
-		bdma_chan->bd_num = 64;
+		bdma_chan->bd_num = TSI721_BDMA_BD_RING_SZ;
 		bdma_chan->regs = priv->regs + TSI721_DMAC_BASE(i);
 
 		bdma_chan->dchan.device = &mport->dma;
-- 
1.7.8.4

