Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbaDXROi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:14:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:22613 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758599AbaDXROh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:14:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,920,1389772800"; 
   d="scan'208";a="499095573"
Subject: [PATCH v2] sched: Skip double execution of pick_next_task_fair
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Apr 2014 10:14:34 -0700
Message-ID: <1398359674.2970.81.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code will call pick_next_task_fair a second time in the
slow path if we did not pull any task in our first try.  This is really
unnecessary as we already know no task can be pulled and it doubles the
delay for the cpu to enter idle.

We instrumented some network workloads and saw that pick_next_task_fair
was called frequently before a cpu entered idle.  The call to
pick_next_task_fair can add non trivial latency as it calls load_balance
which runs find_busiest_group on an hierachy of sched domains spanning
the cpus.  For a large 4 socket system, we saw almost 0.25 msec spent
per call of pick_next_task_fair before a cpu can be idled.

This patch skips pick_next_task_fair in the slow path if it has already
been invoked.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1d1b87b..547ccff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2591,8 +2591,14 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 	if (likely(prev->sched_class == class &&
 		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
-		if (likely(p && p != RETRY_TASK))
-			return p;
+		if (unlikely(p == RETRY_TASK))
+			goto again;
+
+		/* assumes fair_sched_class->next == idle_sched_class */
+		if (unlikely(!p))
+			p = idle_sched_class.pick_next_task(rq, prev);
+
+		return p;
 	}
 
 again:
-- 
1.7.11.7


