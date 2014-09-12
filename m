Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaILOsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:48:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53586 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaILOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:47:58 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 4/9] block: avoid to use q->flush_rq directly
Date: Fri, 12 Sep 2014 22:47:28 +0800
Message-Id: <1410533253-8045-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch trys to use local variable to access flush request,
so that we can convert to per-queue flush machinery a bit easier.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index a5b2a00..a59dd1a 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -225,7 +225,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 
 	if (q->mq_ops) {
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
-		q->flush_rq->tag = -1;
+		flush_rq->tag = -1;
 	}
 
 	running = &q->flush_queue[q->flush_running_idx];
@@ -283,6 +283,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
 	struct request *first_rq =
 		list_first_entry(pending, struct request, flush.list);
+	struct request *flush_rq = q->flush_rq;
 
 	/* C1 described at the top of this file */
 	if (q->flush_pending_idx != q->flush_running_idx || list_empty(pending))
@@ -300,16 +301,16 @@ static bool blk_kick_flush(struct request_queue *q)
 	 */
 	q->flush_pending_idx ^= 1;
 
-	blk_rq_init(q, q->flush_rq);
+	blk_rq_init(q, flush_rq);
 	if (q->mq_ops)
-		blk_mq_clone_flush_request(q->flush_rq, first_rq);
+		blk_mq_clone_flush_request(flush_rq, first_rq);
 
-	q->flush_rq->cmd_type = REQ_TYPE_FS;
-	q->flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
-	q->flush_rq->rq_disk = first_rq->rq_disk;
-	q->flush_rq->end_io = flush_end_io;
+	flush_rq->cmd_type = REQ_TYPE_FS;
+	flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	flush_rq->rq_disk = first_rq->rq_disk;
+	flush_rq->end_io = flush_end_io;
 
-	return blk_flush_queue_rq(q->flush_rq, false);
+	return blk_flush_queue_rq(flush_rq, false);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
-- 
1.7.9.5

