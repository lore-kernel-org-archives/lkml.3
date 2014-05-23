Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaEWSUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:20:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35989 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaEWSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:52 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 04/16] sched: Allocate and initialize sched energy
Date: Fri, 23 May 2014 19:16:31 +0100
Message-Id: <1400869003-27769-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:49.0041 (UTC) FILETIME=[29DA0010:01CF76B3]
X-MC-Unique: 114052319165000501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIKvZI005215

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The per sg struct sched_group_energy structure plus the related struct
capacity_state array are allocated like the other sd hierarchy data
structures (e.g. struct sched_group).  This includes the freeing of
struct sched_group_energy structures which are not used.
One problem is that the sd energy information consists of two structures
per sg, the actual struct sched_group_energy and the related
capacity_state array and that the number of elements of this array can be
configured (see struct sched_group_energy.nr_cap_states).  That means
that the number of capacity states has to be figured out in __sdt_alloc()
and since both data structures are allocated at the same time, struct
sched_group_energy.cap_states is initialized to point to the start of the
capacity state array memory.

The new function init_sched_energy() initializes the per sg struct
sched_group_energy and the struct capacity_state array in case the struct
sched_domain_topology_level contains sd energy information.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c  |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |   30 ++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 851cbd8..785b61d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5438,6 +5438,9 @@ static void free_sched_domain(struct rcu_head *rcu)
 		free_sched_groups(sd->groups, 1);
 	} else if (atomic_dec_and_test(&sd->groups->ref)) {
 		kfree(sd->groups->sgp);
+#ifdef CONFIG_SCHED_ENERGY
+		kfree(sd->groups->sge);
+#endif
 		kfree(sd->groups);
 	}
 	kfree(sd);
@@ -5698,6 +5701,10 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
 		(*sg)->sgp = *per_cpu_ptr(sdd->sgp, cpu);
 		atomic_set(&(*sg)->sgp->ref, 1); /* for claim_allocations */
+#ifdef CONFIG_SCHED_ENERGY
+		(*sg)->sge = *per_cpu_ptr(sdd->sge, cpu);
+		atomic_set(&(*sg)->sge->ref, 1); /* for claim_allocations */
+#endif
 	}
 
 	return cpu;
@@ -5789,6 +5796,31 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
 }
 
+#ifdef CONFIG_SCHED_ENERGY
+static void init_sched_energy(int cpu, struct sched_domain *sd,
+			      struct sched_domain_topology_level *tl)
+{
+	struct sched_group *sg = sd->groups;
+	struct sched_energy *energy = &sg->sge->data;
+	sched_domain_energy_f fn = tl->energy;
+	struct cpumask *mask = sched_group_cpus(sg);
+
+	if (!fn || !fn(cpu))
+		return;
+
+	if (cpumask_weight(mask) > 1)
+		check_sched_energy_data(cpu, fn, mask);
+
+	energy->max_capacity = fn(cpu)->max_capacity;
+	energy->idle_power = fn(cpu)->idle_power;
+	energy->wakeup_energy = fn(cpu)->wakeup_energy;
+	energy->nr_cap_states = fn(cpu)->nr_cap_states;
+
+	memcpy(energy->cap_states, fn(cpu)->cap_states,
+	       energy->nr_cap_states*sizeof(struct capacity_state));
+}
+#endif
+
 /*
  * Initializers for schedule domains
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
@@ -5879,6 +5911,11 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 
 	if (atomic_read(&(*per_cpu_ptr(sdd->sgp, cpu))->ref))
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
+
+#ifdef CONFIG_SCHED_ENERGY
+	if (atomic_read(&(*per_cpu_ptr(sdd->sge, cpu))->ref))
+		*per_cpu_ptr(sdd->sge, cpu) = NULL;
+#endif
 }
 
 #ifdef CONFIG_NUMA
@@ -6284,10 +6321,29 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 		if (!sdd->sgp)
 			return -ENOMEM;
 
+#ifdef CONFIG_SCHED_ENERGY
+		sdd->sge = alloc_percpu(struct sched_group_energy *);
+		if (!sdd->sge)
+			return -ENOMEM;
+#endif
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
 			struct sched_group *sg;
 			struct sched_group_power *sgp;
+#ifdef CONFIG_SCHED_ENERGY
+			struct sched_group_energy *sge;
+			sched_domain_energy_f fn = tl->energy;
+
+			/*
+			 * Figure out how many elements the cap state array has
+			 * to contain.
+			 * In case tl->info.energy(j)->nr_cap_states is 0, we
+			 * still allocate struct sched_group_energy XXX which is
+			 * not used but will be freed later XXX.
+			 */
+			unsigned int nr_cap_states = !fn || !fn(j) ? 0 :
+					fn(j)->nr_cap_states;
+#endif
 
 		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
@@ -6311,6 +6367,20 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sgp, j) = sgp;
+
+#ifdef CONFIG_SCHED_ENERGY
+			sge = kzalloc_node(sizeof(struct sched_group_energy) +
+				nr_cap_states*sizeof(struct capacity_state),
+				GFP_KERNEL, cpu_to_node(j));
+
+			if (!sge)
+				return -ENOMEM;
+
+			sge->data.cap_states = (struct capacity_state *)((void *)sge +
+				 sizeof(struct sched_group_energy));
+
+			*per_cpu_ptr(sdd->sge, j) = sge;
+#endif
 		}
 	}
 
@@ -6339,6 +6409,10 @@ static void __sdt_free(const struct cpumask *cpu_map)
 				kfree(*per_cpu_ptr(sdd->sg, j));
 			if (sdd->sgp)
 				kfree(*per_cpu_ptr(sdd->sgp, j));
+#ifdef CONFIG_SCHED_ENERGY
+			if (sdd->sge)
+				kfree(*per_cpu_ptr(sdd->sge, j));
+#endif
 		}
 		free_percpu(sdd->sd);
 		sdd->sd = NULL;
@@ -6346,6 +6420,10 @@ static void __sdt_free(const struct cpumask *cpu_map)
 		sdd->sg = NULL;
 		free_percpu(sdd->sgp);
 		sdd->sgp = NULL;
+#ifdef CONFIG_SCHED_ENERGY
+		free_percpu(sdd->sge);
+		sdd->sge = NULL;
+#endif
 	}
 }
 
@@ -6417,10 +6495,18 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Calculate CPU power for physical packages and nodes */
 	for (i = nr_cpumask_bits-1; i >= 0; i--) {
+#ifdef CONFIG_SCHED_ENERGY
+		struct sched_domain_topology_level *tl = sched_domain_topology;
+#endif
 		if (!cpumask_test_cpu(i, cpu_map))
 			continue;
 
+#ifdef CONFIG_SCHED_ENERGY
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent, tl++) {
+			init_sched_energy(i, sd, tl);
+#else
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+#endif
 			claim_allocations(i, sd);
 			init_sched_groups_power(i, sd);
 		}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c566f5e..6726437 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -807,6 +807,36 @@ static inline unsigned int group_first_cpu(struct sched_group *group)
 
 extern int group_balance_cpu(struct sched_group *sg);
 
+/*
+ * Check that the per-cpu provided sd energy data is consistent for all cpus
+ * within the mask.
+ */
+#ifdef CONFIG_SCHED_ENERGY
+static inline void check_sched_energy_data(int cpu, sched_domain_energy_f fn,
+					   const struct cpumask *cpumask)
+{
+	struct cpumask mask;
+	int i;
+
+	cpumask_xor(&mask, cpumask, get_cpu_mask(cpu));
+
+	for_each_cpu(i, &mask) {
+		int y = 0;
+
+		BUG_ON(fn(i)->max_capacity != fn(cpu)->max_capacity);
+		BUG_ON(fn(i)->idle_power != fn(cpu)->idle_power);
+		BUG_ON(fn(i)->wakeup_energy != fn(cpu)->wakeup_energy);
+		BUG_ON(fn(i)->nr_cap_states != fn(cpu)->nr_cap_states);
+
+		for (; y < (fn(i)->nr_cap_states); y++) {
+			BUG_ON(fn(i)->cap_states[y].cap !=
+					fn(cpu)->cap_states[y].cap);
+			BUG_ON(fn(i)->cap_states[y].power !=
+					fn(cpu)->cap_states[y].power);
+		}
+	}
+}
+#endif
 #endif /* CONFIG_SMP */
 
 #include "stats.h"
-- 
1.7.9.5


