Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaFRPWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:22:18 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47948 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaFRPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:21:19 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] block, blk-mq: draining can't be skipped even if bypass_depth was non-zero
Date: Wed, 18 Jun 2014 11:21:09 -0400
Message-Id: <1403104872-22236-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403104872-22236-1-git-send-email-tj@kernel.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, both blk_queeu_bypass_start() and blk_mq_freeze_queue()
skip queue draining if bypass_depth was already above zero.  The
assumption is that the one which bumped the bypass_depth should have
performed draining already; however, there's nothing which prevents a
new instance of bypassing/freezing from starting before the previous
one finishes draining.  The current code may allow the later
bypassing/freezing instances to complete while there still are
in-flight requests which haven't finished draining.

Fix it by draining regardless of bypass_depth.  We still skip draining
from blk_queue_bypass_start() while the queue is initializing to avoid
introducing excessive delays during boot.  INIT_DONE setting is moved
above the initial blk_queue_bypass_end() so that bypassing attempts
can't slip inbetween.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 block/blk-core.c  | 11 +++++++----
 block/blk-mq.c    |  7 ++-----
 block/blk-sysfs.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f6f6b9a..2375130 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -438,14 +438,17 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
  */
 void blk_queue_bypass_start(struct request_queue *q)
 {
-	bool drain;
-
 	spin_lock_irq(q->queue_lock);
-	drain = !q->bypass_depth++;
+	q->bypass_depth++;
 	queue_flag_set(QUEUE_FLAG_BYPASS, q);
 	spin_unlock_irq(q->queue_lock);
 
-	if (drain) {
+	/*
+	 * Queues start drained.  Skip actual draining till init is
+	 * complete.  This avoids lenghty delays during queue init which
+	 * can happen many times during boot.
+	 */
+	if (blk_queue_init_done(q)) {
 		spin_lock_irq(q->queue_lock);
 		__blk_drain_queue(q, false);
 		spin_unlock_irq(q->queue_lock);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1c09d57..c0122a4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -131,15 +131,12 @@ static void __blk_mq_drain_queue(struct request_queue *q)
  */
 static void blk_mq_freeze_queue(struct request_queue *q)
 {
-	bool drain;
-
 	spin_lock_irq(q->queue_lock);
-	drain = !q->bypass_depth++;
+	q->bypass_depth++;
 	queue_flag_set(QUEUE_FLAG_BYPASS, q);
 	spin_unlock_irq(q->queue_lock);
 
-	if (drain)
-		__blk_mq_drain_queue(q);
+	__blk_mq_drain_queue(q);
 }
 
 void blk_mq_drain_queue(struct request_queue *q)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 23321fb..4db5abf 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -554,8 +554,8 @@ int blk_register_queue(struct gendisk *disk)
 	 * Initialization must be complete by now.  Finish the initial
 	 * bypass from queue allocation.
 	 */
-	blk_queue_bypass_end(q);
 	queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
+	blk_queue_bypass_end(q);
 
 	ret = blk_trace_init_sysfs(dev);
 	if (ret)
-- 
1.9.3

