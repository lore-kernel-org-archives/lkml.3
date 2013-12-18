Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3LRNOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:14:53 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62568 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3LRNOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:14:51 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, pjt@google.com, Morten.Rasmussen@arm.com,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        james.hogan@imgtec.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, Dietmar.Eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC] sched: CPU topology try
Date: Wed, 18 Dec 2013 14:13:51 +0100
Message-Id: <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies on top of the two patches [1][2] that have been proposed by
Peter for creating a new way to initialize sched_domain. It includes some minor
compilation fixes and a trial of using this new method on ARM platform.
[1] https://lkml.org/lkml/2013/11/5/239
[2] https://lkml.org/lkml/2013/11/5/449

Based on the results of this tests, my feeling about this new way to init the
sched_domain is a bit mitigated.

The good point is that I have been able to create the same sched_domain
topologies than before and even more complex ones (where a subset of the cores
in a cluster share their powergating capabilities). I have described various
topology results below.

I use a system that is made of a dual cluster of quad cores with hyperthreading
for my examples.

If one cluster (0-7) can powergate its cores independantly but not the other
cluster (8-15) we have the following topology, which is equal to what I had
previously:

CPU0:
domain 0: span 0-1 level: SMT
    flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
    groups: 0 1
  domain 1: span 0-7 level: MC
      flags: SD_SHARE_PKG_RESOURCES
      groups: 0-1 2-3 4-5 6-7
    domain 2: span 0-15 level: CPU
        flags:
        groups: 0-7 8-15

CPU8
domain 0: span 8-9 level: SMT
    flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
    groups: 8 9
  domain 1: span 8-15 level: MC
      flags: SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
      groups: 8-9 10-11 12-13 14-15
    domain 2: span 0-15 level CPU
        flags:
        groups: 8-15 0-7

We can even describe some more complex topologies if a susbset (2-7) of the
cluster can't powergate independatly:

CPU0:
domain 0: span 0-1 level: SMT
    flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
    groups: 0 1
  domain 1: span 0-7 level: MC
      flags: SD_SHARE_PKG_RESOURCES
      groups: 0-1 2-7
    domain 2: span 0-15 level: CPU
        flags:
        groups: 0-7 8-15

CPU2:
domain 0: span 2-3 level: SMT
    flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
    groups: 0 1
  domain 1: span 2-7 level: MC
      flags: SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
      groups: 2-7 4-5 6-7
    domain 2: span 0-7 level: MC
        flags: SD_SHARE_PKG_RESOURCES
        groups: 2-7 0-1
      domain 3: span 0-15 level: CPU
          flags:
          groups: 0-7 8-15

In this case, we have an aditionnal sched_domain MC level for this subset (2-7)
of cores so we can trigger some load balance in this subset before doing that
on the complete cluster (which is the last level of cache in my example)

We can add more levels that will describe other dependency/independency like
the frequency scaling dependency and as a result the final sched_domain
topology will have additional levels (if they have not been removed during
the degenerate sequence)

My concern is about the configuration of the table that is used to create the
sched_domain. Some levels are "duplicated" with different flags configuration
which make the table not easily readable and we must also take care of the
order  because parents have to gather all cpus of its childs. So we must
choose which capabilities will be a subset of the other one. The order is
almost straight forward when we describe 1 or 2 kind of capabilities
(package ressource sharing and power sharing) but it can become complex if we
want to add more.

Regards
Vincent

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

---
 arch/arm/include/asm/topology.h |    4 ++
 arch/arm/kernel/topology.c      |   99 ++++++++++++++++++++++++++++++++++++++-
 include/linux/sched.h           |    7 +++
 kernel/sched/core.c             |   17 +++----
 4 files changed, 116 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
index 58b8b84..5102847 100644
--- a/arch/arm/include/asm/topology.h
+++ b/arch/arm/include/asm/topology.h
@@ -5,12 +5,16 @@
 
 #include <linux/cpumask.h>
 
+#define CPU_CORE_GATE		0x1
+#define CPU_CLUSTER_GATE	0x2
+
 struct cputopo_arm {
 	int thread_id;
 	int core_id;
 	int socket_id;
 	cpumask_t thread_sibling;
 	cpumask_t core_sibling;
+	int flags;
 };
 
 extern struct cputopo_arm cpu_topology[NR_CPUS];
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 85a8737..8a2aec6 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -24,6 +24,7 @@
 
 #include <asm/cputype.h>
 #include <asm/topology.h>
+#include <asm/smp_plat.h>
 
 /*
  * cpu power scale management
@@ -79,6 +80,51 @@ unsigned long *__cpu_capacity;
 
 unsigned long middle_capacity = 1;
 
+static int __init get_dt_power_topology(struct device_node *topo)
+{
+	const u32 *reg;
+	int len, power = 0;
+	int flag = CPU_CORE_GATE;
+
+	for (; topo; topo = of_get_next_parent(topo)) {
+		reg = of_get_property(topo, "power-gate", &len);
+		if (reg && len == 4 && be32_to_cpup(reg))
+			power |= flag;
+		flag <<= 1;
+	}
+
+	return power;
+}
+
+#define for_each_subnode_with_property(dn, pn, prop_name) \
+	for (dn = of_find_node_with_property(pn, prop_name); dn; \
+	     dn = of_find_node_with_property(dn, prop_name))
+
+static void __init init_dt_power_topology(void)
+{
+	struct device_node *cn, *topo;
+
+	/* Get power domain topology information */
+	cn = of_find_node_by_path("/cpus/cpu-map");
+	if (!cn) {
+		pr_warn("Missing cpu-map node, bailing out\n");
+		return;
+	}
+
+	for_each_subnode_with_property(topo, cn, "cpu") {
+		struct device_node *cpu;
+
+		cpu = of_parse_phandle(topo, "cpu", 0);
+		if (cpu) {
+			u32 hwid;
+
+			of_property_read_u32(cpu, "reg", &hwid);
+			cpu_topology[get_logical_index(hwid)].flags = get_dt_power_topology(topo);
+
+		}
+	}
+}
+
 /*
  * Iterate all CPUs' descriptor in DT and compute the efficiency
  * (as per table_efficiency). Also calculate a middle efficiency
@@ -151,6 +197,8 @@ static void __init parse_dt_topology(void)
 		middle_capacity = ((max_capacity / 3)
 				>> (SCHED_POWER_SHIFT-1)) + 1;
 
+	/* Retrieve power topology information from DT */
+	init_dt_power_topology();
 }
 
 /*
@@ -266,6 +314,52 @@ void store_cpu_topology(unsigned int cpuid)
 		cpu_topology[cpuid].socket_id, mpidr);
 }
 
+#ifdef CONFIG_SCHED_SMT
+static const struct cpumask *cpu_smt_mask(int cpu)
+{
+	return topology_thread_cpumask(cpu);
+}
+#endif
+
+const struct cpumask *cpu_corepower_mask(int cpu)
+{
+	if (cpu_topology[cpu].flags & CPU_CORE_GATE)
+		return &cpu_topology[cpu].thread_sibling;
+	else
+		return &cpu_topology[cpu].core_sibling;
+}
+
+static const struct cpumask *cpu_cpupower_mask(int cpu)
+{
+	if (cpu_topology[cpu].flags & CPU_CLUSTER_GATE)
+		return &cpu_topology[cpu].core_sibling;
+	else
+		return cpumask_of_node(cpu_to_node(cpu));
+}
+
+static const struct cpumask *cpu_cpu_mask(int cpu)
+{
+	return cpumask_of_node(cpu_to_node(cpu));
+}
+
+static struct sched_domain_topology_level arm_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN },
+#endif
+#ifdef CONFIG_SCHED_MC
+	{ cpu_corepower_mask, SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN },
+	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES},
+#endif
+	{ cpu_cpupower_mask, SD_SHARE_POWERDOMAIN },
+	{ cpu_cpu_mask, },
+	{ NULL, },
+};
+
+static int __init arm_sched_topology(void)
+{
+	sched_domain_topology = arm_topology;
+}
+
 /*
  * init_cpu_topology is called at boot when only one cpu is running
  * which prevent simultaneous write access to cpu_topology array
@@ -274,6 +368,9 @@ void __init init_cpu_topology(void)
 {
 	unsigned int cpu;
 
+	/* set scheduler topology descriptor */
+	arm_sched_topology();
+
 	/* init core mask and power*/
 	for_each_possible_cpu(cpu) {
 		struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
@@ -283,7 +380,7 @@ void __init init_cpu_topology(void)
 		cpu_topo->socket_id = -1;
 		cpumask_clear(&cpu_topo->core_sibling);
 		cpumask_clear(&cpu_topo->thread_sibling);
-
+		cpu_topo->flags = 0;
 		set_power_scale(cpu, SCHED_POWER_SCALE);
 	}
 	smp_wmb();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 075a325..8cbaebf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -772,6 +772,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
@@ -893,6 +894,12 @@ typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 #define SDTL_OVERLAP	0x01
 
+struct sd_data {
+	struct sched_domain **__percpu sd;
+	struct sched_group **__percpu sg;
+	struct sched_group_power **__percpu sgp;
+};
+
 struct sched_domain_topology_level {
 	sched_domain_mask_f mask;
 	int		    sd_flags;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 73658da..8dc2a50 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4680,7 +4680,8 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_FORK |
 			 SD_BALANCE_EXEC |
 			 SD_SHARE_CPUPOWER |
-			 SD_SHARE_PKG_RESOURCES)) {
+			 SD_SHARE_PKG_RESOURCES |
+			 SD_SHARE_POWERDOMAIN)) {
 		if (sd->groups != sd->groups->next)
 			return 0;
 	}
@@ -4711,7 +4712,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
 				SD_SHARE_PKG_RESOURCES |
-				SD_PREFER_SIBLING);
+				SD_PREFER_SIBLING |
+				SD_SHARE_POWERDOMAIN);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -4978,12 +4980,6 @@ static const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
-struct sd_data {
-	struct sched_domain **__percpu sd;
-	struct sched_group **__percpu sg;
-	struct sched_group_power **__percpu sgp;
-};
-
 struct s_data {
 	struct sched_domain ** __percpu sd;
 	struct root_domain	*rd;
@@ -5345,7 +5341,8 @@ static struct cpumask ***sched_domains_numa_masks;
 	(SD_SHARE_CPUPOWER |		\
 	 SD_SHARE_PKG_RESOURCES |	\
 	 SD_NUMA |			\
-	 SD_ASYM_PACKING)
+	 SD_ASYM_PACKING |		\
+	 SD_SHARE_POWERDOMAIN)
 
 static struct sched_domain *
 sd_init(struct sched_domain_topology_level *tl, int cpu)
@@ -5464,7 +5461,7 @@ static struct sched_domain_topology_level default_topology[] = {
 	{ NULL, },
 };
 
-static struct sched_domain_topology_level *sched_domain_topology = default_topology;
+struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
 #define for_each_sd_topology(tl)			\
 	for (tl = sched_domain_topology; tl->mask; tl++)
-- 
1.7.9.5

