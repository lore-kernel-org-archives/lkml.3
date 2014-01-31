Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaAaBIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 20:08:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaAaBI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 20:08:28 -0500
Date: Thu, 30 Jan 2014 17:07:55 -0800
Message-Id: <201401310107.s0V17t5l007583@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/asmlinkage (LTO) for v3.14
Cc: Andi Kleen <ak@linux.intel.com>, Gleb Natapov <gleb@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ido Yariv <ido@wizery.com>,
        Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 30 Jan 2014 17:08:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset adds more infrastructure for link time optimization
(LTO).

This patchset was pulled into my tree late because of a
miscommunication (part of the patchset was picked up by other
maintainers.)  However, the patchset is strictly build-related and
seems to be okay in testing.

The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asmlinkage-for-linus

for you to fetch changes up to 07ba06d9d293d3c0a512f1cb9189645c6e0424e2:

  x86, asmlinkage, xen: Fix type of NMI (2014-01-29 22:17:18 -0800)

----------------------------------------------------------------
Andi Kleen (6):
      x86, asmlinkage, lguest: Fix C functions used by inline assembler
      x86, asmlinkage, paravirt: Don't rely on local assembler labels
      x86, asmlinkage, paravirt: Make paravirt thunks global
      x86: Use inline assembler instead of global register variable to get sp
      x86, asmlinkage, xen, kvm: Make {xen,kvm}_lock_spinning global and visible
      x86, asmlinkage, xen: Fix type of NMI

 arch/x86/include/asm/paravirt.h       |  2 +-
 arch/x86/include/asm/paravirt_types.h |  9 +++++----
 arch/x86/include/asm/thread_info.h    |  8 +++++---
 arch/x86/kernel/kvm.c                 |  2 +-
 arch/x86/kernel/vsmp_64.c             |  8 ++++----
 arch/x86/lguest/boot.c                | 12 ++++++------
 arch/x86/xen/irq.c                    |  8 ++++----
 arch/x86/xen/mmu.c                    | 16 ++++++++--------
 arch/x86/xen/setup.c                  |  4 ++--
 arch/x86/xen/spinlock.c               |  2 +-
 10 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 401f350ef71b..cd6e1610e29e 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -781,9 +781,9 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
  */
 #define PV_CALLEE_SAVE_REGS_THUNK(func)					\
 	extern typeof(func) __raw_callee_save_##func;			\
-	static void *__##func##__ __used = func;			\
 									\
 	asm(".pushsection .text;"					\
+	    ".globl __raw_callee_save_" #func " ; "			\
 	    "__raw_callee_save_" #func ": "				\
 	    PV_SAVE_ALL_CALLER_REGS					\
 	    "call " #func ";"						\
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index aab8f671b523..7549b8b369e4 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -388,10 +388,11 @@ extern struct pv_lock_ops pv_lock_ops;
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
 /* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code) 					\
-	extern const char start_##ops##_##name[] __visible,		\
-			  end_##ops##_##name[] __visible;		\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
+#define NATIVE_LABEL(a,x,b) "\n\t.globl " a #x "_" #b "\n" a #x "_" #b ":\n\t"
+
+#define DEF_NATIVE(ops, name, code)					\
+	__visible extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	asm(NATIVE_LABEL("start_", ops, name) code NATIVE_LABEL("end_", ops, name))
 
 unsigned paravirt_patch_nop(void);
 unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len);
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 3ba3de457d05..e1940c06ed02 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -163,9 +163,11 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-
-/* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("esp") __used;
+#define current_stack_pointer ({		\
+	unsigned long sp;			\
+	asm("mov %%esp,%0" : "=g" (sp));	\
+	sp;					\
+})
 
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6dd802c6d780..cd1b362e4a23 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -673,7 +673,7 @@ static cpumask_t waiting_cpus;
 /* Track spinlock on which a cpu is waiting */
 static DEFINE_PER_CPU(struct kvm_lock_waiting, klock_waiting);
 
-static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
+__visible void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	struct kvm_lock_waiting *w;
 	int cpu;
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 992f890283e9..f6584a90aba3 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -33,7 +33,7 @@
  * and vice versa.
  */
 
-static unsigned long vsmp_save_fl(void)
+asmlinkage unsigned long vsmp_save_fl(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -43,7 +43,7 @@ static unsigned long vsmp_save_fl(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_save_fl);
 
-static void vsmp_restore_fl(unsigned long flags)
+__visible void vsmp_restore_fl(unsigned long flags)
 {
 	if (flags & X86_EFLAGS_IF)
 		flags &= ~X86_EFLAGS_AC;
@@ -53,7 +53,7 @@ static void vsmp_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_restore_fl);
 
-static void vsmp_irq_disable(void)
+asmlinkage void vsmp_irq_disable(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -61,7 +61,7 @@ static void vsmp_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_irq_disable);
 
-static void vsmp_irq_enable(void)
+asmlinkage void vsmp_irq_enable(void)
 {
 	unsigned long flags = native_save_fl();
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index bdf8532494fe..ad1fb5f53925 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -233,13 +233,13 @@ static void lguest_end_context_switch(struct task_struct *next)
  * flags word contains all kind of stuff, but in practice Linux only cares
  * about the interrupt flag.  Our "save_flags()" just returns that.
  */
-static unsigned long save_fl(void)
+asmlinkage unsigned long lguest_save_fl(void)
 {
 	return lguest_data.irq_enabled;
 }
 
 /* Interrupts go off... */
-static void irq_disable(void)
+asmlinkage void lguest_irq_disable(void)
 {
 	lguest_data.irq_enabled = 0;
 }
@@ -253,8 +253,8 @@ static void irq_disable(void)
  * PV_CALLEE_SAVE_REGS_THUNK(), which pushes %eax onto the stack, calls the
  * C function, then restores it.
  */
-PV_CALLEE_SAVE_REGS_THUNK(save_fl);
-PV_CALLEE_SAVE_REGS_THUNK(irq_disable);
+PV_CALLEE_SAVE_REGS_THUNK(lguest_save_fl);
+PV_CALLEE_SAVE_REGS_THUNK(lguest_irq_disable);
 /*:*/
 
 /* These are in i386_head.S */
@@ -1291,9 +1291,9 @@ __init void lguest_init(void)
 	 */
 
 	/* Interrupt-related operations */
-	pv_irq_ops.save_fl = PV_CALLEE_SAVE(save_fl);
+	pv_irq_ops.save_fl = PV_CALLEE_SAVE(lguest_save_fl);
 	pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(lg_restore_fl);
-	pv_irq_ops.irq_disable = PV_CALLEE_SAVE(irq_disable);
+	pv_irq_ops.irq_disable = PV_CALLEE_SAVE(lguest_irq_disable);
 	pv_irq_ops.irq_enable = __PV_IS_CALLEE_SAVE(lg_irq_enable);
 	pv_irq_ops.safe_halt = lguest_safe_halt;
 
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 0da7f863056f..f56c23b60a6c 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -22,7 +22,7 @@ void xen_force_evtchn_callback(void)
 	(void)HYPERVISOR_xen_version(0, NULL);
 }
 
-static unsigned long xen_save_fl(void)
+asmlinkage unsigned long xen_save_fl(void)
 {
 	struct vcpu_info *vcpu;
 	unsigned long flags;
@@ -40,7 +40,7 @@ static unsigned long xen_save_fl(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_save_fl);
 
-static void xen_restore_fl(unsigned long flags)
+__visible void xen_restore_fl(unsigned long flags)
 {
 	struct vcpu_info *vcpu;
 
@@ -62,7 +62,7 @@ static void xen_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_restore_fl);
 
-static void xen_irq_disable(void)
+asmlinkage void xen_irq_disable(void)
 {
 	/* There's a one instruction preempt window here.  We need to
 	   make sure we're don't switch CPUs between getting the vcpu
@@ -73,7 +73,7 @@ static void xen_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_irq_disable);
 
-static void xen_irq_enable(void)
+asmlinkage void xen_irq_enable(void)
 {
 	struct vcpu_info *vcpu;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ce563be09cc1..648512c50cc7 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -431,7 +431,7 @@ static pteval_t iomap_pte(pteval_t val)
 	return val;
 }
 
-static pteval_t xen_pte_val(pte_t pte)
+__visible pteval_t xen_pte_val(pte_t pte)
 {
 	pteval_t pteval = pte.pte;
 #if 0
@@ -448,7 +448,7 @@ static pteval_t xen_pte_val(pte_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
 
-static pgdval_t xen_pgd_val(pgd_t pgd)
+__visible pgdval_t xen_pgd_val(pgd_t pgd)
 {
 	return pte_mfn_to_pfn(pgd.pgd);
 }
@@ -479,7 +479,7 @@ void xen_set_pat(u64 pat)
 	WARN_ON(pat != 0x0007010600070106ull);
 }
 
-static pte_t xen_make_pte(pteval_t pte)
+__visible pte_t xen_make_pte(pteval_t pte)
 {
 	phys_addr_t addr = (pte & PTE_PFN_MASK);
 #if 0
@@ -514,14 +514,14 @@ static pte_t xen_make_pte(pteval_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
 
-static pgd_t xen_make_pgd(pgdval_t pgd)
+__visible pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	pgd = pte_pfn_to_mfn(pgd);
 	return native_make_pgd(pgd);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pgd);
 
-static pmdval_t xen_pmd_val(pmd_t pmd)
+__visible pmdval_t xen_pmd_val(pmd_t pmd)
 {
 	return pte_mfn_to_pfn(pmd.pmd);
 }
@@ -580,7 +580,7 @@ static void xen_pmd_clear(pmd_t *pmdp)
 }
 #endif	/* CONFIG_X86_PAE */
 
-static pmd_t xen_make_pmd(pmdval_t pmd)
+__visible pmd_t xen_make_pmd(pmdval_t pmd)
 {
 	pmd = pte_pfn_to_mfn(pmd);
 	return native_make_pmd(pmd);
@@ -588,13 +588,13 @@ static pmd_t xen_make_pmd(pmdval_t pmd)
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pmd);
 
 #if PAGETABLE_LEVELS == 4
-static pudval_t xen_pud_val(pud_t pud)
+__visible pudval_t xen_pud_val(pud_t pud)
 {
 	return pte_mfn_to_pfn(pud.pud);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pud_val);
 
-static pud_t xen_make_pud(pudval_t pud)
+__visible pud_t xen_make_pud(pudval_t pud)
 {
 	pud = pte_pfn_to_mfn(pud);
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 68c054f59de6..518ab4a17b8a 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -34,7 +34,7 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 #ifdef CONFIG_X86_64
-extern const char nmi[];
+extern asmlinkage void nmi(void);
 #endif
 extern void xen_sysenter_target(void);
 extern void xen_syscall_target(void);
@@ -559,7 +559,7 @@ void xen_enable_syscall(void)
 void xen_enable_nmi(void)
 {
 #ifdef CONFIG_X86_64
-	if (register_callback(CALLBACKTYPE_nmi, nmi))
+	if (register_callback(CALLBACKTYPE_nmi, (char *)nmi))
 		BUG();
 #endif
 }
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 0e36cde12f7e..581521c843a5 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -106,7 +106,7 @@ static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
 static cpumask_t waiting_cpus;
 
 static bool xen_pvspin = true;
-static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
+__visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
 	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
