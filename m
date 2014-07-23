Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaGWP2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:28:46 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42565 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbaGWP2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:28:43 -0400
X-Greylist: delayed 1338 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2014 11:28:43 EDT
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@prodrive-technologies.com>,
        Stef van Os <stef.van.os@prodrive-technologies.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [RESEND PATCH] rapidio: add new RapidIO DMA interface routines
Date: Wed, 23 Jul 2014 11:04:18 -0400
Message-Id: <1406127858-32478-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.11
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending because the original email was rejected by some gateways.

Add RapidIO DMA interface routines that directly use reference to the mport
device object and/or target device destination ID as parameters.
This allows to perform RapidIO DMA transfer requests by modules that do not
have an access to the RapidIO device list.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stef van Os <stef.van.os@prodrive-technologies.com>
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/rapidio/rio.c   | 66 +++++++++++++++++++++++++++++++++++--------------
 include/linux/rio_drv.h |  5 ++++
 2 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index a54ba04..d7b87c6 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1509,30 +1509,39 @@ EXPORT_SYMBOL_GPL(rio_route_clr_table);
 
 static bool rio_chan_filter(struct dma_chan *chan, void *arg)
 {
-	struct rio_dev *rdev = arg;
+	struct rio_mport *mport = arg;
 
 	/* Check that DMA device belongs to the right MPORT */
-	return (rdev->net->hport ==
-		container_of(chan->device, struct rio_mport, dma));
+	return mport == container_of(chan->device, struct rio_mport, dma);
 }
 
 /**
- * rio_request_dma - request RapidIO capable DMA channel that supports
- *   specified target RapidIO device.
- * @rdev: RIO device control structure
+ * rio_request_mport_dma - request RapidIO capable DMA channel associated
+ *   with specified local RapidIO mport device.
+ * @mport: RIO mport to perform DMA data transfers
  *
  * Returns pointer to allocated DMA channel or NULL if failed.
  */
-struct dma_chan *rio_request_dma(struct rio_dev *rdev)
+struct dma_chan *rio_request_mport_dma(struct rio_mport *mport)
 {
 	dma_cap_mask_t mask;
-	struct dma_chan *dchan;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-	dchan = dma_request_channel(mask, rio_chan_filter, rdev);
+	return dma_request_channel(mask, rio_chan_filter, mport);
+}
+EXPORT_SYMBOL_GPL(rio_request_mport_dma);
 
-	return dchan;
+/**
+ * rio_request_dma - request RapidIO capable DMA channel that supports
+ *   specified target RapidIO device.
+ * @rdev: RIO device associated with DMA transfer
+ *
+ * Returns pointer to allocated DMA channel or NULL if failed.
+ */
+struct dma_chan *rio_request_dma(struct rio_dev *rdev)
+{
+	return rio_request_mport_dma(rdev->net->hport);
 }
 EXPORT_SYMBOL_GPL(rio_request_dma);
 
@@ -1547,10 +1556,10 @@ void rio_release_dma(struct dma_chan *dchan)
 EXPORT_SYMBOL_GPL(rio_release_dma);
 
 /**
- * rio_dma_prep_slave_sg - RapidIO specific wrapper
+ * rio_dma_prep_xfer - RapidIO specific wrapper
  *   for device_prep_slave_sg callback defined by DMAENGINE.
- * @rdev: RIO device control structure
  * @dchan: DMA channel to configure
+ * @destid: target RapidIO device destination ID
  * @data: RIO specific data descriptor
  * @direction: DMA data transfer direction (TO or FROM the device)
  * @flags: dmaengine defined flags
@@ -1560,11 +1569,10 @@ EXPORT_SYMBOL_GPL(rio_release_dma);
  * target RIO device.
  * Returns pointer to DMA transaction descriptor or NULL if failed.
  */
-struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
-	struct dma_chan *dchan, struct rio_dma_data *data,
+struct dma_async_tx_descriptor *rio_dma_prep_xfer(struct dma_chan *dchan,
+	u16 destid, struct rio_dma_data *data,
 	enum dma_transfer_direction direction, unsigned long flags)
 {
-	struct dma_async_tx_descriptor *txd = NULL;
 	struct rio_dma_ext rio_ext;
 
 	if (dchan->device->device_prep_slave_sg == NULL) {
@@ -1572,15 +1580,35 @@ struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
 		return NULL;
 	}
 
-	rio_ext.destid = rdev->destid;
+	rio_ext.destid = destid;
 	rio_ext.rio_addr_u = data->rio_addr_u;
 	rio_ext.rio_addr = data->rio_addr;
 	rio_ext.wr_type = data->wr_type;
 
-	txd = dmaengine_prep_rio_sg(dchan, data->sg, data->sg_len,
-					direction, flags, &rio_ext);
+	return dmaengine_prep_rio_sg(dchan, data->sg, data->sg_len,
+				     direction, flags, &rio_ext);
+}
+EXPORT_SYMBOL_GPL(rio_dma_prep_xfer);
 
-	return txd;
+/**
+ * rio_dma_prep_slave_sg - RapidIO specific wrapper
+ *   for device_prep_slave_sg callback defined by DMAENGINE.
+ * @rdev: RIO device control structure
+ * @dchan: DMA channel to configure
+ * @data: RIO specific data descriptor
+ * @direction: DMA data transfer direction (TO or FROM the device)
+ * @flags: dmaengine defined flags
+ *
+ * Initializes RapidIO capable DMA channel for the specified data transfer.
+ * Uses DMA channel private extension to pass information related to remote
+ * target RIO device.
+ * Returns pointer to DMA transaction descriptor or NULL if failed.
+ */
+struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
+	struct dma_chan *dchan, struct rio_dma_data *data,
+	enum dma_transfer_direction direction, unsigned long flags)
+{
+	return rio_dma_prep_xfer(dchan,	rdev->destid, data, direction, flags);
 }
 EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
 
diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
index 5059994..9fc2f21 100644
--- a/include/linux/rio_drv.h
+++ b/include/linux/rio_drv.h
@@ -384,11 +384,16 @@ void rio_dev_put(struct rio_dev *);
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 extern struct dma_chan *rio_request_dma(struct rio_dev *rdev);
+extern struct dma_chan *rio_request_mport_dma(struct rio_mport *mport);
 extern void rio_release_dma(struct dma_chan *dchan);
 extern struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(
 		struct rio_dev *rdev, struct dma_chan *dchan,
 		struct rio_dma_data *data,
 		enum dma_transfer_direction direction, unsigned long flags);
+extern struct dma_async_tx_descriptor *rio_dma_prep_xfer(
+		struct dma_chan *dchan,	u16 destid,
+		struct rio_dma_data *data,
+		enum dma_transfer_direction direction, unsigned long flags);
 #endif
 
 /**
-- 
1.7.11

