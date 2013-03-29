Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3C2KBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:01:10 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39749 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3C2KBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:01:07 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 6/6] powerpc: Use generic code for exception handling
Date: Fri, 29 Mar 2013 18:00:21 +0800
Message-Id: <1364551221-23177-7-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032909-9574-0000-0000-000007409571
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the exception handling moved to generic code, and some changes in
following two commits:
56dd9470d7c8734f055da2a6bac553caf4a468eb
  context_tracking: Move exception handling to generic code
6c1e0256fad84a843d915414e4b5973b7443d48d
  context_tracking: Restore correct previous context state on exception exit

it is able for this patch to replace the implementation in arch code
with the generic code in above commits.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/context_tracking.h |   29 ---------------
 arch/powerpc/kernel/exceptions-64s.S        |    4 +--
 arch/powerpc/kernel/traps.c                 |   42 +++++++++++++---------
 arch/powerpc/mm/fault.c                     |    7 ++--
 arch/powerpc/mm/hash_utils_64.c             |   51 ++++++++++++++-------------
 5 files changed, 57 insertions(+), 76 deletions(-)

diff --git a/arch/powerpc/include/asm/context_tracking.h b/arch/powerpc/include/asm/context_tracking.h
index 4da287e..b6f5a33 100644
--- a/arch/powerpc/include/asm/context_tracking.h
+++ b/arch/powerpc/include/asm/context_tracking.h
@@ -1,39 +1,10 @@
 #ifndef _ASM_POWERPC_CONTEXT_TRACKING_H
 #define _ASM_POWERPC_CONTEXT_TRACKING_H
 
-#ifndef __ASSEMBLY__
-#include <linux/context_tracking.h>
-#include <asm/ptrace.h>
-
-/*
- * temporarily defined to avoid potential conflicts with the common
- * implementation, these will be removed by a later patch after the common
- * code enters powerpc tree
- */
-#define exception_enter __exception_enter
-#define exception_exit __exception_exit
-
-static inline void __exception_enter(struct pt_regs *regs)
-{
-	user_exit();
-}
-
-static inline void __exception_exit(struct pt_regs *regs)
-{
-#ifdef CONFIG_CONTEXT_TRACKING
-	if (user_mode(regs))
-		user_enter();
-#endif
-}
-
-#else /* __ASSEMBLY__ */
-
 #ifdef CONFIG_CONTEXT_TRACKING
 #define SCHEDULE_USER bl	.schedule_user
 #else
 #define SCHEDULE_USER bl	.schedule
 #endif
 
-#endif /* !__ASSEMBLY__ */
-
 #endif
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 6d82f4f..a8a5361 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1368,17 +1368,15 @@ END_MMU_FTR_SECTION_IFCLR(MMU_FTR_SLB)
 	rlwimi	r4,r0,32-13,30,30	/* becomes _PAGE_USER access bit */
 	ori	r4,r4,1			/* add _PAGE_PRESENT */
 	rlwimi	r4,r5,22+2,31-2,31-2	/* Set _PAGE_EXEC if trap is 0x400 */
-	addi	r6,r1,STACK_FRAME_OVERHEAD
 
 	/*
 	 * r3 contains the faulting address
 	 * r4 contains the required access permissions
 	 * r5 contains the trap number
-	 * r6 contains the address of pt_regs
 	 *
 	 * at return r3 = 0 for success, 1 for page fault, negative for error
 	 */
-	bl	.hash_page_ct		/* build HPTE if possible */
+	bl	.hash_page		/* build HPTE if possible */
 	cmpdi	r3,0			/* see if hash_page succeeded */
 
 	/* Success */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 6228b6b..1b46c2d9 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -35,6 +35,7 @@
 #include <linux/kdebug.h>
 #include <linux/debugfs.h>
 #include <linux/ratelimit.h>
+#include <linux/context_tracking.h>
 
 #include <asm/emulated_ops.h>
 #include <asm/pgtable.h>
@@ -60,7 +61,6 @@
 #include <asm/switch_to.h>
 #include <asm/tm.h>
 #include <asm/debug.h>
-#include <asm/context_tracking.h>
 
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 int (*__debugger)(struct pt_regs *regs) __read_mostly;
@@ -669,8 +669,9 @@ int machine_check_generic(struct pt_regs *regs)
 void machine_check_exception(struct pt_regs *regs)
 {
 	int recover = 0;
+	enum ctx_state prev_state;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 
 	__get_cpu_var(irq_stat).mce_exceptions++;
 
@@ -712,7 +713,7 @@ void machine_check_exception(struct pt_regs *regs)
 		panic("Unrecoverable Machine check");
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 void SMIException(struct pt_regs *regs)
@@ -722,19 +723,21 @@ void SMIException(struct pt_regs *regs)
 
 void unknown_exception(struct pt_regs *regs)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
 
 	printk("Bad trap at PC: %lx, SR: %lx, vector=%lx\n",
 	       regs->nip, regs->msr, regs->trap);
 
 	_exception(SIGTRAP, regs, 0, 0);
 
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 void instruction_breakpoint_exception(struct pt_regs *regs)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
 
 	if (notify_die(DIE_IABR_MATCH, "iabr_match", regs, 5,
 					5, SIGTRAP) == NOTIFY_STOP)
@@ -744,7 +747,7 @@ void instruction_breakpoint_exception(struct pt_regs *regs)
 	_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 void RunModeException(struct pt_regs *regs)
@@ -754,7 +757,8 @@ void RunModeException(struct pt_regs *regs)
 
 void __kprobes single_step_exception(struct pt_regs *regs)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
 
 	clear_single_step(regs);
 
@@ -767,7 +771,7 @@ void __kprobes single_step_exception(struct pt_regs *regs)
 	_exception(SIGTRAP, regs, TRAP_TRACE, regs->nip);
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 /*
@@ -1020,9 +1024,10 @@ int is_valid_bugaddr(unsigned long addr)
 void __kprobes program_check_exception(struct pt_regs *regs)
 {
 	unsigned int reason = get_reason(regs);
+	enum ctx_state prev_state;
 	extern int do_mathemu(struct pt_regs *regs);
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 
 	/* We can now get here via a FP Unavailable exception if the core
 	 * has no FPU, in that case the reason flags will be 0 */
@@ -1132,14 +1137,15 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 void alignment_exception(struct pt_regs *regs)
 {
 	int sig, code, fixed = 0;
+	enum ctx_state prev_state;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 
 	/* We restore the interrupt state now */
 	if (!arch_irq_disabled_regs(regs))
@@ -1169,7 +1175,7 @@ void alignment_exception(struct pt_regs *regs)
 		bad_page_fault(regs, regs->dar, sig);
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 void StackOverflow(struct pt_regs *regs)
@@ -1198,18 +1204,20 @@ void trace_syscall(struct pt_regs *regs)
 
 void kernel_fp_unavailable_exception(struct pt_regs *regs)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
 
 	printk(KERN_EMERG "Unrecoverable FP Unavailable Exception "
 			  "%lx at %lx\n", regs->trap, regs->nip);
 	die("Unrecoverable FP Unavailable Exception", regs, SIGABRT);
 
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 void altivec_unavailable_exception(struct pt_regs *regs)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
 
 	if (user_mode(regs)) {
 		/* A user program has executed an altivec instruction,
@@ -1223,7 +1231,7 @@ void altivec_unavailable_exception(struct pt_regs *regs)
 	die("Unrecoverable VMX/Altivec Unavailable Exception", regs, SIGABRT);
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 void vsx_unavailable_exception(struct pt_regs *regs)
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 108ab17..141835b 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -32,6 +32,7 @@
 #include <linux/perf_event.h>
 #include <linux/magic.h>
 #include <linux/ratelimit.h>
+#include <linux/context_tracking.h>
 
 #include <asm/firmware.h>
 #include <asm/page.h>
@@ -42,7 +43,6 @@
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
 #include <asm/debug.h>
-#include <asm/context_tracking.h>
 #include <mm/mmu_decl.h>
 
 #include "icswx.h"
@@ -480,9 +480,10 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 			    unsigned long error_code)
 {
 	int ret;
-	exception_enter(regs);
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
 	ret = __do_page_fault(regs, address, error_code);
-	exception_exit(regs);
+	exception_exit(prev_state);
 	return ret;
 }
 
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 360fba8..eeab30f 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -33,6 +33,7 @@
 #include <linux/init.h>
 #include <linux/signal.h>
 #include <linux/memblock.h>
+#include <linux/context_tracking.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
@@ -56,7 +57,6 @@
 #include <asm/fadump.h>
 #include <asm/firmware.h>
 #include <asm/tm.h>
-#include <asm/context_tracking.h>
 
 #ifdef DEBUG
 #define DBG(fmt...) udbg_printf(fmt)
@@ -919,13 +919,17 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 	const struct cpumask *tmp;
 	int rc, user_region = 0, local = 0;
 	int psize, ssize;
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 
 	DBG_LOW("hash_page(ea=%016lx, access=%lx, trap=%lx\n",
 		ea, access, trap);
 
 	if ((ea & ~REGION_MASK) >= PGTABLE_RANGE) {
 		DBG_LOW(" out of pgtable range !\n");
- 		return 1;
+		rc = 1;
+		goto exit;
 	}
 
 	/* Get region & vsid */
@@ -935,7 +939,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		mm = current->mm;
 		if (! mm) {
 			DBG_LOW(" user region with no mm !\n");
-			return 1;
+			rc = 1;
+			goto exit;
 		}
 		psize = get_slice_psize(mm, ea);
 		ssize = user_segment_size(ea);
@@ -954,14 +959,17 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		/* Not a valid range
 		 * Send the problem up to do_page_fault 
 		 */
-		return 1;
+		rc = 1;
+		goto exit;
 	}
 	DBG_LOW(" mm=%p, mm->pgdir=%p, vsid=%016lx\n", mm, mm->pgd, vsid);
 
 	/* Get pgdir */
 	pgdir = mm->pgd;
-	if (pgdir == NULL)
-		return 1;
+	if (pgdir == NULL) {
+		rc = 1;
+		goto exit;
+	}
 
 	/* Check CPU locality */
 	tmp = cpumask_of(smp_processor_id());
@@ -984,7 +992,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 	ptep = find_linux_pte_or_hugepte(pgdir, ea, &hugeshift);
 	if (ptep == NULL || !pte_present(*ptep)) {
 		DBG_LOW(" no PTE !\n");
-		return 1;
+		rc = 1;
+		goto exit;
 	}
 
 	/* Add _PAGE_PRESENT to the required access perm */
@@ -995,13 +1004,16 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 	 */
 	if (access & ~pte_val(*ptep)) {
 		DBG_LOW(" no access !\n");
-		return 1;
+		rc = 1;
+		goto exit;
 	}
 
 #ifdef CONFIG_HUGETLB_PAGE
-	if (hugeshift)
-		return __hash_page_huge(ea, access, vsid, ptep, trap, local,
+	if (hugeshift) {
+		rc = __hash_page_huge(ea, access, vsid, ptep, trap, local,
 					ssize, hugeshift, psize);
+		goto exit;
+	}
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifndef CONFIG_PPC_64K_PAGES
@@ -1081,22 +1093,12 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		pte_val(*(ptep + PTRS_PER_PTE)));
 #endif
 	DBG_LOW(" -> rc=%d\n", rc);
+exit:
+	exception_exit(prev_state);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(hash_page);
 
-int hash_page_ct(unsigned long ea, unsigned long access,
-		 unsigned long trap, struct pt_regs *regs)
-{
-	int ret;
-
-	exception_enter(regs);
-	ret = hash_page(ea, access, trap);
-	exception_exit(regs);
-
-	return ret;
-}
-
 void hash_preload(struct mm_struct *mm, unsigned long ea,
 		  unsigned long access, unsigned long trap)
 {
@@ -1223,7 +1225,8 @@ void flush_hash_range(unsigned long number, int local)
  */
 void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
 
 	if (user_mode(regs)) {
 #ifdef CONFIG_PPC_SUBPAGE_PROT
@@ -1235,7 +1238,7 @@ void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
 	} else
 		bad_page_fault(regs, address, SIGBUS);
 
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
1.7.9.5

