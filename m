Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3GaJiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:38:00 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40942 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3GaJh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:37:59 -0400
Message-ID: <1375263472.3922.26.camel@j-VirtualBox>
Subject: [RFC PATCH] sched: Reduce overestimating avg_idle
From: Jason Low <jason.low2@hp.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jason Low <jason.low2@hp.com>
Cc: KML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 31 Jul 2013 02:37:52 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The avg_idle value may sometimes be overestimated, which may cause new idle
load balance to be attempted more often than it should. Currently, when
avg_idle gets updated, if the delta exceeds some max value (default 1000000 ns),
the entire avg gets set to the max value, regardless of what the previous avg
was. So if a CPU remains idle for 200,000 ns most of the time, and if the CPU
goes idle for 1,200,000 ns, the average is then pushed up to 1,000,000 ns when
it should be less.

Additionally, once the avg_idle is at its max, it may take a while to pull the
avg down to a value that it should be. In the above example, after the avg idle
is set the max value of 1000000 ns, the CPU's idle durations needs to
be 200000 ns for the next 8 occurrences before the avg falls below the migration
cost value.

This patch attempts to avoid these situations by always updating the avg_idle
value first with the function call to update_avg(). Then, if the avg_idle
exceeds the max avg value, the avg gets set to the max. Also, this patch lowers
the max avg_idle value to migration_cost * 1.5 instead of migration_cost * 2 to
reduce the time it takes to pull the avg idle to a lower value after long idles.

With this change, I got some decent performance boosts in AIM7 workloads on an
8 socket machine on the 3.10 kernel. In particular, it boosted the AIM7 fserver
workload by about 20% when running it with a high # of users.

An avg_idle related question that I have is does migration_cost in idle balance
need to be the same as the migration_cost in task_hot()? Can we keep
migration_cost default value used in task_hot() the same, but have a different
default value or increase migration_cost only when comparing it with avg_idle in
idle balance?


Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b3350..62b484b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1341,12 +1341,12 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 
 	if (rq->idle_stamp) {
 		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
+		u64 max = (sysctl_sched_migration_cost * 3) / 2;
 
-		if (delta > max)
+		update_avg(&rq->avg_idle, delta);
+
+		if (rq->avg_idle > max)
 			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
 		rq->idle_stamp = 0;
 	}
 #endif
@@ -7026,7 +7026,7 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->online = 0;
 		rq->idle_stamp = 0;
-		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->avg_idle = (sysctl_sched_migration_cost * 3) / 2;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
-- 
1.7.1



