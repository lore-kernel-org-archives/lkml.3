Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaKKBwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:52:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:14563 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaKKBwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,357,1413270000"; 
   d="scan'208";a="605658804"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 2/2] sched/deadline: fix start high-res preemption tick for a non-running task
Date: Tue, 11 Nov 2014 09:52:27 +0800
Message-Id: <1415670747-58726-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queued ticks are scheduled to match the budget, which means the budget 
is overall consumed and the dl task should be throttled. Dl task will 
be replenished immediately if fail to start a dl timer. 

However, the curr maybe not the left most dl task in the rb tree any 
more after this immediately replenished and reschedule is needed. 
Start high-res preemption tick for this upcoming rescheduled dl task 
is not correct. 

This patch fix it by not starting high-res preemption tick for a 
non-running dl task.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 56674f6..2a6a5bb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1090,7 +1090,8 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
 {
 	update_curr_dl(rq);
 
-	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
+	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0 &&
+	    is_leftmost(p, &rq->dl))
 		start_hrtick_dl(rq, p);
 }
 
-- 
1.9.1

