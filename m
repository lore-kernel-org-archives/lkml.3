Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3GOLAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:00:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:23423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab3GOLAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="331505555"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <djbw@fb.com>, Matt Porter <matt@ohporter.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] dmaengine: add dma_slave_get_caps api
Date: Mon, 15 Jul 2013 15:51:27 +0530
Message-Id: <1373883687-10146-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1373273650-31097-1-git-send-email-vinod.koul@intel.com>
References: <1373273650-31097-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add new device callback .device_slave_caps api which can be used by clients to
query the dma channel capablties before they program the channel. This can help
is removing errors during the channel programming. Also add helper
dma_slave_get_caps API

This patch folds the work done by Matt earlier
https://patchwork.kernel.org/patch/2094891/

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
this version
	changes api to include struct dma_slave_caps as arg
	removed burst lengths, can be added when we have users
--

 include/linux/dmaengine.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index cb286b1..3582593 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -370,6 +370,33 @@ struct dma_slave_config {
 	unsigned int slave_id;
 };
 
+/* struct dma_slave_caps - expose capabilities of a slave channel only
+ *
+ * @src_addr_widths: bit mask of src addr widths the channel supports
+ * @dstn_addr_widths: bit mask of dstn addr widths the channel supports
+ * @directions: bit mask of slave direction the channel supported
+ * 	since the enum dma_transfer_direction is not defined as bits for each
+ * 	type of direction, the dma controller should fill (1 << <TYPE>) and same
+ * 	should be checked by controller as well
+ * @cmd_pause: true, if pause and thereby resume is supported
+ * @cmd_terminate: true, if terminate cmd is supported
+ *
+ * @max_seg_nr: maximum number of SG segments supported
+ * 	0 for no maximum
+ * @max_seg_len: maximum length of a SG segment supported
+ * 	0 for no maximum
+ */
+struct dma_slave_caps {
+	u32 src_addr_widths;
+	u32 dstn_addr_widths;
+	u32 directions;
+	bool cmd_pause;
+	bool cmd_terminate;
+
+	u32 max_sg_nr;
+	u32 max_sg_len;
+};
+
 static inline const char *dma_chan_name(struct dma_chan *chan)
 {
 	return dev_name(&chan->dev->device);
@@ -532,6 +559,7 @@ struct dma_tx_state {
  *	struct with auxiliary transfer status information, otherwise the call
  *	will just return a simple status code
  * @device_issue_pending: push pending transactions to hardware
+ * @device_slave_caps: return the slave channel capabilities
  */
 struct dma_device {
 
@@ -597,6 +625,7 @@ struct dma_device {
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
+	int (*device_slave_caps)(struct dma_chan *chan, struct dma_slave_caps *caps);
 };
 
 static inline int dmaengine_device_control(struct dma_chan *chan,
@@ -670,6 +699,21 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
 	return chan->device->device_prep_interleaved_dma(chan, xt, flags);
 }
 
+static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps)
+{
+	if (!chan || !caps)
+		return -EINVAL;
+
+	/* check if the channel supports slave transactions */
+	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
+		return -ENXIO;
+
+	if (chan->device->device_slave_caps)
+		return chan->device->device_slave_caps(chan, caps);
+
+	return -ENXIO;
+}
+
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
 {
 	return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
-- 
1.7.0.4

