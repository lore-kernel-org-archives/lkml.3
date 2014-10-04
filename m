Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaJDDRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 23:17:42 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:9702 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbaJDDRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 23:17:38 -0400
Subject: [PATCH 2/3] MIPS: Setup an instruction emulation in VDSO protected
	page instead of user stack
To: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <david.daney@cavium.com>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <davidlohr@hp.com>,
        <macro@linux-mips.org>, <chenhc@lemote.com>, <zajec5@gmail.com>,
        <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <manuel.lauss@gmail.com>, <akpm@linux-foundation.org>,
        <lars.persson@axis.com>
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Date: Fri, 3 Oct 2014 20:17:30 -0700
Message-ID: <20141004031730.28569.38511.stgit@linux-yegoshin>
In-Reply-To: <20141004030438.28569.85536.stgit@linux-yegoshin>
References: <20141004030438.28569.85536.stgit@linux-yegoshin>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Historically, during FPU emulation MIPS runs live BD-slot instruction in stack.
This is needed because it was the only way to correctly handle branch
exceptions with unknown COP2 instructions in BD-slot. Now there is
an eXecuteInhibit feature and it is desirable to protect stack from execution
for security reasons.
This patch moves FPU emulation from stack area to VDSO-located page which is set
write-protected for application access. VDSO page itself is now per-thread and
it's addresses and offsets are stored in thread_info.
Small stack of emulation blocks is supported because nested traps are possible
in MIPS32/64 R6 emulation mix with FPU emulation.

Explanation of problem (current state before patch):

If I set eXecute-disabled stack in ELF binary initialisation then GLIBC ignores
it and may change stack protection at library load. If this library has
eXecute-disabled stack then anything is OK, but if this section (PT_GNU_STACK)
is just missed as usual, then GLIBC applies it's own default == eXecute-enabled
stack.
So, ssh_keygen is built explicitly with eXecute-disabled stack. But GLIBC
ignores it and set stack executable. And because of that - anything works,
FPU emulation and hacker tools.
However, if I use all *.SO libraries with eXecute-disabled stack in PT_GNU_STACK
section then GLIBC keeps stack non-executable but things fails at FPU emulation
later.

Here are two issues which are bind together and to solve an incorrect
behaviour of GLIBC (ignoring X ssh-keygen intention) the splitting both issues
is needed. So, I did a kernel emulation protected and out of stack.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
---
 arch/mips/include/asm/mmu.h         |    2 +
 arch/mips/include/asm/processor.h   |    2 -
 arch/mips/include/asm/switch_to.h   |   12 ++++
 arch/mips/include/asm/thread_info.h |    3 +
 arch/mips/include/asm/tlbmisc.h     |    1 
 arch/mips/include/asm/vdso.h        |    2 +
 arch/mips/kernel/process.c          |    7 ++
 arch/mips/kernel/vdso.c             |   41 ++++++++++++-
 arch/mips/math-emu/dsemul.c         |  114 ++++++++++++++++++++++++++---------
 arch/mips/mm/fault.c                |    5 ++
 arch/mips/mm/tlb-r4k.c              |   39 ++++++++++++
 11 files changed, 197 insertions(+), 31 deletions(-)

diff --git a/arch/mips/include/asm/mmu.h b/arch/mips/include/asm/mmu.h
index c436138..96266b8 100644
--- a/arch/mips/include/asm/mmu.h
+++ b/arch/mips/include/asm/mmu.h
@@ -3,7 +3,9 @@
 
 typedef struct {
 	unsigned long asid[NR_CPUS];
+	unsigned long vdso_asid[NR_CPUS];
 	void *vdso;
+	struct vm_area_struct   *vdso_vma;
 } mm_context_t;
 
 #endif /* __ASM_MMU_H */
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 05f0843..c87b1da 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -40,7 +40,7 @@ extern unsigned int vced_count, vcei_count;
  * A special page (the vdso) is mapped into all processes at the very
  * top of the virtual memory space.
  */
-#define SPECIAL_PAGES_SIZE PAGE_SIZE
+#define SPECIAL_PAGES_SIZE (PAGE_SIZE * 2)
 
 #ifdef CONFIG_32BIT
 #ifdef CONFIG_KVM_GUEST
diff --git a/arch/mips/include/asm/switch_to.h b/arch/mips/include/asm/switch_to.h
index b928b6f..0968f51 100644
--- a/arch/mips/include/asm/switch_to.h
+++ b/arch/mips/include/asm/switch_to.h
@@ -17,6 +17,7 @@
 #include <asm/dsp.h>
 #include <asm/cop2.h>
 #include <asm/msa.h>
+#include <asm/mmu_context.h>
 
 struct task_struct;
 
@@ -104,6 +105,16 @@ do {									\
 	disable_msa();							\
 } while (0)
 
+static inline void flush_vdso_page(void)
+{
+	if (current->mm && cpu_context(raw_smp_processor_id(), current->mm) &&
+	    (current->mm->context.vdso_asid[raw_smp_processor_id()] ==
+	     cpu_asid(raw_smp_processor_id(), current->mm))) {
+		local_flush_tlb_page(current->mm->mmap, (unsigned long)current->mm->context.vdso);
+		current->mm->context.vdso_asid[raw_smp_processor_id()] = 0;
+	}
+}
+
 #define finish_arch_switch(prev)					\
 do {									\
 	u32 __c0_stat;							\
@@ -118,6 +129,7 @@ do {									\
 		__restore_dsp(current);					\
 	if (cpu_has_userlocal)						\
 		write_c0_userlocal(current_thread_info()->tp_value);	\
+	flush_vdso_page();                                              \
 	__restore_watch();						\
 } while (0)
 
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 7de8658..8d16003 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -34,6 +34,8 @@ struct thread_info {
 						 * 0x7fffffff for user-thead
 						 * 0xffffffff for kernel-thread
 						 */
+	unsigned long           vdso_offset;
+	struct page             *vdso_page;
 	struct restart_block	restart_block;
 	struct pt_regs		*regs;
 };
@@ -49,6 +51,7 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
+	.vdso_page      = NULL,                 \
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
diff --git a/arch/mips/include/asm/tlbmisc.h b/arch/mips/include/asm/tlbmisc.h
index 3a45228..abd7bf6 100644
--- a/arch/mips/include/asm/tlbmisc.h
+++ b/arch/mips/include/asm/tlbmisc.h
@@ -6,5 +6,6 @@
  */
 extern void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 	unsigned long entryhi, unsigned long pagemask);
+int install_vdso_tlb(void);
 
 #endif /* __ASM_TLBMISC_H */
diff --git a/arch/mips/include/asm/vdso.h b/arch/mips/include/asm/vdso.h
index cca56aa..baf3402 100644
--- a/arch/mips/include/asm/vdso.h
+++ b/arch/mips/include/asm/vdso.h
@@ -11,6 +11,8 @@
 
 #include <linux/types.h>
 
+void mips_thread_vdso(struct thread_info *ti);
+void arch_release_thread_info(struct thread_info *info);
 
 #ifdef CONFIG_32BIT
 struct mips_vdso {
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 636b074..762738a 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -42,6 +42,7 @@
 #include <asm/isadep.h>
 #include <asm/inst.h>
 #include <asm/stacktrace.h>
+#include <asm/vdso.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 void arch_cpu_idle_dead(void)
@@ -59,6 +60,8 @@ void start_thread(struct pt_regs * regs, unsigned long pc, unsigned long sp)
 {
 	unsigned long status;
 
+	mips_thread_vdso(current_thread_info());
+
 	/* New thread loses kernel privileges. */
 	status = regs->cp0_status & ~(ST0_CU0|ST0_CU1|ST0_FR|KU_MASK);
 	status |= KU_USER;
@@ -75,6 +78,7 @@ void start_thread(struct pt_regs * regs, unsigned long pc, unsigned long sp)
 
 void exit_thread(void)
 {
+	arch_release_thread_info(current_thread_info());
 }
 
 void flush_thread(void)
@@ -103,6 +107,9 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 
 	preempt_enable();
 
+	ti->vdso_page = NULL;
+	mips_thread_vdso(ti);
+
 	/* set up new TSS. */
 	childregs = (struct pt_regs *) childksp - 1;
 	/*  Put the stack after the struct pt_regs.  */
diff --git a/arch/mips/kernel/vdso.c b/arch/mips/kernel/vdso.c
index 0f1af58..7b31bba 100644
--- a/arch/mips/kernel/vdso.c
+++ b/arch/mips/kernel/vdso.c
@@ -19,6 +19,8 @@
 
 #include <asm/vdso.h>
 #include <asm/uasm.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
 
 /*
  * Including <asm/unistd.h> would give use the 64-bit syscall numbers ...
@@ -88,14 +90,18 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	ret = install_special_mapping(mm, addr, PAGE_SIZE,
 				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				      VM_MAYREAD|VM_MAYEXEC,
 				      &vdso_page);
 
 	if (ret)
 		goto up_fail;
 
 	mm->context.vdso = (void *)addr;
+	/* if cache aliasing - use a different cache flush later */
+	if (cpu_has_rixi && cpu_has_dc_aliases)
+		mm->context.vdso_vma = find_vma(mm,addr);
 
+	mips_thread_vdso(current_thread_info());
 up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
@@ -107,3 +113,36 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 		return "[vdso]";
 	return NULL;
 }
+
+void mips_thread_vdso(struct thread_info *ti)
+{
+	struct page *vdso;
+	unsigned long addr;
+
+	if (cpu_has_rixi && ti->task->mm && !ti->vdso_page) {
+		vdso = alloc_page(GFP_USER);
+		if (!vdso)
+			return;
+		ti->vdso_page = vdso;
+		ti->vdso_offset = PAGE_SIZE;
+		addr = (unsigned long)page_address(vdso);
+		copy_page((void *)addr, (void *)page_address(vdso_page));
+		if (!cpu_has_ic_fills_f_dc)
+			flush_data_cache_page(addr);
+		/* any vma in mmap is used, just to get ASIDs back from mm */
+		local_flush_tlb_page(ti->task->mm->mmap,addr);
+	}
+}
+
+void arch_release_thread_info(struct thread_info *info)
+{
+	if (info->vdso_page) {
+		if (info->task->mm) {
+			/* any vma in mmap is used, just to get ASIDs */
+			local_flush_tlb_page(info->task->mm->mmap,(unsigned long)page_address(info->vdso_page));
+			info->task->mm->context.vdso_asid[smp_processor_id()] = 0;
+		}
+		__free_page(info->vdso_page);
+		info->vdso_page = NULL;
+	}
+}
diff --git a/arch/mips/math-emu/dsemul.c b/arch/mips/math-emu/dsemul.c
index 4f514f3..274f9b7 100644
--- a/arch/mips/math-emu/dsemul.c
+++ b/arch/mips/math-emu/dsemul.c
@@ -3,6 +3,7 @@
 #include <asm/fpu_emulator.h>
 #include <asm/inst.h>
 #include <asm/mipsregs.h>
+#include <asm/vdso.h>
 #include <asm/uaccess.h>
 
 #include "ieee754.h"
@@ -30,12 +31,15 @@ struct emuframe {
 	mips_instruction	cookie;
 	unsigned long		epc;
 };
+/* round structure size to N*8 to force a fit two instructions in a single cache line */
+#define EMULFRAME_ROUNDED_SIZE  ((sizeof(struct emuframe) + 0x7) & ~0x7)
 
 int mips_dsemul(struct pt_regs *regs, mips_instruction ir, unsigned long cpc)
 {
 	extern asmlinkage void handle_dsemulret(void);
 	struct emuframe __user *fr;
 	int err;
+	unsigned char *pg_addr;
 
 	if ((get_isa16_mode(regs->cp0_epc) && ((ir >> 16) == MM_NOP16)) ||
 		(ir == 0)) {
@@ -48,7 +52,7 @@ int mips_dsemul(struct pt_regs *regs, mips_instruction ir, unsigned long cpc)
 	pr_debug("dsemul %lx %lx\n", regs->cp0_epc, cpc);
 
 	/*
-	 * The strategy is to push the instruction onto the user stack
+	 * The strategy is to push the instruction onto the user stack/VDSO page
 	 * and put a trap after it which we can catch and jump to
 	 * the required address any alternative apart from full
 	 * instruction emulation!!.
@@ -65,37 +69,78 @@ int mips_dsemul(struct pt_regs *regs, mips_instruction ir, unsigned long cpc)
 	 * handler (single entry point).
 	 */
 
-	/* Ensure that the two instructions are in the same cache line */
-	fr = (struct emuframe __user *)
-		((regs->regs[29] - sizeof(struct emuframe)) & ~0x7);
-
-	/* Verify that the stack pointer is not competely insane */
-	if (unlikely(!access_ok(VERIFY_WRITE, fr, sizeof(struct emuframe))))
-		return SIGBUS;
-
-	if (get_isa16_mode(regs->cp0_epc)) {
-		err = __put_user(ir >> 16, (u16 __user *)(&fr->emul));
-		err |= __put_user(ir & 0xffff, (u16 __user *)((long)(&fr->emul) + 2));
-		err |= __put_user(BREAK_MATH >> 16, (u16 __user *)(&fr->badinst));
-		err |= __put_user(BREAK_MATH & 0xffff, (u16 __user *)((long)(&fr->badinst) + 2));
+	if (current_thread_info()->vdso_page) {
+		/*
+		 * Use VDSO page and fill structure via kernel VA,
+		 * user write is disabled
+		 */
+		pg_addr = (unsigned char *)page_address(current_thread_info()->vdso_page);
+		fr = (struct emuframe __user *)
+			    (pg_addr + current_thread_info()->vdso_offset -
+			     EMULFRAME_ROUNDED_SIZE);
+
+		/* verify that we don't overflow into trampoline areas */
+		if ((unsigned char *)fr < (unsigned char *)(((struct mips_vdso *)pg_addr) + 1)) {
+			MIPS_FPU_EMU_INC_STATS(errors);
+			return SIGBUS;
+		}
+
+		current_thread_info()->vdso_offset -= EMULFRAME_ROUNDED_SIZE;
+
+		if (get_isa16_mode(regs->cp0_epc)) {
+			*(u16 *)&fr->emul = (u16)(ir >> 16);
+			*((u16 *)(&fr->emul) + 1) = (u16)(ir & 0xffff);
+		} else {
+			fr->emul = ir;
+			fr->badinst = (mips_instruction)BREAK_MATH;
+		}
+		fr->cookie = (mips_instruction)BD_COOKIE;
+		fr->epc = cpc;
+
+		/* fill CP0_EPC with user VA */
+		regs->cp0_epc = ((unsigned long)(current->mm->context.vdso +
+				current_thread_info()->vdso_offset)) |
+				get_isa16_mode(regs->cp0_epc);
+		if (cpu_has_dc_aliases)
+			mips_flush_data_cache_range(current->mm->context.vdso_vma,
+				regs->cp0_epc, current_thread_info()->vdso_page,
+				(unsigned long)fr, sizeof(struct emuframe));
+		else
+			/* it is a less expensive on CPU with correct SYNCI */
+			flush_cache_sigtramp((unsigned long)fr);
 	} else {
-		err = __put_user(ir, &fr->emul);
-		err |= __put_user((mips_instruction)BREAK_MATH, &fr->badinst);
+		/* Ensure that the two instructions are in the same cache line */
+		fr = (struct emuframe __user *)
+			((regs->regs[29] - sizeof(struct emuframe)) & ~0x7);
+
+		/* Verify that the stack pointer is not competely insane */
+		if (unlikely(!access_ok(VERIFY_WRITE, fr, sizeof(struct emuframe))))
+			return SIGBUS;
+
+		if (get_isa16_mode(regs->cp0_epc)) {
+			err = __put_user(ir >> 16, (u16 __user *)(&fr->emul));
+			err |= __put_user(ir & 0xffff, (u16 __user *)((long)(&fr->emul) + 2));
+			err |= __put_user(BREAK_MATH >> 16, (u16 __user *)(&fr->badinst));
+			err |= __put_user(BREAK_MATH & 0xffff, (u16 __user *)((long)(&fr->badinst) + 2));
+		} else {
+			err = __put_user(ir, &fr->emul);
+			err |= __put_user((mips_instruction)BREAK_MATH, &fr->badinst);
+		}
+
+		err |= __put_user((mips_instruction)BD_COOKIE, &fr->cookie);
+		err |= __put_user(cpc, &fr->epc);
+
+		if (unlikely(err)) {
+			MIPS_FPU_EMU_INC_STATS(errors);
+			return SIGBUS;
+		}
+
+		regs->cp0_epc = ((unsigned long) &fr->emul) |
+			get_isa16_mode(regs->cp0_epc);
+
+		flush_cache_sigtramp((unsigned long)&fr->badinst);
 	}
 
-	err |= __put_user((mips_instruction)BD_COOKIE, &fr->cookie);
-	err |= __put_user(cpc, &fr->epc);
-
-	if (unlikely(err)) {
-		MIPS_FPU_EMU_INC_STATS(errors);
-		return SIGBUS;
-	}
-
-	regs->cp0_epc = ((unsigned long) &fr->emul) |
-		get_isa16_mode(regs->cp0_epc);
-
-	flush_cache_sigtramp((unsigned long)&fr->badinst);
-
 	return SIGILL;		/* force out of emulation loop */
 }
 
@@ -156,6 +201,17 @@ int do_dsemulret(struct pt_regs *xcp)
 		return 0;
 	}
 
+	if (current_thread_info()->vdso_page) {
+		/* restore VDSO stack level */
+		current_thread_info()->vdso_offset += EMULFRAME_ROUNDED_SIZE;
+		if (current_thread_info()->vdso_offset > PAGE_SIZE) {
+			/* This is not a good situation to be in */
+			current_thread_info()->vdso_offset -= EMULFRAME_ROUNDED_SIZE;
+			force_sig(SIGBUS, current);
+
+			return 0;
+		}
+	}
 	/* Set EPC to return to post-branch instruction */
 	xcp->cp0_epc = epc;
 
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index becc42b..516045a 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -26,6 +26,7 @@
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/highmem.h>		/* For VMALLOC_END */
+#include <asm/tlbmisc.h>
 #include <linux/kdebug.h>
 
 /*
@@ -138,6 +139,9 @@ good_area:
 #endif
 				goto bad_area;
 			}
+			if (((address & PAGE_MASK) == (unsigned long)(mm->context.vdso)) &&
+			    install_vdso_tlb())
+				goto up_return;
 		} else {
 			if (!(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
 				goto bad_area;
@@ -186,6 +190,7 @@ good_area:
 		}
 	}
 
+up_return:
 	up_read(&mm->mmap_sem);
 	return;
 
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index fa6ebd4..a857e21 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -350,6 +350,45 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 	local_irq_restore(flags);
 }
 
+int install_vdso_tlb(void)
+{
+	int tlbidx;
+	unsigned long flags;
+
+	if (!current_thread_info()->vdso_page)
+		return(0);
+
+	local_irq_save(flags);
+	write_c0_entryhi(((unsigned long)current->mm->context.vdso & (PAGE_MASK << 1)) |
+			 cpu_asid(smp_processor_id(), current->mm));
+
+	mtc0_tlbw_hazard();
+	tlb_probe();
+	tlb_probe_hazard();
+	tlbidx = read_c0_index();
+#if defined(CONFIG_64BIT_PHYS_ADDR) && defined(CONFIG_CPU_MIPS32)
+		write_c0_entrylo0(pte_val(pfn_pte(
+			page_to_pfn(current_thread_info()->vdso_page),
+			__pgprot(_page_cachable_default|_PAGE_VALID)))>>32);
+#else
+		write_c0_entrylo0(pte_to_entrylo(pte_val(pfn_pte(
+			page_to_pfn(current_thread_info()->vdso_page),
+			__pgprot(_page_cachable_default|_PAGE_VALID)))));
+#endif
+	write_c0_entrylo1(0);
+	mtc0_tlbw_hazard();
+	if (tlbidx < 0)
+		tlb_write_random();
+	else
+		tlb_write_indexed();
+	tlbw_use_hazard();
+
+	current->mm->context.vdso_asid[smp_processor_id()] = cpu_asid(smp_processor_id(), current->mm);
+	local_irq_restore(flags);
+
+	return(1);
+}
+
 void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 		     unsigned long entryhi, unsigned long pagemask)
 {

