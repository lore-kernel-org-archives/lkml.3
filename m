Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab3H3KSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:18:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33471 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3H3KSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:18:35 -0400
Date: Fri, 30 Aug 2013 12:18:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle
 balance
Message-ID: <20130830101817.GE10002@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
 <1377806736-3752-4-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377806736-3752-4-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 01:05:36PM -0700, Jason Low wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58b0514..bba5a07 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1345,7 +1345,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>  
>  	if (rq->idle_stamp) {
>  		u64 delta = rq_clock(rq) - rq->idle_stamp;
> -		u64 max = 2*rq->max_idle_balance_cost;
> +		u64 max = 2*(sysctl_sched_migration_cost + rq->max_idle_balance_cost);

You re-introduce sched_migration_cost here because max_idle_balance_cost
can now drop down to 0 again?

>  
>  		update_avg(&rq->avg_idle, delta);
>  
> @@ -6509,7 +6509,7 @@ void __init sched_init(void)
>  		rq->online = 0;
>  		rq->idle_stamp = 0;
>  		rq->avg_idle = 2*sysctl_sched_migration_cost;
> -		rq->max_idle_balance_cost = sysctl_sched_migration_cost;
> +		rq->max_idle_balance_cost = 0;
>  
>  		INIT_LIST_HEAD(&rq->cfs_tasks);
>  

Would it make sense to keep it initialized at sched_migration_cost and
'tweak' the decay to also provide as lower bound?

> @@ -5300,12 +5315,20 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	for_each_domain(this_cpu, sd) {
>  		unsigned long interval;
>  		int balance = 1;
> -		u64 t0, domain_cost, max = 5*sysctl_sched_migration_cost;
> +		u64 t0, domain_cost;
> +
> +		/* Periodically decay sd's max_newidle_lb_cost */
> +		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
> +			sd->max_newidle_lb_cost =
> +				(sd->max_newidle_lb_cost * 199) / 200;
> +			sd->next_decay_max_lb_cost = jiffies + HZ;
> +		}

I see you've already done this in rebalance_domains() as well, which I
think is the right place. 

I suppose you also do it here since neither place guarantees a full sd
tree iteration? I think we should fix that since you can very easily
have situations where idle_balance() isn't called for ages.

>  
>  		if (!(sd->flags & SD_LOAD_BALANCE))
>  			continue;
>  
> -		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost)
> +		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost
> +					+ sysctl_sched_migration_cost)
>  			break;
>  
>  		if (sd->flags & SD_BALANCE_NEWIDLE) {
> @@ -5316,8 +5339,6 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  						   sd, CPU_NEWLY_IDLE, &balance);
>  
>  			domain_cost = sched_clock_cpu(smp_processor_id()) - t0;
> -			if (domain_cost > max)
> -				domain_cost = max;
>  
>  			if (domain_cost > sd->max_newidle_lb_cost)
>  				sd->max_newidle_lb_cost = domain_cost;
> @@ -5333,6 +5354,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  			break;
>  		}
>  	}
> +	max_newidle_lb_cost = get_max_newidle_lb_cost(this_cpu);

OK, so this is a tad counter-intuitive. We apparently just iterated all
domains which suggests we could have just computed the max there.
However... we could have broken out due to cost and not seen the top few
domains. Which is why you're now iterating then all again, right?

How about we too move this into the regular balance path, that iterates
the entire tree every time.

So how about something like this:

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
[peterz: rewrote most of the logic, but kept the spirit]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1377806736-3752-4-git-send-email-jason.low2@hp.com
---
 arch/metag/include/asm/topology.h |    1 
 include/linux/sched.h             |    3 ++
 include/linux/topology.h          |    3 ++
 kernel/sched/fair.c               |   42 ++++++++++++++++++++++++++++----------
 4 files changed, 39 insertions(+), 10 deletions(-)

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
+			max_cost = max(max_cost, sd->max_newidle_lb_cost);
+			need_decay = 1;
+		}
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
+	}
+	if (need_decay) {
 		/*
-		 * Stop the load balance at this level. There is another
-		 * CPU in our sched group which is doing load balancing more
-		 * actively.
+		 * Ensure the rq-wide value also decays but keep it at a
+		 * reasonable floor to avoid funnies with rq->avg_idle.
 		 */
-		if (!continue_balancing)
-			break;
+		rq->max_idle_balance_cost =
+			min(sysctl_sched_migration_cost, max_cost);
 	}
 	rcu_read_unlock();
 
