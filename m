Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3DOXkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:40:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:13870 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab3DOXkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:40:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,479,1363158000"; 
   d="scan'208";a="286572512"
Subject: [PATCH v3] async_tx: allow generic async_memcpy() not be effected
 by channel switch
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Mon, 15 Apr 2013 16:39:32 -0700
Message-ID: <20130415233932.14402.37368.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic async_memcpy() for the DMA engines that cannot do channel
switch. Previously it would exclude all DMA engines that don't have all equal
capabilities for all ops with the DMA_ASYNC_TX check. The RAID version of
async memcpy will only request RAID capable channels. This allow us to remove
the ifdef for channel switching fixup.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 crypto/async_tx/async_memcpy.c      |   76 +++++++++++++++++++++++++++--------
 crypto/async_tx/async_raid6_recov.c |    4 +-
 drivers/md/raid5.c                  |   15 ++++---
 include/linux/async_tx.h            |    5 ++
 include/linux/dmaengine.h           |    4 --
 5 files changed, 75 insertions(+), 29 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 9e62fef..3cecb49 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -30,24 +30,11 @@
 #include <linux/dma-mapping.h>
 #include <linux/async_tx.h>
 
-/**
- * async_memcpy - attempt to copy memory with a dma engine.
- * @dest: destination page
- * @src: src page
- * @dest_offset: offset into 'dest' to start transaction
- * @src_offset: offset into 'src' to start transaction
- * @len: length in bytes
- * @submit: submission / completion modifiers
- *
- * honored flags: ASYNC_TX_ACK
- */
-struct dma_async_tx_descriptor *
-async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
-	     unsigned int src_offset, size_t len,
-	     struct async_submit_ctl *submit)
+static struct dma_async_tx_descriptor *
+__async_memcpy(struct dma_chan *chan, struct page *dest, struct page *src,
+	       unsigned int dest_offset, unsigned int src_offset, size_t len,
+	       struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMCPY,
-						      &dest, 1, &src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
@@ -98,8 +85,63 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	return tx;
 }
+
+/**
+ * async_memcpy - attempt to copy memory with a dma engine.
+ * @dest: destination page
+ * @src: src page
+ * @dest_offset: offset into 'dest' to start transaction
+ * @src_offset: offset into 'src' to start transaction
+ * @len: length in bytes
+ * @submit: submission / completion modifiers
+ *
+ * The function will grab any channel that has DMA_MEMCPY cap. This allows
+ * generic DMA memcpy without having to worry about channel switch issues.
+ */
+struct dma_async_tx_descriptor *
+async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
+	     unsigned int src_offset, size_t len,
+	     struct async_submit_ctl *submit)
+{
+	struct dma_chan *chan;
+	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
+
+	if (depend_tx &&
+	    dma_has_cap(DMA_MEMCPY, depend_tx->chan->device->cap_mask))
+		chan = depend_tx->chan;
+	else
+		chan = dma_find_channel(DMA_MEMCPY);
+
+	return __async_memcpy(chan, dest, src, dest_offset, src_offset,
+			      len, submit);
+}
 EXPORT_SYMBOL_GPL(async_memcpy);
 
+
+/**
+ * async_raid_memcpy - attempt to copy memory with a dma engine.
+ * @dest: destination page
+ * @src: src page
+ * @dest_offset: offset into 'dest' to start transaction
+ * @src_offset: offset into 'src' to start transaction
+ * @len: length in bytes
+ * @submit: submission / completion modifiers
+ *
+ * honored flags: ASYNC_TX_ACK
+ */
+struct dma_async_tx_descriptor *
+async_raid_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
+		  unsigned int src_offset, size_t len,
+		  struct async_submit_ctl *submit)
+{
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
+						      &dest, 1, &src, 1, len);
+
+	return __async_memcpy(chan, dest, src, dest_offset, src_offset,
+			      len, submit);
+}
+EXPORT_SYMBOL_GPL(async_raid_memcpy);
+
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous memcpy api");
 MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index a9f08a6..055cf63 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -208,7 +208,7 @@ __2data_recov_5(int disks, size_t bytes, int faila, int failb,
 	dq = blocks[failb];
 
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_memcpy(dp, g, 0, 0, bytes, submit);
+	tx = async_raid_memcpy(dp, g, 0, 0, bytes, submit);
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
 
@@ -464,7 +464,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
-		tx = async_memcpy(p, g, 0, 0, bytes, submit);
+		tx = async_raid_memcpy(p, g, 0, 0, bytes, submit);
 
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 24909eb..8779266 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -760,10 +760,11 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 			b_offset += bvl->bv_offset;
 			bio_page = bvl->bv_page;
 			if (frombio)
-				tx = async_memcpy(page, bio_page, page_offset,
-						  b_offset, clen, &submit);
+				tx = async_raid_memcpy(page, bio_page,
+						       page_offset, b_offset,
+						       clen, &submit);
 			else
-				tx = async_memcpy(bio_page, page, b_offset,
+				tx = async_raid_memcpy(bio_page, page, b_offset,
 						  page_offset, clen, &submit);
 		}
 		/* chain the operations */
@@ -915,7 +916,8 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
 			  ops_complete_compute, sh, to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
+		tx = async_raid_memcpy(xor_dest, xor_srcs[0], 0, 0,
+				       STRIPE_SIZE, &submit);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
@@ -1302,7 +1304,8 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
 			  to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
+		tx = async_raid_memcpy(xor_dest, xor_srcs[0], 0, 0,
+				       STRIPE_SIZE, &submit);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 }
@@ -3211,7 +3214,7 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 
 			/* place all the copies on one channel */
 			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
-			tx = async_memcpy(sh2->dev[dd_idx].page,
+			tx = async_raid_memcpy(sh2->dev[dd_idx].page,
 					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
 					  &submit);
 
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index a1c486a..ce9be3d 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -183,6 +183,11 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	     struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
+async_raid_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
+		  unsigned int src_offset, size_t len,
+		  struct async_submit_ctl *submit);
+
+struct dma_async_tx_descriptor *
 async_memset(struct page *dest, int val, unsigned int offset,
 	     size_t len, struct async_submit_ctl *submit);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index dd6d21b..acd739c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -820,11 +820,7 @@ static inline void net_dmaengine_put(void)
 #ifdef CONFIG_ASYNC_TX_DMA
 #define async_dmaengine_get()	dmaengine_get()
 #define async_dmaengine_put()	dmaengine_put()
-#ifndef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
-#define async_dma_find_channel(type) dma_find_channel(DMA_ASYNC_TX)
-#else
 #define async_dma_find_channel(type) dma_find_channel(type)
-#endif /* CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH */
 #else
 static inline void async_dmaengine_get(void)
 {

