Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbaCZNdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaCZNdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:33:09 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RFC 1/2] sched: Introduce topology level masks and for_each_tlm() macro
Date: Wed, 26 Mar 2014 14:34:23 +0100
Message-Id: <02fa9f8882254a44eae847d2947eb74467d7cce4.1395840483.git.agordeev@redhat.com>
In-Reply-To: <cover.1395840483.git.agordeev@redhat.com>
References: <cover.1395840483.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have for_each_cpu_mask() (and friends) macro which is used
to enumerate CPUs in a given cpumask. Such enumeration walks
CPUs in ascending order of their IDs and does not take into
account CPU topology of the system. That is, each next CPU
could belong to any level of the system topology with regard
to the previously iterated CPU.

Yet, in some cases such indiscriminate enumeration could gain
suboptimal results when for_each_cpu_mask() is used to find-
first a CPU that matches certain criteria: if the finding
process prefers a CPU to be found as close as possible to the
current one (in the same core, package, last level cache etc.)
then for_each_cpu_mask() macro alone is not enough.

To facilitate convenient topology-aware cpumask enumeration
this update introduces a concept of topology level masks - an
per-cpu array of cpumask items. Each n-th item in this array
contains CPUs on this topology level minus all CPUs on all
[0..n-1] previous levels, relatively to this CPU.

Additionally, new macro for_each_tlm() is introduced to
enumerate the described above topology level masks. As result,
a topology-aware enumeration for a arbitrary cpumask 'mask'
would look like this:

	struct cpumask **tlm;
	int cpu;

	for_each_tlm(tlm) {
		for_each_cpu_and(cpu, *tlm, mask) {
			/*
			 * Check if 'cpu' matches criteria
			 */
		}
	}

It is generally recommended to disable preemption when calling
for_each_tlm() macro. Although it is not guaranteed the
finding process is not migrated to another CPU upon preemption
enable, we do not want it moved in the middle of the nested
loops causing accesses to the original CPU's topology level
masks.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |    5 +++
 kernel/sched/core.c   |   89 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..489df53 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2934,4 +2934,9 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+DECLARE_PER_CPU(struct cpumask **, sd_tlm);
+
+#define for_each_tlm(tlm)					\
+	for ((tlm) = this_cpu_read(sd_tlm); *(tlm); (tlm)++)
+
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6edbef2..da6d119 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5451,6 +5451,18 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
 		destroy_sched_domain(sd, cpu);
 }
 
+static void destroy_topology_level_masks(struct cpumask **tlm)
+{
+	if (tlm) {
+		struct cpumask **masks;
+
+		for (masks = tlm; *masks; masks++)
+			kfree(*masks);
+
+		kfree(tlm);
+	}
+}
+
 /*
  * Keep a special pointer to the highest sched_domain that has
  * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
@@ -5493,6 +5505,67 @@ static void update_top_cache_domain(int cpu)
 	rcu_assign_pointer(per_cpu(sd_asym, cpu), sd);
 }
 
+DEFINE_PER_CPU(struct cpumask **, sd_tlm);
+
+static struct cpumask **
+build_topology_level_masks(struct sched_domain *domain, int cpu)
+{
+	struct sched_domain *sd;
+	struct cpumask **ret;
+	struct cpumask *mask;
+	struct cpumask *prev;
+	int node = cpu_to_node(cpu);
+	int ndoms = 0;
+	int level = 0;
+
+	prev = kzalloc(cpumask_size(), GFP_KERNEL);
+	if (!prev)
+		return NULL;
+
+	for (sd = domain; sd; sd = sd->parent) {
+		if (sd->parent && cpumask_equal(sched_domain_span(sd->parent),
+						sched_domain_span(sd)))
+			continue;
+		ndoms++;
+	}
+
+	ret = kzalloc_node((ndoms + 1) * sizeof(ret[0]), GFP_KERNEL, node);
+	if (!ret)
+		goto err;
+
+	for (sd = domain; sd; sd = sd->parent) {
+		if (sd->parent && cpumask_equal(sched_domain_span(sd->parent),
+						sched_domain_span(sd)))
+			continue;
+
+		if (cpumask_equal(sched_domain_span(sd), prev))
+			break;
+
+		mask = kzalloc_node(cpumask_size(), GFP_KERNEL, node);
+		if (!mask)
+			goto err;
+
+		cpumask_andnot(mask, sched_domain_span(sd), prev);
+		cpumask_or(prev, prev, sched_domain_span(sd));
+
+		ret[level] = mask;
+		level++;
+	}
+
+	WARN_ON_ONCE(level != ndoms);
+
+err:
+	kfree(prev);
+	return ret;
+}
+
+static void cpu_attach_topology_level_masks(struct cpumask **masks, int cpu)
+{
+	struct cpumask **tmp = per_cpu(sd_tlm, cpu);
+	per_cpu(sd_tlm, cpu) = masks;
+	destroy_topology_level_masks(tmp);
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -5569,6 +5642,7 @@ struct sd_data {
 
 struct s_data {
 	struct sched_domain ** __percpu sd;
+	struct cpumask *** __percpu masks;
 	struct root_domain	*rd;
 };
 
@@ -5894,6 +5968,7 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 		if (!atomic_read(&d->rd->refcount))
 			free_rootdomain(&d->rd->rcu); /* fall through */
 	case sa_sd:
+		free_percpu(d->masks);
 		free_percpu(d->sd); /* fall through */
 	case sa_sd_storage:
 		__sdt_free(cpu_map); /* fall through */
@@ -5912,6 +5987,9 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 	d->sd = alloc_percpu(struct sched_domain *);
 	if (!d->sd)
 		return sa_sd_storage;
+	d->masks = alloc_percpu(struct cpumask **);
+	if (!d->masks)
+		return sa_sd;
 	d->rd = alloc_rootdomain();
 	if (!d->rd)
 		return sa_sd;
@@ -6373,6 +6451,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 {
 	enum s_alloc alloc_state;
 	struct sched_domain *sd;
+	struct cpumask **masks;
 	struct s_data d;
 	int i, ret = -ENOMEM;
 
@@ -6421,11 +6500,21 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		}
 	}
 
+	/* Build topology level plain masks for the domains */
+	for_each_cpu(i, cpu_map) {
+		sd = *per_cpu_ptr(d.sd, i);
+		masks = build_topology_level_masks(sd, i);
+		*per_cpu_ptr(d.masks, i) = masks;
+	}
+
 	/* Attach the domains */
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map) {
 		sd = *per_cpu_ptr(d.sd, i);
 		cpu_attach_domain(sd, d.rd, i);
+
+		masks = *per_cpu_ptr(d.masks, i);
+		cpu_attach_topology_level_masks(masks, i);
 	}
 	rcu_read_unlock();
 
-- 
1.7.7.6

