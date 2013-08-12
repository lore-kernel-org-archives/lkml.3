Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3HLInA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:43:00 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:47726 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3HLIm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:42:57 -0400
Message-ID: <1376296970.1795.9.camel@j-VirtualBox>
Subject: [PATCH] sched: Give idle_balance() a break when it does not move
 tasks.
From: Jason Low <jason.low2@hp.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jason Low <jason.low2@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Bui, Tuan" <tuan.d.bui@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        "Makphaibulchoke, Thavatchai" <thavatchai.makpahibulchoke@hp.com>,
        "Bueso, Davidlohr" <davidlohr.bueso@hp.com>
Date: Mon, 12 Aug 2013 01:42:50 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running benchmarks on an 8 socket (80 core) machine, newidle load balance
was being attempted frequently, but no tasks were moved most of the time. The
most common reason was due to find_busiest_group returning NULL (for example,
groups were already balanced within domains). Another common reason was that
move tasks was attempted but it couldn't find a suitable task to move.

In situations where idle balance does not need or is not able to move tasks,
attempting it frequently may lower performance by consuming kernel time while
also ending up not doing anything. Functions such as update_sd_lb_stats(),
idle_cpu(), acquiring rq lock, ect... show up as hot kernel functions as
reported by perf during these situations.

In this patch, idle balance attempts for a CPU will be blocked for a
brief duration (10 ms) after newidle load balance is attempted for the CPU but
did not move tasks. The idea is that if a CPU just attempted a new idle
load balance and found that it either does not need to do any balancing or is
unable to move a task over for all sched domains, then it should
avoid re-attempting it on the same CPU too soon once again.

This patch is able to provide good performance boosts of many AIM7 workloads
on an 8 socket machine 80 core while still preserving performance of a few
workloads that I have also been running which benefit from idle balancing.

The table below compares the average jobs per minute at 10-100, 200-1000, and
1100-2000 users between the vanilla 3.11-rc4 kernel and 3.11-rc4 kernel with
this patch with Hyperthreading enabled.

----------------------------------------------------------------
workload     | % improvement   | % improvement	| % improvement
             | with patch      | with patch	| with patch
             | 1100-2000 users | 200-1000 users	| 10-100 users
----------------------------------------------------------------
alltests     | +13.9%          | +5.6%          | +0.9%
----------------------------------------------------------------
custom       | +20.3%          | +20.7%         | +12.2%
----------------------------------------------------------------
disk         | +22.3%          | +18.7%         | +18.3%
----------------------------------------------------------------
fserver      | +62.6%          | +27.3%         | -0.9%
----------------------------------------------------------------
high_systime | +17.7%          | +10.7%         | +0.6%
----------------------------------------------------------------
new_fserver  | +53.1%          | +20.2%         | -0.2%
----------------------------------------------------------------
shared       | +10.3%          | +10.8%         | +10.7%
----------------------------------------------------------------


Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |   10 +++++++++-
 kernel/sched/sched.h |    5 +++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..b1fcf6d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6458,6 +6458,7 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->next_newidle_balance = jiffies;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9565645..70d96d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5277,10 +5277,12 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
+	bool load_balance_attempted = false;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+	if (this_rq->avg_idle < sysctl_sched_migration_cost ||
+	    time_before(jiffies, this_rq->next_newidle_balance))
 		return;
 
 	/*
@@ -5298,6 +5300,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 			continue;
 
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
+			load_balance_attempted = true;
+
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
 						   sd, CPU_NEWLY_IDLE, &balance);
@@ -5322,6 +5326,10 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
+
+	/* Give idle balance on this CPU a break when it isn't moving tasks */
+	if (load_balance_attempted && !pulled_task)
+		this_rq->next_newidle_balance = jiffies + (HZ / 100);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..6a70be9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -524,6 +524,11 @@ struct rq {
 #endif
 
 	struct sched_avg avg;
+
+#ifdef CONFIG_SMP
+	/* set when we want to block idle balance */
+	unsigned long next_newidle_balance;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
-- 
1.7.1



