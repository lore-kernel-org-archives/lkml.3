Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaKZApW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:45:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:59901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaKZApO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:45:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,459,1413270000"; 
   d="scan'208";a="628294337"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v6 3/7] sched/deadline: fix dl entity is still mark yield after replenishing
Date: Wed, 26 Nov 2014 08:44:03 +0800
Message-Id: <1416962647-76792-4-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yield task semantic for deadline task is get off from the CPU until our next
instance, we mark the task got to sleep until its current deadline by forcing
its runtime to zero and update_curr_dl() stops it and the bandwidth timer will
wake it up and will give it new scheduling parameters.

Bandwidth timer may fail to start in update_curr_dl() and instead replenishing
the budget immediately, however, dl_yielded of dl_se is cleared when bandwidth
timer fire, the immediate replenishing miss to reset it.

This patch fix it by resetting the dl_yielded flag after the immediate replenishing
if fail to start bandwidth timer.

Cc: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2d982ce..b102f35 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -633,8 +633,11 @@ static void update_curr_dl(struct rq *rq)
 		__dequeue_task_dl(rq, curr, 0);
 		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
 			dl_se->dl_throttled = 1;
-		else
+		else {
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
+			if (unlikely(dl_se->dl_yielded))
+				dl_se->dl_yielded = 0;
+		}
 
 		if (!is_leftmost(curr, &rq->dl))
 			resched_curr(rq);
-- 
1.9.1

