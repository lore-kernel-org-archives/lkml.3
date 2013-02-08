Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab3BHHLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:11:11 -0500
Received: from relay.parallels.com ([195.214.232.42]:43737 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab3BHHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:11:10 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: initialize runtime to non-zero on cfs bw set
Date: Fri, 8 Feb 2013 11:10:46 +0400
Message-ID: <1360307446-26978-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.22.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cfs_rq->runtime_remaining is <= 0 then either
- cfs_rq is throttled and waiting for quota redistribution, or
- cfs_rq is currently executing and will be throttled on
  put_prev_entity, or
- cfs_rq is not throttled and has not executed since its quota was set
  (runtime_remaining is set to 0 on cfs bandwidth reconfiguration).

It is obvious that the last case is rather an exception from the rule
"runtime_remaining<=0 iff cfs_rq is throttled or will be throttled as
soon as it finishes its execution". Moreover, it can lead to a task hang
as follows. If put_prev_task is called immediately after first
pick_next_task after quota was set, "immediately" meaning rq->clock in
both functions is the same, then the corresponding cfs_rq will be
throttled. Besides being unfair (the cfs_rq has not executed in fact),
the quota refilling timer can be idle at that time and it won't be
activated on put_prev_task because update_curr calls
account_cfs_rq_runtime, which activates the timer, only if delta_exec is
strictly positive. As a result we can get a task "running" inside a
throttled cfs_rq which will probably never be unthrottled.

To avoid the problem, the patch makes tg_set_cfs_bandwidth initialize
runtime_remaining of each cfs_rq to 1 instead of 0 so that the cfs_rq
will be throttled only if it has executed for some positive number of
nanoseconds.
--
Several times we had our customers encountered such hangs inside a VM
(seems something is wrong or rather different in time accounting there).
Analyzing crash dumps revealed that hung tasks were running inside
cfs_rq's, which had the following setup

cfs_rq->throttled=1
cfs_rq->runtime_enabled=1
cfs_rq->runtime_remaining=0
cfs_rq->tg->cfs_bandwidth.idle=1
cfs_rq->tg->cfs_bandwidth.timer_active=0

which conforms pretty nice to the explanation given above.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..c7a078f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7686,7 +7686,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = runtime_enabled;
-		cfs_rq->runtime_remaining = 0;
+		cfs_rq->runtime_remaining = 1;
 
 		if (cfs_rq->throttled)
 			unthrottle_cfs_rq(cfs_rq);
-- 
1.7.1

