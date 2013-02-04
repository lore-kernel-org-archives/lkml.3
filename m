Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3BDTq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:46:28 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:64287 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3BDTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:46:26 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [PATCH v3 1/3] dmaengine: add dma_get_slave_sg_caps()
Date: Mon,  4 Feb 2013 14:47:02 -0500
Message-Id: <1360007224-21735-2-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360007224-21735-1-git-send-email-mporter@ti.com>
References: <1360007224-21735-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dmaengine API to retrieve slave SG transfer capabilities.

The API is optionally implemented by dmaengine drivers and when
unimplemented will return a NULL pointer. A client driver using
this API provides the required dma channel, address width, and
burst size of the transfer. dma_get_slave_sg_caps() returns an
SG caps structure with the maximum number and size of SG segments
that the given channel can handle.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 include/linux/dmaengine.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d3201e4..5b5b220 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -371,6 +371,19 @@ struct dma_slave_config {
 	unsigned int slave_id;
 };
 
+/* struct dma_slave_sg_caps - expose SG transfer capability of a
+ * channel.
+ *
+ * @max_seg_nr: maximum number of SG segments supported on a SG/SLAVE
+ *	    channel (0 for no maximum or not a SG/SLAVE channel)
+ * @max_seg_len: maximum length of SG segments supported on a SG/SLAVE
+ *	     channel (0 for no maximum or not a SG/SLAVE channel)
+ */
+struct dma_slave_sg_caps {
+	u32 max_seg_nr;
+	u32 max_seg_len;
+};
+
 static inline const char *dma_chan_name(struct dma_chan *chan)
 {
 	return dev_name(&chan->dev->device);
@@ -534,6 +547,7 @@ struct dma_tx_state {
  *	struct with auxiliary transfer status information, otherwise the call
  *	will just return a simple status code
  * @device_issue_pending: push pending transactions to hardware
+ * @device_slave_sg_caps: return the slave SG capabilities
  */
 struct dma_device {
 
@@ -602,6 +616,9 @@ struct dma_device {
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
+	struct dma_slave_sg_caps *(*device_slave_sg_caps)(
+		struct dma_chan *chan, enum dma_slave_buswidth addr_width,
+		u32 maxburst);
 };
 
 static inline int dmaengine_device_control(struct dma_chan *chan,
@@ -969,6 +986,29 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
 	}
 }
 
+/**
+ * dma_get_slave_sg_caps - get DMAC SG transfer capabilities
+ * @chan: target DMA channel
+ * @addr_width: address width of the DMA transfer
+ * @maxburst: maximum DMA transfer burst size
+ *
+ * Get SG transfer capabilities for a specified channel. If the dmaengine
+ * driver does not implement SG transfer capabilities then NULL is
+ * returned.
+ */
+static inline struct dma_slave_sg_caps
+*dma_get_slave_sg_caps(struct dma_chan *chan,
+		       enum dma_slave_buswidth addr_width,
+		       u32 maxburst)
+{
+	if (chan->device->device_slave_sg_caps)
+		return chan->device->device_slave_sg_caps(chan,
+							  addr_width,
+							  maxburst);
+
+	return NULL;
+}
+
 enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
-- 
1.7.9.5

