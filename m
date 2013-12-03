Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3LCJIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:08:01 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46572 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3LCJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:07:29 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
Date: Tue,  3 Dec 2013 17:05:56 +0800
Message-Id: <1386061556-28233-5-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Task migration happens when target just a bit less then source cpu load.
To reduce such situation happens, aggravate the target cpu load with
sd->imbalance_pct/100.

This patch removes the hackbench thread regression on Daniel's
Intel Core2 server.

a5d6e63		+patch1~3		+patch1~4
hackbench -T -s 4096 -l 1000 -g 10 -f 40
27.914"         38.694"			28.587"
28.390"         38.341"			29.513"
28.048"         38.626"			28.706"

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bccdd89..c49b7ba 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -978,7 +978,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 
 static unsigned long weighted_cpuload(const int cpu);
 static unsigned long source_load(int cpu);
-static unsigned long target_load(int cpu);
+static unsigned long target_load(int cpu, int imbalance_pct);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -3809,11 +3809,17 @@ static unsigned long source_load(int cpu)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static unsigned long target_load(int cpu)
+static unsigned long target_load(int cpu, int imbalance_pct)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
+	/*
+	 * without cpu_load decay, in most of time cpu_load is same as total
+	 * so we need to make target a bit heavier to reduce task migration
+	 */
+	total = total * imbalance_pct / 100;
+
 	if (!sched_feat(LB_BIAS))
 		return total;
 
@@ -4033,7 +4039,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
 	load	  = source_load(prev_cpu);
-	this_load = target_load(this_cpu);
+	this_load = target_load(this_cpu, 100);
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -4089,7 +4095,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu) <= tl_per_task)) {
+	     this_load + target_load(prev_cpu, 100) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -4135,7 +4141,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 			if (local_group)
 				load = source_load(i);
 			else
-				load = target_load(i);
+				load = target_load(i, sd->imbalance_pct);
 
 			avg_load += load;
 		}
@@ -5478,7 +5484,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group)
-			load = target_load(i);
+			load = target_load(i, env->sd->imbalance_pct);
 		else
 			load = source_load(i);
 
-- 
1.8.1.2

