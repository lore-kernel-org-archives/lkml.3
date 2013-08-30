Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3H3K3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:29:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33690 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3H3K3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:29:52 -0400
Date: Fri, 30 Aug 2013 12:29:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle
 balance
Message-ID: <20130830102941.GF10002@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
 <1377806736-3752-4-git-send-email-jason.low2@hp.com>
 <20130830101817.GE10002@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830101817.GE10002@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:18:17PM +0200, Peter Zijlstra wrote:
>  	for_each_domain(cpu, sd) {
> +		/*
> +		 * Decay the newidle max times here because this is a regular
> +		 * visit to all the domains. Decay ~0.5% per second.
> +		 */
> +		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
> +			sd->max_newidle_lb_cost =
> +				(sd->max_newidle_lb_cost * 254) / 256;
> +			sd->next_decay_max_lb_cost = jiffies + HZ;
> +			max_cost = max(max_cost, sd->max_newidle_lb_cost);
> +			need_decay = 1;
> +		}

We need to pull the max_cost thing out of that condition, for we could
possibly trigger need_decay half-way through the iteration.

That said, why is it: max(sd->max_newidle_lb_cost) and not
sum(sd->max_newidly_lb_cost)?

The sum seems like the more reasonable thing since we're actually
computing the sum over in idle_balance().

> +	if (need_decay) {
>  		/*
> -		 * Stop the load balance at this level. There is another
> -		 * CPU in our sched group which is doing load balancing more
> -		 * actively.
> +		 * Ensure the rq-wide value also decays but keep it at a
> +		 * reasonable floor to avoid funnies with rq->avg_idle.
>  		 */
> -		if (!continue_balancing)
> -			break;
> +		rq->max_idle_balance_cost =
> +			min(sysctl_sched_migration_cost, max_cost);

OK, that gives an ugly compile warn, and that should obviously have
been max, so I suppose max((u64)sysctl_sched_migration_cost, max_cost)
would cure that.

Given all that I end up with:

---
Subject: sched: Periodically decay max cost of idle balance
From: Jason Low <jason.low2@hp.com>
Date: Thu, 29 Aug 2013 13:05:36 -0700

This RFC patch builds on patch 2 and periodically decays that max value to
do idle balancing per sched domain.

Though we want to decay it fairly consistently, we may not want to lower it by
too much each time, especially since avg_idle is capped based on that value.
So I thought that decaying the value every second and lowering it by half a
percent each time appeared to be fairly reasonable.

This change would allow us to remove the limit we set on each domain's max cost
to idle balance. Also, since the max can be reduced now, we now have to
update rq->max_idle balance_cost more frequently. So after every idle balance,
we loop through the sched domain to find the max sd's newidle load balance cost
for any one domain. Then we will set rq->max_idle_balance_cost to that value.

Since we are now decaying the max cost to do idle balancing, that max cost can
also become not high enough. One possible explanation for why is that
besides the time spent on each newidle load balance, there are other costs
associated with attempting idle balancing. Idle balance also releases and
reacquires a spin lock. That cost is not counted when we keep track of each
domain's cost to do newidle load balance. Also, acquiring the rq locks can
potentially prevent other CPUs from running something useful. And after
migrating tasks, it might potentially have to pay the costs of cache misses and
refreshing tasks' cache.

Because of that, this patch also compares avg_idle with max cost to do idle
balancing + sched_migration_cost. While using the max cost helps reduce
overestimating the average idle, the sched_migration_cost can help account
for those additional costs of idle balancing.

Signed-off-by: Jason Low <jason.low2@hp.com>
[peterz: rewrote the logic, but kept the spirit]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1377806736-3752-4-git-send-email-jason.low2@hp.com
---
 arch/metag/include/asm/topology.h |    1 
 include/linux/sched.h             |    3 ++
 include/linux/topology.h          |    3 ++
 kernel/sched/fair.c               |   44 ++++++++++++++++++++++++++++----------
 4 files changed, 40 insertions(+), 11 deletions(-)

--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -27,6 +27,7 @@
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
 	.max_newidle_lb_cost	= 0,			\
+	.next_decay_max_lb_cost	= jiffies,		\
 }
 
 #define cpu_to_node(cpu)	((void)(cpu), 0)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -818,7 +818,10 @@ struct sched_domain {
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
 	u64 last_update;
+
+	/* idle_balance() stats */
 	u64 max_newidle_lb_cost;
+	unsigned long next_decay_max_lb_cost;
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -107,6 +107,7 @@ int arch_update_cpu_topology(void);
 	.balance_interval	= 1,					\
 	.smt_gain		= 1178,	/* 15% */			\
 	.max_newidle_lb_cost	= 0,					\
+	.next_decay_max_lb_cost	= jiffies,				\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -137,6 +138,7 @@ int arch_update_cpu_topology(void);
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.max_newidle_lb_cost	= 0,					\
+	.next_decay_max_lb_cost	= jiffies,				\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -169,6 +171,7 @@ int arch_update_cpu_topology(void);
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.max_newidle_lb_cost	= 0,					\
+	.next_decay_max_lb_cost	= jiffies,				\
 }
 #endif
 
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5409,7 +5409,7 @@ void idle_balance(int this_cpu, struct r
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int continue_balancing = 1;
-		u64 t0, domain_cost, max = 5*sysctl_sched_migration_cost;
+		u64 t0, domain_cost;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -5426,8 +5426,6 @@ void idle_balance(int this_cpu, struct r
 						   &continue_balancing);
 
 			domain_cost = sched_clock_cpu(this_cpu) - t0;
-			if (domain_cost > max)
-				domain_cost = max;
 
 			if (domain_cost > sd->max_newidle_lb_cost)
 				sd->max_newidle_lb_cost = domain_cost;
@@ -5680,15 +5678,39 @@ static void rebalance_domains(int cpu, e
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
-	int need_serialize;
+	int need_serialize, need_decay = 0;
+	u64 max_cost = 0;
 
 	update_blocked_averages(cpu);
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		/*
+		 * Decay the newidle max times here because this is a regular
+		 * visit to all the domains. Decay ~0.5% per second.
+		 */
+		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
+			sd->max_newidle_lb_cost =
+				(sd->max_newidle_lb_cost * 254) / 256;
+			sd->next_decay_max_lb_cost = jiffies + HZ;
+			need_decay = 1;
+		}
+		max_cost += sd->max_newidle_lb_cost;
+
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
+		/*
+		 * Stop the load balance at this level. There is another
+		 * CPU in our sched group which is doing load balancing more
+		 * actively.
+		 */
+		if (!continue_balancing) {
+			if (need_decay)
+				continue;
+			break;
+		}
+
 		interval = sd->balance_interval;
 		if (idle != CPU_IDLE)
 			interval *= sd->busy_factor;
@@ -5722,14 +5744,14 @@ static void rebalance_domains(int cpu, e
 			next_balance = sd->last_balance + interval;
 			update_next_balance = 1;
 		}
-
-		/*
-		 * Stop the load balance at this level. There is another
-		 * CPU in our sched group which is doing load balancing more
-		 * actively.
+	}
+	if (need_decay) {
+		/*
+		 * Ensure the rq-wide value also decays but keep it at a
+		 * reasonable floor to avoid funnies with rq->avg_idle.
 		 */
-		if (!continue_balancing)
-			break;
+		rq->max_idle_balance_cost =
+			max((u64)sysctl_sched_migration_cost, max_cost);
 	}
 	rcu_read_unlock();
 
