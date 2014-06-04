Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaFDWV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:21:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaFDWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:21:23 -0400
Date: Wed, 4 Jun 2014 15:20:16 -0700
Message-Id: <201406042220.s54MKGxL015472@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/espfix changes for v3.16
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: amluto@gmail.com, arjan.van.de.ven@intel.com, boris.ostrovsky@oracle.com,
        bp@alien8.de, brgerst@gmail.com, comexk@gmail.com, dirk@hohndel.org,
        fengguang.wu@intel.com, heukelum@fastmail.fm, hpa@linux.intel.com,
        hpa@zytor.com, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, richard@nod.at, tglx@linutronix.de,
        torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the espfix64 code, which fixes the IRET information leak as
well as the associated functionality problem.  With this code applied,
16-bit stack segments finally work as intended even on a 64-bit
kernel.

Consequently, this patchset also removes the runtime option that we
added as an interrim measure.

To help the people working on Linux kernels for very small systems,
this patchset also makes these compile-time configurable features.

The following changes since commit 172de656b98efd81399aec83837dccaa276622c4:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-05-20 14:21:11 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/espfix

for you to fetch changes up to e6ab9a20e73e790d47e6aa231fcf66f27b6ce3d4:

  Merge commit '7ed6fb9b5a5510e4ef78ab27419184741169978a' into x86/espfix (2014-05-21 15:23:19 -0700)

----------------------------------------------------------------

H. Peter Anvin (8):
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit stack
      x86-32, espfix: Remove filter for espfix32 due to race
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"
      Merge commit '7ed6fb9b5a5510e4ef78ab27419184741169978a' into x86/espfix

 Documentation/x86/x86_64/mm.txt         |   2 +
 arch/x86/Kconfig                        |  25 +++-
 arch/x86/include/asm/espfix.h           |  16 +++
 arch/x86/include/asm/pgtable_64_types.h |   2 +
 arch/x86/include/asm/setup.h            |   2 +
 arch/x86/kernel/Makefile                |   1 +
 arch/x86/kernel/entry_32.S              |  17 ++-
 arch/x86/kernel/entry_64.S              |  81 ++++++++++++-
 arch/x86/kernel/espfix_64.c             | 209 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/ldt.c                   |  10 +-
 arch/x86/kernel/smpboot.c               |   7 ++
 arch/x86/mm/dump_pagetables.c           |  44 +++++--
 arch/x86/vdso/vdso32-setup.c            |   8 --
 init/main.c                             |   4 +
 14 files changed, 387 insertions(+), 41 deletions(-)
 create mode 100644 arch/x86/include/asm/espfix.h
 create mode 100644 arch/x86/kernel/espfix_64.c

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index c584a51..afe68dd 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -12,6 +12,8 @@ ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
 ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
 ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
+ffffff0000000000 - ffffff7fffffffff (=39 bits) %esp fixup stacks
+... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
 ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
 ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..956c770 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -909,10 +909,27 @@ config VM86
 	default y
 	depends on X86_32
 	---help---
-	  This option is required by programs like DOSEMU to run 16-bit legacy
-	  code on X86 processors. It also may be needed by software like
-	  XFree86 to initialize some video cards via BIOS. Disabling this
-	  option saves about 6k.
+	  This option is required by programs like DOSEMU to run
+	  16-bit real mode legacy code on x86 processors. It also may
+	  be needed by software like XFree86 to initialize some video
+	  cards via BIOS. Disabling this option saves about 6K.
+
+config X86_16BIT
+	bool "Enable support for 16-bit segments" if EXPERT
+	default y
+	---help---
+	  This option is required by programs like Wine to run 16-bit
+	  protected mode legacy code on x86 processors.  Disabling
+	  this option saves about 300 bytes on i386, or around 6K text
+	  plus 16K runtime memory on x86-64,
+
+config X86_ESPFIX32
+	def_bool y
+	depends on X86_16BIT && X86_32
+
+config X86_ESPFIX64
+	def_bool y
+	depends on X86_16BIT && X86_64
 
 config TOSHIBA
 	tristate "Toshiba Laptop support"
diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
new file mode 100644
index 0000000..99efebb
--- /dev/null
+++ b/arch/x86/include/asm/espfix.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_X86_ESPFIX_H
+#define _ASM_X86_ESPFIX_H
+
+#ifdef CONFIG_X86_64
+
+#include <asm/percpu.h>
+
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_waddr);
+
+extern void init_espfix_bsp(void);
+extern void init_espfix_ap(void);
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_ESPFIX_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index c883bf7..7166e25 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -61,6 +61,8 @@ typedef struct { pteval_t pte; } pte_t;
 #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
+#define ESPFIX_PGD_ENTRY _AC(-2, UL)
+#define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
 
 #define EARLY_DYNAMIC_PAGE_TABLES	64
 
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 9264f04..ff4e7b2 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -59,6 +59,8 @@ static inline void x86_ce4100_early_setup(void) { }
 
 #ifndef _SETUP
 
+#include <asm/espfix.h>
+
 /*
  * This is set up by the setup-routine at boot-time
  */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f4d9600..491ef3e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
+obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f46..98313ff 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -527,6 +527,7 @@ syscall_exit:
 restore_all:
 	TRACE_IRQS_IRET
 restore_all_notrace:
+#ifdef CONFIG_X86_ESPFIX32
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS, SS and CS
 	# Warning: PT_OLDSS(%esp) contains the wrong/random values if we
 	# are returning to the kernel.
@@ -537,6 +538,7 @@ restore_all_notrace:
 	cmpl $((SEGMENT_LDT << 8) | USER_RPL), %eax
 	CFI_REMEMBER_STATE
 	je ldt_ss			# returning to user-space with LDT SS
+#endif
 restore_nocheck:
 	RESTORE_REGS 4			# skip orig_eax/error_code
 irq_return:
@@ -549,13 +551,9 @@ ENTRY(iret_exc)
 .previous
 	_ASM_EXTABLE(irq_return,iret_exc)
 
+#ifdef CONFIG_X86_ESPFIX32
 	CFI_RESTORE_STATE
 ldt_ss:
-	larl PT_OLDSS(%esp), %eax
-	jnz restore_nocheck
-	testl $0x00400000, %eax		# returning to 32bit stack?
-	jnz restore_nocheck		# allright, normal return
-
 #ifdef CONFIG_PARAVIRT
 	/*
 	 * The kernel can't run on a non-flat stack if paravirt mode
@@ -597,6 +595,7 @@ ldt_ss:
 	lss (%esp), %esp		/* switch to espfix segment */
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
+#endif
 	CFI_ENDPROC
 ENDPROC(system_call)
 
@@ -704,6 +703,7 @@ END(syscall_badsys)
  * the high word of the segment base from the GDT and swiches to the
  * normal stack and adjusts ESP with the matching offset.
  */
+#ifdef CONFIG_X86_ESPFIX32
 	/* fixup the stack */
 	mov GDT_ESPFIX_SS + 4, %al /* bits 16..23 */
 	mov GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
@@ -713,8 +713,10 @@ END(syscall_badsys)
 	pushl_cfi %eax
 	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
+#endif
 .endm
 .macro UNWIND_ESPFIX_STACK
+#ifdef CONFIG_X86_ESPFIX32
 	movl %ss, %eax
 	/* see if on espfix stack */
 	cmpw $__ESPFIX_SS, %ax
@@ -725,6 +727,7 @@ END(syscall_badsys)
 	/* switch to normal stack */
 	FIXUP_ESPFIX_STACK
 27:
+#endif
 .endm
 
 /*
@@ -1355,11 +1358,13 @@ END(debug)
 ENTRY(nmi)
 	RING0_INT_FRAME
 	ASM_CLAC
+#ifdef CONFIG_X86_ESPFIX32
 	pushl_cfi %eax
 	movl %ss, %eax
 	cmpw $__ESPFIX_SS, %ax
 	popl_cfi %eax
 	je nmi_espfix_stack
+#endif
 	cmpl $ia32_sysenter_target,(%esp)
 	je nmi_stack_fixup
 	pushl_cfi %eax
@@ -1399,6 +1404,7 @@ nmi_debug_stack_check:
 	FIX_STACK 24, nmi_stack_correct, 1
 	jmp nmi_stack_correct
 
+#ifdef CONFIG_X86_ESPFIX32
 nmi_espfix_stack:
 	/* We have a RING0_INT_FRAME here.
 	 *
@@ -1420,6 +1426,7 @@ nmi_espfix_stack:
 	lss 12+4(%esp), %esp		# back to espfix stack
 	CFI_ADJUST_CFA_OFFSET -24
 	jmp irq_return
+#endif
 	CFI_ENDPROC
 END(nmi)
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..da0b9bd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -58,6 +58,7 @@
 #include <asm/asm.h>
 #include <asm/context_tracking.h>
 #include <asm/smap.h>
+#include <asm/pgtable_types.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -1040,8 +1041,18 @@ restore_args:
 	RESTORE_ARGS 1,8,1
 
 irq_return:
+	/*
+	 * Are we returning to a stack segment from the LDT?  Note: in
+	 * 64-bit mode SS:RSP on the exception stack is always valid.
+	 */
+#ifdef CONFIG_X86_ESPFIX64
+	testb $4,(SS-RIP)(%rsp)
+	jnz irq_return_ldt
+#endif
+
+irq_return_iret:
 	INTERRUPT_RETURN
-	_ASM_EXTABLE(irq_return, bad_iret)
+	_ASM_EXTABLE(irq_return_iret, bad_iret)
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
@@ -1049,6 +1060,32 @@ ENTRY(native_iret)
 	_ASM_EXTABLE(native_iret, bad_iret)
 #endif
 
+#ifdef CONFIG_X86_ESPFIX64
+irq_return_ldt:
+	pushq_cfi %rax
+	pushq_cfi %rdi
+	SWAPGS
+	movq PER_CPU_VAR(espfix_waddr),%rdi
+	movq %rax,(0*8)(%rdi)	/* RAX */
+	movq (2*8)(%rsp),%rax	/* RIP */
+	movq %rax,(1*8)(%rdi)
+	movq (3*8)(%rsp),%rax	/* CS */
+	movq %rax,(2*8)(%rdi)
+	movq (4*8)(%rsp),%rax	/* RFLAGS */
+	movq %rax,(3*8)(%rdi)
+	movq (6*8)(%rsp),%rax	/* SS */
+	movq %rax,(5*8)(%rdi)
+	movq (5*8)(%rsp),%rax	/* RSP */
+	movq %rax,(4*8)(%rdi)
+	andl $0xffff0000,%eax
+	popq_cfi %rdi
+	orq PER_CPU_VAR(espfix_stack),%rax
+	SWAPGS
+	movq %rax,%rsp
+	popq_cfi %rax
+	jmp irq_return_iret
+#endif
+
 	.section .fixup,"ax"
 bad_iret:
 	/*
@@ -1110,9 +1147,45 @@ ENTRY(retint_kernel)
 	call preempt_schedule_irq
 	jmp exit_intr
 #endif
-
 	CFI_ENDPROC
 END(common_interrupt)
+
+	/*
+	 * If IRET takes a fault on the espfix stack, then we
+	 * end up promoting it to a doublefault.  In that case,
+	 * modify the stack to make it look like we just entered
+	 * the #GP handler from user space, similar to bad_iret.
+	 */
+#ifdef CONFIG_X86_ESPFIX64
+	ALIGN
+__do_double_fault:
+	XCPT_FRAME 1 RDI+8
+	movq RSP(%rdi),%rax		/* Trap on the espfix stack? */
+	sarq $PGDIR_SHIFT,%rax
+	cmpl $ESPFIX_PGD_ENTRY,%eax
+	jne do_double_fault		/* No, just deliver the fault */
+	cmpl $__KERNEL_CS,CS(%rdi)
+	jne do_double_fault
+	movq RIP(%rdi),%rax
+	cmpq $irq_return_iret,%rax
+#ifdef CONFIG_PARAVIRT
+	je 1f
+	cmpq $native_iret,%rax
+#endif
+	jne do_double_fault		/* This shouldn't happen... */
+1:
+	movq PER_CPU_VAR(kernel_stack),%rax
+	subq $(6*8-KERNEL_STACK_OFFSET),%rax	/* Reset to original stack */
+	movq %rax,RSP(%rdi)
+	movq $0,(%rax)			/* Missing (lost) #GP error code */
+	movq $general_protection,RIP(%rdi)
+	retq
+	CFI_ENDPROC
+END(__do_double_fault)
+#else
+# define __do_double_fault do_double_fault
+#endif
+
 /*
  * End of kprobes section
  */
@@ -1314,7 +1387,7 @@ zeroentry overflow do_overflow
 zeroentry bounds do_bounds
 zeroentry invalid_op do_invalid_op
 zeroentry device_not_available do_device_not_available
-paranoiderrorentry double_fault do_double_fault
+paranoiderrorentry double_fault __do_double_fault
 zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
 errorentry invalid_TSS do_invalid_TSS
 errorentry segment_not_present do_segment_not_present
@@ -1601,7 +1674,7 @@ error_sti:
  */
 error_kernelspace:
 	incl %ebx
-	leaq irq_return(%rip),%rcx
+	leaq irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
 	je error_swapgs
 	movl %ecx,%eax	/* zero extend */
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
new file mode 100644
index 0000000..6afbb16
--- /dev/null
+++ b/arch/x86/kernel/espfix_64.c
@@ -0,0 +1,209 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *   Copyright 2014 Intel Corporation; author: H. Peter Anvin
+ *
+ *   This program is free software; you can redistribute it and/or modify it
+ *   under the terms and conditions of the GNU General Public License,
+ *   version 2, as published by the Free Software Foundation.
+ *
+ *   This program is distributed in the hope it will be useful, but WITHOUT
+ *   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ *   more details.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * The IRET instruction, when returning to a 16-bit segment, only
+ * restores the bottom 16 bits of the user space stack pointer.  This
+ * causes some 16-bit software to break, but it also leaks kernel state
+ * to user space.
+ *
+ * This works around this by creating percpu "ministacks", each of which
+ * is mapped 2^16 times 64K apart.  When we detect that the return SS is
+ * on the LDT, we copy the IRET frame to the ministack and use the
+ * relevant alias to return to userspace.  The ministacks are mapped
+ * readonly, so if the IRET fault we promote #GP to #DF which is an IST
+ * vector and thus has its own stack; we then do the fixup in the #DF
+ * handler.
+ *
+ * This file sets up the ministacks and the related page tables.  The
+ * actual ministack invocation is in entry_64.S.
+ */
+
+#include <linux/init.h>
+#include <linux/init_task.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/gfp.h>
+#include <linux/random.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/setup.h>
+#include <asm/espfix.h>
+
+/*
+ * Note: we only need 6*8 = 48 bytes for the espfix stack, but round
+ * it up to a cache line to avoid unnecessary sharing.
+ */
+#define ESPFIX_STACK_SIZE	(8*8UL)
+#define ESPFIX_STACKS_PER_PAGE	(PAGE_SIZE/ESPFIX_STACK_SIZE)
+
+/* There is address space for how many espfix pages? */
+#define ESPFIX_PAGE_SPACE	(1UL << (PGDIR_SHIFT-PAGE_SHIFT-16))
+
+#define ESPFIX_MAX_CPUS		(ESPFIX_STACKS_PER_PAGE * ESPFIX_PAGE_SPACE)
+#if CONFIG_NR_CPUS > ESPFIX_MAX_CPUS
+# error "Need more than one PGD for the ESPFIX hack"
+#endif
+
+#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+
+/* This contains the *bottom* address of the espfix stack */
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_waddr);
+
+/* Initialization mutex - should this be a spinlock? */
+static DEFINE_MUTEX(espfix_init_mutex);
+
+/* Page allocation bitmap - each page serves ESPFIX_STACKS_PER_PAGE CPUs */
+#define ESPFIX_MAX_PAGES  DIV_ROUND_UP(CONFIG_NR_CPUS, ESPFIX_STACKS_PER_PAGE)
+static void *espfix_pages[ESPFIX_MAX_PAGES];
+
+static __page_aligned_bss pud_t espfix_pud_page[PTRS_PER_PUD]
+	__aligned(PAGE_SIZE);
+
+static unsigned int page_random, slot_random;
+
+/*
+ * This returns the bottom address of the espfix stack for a specific CPU.
+ * The math allows for a non-power-of-two ESPFIX_STACK_SIZE, in which case
+ * we have to account for some amount of padding at the end of each page.
+ */
+static inline unsigned long espfix_base_addr(unsigned int cpu)
+{
+	unsigned long page, slot;
+	unsigned long addr;
+
+	page = (cpu / ESPFIX_STACKS_PER_PAGE) ^ page_random;
+	slot = (cpu + slot_random) % ESPFIX_STACKS_PER_PAGE;
+	addr = (page << PAGE_SHIFT) + (slot * ESPFIX_STACK_SIZE);
+	addr = (addr & 0xffffUL) | ((addr & ~0xffffUL) << 16);
+	addr += ESPFIX_BASE_ADDR;
+	return addr;
+}
+
+#define PTE_STRIDE        (65536/PAGE_SIZE)
+#define ESPFIX_PTE_CLONES (PTRS_PER_PTE/PTE_STRIDE)
+#define ESPFIX_PMD_CLONES PTRS_PER_PMD
+#define ESPFIX_PUD_CLONES (65536/(ESPFIX_PTE_CLONES*ESPFIX_PMD_CLONES))
+
+#define PGTABLE_PROT	  ((_KERNPG_TABLE & ~_PAGE_RW) | _PAGE_NX)
+
+static void init_espfix_random(void)
+{
+	unsigned long rand;
+
+	/*
+	 * This is run before the entropy pools are initialized,
+	 * but this is hopefully better than nothing.
+	 */
+	if (!arch_get_random_long(&rand)) {
+		/* The constant is an arbitrary large prime */
+		rdtscll(rand);
+		rand *= 0xc345c6b72fd16123UL;
+	}
+
+	slot_random = rand % ESPFIX_STACKS_PER_PAGE;
+	page_random = (rand / ESPFIX_STACKS_PER_PAGE)
+		& (ESPFIX_PAGE_SPACE - 1);
+}
+
+void __init init_espfix_bsp(void)
+{
+	pgd_t *pgd_p;
+	pteval_t ptemask;
+
+	ptemask = __supported_pte_mask;
+
+	/* Install the espfix pud into the kernel page directory */
+	pgd_p = &init_level4_pgt[pgd_index(ESPFIX_BASE_ADDR)];
+	pgd_populate(&init_mm, pgd_p, (pud_t *)espfix_pud_page);
+
+	/* Randomize the locations */
+	init_espfix_random();
+
+	/* The rest is the same as for any other processor */
+	init_espfix_ap();
+}
+
+void init_espfix_ap(void)
+{
+	unsigned int cpu, page;
+	unsigned long addr;
+	pud_t pud, *pud_p;
+	pmd_t pmd, *pmd_p;
+	pte_t pte, *pte_p;
+	int n;
+	void *stack_page;
+	pteval_t ptemask;
+
+	/* We only have to do this once... */
+	if (likely(this_cpu_read(espfix_stack)))
+		return;		/* Already initialized */
+
+	cpu = smp_processor_id();
+	addr = espfix_base_addr(cpu);
+	page = cpu/ESPFIX_STACKS_PER_PAGE;
+
+	/* Did another CPU already set this up? */
+	stack_page = ACCESS_ONCE(espfix_pages[page]);
+	if (likely(stack_page))
+		goto done;
+
+	mutex_lock(&espfix_init_mutex);
+
+	/* Did we race on the lock? */
+	stack_page = ACCESS_ONCE(espfix_pages[page]);
+	if (stack_page)
+		goto unlock_done;
+
+	ptemask = __supported_pte_mask;
+
+	pud_p = &espfix_pud_page[pud_index(addr)];
+	pud = *pud_p;
+	if (!pud_present(pud)) {
+		pmd_p = (pmd_t *)__get_free_page(PGALLOC_GFP);
+		pud = __pud(__pa(pmd_p) | (PGTABLE_PROT & ptemask));
+		paravirt_alloc_pud(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
+		for (n = 0; n < ESPFIX_PUD_CLONES; n++)
+			set_pud(&pud_p[n], pud);
+	}
+
+	pmd_p = pmd_offset(&pud, addr);
+	pmd = *pmd_p;
+	if (!pmd_present(pmd)) {
+		pte_p = (pte_t *)__get_free_page(PGALLOC_GFP);
+		pmd = __pmd(__pa(pte_p) | (PGTABLE_PROT & ptemask));
+		paravirt_alloc_pmd(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
+		for (n = 0; n < ESPFIX_PMD_CLONES; n++)
+			set_pmd(&pmd_p[n], pmd);
+	}
+
+	pte_p = pte_offset_kernel(&pmd, addr);
+	stack_page = (void *)__get_free_page(GFP_KERNEL);
+	pte = __pte(__pa(stack_page) | (__PAGE_KERNEL_RO & ptemask));
+	paravirt_alloc_pte(&init_mm, __pa(stack_page) >> PAGE_SHIFT);
+	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
+		set_pte(&pte_p[n*PTE_STRIDE], pte);
+
+	/* Job is done for this CPU and any CPU which shares this page */
+	ACCESS_ONCE(espfix_pages[page]) = stack_page;
+
+unlock_done:
+	mutex_unlock(&espfix_init_mutex);
+done:
+	this_cpu_write(espfix_stack, addr);
+	this_cpu_write(espfix_waddr, (unsigned long)stack_page
+		       + (addr & ~PAGE_MASK));
+}
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index dcbbaa1..c37886d 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -20,8 +20,6 @@
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
 
-int sysctl_ldt16 = 0;
-
 #ifdef CONFIG_SMP
 static void flush_ldt(void *current_mm)
 {
@@ -231,16 +229,10 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 		}
 	}
 
-	/*
-	 * On x86-64 we do not support 16-bit segments due to
-	 * IRET leaking the high bits of the kernel stack address.
-	 */
-#ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
+	if (!IS_ENABLED(CONFIG_X86_16BIT) && !ldt_info.seg_32bit) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
-#endif
 
 	fill_ldt(&ldt, &ldt_info);
 	if (oldmode)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3482693..5d93ac1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -244,6 +244,13 @@ static void notrace start_secondary(void *unused)
 	check_tsc_sync_target();
 
 	/*
+	 * Enable the espfix hack for this CPU
+	 */
+#ifdef CONFIG_X86_ESPFIX64
+	init_espfix_ap();
+#endif
+
+	/*
 	 * We need to hold vector_lock so there the set of online cpus
 	 * does not change while we are assigning vectors to cpus.  Holding
 	 * this lock ensures we don't half assign or remove an irq from a cpu.
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 20621d7..167ffca 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -30,12 +30,14 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned long current_address;
 	const struct addr_marker *marker;
+	unsigned long lines;
 	bool to_dmesg;
 };
 
 struct addr_marker {
 	unsigned long start_address;
 	const char *name;
+	unsigned long max_lines;
 };
 
 /* indices for address_markers; keep sync'd w/ address_markers below */
@@ -46,6 +48,7 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
+	ESPFIX_START_NR,
 	HIGH_KERNEL_NR,
 	MODULES_VADDR_NR,
 	MODULES_END_NR,
@@ -68,6 +71,7 @@ static struct addr_marker address_markers[] = {
 	{ PAGE_OFFSET,		"Low Kernel Mapping" },
 	{ VMALLOC_START,        "vmalloc() Area" },
 	{ VMEMMAP_START,        "Vmemmap" },
+	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
 	{ MODULES_VADDR,        "Modules" },
 	{ MODULES_END,          "End Modules" },
@@ -182,7 +186,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		      pgprot_t new_prot, int level)
 {
 	pgprotval_t prot, cur;
-	static const char units[] = "KMGTPE";
+	static const char units[] = "BKMGTPE";
 
 	/*
 	 * If we have a "break" in the series, we need to flush the state that
@@ -197,6 +201,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		st->current_prot = new_prot;
 		st->level = level;
 		st->marker = address_markers;
+		st->lines = 0;
 		pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
 				   st->marker->name);
 	} else if (prot != cur || level != st->level ||
@@ -208,17 +213,24 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		/*
 		 * Now print the actual finished series
 		 */
-		pt_dump_seq_printf(m, st->to_dmesg,  "0x%0*lx-0x%0*lx   ",
-				   width, st->start_address,
-				   width, st->current_address);
-
-		delta = (st->current_address - st->start_address) >> 10;
-		while (!(delta & 1023) && unit[1]) {
-			delta >>= 10;
-			unit++;
+		if (!st->marker->max_lines ||
+		    st->lines < st->marker->max_lines) {
+			pt_dump_seq_printf(m, st->to_dmesg,
+					   "0x%0*lx-0x%0*lx   ",
+					   width, st->start_address,
+					   width, st->current_address);
+
+			delta = st->current_address - st->start_address;
+			while (!(delta & 1023) && unit[1]) {
+				delta >>= 10;
+				unit++;
+			}
+			pt_dump_cont_printf(m, st->to_dmesg, "%9lu%c ",
+					    delta, *unit);
+			printk_prot(m, st->current_prot, st->level,
+				    st->to_dmesg);
 		}
-		pt_dump_cont_printf(m, st->to_dmesg, "%9lu%c ", delta, *unit);
-		printk_prot(m, st->current_prot, st->level, st->to_dmesg);
+		st->lines++;
 
 		/*
 		 * We print markers for special areas of address space,
@@ -226,7 +238,17 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		 * This helps in the interpretation.
 		 */
 		if (st->current_address >= st->marker[1].start_address) {
+			if (st->marker->max_lines &&
+			    st->lines > st->marker->max_lines) {
+				unsigned long nskip =
+					st->lines - st->marker->max_lines;
+				pt_dump_seq_printf(m, st->to_dmesg,
+						   "... %lu entr%s skipped ... \n",
+						   nskip,
+						   nskip == 1 ? "y" : "ies");
+			}
 			st->marker++;
+			st->lines = 0;
 			pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
 					   st->marker->name);
 		}
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e1f220e..0034898 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -39,7 +39,6 @@
 #ifdef CONFIG_X86_64
 #define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
-extern int sysctl_ldt16;
 #endif
 
 /*
@@ -250,13 +249,6 @@ static struct ctl_table abi_table2[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
-	{
-		.procname	= "ldt16",
-		.data		= &sysctl_ldt16,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
 	{}
 };
 
diff --git a/init/main.c b/init/main.c
index 48655ce..eb0ea86 100644
--- a/init/main.c
+++ b/init/main.c
@@ -617,6 +617,10 @@ asmlinkage __visible void __init start_kernel(void)
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
+#ifdef CONFIG_X86_ESPFIX64
+	/* Should be run before the first non-init thread is created */
+	init_espfix_bsp();
+#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);
