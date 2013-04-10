Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937306Ab3DJXoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:44:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:20973 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934578Ab3DJXol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="284530966"
Subject: [PATCH v2 4/5] ioatdma: Adding write back descriptor error status
 support for ioatdma 3.3
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 16:44:39 -0700
Message-ID: <20130410234438.9082.50575.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
References: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
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
 drivers/dma/ioat/dma.h       |    1 
 drivers/dma/ioat/dma_v3.c    |  111 +++++++++++++++++++++++++++++++++---------
 drivers/dma/ioat/hw.h        |   17 ++++++
 drivers/dma/ioat/registers.h |    1 
 4 files changed, 105 insertions(+), 25 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 35d7402..54fb7b9 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -90,6 +90,7 @@ struct ioatdma_device {
 	struct ioat_chan_common *idx[4];
 	struct dca_provider *dca;
 	enum ioat_irq_mode irq_mode;
+	u32 cap;
 	void (*intr_quirk)(struct ioatdma_device *device);
 	int (*enumerate_channels)(struct ioatdma_device *device);
 	int (*reset_hw)(struct ioat_chan_common *chan);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 343320c..2802c92 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -515,6 +515,36 @@ static bool ioat3_cleanup_preamble(struct ioat_chan_common *chan,
 	return true;
 }
 
+static void
+desc_get_errstat(struct ioat2_dma_chan *ioat, struct ioat_ring_ent *desc)
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
+		/* need to set a chanerr var for checking to clear later */
+
+		if (pq->dwbes_f.p_val_err)
+			*desc->result |= SUM_CHECK_P_RESULT;
+
+		if (pq->dwbes_f.q_val_err)
+			*desc->result |= SUM_CHECK_Q_RESULT;
+
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
@@ -552,6 +582,11 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
 		desc = ioat2_get_ring_ent(ioat, idx + i);
 		dump_desc_dbg(ioat, desc);
+
+		/* set err stat if we are using dwbes */
+		if (device->cap & IOAT_CAP_DWBES)
+			desc_get_errstat(ioat, desc);
+
 		tx = &desc->txd;
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
@@ -1095,6 +1130,9 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 		pq->q_addr = dst[1] + offset;
 		pq->ctl = 0;
 		pq->ctl_f.op = op;
+		/* we turn on descriptor write back error status */
+		if (device->cap & IOAT_CAP_DWBES)
+			pq->ctl_f.wb_en = result ? 1 : 0;
 		pq->ctl_f.src_cnt = src_cnt_to_hw(s);
 		pq->ctl_f.p_disable = !!(flags & DMA_PREP_PQ_DISABLE_P);
 		pq->ctl_f.q_disable = !!(flags & DMA_PREP_PQ_DISABLE_Q);
@@ -1211,6 +1249,9 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 		pq->ctl = 0;
 		pq->ctl_f.op = op;
 		pq->ctl_f.src_cnt = src16_cnt_to_hw(s);
+		/* we turn on descriptor write back error status */
+		if (device->cap & IOAT_CAP_DWBES)
+			pq->ctl_f.wb_en = result ? 1 : 0;
 		pq->ctl_f.p_disable = !!(flags & DMA_PREP_PQ_DISABLE_P);
 		pq->ctl_f.q_disable = !!(flags & DMA_PREP_PQ_DISABLE_Q);
 
@@ -1797,6 +1838,32 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
 	return err;
 }
 
+static void ioat3_intr_quirk(struct ioatdma_device *device)
+{
+	struct dma_device *dma;
+	struct dma_chan *c;
+	struct ioat_chan_common *chan;
+	u32 errmask;
+
+	dma = &device->common;
+
+	/*
+	 * if we have descriptor write back error status, we mask the
+	 * error interrupts
+	 */
+	if (device->cap & IOAT_CAP_DWBES) {
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
+}
+
 int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -1806,11 +1873,11 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	struct ioat_chan_common *chan;
 	bool is_raid_device = false;
 	int err;
-	u32 cap;
 
 	device->enumerate_channels = ioat2_enumerate_channels;
 	device->reset_hw = ioat3_reset_hw;
 	device->self_test = ioat3_dma_self_test;
+	device->intr_quirk = ioat3_intr_quirk;
 	dma = &device->common;
 	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
 	dma->device_issue_pending = ioat2_issue_pending;
@@ -1823,16 +1890,16 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 
-	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
+	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
 
 	if (is_bwd_noraid(pdev))
-		cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
+		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
 
 	/* dca is incompatible with raid operations */
-	if (dca_en && (cap & (IOAT_CAP_XOR|IOAT_CAP_PQ)))
-		cap &= ~(IOAT_CAP_XOR|IOAT_CAP_PQ);
+	if (dca_en && (device->cap & (IOAT_CAP_XOR|IOAT_CAP_PQ)))
+		device->cap &= ~(IOAT_CAP_XOR|IOAT_CAP_PQ);
 
-	if (cap & IOAT_CAP_XOR) {
+	if (device->cap & IOAT_CAP_XOR) {
 		is_raid_device = true;
 		dma->max_xor = 8;
 		dma->xor_align = 6;
@@ -1844,10 +1911,15 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		dma->device_prep_dma_xor_val = ioat3_prep_xor_val;
 	}
 
-	if (cap & IOAT_CAP_PQ) {
+	if (device->cap & IOAT_CAP_PQ) {
 		is_raid_device = true;
 
-		if (cap & IOAT_CAP_RAID16SS) {
+		dma->device_prep_dma_pq = ioat3_prep_pq;
+		dma->device_prep_dma_pq_val = ioat3_prep_pq_val;
+		dma_cap_set(DMA_PQ, dma->cap_mask);
+		dma_cap_set(DMA_PQ_VAL, dma->cap_mask);
+
+		if (device->cap & IOAT_CAP_RAID16SS) {
 			dma_set_maxpq(dma, 16, 0);
 			dma->pq_align = 0;
 		} else {
@@ -1858,14 +1930,13 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 				dma->pq_align = 0;
 		}
 
-		dma_cap_set(DMA_PQ, dma->cap_mask);
-		dma->device_prep_dma_pq = ioat3_prep_pq;
-
-		dma_cap_set(DMA_PQ_VAL, dma->cap_mask);
-		dma->device_prep_dma_pq_val = ioat3_prep_pq_val;
+		if (!(device->cap & IOAT_CAP_XOR)) {
+			dma->device_prep_dma_xor = ioat3_prep_pqxor;
+			dma->device_prep_dma_xor_val = ioat3_prep_pqxor_val;
+			dma_cap_set(DMA_XOR, dma->cap_mask);
+			dma_cap_set(DMA_XOR_VAL, dma->cap_mask);
 
-		if (!(cap & IOAT_CAP_XOR)) {
-			if (cap & IOAT_CAP_RAID16SS) {
+			if (device->cap & IOAT_CAP_RAID16SS) {
 				dma->max_xor = 16;
 				dma->xor_align = 0;
 			} else {
@@ -1875,16 +1946,10 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
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
 
-	if (is_raid_device && (cap & IOAT_CAP_FILL_BLOCK)) {
+	if (is_raid_device && (device->cap & IOAT_CAP_FILL_BLOCK)) {
 		dma_cap_set(DMA_MEMSET, dma->cap_mask);
 		dma->device_prep_dma_memset = ioat3_prep_memset_lock;
 	}
@@ -1903,7 +1968,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	}
 
 	/* starting with CB3.3 super extended descriptors are supported */
-	if (cap & IOAT_CAP_RAID16SS) {
+	if (device->cap & IOAT_CAP_RAID16SS) {
 		char pool_name[14];
 		int i;
 
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

