Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaKQNqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:46:42 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49249 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753206AbaKQNqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:46:00 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 60/61] dmaengine: Remove device_control and device_slave_caps
Date: Mon, 17 Nov 2014 14:42:54 +0100
Message-Id: <1416231775-31252-61-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_control has been split into several functions, and
device_slave_caps rendered useless, we can safely remove them.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/dmaengine.h | 52 ++++++-----------------------------------------
 1 file changed, 6 insertions(+), 46 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index be9e60aa8f5e..b01b7a7c581b 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -189,25 +189,6 @@ enum dma_ctrl_flags {
 };
 
 /**
- * enum dma_ctrl_cmd - DMA operations that can optionally be exercised
- * on a running channel.
- * @DMA_TERMINATE_ALL: terminate all ongoing transfers
- * @DMA_PAUSE: pause ongoing transfers
- * @DMA_RESUME: resume paused transfer
- * @DMA_SLAVE_CONFIG: this command is only implemented by DMA controllers
- * that need to runtime reconfigure the slave channels (as opposed to passing
- * configuration data in statically from the platform). An additional
- * argument of struct dma_slave_config must be passed in with this
- * command.
- */
-enum dma_ctrl_cmd {
-	DMA_TERMINATE_ALL,
-	DMA_PAUSE,
-	DMA_RESUME,
-	DMA_SLAVE_CONFIG,
-};
-
-/**
  * enum sum_check_bits - bit position of pq_check_flags
  */
 enum sum_check_bits {
@@ -336,9 +317,8 @@ enum dma_slave_buswidth {
  * This struct is passed in as configuration data to a DMA engine
  * in order to set up a certain channel for DMA transport at runtime.
  * The DMA device/engine has to provide support for an additional
- * command in the channel config interface, DMA_SLAVE_CONFIG
- * and this struct will then be passed in as an argument to the
- * DMA engine device_control() function.
+ * callback in the dma_device structure, device_config and this struct
+ * will then be passed in as an argument to the function.
  *
  * The rationale for adding configuration information to this struct is as
  * follows: if it is likely that more than one DMA slave controllers in
@@ -617,8 +597,6 @@ struct dma_tx_state {
  * @device_prep_interleaved_dma: Transfer expression in a generic way.
  * @device_config: Pushes a new configuration to a channel, return 0 or an error
  *	code
- * @device_control: manipulate all pending operations on a channel, returns
- *	zero or error code
  * @device_pause: Pauses any transfer happening on a channel. Returns
  *	0 or an error code
  * @device_resume: Resumes any transfer on a channel previously
@@ -630,7 +608,6 @@ struct dma_tx_state {
  *	struct with auxiliary transfer status information, otherwise the call
  *	will just return a simple status code
  * @device_issue_pending: push pending transactions to hardware
- * @device_slave_caps: return the slave channel capabilities
  */
 struct dma_device {
 
@@ -697,8 +674,6 @@ struct dma_device {
 
 	int (*device_config)(struct dma_chan *chan,
 			     struct dma_slave_config *config);
-	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		unsigned long arg);
 	int (*device_pause)(struct dma_chan *chan);
 	int (*device_resume)(struct dma_chan *chan);
 	int (*device_terminate_all)(struct dma_chan *chan);
@@ -707,27 +682,15 @@ struct dma_device {
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
-	int (*device_slave_caps)(struct dma_chan *chan, struct dma_slave_caps *caps);
 };
 
-static inline int dmaengine_device_control(struct dma_chan *chan,
-					   enum dma_ctrl_cmd cmd,
-					   unsigned long arg)
-{
-	if (chan->device->device_control)
-		return chan->device->device_control(chan, cmd, arg);
-
-	return -ENOSYS;
-}
-
 static inline int dmaengine_slave_config(struct dma_chan *chan,
 					  struct dma_slave_config *config)
 {
 	if (chan->device->device_config)
 		return chan->device->device_config(chan, config);
 
-	return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
-			(unsigned long)config);
+	return -ENOSYS;
 }
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
@@ -807,9 +770,6 @@ static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_cap
 	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
 		return -ENXIO;
 
-	if (device->device_slave_caps)
-		return device->device_slave_caps(chan, caps);
-
 	/*
 	 * Check whether it reports it uses the generic slave
 	 * capabilities, if not, that means it doesn't support any
@@ -834,7 +794,7 @@ static inline int dmaengine_terminate_all(struct dma_chan *chan)
 	if (chan->device->device_terminate_all)
 		return chan->device->device_terminate_all(chan);
 
-	return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
+	return -ENOSYS;
 }
 
 static inline int dmaengine_pause(struct dma_chan *chan)
@@ -842,7 +802,7 @@ static inline int dmaengine_pause(struct dma_chan *chan)
 	if (chan->device->device_pause)
 		return chan->device->device_pause(chan);
 
-	return dmaengine_device_control(chan, DMA_PAUSE, 0);
+	return -ENOSYS;
 }
 
 static inline int dmaengine_resume(struct dma_chan *chan)
@@ -850,7 +810,7 @@ static inline int dmaengine_resume(struct dma_chan *chan)
 	if (chan->device->device_resume)
 		return chan->device->device_resume(chan);
 
-	return dmaengine_device_control(chan, DMA_RESUME, 0);
+	return -ENOSYS;
 }
 
 static inline enum dma_status dmaengine_tx_status(struct dma_chan *chan,
-- 
2.1.1

