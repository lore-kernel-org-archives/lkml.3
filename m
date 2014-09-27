Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaI0I4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:56:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38677 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752854AbaI0I4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:56:50 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 8/9] dmaengine: Mark device_control as deprecated
Date: Sat, 27 Sep 2014 10:54:44 +0200
Message-Id: <1411808085-27792-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_control has been split into several functions, we can consider
it deprecated.

That also means that we don't want to make it mandatory any more. Since any
device was free to implement any command of device_control, the only least
common denominator is to not expect any callback anymore. Hopefully,
device_slave_caps can provide such informations to the client.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dmaengine.c   |  2 --
 include/linux/dmaengine.h | 10 ++++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index cfcb181b1184..87348e6a3791 100644
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
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index e25a365b808c..9c0d16273ef9 100644
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
 
@@ -697,8 +697,6 @@ struct dma_device {
 
 	int (*device_config)(struct dma_chan *chan,
 			     struct dma_slave_config *config);
-	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			      unsigned long arg);
 	int (*device_pause)(struct dma_chan *chan);
 	int (*device_resume)(struct dma_chan *chan);
 	int (*device_terminate_all)(struct dma_chan *chan);
@@ -706,6 +704,10 @@ struct dma_device {
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
2.1.0

