Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3CYMVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:21:48 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1036 "EHLO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3CYMVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:21:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16258
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] dma: Make the 'mask' parameter of __dma_request_channel const
Date: Mon, 25 Mar 2013 13:23:52 +0100
Message-Id: <1364214232-30078-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'mask' parameter is not modified in __dma_request_channel and really
shouldn't be. Make this explicit by making the parameter const.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/dmaengine.c   |  9 ++++++---
 include/linux/dmaengine.h | 11 ++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index b2728d6..d07ef7d 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -174,7 +174,8 @@ static struct class dma_devclass = {
 #define dma_device_satisfies_mask(device, mask) \
 	__dma_device_satisfies_mask((device), &(mask))
 static int
-__dma_device_satisfies_mask(struct dma_device *device, dma_cap_mask_t *want)
+__dma_device_satisfies_mask(struct dma_device *device,
+			    const dma_cap_mask_t *want)
 {
 	dma_cap_mask_t has;
 
@@ -463,7 +464,8 @@ static void dma_channel_rebalance(void)
 		}
 }
 
-static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_device *dev,
+static struct dma_chan *private_candidate(const dma_cap_mask_t *mask,
+					  struct dma_device *dev,
 					  dma_filter_fn fn, void *fn_param)
 {
 	struct dma_chan *chan;
@@ -505,7 +507,8 @@ static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_devic
  * @fn: optional callback to disposition available channels
  * @fn_param: opaque parameter to pass to dma_filter_fn
  */
-struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param)
+struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
+				       dma_filter_fn fn, void *fn_param)
 {
 	struct dma_device *device, *_d;
 	struct dma_chan *chan = NULL;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 91ac8da..2511742 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -967,8 +967,9 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
-struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
 struct dma_chan *dma_request_slave_channel(struct device *dev, char *name);
+struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
+				       dma_filter_fn fn, void *fn_param);
 void dma_release_channel(struct dma_chan *chan);
 #else
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
@@ -978,7 +979,7 @@ static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descript
 static inline void dma_issue_pending_all(void)
 {
 }
-static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
+static inline struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 					      dma_filter_fn fn, void *fn_param)
 {
 	return NULL;
@@ -1005,9 +1006,9 @@ struct dma_chan *net_dma_find_channel(void);
 	__dma_request_slave_channel_compat(&(mask), x, y, dev, name)
 
 static inline struct dma_chan
-*__dma_request_slave_channel_compat(dma_cap_mask_t *mask, dma_filter_fn fn,
-				  void *fn_param, struct device *dev,
-				  char *name)
+*__dma_request_slave_channel_compat(const dma_cap_mask_t *mask,
+				  dma_filter_fn fn, void *fn_param,
+				  struct device *dev, char *name)
 {
 	struct dma_chan *chan;
 
-- 
1.8.0

