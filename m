Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab3D3H6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:58:34 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:52485 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759173Ab3D3H6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:58:32 -0400
Date: Tue, 30 Apr 2013 09:58:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/cpu changes for v3.10
Message-ID: <20130430075828.GA20953@gmail.com>
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

   HEAD: 1077c932db63ecc571c31df1c24d4a44e30928e5 x86, CPU, AMD: Drop useless label

The biggest change is x86 CPU bug handling refactoring and cleanups, by 
Borislav Petkov.

 Thanks,

	Ingo

------------------>
Borislav Petkov (9):
      x86, cpu: Expand cpufeature facility to include cpu bugs
      x86, cpu: Convert F00F bug detection
      x86, cpu: Convert FDIV bug detection
      x86, cpu: Convert Cyrix coma bug detection
      x86, cpu: Convert AMD Erratum 383
      x86, cpu: Convert AMD Erratum 400
      x86: Fold-in trivial check_config function
      x86, AMD: Correct {rd,wr}msr_amd_safe warnings
      x86, CPU, AMD: Drop useless label


 arch/x86/include/asm/cpufeature.h | 19 ++++++++++++++++
 arch/x86/include/asm/processor.h  | 25 +-------------------
 arch/x86/kernel/alternative.c     |  2 +-
 arch/x86/kernel/cpu/amd.c         | 48 +++++++++++++++++++++++----------------
 arch/x86/kernel/cpu/bugs.c        | 34 ++++++++++++---------------
 arch/x86/kernel/cpu/common.c      |  4 ++++
 arch/x86/kernel/cpu/cyrix.c       |  5 ++--
 arch/x86/kernel/cpu/intel.c       |  4 ++--
 arch/x86/kernel/cpu/proc.c        |  6 ++---
 arch/x86/kernel/process.c         |  2 +-
 arch/x86/kernel/setup.c           |  2 --
 arch/x86/kvm/svm.c                |  2 +-
 arch/x86/mm/fault.c               |  2 +-
 13 files changed, 80 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..272fdcc 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -9,6 +9,7 @@
 #endif
 
 #define NCAPINTS	10	/* N 32-bit words worth of info */
+#define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -216,6 +217,17 @@
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
 
+/*
+ * BUG word(s)
+ */
+#define X86_BUG(x)		(NCAPINTS*32 + (x))
+
+#define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
+#define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
+#define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
+#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
+#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <asm/asm.h>
@@ -401,6 +413,13 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 #define static_cpu_has(bit) boot_cpu_has(bit)
 #endif
 
+#define cpu_has_bug(c, bit)	cpu_has(c, (bit))
+#define set_cpu_bug(c, bit)	set_cpu_cap(c, (bit))
+#define clear_cpu_bug(c, bit)	clear_cpu_cap(c, (bit));
+
+#define static_cpu_has_bug(bit)	static_cpu_has((bit))
+#define boot_cpu_has_bug(bit)	cpu_has_bug(&boot_cpu_data, (bit))
+
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
 #endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 3270116..22224b3 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -91,9 +91,6 @@ struct cpuinfo_x86 {
 	/* Problems on some 486Dx4's and old 386's: */
 	char			hard_math;
 	char			rfu;
-	char			fdiv_bug;
-	char			f00f_bug;
-	char			coma_bug;
 	char			pad0;
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
@@ -107,7 +104,7 @@ struct cpuinfo_x86 {
 	__u32			extended_cpuid_level;
 	/* Maximum supported CPUID level, -1=no CPUID: */
 	int			cpuid_level;
-	__u32			x86_capability[NCAPINTS];
+	__u32			x86_capability[NCAPINTS + NBUGINTS];
 	char			x86_vendor_id[16];
 	char			x86_model_id[64];
 	/* in KB - valid for CPUS which support this call: */
@@ -973,26 +970,6 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
-/*
- * AMD errata checking
- */
-#ifdef CONFIG_CPU_SUP_AMD
-extern const int amd_erratum_383[];
-extern const int amd_erratum_400[];
-extern bool cpu_has_amd_erratum(const int *);
-
-#define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
-#define AMD_OSVW_ERRATUM(osvw_id, ...)	{ osvw_id, __VA_ARGS__, 0 }
-#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
-	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
-#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
-#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
-#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
-
-#else
-#define cpu_has_amd_erratum(x)	(false)
-#endif /* CONFIG_CPU_SUP_AMD */
-
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ef5ccca..c15cf9a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -271,7 +271,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		replacement = (u8 *)&a->repl_offset + a->repl_offset;
 		BUG_ON(a->replacementlen > a->instrlen);
 		BUG_ON(a->instrlen > sizeof(insnbuf));
-		BUG_ON(a->cpuid >= NCAPINTS*32);
+		BUG_ON(a->cpuid >= (NCAPINTS + NBUGINTS) * 32);
 		if (!boot_cpu_has(a->cpuid))
 			continue;
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index fa96eb0..5013a48 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -20,11 +20,11 @@
 
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 	u32 gprs[8] = { 0 };
 	int err;
 
-	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
+	WARN_ONCE((boot_cpu_data.x86 != 0xf),
+		  "%s should only be used on K8!\n", __func__);
 
 	gprs[1] = msr;
 	gprs[7] = 0x9c5a203a;
@@ -38,10 +38,10 @@ static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 
 static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 	u32 gprs[8] = { 0 };
 
-	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
+	WARN_ONCE((boot_cpu_data.x86 != 0xf),
+		  "%s should only be used on K8!\n", __func__);
 
 	gprs[0] = (u32)val;
 	gprs[1] = msr;
@@ -192,11 +192,11 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	/* Athlon 660/661 is valid. */
 	if ((c->x86_model == 6) && ((c->x86_mask == 0) ||
 	    (c->x86_mask == 1)))
-		goto valid_k7;
+		return;
 
 	/* Duron 670 is valid */
 	if ((c->x86_model == 7) && (c->x86_mask == 0))
-		goto valid_k7;
+		return;
 
 	/*
 	 * Athlon 662, Duron 671, and Athlon >model 7 have capability
@@ -209,7 +209,7 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
 	     (c->x86_model > 7))
 		if (cpu_has_mp)
-			goto valid_k7;
+			return;
 
 	/* If we get here, not a certified SMP capable AMD system. */
 
@@ -220,9 +220,6 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
 	add_taint(TAINT_UNSAFE_SMP, LOCKDEP_NOW_UNRELIABLE);
-
-valid_k7:
-	;
 }
 
 static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
@@ -513,6 +510,10 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 }
 
+static const int amd_erratum_383[];
+static const int amd_erratum_400[];
+static bool cpu_has_amd_erratum(const int *erratum);
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
@@ -727,8 +728,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		rdmsrl_safe(MSR_AMD64_BU_CFG2, &value);
 		value &= ~(1ULL << 24);
 		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
+
+		if (cpu_has_amd_erratum(amd_erratum_383))
+			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 	}
 
+	if (cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_bug(c, X86_BUG_AMD_APIC_C1E);
+
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
 }
 
@@ -847,8 +854,7 @@ cpu_dev_register(amd_cpu_dev);
  * AMD_OSVW_ERRATUM() macros. The latter is intended for newer errata that
  * have an OSVW id assigned, which it takes as first argument. Both take a
  * variable number of family-specific model-stepping ranges created by
- * AMD_MODEL_RANGE(). Each erratum also has to be declared as extern const
- * int[] in arch/x86/include/asm/processor.h.
+ * AMD_MODEL_RANGE().
  *
  * Example:
  *
@@ -858,16 +864,22 @@ cpu_dev_register(amd_cpu_dev);
  *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0));
  */
 
-const int amd_erratum_400[] =
+#define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
+#define AMD_OSVW_ERRATUM(osvw_id, ...)	{ osvw_id, __VA_ARGS__, 0 }
+#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
+	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
+#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
+#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
+#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
+
+static const int amd_erratum_400[] =
 	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
-EXPORT_SYMBOL_GPL(amd_erratum_400);
 
-const int amd_erratum_383[] =
+static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
-EXPORT_SYMBOL_GPL(amd_erratum_383);
 
-bool cpu_has_amd_erratum(const int *erratum)
+static bool cpu_has_amd_erratum(const int *erratum)
 {
 	struct cpuinfo_x86 *cpu = __this_cpu_ptr(&cpu_info);
 	int osvw_id = *erratum++;
@@ -908,5 +920,3 @@ bool cpu_has_amd_erratum(const int *erratum)
 
 	return false;
 }
-
-EXPORT_SYMBOL_GPL(cpu_has_amd_erratum);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index af6455e..4112be9 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,7 +59,7 @@ static void __init check_fpu(void)
 	 * trap_init() enabled FXSR and company _before_ testing for FP
 	 * problems here.
 	 *
-	 * Test for the divl bug..
+	 * Test for the divl bug: http://en.wikipedia.org/wiki/Fdiv_bug
 	 */
 	__asm__("fninit\n\t"
 		"fldl %1\n\t"
@@ -75,26 +75,12 @@ static void __init check_fpu(void)
 
 	kernel_fpu_end();
 
-	boot_cpu_data.fdiv_bug = fdiv_bug;
-	if (boot_cpu_data.fdiv_bug)
+	if (fdiv_bug) {
+		set_cpu_bug(&boot_cpu_data, X86_BUG_FDIV);
 		pr_warn("Hmm, FPU with FDIV bug\n");
+	}
 }
 
-/*
- * Check whether we are able to run this kernel safely on SMP.
- *
- * - i386 is no longer supported.
- * - In order to run on anything without a TSC, we need to be
- *   compiled for a i486.
- */
-
-static void __init check_config(void)
-{
-	if (boot_cpu_data.x86 < 4)
-		panic("Kernel requires i486+ for 'invlpg' and other features");
-}
-
-
 void __init check_bugs(void)
 {
 	identify_boot_cpu();
@@ -102,7 +88,17 @@ void __init check_bugs(void)
 	pr_info("CPU: ");
 	print_cpu_info(&boot_cpu_data);
 #endif
-	check_config();
+
+	/*
+	 * Check whether we are able to run this kernel safely on SMP.
+	 *
+	 * - i386 is no longer supported.
+	 * - In order to run on anything without a TSC, we need to be
+	 *   compiled for a i486.
+	 */
+	if (boot_cpu_data.x86 < 4)
+		panic("Kernel requires i486+ for 'invlpg' and other features");
+
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d814772..22018f7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -920,6 +920,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		/* AND the already accumulated flags with these */
 		for (i = 0; i < NCAPINTS; i++)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
+
+		/* OR, i.e. replicate the bug flags */
+		for (i = NCAPINTS; i < NCAPINTS + NBUGINTS; i++)
+			c->x86_capability[i] |= boot_cpu_data.x86_capability[i];
 	}
 
 	/* Init Machine Check Exception if available. */
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 4fbd384..d048d5c 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -249,7 +249,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		/* Emulate MTRRs using Cyrix's ARRs. */
 		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
 		/* 6x86's contain this bug */
-		c->coma_bug = 1;
+		set_cpu_bug(c, X86_BUG_COMA);
 		break;
 
 	case 4: /* MediaGX/GXm or Geode GXM/GXLV/GX1 */
@@ -317,7 +317,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 			/* Enable MMX extensions (App note 108) */
 			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7)|1);
 		} else {
-			c->coma_bug = 1;      /* 6x86MX, it has the bug. */
+			/* A 6x86MX - it has the bug. */
+			set_cpu_bug(c, X86_BUG_COMA);
 		}
 		tmp = (!(dir0_lsn & 7) || dir0_lsn & 1) ? 2 : 0;
 		Cx86_cb[tmp] = cyrix_model_mult2[dir0_lsn & 7];
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1905ce9..1acdd42 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -209,11 +209,11 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	 * system.
 	 * Note that the workaround only should be initialized once...
 	 */
-	c->f00f_bug = 0;
+	clear_cpu_bug(c, X86_BUG_F00F);
 	if (!paravirt_enabled() && c->x86 == 5) {
 		static int f00f_workaround_enabled;
 
-		c->f00f_bug = 1;
+		set_cpu_bug(c, X86_BUG_F00F);
 		if (!f00f_workaround_enabled) {
 			trap_init_f00f_bug();
 			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index e280253..37a198b 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -34,9 +34,9 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "fpu_exception\t: %s\n"
 		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
-		   c->fdiv_bug ? "yes" : "no",
-		   c->f00f_bug ? "yes" : "no",
-		   c->coma_bug ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_FDIV) ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_F00F) ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_COMA) ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   c->cpuid_level,
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..e718f15 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -495,7 +495,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 	if (x86_idle)
 		return;
 
-	if (cpu_has_amd_erratum(amd_erratum_400)) {
+	if (cpu_has_bug(c, X86_BUG_AMD_APIC_C1E)) {
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		pr_info("using AMD E400 aware idle routine\n");
 		x86_idle = amd_e400_idle;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..29258c75 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -173,12 +173,10 @@ static struct resource bss_resource = {
 /* cpu data as detected by the assembly code in head.S */
 struct cpuinfo_x86 new_cpu_data __cpuinitdata = {
 	.wp_works_ok = -1,
-	.fdiv_bug = -1,
 };
 /* common cpu data for all cpus */
 struct cpuinfo_x86 boot_cpu_data __read_mostly = {
 	.wp_works_ok = -1,
-	.fdiv_bug = -1,
 };
 EXPORT_SYMBOL(boot_cpu_data);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e1b1ce2..7d39d70 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -555,7 +555,7 @@ static void svm_init_erratum_383(void)
 	int err;
 	u64 val;
 
-	if (!cpu_has_amd_erratum(amd_erratum_383))
+	if (!static_cpu_has_bug(X86_BUG_AMD_TLB_MMATCH))
 		return;
 
 	/* Use _safe variants to not break nested virtualization */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2b97525..a1ce1fa 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -555,7 +555,7 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 	/*
 	 * Pentium F0 0F C7 C8 bug workaround:
 	 */
-	if (boot_cpu_data.f00f_bug) {
+	if (boot_cpu_has_bug(X86_BUG_F00F)) {
 		nr = (address - idt_descr.address) >> 3;
 
 		if (nr == 6) {
