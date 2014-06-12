Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaFLPEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbaFLPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:04:34 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Ming Lei <tom.leiming@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] blk-mq: bitmap tag: clean-up bt_get() function
Date: Thu, 12 Jun 2014 17:05:38 +0200
Message-Id: <350943ba66ede195df4a34ac7a499be305951c97.1402582256.git.agordeev@redhat.com>
In-Reply-To: <cover.1402582256.git.agordeev@redhat.com>
References: <cover.1402582256.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tag waiting loop in bt_get() function is a mystery for me:

	do {
		bool was_empty;

1.		was_empty = list_empty(&wait.task_list);
		prepare_to_wait(&bs->wait, &wait, TASK_UNINTERRUPTIBLE);

		tag = __bt_get(hctx, bt, last_tag);
		if (tag != -1)
			break;

2.		if (was_empty)
3.			atomic_set(&bs->wait_cnt, bt->wake_cnt);

		io_schedule();
	} while (1);

[1] list_empty(&wait.task_list) check is not protected;
[2] was_empty check is always true which results in *every* thread
    entering the loop resets bt_wait_state::wait_cnt counter rather
    than every bt->wake_cnt'th thread;
[3] 'bt_wait_state::wait_cnt' counter update seems redundant anyway,
    since it is also gets reset in bt_clear_tag() function;

Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c |   27 +++++++--------------------
 1 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 5579fae..dc1f684 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -224,7 +224,6 @@ static int bt_get(struct blk_mq_bitmap_tags *bt, struct blk_mq_hw_ctx *hctx,
 		  unsigned int *last_tag, gfp_t gfp)
 {
 	struct bt_wait_state *bs;
-	DEFINE_WAIT(wait);
 	int tag;
 
 	tag = __bt_get(hctx, bt, last_tag);
@@ -235,23 +234,9 @@ static int bt_get(struct blk_mq_bitmap_tags *bt, struct blk_mq_hw_ctx *hctx,
 		return -1;
 
 	bs = bt_wait_ptr(bt, hctx);
-	do {
-		bool was_empty;
-
-		was_empty = list_empty(&wait.task_list);
-		prepare_to_wait(&bs->wait, &wait, TASK_UNINTERRUPTIBLE);
-
-		tag = __bt_get(hctx, bt, last_tag);
-		if (tag != -1)
-			break;
+	___wait_event(bs->wait, (tag = __bt_get(hctx, bt, last_tag)) != -1,
+		      TASK_UNINTERRUPTIBLE, 0, 0, io_schedule());
 
-		if (was_empty)
-			atomic_set(&bs->wait_cnt, bt->wake_cnt);
-
-		io_schedule();
-	} while (1);
-
-	finish_wait(&bs->wait, &wait);
 	return tag;
 }
 
@@ -477,13 +462,15 @@ static int bt_alloc(struct blk_mq_bitmap_tags *bt, unsigned int depth,
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < BT_WAIT_QUEUES; i++)
-		init_waitqueue_head(&bt->bs[i].wait);
-
 	bt->wake_cnt = BT_WAIT_BATCH;
 	if (bt->wake_cnt > depth / 4)
 		bt->wake_cnt = max(1U, depth / 4);
 
+	for (i = 0; i < BT_WAIT_QUEUES; i++) {
+		init_waitqueue_head(&bt->bs[i].wait);
+		atomic_set(&bt->bs[i].wait_cnt, bt->wake_cnt);
+	}
+
 	bt->depth = depth;
 	return 0;
 }
-- 
1.7.7.6

