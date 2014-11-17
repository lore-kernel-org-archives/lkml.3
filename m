Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaKQNta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:49:30 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49222 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752876AbaKQNpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:54 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 06/61] dmaengine: Introduce a device_config callback
Date: Mon, 17 Nov 2014 14:42:00 +0100
Message-Id: <1416231775-31252-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fact that the channel configuration is done in device_control is rather
misleading, since it's not really advertised as such, plus, the fact that the
framework exposes a function of its own makes it not really intuitive, while
we're losing the type checking whenever we pass that unsigned long argument.

Add a device_config callback to dma_device, with a fallback on the old
behaviour for now for existing drivers to opt in.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/dmaengine.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 4d912575fec0..f797cb81355f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -607,6 +607,8 @@ struct dma_tx_state {
  *	The function takes a buffer of size buf_len. The callback function will
  *	be called after period_len bytes have been transferred.
  * @device_prep_interleaved_dma: Transfer expression in a generic way.
+ * @device_config: Pushes a new configuration to a channel, return 0 or an error
+ *	code
  * @device_control: manipulate all pending operations on a channel, returns
  *	zero or error code
  * @device_tx_status: poll for transaction completion, the optional
@@ -673,6 +675,9 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
 		struct dma_chan *chan, struct dma_interleaved_template *xt,
 		unsigned long flags);
+
+	int (*device_config)(struct dma_chan *chan,
+			     struct dma_slave_config *config);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
@@ -696,6 +701,9 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
 static inline int dmaengine_slave_config(struct dma_chan *chan,
 					  struct dma_slave_config *config)
 {
+	if (chan->device->device_config)
+		return chan->device->device_config(chan, config);
+
 	return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
 			(unsigned long)config);
 }
-- 
2.1.1

