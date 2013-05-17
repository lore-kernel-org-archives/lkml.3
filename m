Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3EQRxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:53:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:18836 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab3EQRxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:53:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,694,1363158000"; 
   d="scan'208";a="315415879"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] ioat: device control support
Date: Fri, 17 May 2013 10:53:47 -0700
Message-Id: <1368813227-29512-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device control support for CBDMA v2 and v3 in the ioat driver.
This allows DMA engine clients to call into the ioat driver and issue a
DMA_TERMINATE_ALL.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/dma/ioat/dma_v2.c |   22 ++++++++++++++++++++++
 drivers/dma/ioat/dma_v3.c |   22 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index b925e1b..d373ee3 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -847,6 +847,27 @@ void ioat2_free_chan_resources(struct dma_chan *c)
 	ioat->dmacount = 0;
 }
 
+static int ioat2_device_control(struct dma_chan *c, enum dma_ctrl_cmd cmd,
+				unsigned long arg)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+	struct ioat_chan_common *chan = &ioat->base;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		spin_lock_bh(&chan->cleanup_lock);
+		spin_lock_bh(&ioat->prep_lock);
+		ioat2_restart_channel(ioat);
+		spin_unlock_bh(&ioat->prep_lock);
+		spin_unlock_bh(&chan->cleanup_lock);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 static ssize_t ring_size_show(struct dma_chan *c, char *page)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
@@ -896,6 +917,7 @@ int ioat2_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 	dma->device_tx_status = ioat_dma_tx_status;
+	dma->device_control = ioat2_device_control;
 
 	err = ioat_probe(device);
 	if (err)
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index ca6ea9b..ca6ecdc 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1833,6 +1833,27 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
 	return err;
 }
 
+static int ioat3_device_control(struct dma_chan *c, enum dma_ctrl_cmd cmd,
+				unsigned long arg)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+	struct ioat_chan_common *chan = &ioat->base;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		spin_lock_bh(&chan->cleanup_lock);
+		spin_lock_bh(&ioat->prep_lock);
+		ioat3_restart_channel(ioat);
+		spin_unlock_bh(&ioat->prep_lock);
+		spin_unlock_bh(&chan->cleanup_lock);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 static void ioat3_intr_quirk(struct ioatdma_device *device)
 {
 	struct dma_device *dma;
@@ -1878,6 +1899,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_issue_pending = ioat2_issue_pending;
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
+	dma->device_control = ioat3_device_control;
 
 	if (is_xeon_cb32(pdev))
 		dma->copy_align = 6;
-- 
1.7.9.5

