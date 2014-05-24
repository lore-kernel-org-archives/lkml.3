Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEXHFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:05:44 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:57579 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaEXHCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:24 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 03/24] ARM64: Change some CONFIG_COMPAT over to use CONFIG_AARCH32_EL0 instead.
Date: Sat, 24 May 2014 00:01:58 -0700
Message-Id: <1400914939-9708-4-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes CONFIG_COMPAT checks inside the arm64 which are AARCH32 specific.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/arch_timer.h |    2 +-
 arch/arm64/include/asm/elf.h        |   23 ++++++++++++++++++++---
 arch/arm64/include/asm/fpsimd.h     |    2 +-
 arch/arm64/include/asm/ptrace.h     |    2 +-
 arch/arm64/include/asm/signal32.h   |    2 ++
 arch/arm64/include/asm/stat.h       |    2 ++
 arch/arm64/include/asm/unistd.h     |    2 +-
 arch/arm64/kernel/Makefile          |    2 +-
 arch/arm64/kernel/asm-offsets.c     |    2 +-
 arch/arm64/kernel/entry.S           |    6 +++---
 arch/arm64/kernel/head.S            |    2 +-
 arch/arm64/kernel/ptrace.c          |   31 ++++++++++++++++++++++++-------
 arch/arm64/kernel/signal.c          |   13 +++++++++++++
 arch/arm64/kernel/traps.c           |    2 +-
 arch/arm64/kernel/vdso.c            |    6 +++---
 15 files changed, 75 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9400596..d9687d1 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -130,7 +130,7 @@ static inline void arch_timer_evtstrm_enable(int divider)
 			| ARCH_TIMER_VIRT_EVT_EN;
 	arch_timer_set_cntkctl(cntkctl);
 	elf_hwcap |= HWCAP_EVTSTRM;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
 #endif
 }
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 01d3aab..36c3603 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -171,24 +171,41 @@ extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 
 #define COMPAT_ELF_ET_DYN_BASE		(randomize_et_dyn(2 * TASK_SIZE_32 / 3))
 
+
+#ifdef CONFIG_AARCH32_EL0
+
 /* AArch32 registers. */
-#define COMPAT_ELF_NGREG		18
+#define COMPAT_A32_ELF_NGREG		18
 typedef unsigned int			compat_elf_greg_t;
-typedef compat_elf_greg_t		compat_elf_gregset_t[COMPAT_ELF_NGREG];
+typedef compat_elf_greg_t		compat_elf_gregset_t[COMPAT_A32_ELF_NGREG];
 
 /* AArch32 EABI. */
 #define EF_ARM_EABI_MASK		0xff000000
-#define compat_elf_check_arch(x)	(((x)->e_machine == EM_ARM) && \
+#define compat_a32_elf_check_arch(x)	(((x)->e_machine == EM_ARM) && \
 					 ((x)->e_flags & EF_ARM_EABI_MASK))
 
 #define compat_start_thread		compat_start_thread
 #define COMPAT_SET_PERSONALITY(ex)	set_thread_flag(TIF_32BIT);
 #define COMPAT_ARCH_DLINFO
+
+
 extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
 				      int uses_interp);
 #define compat_arch_setup_additional_pages \
 					aarch32_setup_vectors_page
 
+#else
+
+typedef elf_greg_t			compat_elf_greg_t;
+typedef elf_gregset_t			compat_elf_gregset_t;
+#define compat_a32_elf_check_arch(x)	0
+#define COMPAT_SET_PERSONALITY(ex)
+#define COMPAT_ARCH_DLINFO
+
+#endif
+
+#define compat_elf_check_arch(x)	compat_a32_elf_check_arch(x)
+
 #endif /* CONFIG_COMPAT */
 
 #endif
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index c43b4ac..0229680 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -39,7 +39,7 @@ struct fpsimd_state {
 	};
 };
 
-#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+#if defined(__KERNEL__) && defined(CONFIG_AARCH32_EL0)
 /* Masks for extracting the FPSR and FPCR from the FPSCR */
 #define VFP_FPSCR_STAT_MASK	0xf800009f
 #define VFP_FPSCR_CTRL_MASK	0x07f79f00
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index c7ba261..564b7df 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -109,7 +109,7 @@ struct pt_regs {
 
 #define arch_has_single_step()	(1)
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define compat_thumb_mode(regs) \
 	(((regs)->pstate & COMPAT_PSR_T_BIT))
 #else
diff --git a/arch/arm64/include/asm/signal32.h b/arch/arm64/include/asm/signal32.h
index 7c275e3..8873db0 100644
--- a/arch/arm64/include/asm/signal32.h
+++ b/arch/arm64/include/asm/signal32.h
@@ -20,6 +20,7 @@
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
 
+#ifdef CONFIG_AARCH32_EL0
 #define AARCH32_KERN_SIGRET_CODE_OFFSET	0x500
 
 extern const compat_ulong_t aarch32_sigret_code[6];
@@ -48,6 +49,7 @@ static inline int compat_setup_rt_frame(int usig, struct k_sigaction *ka,
 static inline void compat_setup_restart_syscall(struct pt_regs *regs)
 {
 }
+#endif /* CONFIG_AARCH32_EL0 */
 #endif /* CONFIG_COMPAT */
 #endif /* __KERNEL__ */
 #endif /* __ASM_SIGNAL32_H */
diff --git a/arch/arm64/include/asm/stat.h b/arch/arm64/include/asm/stat.h
index 15e3559..af04276 100644
--- a/arch/arm64/include/asm/stat.h
+++ b/arch/arm64/include/asm/stat.h
@@ -22,6 +22,7 @@
 
 #include <asm/compat.h>
 
+#ifdef CONFIG_AARCH32_EL0
 /*
  * struct stat64 is needed for compat tasks only. Its definition is different
  * from the generic struct stat64.
@@ -59,3 +60,4 @@ struct stat64 {
 
 #endif
 #endif
+#endif
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index a4654c6..11502bd 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -13,7 +13,7 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define __ARCH_WANT_COMPAT_SYS_GETDENTS64
 #define __ARCH_WANT_COMPAT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7d811d9..00c0da4 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -11,7 +11,7 @@ arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
 			   hyp-stub.o psci.o cpu_ops.o insn.o
 
-arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
+arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o topology.o
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 646f888..378d692 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -53,7 +53,7 @@ int main(void)
   DEFINE(S_X7,			offsetof(struct pt_regs, regs[7]));
   DEFINE(S_LR,			offsetof(struct pt_regs, regs[30]));
   DEFINE(S_SP,			offsetof(struct pt_regs, sp));
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
   DEFINE(S_COMPAT_SP,		offsetof(struct pt_regs, compat_sp));
 #endif
   DEFINE(S_PSTATE,		offsetof(struct pt_regs, pstate));
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 39ac630..1e1ebfc 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -167,7 +167,7 @@ ENTRY(vectors)
 	ventry	el0_fiq_invalid			// FIQ 64-bit EL0
 	ventry	el0_error_invalid		// Error 64-bit EL0
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	ventry	el0_sync_compat			// Synchronous 32-bit EL0
 	ventry	el0_irq_compat			// IRQ 32-bit EL0
 	ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
@@ -207,7 +207,7 @@ el0_error_invalid:
 	inv_entry 0, BAD_ERROR
 ENDPROC(el0_error_invalid)
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 el0_fiq_invalid_compat:
 	inv_entry 0, BAD_FIQ, 32
 ENDPROC(el0_fiq_invalid_compat)
@@ -370,7 +370,7 @@ el0_sync:
 	b.ge	el0_dbg
 	b	el0_inv
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	.align	6
 el0_sync_compat:
 	kernel_entry 0, 32
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 0fd5650..5bd1a94 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -200,7 +200,7 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
 	mov	x0, #0x33ff
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
 #endif
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6a8928b..67a0f4d 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -69,7 +69,7 @@ static void ptrace_hbptriggered(struct perf_event *bp,
 		.si_addr	= (void __user *)(bkpt->trigger),
 	};
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	int i;
 
 	if (!is_compat_task())
@@ -607,7 +607,7 @@ static const struct user_regset_view user_aarch64_view = {
 	.regsets = aarch64_regsets, .n = ARRAY_SIZE(aarch64_regsets)
 };
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #include <linux/compat.h>
 
 enum compat_regset {
@@ -770,7 +770,7 @@ static int compat_vfp_set(struct task_struct *target,
 static const struct user_regset aarch32_regsets[] = {
 	[REGSET_COMPAT_GPR] = {
 		.core_note_type = NT_PRSTATUS,
-		.n = COMPAT_ELF_NGREG,
+		.n = COMPAT_A32_ELF_NGREG,
 		.size = sizeof(compat_elf_greg_t),
 		.align = sizeof(compat_elf_greg_t),
 		.get = compat_gpr_get,
@@ -964,8 +964,8 @@ static int compat_ptrace_sethbpregs(struct task_struct *tsk, compat_long_t num,
 }
 #endif	/* CONFIG_HAVE_HW_BREAKPOINT */
 
-long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
-			compat_ulong_t caddr, compat_ulong_t cdata)
+long compat_a32_arch_ptrace(struct task_struct *child, compat_long_t request,
+			    compat_ulong_t caddr, compat_ulong_t cdata)
 {
 	unsigned long addr = caddr;
 	unsigned long data = cdata;
@@ -1041,11 +1041,28 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 	return ret;
 }
-#endif /* CONFIG_COMPAT */
+#else /* !CONFIG_AARCH32_EL0 */
+long compat_a32_arch_ptrace(struct task_struct *child, compat_long_t request,
+			    compat_ulong_t caddr, compat_ulong_t cdata)
+{
+	return -1;
+}
+#endif /* !CONFIG_AARCH32_EL0 */
+
+#ifdef CONFIG_COMPAT
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			compat_ulong_t caddr, compat_ulong_t cdata)
+{
+	if (is_compat_task())
+		return compat_a32_arch_ptrace(child, request, caddr, cdata);
+	return compat_ptrace_request(child, request, caddr, cdata);
+}
+#endif
+
 
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	if (is_compat_thread(task_thread_info(task)))
 		return &user_aarch32_view;
 #endif
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591..12b232a 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -417,3 +417,16 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 		tracehook_notify_resume(regs);
 	}
 }
+
+/* Some functions are needed for compat ptrace but we don't define
+   them if we don't have AARCH32 support compiled in */
+#if defined CONFIG_COMPAT && !defined CONFIG_AARCH32_EL0
+int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
+{
+	return -EFAULT;
+}
+int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
+{
+	return -EFAULT;
+}
+#endif
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 7ffaddd..25dae1a 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -285,7 +285,7 @@ long compat_arm_syscall(struct pt_regs *regs);
 
 asmlinkage long do_ni_syscall(struct pt_regs *regs)
 {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	long ret;
 	if (is_compat_task()) {
 		ret = compat_arm_syscall(regs);
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 50384fe..31e995b 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -49,7 +49,7 @@ static union {
 } vdso_data_store __page_aligned_data;
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 /*
  * Create and map the vectors page for AArch32 tasks.
  */
@@ -102,7 +102,7 @@ int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
 
 	return ret;
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_AARCH32_EL0 */
 
 static int __init vdso_init(void)
 {
@@ -176,7 +176,7 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 	 * it conflicting with the vectors base.
 	 */
 	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso) {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 		if (vma->vm_start == AARCH32_VECTORS_BASE)
 			return "[vectors]";
 #endif
-- 
1.7.2.5

