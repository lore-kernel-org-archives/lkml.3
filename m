Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaH3QJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:09:40 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60780 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaH3QJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:09:38 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 2/6] blk-mq: introduce prepare_flush_rq_fn callback and its pair
Date: Sun, 31 Aug 2014 00:08:23 +0800
Message-Id: <1409414907-22238-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
References: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pdu of the flush rq is simlpy copied from another rq,
it isn't enough to initialize pointer field well, so introduce
these two callbacks for driver to handle the case easily.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c      |    4 ++++
 block/blk-mq.c         |   12 ++++++++++--
 include/linux/blk-mq.h |   12 ++++++++++++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3cb5e9e..cd36596 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -225,6 +225,10 @@ static void flush_end_io(struct request *flush_rq, int error)
 
 	if (q->mq_ops) {
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
+		if (q->mq_ops->unprepare_flush_rq)
+			q->mq_ops->unprepare_flush_rq(
+				q->tag_set->driver_data,
+				q, q->flush_rq);
 		q->flush_rq->tag = -1;
 	}
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ad7524..4a610d2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -291,11 +291,19 @@ void blk_mq_clone_flush_request(struct request *flush_rq,
 {
 	struct blk_mq_hw_ctx *hctx =
 		orig_rq->q->mq_ops->map_queue(orig_rq->q, orig_rq->mq_ctx->cpu);
+	int ret = 0;
 
 	flush_rq->mq_ctx = orig_rq->mq_ctx;
 	flush_rq->tag = orig_rq->tag;
-	memcpy(blk_mq_rq_to_pdu(flush_rq), blk_mq_rq_to_pdu(orig_rq),
-		hctx->cmd_size);
+
+	if (orig_rq->q->mq_ops->prepare_flush_rq)
+		ret = orig_rq->q->mq_ops->prepare_flush_rq(
+				orig_rq->q->tag_set->driver_data,
+				orig_rq->q, flush_rq, orig_rq);
+	else
+		memcpy(blk_mq_rq_to_pdu(flush_rq),
+		       blk_mq_rq_to_pdu(orig_rq), hctx->cmd_size);
+	WARN_ON(ret);
 }
 
 inline void __blk_mq_end_io(struct request *rq, int error)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c6b2bfa..8935f34 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -85,6 +85,10 @@ typedef int (init_request_fn)(void *, struct request *, unsigned int,
 		unsigned int, unsigned int);
 typedef void (exit_request_fn)(void *, struct request *, unsigned int,
 		unsigned int);
+typedef int (prepare_flush_rq_fn)(void *, struct request_queue *,
+		struct request *, const struct request *);
+typedef void (unprepare_flush_rq_fn)(void *, struct request_queue *,
+		struct request *);
 
 struct blk_mq_ops {
 	/*
@@ -119,6 +123,14 @@ struct blk_mq_ops {
 	 */
 	init_request_fn		*init_request;
 	exit_request_fn		*exit_request;
+
+	/*
+	 * Called after flush request cloned by the block layer to allow
+	 * the driver to set up driver specific data, since simple memcpy
+	 * may not initialize flush req well.
+	 */
+	prepare_flush_rq_fn	*prepare_flush_rq;
+	unprepare_flush_rq_fn	*unprepare_flush_rq;
 };
 
 enum {
-- 
1.7.9.5

