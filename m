Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbaIQWdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:33:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:20314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302AbaIQWdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,542,1406617200"; 
   d="scan'208";a="574739386"
Subject: [RFC][PATCH 2/6] x86: introduce cpumask specifically for the package
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 17 Sep 2014 15:33:14 -0700
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
In-Reply-To: <20140917223310.026BCC2C@viggo.jf.intel.com>
Message-Id: <20140917223314.CEE1F258@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

As noted by multiple reports:

	https://lkml.org/lkml/2014/9/15/1240
	https://lkml.org/lkml/2014/7/28/442

the sched domains code has some assumptions that break on newer
AMD and Intel CPUs.  Namely, the code assumes that NUMA node
boundaries always lie outside of a CPU package.  That assumption
is no longer true with Intel's Cluster-on-Die found in Haswell
CPUs (with a special BIOS config knob) and AMD's DCM feature.

Essentially, the 'cpu_core_map' is no longer suitable for
enumerating all the CPUs in a physical package.

This patch introduces a new map which is specifically built by
consulting the the physical package ids instead of inferring the
information from NUMA nodes.

This still leaves us with a broken 'core_siblings_list' in sysfs,
but a later patch will fix that up too.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/smp.h      |    6 ++++++
 b/arch/x86/include/asm/topology.h |    1 +
 b/arch/x86/kernel/smpboot.c       |   13 +++++++++++++
 b/arch/x86/xen/smp.c              |    1 +
 4 files changed, 21 insertions(+)

diff -puN arch/x86/include/asm/smp.h~introduce-package-sd-level arch/x86/include/asm/smp.h
--- a/arch/x86/include/asm/smp.h~introduce-package-sd-level	2014-09-17 15:28:57.075552056 -0700
+++ b/arch/x86/include/asm/smp.h	2014-09-17 15:28:57.084552469 -0700
@@ -32,6 +32,7 @@ static inline bool cpu_has_ht_siblings(v
 
 DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_core_map);
+DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_package_map);
 /* cpus sharing the last level cache: */
 DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id);
@@ -52,6 +53,11 @@ static inline struct cpumask *cpu_llc_sh
 	return per_cpu(cpu_llc_shared_map, cpu);
 }
 
+static inline struct cpumask *cpu_package_mask(int cpu)
+{
+	return per_cpu(cpu_package_map, cpu);
+}
+
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
diff -puN arch/x86/include/asm/topology.h~introduce-package-sd-level arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~introduce-package-sd-level	2014-09-17 15:28:57.077552149 -0700
+++ b/arch/x86/include/asm/topology.h	2014-09-17 15:28:57.084552469 -0700
@@ -118,6 +118,7 @@ static inline void setup_node_to_cpumask
 #include <asm-generic/topology.h>
 
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
+extern const struct cpumask *cpu_package_mask_func(int cpu);
 
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
diff -puN arch/x86/kernel/smpboot.c~introduce-package-sd-level arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~introduce-package-sd-level	2014-09-17 15:28:57.079552240 -0700
+++ b/arch/x86/kernel/smpboot.c	2014-09-17 15:28:57.085552515 -0700
@@ -98,6 +98,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_package_map);
+
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -352,6 +354,13 @@ static bool match_mc(struct cpuinfo_x86
 	return false;
 }
 
+static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	if (c->phys_proc_id == o->phys_proc_id)
+		return true;
+	return false;
+}
+
 void set_cpu_sibling_map(int cpu)
 {
 	bool has_smt = smp_num_siblings > 1;
@@ -365,6 +374,7 @@ void set_cpu_sibling_map(int cpu)
 	if (!has_mp) {
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
+		cpumask_set_cpu(cpu, cpu_package_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
 		c->booted_cores = 1;
 		return;
@@ -410,6 +420,9 @@ void set_cpu_sibling_map(int cpu)
 			} else if (i != cpu && !c->booted_cores)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
+		if ((i == cpu) || (has_mp && match_pkg(c, o))) {
+			link_mask(package, cpu, i);
+		}
 	}
 }
 
diff -puN arch/x86/xen/smp.c~introduce-package-sd-level arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c~introduce-package-sd-level	2014-09-17 15:28:57.080552285 -0700
+++ b/arch/x86/xen/smp.c	2014-09-17 15:28:57.085552515 -0700
@@ -331,6 +331,7 @@ static void __init xen_smp_prepare_cpus(
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_package_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
_
