Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3H2UF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:05:57 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:13966 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3H2UFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:05:55 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle balance
Date: Thu, 29 Aug 2013 13:05:36 -0700
Message-Id: <1377806736-3752-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/metag/include/asm/topology.h |    1 +
 include/linux/sched.h             |    3 ++
 include/linux/topology.h          |    3 ++
 kernel/sched/core.c               |    4 +-
 kernel/sched/fair.c               |   43 ++++++++++++++++++++++++++++++-------
 5 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index db19292..8e9c0b3 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -27,6 +27,7 @@
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
 	.max_newidle_lb_cost	= 0,			\
+	.next_decay_max_lb_cost	= jiffies,		\
 }
 
 #define cpu_to_node(cpu)	((void)(cpu), 0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 16e7d80..bcc805a 100644
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
diff --git a/include/linux/topology.h b/include/linux/topology.h
index e2a2c3d..12ae6ce 100644
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
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58b0514..bba5a07 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1345,7 +1345,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 
 	if (rq->idle_stamp) {
 		u64 delta = rq_clock(rq) - rq->idle_stamp;
-		u64 max = 2*rq->max_idle_balance_cost;
+		u64 max = 2*(sysctl_sched_migration_cost + rq->max_idle_balance_cost);
 
 		update_avg(&rq->avg_idle, delta);
 
@@ -6509,7 +6509,7 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
-		rq->max_idle_balance_cost = sysctl_sched_migration_cost;
+		rq->max_idle_balance_cost = 0;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7697741..60b984d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5274,6 +5274,20 @@ out:
 	return ld_moved;
 }
 
+/* Returns the max newidle lb cost out of all of this_cpu's sched domains */
+inline u64 get_max_newidle_lb_cost(int this_cpu)
+{
+	struct sched_domain *sd;
+	u64 max = 0;
+
+	for_each_domain(this_cpu, sd) {
+		if (sd->max_newidle_lb_cost > max)
+			max = sd->max_newidle_lb_cost;
+	}
+
+	return max;
+}
+
 /*
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
@@ -5283,11 +5297,12 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
-	u64 curr_cost = 0;
+	u64 curr_cost = 0, max_newidle_lb_cost = 0;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < this_rq->max_idle_balance_cost)
+	if (this_rq->avg_idle < sysctl_sched_migration_cost
+				+ this_rq->max_idle_balance_cost)
 		return;
 
 	/*
@@ -5300,12 +5315,20 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
-		u64 t0, domain_cost, max = 5*sysctl_sched_migration_cost;
+		u64 t0, domain_cost;
+
+		/* Periodically decay sd's max_newidle_lb_cost */
+		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
+			sd->max_newidle_lb_cost =
+				(sd->max_newidle_lb_cost * 199) / 200;
+			sd->next_decay_max_lb_cost = jiffies + HZ;
+		}
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost)
+		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost
+					+ sysctl_sched_migration_cost)
 			break;
 
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
@@ -5316,8 +5339,6 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 						   sd, CPU_NEWLY_IDLE, &balance);
 
 			domain_cost = sched_clock_cpu(smp_processor_id()) - t0;
-			if (domain_cost > max)
-				domain_cost = max;
 
 			if (domain_cost > sd->max_newidle_lb_cost)
 				sd->max_newidle_lb_cost = domain_cost;
@@ -5333,6 +5354,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 			break;
 		}
 	}
+	max_newidle_lb_cost = get_max_newidle_lb_cost(this_cpu);
 	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
@@ -5345,8 +5367,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		this_rq->next_balance = next_balance;
 	}
 
-	if (curr_cost > this_rq->max_idle_balance_cost)
-		this_rq->max_idle_balance_cost = curr_cost;
+	this_rq->max_idle_balance_cost = max_newidle_lb_cost;
 }
 
 /*
@@ -5576,6 +5597,12 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
+			sd->max_newidle_lb_cost =
+				(sd->max_newidle_lb_cost * 199) / 200;
+			sd->next_decay_max_lb_cost = jiffies + HZ;
+		}
+
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-- 
1.7.1

