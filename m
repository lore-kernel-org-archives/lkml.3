Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaG3CLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:11:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaG3Bt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 04/21] block: dont assume last put of shared tags is for the host
Date: Tue, 29 Jul 2014 18:48:33 -0700
Message-Id: <20140730014830.618202475@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014830.424826215@linuxfoundation.org>
References: <20140730014830.424826215@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit d45b3279a5a2252cafcd665bbf2db8c9b31ef783 upstream.

There is no inherent reason why the last put of a tag structure must be
the one for the Scsi_Host, as device model objects can be held for
arbitrary periods.  Merge blk_free_tags and __blk_free_tags into a single
funtion that just release a references and get rid of the BUG() when the
host reference wasn't the last.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-tag.c |   33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -27,18 +27,15 @@ struct request *blk_queue_find_tag(struc
 EXPORT_SYMBOL(blk_queue_find_tag);
 
 /**
- * __blk_free_tags - release a given set of tag maintenance info
+ * blk_free_tags - release a given set of tag maintenance info
  * @bqt:	the tag map to free
  *
- * Tries to free the specified @bqt.  Returns true if it was
- * actually freed and false if there are still references using it
+ * Drop the reference count on @bqt and frees it when the last reference
+ * is dropped.
  */
-static int __blk_free_tags(struct blk_queue_tag *bqt)
+void blk_free_tags(struct blk_queue_tag *bqt)
 {
-	int retval;
-
-	retval = atomic_dec_and_test(&bqt->refcnt);
-	if (retval) {
+	if (atomic_dec_and_test(&bqt->refcnt)) {
 		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
 							bqt->max_depth);
 
@@ -50,9 +47,8 @@ static int __blk_free_tags(struct blk_qu
 
 		kfree(bqt);
 	}
-
-	return retval;
 }
+EXPORT_SYMBOL(blk_free_tags);
 
 /**
  * __blk_queue_free_tags - release tag maintenance info
@@ -69,28 +65,13 @@ void __blk_queue_free_tags(struct reques
 	if (!bqt)
 		return;
 
-	__blk_free_tags(bqt);
+	blk_free_tags(bqt);
 
 	q->queue_tags = NULL;
 	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
 }
 
 /**
- * blk_free_tags - release a given set of tag maintenance info
- * @bqt:	the tag map to free
- *
- * For externally managed @bqt frees the map.  Callers of this
- * function must guarantee to have released all the queues that
- * might have been using this tag map.
- */
-void blk_free_tags(struct blk_queue_tag *bqt)
-{
-	if (unlikely(!__blk_free_tags(bqt)))
-		BUG();
-}
-EXPORT_SYMBOL(blk_free_tags);
-
-/**
  * blk_queue_free_tags - release tag maintenance info
  * @q:  the request queue for the device
  *


