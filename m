Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820AbaJ3OSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:18:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:61820 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760141AbaJ3OS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:18:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,286,1413270000"; 
   d="scan'208";a="628327835"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2 2/6] sched/deadline: fix artificial overrun introduced by yield_task_dl
Date: Thu, 30 Oct 2014 22:16:59 +0800
Message-Id: <1414678623-13576-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414678623-13576-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414678623-13576-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The yield semantic of deadline class is to reduce remaining runtime to 
zero, and then update_curr_dl() will stop it. However, comsumed bandwidth 
is reduced from the budget of yield task again even if it has already been 
set to zero which leads to artificial overrun. This patch fix it by make 
sure we don't steal some more time from the task that yielded in update_curr_dl().

Suggested-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * make sure we don't steal some more time from the task 
   that yielded in update_curr_dl().

 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2e31a30..db6ad38 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -633,7 +633,7 @@ static void update_curr_dl(struct rq *rq)
 
 	sched_rt_avg_update(rq, delta_exec);
 
-	dl_se->runtime -= delta_exec;
+	dl_se->runtime -= dl_se->dl_yielded ? 0 : delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
 		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
-- 
1.9.1

