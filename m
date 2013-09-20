Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3ITNsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:48:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab3ITNsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:48:10 -0400
Date: Fri, 20 Sep 2013 06:47:39 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-f48627e686a69f5215cb0761e731edb3d9859dd9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, jason.low2@hp.com
In-Reply-To: <1379096813-3032-4-git-send-email-jason.low2@hp.com>
References: <1379096813-3032-4-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/balancing:
  Periodically decay max cost of idle balance
Git-Commit-ID: f48627e686a69f5215cb0761e731edb3d9859dd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 06:47:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f48627e686a69f5215cb0761e731edb3d9859dd9
Gitweb:     http://git.kernel.org/tip/f48627e686a69f5215cb0761e731edb3d9859dd9
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Fri, 13 Sep 2013 11:26:53 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 12:03:46 +0200

sched/balancing: Periodically decay max cost of idle balance

This patch builds on patch 2 and periodically decays that max value to
do idle balancing per sched domain by approximately 1% per second. Also
decay the rq's max_idle_balance_cost value.

Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379096813-3032-4-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/metag/include/asm/topology.h |  1 +
 include/linux/sched.h             |  3 +++
 include/linux/topology.h          |  3 +++
 kernel/sched/fair.c               | 38 +++++++++++++++++++++++++++++++-------
 4 files changed, 38 insertions(+), 7 deletions(-)

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
index be078ff..b5344de 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -810,7 +810,10 @@ struct sched_domain {
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
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ffc99d8..2b89cd2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5681,15 +5681,39 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
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
+		 * visit to all the domains. Decay ~1% per second.
+		 */
+		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
+			sd->max_newidle_lb_cost =
+				(sd->max_newidle_lb_cost * 253) / 256;
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
@@ -5723,14 +5747,14 @@ out:
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
+			max((u64)sysctl_sched_migration_cost, max_cost);
 	}
 	rcu_read_unlock();
 
