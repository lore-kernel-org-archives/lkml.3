Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936805Ab3DHP6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:58:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43462 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936739Ab3DHP6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:58:13 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/4] x86: Get rid of ->hard_math and all the FPU asm fu
Date: Mon,  8 Apr 2013 17:57:43 +0200
Message-Id: <1365436666-9837-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
In-Reply-To: <1365436666-9837-1-git-send-email-bp@alien8.de>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Reimplement FPU detection code in C and drop old, not-so-recommended
detection method in asm. Move all the relevant stuff into i387.c where
it conceptually belongs. Finally drop cpuinfo_x86.hard_math.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/fpu-internal.h |  2 --
 arch/x86/include/asm/processor.h    |  3 +-
 arch/x86/kernel/asm-offsets_32.c    |  1 -
 arch/x86/kernel/cpu/bugs.c          | 21 ++-----------
 arch/x86/kernel/cpu/common.c        |  3 +-
 arch/x86/kernel/cpu/cyrix.c         |  2 +-
 arch/x86/kernel/cpu/proc.c          |  4 +--
 arch/x86/kernel/head_32.S           | 21 -------------
 arch/x86/kernel/i387.c              | 59 ++++++++++++++++++++++++++++++-------
 arch/x86/kernel/xsave.c             |  5 ++--
 arch/x86/lguest/boot.c              |  2 +-
 arch/x86/xen/enlighten.c            |  2 +-
 12 files changed, 60 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index e25cc33ec54d..fb808d71cd70 100644
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
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 22224b3b43bb..578f8b1d6910 100644
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
index 85d98ab15cdc..a8ff7f936649 100644
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
index c59635ecbbb8..efa24c0b7c43 100644
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
@@ -112,5 +94,6 @@ void __init check_bugs(void)
 	 * kernel_fpu_begin/end() in check_fpu() relies on the patched
 	 * alternative instructions.
 	 */
-	check_fpu();
+	if (cpu_has_fpu)
+		check_fpu();
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22018f70a671..d4dd99350e9d 100644
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
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index d048d5ca43c1..7582f475b163 100644
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
index 37a198bd48c8..aee6317b902f 100644
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
index 73afd11799ca..e65ddc62e113 100644
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
index 245a71db401a..3a6455304c8d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -135,7 +135,7 @@ static void __cpuinit init_thread_xstate(void)
 	 * xsave_init().
 	 */
 
-	if (!HAVE_HWFP) {
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
 		/*
 		 * Disable xsave as we do not support it if i387
 		 * emulation is enabled.
@@ -162,6 +162,14 @@ void __cpuinit fpu_init(void)
 	unsigned long cr0;
 	unsigned long cr4_mask = 0;
 
+#ifndef CONFIG_MATH_EMULATION
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
+		pr_emerg("No FPU found and no math emulation present\n");
+		pr_emerg("Giving up\n");
+		for (;;)
+			asm volatile("hlt");
+	}
+#endif
 	if (cpu_has_fxsr)
 		cr4_mask |= X86_CR4_OSFXSR;
 	if (cpu_has_xmm)
@@ -171,7 +179,7 @@ void __cpuinit fpu_init(void)
 
 	cr0 = read_cr0();
 	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
-	if (!HAVE_HWFP)
+	if (!static_cpu_has(X86_FEATURE_FPU))
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
@@ -189,7 +197,7 @@ void __cpuinit fpu_init(void)
 
 void fpu_finit(struct fpu *fpu)
 {
-	if (!HAVE_HWFP) {
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
 		finit_soft_fpu(&fpu->state->soft);
 		return;
 	}
@@ -218,7 +226,7 @@ int init_fpu(struct task_struct *tsk)
 	int ret;
 
 	if (tsk_used_math(tsk)) {
-		if (HAVE_HWFP && tsk == current)
+		if (static_cpu_has(X86_FEATURE_FPU) && tsk == current)
 			unlazy_fpu(tsk);
 		tsk->thread.fpu.last_cpu = ~0;
 		return 0;
@@ -515,14 +523,13 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
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
 
@@ -549,13 +556,13 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
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
@@ -596,3 +603,33 @@ int dump_fpu(struct pt_regs *regs, struct user_i387_struct *fpu)
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
index ada87a329edc..d6c28acdf99c 100644
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
index 1cbd89ca5569..d3f2ab39f364 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1409,7 +1409,7 @@ __init void lguest_init(void)
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 
 	/* Math is always hard! */
-	new_cpu_data.hard_math = 1;
+	set_cpu_cap(&new_cpu_data, X86_FEATURE_FPU);
 
 	/* We don't have features.  We have puppies!  Puppies! */
 #ifdef CONFIG_X86_MCE
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8e1c7b95c3b..18833ffb2fbc 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1463,7 +1463,7 @@ asmlinkage void __init xen_start_kernel(void)
 #ifdef CONFIG_X86_32
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);
-	new_cpu_data.hard_math = 1;
+	set_cpu_cap(&new_cpu_data, X86_FEATURE_FPU);
 	new_cpu_data.wp_works_ok = 1;
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif
-- 
1.8.2.135.g7b592fa

