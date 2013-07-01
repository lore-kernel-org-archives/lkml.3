Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3GAK2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:28:06 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63931 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3GAK2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:28:01 -0400
Date: Mon, 1 Jul 2013 12:27:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu changes for v3.11
Message-ID: <20130701102757.GA17647@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-fpu-for-linus

   HEAD: 5f8c4218148822fde6eebbeefc34bd0a6061e031 x86, fpu: Use static_cpu_has_safe before alternatives

There are two bigger changes in this tree:

 - Add an [early-use-]safe static_cpu_has() variant and other robustness 
   improvements, including the new CONFIG_X86_DEBUG_STATIC_CPU_HAS=y 
   debugging facility, motivated by recent obscure FPU code bugs,
   by Borislav Petkov

 - Reimplement FPU detection code in C and drop the old asm code,
   by H. Peter Anvin.

 Thanks,

	Ingo

------------------>
Borislav Petkov (4):
      x86, cpu: Add a synthetic, always true, cpu feature
      x86: Sanity-check static_cpu_has usage
      x86: Add a static_cpu_has_safe variant
      x86, fpu: Use static_cpu_has_safe before alternatives

H. Peter Anvin (1):
      x86: Get rid of ->hard_math and all the FPU asm fu


 arch/x86/Kconfig.debug              |  10 +++
 arch/x86/include/asm/cpufeature.h   | 118 ++++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/fpu-internal.h |   4 +-
 arch/x86/include/asm/processor.h    |   3 +-
 arch/x86/kernel/asm-offsets_32.c    |   1 -
 arch/x86/kernel/cpu/bugs.c          |  21 +------
 arch/x86/kernel/cpu/common.c        |  19 +++++-
 arch/x86/kernel/cpu/cyrix.c         |   2 +-
 arch/x86/kernel/cpu/proc.c          |   4 +-
 arch/x86/kernel/head_32.S           |  21 -------
 arch/x86/kernel/i387.c              |  59 ++++++++++++++----
 arch/x86/kernel/xsave.c             |   5 +-
 arch/x86/lguest/boot.c              |   2 +-
 arch/x86/xen/enlighten.c            |   2 +-
 14 files changed, 201 insertions(+), 70 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c198b7e..c6acdf7 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -304,4 +304,14 @@ config DEBUG_NMI_SELFTEST
 
 	  If unsure, say N.
 
+config X86_DEBUG_STATIC_CPU_HAS
+	bool "Debug alternatives"
+	depends on DEBUG_KERNEL
+	---help---
+	  This option causes additional code to be generated which
+	  fails if static_cpu_has() is used before alternatives have
+	  run.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e99ac27..47538a6 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -92,7 +92,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-					  /* 21 available, was AMD_C1E */
+#define X86_FEATURE_ALWAYS	(3*32+21) /* "" Always-present feature */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
@@ -356,15 +356,36 @@ extern const char * const x86_power_flags[32];
 #endif /* CONFIG_X86_64 */
 
 #if __GNUC__ >= 4
+extern void warn_pre_alternatives(void);
+extern bool __static_cpu_has_safe(u16 bit);
+
 /*
  * Static testing of CPU features.  Used the same as boot_cpu_has().
  * These are only valid after alternatives have run, but will statically
  * patch the target code for additional performance.
- *
  */
 static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
 #if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
+
+#ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+		/*
+		 * Catch too early usage of this before alternatives
+		 * have run.
+		 */
+		asm goto("1: jmp %l[t_warn]\n"
+			 "2:\n"
+			 ".section .altinstructions,\"a\"\n"
+			 " .long 1b - .\n"
+			 " .long 0\n"		/* no replacement */
+			 " .word %P0\n"		/* 1: do replace */
+			 " .byte 2b - 1b\n"	/* source len */
+			 " .byte 0\n"		/* replacement len */
+			 ".previous\n"
+			 /* skipping size check since replacement size = 0 */
+			 : : "i" (X86_FEATURE_ALWAYS) : : t_warn);
+#endif
+
 		asm goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
@@ -379,7 +400,13 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		return true;
 	t_no:
 		return false;
-#else
+
+#ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+	t_warn:
+		warn_pre_alternatives();
+		return false;
+#endif
+#else /* GCC_VERSION >= 40500 */
 		u8 flag;
 		/* Open-coded due to __stringify() in ALTERNATIVE() */
 		asm volatile("1: movb $0,%0\n"
@@ -411,11 +438,94 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
+
+static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
+{
+#if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
+/*
+ * We need to spell the jumps to the compiler because, depending on the offset,
+ * the replacement jump can be bigger than the original jump, and this we cannot
+ * have. Thus, we force the jump to the widest, 4-byte, signed relative
+ * offset even though the last would often fit in less bytes.
+ */
+		asm goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
+			 "2:\n"
+			 ".section .altinstructions,\"a\"\n"
+			 " .long 1b - .\n"		/* src offset */
+			 " .long 3f - .\n"		/* repl offset */
+			 " .word %P1\n"			/* always replace */
+			 " .byte 2b - 1b\n"		/* src len */
+			 " .byte 4f - 3f\n"		/* repl len */
+			 ".previous\n"
+			 ".section .altinstr_replacement,\"ax\"\n"
+			 "3: .byte 0xe9\n .long %l[t_no] - 2b\n"
+			 "4:\n"
+			 ".previous\n"
+			 ".section .altinstructions,\"a\"\n"
+			 " .long 1b - .\n"		/* src offset */
+			 " .long 0\n"			/* no replacement */
+			 " .word %P0\n"			/* feature bit */
+			 " .byte 2b - 1b\n"		/* src len */
+			 " .byte 0\n"			/* repl len */
+			 ".previous\n"
+			 : : "i" (bit), "i" (X86_FEATURE_ALWAYS)
+			 : : t_dynamic, t_no);
+		return true;
+	t_no:
+		return false;
+	t_dynamic:
+		return __static_cpu_has_safe(bit);
+#else /* GCC_VERSION >= 40500 */
+		u8 flag;
+		/* Open-coded due to __stringify() in ALTERNATIVE() */
+		asm volatile("1: movb $2,%0\n"
+			     "2:\n"
+			     ".section .altinstructions,\"a\"\n"
+			     " .long 1b - .\n"		/* src offset */
+			     " .long 3f - .\n"		/* repl offset */
+			     " .word %P2\n"		/* always replace */
+			     " .byte 2b - 1b\n"		/* source len */
+			     " .byte 4f - 3f\n"		/* replacement len */
+			     ".previous\n"
+			     ".section .discard,\"aw\",@progbits\n"
+			     " .byte 0xff + (4f-3f) - (2b-1b)\n" /* size check */
+			     ".previous\n"
+			     ".section .altinstr_replacement,\"ax\"\n"
+			     "3: movb $0,%0\n"
+			     "4:\n"
+			     ".previous\n"
+			     ".section .altinstructions,\"a\"\n"
+			     " .long 1b - .\n"		/* src offset */
+			     " .long 5f - .\n"		/* repl offset */
+			     " .word %P1\n"		/* feature bit */
+			     " .byte 4b - 3b\n"		/* src len */
+			     " .byte 6f - 5f\n"		/* repl len */
+			     ".previous\n"
+			     ".section .discard,\"aw\",@progbits\n"
+			     " .byte 0xff + (6f-5f) - (4b-3b)\n" /* size check */
+			     ".previous\n"
+			     ".section .altinstr_replacement,\"ax\"\n"
+			     "5: movb $1,%0\n"
+			     "6:\n"
+			     ".previous\n"
+			     : "=qm" (flag)
+			     : "i" (bit), "i" (X86_FEATURE_ALWAYS));
+		return (flag == 2 ? __static_cpu_has_safe(bit) : flag);
+#endif
+}
+
+#define static_cpu_has_safe(bit)				\
+(								\
+	__builtin_constant_p(boot_cpu_has(bit)) ?		\
+		boot_cpu_has(bit) :				\
+		_static_cpu_has_safe(bit)			\
+)
 #else
 /*
  * gcc 3.x is too stupid to do the static test; fall back to dynamic.
  */
-#define static_cpu_has(bit) boot_cpu_has(bit)
+#define static_cpu_has(bit)		boot_cpu_has(bit)
+#define static_cpu_has_safe(bit)	boot_cpu_has(bit)
 #endif
 
 #define cpu_has_bug(c, bit)	cpu_has(c, (bit))
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index e25cc33..4d0bda7 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -62,10 +62,8 @@ extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
 #define xstateregs_active	fpregs_active
 
 #ifdef CONFIG_MATH_EMULATION
-# define HAVE_HWFP		(boot_cpu_data.hard_math)
 extern void finit_soft_fpu(struct i387_soft_struct *soft);
 #else
-# define HAVE_HWFP		1
 static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
@@ -345,7 +343,7 @@ static inline void __thread_fpu_end(struct task_struct *tsk)
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	if (!use_eager_fpu())
+	if (!static_cpu_has_safe(X86_FEATURE_EAGER_FPU))
 		clts();
 	__thread_set_has_fpu(tsk);
 }
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 22224b3..578f8b1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -89,9 +89,9 @@ struct cpuinfo_x86 {
 	char			wp_works_ok;	/* It doesn't on 386's */
 
 	/* Problems on some 486Dx4's and old 386's: */
-	char			hard_math;
 	char			rfu;
 	char			pad0;
+	char			pad1;
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			x86_tlbsize;
@@ -164,6 +164,7 @@ extern const struct seq_operations cpuinfo_op;
 #define cache_line_size()	(boot_cpu_data.x86_cache_alignment)
 
 extern void cpu_detect(struct cpuinfo_x86 *c);
+extern void __cpuinit fpu_detect(struct cpuinfo_x86 *c);
 
 extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 0ef4bba..d67c4be 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -28,7 +28,6 @@ void foo(void)
 	OFFSET(CPUINFO_x86_vendor, cpuinfo_x86, x86_vendor);
 	OFFSET(CPUINFO_x86_model, cpuinfo_x86, x86_model);
 	OFFSET(CPUINFO_x86_mask, cpuinfo_x86, x86_mask);
-	OFFSET(CPUINFO_hard_math, cpuinfo_x86, hard_math);
 	OFFSET(CPUINFO_cpuid_level, cpuinfo_x86, cpuid_level);
 	OFFSET(CPUINFO_x86_capability, cpuinfo_x86, x86_capability);
 	OFFSET(CPUINFO_x86_vendor_id, cpuinfo_x86, x86_vendor_id);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4112be9..0344534 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -17,15 +17,6 @@
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
 
-static int __init no_387(char *s)
-{
-	boot_cpu_data.hard_math = 0;
-	write_cr0(X86_CR0_TS | X86_CR0_EM | X86_CR0_MP | read_cr0());
-	return 1;
-}
-
-__setup("no387", no_387);
-
 static double __initdata x = 4195835.0;
 static double __initdata y = 3145727.0;
 
@@ -44,15 +35,6 @@ static void __init check_fpu(void)
 {
 	s32 fdiv_bug;
 
-	if (!boot_cpu_data.hard_math) {
-#ifndef CONFIG_MATH_EMULATION
-		pr_emerg("No coprocessor found and no math emulation present\n");
-		pr_emerg("Giving up\n");
-		for (;;) ;
-#endif
-		return;
-	}
-
 	kernel_fpu_begin();
 
 	/*
@@ -107,5 +89,6 @@ void __init check_bugs(void)
 	 * kernel_fpu_begin/end() in check_fpu() relies on the patched
 	 * alternative instructions.
 	 */
-	check_fpu();
+	if (cpu_has_fpu)
+		check_fpu();
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22018f7..a4a07c0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -711,10 +711,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		return;
 
 	cpu_detect(c);
-
 	get_cpu_vendor(c);
-
 	get_cpu_cap(c);
+	fpu_detect(c);
 
 	if (this_cpu->c_early_init)
 		this_cpu->c_early_init(c);
@@ -724,6 +723,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	if (this_cpu->c_bsp_init)
 		this_cpu->c_bsp_init(c);
+
+	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
 }
 
 void __init early_cpu_init(void)
@@ -1363,3 +1364,17 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 }
 #endif
+
+#ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+void warn_pre_alternatives(void)
+{
+	WARN(1, "You're using static_cpu_has before alternatives have run!\n");
+}
+EXPORT_SYMBOL_GPL(warn_pre_alternatives);
+#endif
+
+inline bool __static_cpu_has_safe(u16 bit)
+{
+	return boot_cpu_has(bit);
+}
+EXPORT_SYMBOL_GPL(__static_cpu_has_safe);
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index d048d5c..7582f47 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -333,7 +333,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		switch (dir0_lsn) {
 		case 0xd:  /* either a 486SLC or DLC w/o DEVID */
 			dir0_msn = 0;
-			p = Cx486_name[(c->hard_math) ? 1 : 0];
+			p = Cx486_name[(cpu_has_fpu ? 1 : 0)];
 			break;
 
 		case 0xe:  /* a 486S A step */
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 37a198b..aee6317 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -37,8 +37,8 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   static_cpu_has_bug(X86_BUG_FDIV) ? "yes" : "no",
 		   static_cpu_has_bug(X86_BUG_F00F) ? "yes" : "no",
 		   static_cpu_has_bug(X86_BUG_COMA) ? "yes" : "no",
-		   c->hard_math ? "yes" : "no",
-		   c->hard_math ? "yes" : "no",
+		   static_cpu_has(X86_FEATURE_FPU) ? "yes" : "no",
+		   static_cpu_has(X86_FEATURE_FPU) ? "yes" : "no",
 		   c->cpuid_level,
 		   c->wp_works_ok ? "yes" : "no");
 }
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 73afd11..e65ddc6 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -444,7 +444,6 @@ is486:
 	orl %ecx,%eax
 	movl %eax,%cr0
 
-	call check_x87
 	lgdt early_gdt_descr
 	lidt idt_descr
 	ljmp $(__KERNEL_CS),$1f
@@ -467,26 +466,6 @@ is486:
 	pushl $0		# fake return address for unwinder
 	jmp *(initial_code)
 
-/*
- * We depend on ET to be correct. This checks for 287/387.
- */
-check_x87:
-	movb $0,X86_HARD_MATH
-	clts
-	fninit
-	fstsw %ax
-	cmpb $0,%al
-	je 1f
-	movl %cr0,%eax		/* no coprocessor: have to set bits */
-	xorl $4,%eax		/* set EM */
-	movl %eax,%cr0
-	ret
-	ALIGN
-1:	movb $1,X86_HARD_MATH
-	.byte 0xDB,0xE4		/* fsetpm for 287, ignored by 387 */
-	ret
-
-	
 #include "verify_cpu.S"
 
 /*
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index cb33909..b627746 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -131,7 +131,7 @@ static void __cpuinit init_thread_xstate(void)
 	 * xsave_init().
 	 */
 
-	if (!HAVE_HWFP) {
+	if (!cpu_has_fpu) {
 		/*
 		 * Disable xsave as we do not support it if i387
 		 * emulation is enabled.
@@ -158,6 +158,14 @@ void __cpuinit fpu_init(void)
 	unsigned long cr0;
 	unsigned long cr4_mask = 0;
 
+#ifndef CONFIG_MATH_EMULATION
+	if (!cpu_has_fpu) {
+		pr_emerg("No FPU found and no math emulation present\n");
+		pr_emerg("Giving up\n");
+		for (;;)
+			asm volatile("hlt");
+	}
+#endif
 	if (cpu_has_fxsr)
 		cr4_mask |= X86_CR4_OSFXSR;
 	if (cpu_has_xmm)
@@ -167,7 +175,7 @@ void __cpuinit fpu_init(void)
 
 	cr0 = read_cr0();
 	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
-	if (!HAVE_HWFP)
+	if (!cpu_has_fpu)
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
@@ -185,7 +193,7 @@ void __cpuinit fpu_init(void)
 
 void fpu_finit(struct fpu *fpu)
 {
-	if (!HAVE_HWFP) {
+	if (!cpu_has_fpu) {
 		finit_soft_fpu(&fpu->state->soft);
 		return;
 	}
@@ -214,7 +222,7 @@ int init_fpu(struct task_struct *tsk)
 	int ret;
 
 	if (tsk_used_math(tsk)) {
-		if (HAVE_HWFP && tsk == current)
+		if (cpu_has_fpu && tsk == current)
 			unlazy_fpu(tsk);
 		tsk->thread.fpu.last_cpu = ~0;
 		return 0;
@@ -511,14 +519,13 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	if (!HAVE_HWFP)
+	if (!static_cpu_has(X86_FEATURE_FPU))
 		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
 
-	if (!cpu_has_fxsr) {
+	if (!cpu_has_fxsr)
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 					   &target->thread.fpu.state->fsave, 0,
 					   -1);
-	}
 
 	sanitize_i387_state(target);
 
@@ -545,13 +552,13 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	sanitize_i387_state(target);
 
-	if (!HAVE_HWFP)
+	if (!static_cpu_has(X86_FEATURE_FPU))
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
-	if (!cpu_has_fxsr) {
+	if (!cpu_has_fxsr)
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &target->thread.fpu.state->fsave, 0, -1);
-	}
+					  &target->thread.fpu.state->fsave, 0,
+					  -1);
 
 	if (pos > 0 || count < sizeof(env))
 		convert_from_fxsr(&env, target);
@@ -592,3 +599,33 @@ int dump_fpu(struct pt_regs *regs, struct user_i387_struct *fpu)
 EXPORT_SYMBOL(dump_fpu);
 
 #endif	/* CONFIG_X86_32 || CONFIG_IA32_EMULATION */
+
+static int __init no_387(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_FPU);
+	return 1;
+}
+
+__setup("no387", no_387);
+
+void __cpuinit fpu_detect(struct cpuinfo_x86 *c)
+{
+	unsigned long cr0;
+	u16 fsw, fcw;
+
+	fsw = fcw = 0xffff;
+
+	cr0 = read_cr0();
+	cr0 &= ~(X86_CR0_TS | X86_CR0_EM);
+	write_cr0(cr0);
+
+	asm volatile("fninit ; fnstsw %0 ; fnstcw %1"
+		     : "+m" (fsw), "+m" (fcw));
+
+	if (fsw == 0 && (fcw & 0x103f) == 0x003f)
+		set_cpu_cap(c, X86_FEATURE_FPU);
+	else
+		clear_cpu_cap(c, X86_FEATURE_FPU);
+
+	/* The final cr0 value is set in fpu_init() */
+}
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index ada87a3..d6c28ac 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -243,7 +243,7 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	if (!access_ok(VERIFY_WRITE, buf, size))
 		return -EACCES;
 
-	if (!HAVE_HWFP)
+	if (!static_cpu_has(X86_FEATURE_FPU))
 		return fpregs_soft_get(current, NULL, 0,
 			sizeof(struct user_i387_ia32_struct), NULL,
 			(struct _fpstate_ia32 __user *) buf) ? -1 : 1;
@@ -350,11 +350,10 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	if (!used_math() && init_fpu(tsk))
 		return -1;
 
-	if (!HAVE_HWFP) {
+	if (!static_cpu_has(X86_FEATURE_FPU))
 		return fpregs_soft_set(current, NULL,
 				       0, sizeof(struct user_i387_ia32_struct),
 				       NULL, buf) != 0;
-	}
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 7114c63..d482bca 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1410,7 +1410,7 @@ __init void lguest_init(void)
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 
 	/* Math is always hard! */
-	new_cpu_data.hard_math = 1;
+	set_cpu_cap(&new_cpu_data, X86_FEATURE_FPU);
 
 	/* We don't have features.  We have puppies!  Puppies! */
 #ifdef CONFIG_X86_MCE
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a492be2..2fa02bc 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1557,7 +1557,7 @@ asmlinkage void __init xen_start_kernel(void)
 #ifdef CONFIG_X86_32
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);
-	new_cpu_data.hard_math = 1;
+	set_cpu_cap(&new_cpu_data, X86_FEATURE_FPU);
 	new_cpu_data.wp_works_ok = 1;
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif
