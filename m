Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3C0Wo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:44:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:48983 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab3C0Wo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,922,1355126400"; 
   d="scan'208";a="276881420"
Subject: [PATCH] async_tx: allow generic async_memcpy() not be effected by
 channel switch
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 15:44:25 -0700
Message-ID: <20130327224425.8912.19935.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic async_memcpy() for the DMA engines that cannot do channel
switch. Previously it would exclude all DMA engines that don't have all equal
capabilities for all ops with the DMA_ASYNC_TX check.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 crypto/async_tx/async_memcpy.c |   76 +++++++++++++++++++++++++++++++---------
 drivers/md/raid5.c             |   15 +++++---
 include/linux/async_tx.h       |    5 +++
 3 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 9e62fef..f9705f6 100644
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
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMCPY,
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
 

