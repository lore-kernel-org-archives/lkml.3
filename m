Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaFRPVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:21:49 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:56132 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFRPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:21:22 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] blk-mq: collapse __blk_mq_drain_queue() into blk_mq_freeze_queue()
Date: Wed, 18 Jun 2014 11:21:11 -0400
Message-Id: <1403104872-22236-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403104872-22236-1-git-send-email-tj@kernel.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping __blk_mq_drain_queue() as a separate function doesn't buy us
anything and it's gonna be further simplified.  Let's flatten it into
its caller.

This patch doesn't make any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 block/blk-mq.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f49b2ab..eda78c8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -108,8 +108,16 @@ static void blk_mq_queue_exit(struct request_queue *q)
 	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
 }
 
-static void __blk_mq_drain_queue(struct request_queue *q)
+/*
+ * Guarantee no request is in use, so we can change any data structure of
+ * the queue afterward.
+ */
+void blk_mq_freeze_queue(struct request_queue *q)
 {
+	spin_lock_irq(q->queue_lock);
+	q->mq_freeze_depth++;
+	spin_unlock_irq(q->queue_lock);
+
 	while (true) {
 		s64 count;
 
@@ -124,19 +132,6 @@ static void __blk_mq_drain_queue(struct request_queue *q)
 	}
 }
 
-/*
- * Guarantee no request is in use, so we can change any data structure of
- * the queue afterward.
- */
-void blk_mq_freeze_queue(struct request_queue *q)
-{
-	spin_lock_irq(q->queue_lock);
-	q->mq_freeze_depth++;
-	spin_unlock_irq(q->queue_lock);
-
-	__blk_mq_drain_queue(q);
-}
-
 static void blk_mq_unfreeze_queue(struct request_queue *q)
 {
 	bool wake = false;
-- 
1.9.3

