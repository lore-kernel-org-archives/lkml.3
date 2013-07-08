Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab3GHJdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:33:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:26725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab3GHJdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:33:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1019,1363158000"; 
   d="scan'208";a="342040318"
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Porter <matt@ohporter.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [RFC] dmaengine: add dma_slave_get_caps api
Date: Mon,  8 Jul 2013 14:24:10 +0530
Message-Id: <1373273650-31097-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
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
 include/linux/dmaengine.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 96d3e4a..f259f27 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -371,6 +371,37 @@ struct dma_slave_config {
 	unsigned int slave_id;
 };
 
+/* struct dma_slave_caps - expose capabilities of a slave channel only
+ *
+ * @src_addr_widths: bit mask of src addr widths the channel supports
+ * @dstn_addr_widths: bit mask of dstn addr widths the channel supports
+ * @src_burst_lengths: bit mask of src slave burst lengths supported
+ * @dstn_burst_lengths: bit mask of dstn slave burst lengths supported
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
+	u32 src_burst_lengths;
+	u32 dstn_burst_lengths;
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
@@ -534,6 +565,7 @@ struct dma_tx_state {
  *	struct with auxiliary transfer status information, otherwise the call
  *	will just return a simple status code
  * @device_issue_pending: push pending transactions to hardware
+ * @device_slave_caps: return the slave channel capabilities
  */
 struct dma_device {
 
@@ -602,6 +634,7 @@ struct dma_device {
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
+	struct dma_slave_caps *(*device_slave_caps)(struct dma_chan *chan);
 };
 
 static inline int dmaengine_device_control(struct dma_chan *chan,
@@ -675,6 +708,18 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
 	return chan->device->device_prep_interleaved_dma(chan, xt, flags);
 }
 
+static inline struct dma_slave_caps *dma_get_slave_caps(struct dma_chan *chan)
+{
+	/* check if the channel supports slave transactions */
+	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
+		return NULL;
+
+	if (chan->device->device_slave_caps)
+		return chan->device->device_slave_caps(chan);
+
+	return NULL;
+}
+
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
 {
 	return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
-- 
1.7.0.4

