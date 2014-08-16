Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaHPMC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 08:02:29 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:61530 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaHPMC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 08:02:28 -0400
Date: Sat, 16 Aug 2014 08:02:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: blk_mq_freeze_queue() should allow nesting
Message-ID: <20140816120224.GB9305@htj.dyndns.org>
References: <1408115792-3311-1-git-send-email-ming.lei@canonical.com>
 <53EE534F.2040208@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EE534F.2040208@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While converting to percpu_ref for freezing, add703fda981 ("blk-mq:
use percpu_ref for mq usage count") incorrectly made
blk_mq_freeze_queue() misbehave when freezing is nested due to
percpu_ref_kill() being invoked on an already killed ref.

Fix it by making blk_mq_freeze_queue() kill and kick the queue only
for the outermost freeze attempt.  All the nested ones can simply wait
for the ref to reach zero.

While at it, remove unnecessary @wake initialization from
blk_mq_unfreeze_queue().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ming Lei <ming.lei@canonical.com>
---
Hello, Ming, Jens.

I think something like this is the correct solution.  Freezing should
be nestable after all.  Ming, can you please verify whether this fixes
the issue you're seeing?

Thanks.

 block/blk-mq.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5189cb1..5978088 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -112,18 +112,22 @@ static void blk_mq_usage_counter_release(struct percpu_ref *ref)
  */
 void blk_mq_freeze_queue(struct request_queue *q)
 {
+	bool freeze;
+
 	spin_lock_irq(q->queue_lock);
-	q->mq_freeze_depth++;
+	freeze = !q->mq_freeze_depth++;
 	spin_unlock_irq(q->queue_lock);
 
-	percpu_ref_kill(&q->mq_usage_counter);
-	blk_mq_run_queues(q, false);
+	if (freeze) {
+		percpu_ref_kill(&q->mq_usage_counter);
+		blk_mq_run_queues(q, false);
+	}
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));
 }
 
 static void blk_mq_unfreeze_queue(struct request_queue *q)
 {
-	bool wake = false;
+	bool wake;
 
 	spin_lock_irq(q->queue_lock);
 	wake = !--q->mq_freeze_depth;
