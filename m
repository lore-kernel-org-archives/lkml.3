Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaJVPpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:22 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53968 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754367AbaJVPpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:16 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 10/59] dmaengine: Create a generic dma_slave_caps callback
Date: Wed, 22 Oct 2014 17:43:24 +0200
Message-Id: <1413992653-21963-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_slave_caps is very important to the generic layers that might interact with
dmaengine, such as ASoC. Unfortunately, it has been added as yet another
dma_device callback, and most of the existing drivers haven't implemented it,
reducing its reliability.

Introduce a generic behaviour and a flag to trigger it. In case this flag
hasn't been set, fall back to the old mechanism.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 include/linux/dmaengine.h | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b0efc805937a..6b74d9d8977e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -642,6 +642,8 @@ struct dma_device {
 	int dev_id;
 	struct device *dev;
 
+	bool generic_slave_caps;
+
 	int (*device_alloc_chan_resources)(struct dma_chan *chan);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
 
@@ -783,17 +785,32 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_sg(
 
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
+	if (device->generic_slave_caps)
 		return -ENXIO;
 
-	if (chan->device->device_slave_caps)
-		return chan->device->device_slave_caps(chan, caps);
+	caps->cmd_pause = !!device->device_pause;
+	caps->cmd_terminate = !!device->device_terminate_all;
 
-	return -ENXIO;
+	return 0;
 }
 
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
-- 
2.1.1

