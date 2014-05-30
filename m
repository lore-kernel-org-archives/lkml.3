Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaE3Lnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaE3Lnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:43:42 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jan Beulich <JBeulich@suse.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>
Subject: [PATCH 1/2] x86, Clean up smp_num_siblings calculation
Date: Fri, 30 May 2014 07:43:04 -0400
Message-Id: <1401450185-23061-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1401450185-23061-1-git-send-email-prarit@redhat.com>
References: <1401450185-23061-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a system on which I have disabled threading in the BIOS, and I am booting
the kernel with the option "idle=poll".

The kernel displays

process: WARNING: polling idle and HT enabled, performance may degrade

which is incorrect -- I've already disabled HT.

This warning is issued here:

void select_idle_routine(const struct cpuinfo_x86 *c)
{
        if (boot_option_idle_override == IDLE_POLL && smp_num_siblings > 1)
                pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");

>From my understanding of the other ares of kernel that use
smp_num_siblings, the value is supposed to be the the number of threads
per core.

The value of smp_num_siblings is incorrect.  In theory, it should be 1 but it
is reported as 2.  When I looked into how smp_num_siblings is calculated I
found the following call sequence in the kernel:

start_kernel ->
        check_bugs ->
                identify_boot_cpu ->
                                identify_cpu ->
                                        c_init = init_intel
                                                init_intel ->
                                                        detect_extended_topology
                                                        (sets value)

                                        OR

                                        c_init = init_amd
                                                init_amd -> amd_detect_cmp
                                                             -> amd_get_topology
                                                                (sets value)
                                                         -> detect_ht()
                                        ...		    (sets value)
                                        detect_ht()
                                        (also sets value)

ie) it is set three times in some cases and is overwritten by the call
to detect_ht() from identify_cpu() in all cases.

It should be noted that nothing in the identify_cpu() path or the cpu_up()
path requires smp_num_siblings to be set, prior to the final call to
detect_ht().

For x86 boxes, smp_num_siblings is set to a value read in a CPUID call in
detect_ht().  This value is the *factory defined* value in all cases; even
if HT is disabled in BIOS the value still returns 2 if the CPU supports
HT.  AMD also reports the factory defined value in all cases.

Other uses of smp_num_siblings involve oprofile (used after boot), and
the perf code which is done well after the initial cpus are brought online.

This patch removes dead code and moves the assignment of smp_num_siblings
to only the detect_ht() code; it is still always reporting 2.  A follow
on patch will fix the calculation.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Borislav Petkov <bp@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 arch/x86/kernel/cpu/amd.c      |    1 -
 arch/x86/kernel/cpu/common.c   |   23 +++++++++++------------
 arch/x86/kernel/cpu/topology.c |    2 +-
 arch/x86/kernel/smpboot.c      |    5 ++---
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff..6aca2b6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -304,7 +304,6 @@ static void amd_get_topology(struct cpuinfo_x86 *c)
 		node_id = ecx & 7;
 
 		/* get compute unit information */
-		smp_num_siblings = ((ebx >> 8) & 3) + 1;
 		c->compute_unit_id = ebx & 0xff;
 		cores_per_cu += ((ebx >> 8) & 3);
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..fc1235c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -507,42 +507,41 @@ void detect_ht(struct cpuinfo_x86 *c)
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
 	static bool printed;
+	int threads_per_core;
 
 	if (!cpu_has(c, X86_FEATURE_HT))
 		return;
 
-	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
+	if (cpu_has(c, X86_FEATURE_CMP_LEGACY)) {
+		threads_per_core = 1;
 		goto out;
+	}
 
 	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
 		return;
 
 	cpuid(1, &eax, &ebx, &ecx, &edx);
 
-	smp_num_siblings = (ebx & 0xff0000) >> 16;
+	threads_per_core = smp_num_siblings = (ebx & 0xff0000) >> 16;
 
-	if (smp_num_siblings == 1) {
-		printk_once(KERN_INFO "CPU0: Hyper-Threading is disabled\n");
+	if (threads_per_core <= 1) {
+		pr_info_once("CPU: Hyper-Threading is unsupported on this processor.\n");
 		goto out;
 	}
 
-	if (smp_num_siblings <= 1)
-		goto out;
-
-	index_msb = get_count_order(smp_num_siblings);
+	index_msb = get_count_order(threads_per_core);
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
 
-	smp_num_siblings = smp_num_siblings / c->x86_max_cores;
+	threads_per_core = threads_per_core / c->x86_max_cores;
 
-	index_msb = get_count_order(smp_num_siblings);
+	index_msb = get_count_order(threads_per_core);
 
 	core_bits = get_count_order(c->x86_max_cores);
 
 	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, index_msb) &
 				       ((1 << core_bits) - 1);
-
 out:
-	if (!printed && (c->x86_max_cores * smp_num_siblings) > 1) {
+	if (!printed && (c->x86_max_cores * threads_per_core) > 1) {
 		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
 		       c->phys_proc_id);
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 4c60eaf..a9b837e 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -55,7 +55,7 @@ void detect_extended_topology(struct cpuinfo_x86 *c)
 	/*
 	 * Populate HT related information from sub-leaf level 0.
 	 */
-	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
+	core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
 	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 
 	sub_index = 1;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3482693..b2ad27c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -351,8 +351,7 @@ static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 
 void set_cpu_sibling_map(int cpu)
 {
-	bool has_smt = smp_num_siblings > 1;
-	bool has_mp = has_smt || boot_cpu_data.x86_max_cores > 1;
+	bool has_mp = boot_cpu_data.x86_max_cores > 1;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct cpuinfo_x86 *o;
 	int i;
@@ -370,7 +369,7 @@ void set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		o = &cpu_data(i);
 
-		if ((i == cpu) || (has_smt && match_smt(c, o)))
+		if ((i == cpu) || match_smt(c, o))
 			link_mask(sibling, cpu, i);
 
 		if ((i == cpu) || (has_mp && match_llc(c, o)))
-- 
1.7.9.3

