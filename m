Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbaGNTZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:25:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbaGNTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:24:54 -0400
Date: Mon, 14 Jul 2014 12:24:39 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-26bfa5f89486a8926cd4d4ca81a04d3f0f174934@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1403609105-8332-3-git-send-email-bp@alien8.de>
References: <1403609105-8332-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, amd: Cleanup init_amd
Git-Commit-ID: 26bfa5f89486a8926cd4d4ca81a04d3f0f174934
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26bfa5f89486a8926cd4d4ca81a04d3f0f174934
Gitweb:     http://git.kernel.org/tip/26bfa5f89486a8926cd4d4ca81a04d3f0f174934
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 24 Jun 2014 13:25:04 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 14 Jul 2014 12:21:40 -0700

x86, amd: Cleanup init_amd

Distribute family-specific code to corresponding functions.

Also,

* move the direct mapping splitting around the TSEG SMM area to
bsp_init_amd().

* kill ancient comment about what we should do for K5.

* merge amd_k7_smp_check() into its only caller init_amd_k7 and drop
cpu_has_mp macro.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1403609105-8332-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c | 339 ++++++++++++++++++++++------------------------
 1 file changed, 161 insertions(+), 178 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8714a78..bc360d3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -8,6 +8,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/smp.h>
 #include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
@@ -50,7 +51,6 @@ static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
 	return wrmsr_safe_regs(gprs);
 }
 
-#ifdef CONFIG_X86_32
 /*
  *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
  *	misexecution of code under Linux. Owners of such processors should
@@ -70,6 +70,7 @@ __asm__(".globl vide\n\t.align 4\nvide: ret");
 
 static void init_amd_k5(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 /*
  * General Systems BIOSen alias the cpu frequency registers
  * of the Elan at 0x000df000. Unfortuantly, one of the Linux
@@ -83,11 +84,12 @@ static void init_amd_k5(struct cpuinfo_x86 *c)
 		if (inl(CBAR) & CBAR_ENB)
 			outl(0 | CBAR_KEY, CBAR);
 	}
+#endif
 }
 
-
 static void init_amd_k6(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 	u32 l, h;
 	int mbytes = get_num_physpages() >> (20-PAGE_SHIFT);
 
@@ -176,10 +178,44 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
 		/* placeholder for any needed mods */
 		return;
 	}
+#endif
 }
 
-static void amd_k7_smp_check(struct cpuinfo_x86 *c)
+static void init_amd_k7(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
+	u32 l, h;
+
+	/*
+	 * Bit 15 of Athlon specific MSR 15, needs to be 0
+	 * to enable SSE on Palomino/Morgan/Barton CPU's.
+	 * If the BIOS didn't enable it already, enable it here.
+	 */
+	if (c->x86_model >= 6 && c->x86_model <= 10) {
+		if (!cpu_has(c, X86_FEATURE_XMM)) {
+			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
+			msr_clear_bit(MSR_K7_HWCR, 15);
+			set_cpu_cap(c, X86_FEATURE_XMM);
+		}
+	}
+
+	/*
+	 * It's been determined by AMD that Athlons since model 8 stepping 1
+	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
+	 * As per AMD technical note 27212 0.2
+	 */
+	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
+		rdmsr(MSR_K7_CLK_CTL, l, h);
+		if ((l & 0xfff00000) != 0x20000000) {
+			printk(KERN_INFO
+			    "CPU: CLK_CTL MSR was %x. Reprogramming to %x\n",
+					l, ((l & 0x000fffff)|0x20000000));
+			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
+		}
+	}
+
+	set_cpu_cap(c, X86_FEATURE_K7);
+
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
 		return;
@@ -207,7 +243,7 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
 	    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
 	     (c->x86_model > 7))
-		if (cpu_has_mp)
+		if (cpu_has(c, X86_FEATURE_MP))
 			return;
 
 	/* If we get here, not a certified SMP capable AMD system. */
@@ -219,45 +255,8 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
 	add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
-}
-
-static void init_amd_k7(struct cpuinfo_x86 *c)
-{
-	u32 l, h;
-
-	/*
-	 * Bit 15 of Athlon specific MSR 15, needs to be 0
-	 * to enable SSE on Palomino/Morgan/Barton CPU's.
-	 * If the BIOS didn't enable it already, enable it here.
-	 */
-	if (c->x86_model >= 6 && c->x86_model <= 10) {
-		if (!cpu_has(c, X86_FEATURE_XMM)) {
-			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
-			msr_clear_bit(MSR_K7_HWCR, 15);
-			set_cpu_cap(c, X86_FEATURE_XMM);
-		}
-	}
-
-	/*
-	 * It's been determined by AMD that Athlons since model 8 stepping 1
-	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
-	 * As per AMD technical note 27212 0.2
-	 */
-	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
-		rdmsr(MSR_K7_CLK_CTL, l, h);
-		if ((l & 0xfff00000) != 0x20000000) {
-			printk(KERN_INFO
-			    "CPU: CLK_CTL MSR was %x. Reprogramming to %x\n",
-					l, ((l & 0x000fffff)|0x20000000));
-			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
-		}
-	}
-
-	set_cpu_cap(c, X86_FEATURE_K7);
-
-	amd_k7_smp_check(c);
-}
 #endif
+}
 
 #ifdef CONFIG_NUMA
 /*
@@ -446,6 +445,26 @@ static void early_init_amd_mc(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
+
+#ifdef CONFIG_X86_64
+	if (c->x86 >= 0xf) {
+		unsigned long long tseg;
+
+		/*
+		 * Split up direct mapping around the TSEG SMM area.
+		 * Don't do it for gbpages because there seems very little
+		 * benefit in doing so.
+		 */
+		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+			unsigned long pfn = tseg >> PAGE_SHIFT;
+
+			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
+			if (pfn_range_is_mapped(pfn, pfn + 1))
+				set_memory_4k((unsigned long)__va(tseg), 1);
+		}
+	}
+#endif
+
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 
 		if (c->x86 > 0x10 ||
@@ -515,10 +534,100 @@ static const int amd_erratum_383[];
 static const int amd_erratum_400[];
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
 
+static void init_amd_k8(struct cpuinfo_x86 *c)
+{
+	u32 level;
+	u64 value;
+
+	/* On C+ stepping K8 rep microcode works well for copy/memset */
+	level = cpuid_eax(1);
+	if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+	/*
+	 * Some BIOSes incorrectly force this feature, but only K8 revision D
+	 * (model = 0x14) and later actually support it.
+	 * (AMD Erratum #110, docId: 25759).
+	 */
+	if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
+		clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
+		if (!rdmsrl_amd_safe(0xc001100d, &value)) {
+			value &= ~BIT_64(32);
+			wrmsrl_amd_safe(0xc001100d, value);
+		}
+	}
+
+	if (!c->x86_model_id[0])
+		strcpy(c->x86_model_id, "Hammer");
+}
+
+static void init_amd_gh(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_64
+	/* do this for boot cpu */
+	if (c == &boot_cpu_data)
+		check_enable_amd_mmconf_dmi();
+
+	fam10h_check_enable_mmcfg();
+#endif
+
+	/*
+	 * Disable GART TLB Walk Errors on Fam10h. We do this here because this
+	 * is always needed when GART is enabled, even in a kernel which has no
+	 * MCE support built in. BIOS should disable GartTlbWlk Errors already.
+	 * If it doesn't, we do it here as suggested by the BKDG.
+	 *
+	 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
+	 */
+	msr_set_bit(MSR_AMD64_MCx_MASK(4), 10);
+
+	/*
+	 * On family 10h BIOS may not have properly enabled WC+ support, causing
+	 * it to be converted to CD memtype. This may result in performance
+	 * degradation for certain nested-paging guests. Prevent this conversion
+	 * by clearing bit 24 in MSR_AMD64_BU_CFG2.
+	 *
+	 * NOTE: we want to use the _safe accessors so as not to #GP kvm
+	 * guests on older kvm hosts.
+	 */
+	msr_clear_bit(MSR_AMD64_BU_CFG2, 24);
+
+	if (cpu_has_amd_erratum(c, amd_erratum_383))
+		set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
+}
+
+static void init_amd_bd(struct cpuinfo_x86 *c)
+{
+	u64 value;
+
+	/* re-enable TopologyExtensions if switched off by BIOS */
+	if ((c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
+	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
+
+		if (msr_set_bit(0xc0011005, 54) > 0) {
+			rdmsrl(0xc0011005, value);
+			if (value & BIT_64(54)) {
+				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
+				pr_info(FW_INFO "CPU: Re-enabling disabled Topology Extensions Support.\n");
+			}
+		}
+	}
+
+	/*
+	 * The way access filter has a performance penalty on some workloads.
+	 * Disable it on the affected CPUs.
+	 */
+	if ((c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
+		if (!rdmsrl_safe(0xc0011021, &value) && !(value & 0x1E)) {
+			value |= 0x1E;
+			wrmsrl_safe(0xc0011021, value);
+		}
+	}
+}
+
 static void init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
-	unsigned long long value;
 
 #ifdef CONFIG_SMP
 	/*
@@ -540,100 +649,29 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 */
 	clear_cpu_cap(c, 0*32+31);
 
-#ifdef CONFIG_X86_64
-	/* On C+ stepping K8 rep microcode works well for copy/memset */
-	if (c->x86 == 0xf) {
-		u32 level;
-
-		level = cpuid_eax(1);
-		if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
-			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-
-		/*
-		 * Some BIOSes incorrectly force this feature, but only K8
-		 * revision D (model = 0x14) and later actually support it.
-		 * (AMD Erratum #110, docId: 25759).
-		 */
-		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
-			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
-			if (!rdmsrl_amd_safe(0xc001100d, &value)) {
-				value &= ~(1ULL << 32);
-				wrmsrl_amd_safe(0xc001100d, value);
-			}
-		}
-
-	}
 	if (c->x86 >= 0x10)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
 	/* get apicid instead of initial apic id from cpuid */
 	c->apicid = hard_smp_processor_id();
-#else
-
-	/*
-	 *	FIXME: We should handle the K5 here. Set up the write
-	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
-	 *	no bus pipeline)
-	 */
-
-	switch (c->x86) {
-	case 4:
-		init_amd_k5(c);
-		break;
-	case 5:
-		init_amd_k6(c);
-		break;
-	case 6: /* An Athlon/Duron */
-		init_amd_k7(c);
-		break;
-	}
 
 	/* K6s reports MCEs but don't actually have all the MSRs */
 	if (c->x86 < 6)
 		clear_cpu_cap(c, X86_FEATURE_MCE);
-#endif
+
+	switch (c->x86) {
+	case 4:    init_amd_k5(c); break;
+	case 5:    init_amd_k6(c); break;
+	case 6:	   init_amd_k7(c); break;
+	case 0xf:  init_amd_k8(c); break;
+	case 0x10: init_amd_gh(c); break;
+	case 0x15: init_amd_bd(c); break;
+	}
 
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
 		set_cpu_bug(c, X86_BUG_FXSAVE_LEAK);
 
-	if (!c->x86_model_id[0]) {
-		switch (c->x86) {
-		case 0xf:
-			/* Should distinguish Models here, but this is only
-			   a fallback anyways. */
-			strcpy(c->x86_model_id, "Hammer");
-			break;
-		}
-	}
-
-	/* re-enable TopologyExtensions if switched off by BIOS */
-	if ((c->x86 == 0x15) &&
-	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
-	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
-
-		if (msr_set_bit(0xc0011005, 54) > 0) {
-			rdmsrl(0xc0011005, value);
-			if (value & BIT_64(54)) {
-				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
-				pr_info(FW_INFO "CPU: Re-enabling disabled Topology Extensions Support.\n");
-			}
-		}
-	}
-
-	/*
-	 * The way access filter has a performance penalty on some workloads.
-	 * Disable it on the affected CPUs.
-	 */
-	if ((c->x86 == 0x15) &&
-	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
-
-		if (!rdmsrl_safe(0xc0011021, &value) && !(value & 0x1E)) {
-			value |= 0x1E;
-			wrmsrl_safe(0xc0011021, value);
-		}
-	}
-
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
@@ -656,33 +694,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
 
-#ifdef CONFIG_X86_64
-	if (c->x86 == 0x10) {
-		/* do this for boot cpu */
-		if (c == &boot_cpu_data)
-			check_enable_amd_mmconf_dmi();
-
-		fam10h_check_enable_mmcfg();
-	}
-
-	if (c == &boot_cpu_data && c->x86 >= 0xf) {
-		unsigned long long tseg;
-
-		/*
-		 * Split up direct mapping around the TSEG SMM area.
-		 * Don't do it for gbpages because there seems very little
-		 * benefit in doing so.
-		 */
-		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
-			unsigned long pfn = tseg >> PAGE_SHIFT;
-
-			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-			if (pfn_range_is_mapped(pfn, pfn + 1))
-				set_memory_4k((unsigned long)__va(tseg), 1);
-		}
-	}
-#endif
-
 	/*
 	 * Family 0x12 and above processors have APIC timer
 	 * running in deep C states.
@@ -690,34 +701,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
-	if (c->x86 == 0x10) {
-		/*
-		 * Disable GART TLB Walk Errors on Fam10h. We do this here
-		 * because this is always needed when GART is enabled, even in a
-		 * kernel which has no MCE support built in.
-		 * BIOS should disable GartTlbWlk Errors already. If
-		 * it doesn't, do it here as suggested by the BKDG.
-		 *
-		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
-		 */
-		msr_set_bit(MSR_AMD64_MCx_MASK(4), 10);
-
-		/*
-		 * On family 10h BIOS may not have properly enabled WC+ support,
-		 * causing it to be converted to CD memtype. This may result in
-		 * performance degradation for certain nested-paging guests.
-		 * Prevent this conversion by clearing bit 24 in
-		 * MSR_AMD64_BU_CFG2.
-		 *
-		 * NOTE: we want to use the _safe accessors so as not to #GP kvm
-		 * guests on older kvm hosts.
-		 */
-		msr_clear_bit(MSR_AMD64_BU_CFG2, 24);
-
-		if (cpu_has_amd_erratum(c, amd_erratum_383))
-			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
-	}
-
 	if (cpu_has_amd_erratum(c, amd_erratum_400))
 		set_cpu_bug(c, X86_BUG_AMD_APIC_C1E);
 
