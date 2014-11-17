Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaKQNp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:45:58 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbaKQNpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:47 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 10/61] dmaengine: Create a generic dma_slave_caps callback
Date: Mon, 17 Nov 2014 14:42:04 +0100
Message-Id: <1416231775-31252-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_slave_caps is very important to the generic layers that might interact with
dmaengine, such as ASoC. Unfortunately, it has been added as yet another
dma_device callback, and most of the existing drivers haven't implemented it,
reducing its reliability.

Introduce a generic behaviour to implement this, that rely on both the split of
device_control to derive which functions are supported and on new variables to
be set in the dma_device structure.

These variables holds what used to be the capabilities, that were set
per-channel. However, this proved to be a bit overkill, since every driver
filling these so far were hardcoding it, disregarding which channel was
actually given.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/dmaengine.h | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b0efc805937a..be9e60aa8f5e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -593,6 +593,14 @@ struct dma_tx_state {
  * @fill_align: alignment shift for memset operations
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
+ * @src_addr_widths: bit mask of src addr widths the device supports
+ * @dst_addr_widths: bit mask of dst addr widths the device supports
+ * @directions: bit mask of slave direction the device supports since
+ * 	the enum dma_transfer_direction is not defined as bits for
+ * 	each type of direction, the dma controller should fill (1 <<
+ * 	<TYPE>) and same should be checked by controller as well
+ * @residue_granularity: granularity of the transfer residue reported
+ *	by tx_status
  * @device_alloc_chan_resources: allocate resources and return the
  *	number of allocated descriptors
  * @device_free_chan_resources: release DMA channel's resources
@@ -642,6 +650,11 @@ struct dma_device {
 	int dev_id;
 	struct device *dev;
 
+	u32 src_addr_widths;
+	u32 dst_addr_widths;
+	u32 directions;
+	enum dma_residue_granularity residue_granularity;
+
 	int (*device_alloc_chan_resources)(struct dma_chan *chan);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
 
@@ -783,17 +796,37 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_sg(
 
 static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps)
 {
+	struct dma_device *device;
+
 	if (!chan || !caps)
 		return -EINVAL;
 
+	device = chan->device;
+
 	/* check if the channel supports slave transactions */
-	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
+	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
+		return -ENXIO;
+
+	if (device->device_slave_caps)
+		return device->device_slave_caps(chan, caps);
+
+	/*
+	 * Check whether it reports it uses the generic slave
+	 * capabilities, if not, that means it doesn't support any
+	 * kind of slave capabilities reporting.
+	 */
+	if (!device->directions)
 		return -ENXIO;
 
-	if (chan->device->device_slave_caps)
-		return chan->device->device_slave_caps(chan, caps);
+	caps->src_addr_widths = device->src_addr_widths;
+	caps->dst_addr_widths = device->dst_addr_widths;
+	caps->directions = device->directions;
+	caps->residue_granularity = device->residue_granularity;
+
+	caps->cmd_pause = !!device->device_pause;
+	caps->cmd_terminate = !!device->device_terminate_all;
 
-	return -ENXIO;
+	return 0;
 }
 
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
-- 
2.1.1

