Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaG3MUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36788 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 80/94] block: don't assume last put of shared tags is for the host
Date: Wed, 30 Jul 2014 14:15:09 +0200
Message-Id: <b786221fb1e1c1664140d49a46b4bf844afc272c.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d45b3279a5a2252cafcd665bbf2db8c9b31ef783 upstream.

There is no inherent reason why the last put of a tag structure must be
the one for the Scsi_Host, as device model objects can be held for
arbitrary periods.  Merge blk_free_tags and __blk_free_tags into a single
funtion that just release a references and get rid of the BUG() when the
host reference wasn't the last.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 block/blk-tag.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 3f33d8672268..a185b86741e5 100644
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
2.0.1

