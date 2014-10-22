Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaJVQJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:09:36 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53973 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754417AbaJVPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:17 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 11/59] dmaengine: Move slave caps to dma_device
Date: Wed, 22 Oct 2014 17:43:25 +0200
Message-Id: <1413992653-21963-12-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
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
index 6b74d9d8977e..98f8163dfbac 100644
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
@@ -643,6 +651,10 @@ struct dma_device {
 	struct device *dev;
 
 	bool generic_slave_caps;
+	u32 src_addr_widths;
+	u32 dst_addr_widths;
+	u32 directions;
+	enum dma_residue_granularity residue_granularity;
 
 	int (*device_alloc_chan_resources)(struct dma_chan *chan);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
@@ -807,6 +819,11 @@ static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_cap
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

