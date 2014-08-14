Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaHNPwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:52:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37356 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbaHNPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:52:04 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 4/9] blk-mq: introduce init_flush_rq_fn callback in 'blk_mq_ops'
Date: Thu, 14 Aug 2014 23:50:35 +0800
Message-Id: <1408031441-31156-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pdu of the flush rq is simlpy copied from another rq,
it isn't enough to initialize pointer field well, so introduce
the callback for driver to handle the case easily.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c         |    7 +++++++
 include/linux/blk-mq.h |   11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 07e1033..295cfc8d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -285,11 +285,18 @@ void blk_mq_clone_flush_request(struct request *flush_rq,
 {
 	struct blk_mq_hw_ctx *hctx =
 		orig_rq->q->mq_ops->map_queue(orig_rq->q, orig_rq->mq_ctx->cpu);
+	int ret = 0;
 
 	flush_rq->mq_ctx = orig_rq->mq_ctx;
 	flush_rq->tag = orig_rq->tag;
 	memcpy(blk_mq_rq_to_pdu(flush_rq), blk_mq_rq_to_pdu(orig_rq),
 		hctx->cmd_size);
+
+	if (orig_rq->q->mq_ops->init_flush_rq)
+		ret = orig_rq->q->mq_ops->init_flush_rq(
+				orig_rq->q->tag_set->driver_data,
+				orig_rq->q, flush_rq, orig_rq);
+	WARN_ON(ret);
 }
 
 inline void __blk_mq_end_io(struct request *rq, int error)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1cc1baa..df000d4 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -85,6 +85,8 @@ typedef int (init_request_fn)(void *, struct request *, unsigned int,
 		unsigned int, unsigned int);
 typedef void (exit_request_fn)(void *, struct request *, unsigned int,
 		unsigned int);
+typedef int (init_flush_rq_fn)(void *, struct request_queue *,
+		struct request *, const struct request *);
 
 struct blk_mq_ops {
 	/*
@@ -119,6 +121,15 @@ struct blk_mq_ops {
 	 */
 	init_request_fn		*init_request;
 	exit_request_fn		*exit_request;
+
+	/*
+	 * Called after the flush rq is cloned, pointer can't be
+	 * initialized well with simply memcpy(), so driver can
+	 * use the callback to reinitialize flush rq. The 3rd
+	 * parameter is the flush rq which has been cloned/copied
+	 * from another rq(the 4th parameter).
+	 */
+	init_flush_rq_fn	*init_flush_rq;
 };
 
 enum {
-- 
1.7.9.5

