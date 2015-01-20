Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbbATDBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:01:07 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47264 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbATDBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:01:06 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] blk-mq: fix hctx/ctx kobject use-after-free
Date: Tue, 20 Jan 2015 11:00:56 +0800
Message-Id: <1421722856-6346-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kobject memory shouldn't have been freed before the kobject
is released because driver core can access it freely before its
release.

This patch frees hctx in its release callback. For ctx, they
share one single per-cpu variable which is associated with
the request queue, so free ctx in q->mq_kobj's release handler.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
(fix ctx kobjects)
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq-sysfs.c |   25 +++++++++++++++++++++++--
 block/blk-mq.c       |    6 +-----
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 1630a20..6774a0e 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -15,6 +15,26 @@
 
 static void blk_mq_sysfs_release(struct kobject *kobj)
 {
+	struct request_queue *q;
+
+	q = container_of(kobj, struct request_queue, mq_kobj);
+	free_percpu(q->queue_ctx);
+}
+
+static void blk_mq_ctx_release(struct kobject *kobj)
+{
+	struct blk_mq_ctx *ctx;
+
+	ctx = container_of(kobj, struct blk_mq_ctx, kobj);
+	kobject_put(&ctx->queue->mq_kobj);
+}
+
+static void blk_mq_hctx_release(struct kobject *kobj)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
+	kfree(hctx);
 }
 
 struct blk_mq_ctx_sysfs_entry {
@@ -318,13 +338,13 @@ static struct kobj_type blk_mq_ktype = {
 static struct kobj_type blk_mq_ctx_ktype = {
 	.sysfs_ops	= &blk_mq_sysfs_ops,
 	.default_attrs	= default_ctx_attrs,
-	.release	= blk_mq_sysfs_release,
+	.release	= blk_mq_ctx_release,
 };
 
 static struct kobj_type blk_mq_hw_ktype = {
 	.sysfs_ops	= &blk_mq_hw_sysfs_ops,
 	.default_attrs	= default_hw_ctx_attrs,
-	.release	= blk_mq_sysfs_release,
+	.release	= blk_mq_hctx_release,
 };
 
 static void blk_mq_unregister_hctx(struct blk_mq_hw_ctx *hctx)
@@ -355,6 +375,7 @@ static int blk_mq_register_hctx(struct blk_mq_hw_ctx *hctx)
 		return ret;
 
 	hctx_for_each_ctx(hctx, ctx, i) {
+		kobject_get(&q->mq_kobj);
 		ret = kobject_add(&ctx->kobj, &hctx->kobj, "cpu%u", ctx->cpu);
 		if (ret)
 			break;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 04caf9f..a39cc8d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1593,10 +1593,8 @@ static void blk_mq_free_hw_queues(struct request_queue *q,
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
 
-	queue_for_each_hw_ctx(q, hctx, i) {
+	queue_for_each_hw_ctx(q, hctx, i)
 		free_cpumask_var(hctx->cpumask);
-		kfree(hctx);
-	}
 }
 
 static int blk_mq_init_hctx(struct request_queue *q,
@@ -1955,11 +1953,9 @@ void blk_mq_free_queue(struct request_queue *q)
 
 	percpu_ref_exit(&q->mq_usage_counter);
 
-	free_percpu(q->queue_ctx);
 	kfree(q->queue_hw_ctx);
 	kfree(q->mq_map);
 
-	q->queue_ctx = NULL;
 	q->queue_hw_ctx = NULL;
 	q->mq_map = NULL;
 
-- 
1.7.9.5

