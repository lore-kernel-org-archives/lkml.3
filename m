Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbaGCQc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:32:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44971 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbaGCQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:10 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 04/23] sched: Allocate and initialize energy data structures
Date: Thu,  3 Jul 2014 17:25:51 +0100
Message-Id: <1404404770-323-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:09.0037 (UTC) FILETIME=[7F098BD0:01CF96DB]
X-MC-Unique: 114070317260825001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GYF6U010777

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The per sched group (sg) sched_group_energy structure plus the related
idle_state and capacity_state arrays are allocated like the other sched
domain (sd) hierarchy data structures. This includes the freeing of
sched_group_energy structures which are not used.

One problem is that the number of elements of the idle_state and the
capacity_state arrays is not fixed and has to be retrieved in
__sdt_alloc() to allocate memory for the sched_group_energy structure and
the two arrays in one chunk. The array pointers (idle_states and
cap_states) are initialized here to point to the correct place inside the
memory chunk.

The new function init_sched_energy() initializes the sched_group_energy
structure and the two arrays in case the sd topology level contains energy
information.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c  |   71 +++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h |   35 +++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 54f5722..ecece17 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5539,6 +5539,7 @@ static void free_sched_domain(struct rcu_head *rcu)
 		free_sched_groups(sd->groups, 1);
 	} else if (atomic_dec_and_test(&sd->groups->ref)) {
 		kfree(sd->groups->sgc);
+		kfree(sd->groups->sge);
 		kfree(sd->groups);
 	}
 	kfree(sd);
@@ -5799,6 +5800,8 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
 		(*sg)->sgc = *per_cpu_ptr(sdd->sgc, cpu);
 		atomic_set(&(*sg)->sgc->ref, 1); /* for claim_allocations */
+		(*sg)->sge = *per_cpu_ptr(sdd->sge, cpu);
+		atomic_set(&(*sg)->sge->ref, 1); /* for claim_allocations */
 	}
 
 	return cpu;
@@ -5888,6 +5891,28 @@ static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
 	atomic_set(&sg->sgc->nr_busy_cpus, sg->group_weight);
 }
 
+static void init_sched_energy(int cpu, struct sched_domain *sd,
+			      struct sched_domain_topology_level *tl)
+{
+	struct sched_group *sg = sd->groups;
+	struct sched_group_energy *energy = sg->sge;
+	sched_domain_energy_f fn = tl->energy;
+	struct cpumask *mask = sched_group_cpus(sg);
+
+	if (!fn || !fn(cpu))
+		return;
+
+	if (cpumask_weight(mask) > 1)
+		check_sched_energy_data(cpu, fn, mask);
+
+	energy->nr_idle_states = fn(cpu)->nr_idle_states;
+	memcpy(energy->idle_states, fn(cpu)->idle_states,
+	       energy->nr_idle_states*sizeof(struct idle_state));
+	energy->nr_cap_states = fn(cpu)->nr_cap_states;
+	memcpy(energy->cap_states, fn(cpu)->cap_states,
+	       energy->nr_cap_states*sizeof(struct capacity_state));
+}
+
 /*
  * Initializers for schedule domains
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
@@ -5978,6 +6003,9 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 
 	if (atomic_read(&(*per_cpu_ptr(sdd->sgc, cpu))->ref))
 		*per_cpu_ptr(sdd->sgc, cpu) = NULL;
+
+	if (atomic_read(&(*per_cpu_ptr(sdd->sge, cpu))->ref))
+		*per_cpu_ptr(sdd->sge, cpu) = NULL;
 }
 
 #ifdef CONFIG_NUMA
@@ -6383,10 +6411,24 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 		if (!sdd->sgc)
 			return -ENOMEM;
 
+		sdd->sge = alloc_percpu(struct sched_group_energy *);
+		if (!sdd->sge)
+			return -ENOMEM;
+
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
 			struct sched_group *sg;
 			struct sched_group_capacity *sgc;
+			struct sched_group_energy *sge;
+			sched_domain_energy_f fn = tl->energy;
+			unsigned int nr_idle_states = 0;
+			unsigned int nr_cap_states = 0;
+
+			if (fn && fn(j)) {
+				nr_idle_states = fn(j)->nr_idle_states;
+				nr_cap_states = fn(j)->nr_cap_states;
+				BUG_ON(!nr_idle_states || !nr_cap_states);
+			}
 
 		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
@@ -6410,6 +6452,26 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sgc, j) = sgc;
+
+			sge = kzalloc_node(sizeof(struct sched_group_energy) +
+				nr_idle_states*sizeof(struct idle_state) +
+				nr_cap_states*sizeof(struct capacity_state),
+				GFP_KERNEL, cpu_to_node(j));
+
+			if (!sge)
+				return -ENOMEM;
+
+			sge->idle_states = (struct idle_state *)
+					   ((void *)&sge->cap_states +
+					    sizeof(sge->cap_states));
+
+			sge->cap_states = (struct capacity_state *)
+					  ((void *)&sge->cap_states +
+					   sizeof(sge->cap_states) +
+					   nr_idle_states*
+					   sizeof(struct idle_state));
+
+			*per_cpu_ptr(sdd->sge, j) = sge;
 		}
 	}
 
@@ -6438,6 +6500,8 @@ static void __sdt_free(const struct cpumask *cpu_map)
 				kfree(*per_cpu_ptr(sdd->sg, j));
 			if (sdd->sgc)
 				kfree(*per_cpu_ptr(sdd->sgc, j));
+			if (sdd->sge)
+				kfree(*per_cpu_ptr(sdd->sge, j));
 		}
 		free_percpu(sdd->sd);
 		sdd->sd = NULL;
@@ -6445,6 +6509,8 @@ static void __sdt_free(const struct cpumask *cpu_map)
 		sdd->sg = NULL;
 		free_percpu(sdd->sgc);
 		sdd->sgc = NULL;
+		free_percpu(sdd->sge);
+		sdd->sge = NULL;
 	}
 }
 
@@ -6516,10 +6582,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Calculate CPU capacity for physical packages and nodes */
 	for (i = nr_cpumask_bits-1; i >= 0; i--) {
+		struct sched_domain_topology_level *tl = sched_domain_topology;
+
 		if (!cpumask_test_cpu(i, cpu_map))
 			continue;
 
-		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent, tl++) {
+			init_sched_energy(i, sd, tl);
 			claim_allocations(i, sd);
 			init_sched_groups_capacity(i, sd);
 		}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d300a64..1a5f1ee 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -790,6 +790,41 @@ static inline unsigned int group_first_cpu(struct sched_group *group)
 
 extern int group_balance_cpu(struct sched_group *sg);
 
+/*
+ * Check that the per-cpu provided sd energy data is consistent for all cpus
+ * within the mask.
+ */
+static inline void check_sched_energy_data(int cpu, sched_domain_energy_f fn,
+					   const struct cpumask *cpumask)
+{
+	struct cpumask mask;
+	int i;
+
+	cpumask_xor(&mask, cpumask, get_cpu_mask(cpu));
+
+	for_each_cpu(i, &mask) {
+		int y;
+
+		BUG_ON(fn(i)->nr_idle_states != fn(cpu)->nr_idle_states);
+
+		for (y = 0; y < (fn(i)->nr_idle_states); y++) {
+			BUG_ON(fn(i)->idle_states[y].power !=
+					fn(cpu)->idle_states[y].power);
+			BUG_ON(fn(i)->idle_states[y].wu_energy !=
+					fn(cpu)->idle_states[y].wu_energy);
+		}
+
+		BUG_ON(fn(i)->nr_cap_states != fn(cpu)->nr_cap_states);
+
+		for (y = 0; y < (fn(i)->nr_cap_states); y++) {
+			BUG_ON(fn(i)->cap_states[y].cap !=
+					fn(cpu)->cap_states[y].cap);
+			BUG_ON(fn(i)->cap_states[y].power !=
+					fn(cpu)->cap_states[y].power);
+		}
+	}
+}
+
 #else
 
 static inline void sched_ttwu_pending(void) { }
-- 
1.7.9.5


