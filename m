Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaKQN7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:59:54 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48964 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753131AbaKQNpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:19 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 07/61] dmaengine: split out pause/resume operations from device_control
Date: Mon, 17 Nov 2014 14:42:01 +0100
Message-Id: <1416231775-31252-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the pause and resume operations to callbacks of their own. In order
to preserve some backwark compatibility, the dmaengine_pause/dmaengine_resume
are still falling back on dmaengine_device_control.

Eventually, that will allow to get the device capabilities in a generic way,
removing the need to implement device_slave_caps.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/dmaengine.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index f797cb81355f..4583c55f3355 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -611,6 +611,10 @@ struct dma_tx_state {
  *	code
  * @device_control: manipulate all pending operations on a channel, returns
  *	zero or error code
+ * @device_pause: Pauses any transfer happening on a channel. Returns
+ *	0 or an error code
+ * @device_resume: Resumes any transfer on a channel previously
+ *	paused. Returns 0 or an error code
  * @device_tx_status: poll for transaction completion, the optional
  *	txstate parameter can be supplied with a pointer to get a
  *	struct with auxiliary transfer status information, otherwise the call
@@ -680,6 +684,8 @@ struct dma_device {
 			     struct dma_slave_config *config);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
+	int (*device_pause)(struct dma_chan *chan);
+	int (*device_resume)(struct dma_chan *chan);
 
 	enum dma_status (*device_tx_status)(struct dma_chan *chan,
 					    dma_cookie_t cookie,
@@ -794,11 +800,17 @@ static inline int dmaengine_terminate_all(struct dma_chan *chan)
 
 static inline int dmaengine_pause(struct dma_chan *chan)
 {
+	if (chan->device->device_pause)
+		return chan->device->device_pause(chan);
+
 	return dmaengine_device_control(chan, DMA_PAUSE, 0);
 }
 
 static inline int dmaengine_resume(struct dma_chan *chan)
 {
+	if (chan->device->device_resume)
+		return chan->device->device_resume(chan);
+
 	return dmaengine_device_control(chan, DMA_RESUME, 0);
 }
 
-- 
2.1.1

