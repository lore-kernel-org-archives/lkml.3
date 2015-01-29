Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbbA2MSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:18:00 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:64389 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbbA2MR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:17:57 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/2] blk-mq: release mq's kobjects in blk_release_queue()
Date: Thu, 29 Jan 2015 20:17:27 +0800
Message-Id: <1422533847-31726-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422533847-31726-1-git-send-email-ming.lei@canonical.com>
References: <1422533847-31726-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kobject memory inside blk-mq hctx/ctx shouldn't have been freed
before the kobject is released because driver core can access it freely
before its release.

We can't do that in all ctx/hctx/mq_kobj's release handler because
it can be run before blk_cleanup_queue().

Given mq_kobj shouldn't have been introduced, this patch simply moves
mq's release into blk_release_queue().

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c    |   29 ++++++++++++++++++++++-------
 block/blk-mq.h    |    2 ++
 block/blk-sysfs.c |    2 ++
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a880b6c..9b250da 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1644,10 +1644,8 @@ static void blk_mq_free_hw_queues(struct request_queue *q,
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
 
-	queue_for_each_hw_ctx(q, hctx, i) {
+	queue_for_each_hw_ctx(q, hctx, i)
 		free_cpumask_var(hctx->cpumask);
-		kfree(hctx);
-	}
 }
 
 static int blk_mq_init_hctx(struct request_queue *q,
@@ -1872,6 +1870,27 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	mutex_unlock(&set->tag_list_lock);
 }
 
+/*
+ * It is the actual release handler for mq, but we do it from
+ * request queue's release handler for avoiding use-after-free
+ * and headache because q->mq_kobj shouldn't have been introduced,
+ * but we can't group ctx/kctx kobj without it.
+ */
+void blk_mq_release(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+
+	/* hctx kobj stays in hctx */
+	queue_for_each_hw_ctx(q, hctx, i)
+		kfree(hctx);
+
+	kfree(q->queue_hw_ctx);
+
+	/* ctx kobj stays in queue_ctx */
+	free_percpu(q->queue_ctx);
+}
+
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 {
 	struct blk_mq_hw_ctx **hctxs;
@@ -2005,12 +2024,8 @@ void blk_mq_free_queue(struct request_queue *q)
 
 	percpu_ref_exit(&q->mq_usage_counter);
 
-	free_percpu(q->queue_ctx);
-	kfree(q->queue_hw_ctx);
 	kfree(q->mq_map);
 
-	q->queue_ctx = NULL;
-	q->queue_hw_ctx = NULL;
 	q->mq_map = NULL;
 
 	mutex_lock(&all_q_mutex);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 4f4f943..6a48c4c 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -62,6 +62,8 @@ extern void blk_mq_sysfs_unregister(struct request_queue *q);
 
 extern void blk_mq_rq_timed_out(struct request *req, bool reserved);
 
+void blk_mq_release(struct request_queue *q);
+
 /*
  * Basic implementation of sparser bitmap, allowing the user to spread
  * the bits over more cachelines.
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 935ea2a..faaf36a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -517,6 +517,8 @@ static void blk_release_queue(struct kobject *kobj)
 
 	if (!q->mq_ops)
 		blk_free_flush_queue(q->fq);
+	else
+		blk_mq_release(q);
 
 	blk_trace_shutdown(q);
 
-- 
1.7.9.5

