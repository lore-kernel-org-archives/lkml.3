Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaJ1Wa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:30:57 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:49053 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaJ1Waz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:30:55 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dmaengine@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: [PATCH] dmaengine: Move dma_get_slave_caps() implementation to dmaengine.c
Date: Wed, 29 Oct 2014 00:30:58 +0200
Message-Id: <1414535458-21699-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414531573-18807-11-git-send-email-maxime.ripard@free-electrons.com>
References: <1414531573-18807-11-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is too big to be a static inline.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/dma/dmaengine.c   | 33 +++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h | 32 +-------------------------------
 2 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 300c8cd2786c..caa91abca2ee 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -480,6 +480,39 @@ static void dma_channel_rebalance(void)
 		}
 }
 
+int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps)
+{
+	struct dma_device *device;
+
+	if (!chan || !caps)
+		return -EINVAL;
+
+	device = chan->device;
+
+	/* check if the channel supports slave transactions */
+	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
+		return -ENXIO;
+
+	/*
+	 * Check whether it reports it uses the generic slave
+	 * capabilities, if not, that means it doesn't support any
+	 * kind of slave capabilities reporting.
+	 */
+	if (!device->directions)
+		return -ENXIO;
+
+	caps->src_addr_widths = device->src_addr_widths;
+	caps->dst_addr_widths = device->dst_addr_widths;
+	caps->directions = device->directions;
+	caps->residue_granularity = device->residue_granularity;
+
+	caps->cmd_pause = !!device->device_pause;
+	caps->cmd_terminate = !!device->device_terminate_all;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dma_get_slave_caps);
+
 static struct dma_chan *private_candidate(const dma_cap_mask_t *mask,
 					  struct dma_device *dev,
 					  dma_filter_fn fn, void *fn_param)
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b01b7a7c581b..92e0ca01061c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -757,37 +757,7 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_sg(
 			src_sg, src_nents, flags);
 }
 
-static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps)
-{
-	struct dma_device *device;
-
-	if (!chan || !caps)
-		return -EINVAL;
-
-	device = chan->device;
-
-	/* check if the channel supports slave transactions */
-	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
-		return -ENXIO;
-
-	/*
-	 * Check whether it reports it uses the generic slave
-	 * capabilities, if not, that means it doesn't support any
-	 * kind of slave capabilities reporting.
-	 */
-	if (!device->directions)
-		return -ENXIO;
-
-	caps->src_addr_widths = device->src_addr_widths;
-	caps->dst_addr_widths = device->dst_addr_widths;
-	caps->directions = device->directions;
-	caps->residue_granularity = device->residue_granularity;
-
-	caps->cmd_pause = !!device->device_pause;
-	caps->cmd_terminate = !!device->device_terminate_all;
-
-	return 0;
-}
+int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps);
 
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
 {
-- 
Regards,

Laurent Pinchart

