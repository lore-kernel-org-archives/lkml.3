Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaJPKTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:19:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37134 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789AbaJPKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:19:26 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 07/53] dmaengine: Move slave caps to dma_device
Date: Thu, 16 Oct 2014 12:17:06 +0200
Message-Id: <1413454672-27400-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous code was relying on the fact that the slave_caps were to be
defined on a per channel basis.

However, this proved to be a bit overkill, since every driver filling these so
far were hardcoding it, disregarding which channel was actually given.

Add these capabilities to the dma_device structure, so that drivers can just
provide them at probe time, and be done with it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 include/linux/dmaengine.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 85afd71df2e7..befa352ccba6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -594,6 +594,14 @@ struct dma_tx_state {
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
@@ -644,6 +652,10 @@ struct dma_device {
 	struct device *dev;
 
 	bool generic_slave_caps;
+	u32 src_addr_widths;
+	u32 dst_addr_widths;
+	u32 directions;
+	enum dma_residue_granularity residue_granularity;
 
 	int (*device_alloc_chan_resources)(struct dma_chan *chan);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
@@ -796,6 +808,11 @@ static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_cap
 	if (device->generic_slave_caps)
 		return -ENXIO;
 
+	caps->src_addr_widths = device->src_addr_widths;
+	caps->dst_addr_widths = device->dst_addr_widths;
+	caps->directions = device->directions;
+	caps->residue_granularity = device->residue_granularity;
+
 	caps->cmd_pause = !!device->device_pause;
 	caps->cmd_terminate = !!device->device_terminate_all;
 
-- 
2.1.1

