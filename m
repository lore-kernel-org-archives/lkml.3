Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937162Ab3DJXoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:44:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:41814 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936331Ab3DJXoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="284530899"
Subject: [PATCH v2 1/5] ioatdma: Removing hw bug workaround for CB3.x .2 and
 earlier
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 16:44:20 -0700
Message-ID: <20130410234420.9082.7578.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
References: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CB3.2 and earlier hardware has silicon bugs that are no longer needed with
the new hardware. We don't have to use a NULL op to signal interrupt for
RAID ops any longer. This code make sure the legacy workarounds only happen on
legacy hardware.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index cf97e3f..6393115 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -837,6 +837,7 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
 	struct ioat_chan_common *chan = &ioat->base;
+	struct ioatdma_device *device = chan->device;
 	struct ioat_ring_ent *compl_desc;
 	struct ioat_ring_ent *desc;
 	struct ioat_ring_ent *ext;
@@ -847,6 +848,7 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 	u32 offset = 0;
 	u8 op = result ? IOAT_OP_PQ_VAL : IOAT_OP_PQ;
 	int i, s, idx, with_ext, num_descs;
+	int cb32 = (device->version < IOAT_VER_3_3) ? 1 : 0;
 
 	dev_dbg(to_dev(chan), "%s\n", __func__);
 	/* the engine requires at least two sources (we provide
@@ -872,7 +874,7 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 	 * order.
 	 */
 	if (likely(num_descs) &&
-	    ioat2_check_space_lock(ioat, num_descs+1) == 0)
+	    ioat2_check_space_lock(ioat, num_descs + cb32) == 0)
 		idx = ioat->head;
 	else
 		return NULL;
@@ -926,16 +928,23 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 	pq->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
 	dump_pq_desc_dbg(ioat, desc, ext);
 
-	/* completion descriptor carries interrupt bit */
-	compl_desc = ioat2_get_ring_ent(ioat, idx + i);
-	compl_desc->txd.flags = flags & DMA_PREP_INTERRUPT;
-	hw = compl_desc->hw;
-	hw->ctl = 0;
-	hw->ctl_f.null = 1;
-	hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
-	hw->ctl_f.compl_write = 1;
-	hw->size = NULL_DESC_BUFFER_SIZE;
-	dump_desc_dbg(ioat, compl_desc);
+	if (!cb32) {
+		pq->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
+		pq->ctl_f.compl_write = 1;
+		compl_desc = desc;
+	} else {
+		/* completion descriptor carries interrupt bit */
+		compl_desc = ioat2_get_ring_ent(ioat, idx + i);
+		compl_desc->txd.flags = flags & DMA_PREP_INTERRUPT;
+		hw = compl_desc->hw;
+		hw->ctl = 0;
+		hw->ctl_f.null = 1;
+		hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
+		hw->ctl_f.compl_write = 1;
+		hw->size = NULL_DESC_BUFFER_SIZE;
+		dump_desc_dbg(ioat, compl_desc);
+	}
+
 
 	/* we leave the channel locked to ensure in order submission */
 	return &compl_desc->txd;

