Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbaIPAPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:15:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:48904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbaIPAPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:15:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,531,1406617200"; 
   d="scan'208";a="573543143"
Subject: [PATCH] x86: Consider multiple nodes in a single socket to be "sane"
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, borislav.petkov@amd.com,
        andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl, mingo@kernel.org,
        hpa@linux.intel.com, ak@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Mon, 15 Sep 2014 15:26:41 -0700
Message-Id: <20140915222641.D640BD8A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm getting the spew below when booting with Haswell (Xeon
E5-2699) CPUs and the "Cluster-on-Die" (CoD) feature enabled in
the BIOS.  It seems similar to the issue that some folks from
AMD ran in to on their systems and addressed in this commit:

	http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=161270fc1f9ddfc17154e0d49291472a9cdef7db

Both these Intel and AMD systems break an assumption which is
being enforced by "topology_sane()": a socket may not contain
more than one NUMA node.

AMD special-cased their system by looking for a cpuid flag.  The
Intel mode is dependent on BIOS options and I do not know of a
way which it is enumerated other than the tables being parsed
during the CPU bringup process.

One system that does this is a weirdo that can be special-cased,
but two makes for an industry trend.  This patch removes the
sanity check completely.

This also fixes sysfs because CPUs with the same 'physical_package_id'
in /sys/devices/system/cpu/cpu*/topology/ are not listed together
in the same 'core_siblings_list'.  This violates a statement from
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

After this patch, there are only 2 sets of core siblings, which
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

Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: ak@linux.intel.com

---

 b/arch/x86/kernel/smpboot.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~hsw-cod-is-sane arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~hsw-cod-is-sane	2014-09-15 14:56:20.012314468 -0700
+++ b/arch/x86/kernel/smpboot.c	2014-09-15 14:58:58.837506644 -0700
@@ -344,10 +344,13 @@ static bool match_llc(struct cpuinfo_x86
 static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
 	if (c->phys_proc_id == o->phys_proc_id) {
-		if (cpu_has(c, X86_FEATURE_AMD_DCM))
-			return true;
-
-		return topology_sane(c, o, "mc");
+		/*
+		 * We used to enforce that 'c' and 'o' be on the
+		 * same node, but AMD's DCM and Intel's Cluster-
+		 * on-Die (CoD) support both have physical
+		 * processors that span NUMA nodes.
+		 */
+		return true;
 	}
 	return false;
 }
_
