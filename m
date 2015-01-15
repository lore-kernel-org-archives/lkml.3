Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbbAOUIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:08:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31118 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbbAOUIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:08:54 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ming.lei@canonical.com, Sasha Levin <sasha.levin@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] blk-mq: free hctx only when the kobject is released
Date: Thu, 15 Jan 2015 15:08:38 -0500
Message-Id: <1421352518-27220-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When releasing hctx, we do not know that the embedded kobject has been
released until it's ->release() callback has been called. It is unsafe
to unconditionally free the underlying memory until the ->release()
callback has been called since it may cause use-after-free bugs.

In practice, this patch fixes a use-after-free when destroying devices
(encountered with loop devices, in my case).

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 block/blk-mq-sysfs.c |   11 ++++++++++-
 block/blk-mq.c       |    4 +---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 1630a20..83d4bd8 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -17,6 +17,15 @@ static void blk_mq_sysfs_release(struct kobject *kobj)
 {
 }
 
+static void blk_mq_hw_sysfs_release(struct kobject *kobj)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
+
+	kfree(hctx);
+}
+
 struct blk_mq_ctx_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct blk_mq_ctx *, char *);
@@ -324,7 +333,7 @@ static struct kobj_type blk_mq_ctx_ktype = {
 static struct kobj_type blk_mq_hw_ktype = {
 	.sysfs_ops	= &blk_mq_hw_sysfs_ops,
 	.default_attrs	= default_hw_ctx_attrs,
-	.release	= blk_mq_sysfs_release,
+	.release	= blk_mq_hw_sysfs_release,
 };
 
 static void blk_mq_unregister_hctx(struct blk_mq_hw_ctx *hctx)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 04caf9f..7701eb2 100644
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
-- 
1.7.10.4

