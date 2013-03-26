Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3CZWnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:43:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:49333 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab3CZWn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276349732"
Subject: [PATCH 09/10] ioatdma: Adding write back descriptor error status
 support for ioatdma 3.3
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:43:27 -0700
Message-ID: <20130326224327.15072.96599.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3.3 provides support for write back descriptor error status. This allows
reporting of errors in a descriptor field. In supporting this, certain
errors such as P/Q validation errors no longer halts the channel. The DMA
engine can continue to execute until the end of the chain and allow software
to report the "errors" up the stack. We are also going to mask those error
interrupts and handle them when the "chain" has completed at the end.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c    |   87 ++++++++++++++++++++++++++++++++++++------
 drivers/dma/ioat/hw.h        |   17 +++++++-
 drivers/dma/ioat/registers.h |    1 
 3 files changed, 90 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 230a8bc..83d44f3 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -498,6 +498,32 @@ static bool ioat3_cleanup_preamble(struct ioat_chan_common *chan,
 	return true;
 }
 
+static void desc_get_errstat(struct ioat_ring_ent *desc)
+{
+	struct ioat_dma_descriptor *hw = desc->hw;
+
+	switch (hw->ctl_f.op) {
+	case IOAT_OP_PQ_VAL:
+	case IOAT_OP_PQ_VAL_16S:
+	{
+		struct ioat_pq_descriptor *pq = desc->pq;
+
+		/* check if there's error written */
+		if (!pq->dwbes_f.wbes)
+			return;
+
+		if (pq->dwbes_f.p_val_err)
+			*desc->result |= SUM_CHECK_P_RESULT;
+
+		if (pq->dwbes_f.q_val_err)
+			*desc->result |= SUM_CHECK_Q_RESULT;
+		return;
+	}
+	default:
+		return;
+	}
+}
+
 /**
  * __cleanup - reclaim used descriptors
  * @ioat: channel (ring) to clean
@@ -535,6 +561,10 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
 		desc = ioat2_get_ring_ent(ioat, idx + i);
 		dump_desc_dbg(ioat, desc);
+
+		/* set err stat if we are using dwbes */
+		desc_get_errstat(desc);
+
 		tx = &desc->txd;
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
@@ -580,14 +610,15 @@ static void ioat3_cleanup(struct ioat2_dma_chan *ioat)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 	u64 phys_complete;
+	u32 chanerr;
 
 	spin_lock_bh(&chan->cleanup_lock);
 
 	if (ioat3_cleanup_preamble(chan, &phys_complete))
 		__cleanup(ioat, phys_complete);
 
+	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
 	if (is_ioat_halted(*chan->completion)) {
-		u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
 
 		if (chanerr & IOAT_CHANERR_HANDLE_MASK) {
 			mod_timer(&chan->timer, jiffies + IDLE_TIMEOUT);
@@ -595,6 +626,15 @@ static void ioat3_cleanup(struct ioat2_dma_chan *ioat)
 		}
 	}
 
+	/*
+	 * with DWBES we must clear the chanerr register at the end of the
+	 * chain in order to be able to issue the next command.
+	 */
+	if (chanerr) {
+		writel(chanerr & IOAT_CHANERR_HANDLE_MASK,
+		       chan->reg_base + IOAT_CHANERR_OFFSET);
+	}
+
 	spin_unlock_bh(&chan->cleanup_lock);
 }
 
@@ -1077,6 +1117,8 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 		pq->q_addr = dst[1] + offset;
 		pq->ctl = 0;
 		pq->ctl_f.op = op;
+		/* we turn on descriptor write back error status */
+		pq->ctl_f.wb_en = result ? 1 : 0;
 		pq->ctl_f.src_cnt = src_cnt_to_hw(s);
 		pq->ctl_f.p_disable = !!(flags & DMA_PREP_PQ_DISABLE_P);
 		pq->ctl_f.q_disable = !!(flags & DMA_PREP_PQ_DISABLE_Q);
@@ -1193,6 +1235,8 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 		pq->ctl = 0;
 		pq->ctl_f.op = op;
 		pq->ctl_f.src_cnt = src16_cnt_to_hw(s);
+		/* we turn on descriptor write back error status */
+		pq->ctl_f.wb_en = result ? 1 : 0;
 		pq->ctl_f.p_disable = !!(flags & DMA_PREP_PQ_DISABLE_P);
 		pq->ctl_f.q_disable = !!(flags & DMA_PREP_PQ_DISABLE_Q);
 
@@ -1785,9 +1829,28 @@ static int ioat3_init_device(struct ioatdma_device *device)
 	struct dma_device *dma;
 	struct dma_chan *c;
 	struct ioat_chan_common *chan;
+	u32 cap, errmask;
 
 	dma = &device->common;
 
+	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
+
+	/*
+	 * if we have descriptor write back error status, we mask the
+	 * error interrupts
+	 */
+	if (cap & (IOAT_CAP_DWBES | IOAT_CAP_RAID16SS)) {
+		list_for_each_entry(c, &dma->channels, device_node) {
+			chan = to_chan_common(c);
+			errmask = readl(chan->reg_base +
+					IOAT_CHANERR_MASK_OFFSET);
+			errmask |= IOAT_CHANERR_XOR_P_OR_CRC_ERR |
+				   IOAT_CHANERR_XOR_Q_ERR;
+			writel(errmask, chan->reg_base +
+					IOAT_CHANERR_MASK_OFFSET);
+		}
+	}
+
 	list_for_each_entry(c, &dma->channels, device_node) {
 		if (is_xeon_cb32(pdev)) {
 			chan = to_chan_common(c);
@@ -1846,6 +1909,11 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	if (cap & IOAT_CAP_PQ) {
 		is_raid_device = true;
 
+		dma->device_prep_dma_pq = ioat3_prep_pq;
+		dma->device_prep_dma_pq_val = ioat3_prep_pq_val;
+		dma_cap_set(DMA_PQ, dma->cap_mask);
+		dma_cap_set(DMA_PQ_VAL, dma->cap_mask);
+
 		if (cap & IOAT_CAP_RAID16SS) {
 			dma_set_maxpq(dma, 16, 0);
 			dma->pq_align = 0;
@@ -1857,13 +1925,12 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 				dma->pq_align = 0;
 		}
 
-		dma_cap_set(DMA_PQ, dma->cap_mask);
-		dma->device_prep_dma_pq = ioat3_prep_pq;
-
-		dma_cap_set(DMA_PQ_VAL, dma->cap_mask);
-		dma->device_prep_dma_pq_val = ioat3_prep_pq_val;
-
 		if (!(cap & IOAT_CAP_XOR)) {
+			dma->device_prep_dma_xor = ioat3_prep_pqxor;
+			dma->device_prep_dma_xor_val = ioat3_prep_pqxor_val;
+			dma_cap_set(DMA_XOR, dma->cap_mask);
+			dma_cap_set(DMA_XOR_VAL, dma->cap_mask);
+
 			if (cap & IOAT_CAP_RAID16SS) {
 				dma->max_xor = 16;
 				dma->xor_align = 0;
@@ -1874,12 +1941,6 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 				else
 					dma->xor_align = 0;
 			}
-
-			dma_cap_set(DMA_XOR, dma->cap_mask);
-			dma->device_prep_dma_xor = ioat3_prep_pqxor;
-
-			dma_cap_set(DMA_XOR_VAL, dma->cap_mask);
-			dma->device_prep_dma_xor_val = ioat3_prep_pqxor_val;
 		}
 	}
 
diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index d10570d..5ee57d4 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -165,7 +165,17 @@ struct ioat_xor_ext_descriptor {
 };
 
 struct ioat_pq_descriptor {
-	uint32_t	size;
+	union {
+		uint32_t	size;
+		uint32_t	dwbes;
+		struct {
+			unsigned int rsvd:25;
+			unsigned int p_val_err:1;
+			unsigned int q_val_err:1;
+			unsigned int rsvd1:4;
+			unsigned int wbes:1;
+		} dwbes_f;
+	};
 	union {
 		uint32_t ctl;
 		struct {
@@ -180,7 +190,10 @@ struct ioat_pq_descriptor {
 			unsigned int hint:1;
 			unsigned int p_disable:1;
 			unsigned int q_disable:1;
-			unsigned int rsvd:11;
+			unsigned int rsvd2:2;
+			unsigned int wb_en:1;
+			unsigned int prl_en:1;
+			unsigned int rsvd3:7;
 			#define IOAT_OP_PQ 0x89
 			#define IOAT_OP_PQ_VAL 0x8a
 			#define IOAT_OP_PQ_16S 0xa0
diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index efdd47e..2f1cfa0 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -79,6 +79,7 @@
 #define IOAT_CAP_APIC				0x00000080
 #define IOAT_CAP_XOR				0x00000100
 #define IOAT_CAP_PQ				0x00000200
+#define IOAT_CAP_DWBES				0x00002000
 #define IOAT_CAP_RAID16SS			0x00020000
 
 #define IOAT_CHANNEL_MMIO_SIZE			0x80	/* Each Channel MMIO space is this size */

