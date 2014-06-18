Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaFRPWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:22:37 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:40718 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaFRPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:21:18 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] blk-mq: fix a memory ordering bug in blk_mq_queue_enter()
Date: Wed, 18 Jun 2014 11:21:08 -0400
Message-Id: <1403104872-22236-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403104872-22236-1-git-send-email-tj@kernel.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk-mq uses a percpu_counter to keep track of how many usages are in
flight.  The percpu_counter is drained while freezing to ensure that
no usage is left in-flight after freezing is complete.

blk_mq_queue_enter/exit() and blk_mq_[un]freeze_queue() implement this
per-cpu gating mechanism; unfortunately, it contains a subtle bug -
smp_wmb() in blk_mq_queue_enter() doesn't prevent prevent the cpu from
fetching @q->bypass_depth before incrementing @q->mq_usage_counter and
if freezing happens inbetween the caller can slip through and freezing
can be complete while there are active users.

Use smp_mb() instead so that bypass_depth and mq_usage_counter
modifications and tests are properly interlocked.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4787c3d..1c09d57 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -81,7 +81,7 @@ static int blk_mq_queue_enter(struct request_queue *q)
 	int ret;
 
 	__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
-	smp_wmb();
+	smp_mb();
 
 	/* we have problems freezing the queue if it's initializing */
 	if (!blk_queue_dying(q) &&
-- 
1.9.3

