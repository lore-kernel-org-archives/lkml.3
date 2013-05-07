Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3EGFMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:12:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:35358 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab3EGFMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:12:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="309346001"
Message-ID: <51888D22.8010309@intel.com>
Date: Tue, 07 May 2013 13:12:02 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com> <5187C59F.1020305@intel.com> <CAPM31RJBiGtLPbBwuWJQvW6e=5x=X7+Qx5YKJkjtyr_HDEqivg@mail.gmail.com>
In-Reply-To: <CAPM31RJBiGtLPbBwuWJQvW6e=5x=X7+Qx5YKJkjtyr_HDEqivg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 02:34 AM, Paul Turner wrote:
>> > Current load balance doesn't consider slept task's load which is
>> > represented by blocked_load_avg. And the slept task is not on_rq, so
>> > consider it in load balance is a little strange.
> The load-balancer has a longer time horizon; think of blocked_loag_avg
> to be a signal for the load, already assigned to this cpu, which is
> expected to appear (within roughly the next quantum).
> 
> Consider the following scenario:
> 
> tasks: A,B (40% busy), C (90% busy)
> 
> Suppose we have:
> CPU 0:  CPU 1:
>  A            C
>  B
> 
> Then, when C blocks the load balancer ticks.
> 
> If we considered only runnable_load then A or B would be eligible for
> migration to CPU 1, which is essentially where we are today.
> 

here is the changed patch according to Paul's comments. Is that you liked, Paul? :)

---

>From 1d7290530e2ee402874bbce39297bb1cfd882339 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sat, 17 Nov 2012 13:56:11 +0800
Subject: [PATCH 5/7] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 16 ++++++++++++++--
 kernel/sched/fair.c |  8 ++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 33d9a858..f4c6cac 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2536,9 +2536,14 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load;
 	unsigned long pending_updates;
 
+#ifdef CONFIG_SMP
+	load = this_rq->cfs.runnable_load_avg + this_rq->cfs.blocked_load_avg;
+#else
+	load = this_rq->load.weight;
+#endif
 	/*
 	 * bail if there's load or we're actually up-to-date.
 	 */
@@ -2582,11 +2587,18 @@ void update_cpu_load_nohz(void)
  */
 static void update_cpu_load_active(struct rq *this_rq)
 {
+	unsigned long load;
+
+#ifdef CONFIG_SMP
+	load = this_rq->cfs.runnable_load_avg + this_rq->cfs.blocked_load_avg;
+#else
+	load = this_rq->load.weight;
+#endif
 	/*
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, load, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2881d42..407ef61 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2900,7 +2900,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	struct rq *rq = cpu_rq(cpu);
+	return rq->cfs.runnable_load_avg + rq->cfs.blocked_load_avg;
 }
 
 /*
@@ -2946,8 +2947,11 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
+	unsigned long load_avg;
+	load_avg = rq->cfs.runnable_load_avg + rq->cfs.blocked_load_avg;
+
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return load_avg / nr_running;
 
 	return 0;
 }
-- 
1.7.12


-- 
Thanks
    Alex
