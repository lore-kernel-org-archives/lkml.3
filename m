Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaHHUot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:44:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbaHHUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:44:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 158/259] block: don't assume last put of shared tags is for the host
Date: Fri,  8 Aug 2014 13:39:41 -0700
Message-Id: <1407530482-4483-159-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/blk-tag.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 3f33d86..a185b86 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -27,18 +27,15 @@ struct request *blk_queue_find_tag(struct request_queue *q, int tag)
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
 
@@ -50,9 +47,8 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
 
 		kfree(bqt);
 	}
-
-	return retval;
 }
+EXPORT_SYMBOL(blk_free_tags);
 
 /**
  * __blk_queue_free_tags - release tag maintenance info
@@ -69,28 +65,13 @@ void __blk_queue_free_tags(struct request_queue *q)
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
-- 
1.9.1

