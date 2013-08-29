Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3H2UFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:05:50 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:14945 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab3H2UFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:05:48 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: [PATCH v4 2/3] sched: Consider max cost of idle balance per sched domain
Date: Thu, 29 Aug 2013 13:05:35 -0700
Message-Id: <1377806736-3752-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, we keep track of the max cost we spend doing idle load balancing
for each sched domain. If the avg time the CPU remains idle is less then the
time we have already spent on idle balancing + the max cost of idle balancing
in the sched domain, then we don't continue to attempt the balance. We also
keep a per rq variable, max_idle_balance_cost, which keeps track of the max
time spent on newidle load balances throughout all its domains. Additionally,
we swap sched_migration_cost used in idle_balance for rq->max_idle_balance_cost.

By using the max, we avoid overrunning the average. This further reduces the chance
we attempt balancing when the CPU is not idle for longer than the cost to balance.

I also limited the max cost of each domain to 5*sysctl_sched_migration_cost as
a way to prevent the max from becoming too inflated.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 arch/metag/include/asm/topology.h |    1 +
 include/linux/sched.h             |    1 +
 include/linux/topology.h          |    3 +++
 kernel/sched/core.c               |    3 ++-
 kernel/sched/fair.c               |   21 ++++++++++++++++++++-
 kernel/sched/sched.h              |    3 +++
 6 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 23f5118..db19292 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -26,6 +26,7 @@
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
+	.max_newidle_lb_cost	= 0,			\
 }
 
 #define cpu_to_node(cpu)	((void)(cpu), 0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 078066d..16e7d80 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -818,6 +818,7 @@ struct sched_domain {
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
 	u64 last_update;
+	u64 max_newidle_lb_cost;
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..e2a2c3d 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -106,6 +106,7 @@ int arch_update_cpu_topology(void);
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.smt_gain		= 1178,	/* 15% */			\
+	.max_newidle_lb_cost	= 0,					\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -135,6 +136,7 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.max_newidle_lb_cost	= 0,					\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -166,6 +168,7 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.max_newidle_lb_cost	= 0,					\
 }
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 93b18ef..58b0514 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1345,7 +1345,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 
 	if (rq->idle_stamp) {
 		u64 delta = rq_clock(rq) - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
+		u64 max = 2*rq->max_idle_balance_cost;
 
 		update_avg(&rq->avg_idle, delta);
 
@@ -6509,6 +6509,7 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->max_idle_balance_cost = sysctl_sched_migration_cost;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 68f1609..7697741 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5283,10 +5283,11 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
+	u64 curr_cost = 0;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+	if (this_rq->avg_idle < this_rq->max_idle_balance_cost)
 		return;
 
 	/*
@@ -5299,14 +5300,29 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
+		u64 t0, domain_cost, max = 5*sysctl_sched_migration_cost;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
+		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost)
+			break;
+
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
+			t0 = sched_clock_cpu(smp_processor_id());
+
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
 						   sd, CPU_NEWLY_IDLE, &balance);
+
+			domain_cost = sched_clock_cpu(smp_processor_id()) - t0;
+			if (domain_cost > max)
+				domain_cost = max;
+
+			if (domain_cost > sd->max_newidle_lb_cost)
+				sd->max_newidle_lb_cost = domain_cost;
+
+			curr_cost += domain_cost;
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
@@ -5328,6 +5344,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
+
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..6340d0a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -477,6 +477,9 @@ struct rq {
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
+
+	/* Set to max idle balance cost for any one sched domain */
+	u64 max_idle_balance_cost;
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-- 
1.7.1

