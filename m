Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3AKGaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:30:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:42438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3AKGau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:30:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,449,1355126400"; 
   d="scan'208";a="272556576"
Message-ID: <50EFB1DB.7090804@intel.com>
Date: Fri, 11 Jan 2013 14:31:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, namhyung@kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        preeti@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-10-git-send-email-alex.shi@intel.com> <50E7EAB1.6020302@intel.com> <50E92DC3.4050906@intel.com> <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
In-Reply-To: <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 02:31 AM, Linus Torvalds wrote:
> On Sat, Jan 5, 2013 at 11:54 PM, Alex Shi <alex.shi@intel.com> wrote:
>>
>> I just looked into the aim9 benchmark, in this case it forks 2000 tasks,
>> after all tasks ready, aim9 give a signal than all tasks burst waking up
>> and run until all finished.
>> Since each of tasks are finished very quickly, a imbalanced empty cpu
>> may goes to sleep till a regular balancing give it some new tasks. That
>> causes the performance dropping. cause more idle entering.
> 
> Sounds like for AIM (and possibly for other really bursty loads), we
> might want to do some load-balancing at wakeup time by *just* looking
> at the number of running tasks, rather than at the load average. Hmm?
> 
> The load average is fundamentally always going to run behind a bit,
> and while you want to use it for long-term balancing, a short-term you
> might want to do just a "if we have a huge amount of runnable
> processes, do a load balancing *now*". Where "huge amount" should
> probably be relative to the long-term load balancing (ie comparing the
> number of runnable processes on this CPU right *now* with the load
> average over the last second or so would show a clear spike, and a
> reason for quick action).
> 

Sorry for response late!

Just written a patch following your suggestion, but no clear improvement for this case.
I also tried change the burst checking interval, also no clear help.

If I totally give up runnable load in periodic balancing, the performance can recover 60%
of lose.

I will try to optimize wake up balancing in weekend.

Nice weekend!
Alex

---
>From 8f6f7317568a7bd8497e7a6e8d9afcc2b4e93a7e Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Wed, 9 Jan 2013 23:16:57 +0800
Subject: [PATCH] sched: use instant load weight in burst regular load balance

Runnable load tracking needs much time to accumulate the runnable
load, so when system burst wake up many sleep tasks, it needs more time
balance them well. This patch try to catch such scenario and use instant
load instead of runnable load to do balance.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |  1 +
 kernel/sched/debug.c  |  1 +
 kernel/sched/fair.c   | 55 +++++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sysctl.c       |  7 +++++++
 4 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0354a5..f6cf1b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2032,6 +2032,7 @@ extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
+extern unsigned int sysctl_sched_burst_check_ms;
 
 enum sched_tunable_scaling {
 	SCHED_TUNABLESCALING_NONE,
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e4035f7..d06fc3c 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -380,6 +380,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
+	PN(sysctl_sched_burst_check_ms);
 	P(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
 #undef PN
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 604d0ee..875e7af 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4032,6 +4032,7 @@ struct lb_env {
 	unsigned int		loop_max;
 	int			power_lb;  /* if power balance needed */
 	int			perf_lb;   /* if performance balance needed */
+	int			has_burst;
 };
 
 /*
@@ -4729,6 +4730,37 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	return 0;
 }
 
+DEFINE_PER_CPU(unsigned long, next_check);
+DEFINE_PER_CPU(unsigned int, last_running);
+
+/* do burst check no less than this interval */
+unsigned int sysctl_sched_burst_check_ms = 1000UL;
+
+/**
+ * check_burst - check if tasks bursts up on this cpu.
+ * @env: The load balancing environment.
+ */
+static void check_burst(struct lb_env *env)
+{
+	int cpu;
+	unsigned int curr_running, prev_running, interval;
+
+	cpu = env->dst_cpu;
+	curr_running = cpu_rq(cpu)->nr_running;
+	prev_running = per_cpu(last_running, cpu);
+	interval = sysctl_sched_burst_check_ms;
+
+	per_cpu(last_running, cpu) = curr_running;
+
+	if (time_after_eq(jiffies, per_cpu(next_check, cpu))) {
+		per_cpu(next_check, cpu) = jiffies + msecs_to_jiffies(interval);
+		/* find a pike from last balance on the cpu  */
+		if (curr_running  >  2 + (prev_running << 2))
+			env->has_burst = 1;
+	}
+	env->has_burst = 0;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -4770,9 +4802,15 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 				balance_cpu = i;
 			}
 
-			load = target_load(i, load_idx);
+			if (env->has_burst)
+				load = rq->load.weight;
+			else
+				load = target_load(i, load_idx);
 		} else {
-			load = source_load(i, load_idx);
+			if (env->has_burst)
+				load = rq->load.weight;
+			else
+				load = source_load(i, load_idx);
 			if (load > max_cpu_load)
 				max_cpu_load = load;
 			if (min_cpu_load > load)
@@ -4786,7 +4824,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += nr_running;
-		sgs->sum_weighted_load += weighted_cpuload(i);
+		if (env->has_burst)
+			sgs->sum_weighted_load += cpu_rq(i)->load.weight;
+		else
+			sgs->sum_weighted_load += weighted_cpuload(i);
 
 		/* accumulate the maximum potential util */
 		if (!nr_running)
@@ -5164,6 +5205,8 @@ find_busiest_group(struct lb_env *env, int *balance)
 
 	memset(&sds, 0, sizeof(sds));
 
+	check_burst(env);
+
 	/*
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
@@ -5270,7 +5313,10 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 			continue;
 
 		rq = cpu_rq(i);
-		wl = weighted_cpuload(i);
+		if (env->has_burst)
+			wl = rq->load.weight;
+		else
+			wl = weighted_cpuload(i);
 
 		/*
 		 * When comparing with imbalance, use weighted_cpuload()
@@ -5352,6 +5398,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.cpus		= cpus,
 		.power_lb	= 1,
 		.perf_lb	= 0,
+		.has_burst	= 0,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..25262b8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -350,6 +350,13 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "sched_burst_check_ms",
+		.data		= &sysctl_sched_burst_check_ms,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif /* CONFIG_SMP */
 #ifdef CONFIG_NUMA_BALANCING
 	{
-- 
1.7.12

>            Linus
> 

