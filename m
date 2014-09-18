Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaIRTdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:33:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:31103 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbaIRTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:33:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,548,1406617200"; 
   d="scan'208";a="478513962"
Subject: [PATCH] x86: new topology for multi-NUMA-node CPUs
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        a.p.zijlstra@chello.nl, mingo@kernel.org, hpa@linux.intel.com,
        brice.goglin@gmail.com, bp@alien8.de
From: Dave Hansen <dave@sr71.net>
Date: Thu, 18 Sep 2014 12:33:34 -0700
Message-Id: <20140918193334.C065EBCE@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This is my third attempt to fix this.  It's definitely simpler
than the previous set.  This takes Peter Z's suggestion to just
create and use a different topology when we see these
"Cluster-on-Die" systems.

--
From: Dave Hansen <dave.hansen@linux.intel.com>

I'm getting the spew below when booting with Haswell (Xeon
E5-2699 v3) CPUs and the "Cluster-on-Die" (CoD) feature enabled
in the BIOS.  It seems similar to the issue that some folks from
AMD ran in to on their systems and addressed in this commit:

	http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=161270fc1f9ddfc17154e0d49291472a9cdef7db

Both these Intel and AMD systems break an assumption which is
being enforced by topology_sane(): a socket may not contain more
than one NUMA node.

AMD special-cased their system by looking for a cpuid flag.  The
Intel mode is dependent on BIOS options and I do not know of a
way which it is enumerated other than the tables being parsed
during the CPU bringup process.  In other words, we have to trust
the ACPI tables <shudder>.

This detects the situation where a NUMA node occurs at a place in
the middle of the "CPU" sched domains.  It replaces the default
topology with one that relies on the NUMA information from the
firmware (SRAT table) for all levels of sched domains above the
hyperthreads.

This also fixes a sysfs bug.  We used to freak out when we saw
the "mc" group cross a node boundary, so we stopped building the
MC group.  MC gets exported as the 'core_siblings_list' in
/sys/devices/system/cpu/cpu*/topology/ and this caused CPUs with
the same 'physical_package_id' to not be listed together in
'core_siblings_list'.  This violates a statement from
Documentation/ABI/testing/sysfs-devices-system-cpu:

	core_siblings: internal kernel map of cpu#'s hardware threads
	within the same physical_package_id.

	core_siblings_list: human-readable list of the logical CPU
	numbers within the same physical_package_id as cpu#.

The sysfs effects here cause an issue with the hwloc tool where
it gets confused and thinks there are more sockets than are
physically present.

Before this patch, there are two packages:

# cd /sys/devices/system/cpu/
# cat cpu*/topology/physical_package_id | sort | uniq -c
     18 0
     18 1

But 4 _sets_ of core siblings:

# cat cpu*/topology/core_siblings_list | sort | uniq -c
      9 0-8
      9 18-26
      9 27-35
      9 9-17

After this set, there are only 2 sets of core siblings, which
is what we expect for a 2-socket system.

# cat cpu*/topology/physical_package_id | sort | uniq -c
     18 0
     18 1
# cat cpu*/topology/core_siblings_list | sort | uniq -c
     18 0-17
     18 18-35


Example spew:
...
	NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
	 #2  #3  #4  #5  #6  #7  #8
	.... node  #1, CPUs:    #9
	------------[ cut here ]------------
	WARNING: CPU: 9 PID: 0 at /home/ak/hle/linux-hle-2.6/arch/x86/kernel/smpboot.c:306 topology_sane.isra.2+0x74/0x90()
	sched: CPU #9's mc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.
	Modules linked in:
	CPU: 9 PID: 0 Comm: swapper/9 Not tainted 3.17.0-rc1-00293-g8e01c4d-dirty #631
	Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0036.R05.1407140519 07/14/2014
	0000000000000009 ffff88046ddabe00 ffffffff8172e485 ffff88046ddabe48
	ffff88046ddabe38 ffffffff8109691d 000000000000b001 0000000000000009
	ffff88086fc12580 000000000000b020 0000000000000009 ffff88046ddabe98
	Call Trace:
	[<ffffffff8172e485>] dump_stack+0x45/0x56
	[<ffffffff8109691d>] warn_slowpath_common+0x7d/0xa0
	[<ffffffff8109698c>] warn_slowpath_fmt+0x4c/0x50
	[<ffffffff81074f94>] topology_sane.isra.2+0x74/0x90
	[<ffffffff8107530e>] set_cpu_sibling_map+0x31e/0x4f0
	[<ffffffff8107568d>] start_secondary+0x1ad/0x240
	---[ end trace 3fe5f587a9fcde61 ]---
	#10 #11 #12 #13 #14 #15 #16 #17
	.... node  #2, CPUs:   #18 #19 #20 #21 #22 #23 #24 #25 #26
	.... node  #3, CPUs:   #27 #28 #29 #30 #31 #32 #33 #34 #35

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
rc: ak@linux.intel.com
Cc: brice.goglin@gmail.com
Cc: bp@alien8.de
---

 b/arch/x86/kernel/smpboot.c |   48 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~ignore-mc-sanity-check arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~ignore-mc-sanity-check	2014-09-18 11:23:03.422187764 -0700
+++ b/arch/x86/kernel/smpboot.c	2014-09-18 12:32:01.622256575 -0700
@@ -296,11 +296,19 @@ void smp_store_cpu_info(int id)
 }
 
 static bool
+topology_same_node(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+
+	return (cpu_to_node(cpu1) == cpu_to_node(cpu2));
+}
+
+static bool
 topology_sane(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o, const char *name)
 {
 	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
-	return !WARN_ONCE(cpu_to_node(cpu1) != cpu_to_node(cpu2),
+	return !WARN_ONCE(!topology_same_node(c, o),
 		"sched: CPU #%d's %s-sibling CPU #%d is not on the same node! "
 		"[node: %d != %d]. Ignoring dependency.\n",
 		cpu1, name, cpu2, cpu_to_node(cpu1), cpu_to_node(cpu2));
@@ -341,17 +349,41 @@ static bool match_llc(struct cpuinfo_x86
 	return false;
 }
 
+/*
+ * Unlike the other levels, we do not enforce keeping a
+ * multicore group inside a NUMA node.  If this happens, we will
+ * discard the MC level of the topology later.
+ */
 static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (c->phys_proc_id == o->phys_proc_id) {
-		if (cpu_has(c, X86_FEATURE_AMD_DCM))
-			return true;
-
-		return topology_sane(c, o, "mc");
-	}
+	if (c->phys_proc_id == o->phys_proc_id)
+		return true;
 	return false;
 }
 
+static struct sched_domain_topology_level numa_inside_package_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
+#endif
+	{ NULL, },
+};
+/*
+ * set_sched_topology() sets the topology internal to a CPU.  The
+ * NUMA topologies are layered on top of it to build the full
+ * system topology.
+ *
+ * If NUMA nodes are observed to occur within a CPU package, this
+ * function should be called.  It forces the sched domain code to
+ * only use the SMT level for the CPU portion of the topology.
+ * This essentially falls back to relying on NUMA information
+ * from the SRAT table to describe the entire system topology
+ * (except for hyperthreads).
+ */
+static void primarily_use_numa_for_topology(void)
+{
+	set_sched_topology(numa_inside_package_topology);
+}
+
 void set_cpu_sibling_map(int cpu)
 {
 	bool has_smt = smp_num_siblings > 1;
@@ -410,6 +442,8 @@ void set_cpu_sibling_map(int cpu)
 			} else if (i != cpu && !c->booted_cores)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
+		if (match_mc(c, o) == !topology_same_node(c, o))
+			primarily_use_numa_for_topology();
 	}
 }
 
_
