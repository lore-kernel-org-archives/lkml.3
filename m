Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbaGWW5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:57:17 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63260 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaGWW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:57:12 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/9] blk-mq: introduce init_flush_rq_fn callback in 'blk_mq_ops'
Date: Thu, 24 Jul 2014 06:55:23 +0800
Message-Id: <1406156130-15575-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
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

