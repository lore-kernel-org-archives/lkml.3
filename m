Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965801Ab3GSHuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:50:21 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:14488 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965511Ab3GSHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:15 -0400
Message-ID: <1374220211.5447.9.camel@j-VirtualBox>
Subject: [RFC PATCH v2] sched: Limit idle_balance()
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
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Fri, 19 Jul 2013 00:50:11 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When idle balance is being used frequently, functions such as load_balance(),
update_sd_lb_stats(), tg_load_down(), and acquiring run queue locks can increase
time spent in the kernel by quite a bit. In addition to spending kernel time
in those functions, it may sometimes indirectly increase the % time spent
acquiring other kernel locks and also reduce % time spent completing user space
functions. For example, when running fserver at a high number of users on an
8 socket box with HT-enabled, a lot of time was spent on __read_lock_failed(),
__write_lock_failed(), update_sd_lb_stats(), tg_load_down(), ect... as reported
by perf. Once we reduce the rate at which idle_balance occurs, the percentage
time spent on those functions decreased, and the percentage of the time spent
in user space functions such as add_long() increased.

Below is a sample perf report on running fserver with high # of users when
idle_balance is allowed to run often:

    18.01%     reaim    [k] mspin_lock
    16.42%     reaim    [k] __read_lock_failed
    10.27%     reaim    [k] __write_lock_failed
     2.84%     reaim    [k] _raw_spin_lock
     2.42%     reaim    [k] mutex_spin_on_owner
     2.21%     reaim    [k] update_sd_lb_stats
     1.93%     reaim    [k] start_this_handle
     1.75%     reaim    [.] add_int
     1.74%     reaim    [.] add_long
     1.59%     reaim    [k] update_cfs_rq_blocked_load
     1.42%     reaim    [k] tg_load_down
     1.35%     swapper  [k] intel_idle
     1.22%     reaim    [.] div_long
     1.21%     reaim    [k] _raw_spin_lock_irqsave
     1.18%     reaim    [k] load_balance

Below is a perf report when we lower the rate at which idle_balance is attempted:

    14.84%     reaim    [k] mspin_lock
     7.03%     reaim    [.] add_int
     6.99%     reaim    [.] add_long
     4.49%     reaim    [.] div_long
     4.18%     reaim    [.] strncat
     3.98%     reaim    [.] string_rtns_1
     3.94%     reaim    [k] mutex_spin_on_owner
     3.27%     reaim    [.] add_short
     2.77%     reaim    [k] __read_lock_failed
     1.77%     swapper  [k] intel_idle
     1.69%     reaim    [.] msort_with_tmp
     1.69%     reaim    [.] div_short
     1.66%     reaim    [.] div_int
     1.49%     reaim    [.] _int_malloc
     1.23%     reaim    [k] __write_lock_failed

However, this may not necessarily mean we should remove or permanently lower
the rate at which idle balance may be attempted. If a CPU remains idle a lot
longer than the overhead for doing idle balance, then we should allow it.

This patch attempts to keep track of each CPU's "approximate" average idle
time and the average cost of attempting each load_balance per sched domain.
Load balancing gets skipped if the approximate cost of load balancing will
be greater than N% of the approximate time the CPU remains idle. Currently,
N is set to 10% though I'm searching for a more "ideal" way to compute this.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 arch/metag/include/asm/topology.h |    1 +
 include/linux/sched.h             |    1 +
 include/linux/topology.h          |    3 +++
 kernel/sched/core.c               |    3 +++
 kernel/sched/debug.c              |    1 +
 kernel/sched/fair.c               |   19 +++++++++++++++++++
 kernel/sched/sched.h              |    4 ++++
 7 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 23f5118..8f0ebeb 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -26,6 +26,7 @@
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
+	.avg_idle_balance_cost	= 0,			\
 }
 
 #define cpu_to_node(cpu)	((void)(cpu), 0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..1eb94c2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -809,6 +809,7 @@ struct sched_domain {
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
+	u64 avg_idle_balance_cost;
 
 	int nohz_idle;			/* NOHZ IDLE status */
 	int flags;			/* See SD_* */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..59ee2e8 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -106,6 +106,7 @@ int arch_update_cpu_topology(void);
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.smt_gain		= 1178,	/* 15% */			\
+	.avg_idle_balance_cost	= 0,					\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -135,6 +136,7 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.avg_idle_balance_cost	= 0,					\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -166,6 +168,7 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.avg_idle_balance_cost	= 0,					\
 }
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b3350..da2cb3e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1348,6 +1348,8 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 		else
 			update_avg(&rq->avg_idle, delta);
 		rq->idle_stamp = 0;
+
+		rq->idle_duration = (rq->idle_duration + delta) / 2;
 	}
 #endif
 }
@@ -7027,6 +7029,7 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->idle_duration = 0;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 75024a6..a3f062c 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -307,6 +307,7 @@ do {									\
 	P(sched_goidle);
 #ifdef CONFIG_SMP
 	P64(avg_idle);
+	P64(idle_duration);
 #endif
 
 	P(ttwu_count);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..da7ddd6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5240,6 +5240,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
+	u64 cost = 0;
+	u64 idle_duration = this_rq->idle_duration;
 
 	this_rq->idle_stamp = this_rq->clock;
 
@@ -5256,14 +5258,31 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
+		u64 this_domain_balance_cost = 0;
+		u64 start_time;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
+		/*
+		 * If the time which this_cpu remains is not lot higher than the cost
+		 * of attempt idle balancing within this domain, then stop searching.
+		 */
+		if (idle_duration / 10 < (sd->avg_idle_balance_cost + cost))
+			break;
+
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
+			start_time = sched_clock_cpu(smp_processor_id());
+
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
 						   sd, CPU_NEWLY_IDLE, &balance);
+
+			this_domain_balance_cost = sched_clock_cpu(smp_processor_id()) - start_time;
+
+			sd->avg_idle_balance_cost =
+				(sd->avg_idle_balance_cost + this_domain_balance_cost) / 2;
+			cost += this_domain_balance_cost;
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ce39224..6a7e620 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -521,6 +521,10 @@ struct rq {
 #endif
 
 	struct sched_avg avg;
+
+#ifdef CONFIG_SMP
+	u64 idle_duration;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
-- 
1.7.1



