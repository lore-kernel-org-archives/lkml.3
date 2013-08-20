Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab3HTJcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:32:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20327 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3HTJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:32:48 -0400
Message-ID: <1376991166.1753.8.camel@j-VirtualBox>
Subject: [RFC PATCH v3] sched: Limit idle balance based on max cost per
 sched domain
From: Jason Low <jason.low2@hp.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jason Low <jason.low2@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 Aug 2013 02:32:46 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

So this is my sample implementation of the concept of matching the CPU's avg_idle 
with the maximum time we ever spend in a new idle load balance for each domain.
This is based on our previous patch which compares avg_idle with sd->avg_cost,
but I replaced sd->avg_cost with sd->max_cost.

Since we are comparing avg_idle with sd->max_cost, the existing avg_idle would 
not be accurate since it is limited based on migration_cost, so I increased the 
max avg_idle to 25*sched_migration_cost. Additionally, I updated avg_idle by 
calling update_avg() first. Then if the avg_idle exceeds the max, the avg_idle 
is set to the max. This is to prevent avg_idle from being set to the maximum 
after 1 long idle.

Since I have found idle balance to be beneficial when it is not failing to move 
tasks, I was thinking we can also not skip newidle balance (regardless of what 
avg_idle and max_cost are) if the previous attempt on the rq or domain 
succeeded in moving tasks. I was also wondering if we should periodically reset
the max cost. Both would require an extra field to be added to either the
rq or domain structure though.


Signed-off-by: Jason Low <jason.low2@hp.com>
---
 arch/metag/include/asm/topology.h |    1 +
 include/linux/sched.h             |    1 +
 include/linux/topology.h          |    3 +++
 kernel/sched/core.c               |    9 +++++----
 kernel/sched/fair.c               |   16 ++++++++++++++++
 5 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 23f5118..be400ad 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -26,6 +26,7 @@
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
+	.max_idle_balance_cost	= 0,			\
 }
 
 #define cpu_to_node(cpu)	((void)(cpu), 0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d722490..6e89421 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -818,6 +818,7 @@ struct sched_domain {
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
 	u64 last_update;
+	u64 max_idle_balance_cost;
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..e3cfe88 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -106,6 +106,7 @@ int arch_update_cpu_topology(void);
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.smt_gain		= 1178,	/* 15% */			\
+	.max_idle_balance_cost	= 0,					\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -135,6 +136,7 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.max_idle_balance_cost	= 0,					\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -166,6 +168,7 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.max_idle_balance_cost	= 0,					\
 }
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..204e02c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1343,12 +1343,13 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 
 	if (rq->idle_stamp) {
 		u64 delta = rq_clock(rq) - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
+		u64 max = 25*sysctl_sched_migration_cost;
 
-		if (delta > max)
+		update_avg(&rq->avg_idle, delta);
+
+		if (rq->avg_idle > max)
 			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
+
 		rq->idle_stamp = 0;
 	}
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9565645..1b76933 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5277,6 +5277,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
+	u64 cost = 0;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
@@ -5293,14 +5294,29 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
+		u64 this_domain_balance_cost = 0;
+		u64 start_time;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
+		if (this_rq->avg_idle < sd->max_idle_balance_cost + cost)
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
+			/* Update the max idle balance cost stats for this sd */
+			if (this_domain_balance_cost > sd->max_idle_balance_cost)
+				sd->max_idle_balance_cost = this_domain_balance_cost;
+
+			cost += this_domain_balance_cost;
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
-- 
1.7.1



