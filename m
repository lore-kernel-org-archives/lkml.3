Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaDWWcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:32:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:40192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaDWWcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:32:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,914,1389772800"; 
   d="scan'208";a="526638697"
Subject: [PATCH] sched: Skip double execution of pick_next_task_fair
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Apr 2014 15:31:57 -0700
Message-ID: <1398292317.2970.63.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code will call pick_next_task_fair a second time
in the slow path if we did not pull any task in our first try.
This is really unnecessary as we already know no task can
be pulled and it doubles the delay for the cpu to enter idle.

We instrumented some network workloads and that saw that
pick_next_task_fair is frequently called twice before a cpu enters idle.
The call to pick_next_task_fair can add
non trivial latency as it calls load_balance which runs find_busiest_group
on an hierarchy of sched domains spanning the cpus for a large system.  For
some 4 socket systems, we saw almost 0.25 msec spent per call
of pick_next_task_fair before a cpu can be idled.

This patch skips pick_next_task_fair in the slow path if it
has already been invoked.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1d1b87b..4053437 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2583,6 +2583,7 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 {
 	const struct sched_class *class = &fair_sched_class;
 	struct task_struct *p;
+	int skip_fair = 0;
 
 	/*
 	 * Optimization: we know that if all tasks are in
@@ -2591,12 +2592,17 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 	if (likely(prev->sched_class == class &&
 		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
-		if (likely(p && p != RETRY_TASK))
+		if (!p)
+			skip_fair = 1;
+		else if (likely(p != RETRY_TASK))
 			return p;
 	}
 
 again:
 	for_each_class(class) {
+		/* if we have already failed to pull fair task, skip */
+		if (class == &fair_sched_class && skip_fair)
+			continue;
 		p = class->pick_next_task(rq, prev);
 		if (p) {
 			if (unlikely(p == RETRY_TASK))
-- 
1.7.11.7


