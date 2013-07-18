Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3GRQro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:47:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50410 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216Ab3GRQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:47:39 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>
CC: Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 1/3] dmaengine: add dma_get_slave_sg_limits()
Date: Thu, 18 Jul 2013 11:46:39 -0500
Message-ID: <1374166001-31340-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374166001-31340-1-git-send-email-joelf@ti.com>
References: <1374166001-31340-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Add a dmaengine API to retrieve slave SG transfer limits.

The API is optionally implemented by dmaengine drivers and when
unimplemented will return a NULL pointer. A client driver using
this API provides the required dma channel, address width, and
burst size of the transfer. dma_get_slave_sg_limits() returns an
SG limits structure with the maximum number and size of SG segments
that the given channel can handle.

[Joel Fernandes <joelf@ti.com>: Changes to allocate limits
structure in client and fill up in DMAEngine implementation.]
Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
Cc: Mark Jackson <mpfj-list@newflow.co.uk>
---
 include/linux/dmaengine.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 96d3e4a..2985878 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -371,6 +371,18 @@ struct dma_slave_config {
 	unsigned int slave_id;
 };
 
+/* struct dma_slave_sg_limits - expose SG transfer limits of a channel
+ *
+ * @max_seg_nr: maximum number of SG segments supported on a SG/SLAVE
+ *	    channel (0 for no maximum or not a SG/SLAVE channel)
+ * @max_seg_len: maximum length of SG segments supported on a SG/SLAVE
+ *	     channel (0 for no maximum or not a SG/SLAVE channel)
+ */
+struct dma_slave_sg_limits {
+	u32 max_seg_nr;
+	u32 max_seg_len;
+};
+
 static inline const char *dma_chan_name(struct dma_chan *chan)
 {
 	return dev_name(&chan->dev->device);
@@ -534,6 +546,7 @@ struct dma_tx_state {
  *	struct with auxiliary transfer status information, otherwise the call
  *	will just return a simple status code
  * @device_issue_pending: push pending transactions to hardware
+ * @device_slave_sg_limits: return the slave SG capabilities
  */
 struct dma_device {
 
@@ -602,6 +615,10 @@ struct dma_device {
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
+	int (*device_slave_sg_limits)(struct dma_chan *chan,
+		enum dma_slave_buswidth addr_width,
+		u32 maxburst,
+		struct dma_slave_sg_limits *sg_limits);
 };
 
 static inline int dmaengine_device_control(struct dma_chan *chan,
@@ -963,6 +980,34 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
 	}
 }
 
+/**
+ * dma_get_slave_sg_limits - get DMAC SG transfer capabilities
+ * @chan: target DMA channel
+ * @addr_width: address width of the DMA transfer
+ * @maxburst: maximum DMA transfer burst size
+ * @sg_limits: point to sg_limits struct to populate with limit info
+ *
+ * Get SG transfer capabilities for a specified channel. If the dmaengine
+ * driver does not implement SG transfer capabilities then NULL is
+ * returned.
+ */
+static inline int
+dma_get_slave_sg_limits(struct dma_chan *chan,
+		       enum dma_slave_buswidth addr_width,
+		       u32 maxburst,
+		       struct dma_slave_sg_limits *sg_limits)
+
+{
+
+	if (chan->device->device_slave_sg_limits && sg_limits)
+		return chan->device->device_slave_sg_limits(chan,
+							  addr_width,
+							  maxburst,
+							  sg_limits);
+
+	return -EINVAL;
+}
+
 enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
-- 
1.7.9.5

