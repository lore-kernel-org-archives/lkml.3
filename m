Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3GIP4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:56:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46169 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3GIPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:38 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 6/9] sched: power: add power_domain data structure
Date: Tue,  9 Jul 2013 16:55:35 +0100
Message-Id: <1373385338-12983-7-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:35.0106 (UTC) FILETIME=[BFA1A220:01CE7CBC]
X-MC-Unique: 113070916553621901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69Fuucg011641

Initial proposal for power topology representation in power
scheduler. For now just one global hierarchy. It will need a more
scalable layout later. More topology information will be added as
the power scheduler design evolves and implements power topology
aware freqency/P-state and idle state selection.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/sched/power.c |  133 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 110 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/power.c b/kernel/sched/power.c
index ddf249f..1ff8e4a 100644
--- a/kernel/sched/power.c
+++ b/kernel/sched/power.c
@@ -21,18 +21,54 @@
 #define INTERVAL 5 /* ms */
 #define CPU_FULL 90 /* Busy %-age - TODO: Make tunable */
 
-struct cpu_stats_struct {
+struct power_domain {
+	/* Domain hierarchy pointers */
+	struct power_domain *parent;
+	struct power_domain *next;
+	struct power_domain *child;
+	/* Domain info */
+	struct cpumask span;
+	/* current max power supported by platform */
+	unsigned long arch_power;
+	/* cpu power exposed to the scheduler (fair.c) */
+	unsigned long sched_power;
+	/* load ratio (load tracking) */
 	int load;
 	int nr_tasks;
 };
 
-static unsigned long power_of(int cpu)
+static struct power_domain power_hierarchy;
+
+DEFINE_PER_CPU(struct power_domain, *cpu_pds);
+
+#define cpu_pd(cpu)	(per_cpu(cpu_pds, (cpu)))
+
+#define for_each_pd(cpu, __pd) \
+		for (__pd = cpu_pd(cpu); __pd; __pd = __pd->parent)
+
+/*
+ * update_hierarchy updates the power domain hierarchy with new information
+ * for a specific cpu
+ */
+static void update_hierarchy(int cpu)
 {
-	return cpu_rq(cpu)->cpu_power;
+	int i;
+	int domain_load;
+	int domain_arch_power;
+	struct power_domain *pd;
+
+	for_each_pd(cpu, pd) {
+		domain_load = 0;
+		domain_arch_power = 0;
+		for_each_cpu_mask(i, pd->span) {
+			domain_load += cpu_pd(i)->load;
+			domain_arch_power += cpu_pd(i)->arch_power;
+		}
+		pd->load = domain_load;
+		pd->arch_power = domain_arch_power;
+	}
 }
 
-DEFINE_PER_CPU(struct cpu_stats_struct, cpu_stats);
-
 /*
  * update_cpu_load fetches runqueue statistics from the scheduler should
  * only be called with approitate locks held.
@@ -47,18 +83,19 @@ static void update_cpu_load(void)
 		u32 sum = rq->avg.runnable_avg_sum;
 		u32 period = rq->avg.runnable_avg_period;
 
-		load = (sum * power_of(i)) / (period+1);
-		per_cpu(cpu_stats, i).load = load;
-		per_cpu(cpu_stats, i).nr_tasks = rq->nr_running;
+		load = (sum * power_sched_cpu_power(i)) / (period+1);
+		cpu_pd(i)->load = load;
+		cpu_pd(i)->nr_tasks = rq->nr_running;
 
 		/* Take power scheduler kthread into account */
 		if (smp_processor_id() == i)
-			per_cpu(cpu_stats, i).nr_tasks--;
+			cpu_pd(i)->nr_tasks--;
+
+		update_hierarchy(i);
 	}
 }
 
 extern unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu);
-DEFINE_PER_CPU(unsigned long, arch_cpu_power);
 
 static void get_arch_cpu_power(void)
 {
@@ -66,16 +103,14 @@ static void get_arch_cpu_power(void)
 
 	if (sched_feat(ARCH_POWER)) {
 		for_each_online_cpu(i)
-			per_cpu(arch_cpu_power, i) =
+			cpu_pd(i)->arch_power =
 				arch_scale_freq_power(cpu_rq(i)->sd, i);
 	} else {
 		for_each_online_cpu(i)
-			per_cpu(arch_cpu_power, i) = SCHED_POWER_SCALE;
+			cpu_pd(i)->arch_power = SCHED_POWER_SCALE;
 	}
 }
 
-DEFINE_PER_CPU(unsigned long, cpu_power);
-
 /*
  * power_sched_cpu_power is called from fair.c to get the power scheduler
  * cpu capacities. We can't use arch_scale_freq_power() as this may already
@@ -83,7 +118,10 @@ DEFINE_PER_CPU(unsigned long, cpu_power);
  */
 unsigned long power_sched_cpu_power(struct sched_domain *sd, int cpu)
 {
-	return per_cpu(cpu_power, cpu);
+	if (cpu_pd(cpu))
+		return cpu_pd(cpu)->sched_power;
+	else
+		return SCHED_POWER_SCALE;
 }
 
 /*
@@ -95,7 +133,7 @@ unsigned long power_sched_cpu_power(struct sched_domain *sd, int cpu)
 static void calculate_cpu_capacities(void)
 {
 	int i, spare_cap = 0;
-	struct cpu_stats_struct *stats;
+	struct power_domain *stats;
 
 	/*
 	 * spare_cap keeps track of the total available capacity across
@@ -104,22 +142,22 @@ static void calculate_cpu_capacities(void)
 
 	for_each_online_cpu(i) {
 		int t_cap = 0;
-		int arch_power = per_cpu(arch_cpu_power, i);
+		int sched_power = cpu_pd(i)->sched_power;
 
-		stats = &per_cpu(cpu_stats, i);
-		t_cap = arch_power - stats->load;
+		stats = cpu_pd(i);
+		t_cap = sched_power - stats->load;
 
-		if (t_cap < (arch_power * (100-CPU_FULL)) / 100) {
+		if (t_cap < (sched_power * (100-CPU_FULL)) / 100) {
 			/* Potential for spreading load */
 			if (stats->nr_tasks > 1)
 				t_cap = -(stats->load / stats->nr_tasks);
 		}
 
 		/* Do we have enough capacity already? */
-		if (spare_cap + t_cap > arch_power) {
-			per_cpu(cpu_power, i) = 1;
+		if (spare_cap + t_cap > sched_power) {
+			cpu_pd(i)->sched_power = 1;
 		} else {
-			per_cpu(cpu_power, i) = arch_power;
+			cpu_pd(i)->sched_power = cpu_pd(i)->arch_power;
 			spare_cap += t_cap;
 		}
 	}
@@ -136,6 +174,53 @@ static void __power_schedule(void)
 	rcu_read_unlock();
 }
 
+static void init_power_domain(struct power_domain *pd)
+{
+	pd->parent = NULL;
+	pd->next = pd;
+	pd->child = NULL;
+	pd->load = 0;
+	pd->arch_power = 0;
+	pd->sched_power = 0;
+	cpumask_copy(&pd->span, cpu_possible_mask);
+}
+
+/*
+ * init_power_hierarhcy sets up the default power domain hierarchy with
+ * one top level domain spanning all cpus and child domains for each cpu.
+ * next points to the next power domain at the current level and forms a
+ * circular list.
+ */
+static void init_power_hierarchy(void)
+{
+	int cpu, next_cpu;
+	struct power_domain *pd;
+
+	init_power_domain(&power_hierarchy);
+	cpumask_copy(&power_hierarchy.span, cpu_possible_mask);
+
+	pd = kzalloc(sizeof(struct power_domain) * nr_cpu_ids, GFP_KERNEL);
+
+	cpu = cpumask_next(-1, &power_hierarchy.span);
+
+	while (cpu < nr_cpu_ids) {
+		cpu_pd(cpu) = &pd[cpu];
+		cpu_pd(cpu)->parent = &power_hierarchy;
+		cpu_pd(cpu)->child = NULL;
+		cpumask_copy(&(cpu_pd(cpu)->span), get_cpu_mask(cpu));
+		cpu_pd(cpu)->arch_power = 1;
+		cpu_pd(cpu)->sched_power = 1;
+
+		next_cpu = cpumask_next(cpu, &power_hierarchy.span);
+		if (next_cpu < nr_cpu_ids)
+			cpu_pd(cpu)->next = &pd[next_cpu];
+		else
+			cpu_pd(cpu)->next =
+				&pd[cpumask_first(&power_hierarchy.span)];
+		cpu = next_cpu;
+	}
+}
+
 struct delayed_work dwork;
 
 /* Periodic power schedule target cpu */
@@ -153,6 +238,8 @@ void power_schedule_wq(struct work_struct *work)
 
 static int __init sched_power_init(void)
 {
+	init_power_hierarchy();
+
 	INIT_DELAYED_WORK(&dwork, power_schedule_wq);
 	mod_delayed_work_on(schedule_cpu(), system_wq, &dwork,
 				msecs_to_jiffies(INTERVAL));
-- 
1.7.9.5


