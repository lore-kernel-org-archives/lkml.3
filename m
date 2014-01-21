Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaAUQNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:13:04 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32980 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaAUQNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:13:02 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, pjt@google.com, bsegall@google.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched: fix sched_entity avg statistics update
Date: Tue, 21 Jan 2014 17:12:18 +0100
Message-Id: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current implementation, the load average statistics of a sched entity
change according to other activity on the CPU even if this activity is done
between the running window of the sched entity and have no influence on the
running duration of the task.

When a task wakes up on the same CPU, we currently update last_runnable_update
with the return  of __synchronize_entity_decay without updating the
runnable_avg_sum and runnable_avg_period accordingly. In fact, we have to sync
the load_contrib of the se with the rq's blocked_load_contrib before removing
it from the latter (with __synchronize_entity_decay) but we must keep
last_runnable_update unchanged for updating runnable_avg_sum/period during the
next update_entity_load_avg.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e64b079..5b0ef90 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2370,8 +2370,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		 * would have made count negative); we must be careful to avoid
 		 * double-accounting blocked time after synchronizing decays.
 		 */
-		se->avg.last_runnable_update += __synchronize_entity_decay(se)
-							<< 20;
+		__synchronize_entity_decay(se);
 	}
 
 	/* migrated tasks did not contribute to our blocked load */
-- 
1.7.9.5

