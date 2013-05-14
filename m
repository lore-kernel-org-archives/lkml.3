Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3ENCRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:17:05 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45656 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab3ENCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:17:00 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        michael@ellerman.id.au, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 2/5] powerpc: Exception hooks for context tracking subsystem
Date: Tue, 14 May 2013 10:16:41 +0800
Message-Id: <1368497804-21706-3-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368497804-21706-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1368497804-21706-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051402-8256-0000-0000-0000077BE9C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the exception hooks for context tracking subsystem, including
data access, program check, single step, instruction breakpoint, machine check,
alignment, fp unavailable, altivec assist, unknown exception, whose handlers
might use RCU.

This patch corresponds to
[PATCH] x86: Exception hooks for userspace RCU extended QS
  commit 6ba3c97a38803883c2eee489505796cb0a727122

But after the exception handling moved to generic code, and some changes in
following two commits:
56dd9470d7c8734f055da2a6bac553caf4a468eb
  context_tracking: Move exception handling to generic code
6c1e0256fad84a843d915414e4b5973b7443d48d
  context_tracking: Restore correct previous context state on exception exit

it is able for exception hooks to use the generic code above instead of a
redundant arch implementation.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/traps.c     |   80 ++++++++++++++++++++++++++++-----------
 arch/powerpc/mm/fault.c         |   41 +++++++++++++-------
 arch/powerpc/mm/hash_utils_64.c |   36 +++++++++++++-----
 3 files changed, 112 insertions(+), 45 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 83efa2f..a7a648f 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -35,6 +35,7 @@
 #include <linux/kdebug.h>
 #include <linux/debugfs.h>
 #include <linux/ratelimit.h>
+#include <linux/context_tracking.h>
 
 #include <asm/emulated_ops.h>
 #include <asm/pgtable.h>
@@ -667,6 +668,7 @@ int machine_check_generic(struct pt_regs *regs)
 
 void machine_check_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
 	int recover = 0;
 
 	__get_cpu_var(irq_stat).mce_exceptions++;
@@ -683,7 +685,7 @@ void machine_check_exception(struct pt_regs *regs)
 		recover = cur_cpu_spec->machine_check(regs);
 
 	if (recover > 0)
-		return;
+		goto bail;
 
 #if defined(CONFIG_8xx) && defined(CONFIG_PCI)
 	/* the qspan pci read routines can cause machine checks -- Cort
@@ -693,20 +695,23 @@ void machine_check_exception(struct pt_regs *regs)
 	 * -- BenH
 	 */
 	bad_page_fault(regs, regs->dar, SIGBUS);
-	return;
+	goto bail;
 #endif
 
 	if (debugger_fault_handler(regs))
-		return;
+		goto bail;
 
 	if (check_io_access(regs))
-		return;
+		goto bail;
 
 	die("Machine check", regs, SIGBUS);
 
 	/* Must die if the interrupt is not recoverable */
 	if (!(regs->msr & MSR_RI))
 		panic("Unrecoverable Machine check");
+
+bail:
+	exception_exit(prev_state);
 }
 
 void SMIException(struct pt_regs *regs)
@@ -716,20 +721,29 @@ void SMIException(struct pt_regs *regs)
 
 void unknown_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
+
 	printk("Bad trap at PC: %lx, SR: %lx, vector=%lx\n",
 	       regs->nip, regs->msr, regs->trap);
 
 	_exception(SIGTRAP, regs, 0, 0);
+
+	exception_exit(prev_state);
 }
 
 void instruction_breakpoint_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
+
 	if (notify_die(DIE_IABR_MATCH, "iabr_match", regs, 5,
 					5, SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto bail;
 	if (debugger_iabr_match(regs))
-		return;
+		goto bail;
 	_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
+
+bail:
+	exception_exit(prev_state);
 }
 
 void RunModeException(struct pt_regs *regs)
@@ -739,15 +753,20 @@ void RunModeException(struct pt_regs *regs)
 
 void __kprobes single_step_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
+
 	clear_single_step(regs);
 
 	if (notify_die(DIE_SSTEP, "single_step", regs, 5,
 					5, SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto bail;
 	if (debugger_sstep(regs))
-		return;
+		goto bail;
 
 	_exception(SIGTRAP, regs, TRAP_TRACE, regs->nip);
+
+bail:
+	exception_exit(prev_state);
 }
 
 /*
@@ -1005,6 +1024,7 @@ int is_valid_bugaddr(unsigned long addr)
 
 void __kprobes program_check_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
 	unsigned int reason = get_reason(regs);
 	extern int do_mathemu(struct pt_regs *regs);
 
@@ -1014,26 +1034,26 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 	if (reason & REASON_FP) {
 		/* IEEE FP exception */
 		parse_fpe(regs);
-		return;
+		goto bail;
 	}
 	if (reason & REASON_TRAP) {
 		/* Debugger is first in line to stop recursive faults in
 		 * rcu_lock, notify_die, or atomic_notifier_call_chain */
 		if (debugger_bpt(regs))
-			return;
+			goto bail;
 
 		/* trap exception */
 		if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
 				== NOTIFY_STOP)
-			return;
+			goto bail;
 
 		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
 		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
 			regs->nip += 4;
-			return;
+			goto bail;
 		}
 		_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
-		return;
+		goto bail;
 	}
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (reason & REASON_TM) {
@@ -1049,7 +1069,7 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		if (!user_mode(regs) &&
 		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
 			regs->nip += 4;
-			return;
+			goto bail;
 		}
 		/* If usermode caused this, it's done something illegal and
 		 * gets a SIGILL slap on the wrist.  We call it an illegal
@@ -1059,7 +1079,7 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		 */
 		if (user_mode(regs)) {
 			_exception(SIGILL, regs, ILL_ILLOPN, regs->nip);
-			return;
+			goto bail;
 		} else {
 			printk(KERN_EMERG "Unexpected TM Bad Thing exception "
 			       "at %lx (msr 0x%x)\n", regs->nip, reason);
@@ -1083,16 +1103,16 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 	switch (do_mathemu(regs)) {
 	case 0:
 		emulate_single_step(regs);
-		return;
+		goto bail;
 	case 1: {
 			int code = 0;
 			code = __parse_fpscr(current->thread.fpscr.val);
 			_exception(SIGFPE, regs, code, regs->nip);
-			return;
+			goto bail;
 		}
 	case -EFAULT:
 		_exception(SIGSEGV, regs, SEGV_MAPERR, regs->nip);
-		return;
+		goto bail;
 	}
 	/* fall through on any other errors */
 #endif /* CONFIG_MATH_EMULATION */
@@ -1103,10 +1123,10 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		case 0:
 			regs->nip += 4;
 			emulate_single_step(regs);
-			return;
+			goto bail;
 		case -EFAULT:
 			_exception(SIGSEGV, regs, SEGV_MAPERR, regs->nip);
-			return;
+			goto bail;
 		}
 	}
 
@@ -1114,10 +1134,14 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		_exception(SIGILL, regs, ILL_PRVOPC, regs->nip);
 	else
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
+
+bail:
+	exception_exit(prev_state);
 }
 
 void alignment_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
 	int sig, code, fixed = 0;
 
 	/* We restore the interrupt state now */
@@ -1131,7 +1155,7 @@ void alignment_exception(struct pt_regs *regs)
 	if (fixed == 1) {
 		regs->nip += 4;	/* skip over emulated instruction */
 		emulate_single_step(regs);
-		return;
+		goto bail;
 	}
 
 	/* Operand address was bad */
@@ -1146,6 +1170,9 @@ void alignment_exception(struct pt_regs *regs)
 		_exception(sig, regs, code, regs->dar);
 	else
 		bad_page_fault(regs, regs->dar, sig);
+
+bail:
+	exception_exit(prev_state);
 }
 
 void StackOverflow(struct pt_regs *regs)
@@ -1174,23 +1201,32 @@ void trace_syscall(struct pt_regs *regs)
 
 void kernel_fp_unavailable_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
+
 	printk(KERN_EMERG "Unrecoverable FP Unavailable Exception "
 			  "%lx at %lx\n", regs->trap, regs->nip);
 	die("Unrecoverable FP Unavailable Exception", regs, SIGABRT);
+
+	exception_exit(prev_state);
 }
 
 void altivec_unavailable_exception(struct pt_regs *regs)
 {
+	enum ctx_state prev_state = exception_enter();
+
 	if (user_mode(regs)) {
 		/* A user program has executed an altivec instruction,
 		   but this kernel doesn't support altivec. */
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
-		return;
+		goto bail;
 	}
 
 	printk(KERN_EMERG "Unrecoverable VMX/Altivec Unavailable Exception "
 			"%lx at %lx\n", regs->trap, regs->nip);
 	die("Unrecoverable VMX/Altivec Unavailable Exception", regs, SIGABRT);
+
+bail:
+	exception_exit(prev_state);
 }
 
 void vsx_unavailable_exception(struct pt_regs *regs)
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 229951f..8726779 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -32,6 +32,7 @@
 #include <linux/perf_event.h>
 #include <linux/magic.h>
 #include <linux/ratelimit.h>
+#include <linux/context_tracking.h>
 
 #include <asm/firmware.h>
 #include <asm/page.h>
@@ -196,6 +197,7 @@ static int mm_fault_error(struct pt_regs *regs, unsigned long addr, int fault)
 int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 			    unsigned long error_code)
 {
+	enum ctx_state prev_state = exception_enter();
 	struct vm_area_struct * vma;
 	struct mm_struct *mm = current->mm;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
@@ -204,6 +206,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 	int trap = TRAP(regs);
  	int is_exec = trap == 0x400;
 	int fault;
+	int rc = 0;
 
 #if !(defined(CONFIG_4xx) || defined(CONFIG_BOOKE))
 	/*
@@ -230,28 +233,30 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 	 * look at it
 	 */
 	if (error_code & ICSWX_DSI_UCT) {
-		int rc = acop_handle_fault(regs, address, error_code);
+		rc = acop_handle_fault(regs, address, error_code);
 		if (rc)
-			return rc;
+			goto bail;
 	}
 #endif /* CONFIG_PPC_ICSWX */
 
 	if (notify_page_fault(regs))
-		return 0;
+		goto bail;
 
 	if (unlikely(debugger_fault_handler(regs)))
-		return 0;
+		goto bail;
 
 	/* On a kernel SLB miss we can only check for a valid exception entry */
-	if (!user_mode(regs) && (address >= TASK_SIZE))
-		return SIGSEGV;
+	if (!user_mode(regs) && (address >= TASK_SIZE)) {
+		rc = SIGSEGV;
+		goto bail;
+	}
 
 #if !(defined(CONFIG_4xx) || defined(CONFIG_BOOKE) || \
 			     defined(CONFIG_PPC_BOOK3S_64))
   	if (error_code & DSISR_DABRMATCH) {
 		/* breakpoint match */
 		do_break(regs, address, error_code);
-		return 0;
+		goto bail;
 	}
 #endif
 
@@ -260,8 +265,10 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 		local_irq_enable();
 
 	if (in_atomic() || mm == NULL) {
-		if (!user_mode(regs))
-			return SIGSEGV;
+		if (!user_mode(regs)) {
+			rc = SIGSEGV;
+			goto bail;
+		}
 		/* in_atomic() in user mode is really bad,
 		   as is current->mm == NULL. */
 		printk(KERN_EMERG "Page fault in user mode with "
@@ -417,9 +424,11 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, flags);
 	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
-		int rc = mm_fault_error(regs, address, fault);
+		rc = mm_fault_error(regs, address, fault);
 		if (rc >= MM_FAULT_RETURN)
-			return rc;
+			goto bail;
+		else
+			rc = 0;
 	}
 
 	/*
@@ -454,7 +463,7 @@ good_area:
 	}
 
 	up_read(&mm->mmap_sem);
-	return 0;
+	goto bail;
 
 bad_area:
 	up_read(&mm->mmap_sem);
@@ -463,7 +472,7 @@ bad_area_nosemaphore:
 	/* User mode accesses cause a SIGSEGV */
 	if (user_mode(regs)) {
 		_exception(SIGSEGV, regs, code, address);
-		return 0;
+		goto bail;
 	}
 
 	if (is_exec && (error_code & DSISR_PROTFAULT))
@@ -471,7 +480,11 @@ bad_area_nosemaphore:
 				   " page (%lx) - exploit attempt? (uid: %d)\n",
 				   address, from_kuid(&init_user_ns, current_uid()));
 
-	return SIGSEGV;
+	rc = SIGSEGV;
+
+bail:
+	exception_exit(prev_state);
+	return rc;
 
 }
 
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 88ac0ee..e303a6d 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -33,6 +33,7 @@
 #include <linux/init.h>
 #include <linux/signal.h>
 #include <linux/memblock.h>
+#include <linux/context_tracking.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
@@ -954,6 +955,7 @@ void hash_failure_debug(unsigned long ea, unsigned long access,
  */
 int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 {
+	enum ctx_state prev_state = exception_enter();
 	pgd_t *pgdir;
 	unsigned long vsid;
 	struct mm_struct *mm;
@@ -973,7 +975,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		mm = current->mm;
 		if (! mm) {
 			DBG_LOW(" user region with no mm !\n");
-			return 1;
+			rc = 1;
+			goto bail;
 		}
 		psize = get_slice_psize(mm, ea);
 		ssize = user_segment_size(ea);
@@ -992,19 +995,23 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		/* Not a valid range
 		 * Send the problem up to do_page_fault 
 		 */
-		return 1;
+		rc = 1;
+		goto bail;
 	}
 	DBG_LOW(" mm=%p, mm->pgdir=%p, vsid=%016lx\n", mm, mm->pgd, vsid);
 
 	/* Bad address. */
 	if (!vsid) {
 		DBG_LOW("Bad address!\n");
-		return 1;
+		rc = 1;
+		goto bail;
 	}
 	/* Get pgdir */
 	pgdir = mm->pgd;
-	if (pgdir == NULL)
-		return 1;
+	if (pgdir == NULL) {
+		rc = 1;
+		goto bail;
+	}
 
 	/* Check CPU locality */
 	tmp = cpumask_of(smp_processor_id());
@@ -1027,7 +1034,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 	ptep = find_linux_pte_or_hugepte(pgdir, ea, &hugeshift);
 	if (ptep == NULL || !pte_present(*ptep)) {
 		DBG_LOW(" no PTE !\n");
-		return 1;
+		rc = 1;
+		goto bail;
 	}
 
 	/* Add _PAGE_PRESENT to the required access perm */
@@ -1038,13 +1046,16 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 	 */
 	if (access & ~pte_val(*ptep)) {
 		DBG_LOW(" no access !\n");
-		return 1;
+		rc = 1;
+		goto bail;
 	}
 
 #ifdef CONFIG_HUGETLB_PAGE
-	if (hugeshift)
-		return __hash_page_huge(ea, access, vsid, ptep, trap, local,
+	if (hugeshift) {
+		rc = __hash_page_huge(ea, access, vsid, ptep, trap, local,
 					ssize, hugeshift, psize);
+		goto bail;
+	}
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifndef CONFIG_PPC_64K_PAGES
@@ -1124,6 +1135,9 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		pte_val(*(ptep + PTRS_PER_PTE)));
 #endif
 	DBG_LOW(" -> rc=%d\n", rc);
+
+bail:
+	exception_exit(prev_state);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(hash_page);
@@ -1259,6 +1273,8 @@ void flush_hash_range(unsigned long number, int local)
  */
 void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
 {
+	enum ctx_state prev_state = exception_enter();
+
 	if (user_mode(regs)) {
 #ifdef CONFIG_PPC_SUBPAGE_PROT
 		if (rc == -2)
@@ -1268,6 +1284,8 @@ void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
 			_exception(SIGBUS, regs, BUS_ADRERR, address);
 	} else
 		bad_page_fault(regs, address, SIGBUS);
+
+	exception_exit(prev_state);
 }
 
 long hpte_insert_repeating(unsigned long hash, unsigned long vpn,
-- 
1.7.9.5

