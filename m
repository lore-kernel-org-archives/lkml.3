Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab3DYR0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:26:24 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61779 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759019Ab3DYRZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:25:15 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net,
        l.majewski@samsung.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 12/14] sched: create a new field with available capacity
Date: Thu, 25 Apr 2013 19:23:28 +0200
Message-Id: <1366910611-20048-13-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new field power_available reflects the available capacity of a CPU
unlike the cpu_power which reflects the current capacity.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |    2 +-
 kernel/sched/fair.c   |   18 +++++++++++++++---
 kernel/sched/sched.h  |    1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a82cdeb..03a5143 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -824,7 +824,7 @@ struct sched_group_power {
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
 	 */
-	unsigned int power, power_orig;
+	unsigned int power, power_orig, power_available;
 	unsigned long next_update;
 	/*
 	 * Number of busy cpus in this group.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6f63fb9..756b1e3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -179,6 +179,11 @@ static unsigned long power_of(int cpu)
 	return cpu_rq(cpu)->cpu_power;
 }
 
+static unsigned long available_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_available;
+}
+
 /*
  * Save the id of the optimal CPU that should be used to pack small tasks
  * The value -1 is used when no buddy has been found
@@ -4588,6 +4593,9 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	if (!power)
 		power = 1;
 
+	cpu_rq(cpu)->cpu_available = power;
+	sdg->sgp->power_available = power;
+
 	cpu_rq(cpu)->cpu_power = power;
 	sdg->sgp->power = power;
 }
@@ -4596,7 +4604,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power;
+	unsigned long power, available;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
@@ -4608,7 +4616,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		return;
 	}
 
-	power = 0;
+	power = available = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -4618,6 +4626,8 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 		for_each_cpu(cpu, sched_group_cpus(sdg))
 			power += power_of(cpu);
+			available += available_of(cpu);
+
 	} else  {
 		/*
 		 * !SD_OVERLAP domains can assume that child groups
@@ -4627,11 +4637,13 @@ void update_group_power(struct sched_domain *sd, int cpu)
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
index 96b164d..2b6eaf9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -413,6 +413,7 @@ struct rq {
 	struct sched_domain *sd;
 
 	unsigned long cpu_power;
+	unsigned long cpu_available;
 
 	unsigned char idle_balance;
 	/* For active balancing */
-- 
1.7.9.5

