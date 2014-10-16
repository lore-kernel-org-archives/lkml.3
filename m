Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaJPKXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:23:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37383 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752594AbaJPKUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:22 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 53/53] dmaengine: Mark device_control and device_slave_caps as deprecated
Date: Thu, 16 Oct 2014 12:17:52 +0200
Message-Id: <1413454672-27400-54-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_control has been split into several functions, and
device_slave_caps rendered useless, we can consider them deprecated.

That also means that we don't want to make device_control mandatory any more.
Since any device was free to implement any command of device_control, the only
least common denominator is to not expect any callback anymore.

Hopefully, the generic device_slave_caps can provide such informations to the
client.

Also add warning that trigger during registration if those callbacks are set,
in order to encourage legacy driver to switch to these new mechanisms.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dmaengine.c   |  8 ++++++--
 include/linux/dmaengine.h | 10 ++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index cfcb181b1184..05c72cd0b53a 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -812,8 +812,6 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_sg);
 	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
 		!device->device_prep_dma_cyclic);
-	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
-		!device->device_control);
 	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
 		!device->device_prep_interleaved_dma);
 
@@ -821,6 +819,12 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
 
+	WARN(device->device_control,
+	     "this driver still declares device_control, which is deprecated.\n");
+
+	WARN(dma_has_cap(DMA_SLAVE, device->cap_mask) && !device->generic_slave_caps,
+	     "this driver doesn't support generic slave capabilities reporting\n");
+
 	/* note: this only matters in the
 	 * CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH=n case
 	 */
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index befa352ccba6..f9776b8176d3 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -619,7 +619,7 @@ struct dma_tx_state {
  * @device_config: Pushes a new configuration to a channel, return 0 or an error
  *	code
  * @device_control: manipulate all pending operations on a channel, returns
- *	zero or error code
+ *	zero or error code (Deprecated)
  * @device_pause: Pauses any transfer happening on a channel. Returns
  *	0 or an error code
  * @device_resume: Resumes any transfer on a channel previously
@@ -631,7 +631,7 @@ struct dma_tx_state {
  *	struct with auxiliary transfer status information, otherwise the call
  *	will just return a simple status code
  * @device_issue_pending: push pending transactions to hardware
- * @device_slave_caps: return the slave channel capabilities
+ * @device_slave_caps: return the slave channel capabilities (Deprecated)
  */
 struct dma_device {
 
@@ -698,8 +698,6 @@ struct dma_device {
 
 	int (*device_config)(struct dma_chan *chan,
 			     struct dma_slave_config *config);
-	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			      unsigned long arg);
 	int (*device_pause)(struct dma_chan *chan);
 	int (*device_resume)(struct dma_chan *chan);
 	int (*device_terminate_all)(struct dma_chan *chan);
@@ -707,6 +705,10 @@ struct dma_device {
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
+
+	/* Deprecated */
+	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			      unsigned long arg);
 	int (*device_slave_caps)(struct dma_chan *chan, struct dma_slave_caps *caps);
 };
 
-- 
2.1.1

