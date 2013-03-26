Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3CZWm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:42:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:27514 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab3CZWm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:42:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276349462"
Subject: [PATCH 04/10] ioatdma: Removing hw bug workaround for CB3.x .2 and
 earlier
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:42:53 -0700
Message-ID: <20130326224253.15072.99117.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
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
 drivers/dma/ioat/dma.c    |    6 +++++
 drivers/dma/ioat/dma.h    |    8 +++++++
 drivers/dma/ioat/dma_v3.c |   50 +++++++++++++++++++++++++++++++++++----------
 3 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 17a2393..e2bf3fa 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -1042,6 +1042,12 @@ int ioat_probe(struct ioatdma_device *device)
 	if (err)
 		goto err_setup_interrupts;
 
+	if (device->init_device) {
+		err = device->init_device(device);
+		if (err)
+			goto err_self_test;
+	}
+
 	err = device->self_test(device);
 	if (err)
 		goto err_self_test;
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index b16902c..12eab37 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -92,8 +92,14 @@ struct ioatdma_device {
 	void (*cleanup_fn)(unsigned long data);
 	void (*timer_fn)(unsigned long data);
 	int (*self_test)(struct ioatdma_device *device);
+	int (*init_device)(struct ioatdma_device *device);
 };
 
+enum ioat_hwbugs {
+	IOAT_LEGACY_COMPLETION_REQUIRED = (1 << 0),
+};
+
+
 struct ioat_chan_common {
 	struct dma_chan common;
 	void __iomem *reg_base;
@@ -116,6 +122,8 @@ struct ioat_chan_common {
 	u64 *completion;
 	struct tasklet_struct cleanup_task;
 	struct kobject kobj;
+
+	u32 hwbug_flags;
 };
 
 struct ioat_sysfs_entry {
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 65b912a..e66fead 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -760,7 +760,8 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 	 * order.
 	 */
 	if (likely(num_descs) &&
-	    ioat2_check_space_lock(ioat, num_descs+1) == 0)
+	    ioat2_check_space_lock(ioat, num_descs + !!(chan->hwbug_flags &
+			    IOAT_LEGACY_COMPLETION_REQUIRED)) == 0)
 		idx = ioat->head;
 	else
 		return NULL;
@@ -814,16 +815,23 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
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
+	if (!(chan->hwbug_flags & IOAT_LEGACY_COMPLETION_REQUIRED)) {
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
@@ -1358,6 +1366,25 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
 	return err;
 }
 
+static int ioat3_init_device(struct ioatdma_device *device)
+{
+	struct pci_dev *pdev = device->pdev;
+	struct dma_device *dma;
+	struct dma_chan *c;
+	struct ioat_chan_common *chan;
+
+	dma = &device->common;
+
+	list_for_each_entry(c, &dma->channels, device_node) {
+		if (is_xeon_cb32(pdev)) {
+			chan = to_chan_common(c);
+			chan->hwbug_flags |= IOAT_LEGACY_COMPLETION_REQUIRED;
+		}
+	}
+
+	return 0;
+}
+
 int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -1372,6 +1399,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	device->enumerate_channels = ioat2_enumerate_channels;
 	device->reset_hw = ioat3_reset_hw;
 	device->self_test = ioat3_dma_self_test;
+	device->init_device = ioat3_init_device;
 	dma = &device->common;
 	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
 	dma->device_issue_pending = ioat2_issue_pending;

