Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbbA2MRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:17:51 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:56482 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbbA2MRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:17:49 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/2] Revert "blk-mq: fix hctx/ctx kobject use-after-free"
Date: Thu, 29 Jan 2015 20:17:26 +0800
Message-Id: <1422533847-31726-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422533847-31726-1-git-send-email-ming.lei@canonical.com>
References: <1422533847-31726-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 76d697d10769048e5721510100bf3a9413a56385.

The commit 76d697d10769048 causes general protection fault
reported from Bart Van Assche:

	https://lkml.org/lkml/2015/1/28/334

Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq-sysfs.c |   25 ++-----------------------
 block/blk-mq.c       |    6 +++++-
 2 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 6774a0e..1630a20 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -15,26 +15,6 @@
 
 static void blk_mq_sysfs_release(struct kobject *kobj)
 {
-	struct request_queue *q;
-
-	q = container_of(kobj, struct request_queue, mq_kobj);
-	free_percpu(q->queue_ctx);
-}
-
-static void blk_mq_ctx_release(struct kobject *kobj)
-{
-	struct blk_mq_ctx *ctx;
-
-	ctx = container_of(kobj, struct blk_mq_ctx, kobj);
-	kobject_put(&ctx->queue->mq_kobj);
-}
-
-static void blk_mq_hctx_release(struct kobject *kobj)
-{
-	struct blk_mq_hw_ctx *hctx;
-
-	hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
-	kfree(hctx);
 }
 
 struct blk_mq_ctx_sysfs_entry {
@@ -338,13 +318,13 @@ static struct kobj_type blk_mq_ktype = {
 static struct kobj_type blk_mq_ctx_ktype = {
 	.sysfs_ops	= &blk_mq_sysfs_ops,
 	.default_attrs	= default_ctx_attrs,
-	.release	= blk_mq_ctx_release,
+	.release	= blk_mq_sysfs_release,
 };
 
 static struct kobj_type blk_mq_hw_ktype = {
 	.sysfs_ops	= &blk_mq_hw_sysfs_ops,
 	.default_attrs	= default_hw_ctx_attrs,
-	.release	= blk_mq_hctx_release,
+	.release	= blk_mq_sysfs_release,
 };
 
 static void blk_mq_unregister_hctx(struct blk_mq_hw_ctx *hctx)
@@ -375,7 +355,6 @@ static int blk_mq_register_hctx(struct blk_mq_hw_ctx *hctx)
 		return ret;
 
 	hctx_for_each_ctx(hctx, ctx, i) {
-		kobject_get(&q->mq_kobj);
 		ret = kobject_add(&ctx->kobj, &hctx->kobj, "cpu%u", ctx->cpu);
 		if (ret)
 			break;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 51ce53d..a880b6c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1644,8 +1644,10 @@ static void blk_mq_free_hw_queues(struct request_queue *q,
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
 
-	queue_for_each_hw_ctx(q, hctx, i)
+	queue_for_each_hw_ctx(q, hctx, i) {
 		free_cpumask_var(hctx->cpumask);
+		kfree(hctx);
+	}
 }
 
 static int blk_mq_init_hctx(struct request_queue *q,
@@ -2003,9 +2005,11 @@ void blk_mq_free_queue(struct request_queue *q)
 
 	percpu_ref_exit(&q->mq_usage_counter);
 
+	free_percpu(q->queue_ctx);
 	kfree(q->queue_hw_ctx);
 	kfree(q->mq_map);
 
+	q->queue_ctx = NULL;
 	q->queue_hw_ctx = NULL;
 	q->mq_map = NULL;
 
-- 
1.7.9.5

