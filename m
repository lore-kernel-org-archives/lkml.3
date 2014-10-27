Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaJ0Bll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:41:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:12393 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaJ0Blj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:41:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="scan'208";a="621089515"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 2/6] sched/dl: fix yield task artificial overrun
Date: Mon, 27 Oct 2014 09:41:03 +0800
Message-Id: <1414374067-7209-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The yield semantic of deadline class is to reduce remaining runtime to 
zero, and then update_curr_dl() will stop it. However, comsumed bandwidth 
is reduced from the budget of yield task again even if it has already been 
set to zero which leads to artificial overrun. This patch fix it by reduce 
remaining runtime to zero if there is still remaining runtime after comsumed 
bandwidth is accumulated.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index abfaf3d..d4ffc1e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -568,7 +568,12 @@ static
 int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 {
 	int dmiss = dl_time_before(dl_se->deadline, rq_clock(rq));
-	int rorun = dl_se->runtime <= 0;
+	int rorun;
+
+	if (dl_se->dl_yielded && dl_se->runtime > 0)
+		dl_se->runtime = 0;
+
+	rorun = dl_se->runtime <= 0;
 
 	if (!rorun && !dmiss)
 		return 0;
@@ -897,10 +902,8 @@ static void yield_task_dl(struct rq *rq)
 	 * it and the bandwidth timer will wake it up and will give it
 	 * new scheduling parameters (thanks to dl_yielded=1).
 	 */
-	if (p->dl.runtime > 0) {
+	if (p->dl.runtime > 0)
 		rq->curr->dl.dl_yielded = 1;
-		p->dl.runtime = 0;
-	}
 	update_curr_dl(rq);
 }
 
-- 
1.9.1

