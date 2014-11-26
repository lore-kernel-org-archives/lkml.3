Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaKZApL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:45:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:59901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaKZApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:45:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,459,1413270000"; 
   d="scan'208";a="628294303"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v6 1/7] sched/deadline: fix start high-res preemption tick for a non-leftmost task
Date: Wed, 26 Nov 2014 08:44:01 +0800
Message-Id: <1416962647-76792-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queued ticks are scheduled to match the budget, which means the budget
is overall consumed and the dl task should be throttled.

Dl task will be replenished immediately if fail to start a dl timer.
So the curr maybe not the left most dl task in the rb tree any more
after this immediately replenished since reschedule is needed.

The parameter of task_tick_dl() queued == 1 means that hrtick is fired.
hrtick() => task_tick_dl( , ,1), so p->dl.runtime should be <= 0 if
queued == 1. If replenished immediately(fail to start dl timer),
hrtick is start for task w/ queued == 1 && p->dl.runtime > 0 && p is
not the left most task.

Start high-res preemption tick for this upcoming rescheduled dl task
is not correct. This patch fix it by not starting high-res preemption
tick for a non-leftmost dl task.

Cc: Juri Lelli <juri.lelli@arm.com>
Acked-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * add a more explanatory changelog
 * add a comment just above the check

 kernel/sched/deadline.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 86d9a54..2d982ce 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1090,7 +1090,18 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
 {
 	update_curr_dl(rq);
 
-	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
+	/*
+	 * Queued tick means that hrtick is fired, when the budget is
+	 * consumed the task has to be throttled. However, task will
+	 * be replenished immediately if fail to start a dl timer, in
+	 * addition, the task maybe not the left most any more. Don't
+	 * start high-res preemption tick for the task who is not the
+	 * left most. The high-res preemption tick will be started for
+	 * this task just when it can be picked in pick_next_task_dl()
+	 * again.
+	 */
+	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0 &&
+	    is_leftmost(p, &rq->dl))
 		start_hrtick_dl(rq, p);
 }
 
-- 
1.9.1

