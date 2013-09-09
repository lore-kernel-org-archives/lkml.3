Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3IIVde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:33:34 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47450 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3IIVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:33:10 -0400
From: Andrew Pinski <pinskia@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/5] ARM64: Split out CONFIG_ARM64_AARCH32 from CONFIG_COMPAT. Signed-off-by: Andrew Pinski <apinski@cavium.com>
Date: Mon,  9 Sep 2013 14:32:55 -0700
Message-Id: <1378762380-13152-1-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now CONFIG_COMPAT means enabling AARCH32 support in the ARM64 traget, which we want to split out so we can it to mean any 32bit ABI support instead.

---
 arch/arm64/Kconfig                 |    6 +++++-
 arch/arm64/include/asm/compat.h    |   32 ++++++++++++++++++++++++++++----
 arch/arm64/include/asm/elf.h       |   19 ++++++++++++++-----
 arch/arm64/include/asm/fpsimd.h    |    2 +-
 arch/arm64/include/asm/hwcap.h     |    3 ++-
 arch/arm64/include/asm/memory.h    |    6 +++---
 arch/arm64/include/asm/processor.h |    2 +-
 arch/arm64/include/asm/ptrace.h    |    2 +-
 arch/arm64/include/asm/stat.h      |    2 +-
 arch/arm64/kernel/Makefile         |    2 +-
 arch/arm64/kernel/entry.S          |    6 +++---
 arch/arm64/kernel/head.S           |    2 +-
 arch/arm64/kernel/hw_breakpoint.c  |    6 +++---
 arch/arm64/kernel/process.c        |    6 +++---
 arch/arm64/kernel/ptrace.c         |   28 ++++++++++++++--------------
 arch/arm64/kernel/signal.c         |    4 ++--
 arch/arm64/kernel/traps.c          |    4 ++--
 arch/arm64/kernel/vdso.c           |    6 +++---
 arch/arm64/mm/fault.c              |    1 +
 arch/arm64/mm/mmap.c               |    1 +
 20 files changed, 90 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ae323a4..cc64df5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -247,9 +247,13 @@ menu "Userspace binary formats"
 source "fs/Kconfig.binfmt"
 
 config COMPAT
+	def_bool y
+	depends on ARM64_AARCH32
+	select COMPAT_BINFMT_ELF
+
+config ARM64_AARCH32
 	bool "Kernel support for 32-bit EL0"
 	depends on !ARM64_64K_PAGES
-	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
 	select OLD_SIGSUSPEND3
 	select COMPAT_OLD_SIGACTION
diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 899af80..5ab2676 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -279,28 +279,52 @@ struct compat_shmid64_ds {
 	compat_ulong_t __unused5;
 };
 
-static inline int is_compat_task(void)
+#if defined(CONFIG_ARM64_AARCH32)
+static inline int is_aarch32_task(void)
 {
 	return test_thread_flag(TIF_32BIT);
 }
 
-static inline int is_compat_thread(struct thread_info *thread)
+static inline int is_aarch32_thread(struct thread_info *thread)
 {
 	return test_ti_thread_flag(thread, TIF_32BIT);
 }
+#else
+static inline int is_aarch32_task(void)
+{
+	return 0;
+}
+
+static inline int is_aarch32_thread(struct thread_info *thread)
+{
+	return 0;
+}
+#endif
+
 
 #else /* !CONFIG_COMPAT */
 
-static inline int is_compat_task(void)
+static inline int is_aarch32_task(void)
 {
 	return 0;
 }
 
-static inline int is_compat_thread(struct thread_info *thread)
+static inline int is_aarch32_thread(struct thread_info *thread)
 {
 	return 0;
 }
 
 #endif /* CONFIG_COMPAT */
+
+static inline int is_compat_task(void)
+{
+  return is_aarch32_task();
+}
+
+static inline int is_compat_thread(struct thread_info *thread)
+{
+  return is_aarch32_thread(thread);
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_COMPAT_H */
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index e7fa87f..0a89e94 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -153,24 +153,33 @@ extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 
 #define COMPAT_ELF_ET_DYN_BASE		(randomize_et_dyn(2 * TASK_SIZE_32 / 3))
 
+#ifdef CONFIG_ARM64_AARCH32
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
-typedef unsigned int			compat_elf_greg_t;
-typedef compat_elf_greg_t		compat_elf_gregset_t[COMPAT_ELF_NGREG];
+typedef unsigned int			compat_a32_elf_greg_t;
+typedef compat_a32_elf_greg_t compat_a32_elf_gregset_t[COMPAT_ELF_NGREG];
 
 /* AArch32 EABI. */
 #define EF_ARM_EABI_MASK		0xff000000
-#define compat_elf_check_arch(x)	(((x)->e_machine == EM_ARM) && \
+#define compat_elf_a32_check_arch(x)	(((x)->e_machine == EM_ARM) && \
 					 ((x)->e_flags & EF_ARM_EABI_MASK))
 
-#define compat_start_thread		compat_start_thread
-#define COMPAT_SET_PERSONALITY(ex)	set_thread_flag(TIF_32BIT);
+#define COMPAT_SET_A32_PERSONALITY(ex)	set_thread_flag(TIF_32BIT);
 #define COMPAT_ARCH_DLINFO
+
 extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
 				      int uses_interp);
 #define compat_arch_setup_additional_pages \
 					aarch32_setup_vectors_page
 
+typedef compat_a32_elf_greg_t		compat_elf_greg_t;
+typedef compat_a32_elf_gregset_t	compat_elf_gregset_t;
+#endif
+
+#define compat_elf_check_arch(x) compat_elf_a32_check_arch(x)
+#define COMPAT_SET_PERSONALITY(ex) COMPAT_SET_A32_PERSONALITY(x)
+#define compat_start_thread		compat_start_thread
+
 #endif /* CONFIG_COMPAT */
 
 #endif
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index c43b4ac..1924290 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -39,7 +39,7 @@ struct fpsimd_state {
 	};
 };
 
-#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+#if defined(__KERNEL__) && defined(CONFIG_ARM64_AARCH32)
 /* Masks for extracting the FPSR and FPCR from the FPSCR */
 #define VFP_FPSCR_STAT_MASK	0xf800009f
 #define VFP_FPSCR_CTRL_MASK	0x07f79f00
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 6d4482f..d189728 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -37,12 +37,13 @@
  * instruction set this cpu supports.
  */
 #define ELF_HWCAP		(elf_hwcap)
-#define COMPAT_ELF_HWCAP	(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
+#define COMPAT_ELF_A32_HWCAP	(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
 				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
 				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
 				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
 				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
 
 extern unsigned int elf_hwcap;
+#define COMPAT_ELF_HWCAP COMPAT_ELF_A32_HWCAP
 #endif
 #endif
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 20925bc..4a644a5 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -49,11 +49,11 @@
 
 #ifdef CONFIG_COMPAT
 #define TASK_SIZE_32		UL(0x100000000)
-#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
+#define TASK_SIZE		(is_compat_task() ? \
 				TASK_SIZE_32 : TASK_SIZE_64)
 #else
-#define TASK_SIZE		TASK_SIZE_64
-#endif /* CONFIG_COMPAT */
+#define TASK_SIZE              TASK_SIZE_64
+#endif
 
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index ab239b2..9f0cbcd 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -38,7 +38,7 @@
 #define STACK_TOP_MAX		TASK_SIZE_64
 #ifdef CONFIG_COMPAT
 #define AARCH32_VECTORS_BASE	0xffff0000
-#define STACK_TOP		(test_thread_flag(TIF_32BIT) ? \
+#define STACK_TOP		(is_compat_task() ? \
 				AARCH32_VECTORS_BASE : STACK_TOP_MAX)
 #else
 #define STACK_TOP		STACK_TOP_MAX
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 0dacbbf..832a4d8 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -107,7 +107,7 @@ struct pt_regs {
 
 #define arch_has_single_step()	(1)
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 #define compat_thumb_mode(regs) \
 	(((regs)->pstate & COMPAT_PSR_T_BIT))
 #else
diff --git a/arch/arm64/include/asm/stat.h b/arch/arm64/include/asm/stat.h
index 15e3559..989128a 100644
--- a/arch/arm64/include/asm/stat.h
+++ b/arch/arm64/include/asm/stat.h
@@ -18,7 +18,7 @@
 
 #include <uapi/asm/stat.h>
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 
 #include <asm/compat.h>
 
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7b4b564..e23efb7 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -11,7 +11,7 @@ arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
 			   hyp-stub.o psci.o
 
-arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
+arm64-obj-$(CONFIG_ARM64_AARCH32)	+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o smp_psci.o
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 3881fd1..28cf5c7 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -167,7 +167,7 @@ ENTRY(vectors)
 	ventry	el0_fiq_invalid			// FIQ 64-bit EL0
 	ventry	el0_error_invalid		// Error 64-bit EL0
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 	ventry	el0_sync_compat			// Synchronous 32-bit EL0
 	ventry	el0_irq_compat			// IRQ 32-bit EL0
 	ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
@@ -207,7 +207,7 @@ el0_error_invalid:
 	inv_entry 0, BAD_ERROR
 ENDPROC(el0_error_invalid)
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 el0_fiq_invalid_compat:
 	inv_entry 0, BAD_FIQ, 32
 ENDPROC(el0_fiq_invalid_compat)
@@ -371,7 +371,7 @@ el0_sync:
 	b.ge	el0_dbg
 	b	el0_inv
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 	.align	6
 el0_sync_compat:
 	kernel_entry 0, 32
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 7090c12..ad6a33a 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -188,7 +188,7 @@ ENTRY(el2_setup)
 	mov	x0, #0x33ff
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
 #endif
 
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 329218c..fbaad0d 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -392,7 +392,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 	 * Watchpoints can be of length 1, 2, 4 or 8 bytes.
 	 */
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
-		if (is_compat_task()) {
+		if (is_aarch32_task()) {
 			if (info->ctrl.len != ARM_BREAKPOINT_LEN_2 &&
 			    info->ctrl.len != ARM_BREAKPOINT_LEN_4)
 				return -EINVAL;
@@ -449,7 +449,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	 * AArch32 tasks expect some simple alignment fixups, so emulate
 	 * that here.
 	 */
-	if (is_compat_task()) {
+	if (is_aarch32_task()) {
 		if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
 			alignment_mask = 0x7;
 		else
@@ -636,7 +636,7 @@ static int watchpoint_handler(unsigned long addr, unsigned int esr,
 
 		info = counter_arch_bp(wp);
 		/* AArch32 watchpoints are either 4 or 8 bytes aligned. */
-		if (is_compat_task()) {
+		if (is_aarch32_task()) {
 			if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
 				alignment_mask = 0x7;
 			else
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 57fb55c..8845c2d 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -202,7 +202,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	if (likely(!(p->flags & PF_KTHREAD))) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
-		if (is_compat_thread(task_thread_info(p))) {
+		if (is_aarch32_thread(task_thread_info(p))) {
 			if (stack_start)
 				childregs->compat_sp = stack_start;
 		} else {
@@ -243,12 +243,12 @@ static void tls_thread_switch(struct task_struct *next)
 {
 	unsigned long tpidr, tpidrro;
 
-	if (!is_compat_task()) {
+	if (!is_aarch32_task()) {
 		asm("mrs %0, tpidr_el0" : "=r" (tpidr));
 		current->thread.tp_value = tpidr;
 	}
 
-	if (is_compat_thread(task_thread_info(next))) {
+	if (is_aarch32_thread(task_thread_info(next))) {
 		tpidr = 0;
 		tpidrro = next->thread.tp_value;
 	} else {
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index fecdbf7..4805581 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -69,10 +69,10 @@ static void ptrace_hbptriggered(struct perf_event *bp,
 		.si_addr	= (void __user *)(bkpt->trigger),
 	};
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 	int i;
 
-	if (!is_compat_task())
+	if (!is_aarch32_task())
 		goto send_sig;
 
 	for (i = 0; i < ARM_MAX_BRP; ++i) {
@@ -609,7 +609,7 @@ static const struct user_regset_view user_aarch64_view = {
 	.regsets = aarch64_regsets, .n = ARRAY_SIZE(aarch64_regsets)
 };
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 #include <linux/compat.h>
 
 enum compat_regset {
@@ -775,8 +775,8 @@ static const struct user_regset aarch32_regsets[] = {
 	[REGSET_COMPAT_GPR] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = COMPAT_ELF_NGREG,
-		.size = sizeof(compat_elf_greg_t),
-		.align = sizeof(compat_elf_greg_t),
+		.size = sizeof(compat_a32_elf_greg_t),
+		.align = sizeof(compat_a32_elf_greg_t),
 		.get = compat_gpr_get,
 		.set = compat_gpr_set
 	},
@@ -809,7 +809,7 @@ static int compat_ptrace_read_user(struct task_struct *tsk, compat_ulong_t off,
 		tmp = tsk->mm->start_data;
 	else if (off == COMPAT_PT_TEXT_END_ADDR)
 		tmp = tsk->mm->end_code;
-	else if (off < sizeof(compat_elf_gregset_t))
+	else if (off < sizeof(compat_a32_elf_gregset_t))
 		return copy_regset_to_user(tsk, &user_aarch32_view,
 					   REGSET_COMPAT_GPR, off,
 					   sizeof(compat_ulong_t), ret);
@@ -829,7 +829,7 @@ static int compat_ptrace_write_user(struct task_struct *tsk, compat_ulong_t off,
 	if (off & 3 || off >= COMPAT_USER_SZ)
 		return -EIO;
 
-	if (off >= sizeof(compat_elf_gregset_t))
+	if (off >= sizeof(compat_a32_elf_gregset_t))
 		return 0;
 
 	ret = copy_regset_from_user(tsk, &user_aarch32_view,
@@ -989,7 +989,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			ret = copy_regset_to_user(child,
 						  &user_aarch32_view,
 						  REGSET_COMPAT_GPR,
-						  0, sizeof(compat_elf_gregset_t),
+						  0, sizeof(compat_a32_elf_gregset_t),
 						  datap);
 			break;
 
@@ -997,7 +997,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			ret = copy_regset_from_user(child,
 						    &user_aarch32_view,
 						    REGSET_COMPAT_GPR,
-						    0, sizeof(compat_elf_gregset_t),
+						    0, sizeof(compat_a32_elf_gregset_t),
 						    datap);
 			break;
 
@@ -1045,12 +1045,12 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 	return ret;
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_ARM64_AARCH32 */
 
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
-#ifdef CONFIG_COMPAT
-	if (is_compat_thread(task_thread_info(task)))
+#ifdef CONFIG_ARM64_AARCH32
+	if (is_aarch32_thread(task_thread_info(task)))
 		return &user_aarch32_view;
 #endif
 	return &user_aarch64_view;
@@ -1069,7 +1069,7 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return regs->syscallno;
 
-	if (is_compat_task()) {
+	if (is_aarch32_task()) {
 		/* AArch32 uses ip (r12) for scratch */
 		saved_reg = regs->regs[12];
 		regs->regs[12] = dir;
@@ -1087,7 +1087,7 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 	else if (tracehook_report_syscall_entry(regs))
 		regs->syscallno = ~0UL;
 
-	if (is_compat_task())
+	if (is_aarch32_task())
 		regs->regs[12] = saved_reg;
 	else
 		regs->regs[7] = saved_reg;
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591..3fbd848 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -268,7 +268,7 @@ static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
 
 static void setup_restart_syscall(struct pt_regs *regs)
 {
-	if (is_compat_task())
+	if (is_aarch32_task())
 		compat_setup_restart_syscall(regs);
 	else
 		regs->regs[8] = __NR_restart_syscall;
@@ -295,7 +295,7 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 	/*
 	 * Set up the stack frame
 	 */
-	if (is_compat_task()) {
+	if (is_aarch32_task()) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
 			ret = compat_setup_rt_frame(usig, ka, info, oldset,
 						    regs);
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 7ffaddd..0bc28fa 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -285,9 +285,9 @@ long compat_arm_syscall(struct pt_regs *regs);
 
 asmlinkage long do_ni_syscall(struct pt_regs *regs)
 {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 	long ret;
-	if (is_compat_task()) {
+	if (is_aarch32_task()) {
 		ret = compat_arm_syscall(regs);
 		if (ret != -ENOSYS)
 			return ret;
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 6a389dc..b5605ac 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -49,7 +49,7 @@ static union {
 } vdso_data_store __page_aligned_data;
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 /*
  * Create and map the vectors page for AArch32 tasks.
  */
@@ -99,7 +99,7 @@ int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
 
 	return ret;
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_ARM64_AARCH32 */
 
 static int __init vdso_init(void)
 {
@@ -191,7 +191,7 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 	 * it conflicting with the vectors base.
 	 */
 	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso) {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 		if (vma->vm_start == AARCH32_VECTORS_BASE)
 			return "[vectors]";
 #endif
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 6c8ba25..428658e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -35,6 +35,7 @@
 #include <asm/system_misc.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/compat.h>
 
 static const char *fault_name(unsigned int esr);
 
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 8ed6cb1..29eb82a 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -28,6 +28,7 @@
 #include <linux/random.h>
 
 #include <asm/cputype.h>
+#include <asm/compat.h>
 
 /*
  * Leave enough space between the mmap area and the stack to honour ulimit in
-- 
1.7.2.5

