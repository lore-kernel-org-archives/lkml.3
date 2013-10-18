Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3JRLyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:09 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57876 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab3JRLxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:51 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 06/14] sched: create a new field with available capacity
Date: Fri, 18 Oct 2013 13:52:19 +0200
Message-Id: <1382097147-30088-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new field power_available reflects the available capacity of a CPU
unlike the cpu_power which reflects the current capacity.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c  |   14 +++++++++++---
 kernel/sched/sched.h |    3 ++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5568980..db9b871 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4584,15 +4584,19 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	if (!power)
 		power = 1;
 
+	cpu_rq(cpu)->cpu_available = power;
+	sdg->sgp->power_available = power;
+
 	cpu_rq(cpu)->cpu_power = power;
 	sdg->sgp->power = power;
+
 }
 
 void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power;
+	unsigned long power, available;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
@@ -4604,7 +4608,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		return;
 	}
 
-	power = 0;
+	power = available = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -4614,6 +4618,8 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 		for_each_cpu(cpu, sched_group_cpus(sdg))
 			power += power_of(cpu);
+			available += available_of(cpu);
+
 	} else  {
 		/*
 		 * !SD_OVERLAP domains can assume that child groups
@@ -4623,11 +4629,13 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		group = child->groups;
 		do {
 			power += group->sgp->power;
+			available += group->sgp->power_available;
 			group = group->next;
 		} while (group != child->groups);
 	}
 
-	sdg->sgp->power_orig = sdg->sgp->power = power;
+	sdg->sgp->power_orig = sdg->sgp->power_available = available;
+	sdg->sgp->power = power;
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 22e3f1d..d5a4ec0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -459,6 +459,7 @@ struct rq {
 	struct sched_domain *sd;
 
 	unsigned long cpu_power;
+	unsigned long cpu_available;
 
 	unsigned char idle_balance;
 	/* For active balancing */
@@ -603,7 +604,7 @@ struct sched_group_power {
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
 	 */
-	unsigned int power, power_orig;
+	unsigned int power, power_orig, power_available;
 	unsigned long next_update;
 	/*
 	 * Number of busy cpus in this group.
-- 
1.7.9.5

