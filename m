Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbaFLPEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:04:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbaFLPEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:04:31 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Ming Lei <tom.leiming@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] blk-mq: bitmap tag: fix races on shared ::wake_index fields
Date: Thu, 12 Jun 2014 17:05:36 +0200
Message-Id: <eaf7c751892ace09874d1d870284b965195bd703.1402582256.git.agordeev@redhat.com>
In-Reply-To: <cover.1402582256.git.agordeev@redhat.com>
References: <cover.1402582256.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix racy updates of shared blk_mq_bitmap_tags::wake_index
and blk_mq_hw_ctx::wake_index fields.

Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c     |   32 +++++++++++++++++++++-----------
 block/blk-mq-tag.h     |    2 +-
 include/linux/blk-mq.h |    2 +-
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c80086c..efe9419 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -39,9 +39,16 @@ bool blk_mq_has_free_tags(struct blk_mq_tags *tags)
 	return bt_has_free_tags(&tags->bitmap_tags);
 }
 
-static inline void bt_index_inc(unsigned int *index)
+static inline int bt_index_inc(int index)
 {
-	*index = (*index + 1) & (BT_WAIT_QUEUES - 1);
+	return (index + 1) & (BT_WAIT_QUEUES - 1);
+}
+
+static inline void bt_index_atomic_inc(atomic_t *index)
+{
+	int old = atomic_read(index);
+	int new = bt_index_inc(old);
+	atomic_cmpxchg(index, old, new);
 }
 
 /*
@@ -75,14 +82,14 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 	 * Will only throttle depth on non-reserved tags
 	 */
 	bt = &tags->bitmap_tags;
-	wake_index = bt->wake_index;
+	wake_index = atomic_read(&bt->wake_index);
 	for (i = 0; i < BT_WAIT_QUEUES; i++) {
 		struct bt_wait_state *bs = &bt->bs[wake_index];
 
 		if (waitqueue_active(&bs->wait))
 			wake_up(&bs->wait);
 
-		bt_index_inc(&wake_index);
+		wake_index = bt_index_inc(wake_index);
 	}
 }
 
@@ -202,12 +209,14 @@ static struct bt_wait_state *bt_wait_ptr(struct blk_mq_bitmap_tags *bt,
 					 struct blk_mq_hw_ctx *hctx)
 {
 	struct bt_wait_state *bs;
+	int wait_index;
 
 	if (!hctx)
 		return &bt->bs[0];
 
-	bs = &bt->bs[hctx->wait_index];
-	bt_index_inc(&hctx->wait_index);
+	wait_index = atomic_read(&hctx->wait_index);
+	bs = &bt->bs[wait_index];
+	bt_index_atomic_inc(&hctx->wait_index);
 	return bs;
 }
 
@@ -289,18 +298,19 @@ static struct bt_wait_state *bt_wake_ptr(struct blk_mq_bitmap_tags *bt)
 {
 	int i, wake_index;
 
-	wake_index = bt->wake_index;
+	wake_index = atomic_read(&bt->wake_index);
 	for (i = 0; i < BT_WAIT_QUEUES; i++) {
 		struct bt_wait_state *bs = &bt->bs[wake_index];
 
 		if (waitqueue_active(&bs->wait)) {
-			if (wake_index != bt->wake_index)
-				bt->wake_index = wake_index;
+			int o = atomic_read(&bt->wake_index);
+			if (wake_index != o)
+				atomic_cmpxchg(&bt->wake_index, o, wake_index);
 
 			return bs;
 		}
 
-		bt_index_inc(&wake_index);
+		wake_index = bt_index_inc(wake_index);
 	}
 
 	return NULL;
@@ -320,7 +330,7 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 	bs = bt_wake_ptr(bt);
 	if (bs && atomic_dec_and_test(&bs->wait_cnt)) {
 		atomic_set(&bs->wait_cnt, bt->wake_cnt);
-		bt_index_inc(&bt->wake_index);
+		bt_index_atomic_inc(&bt->wake_index);
 		wake_up(&bs->wait);
 	}
 }
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 0f5ec8b..96f13d7 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -27,7 +27,7 @@ struct blk_mq_bitmap_tags {
 	unsigned int map_nr;
 	struct blk_mq_bitmap *map;
 
-	unsigned int wake_index;
+	atomic_t wake_index;
 	struct bt_wait_state *bs;
 };
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 379f88d..9b86442 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -36,7 +36,7 @@ struct blk_mq_hw_ctx {
 	unsigned int		nr_ctx;
 	struct blk_mq_ctx	**ctxs;
 
-	unsigned int		wait_index;
+	atomic_t		wait_index;
 
 	struct blk_mq_tags	*tags;
 
-- 
1.7.7.6

