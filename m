Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbaIQWdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:33:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:21563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbaIQWdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:33:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,542,1406617200"; 
   d="scan'208";a="478285709"
Subject: [RFC][PATCH 1/6] topology: rename topology_core_cpumask() to topology_package_cpumask()
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>, linux-arch@vger.kernel.org,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 17 Sep 2014 15:33:11 -0700
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
In-Reply-To: <20140917223310.026BCC2C@viggo.jf.intel.com>
Message-Id: <20140917223311.39AFA26F@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

topology_core_cpumask() is a function that arch-independent code
uses.  Each (non-generic) architecture will define it in order to
map over to the arch-specific variables storing the actual mask.

I think topology_core_cpumask() is a bad name.  It makes it sound
like it is generating a cpumask for *A* core.  It is, in fact,
generating the mask of all cores inside a CPU package.  Let's
make that more clear with the naming.

For the non-x86 architectures, I'd appreciate a sanity check of
this.  It definitely makes sense on x86, but I'm less confident
about the others.

Cc: linux-arch@vger.kernel.org

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/arm/include/asm/topology.h         |    2 +-
 b/arch/arm64/include/asm/topology.h       |    2 +-
 b/arch/ia64/include/asm/topology.h        |    2 +-
 b/arch/metag/include/asm/topology.h       |    2 +-
 b/arch/mips/include/asm/smp.h             |    2 +-
 b/arch/powerpc/include/asm/topology.h     |    2 +-
 b/arch/s390/include/asm/topology.h        |    2 +-
 b/arch/sh/include/asm/topology.h          |    2 +-
 b/arch/sparc/include/asm/topology_64.h    |    2 +-
 b/arch/tile/include/asm/topology.h        |    2 +-
 b/arch/x86/include/asm/topology.h         |    2 +-
 b/drivers/base/topology.c                 |    8 ++++----
 b/drivers/block/nvme-core.c               |    2 +-
 b/drivers/cpufreq/arm_big_little.c        |    2 +-
 b/drivers/infiniband/hw/qib/qib_iba7322.c |    2 +-
 b/include/linux/topology.h                |    4 ++--
 b/lib/cpu_rmap.c                          |    2 +-
 17 files changed, 21 insertions(+), 21 deletions(-)

diff -puN arch/arm64/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/arm64/include/asm/topology.h
--- a/arch/arm64/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.310517034 -0700
+++ b/arch/arm64/include/asm/topology.h	2014-09-17 15:28:56.341518454 -0700
@@ -17,7 +17,7 @@ extern struct cpu_topology cpu_topology[
 
 #define topology_physical_package_id(cpu)	(cpu_topology[cpu].cluster_id)
 #define topology_core_id(cpu)		(cpu_topology[cpu].core_id)
-#define topology_core_cpumask(cpu)	(&cpu_topology[cpu].core_sibling)
+#define topology_package_cpumask(cpu)	(&cpu_topology[cpu].core_sibling)
 #define topology_thread_cpumask(cpu)	(&cpu_topology[cpu].thread_sibling)
 
 void init_cpu_topology(void);
diff -puN arch/arm/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/arm/include/asm/topology.h
--- a/arch/arm/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.311517079 -0700
+++ b/arch/arm/include/asm/topology.h	2014-09-17 15:28:56.341518454 -0700
@@ -17,7 +17,7 @@ extern struct cputopo_arm cpu_topology[N
 
 #define topology_physical_package_id(cpu)	(cpu_topology[cpu].socket_id)
 #define topology_core_id(cpu)		(cpu_topology[cpu].core_id)
-#define topology_core_cpumask(cpu)	(&cpu_topology[cpu].core_sibling)
+#define topology_package_cpumask(cpu)	(&cpu_topology[cpu].core_sibling)
 #define topology_thread_cpumask(cpu)	(&cpu_topology[cpu].thread_sibling)
 
 void init_cpu_topology(void);
diff -puN arch/ia64/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/ia64/include/asm/topology.h
--- a/arch/ia64/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.313517171 -0700
+++ b/arch/ia64/include/asm/topology.h	2014-09-17 15:28:56.341518454 -0700
@@ -52,7 +52,7 @@ void build_cpu_to_node_map(void);
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)	(cpu_data(cpu)->socket_id)
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
-#define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
+#define topology_package_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #endif
 
diff -puN arch/metag/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/metag/include/asm/topology.h
--- a/arch/metag/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.315517263 -0700
+++ b/arch/metag/include/asm/topology.h	2014-09-17 15:28:56.342518499 -0700
@@ -21,7 +21,7 @@ const struct cpumask *cpu_coregroup_mask
 
 extern cpumask_t cpu_core_map[NR_CPUS];
 
-#define topology_core_cpumask(cpu)	(&cpu_core_map[cpu])
+#define topology_package_cpumask(cpu)	(&cpu_core_map[cpu])
 
 #include <asm-generic/topology.h>
 
diff -puN arch/mips/include/asm/smp.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/mips/include/asm/smp.h
--- a/arch/mips/include/asm/smp.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.316517309 -0700
+++ b/arch/mips/include/asm/smp.h	2014-09-17 15:28:56.342518499 -0700
@@ -39,7 +39,7 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define topology_physical_package_id(cpu)	(cpu_data[cpu].package)
 #define topology_core_id(cpu)			(cpu_data[cpu].core)
-#define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
+#define topology_package_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&cpu_sibling_map[cpu])
 
 #define SMP_RESCHEDULE_YOURSELF 0x1	/* XXX braindead */
diff -puN arch/powerpc/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/powerpc/include/asm/topology.h
--- a/arch/powerpc/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.318517401 -0700
+++ b/arch/powerpc/include/asm/topology.h	2014-09-17 15:28:56.342518499 -0700
@@ -88,7 +88,7 @@ static inline int prrn_is_enabled(void)
 
 #define topology_physical_package_id(cpu)	(cpu_to_chip_id(cpu))
 #define topology_thread_cpumask(cpu)	(per_cpu(cpu_sibling_map, cpu))
-#define topology_core_cpumask(cpu)	(per_cpu(cpu_core_map, cpu))
+#define topology_package_cpumask(cpu)	(per_cpu(cpu_core_map, cpu))
 #define topology_core_id(cpu)		(cpu_to_core_id(cpu))
 #endif
 #endif
diff -puN arch/s390/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/s390/include/asm/topology.h
--- a/arch/s390/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.320517491 -0700
+++ b/arch/s390/include/asm/topology.h	2014-09-17 15:28:56.343518544 -0700
@@ -20,7 +20,7 @@ extern struct cpu_topology_s390 cpu_topo
 
 #define topology_physical_package_id(cpu)	(cpu_topology[cpu].socket_id)
 #define topology_core_id(cpu)			(cpu_topology[cpu].core_id)
-#define topology_core_cpumask(cpu)		(&cpu_topology[cpu].core_mask)
+#define topology_package_cpumask(cpu)		(&cpu_topology[cpu].core_mask)
 #define topology_book_id(cpu)			(cpu_topology[cpu].book_id)
 #define topology_book_cpumask(cpu)		(&cpu_topology[cpu].book_mask)
 
diff -puN arch/sh/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/sh/include/asm/topology.h
--- a/arch/sh/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.321517537 -0700
+++ b/arch/sh/include/asm/topology.h	2014-09-17 15:28:56.343518544 -0700
@@ -21,7 +21,7 @@ const struct cpumask *cpu_coregroup_mask
 
 extern cpumask_t cpu_core_map[NR_CPUS];
 
-#define topology_core_cpumask(cpu)	(&cpu_core_map[cpu])
+#define topology_package_cpumask(cpu)	(&cpu_core_map[cpu])
 
 #include <asm-generic/topology.h>
 
diff -puN arch/sparc/include/asm/topology_64.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.323517629 -0700
+++ b/arch/sparc/include/asm/topology_64.h	2014-09-17 15:28:56.343518544 -0700
@@ -40,7 +40,7 @@ static inline int pcibus_to_node(struct
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
-#define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
+#define topology_package_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #endif /* CONFIG_SMP */
 
diff -puN arch/tile/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/tile/include/asm/topology.h
--- a/arch/tile/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.325517721 -0700
+++ b/arch/tile/include/asm/topology.h	2014-09-17 15:28:56.344518590 -0700
@@ -54,7 +54,7 @@ static inline const struct cpumask *cpum
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)       ((void)(cpu), 0)
 #define topology_core_id(cpu)                   (cpu)
-#define topology_core_cpumask(cpu)              ((void)(cpu), cpu_online_mask)
+#define topology_package_cpumask(cpu)              ((void)(cpu), cpu_online_mask)
 #define topology_thread_cpumask(cpu)            cpumask_of(cpu)
 #endif
 
diff -puN arch/x86/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.326517767 -0700
+++ b/arch/x86/include/asm/topology.h	2014-09-17 15:28:56.344518590 -0700
@@ -123,7 +123,7 @@ extern const struct cpumask *cpu_coregro
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 
 #ifdef ENABLE_TOPO_DEFINES
-#define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
+#define topology_package_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
 
diff -puN drivers/base/topology.c~rename-topology_cpu_cpumask-topology_package_cpumask drivers/base/topology.c
--- a/drivers/base/topology.c~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.328517857 -0700
+++ b/drivers/base/topology.c	2014-09-17 15:28:56.344518590 -0700
@@ -42,7 +42,7 @@ static ssize_t show_##name(struct device
 	return sprintf(buf, "%d\n", topology_##name(dev->id));	\
 }
 
-#if defined(topology_thread_cpumask) || defined(topology_core_cpumask) || \
+#if defined(topology_thread_cpumask) || defined(topology_package_cpumask) || \
     defined(topology_book_cpumask)
 static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 {
@@ -88,9 +88,9 @@ define_siblings_show_func(thread_cpumask
 define_one_ro_named(thread_siblings, show_thread_cpumask);
 define_one_ro_named(thread_siblings_list, show_thread_cpumask_list);
 
-define_siblings_show_func(core_cpumask);
-define_one_ro_named(core_siblings, show_core_cpumask);
-define_one_ro_named(core_siblings_list, show_core_cpumask_list);
+define_siblings_show_func(package_cpumask);
+define_one_ro_named(core_siblings, show_package_cpumask);
+define_one_ro_named(core_siblings_list, show_package_cpumask_list);
 
 #ifdef CONFIG_SCHED_BOOK
 define_id_show_func(book_id);
diff -puN drivers/block/nvme-core.c~rename-topology_cpu_cpumask-topology_package_cpumask drivers/block/nvme-core.c
--- a/drivers/block/nvme-core.c~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.330517950 -0700
+++ b/drivers/block/nvme-core.c	2014-09-17 15:28:56.345518636 -0700
@@ -2054,7 +2054,7 @@ static void nvme_assign_io_queues(struct
 				nvmeq, cpus_per_queue);
 		if (cpus_weight(mask) < cpus_per_queue)
 			nvme_add_cpus(&mask, unassigned_cpus,
-				topology_core_cpumask(cpu),
+				topology_package_cpumask(cpu),
 				nvmeq, cpus_per_queue);
 		if (cpus_weight(mask) < cpus_per_queue)
 			nvme_add_cpus(&mask, unassigned_cpus,
diff -puN drivers/cpufreq/arm_big_little.c~rename-topology_cpu_cpumask-topology_package_cpumask drivers/cpufreq/arm_big_little.c
--- a/drivers/cpufreq/arm_big_little.c~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.332518042 -0700
+++ b/drivers/cpufreq/arm_big_little.c	2014-09-17 15:28:56.346518682 -0700
@@ -449,7 +449,7 @@ static int bL_cpufreq_init(struct cpufre
 	if (cur_cluster < MAX_CLUSTERS) {
 		int cpu;
 
-		cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
+		cpumask_copy(policy->cpus, topology_package_cpumask(policy->cpu));
 
 		for_each_cpu(cpu, policy->cpus)
 			per_cpu(physical_cluster, cpu) = cur_cluster;
diff -puN drivers/infiniband/hw/qib/qib_iba7322.c~rename-topology_cpu_cpumask-topology_package_cpumask drivers/infiniband/hw/qib/qib_iba7322.c
--- a/drivers/infiniband/hw/qib/qib_iba7322.c~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.334518132 -0700
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c	2014-09-17 15:28:56.349518820 -0700
@@ -3449,7 +3449,7 @@ try_intx:
 	firstcpu = cpumask_first(local_mask);
 	if (firstcpu >= nr_cpu_ids ||
 			cpumask_weight(local_mask) == num_online_cpus()) {
-		local_mask = topology_core_cpumask(0);
+		local_mask = topology_package_cpumask(0);
 		firstcpu = cpumask_first(local_mask);
 	}
 	if (firstcpu < nr_cpu_ids) {
diff -puN include/linux/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask include/linux/topology.h
--- a/include/linux/topology.h~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.336518224 -0700
+++ b/include/linux/topology.h	2014-09-17 15:28:56.350518866 -0700
@@ -177,8 +177,8 @@ static inline int cpu_to_mem(int cpu)
 #ifndef topology_thread_cpumask
 #define topology_thread_cpumask(cpu)		cpumask_of(cpu)
 #endif
-#ifndef topology_core_cpumask
-#define topology_core_cpumask(cpu)		cpumask_of(cpu)
+#ifndef topology_package_cpumask
+#define topology_package_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
 #ifdef CONFIG_SCHED_SMT
diff -puN lib/cpu_rmap.c~rename-topology_cpu_cpumask-topology_package_cpumask lib/cpu_rmap.c
--- a/lib/cpu_rmap.c~rename-topology_cpu_cpumask-topology_package_cpumask	2014-09-17 15:28:56.337518270 -0700
+++ b/lib/cpu_rmap.c	2014-09-17 15:28:56.350518866 -0700
@@ -194,7 +194,7 @@ int cpu_rmap_update(struct cpu_rmap *rma
 					topology_thread_cpumask(cpu), 1))
 			continue;
 		if (cpu_rmap_copy_neigh(rmap, cpu,
-					topology_core_cpumask(cpu), 2))
+					topology_package_cpumask(cpu), 2))
 			continue;
 		if (cpu_rmap_copy_neigh(rmap, cpu,
 					cpumask_of_node(cpu_to_node(cpu)), 3))
_
