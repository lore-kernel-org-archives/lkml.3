Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3IMS1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:27:16 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10978 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3IMS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:27:12 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com, chegu_vinod@hp.com
Subject: [PATCH v5 2/3] sched: Consider max cost of idle balance per sched domain
Date: Fri, 13 Sep 2013 11:26:52 -0700
Message-Id: <1379096813-3032-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379096813-3032-1-git-send-email-jason.low2@hp.com>
References: <1379096813-3032-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4->v5
- We don't use the this_rq->avg_idle < this_rq->max_idle_balance_cost check.
  However, we kept the old rq->avg_idle < sysctl_sched_migration_cost since
  I saw some performance benefits with it.
- Substitute smp_processor_id() with this_cpu.

In this patch, we keep track of the max cost we spend doing idle load balancing
for each sched domain. If the avg time the CPU remains idle is less then the
time we have already spent on idle balancing + the max cost of idle balancing
in the sched domain, then we don't continue to attempt the balance. We also
keep a per rq variable, max_idle_balance_cost, which keeps track of the max
time spent on newidle load balances throughout all its domains so that we can
determine the avg_idle's max value.

By using the max, we avoid overrunning the average. This further reduces the
chance we attempt balancing when the CPU is not idle for longer than the cost
to balance.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 arch/metag/include/asm/topology.h |    1 +
 include/linux/sched.h             |    1 +
 include/linux/topology.h          |    3 +++
 kernel/sched/core.c               |    3 ++-
 kernel/sched/fair.c               |   16 ++++++++++++++++
 kernel/sched/sched.h              |    3 +++
 6 files changed, 26 insertions(+), 1 deletions(-)

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
index f79ced7..fe16b7d 100644
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
index 25b0f79..455ab28 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1345,7 +1345,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 
 	if (rq->idle_stamp) {
 		u64 delta = rq_clock(rq) - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
+		u64 max = 2*rq->max_idle_balance_cost;
 
 		update_avg(&rq->avg_idle, delta);
 
@@ -6521,6 +6521,7 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->max_idle_balance_cost = sysctl_sched_migration_cost;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b3fe1c..8b33257 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5392,6 +5392,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
+	u64 curr_cost = 0;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
@@ -5408,15 +5409,27 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int continue_balancing = 1;
+		u64 t0, domain_cost;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
+		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost)
+			break;
+
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
+			t0 = sched_clock_cpu(this_cpu);
+
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
 						   sd, CPU_NEWLY_IDLE,
 						   &continue_balancing);
+
+			domain_cost = sched_clock_cpu(this_cpu) - t0;
+			if (domain_cost > sd->max_newidle_lb_cost)
+				sd->max_newidle_lb_cost = domain_cost;
+
+			curr_cost += domain_cost;
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
@@ -5438,6 +5451,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
+
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b3c5653..f24e239 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -476,6 +476,9 @@ struct rq {
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
+
+	/* This is used to determine avg_idle's max value */
+	u64 max_idle_balance_cost;
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-- 
1.7.1

