Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab3GPTVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:21:12 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:48038 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3GPTVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:21:11 -0400
Message-ID: <1374002463.3944.11.camel@j-VirtualBox>
Subject: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
From: Jason Low <jason.low2@hp.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jason Low <jason.low2@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 16 Jul 2013 12:21:03 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running benchmarks on an 8 socket 80 core machine with a 3.10 kernel,
there can be a lot of contention in idle_balance() and related functions.
On many AIM7 workloads in which CPUs go idle very often and idle balance
gets called a lot, it is actually lowering performance.

Since idle balance often helps performance (when it is not overused), I
looked into trying to avoid attempting idle balance only when it is
occurring too frequently.

This RFC patch attempts to keep track of the approximate "average" time between
idle balance attempts per CPU. Each time the idle_balance() function is
invoked, it will compute the duration since the last idle_balance() for
the current CPU. The avg time between idle balance attempts is then updated
using a very similar method as how rq->avg_idle is computed. 

Once the average time between idle balance attempts drops below a certain
value (which in this patch is sysctl_sched_idle_balance_limit), idle_balance
for that CPU will be skipped. The average time between idle balances will
continue to be updated, even if it ends up getting skipped. The
initial/maximum average is set a lot higher though to make sure that the
avg doesn't fall below the threshold until the sample size is large and to
prevent the avg from being overestimated.

This change improved the performance of many AIM7 workloads at 1, 2, 4, 8
sockets on the 3.10 kernel. The most significant differences were at
8 sockets HT-enabled. The table below compares the average jobs per minute
at 1100-2000 users between the vanilla 3.10 kernel and 3.10 kernel with this
patch. I included data for both hyperthreading disabled and enabled. I used
numactl to restrict AIM7 to run on certain number of nodes. I only included
data in which the % difference was beyond a 2% noise range.

--------------------------------------------------------------------------
			1 socket
--------------------------------------------------------------------------
workload	| HT-disabled	| HT-enabled	|
		| % improvement | % improvement	|
		| with patch	| with patch	|
--------------------------------------------------------------------------
disk		|   +17.7%	|   +4.7%	|
--------------------------------------------------------------------------
high_systime	|   +2.9%	|   -----	|
--------------------------------------------------------------------------


--------------------------------------------------------------------------
			2 sockets
--------------------------------------------------------------------------
workload	| HT-disabled	| HT-enabled	|
		| % improvement	| % improvement	|
		| with patch	| with patch	|
--------------------------------------------------------------------------
alltests	|   -----	|   +2.3%	|
--------------------------------------------------------------------------
disk		|   +10.5%	|   -----	|
--------------------------------------------------------------------------
fserver		|   +3.6%	|   -----	|
--------------------------------------------------------------------------
new_fserver	|   +3.7%	|   -----	|
--------------------------------------------------------------------------


--------------------------------------------------------------------------
			4 sockets
--------------------------------------------------------------------------
workload	| HT-disabled	| HT-enabled	|
		| % improvement | % improvement	|
		| with patch	| with patch	|
--------------------------------------------------------------------------
alltests	|   +3.7%	|   -----	|
--------------------------------------------------------------------------
custom		|   -2.2%	|   +14.0%	|
--------------------------------------------------------------------------
fserver		|   +2.8%	|   -----	|
--------------------------------------------------------------------------
high_systime	|   -3.6%	|   +18.7%	|
--------------------------------------------------------------------------
new_fserver	|   +3.4%	|   -----	|
--------------------------------------------------------------------------


--------------------------------------------------------------------------
			8 sockets
--------------------------------------------------------------------------
workload	| HT-disabled	| HT-enabled	|
		| % improvement | % improvement |
		| with patch	| with patch	|
--------------------------------------------------------------------------
alltests	|   +4.4%	|   +13.3%	|
--------------------------------------------------------------------------
custom		|   +8.1%	|   +15.2%	|
--------------------------------------------------------------------------
disk		|   -4.7%	|   +20.4%	|
--------------------------------------------------------------------------
fserver		|   +3.4%	|   +26.8%	|
--------------------------------------------------------------------------
high_systime	|   +11.7%	|   +14.7%	|
--------------------------------------------------------------------------
new_fserver	|   +3.7%	|   +16.0%	|
--------------------------------------------------------------------------
shared		|   -----	|   +10.1%	|
--------------------------------------------------------------------------

All other % difference results were within a 2% noise range.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/sched.h |    4 ++++
 kernel/sched/core.c   |    3 +++
 kernel/sched/fair.c   |   26 ++++++++++++++++++++++++++
 kernel/sched/sched.h  |    6 ++++++
 kernel/sysctl.c       |   11 +++++++++++
 5 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..5385c93 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1031,6 +1031,10 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_sched_idle_balance_limit;
+#endif
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b3350..320389f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7028,6 +7028,9 @@ void __init sched_init(void)
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 
+		rq->avg_time_between_ib = 20*sysctl_sched_idle_balance_limit;
+		rq->prev_idle_balance = 0;
+
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
 		rq_attach_root(rq, &def_root_domain);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..f5f5e4e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -34,6 +34,8 @@
 
 #include "sched.h"
 
+unsigned int sysctl_sched_idle_balance_limit = 5000000U;
+
 /*
  * Targeted preemption latency for CPU-bound tasks:
  * (default: 6ms * (1 + ilog(ncpus)), units: nanoseconds)
@@ -5231,6 +5233,23 @@ out:
 	return ld_moved;
 }
 
+#ifdef CONFIG_SMP
+/* Update average time between idle balance attempts this_rq */
+static inline void update_avg_time_between_ib(struct rq *this_rq)
+{
+	u64 time_since_last_ib = this_rq->clock - this_rq->prev_idle_balance;
+	u64 max_avg_idle_balance = 20*sysctl_sched_idle_balance_limit;
+	s64 diff;
+
+	if (time_since_last_ib > max_avg_idle_balance) {
+		this_rq->avg_time_between_ib = max_avg_idle_balance;
+	} else {
+		diff = time_since_last_ib - this_rq->avg_time_between_ib;
+		this_rq->avg_time_between_ib += (diff >> 3);
+	}
+}
+#endif
+
 /*
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
@@ -5246,6 +5265,13 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	update_avg_time_between_ib(this_rq);
+	this_rq->prev_idle_balance = this_rq->clock;
+
+	/* Skip idle balancing if avg time between attempts is small */
+	if (this_rq->avg_time_between_ib < sysctl_sched_idle_balance_limit)
+		return;
+
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ce39224..27d6752 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -521,6 +521,12 @@ struct rq {
 #endif
 
 	struct sched_avg avg;
+
+#ifdef CONFIG_SMP
+	/* stats for putting a limit on idle balancing */
+	u64 avg_time_between_ib;
+	u64 prev_idle_balance;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..35e5f86 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -436,6 +436,17 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 	},
 #endif
+#ifdef CONFIG_SMP
+       {
+               .procname       = "sched_idle_balance_limit",
+               .data           = &sysctl_sched_idle_balance_limit,
+               .maxlen         = sizeof(unsigned int),
+               .mode           = 0644,
+               .proc_handler   = proc_dointvec_minmax,
+               .extra1         =&zero,
+       },
+#endif
+
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
-- 
1.7.1



