Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaCaOXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:23:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54667 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaCaOXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:23:06 -0400
Date: Mon, 31 Mar 2014 16:23:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.15
Message-ID: <20140331142302.GA10913@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   # HEAD: 69f2366c9456d0ce784cf5aba87ee77eeadc1d5e x86, cpu: Add forcepae parameter for booting PAE kernels on PAE-disabled Pentium M

Bigger changes:

  - Intel CPU hardware-enablement: new vector instructions support 
    (AVX-512), by Fenghua Yu.

  - Support the clflushopt instruction and use it in appropriate
    places. clflushopt is similar to clflush but with more relaxed 
    ordering, by Ross Zwisler.

  - MSR accessor cleanups, by Borislav Petkov.

  - 'forcepae' boot flag for those who have way too much time to spend 
    on way too old Pentium-M systems and want to live way too 
    dangerously, by Chris Bainbridge.


  out-of-topic modifications in x86-cpu-for-linus:
  --------------------------------------------------
  drivers/gpu/drm/drm_cache.c        # 2a0788d: x86: Use clflushopt in drm_clflus
                                   # 2a0c772: x86: Use clflushopt in drm_clflus
  include/linux/kernel.h             # 8c90487: Rename TAINT_UNSAFE_SMP to TAINT_
  kernel/module.c                    # 8c90487: Rename TAINT_UNSAFE_SMP to TAINT_

 Thanks,

	Ingo

------------------>
Borislav Petkov (3):
      x86: Add another set of MSR accessor functions
      x86, AMD: Convert to the new bit access MSR accessors
      x86, Intel: Convert to the new bit access MSR accessors

Chris Bainbridge (1):
      x86, cpu: Add forcepae parameter for booting PAE kernels on PAE-disabled Pentium M

Dave Jones (1):
      Rename TAINT_UNSAFE_SMP to TAINT_CPU_OUT_OF_SPEC

Fenghua Yu (2):
      x86, AVX-512: AVX-512 Feature Detection
      x86, AVX-512: Enable AVX-512 States Context Switch

H. Peter Anvin (1):
      x86, intel: Make MSR_IA32_MISC_ENABLE bit constants systematic

Ross Zwisler (4):
      x86: Add support for the clflushopt instruction
      x86: Use clflushopt in clflush_cache_range
      x86: Use clflushopt in drm_clflush_page
      x86: Use clflushopt in drm_clflush_virt_range


 Documentation/kernel-parameters.txt   |  7 +++
 arch/x86/boot/cpucheck.c              | 20 ++++++++
 arch/x86/include/asm/cpufeature.h     |  5 ++
 arch/x86/include/asm/msr.h            |  2 +
 arch/x86/include/asm/special_insns.h  |  8 ++++
 arch/x86/include/asm/xsave.h          | 16 ++++---
 arch/x86/include/uapi/asm/msr-index.h | 75 +++++++++++++++++++----------
 arch/x86/kernel/cpu/amd.c             | 50 +++++---------------
 arch/x86/kernel/cpu/intel.c           | 53 ++++++++++++---------
 arch/x86/lib/msr.c                    | 89 ++++++++++++++++++++++++++++++++++-
 arch/x86/mm/pageattr.c                |  8 ++--
 drivers/gpu/drm/drm_cache.c           | 10 +++-
 include/linux/kernel.h                |  2 +-
 kernel/module.c                       |  2 +-
 kernel/panic.c                        |  2 +-
 15 files changed, 248 insertions(+), 101 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..06600cc 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1011,6 +1011,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			parameter will force ia64_sal_cache_flush to call
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
+	forcepae [X86-32]
+			Forcefully enable Physical Address Extension (PAE).
+			Many Pentium M systems disable PAE but may have a
+			functionally usable PAE implementation.
+			Warning: use of this parameter will taint the kernel
+			and may cause unknown problems.
+
 	ftrace=[tracer]
 			[FTRACE] will set and start the specified tracer
 			as early as possible in order to facilitate early
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 100a9a1..f0d0b20 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -67,6 +67,13 @@ static int is_transmeta(void)
 	       cpu_vendor[2] == A32('M', 'x', '8', '6');
 }
 
+static int is_intel(void)
+{
+	return cpu_vendor[0] == A32('G', 'e', 'n', 'u') &&
+	       cpu_vendor[1] == A32('i', 'n', 'e', 'I') &&
+	       cpu_vendor[2] == A32('n', 't', 'e', 'l');
+}
+
 /* Returns a bitmask of which words we have error bits in */
 static int check_cpuflags(void)
 {
@@ -153,6 +160,19 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
 		err = check_cpuflags();
+	} else if (err == 0x01 &&
+		   !(err_flags[0] & ~(1 << X86_FEATURE_PAE)) &&
+		   is_intel() && cpu.level == 6 &&
+		   (cpu.model == 9 || cpu.model == 13)) {
+		/* PAE is disabled on this Pentium M but can be forced */
+		if (cmdline_find_option_bool("forcepae")) {
+			puts("WARNING: Forcing PAE in CPU flags\n");
+			set_bit(X86_FEATURE_PAE, cpu.flags);
+			err = check_cpuflags();
+		}
+		else {
+			puts("WARNING: PAE disabled. Use parameter 'forcepae' to enable at your own risk!\n");
+		}
 	}
 
 	if (err_flags_ptr)
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e099f95..bc507d7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -217,9 +217,14 @@
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
+#define X86_FEATURE_AVX512F	(9*32+16) /* AVX-512 Foundation */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_CLFLUSHOPT	(9*32+23) /* CLFLUSHOPT instruction */
+#define X86_FEATURE_AVX512PF	(9*32+26) /* AVX-512 Prefetch */
+#define X86_FEATURE_AVX512ER	(9*32+27) /* AVX-512 Exponential and Reciprocal */
+#define X86_FEATURE_AVX512CD	(9*32+28) /* AVX-512 Conflict Detection */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index e139b13..de36f22 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -214,6 +214,8 @@ do {                                                            \
 
 struct msr *msrs_alloc(void);
 void msrs_free(struct msr *msrs);
+int msr_set_bit(u32 msr, u8 bit);
+int msr_clear_bit(u32 msr, u8 bit);
 
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 645cad2..e820c08 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -191,6 +191,14 @@ static inline void clflush(volatile void *__p)
 	asm volatile("clflush %0" : "+m" (*(volatile char __force *)__p));
 }
 
+static inline void clflushopt(volatile void *__p)
+{
+	alternative_io(".byte " __stringify(NOP_DS_PREFIX) "; clflush %P0",
+		       ".byte 0x66; clflush %P0",
+		       X86_FEATURE_CLFLUSHOPT,
+		       "+m" (*(volatile char __force *)__p));
+}
+
 #define nop() asm volatile ("nop")
 
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 5547389..6c1d741 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -6,11 +6,14 @@
 
 #define XSTATE_CPUID		0x0000000d
 
-#define XSTATE_FP	0x1
-#define XSTATE_SSE	0x2
-#define XSTATE_YMM	0x4
-#define XSTATE_BNDREGS	0x8
-#define XSTATE_BNDCSR	0x10
+#define XSTATE_FP		0x1
+#define XSTATE_SSE		0x2
+#define XSTATE_YMM		0x4
+#define XSTATE_BNDREGS		0x8
+#define XSTATE_BNDCSR		0x10
+#define XSTATE_OPMASK		0x20
+#define XSTATE_ZMM_Hi256	0x40
+#define XSTATE_Hi16_ZMM		0x80
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -23,7 +26,8 @@
 #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET)
 
 /* Supported features which support lazy state saving */
-#define XSTATE_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XSTATE_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM		      \
+			| XSTATE_OPMASK | XSTATE_ZMM_Hi256 | XSTATE_Hi16_ZMM)
 
 /* Supported features which require eager state saving */
 #define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index c19fc60..4924f4b 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -368,33 +368,58 @@
 #define THERM_LOG_THRESHOLD1           (1 << 9)
 
 /* MISC_ENABLE bits: architectural */
-#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
-#define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
-#define MSR_IA32_MISC_ENABLE_EMON		(1ULL << 7)
-#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL	(1ULL << 11)
-#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL	(1ULL << 12)
-#define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP	(1ULL << 16)
-#define MSR_IA32_MISC_ENABLE_MWAIT		(1ULL << 18)
-#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << 22)
-#define MSR_IA32_MISC_ENABLE_XTPR_DISABLE	(1ULL << 23)
-#define MSR_IA32_MISC_ENABLE_XD_DISABLE		(1ULL << 34)
+#define MSR_IA32_MISC_ENABLE_FAST_STRING_BIT		0
+#define MSR_IA32_MISC_ENABLE_FAST_STRING		(1ULL << MSR_IA32_MISC_ENABLE_FAST_STRING_BIT)
+#define MSR_IA32_MISC_ENABLE_TCC_BIT			1
+#define MSR_IA32_MISC_ENABLE_TCC			(1ULL << MSR_IA32_MISC_ENABLE_TCC_BIT)
+#define MSR_IA32_MISC_ENABLE_EMON_BIT			7
+#define MSR_IA32_MISC_ENABLE_EMON			(1ULL << MSR_IA32_MISC_ENABLE_EMON_BIT)
+#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL_BIT		11
+#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL		(1ULL << MSR_IA32_MISC_ENABLE_BTS_UNAVAIL_BIT)
+#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL_BIT		12
+#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL		(1ULL << MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL_BIT)
+#define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP_BIT	16
+#define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP		(1ULL << MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP_BIT)
+#define MSR_IA32_MISC_ENABLE_MWAIT_BIT			18
+#define MSR_IA32_MISC_ENABLE_MWAIT			(1ULL << MSR_IA32_MISC_ENABLE_MWAIT_BIT)
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT		22
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT);
+#define MSR_IA32_MISC_ENABLE_XTPR_DISABLE_BIT		23
+#define MSR_IA32_MISC_ENABLE_XTPR_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_XTPR_DISABLE_BIT)
+#define MSR_IA32_MISC_ENABLE_XD_DISABLE_BIT		34
+#define MSR_IA32_MISC_ENABLE_XD_DISABLE			(1ULL << MSR_IA32_MISC_ENABLE_XD_DISABLE_BIT)
 
 /* MISC_ENABLE bits: model-specific, meaning may vary from core to core */
-#define MSR_IA32_MISC_ENABLE_X87_COMPAT		(1ULL << 2)
-#define MSR_IA32_MISC_ENABLE_TM1		(1ULL << 3)
-#define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE	(1ULL << 4)
-#define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE	(1ULL << 6)
-#define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK	(1ULL << 8)
-#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE	(1ULL << 9)
-#define MSR_IA32_MISC_ENABLE_FERR		(1ULL << 10)
-#define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX	(1ULL << 10)
-#define MSR_IA32_MISC_ENABLE_TM2		(1ULL << 13)
-#define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE	(1ULL << 19)
-#define MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK	(1ULL << 20)
-#define MSR_IA32_MISC_ENABLE_L1D_CONTEXT	(1ULL << 24)
-#define MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE	(1ULL << 37)
-#define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
-#define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
+#define MSR_IA32_MISC_ENABLE_X87_COMPAT_BIT		2
+#define MSR_IA32_MISC_ENABLE_X87_COMPAT			(1ULL << MSR_IA32_MISC_ENABLE_X87_COMPAT_BIT)
+#define MSR_IA32_MISC_ENABLE_TM1_BIT			3
+#define MSR_IA32_MISC_ENABLE_TM1			(1ULL << MSR_IA32_MISC_ENABLE_TM1_BIT)
+#define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE_BIT	4
+#define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE_BIT)
+#define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE_BIT	6
+#define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE_BIT)
+#define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK_BIT		8
+#define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK		(1ULL << MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK_BIT)
+#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE_BIT	9
+#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE_BIT)
+#define MSR_IA32_MISC_ENABLE_FERR_BIT			10
+#define MSR_IA32_MISC_ENABLE_FERR			(1ULL << MSR_IA32_MISC_ENABLE_FERR_BIT)
+#define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT		10
+#define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX		(1ULL << MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT)
+#define MSR_IA32_MISC_ENABLE_TM2_BIT			13
+#define MSR_IA32_MISC_ENABLE_TM2			(1ULL << MSR_IA32_MISC_ENABLE_TM2_BIT)
+#define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE_BIT	19
+#define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE_BIT)
+#define MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK_BIT		20
+#define MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK		(1ULL << MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK_BIT)
+#define MSR_IA32_MISC_ENABLE_L1D_CONTEXT_BIT		24
+#define MSR_IA32_MISC_ENABLE_L1D_CONTEXT		(1ULL << MSR_IA32_MISC_ENABLE_L1D_CONTEXT_BIT)
+#define MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE_BIT	37
+#define MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE_BIT)
+#define MSR_IA32_MISC_ENABLE_TURBO_DISABLE_BIT		38
+#define MSR_IA32_MISC_ENABLE_TURBO_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_TURBO_DISABLE_BIT)
+#define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE_BIT	39
+#define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE_BIT)
 
 #define MSR_IA32_TSC_DEADLINE		0x000006E0
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c67ffa6..ce8b8ff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -218,7 +218,7 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	 */
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
-	add_taint(TAINT_UNSAFE_SMP, LOCKDEP_NOW_UNRELIABLE);
+	add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
 }
 
 static void init_amd_k7(struct cpuinfo_x86 *c)
@@ -233,9 +233,7 @@ static void init_amd_k7(struct cpuinfo_x86 *c)
 	if (c->x86_model >= 6 && c->x86_model <= 10) {
 		if (!cpu_has(c, X86_FEATURE_XMM)) {
 			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
-			rdmsr(MSR_K7_HWCR, l, h);
-			l &= ~0x00008000;
-			wrmsr(MSR_K7_HWCR, l, h);
+			msr_clear_bit(MSR_K7_HWCR, 15);
 			set_cpu_cap(c, X86_FEATURE_XMM);
 		}
 	}
@@ -509,14 +507,8 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	/* F16h erratum 793, CVE-2013-6885 */
-	if (c->x86 == 0x16 && c->x86_model <= 0xf) {
-		u64 val;
-
-		rdmsrl(MSR_AMD64_LS_CFG, val);
-		if (!(val & BIT(15)))
-			wrmsrl(MSR_AMD64_LS_CFG, val | BIT(15));
-	}
-
+	if (c->x86 == 0x16 && c->x86_model <= 0xf)
+		msr_set_bit(MSR_AMD64_LS_CFG, 15);
 }
 
 static const int amd_erratum_383[];
@@ -536,11 +528,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 * Errata 63 for SH-B3 steppings
 	 * Errata 122 for all steppings (F+ have it disabled by default)
 	 */
-	if (c->x86 == 0xf) {
-		rdmsrl(MSR_K7_HWCR, value);
-		value |= 1 << 6;
-		wrmsrl(MSR_K7_HWCR, value);
-	}
+	if (c->x86 == 0xf)
+		msr_set_bit(MSR_K7_HWCR, 6);
 #endif
 
 	early_init_amd(c);
@@ -623,14 +612,11 @@ static void init_amd(struct cpuinfo_x86 *c)
 	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
 	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
 
-		if (!rdmsrl_safe(0xc0011005, &value)) {
-			value |= 1ULL << 54;
-			wrmsrl_safe(0xc0011005, value);
+		if (msr_set_bit(0xc0011005, 54) > 0) {
 			rdmsrl(0xc0011005, value);
-			if (value & (1ULL << 54)) {
+			if (value & BIT_64(54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
-				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
-				  "disabled Topology Extensions Support\n");
+				pr_info(FW_INFO "CPU: Re-enabling disabled Topology Extensions Support.\n");
 			}
 		}
 	}
@@ -709,19 +695,12 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * Disable GART TLB Walk Errors on Fam10h. We do this here
 		 * because this is always needed when GART is enabled, even in a
 		 * kernel which has no MCE support built in.
-		 * BIOS should disable GartTlbWlk Errors themself. If
-		 * it doesn't do it here as suggested by the BKDG.
+		 * BIOS should disable GartTlbWlk Errors already. If
+		 * it doesn't, do it here as suggested by the BKDG.
 		 *
 		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 		 */
-		u64 mask;
-		int err;
-
-		err = rdmsrl_safe(MSR_AMD64_MCx_MASK(4), &mask);
-		if (err == 0) {
-			mask |= (1 << 10);
-			wrmsrl_safe(MSR_AMD64_MCx_MASK(4), mask);
-		}
+		msr_set_bit(MSR_AMD64_MCx_MASK(4), 10);
 
 		/*
 		 * On family 10h BIOS may not have properly enabled WC+ support,
@@ -733,10 +712,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * NOTE: we want to use the _safe accessors so as not to #GP kvm
 		 * guests on older kvm hosts.
 		 */
-
-		rdmsrl_safe(MSR_AMD64_BU_CFG2, &value);
-		value &= ~(1ULL << 24);
-		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
+		msr_clear_bit(MSR_AMD64_BU_CFG2, 24);
 
 		if (cpu_has_amd_erratum(c, amd_erratum_383))
 			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5cd9bfa..897d620 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -31,11 +31,8 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-
-		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
-			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
-			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		if (msr_clear_bit(MSR_IA32_MISC_ENABLE,
+				  MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT) > 0) {
 			c->cpuid_level = cpuid_eax(0);
 			get_cpu_cap(c);
 		}
@@ -129,16 +126,10 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * Ingo Molnar reported a Pentium D (model 6) and a Xeon
 	 * (model 2) with the same problem.
 	 */
-	if (c->x86 == 15) {
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-
-		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
-			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
-
-			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
-			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-		}
-	}
+	if (c->x86 == 15)
+		if (msr_clear_bit(MSR_IA32_MISC_ENABLE,
+				  MSR_IA32_MISC_ENABLE_FAST_STRING_BIT) > 0)
+			pr_info("kmemcheck: Disabling fast string operations\n");
 #endif
 
 	/*
@@ -195,10 +186,16 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
 	}
 }
 
-static void intel_workarounds(struct cpuinfo_x86 *c)
+static int forcepae;
+static int __init forcepae_setup(char *__unused)
 {
-	unsigned long lo, hi;
+	forcepae = 1;
+	return 1;
+}
+__setup("forcepae", forcepae_setup);
 
+static void intel_workarounds(struct cpuinfo_x86 *c)
+{
 #ifdef CONFIG_X86_F00F_BUG
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
@@ -225,16 +222,26 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
+	 * PAE CPUID issue: many Pentium M report no PAE but may have a
+	 * functionally usable PAE implementation.
+	 * Forcefully enable PAE if kernel parameter "forcepae" is present.
+	 */
+	if (forcepae) {
+		printk(KERN_WARNING "PAE forced!\n");
+		set_cpu_cap(c, X86_FEATURE_PAE);
+		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
+	}
+
+	/*
 	 * P4 Xeon errata 037 workaround.
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
-		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
-		if ((lo & MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) == 0) {
-			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
-			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
-			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
-			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
+		if (msr_set_bit(MSR_IA32_MISC_ENABLE,
+				MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE_BIT)
+		    > 0) {
+			pr_info("CPU: C0 stepping P4 Xeon detected.\n");
+			pr_info("CPU: Disabling hardware prefetching (Errata 037)\n");
 		}
 	}
 
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 8f8eebd..db9db44 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -8,7 +8,7 @@ struct msr *msrs_alloc(void)
 
 	msrs = alloc_percpu(struct msr);
 	if (!msrs) {
-		pr_warning("%s: error allocating msrs\n", __func__);
+		pr_warn("%s: error allocating msrs\n", __func__);
 		return NULL;
 	}
 
@@ -21,3 +21,90 @@ void msrs_free(struct msr *msrs)
 	free_percpu(msrs);
 }
 EXPORT_SYMBOL(msrs_free);
+
+/**
+ * Read an MSR with error handling
+ *
+ * @msr: MSR to read
+ * @m: value to read into
+ *
+ * It returns read data only on success, otherwise it doesn't change the output
+ * argument @m.
+ *
+ */
+int msr_read(u32 msr, struct msr *m)
+{
+	int err;
+	u64 val;
+
+	err = rdmsrl_safe(msr, &val);
+	if (!err)
+		m->q = val;
+
+	return err;
+}
+
+/**
+ * Write an MSR with error handling
+ *
+ * @msr: MSR to write
+ * @m: value to write
+ */
+int msr_write(u32 msr, struct msr *m)
+{
+	return wrmsrl_safe(msr, m->q);
+}
+
+static inline int __flip_bit(u32 msr, u8 bit, bool set)
+{
+	struct msr m, m1;
+	int err = -EINVAL;
+
+	if (bit > 63)
+		return err;
+
+	err = msr_read(msr, &m);
+	if (err)
+		return err;
+
+	m1 = m;
+	if (set)
+		m1.q |=  BIT_64(bit);
+	else
+		m1.q &= ~BIT_64(bit);
+
+	if (m1.q == m.q)
+		return 0;
+
+	err = msr_write(msr, &m);
+	if (err)
+		return err;
+
+	return 1;
+}
+
+/**
+ * Set @bit in a MSR @msr.
+ *
+ * Retval:
+ * < 0: An error was encountered.
+ * = 0: Bit was already set.
+ * > 0: Hardware accepted the MSR write.
+ */
+int msr_set_bit(u32 msr, u8 bit)
+{
+	return __flip_bit(msr, bit, true);
+}
+
+/**
+ * Clear @bit in a MSR @msr.
+ *
+ * Retval:
+ * < 0: An error was encountered.
+ * = 0: Bit was already cleared.
+ * > 0: Hardware accepted the MSR write.
+ */
+int msr_clear_bit(u32 msr, u8 bit)
+{
+	return __flip_bit(msr, bit, false);
+}
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b3b19f4..b1c4672 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -126,8 +126,8 @@ within(unsigned long addr, unsigned long start, unsigned long end)
  * @vaddr:	virtual start address
  * @size:	number of bytes to flush
  *
- * clflush is an unordered instruction which needs fencing with mfence
- * to avoid ordering issues.
+ * clflushopt is an unordered instruction which needs fencing with mfence or
+ * sfence to avoid ordering issues.
  */
 void clflush_cache_range(void *vaddr, unsigned int size)
 {
@@ -136,11 +136,11 @@ void clflush_cache_range(void *vaddr, unsigned int size)
 	mb();
 
 	for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
-		clflush(vaddr);
+		clflushopt(vaddr);
 	/*
 	 * Flush any possible final partial cacheline:
 	 */
-	clflush(vend);
+	clflushopt(vend);
 
 	mb();
 }
diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index bb8f580..534cb89 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -32,6 +32,12 @@
 #include <drm/drmP.h>
 
 #if defined(CONFIG_X86)
+
+/*
+ * clflushopt is an unordered instruction which needs fencing with mfence or
+ * sfence to avoid ordering issues.  For drm_clflush_page this fencing happens
+ * in the caller.
+ */
 static void
 drm_clflush_page(struct page *page)
 {
@@ -44,7 +50,7 @@ drm_clflush_page(struct page *page)
 
 	page_virtual = kmap_atomic(page);
 	for (i = 0; i < PAGE_SIZE; i += size)
-		clflush(page_virtual + i);
+		clflushopt(page_virtual + i);
 	kunmap_atomic(page_virtual);
 }
 
@@ -133,7 +139,7 @@ drm_clflush_virt_range(char *addr, unsigned long length)
 		mb();
 		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
 			clflush(addr);
-		clflush(end - 1);
+		clflushopt(end - 1);
 		mb();
 		return;
 	}
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 196d1ea..08fb024 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -458,7 +458,7 @@ extern enum system_states {
 
 #define TAINT_PROPRIETARY_MODULE	0
 #define TAINT_FORCED_MODULE		1
-#define TAINT_UNSAFE_SMP		2
+#define TAINT_CPU_OUT_OF_SPEC		2
 #define TAINT_FORCED_RMMOD		3
 #define TAINT_MACHINE_CHECK		4
 #define TAINT_BAD_PAGE			5
diff --git a/kernel/module.c b/kernel/module.c
index d24fcf2..ca2c1ad 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1015,7 +1015,7 @@ static size_t module_flags_taint(struct module *mod, char *buf)
 		buf[l++] = 'C';
 	/*
 	 * TAINT_FORCED_RMMOD: could be added.
-	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
+	 * TAINT_CPU_OUT_OF_SPEC, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
 	 * apply to modules.
 	 */
 	return l;
diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..2270cfd 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -199,7 +199,7 @@ struct tnt {
 static const struct tnt tnts[] = {
 	{ TAINT_PROPRIETARY_MODULE,	'P', 'G' },
 	{ TAINT_FORCED_MODULE,		'F', ' ' },
-	{ TAINT_UNSAFE_SMP,		'S', ' ' },
+	{ TAINT_CPU_OUT_OF_SPEC,	'S', ' ' },
 	{ TAINT_FORCED_RMMOD,		'R', ' ' },
 	{ TAINT_MACHINE_CHECK,		'M', ' ' },
 	{ TAINT_BAD_PAGE,		'B', ' ' },
