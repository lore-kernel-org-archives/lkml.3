Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaIQMy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:54:26 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:59483 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaIQMyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:54:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAPqDGVSERCAB/2dsb2JhbABggw2BKtByAYEVFgEBeIQEAQUnUhBRVxmIPrd6hi0Yj0sHhEsFhh+FGqcXg2FpgkoBAQE
X-IPAS-Result: Ah0FAPqDGVSERCAB/2dsb2JhbABggw2BKtByAYEVFgEBeIQEAQUnUhBRVxmIPrd6hi0Yj0sHhEsFhh+FGqcXg2FpgkoBAQE
X-IronPort-AV: E=Sophos;i="5.04,540,1406581200"; 
   d="scan'208";a="122640336"
From: Nadav Amit <namit@cs.technion.ac.il>
To: bp@alien8.de
Cc: mingo@kernel.org, nadav.amit@gmail.com, pbonzini@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, Nadav Amit <namit@cs.technion.ac.il>
Subject: [RESEND PATCH 2/3] x86: Use new cpuid structs in cpuid functions
Date: Wed, 17 Sep 2014 15:54:13 +0300
Message-Id: <1410958454-7501-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code that decodes cpuid fields is somewhat cryptic, since it uses
many bit operations.  Using cpuid structs instead for clarifying the code.
Introducign no functional change.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kernel/cpu/common.c | 56 +++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b4..b57c160 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -41,6 +41,7 @@
 #include <asm/pat.h>
 #include <asm/microcode.h>
 #include <asm/microcode_intel.h>
+#include <asm/cpuid_def.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
@@ -444,13 +445,17 @@ static void get_model_name(struct cpuinfo_x86 *c)
 
 void cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 {
-	unsigned int n, dummy, ebx, ecx, edx, l2size;
+	unsigned int n, dummy, dummy2, l2size;
+	union cpuid8_5_ecx_edx ecx5, edx5;
+	union cpuid8_6_ebx ebx6;
+	union cpuid8_6_ecx ecx6;
 
 	n = c->extended_cpuid_level;
 
 	if (n >= 0x80000005) {
-		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
-		c->x86_cache_size = (ecx>>24) + (edx>>24);
+		cpuid(0x80000005, &dummy, &dummy2, &ecx5.full, &edx5.full);
+		c->x86_cache_size = ecx5.split.cache_size +
+				    edx5.split.cache_size;
 #ifdef CONFIG_X86_64
 		/* On K8 L1 TLB is inclusive, so don't count it */
 		c->x86_tlbsize = 0;
@@ -460,11 +465,11 @@ void cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
 		return;
 
-	cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
-	l2size = ecx >> 16;
+	cpuid(0x80000006, &dummy, &ebx6.full, &ecx6.full, &dummy2);
+	l2size = ecx6.split.cache_size;
 
 #ifdef CONFIG_X86_64
-	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
+	c->x86_tlbsize += ebx6.split.dtlb_entries + ebx6.split.itlb_entries;
 #else
 	/* do processor-specific cache resizing */
 	if (this_cpu->legacy_cache_size)
@@ -505,9 +510,10 @@ void cpu_detect_tlb(struct cpuinfo_x86 *c)
 void detect_ht(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
-	u32 eax, ebx, ecx, edx;
+	u32 eax, ecx, edx;
 	int index_msb, core_bits;
 	static bool printed;
+	union cpuid1_ebx ebx;
 
 	if (!cpu_has(c, X86_FEATURE_HT))
 		return;
@@ -518,9 +524,9 @@ void detect_ht(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
 		return;
 
-	cpuid(1, &eax, &ebx, &ecx, &edx);
+	cpuid(1, &eax, &ebx.full, &ecx, &edx);
 
-	smp_num_siblings = (ebx & 0xff0000) >> 16;
+	smp_num_siblings = ebx.split.max_logical_proc;
 
 	if (smp_num_siblings == 1) {
 		printk_once(KERN_INFO "CPU0: Hyper-Threading is disabled\n");
@@ -591,20 +597,22 @@ void cpu_detect(struct cpuinfo_x86 *c)
 	c->x86 = 4;
 	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
-		u32 junk, tfms, cap0, misc;
+		u32 junk, cap0;
+		union cpuid1_eax tfms;
+		union cpuid1_ebx misc;
 
-		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
-		c->x86 = (tfms >> 8) & 0xf;
-		c->x86_model = (tfms >> 4) & 0xf;
-		c->x86_mask = tfms & 0xf;
+		cpuid(0x00000001, &tfms.full, &misc.full, &junk, &cap0);
+		c->x86 = tfms.split.family_id;
+		c->x86_model = tfms.split.model;
+		c->x86_mask = tfms.split.stepping_id;
 
 		if (c->x86 == 0xf)
-			c->x86 += (tfms >> 20) & 0xff;
+			c->x86 += tfms.split.extended_family_id;
 		if (c->x86 >= 0x6)
-			c->x86_model += ((tfms >> 16) & 0xf) << 4;
+			c->x86_model += tfms.split.extended_model_id << 4;
 
-		if (cap0 & (1<<19)) {
-			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
+		if (cap0 & (1 << (X86_FEATURE_CLFLUSH & 31))) {
+			c->x86_clflush_size = misc.split.clflush_size * 8;
 			c->x86_cache_alignment = c->x86_clflush_size;
 		}
 	}
@@ -654,10 +662,11 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	}
 
 	if (c->extended_cpuid_level >= 0x80000008) {
-		u32 eax = cpuid_eax(0x80000008);
+		union cpuid_8_8_eax eax;
 
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
+		eax.full = cpuid_eax(0x80000008);
+		c->x86_virt_bits = eax.split.virt_as;
+		c->x86_phys_bits = eax.split.phys_as;
 	}
 #ifdef CONFIG_X86_32
 	else if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
@@ -814,7 +823,10 @@ static void generic_identify(struct cpuinfo_x86 *c)
 	get_cpu_cap(c);
 
 	if (c->cpuid_level >= 0x00000001) {
-		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
+		union cpuid1_ebx ebx;
+
+		ebx.full = cpuid_ebx(1);
+		c->initial_apicid = ebx.split.initial_apicid;
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_HT
 		c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
-- 
1.9.1

