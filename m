Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaEaQn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 12:43:59 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:36357 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaEaQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 12:43:55 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] blk-mq: move blk_mq_get_ctx/blk_mq_put_ctx to mq private header
Date: Sun,  1 Jun 2014 00:43:36 +0800
Message-Id: <1401554617-10099-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401554617-10099-1-git-send-email-tom.leiming@gmail.com>
References: <1401554617-10099-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk-mq tag code need these helpers.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |   22 ----------------------
 block/blk-mq.h |   22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0f5879c..b9230c5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -33,28 +33,6 @@ static LIST_HEAD(all_q_list);
 
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx);
 
-static struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
-					   unsigned int cpu)
-{
-	return per_cpu_ptr(q->queue_ctx, cpu);
-}
-
-/*
- * This assumes per-cpu software queueing queues. They could be per-node
- * as well, for instance. For now this is hardcoded as-is. Note that we don't
- * care about preemption, since we know the ctx's are persistent. This does
- * mean that we can't rely on ctx always matching the currently running CPU.
- */
-static struct blk_mq_ctx *blk_mq_get_ctx(struct request_queue *q)
-{
-	return __blk_mq_get_ctx(q, get_cpu());
-}
-
-static void blk_mq_put_ctx(struct blk_mq_ctx *ctx)
-{
-	put_cpu();
-}
-
 /*
  * Check if any of the ctx's have pending work in this hardware queue
  */
diff --git a/block/blk-mq.h b/block/blk-mq.h
index de7b3bb..57a7968 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -69,4 +69,26 @@ struct blk_align_bitmap {
 	unsigned long depth;
 } ____cacheline_aligned_in_smp;
 
+static inline struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
+					   unsigned int cpu)
+{
+	return per_cpu_ptr(q->queue_ctx, cpu);
+}
+
+/*
+ * This assumes per-cpu software queueing queues. They could be per-node
+ * as well, for instance. For now this is hardcoded as-is. Note that we don't
+ * care about preemption, since we know the ctx's are persistent. This does
+ * mean that we can't rely on ctx always matching the currently running CPU.
+ */
+static inline struct blk_mq_ctx *blk_mq_get_ctx(struct request_queue *q)
+{
+	return __blk_mq_get_ctx(q, get_cpu());
+}
+
+static inline void blk_mq_put_ctx(struct blk_mq_ctx *ctx)
+{
+	put_cpu();
+}
+
 #endif
-- 
1.7.9.5

