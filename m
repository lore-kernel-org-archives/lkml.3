Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaLAABu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:01:50 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51298 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaLAABs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:01:48 -0500
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@fb.com
Subject: [PATCH] blk-mq: don't use rw_is_sync() to determine sync request
Date: Sun, 30 Nov 2014 16:01:39 -0800
Message-Id: <4f327fd4f830a3fceab3694cdd7621c37f780809.1417391999.git.shli@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffer read is counted as sync in rw_is_sync(). If we use it,
blk_sq_make_request() will not do per-process plug any more.

I haven't changed blk_mq_make_request() yet. It makes sense to dispatch
REQ_SYNC request immediately. But for buffer read, it's weird not to do
per-process plug, as buffer read doesn't need low latency.
blk_mq_merge_queue_io() isn't very helpful, as we don't have delay mechanism
there, the queue is immediately flushed, which makes the merge very
superficial.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 block/blk-mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d5b4643..0ccbfac 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1106,7 +1106,7 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	ctx = blk_mq_get_ctx(q);
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-	if (rw_is_sync(bio->bi_rw))
+	if (bio->bi_rw & REQ_SYNC)
 		rw |= REQ_SYNC;
 
 	trace_block_getrq(q, bio, rw);
@@ -1206,7 +1206,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
  */
 static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = !!(bio->bi_rw & REQ_SYNC);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	unsigned int use_plug, request_count = 0;
 	struct blk_map_ctx data;
-- 
1.8.3.2

