Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaDUWsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:48:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:38043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbaDUWr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:47:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,898,1389772800"; 
   d="scan'208";a="421730441"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <amluto@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Date: Mon, 21 Apr 2014 15:47:52 -0700
Message-Id: <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a prototype of espfix for the 64-bit kernel.  espfix is a
workaround for the architectural definition of IRET, which fails to
restore bits [31:16] of %esp when returning to a 16-bit stack
segment.  We have a workaround for the 32-bit kernel, but that
implementation doesn't work for 64 bits.

The 64-bit implementation works like this:

Set up a ministack for each CPU, which is then mapped 65536 times
using the page tables.  This implementation uses the second-to-last
PGD slot for this; with a 64-byte espfix stack this is sufficient for
2^18 CPUs (currently we support a max of 2^13 CPUs.)

64 bytes appear to be sufficient, because NMI and #MC cause a task
switch.

THIS IS A PROTOTYPE AND IS NOT COMPLETE.  We need to make sure all
code paths that can interrupt userspace execute this code.
Fortunately we never need to use the espfix stack for nested faults,
so one per CPU is guaranteed to be safe.

Furthermore, this code adds unnecessary instructions to the common
path.  For example, on exception entry we push %rdi, pop %rdi, and
then save away %rdi.  Ideally we should do this in such a way that we
avoid unnecessary swapgs, especially on the IRET path (the exception
path is going to be very rare, and so is less critical.)

Putting this version out there for people to look at/laugh at/play
with.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/tip-kicdm89kzw9lldryb1br9od0@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andy Lutomirski <amluto@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Arjan van de Ven <arjan.van.de.ven@intel.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Alexandre Julliard <julliard@winehq.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/setup.h  |   2 +
 arch/x86/kernel/Makefile      |   1 +
 arch/x86/kernel/entry_64.S    |  79 ++++++++++++++++++-
 arch/x86/kernel/espfix_64.c   | 171 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/head64.c      |   1 +
 arch/x86/kernel/ldt.c         |  11 ---
 arch/x86/kernel/smpboot.c     |   5 ++
 arch/x86/mm/dump_pagetables.c |   2 +
 init/main.c                   |   4 +
 9 files changed, 264 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/kernel/espfix_64.c

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 9264f04a4c55..84b882eebdf9 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -57,6 +57,8 @@ extern void x86_ce4100_early_setup(void);
 static inline void x86_ce4100_early_setup(void) { }
 #endif
 
+extern void init_espfix_cpu(void);
+
 #ifndef _SETUP
 
 /*
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f4d96000d33a..1cc3789d99d9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
+obj-$(CONFIG_X86_64)	+= espfix_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c3628bf2..7cc01770bf21 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -58,6 +58,7 @@
 #include <asm/asm.h>
 #include <asm/context_tracking.h>
 #include <asm/smap.h>
+#include <asm/pgtable_types.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -1040,8 +1041,16 @@ restore_args:
 	RESTORE_ARGS 1,8,1
 
 irq_return:
+	/*
+	 * Are we returning to the LDT?  Note: in 64-bit mode
+	 * SS:RSP on the exception stack is always valid.
+	 */
+	testb $4,(SS-RIP)(%rsp)
+	jnz irq_return_ldt
+
+irq_return_iret:
 	INTERRUPT_RETURN
-	_ASM_EXTABLE(irq_return, bad_iret)
+	_ASM_EXTABLE(irq_return_iret, bad_iret)
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
@@ -1049,6 +1058,34 @@ ENTRY(native_iret)
 	_ASM_EXTABLE(native_iret, bad_iret)
 #endif
 
+irq_return_ldt:
+	pushq_cfi %rcx
+	larl (CS-RIP+8)(%rsp), %ecx
+	jnz 1f		/* Invalid segment - will #GP at IRET time */
+	testl $0x00200000, %ecx
+	jnz 1f		/* Returning to 64-bit mode */
+	larl (SS-RIP+8)(%rsp), %ecx
+	jnz 1f		/* Invalid segment - will #SS at IRET time */
+	testl $0x00400000, %ecx
+	jnz 1f		/* Not a 16-bit stack segment */
+	pushq_cfi %rsi
+	pushq_cfi %rdi
+	SWAPGS
+	movq PER_CPU_VAR(espfix_stack),%rdi
+	movl (RSP-RIP+3*8)(%rsp),%esi
+	xorw %si,%si
+	orq %rsi,%rdi
+	movq %rsp,%rsi
+	movl $8,%ecx
+	rep;movsq
+	leaq -(8*8)(%rdi),%rsp
+	SWAPGS
+	popq_cfi %rdi
+	popq_cfi %rsi
+1:
+	popq_cfi %rcx
+	jmp irq_return_iret
+
 	.section .fixup,"ax"
 bad_iret:
 	/*
@@ -1058,6 +1095,7 @@ bad_iret:
 	 * So pretend we completed the iret and took the #GPF in user mode.
 	 *
 	 * We are now running with the kernel GS after exception recovery.
+	 * Exception entry will have removed us from the espfix stack.
 	 * But error_entry expects us to have user GS to match the user %cs,
 	 * so swap back.
 	 */
@@ -1200,6 +1238,17 @@ apicinterrupt IRQ_WORK_VECTOR \
 	irq_work_interrupt smp_irq_work_interrupt
 #endif
 
+.macro espfix_adjust_stack
+	pushq_cfi %rdi
+	movq %rsp,%rdi
+	sarq $PGDIR_SHIFT,%rdi
+	cmpl $-2,%edi
+	jne 1f
+	call espfix_fix_stack
+1:
+	popq_cfi %rdi		/* Fix so we don't need this again */
+.endm
+
 /*
  * Exception entry points.
  */
@@ -1209,6 +1258,7 @@ ENTRY(\sym)
 	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	espfix_adjust_stack
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
@@ -1227,6 +1277,7 @@ ENTRY(\sym)
 	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	espfix_adjust_stack
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
@@ -1265,6 +1316,7 @@ ENTRY(\sym)
 	XCPT_FRAME
 	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	espfix_adjust_stack
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
@@ -1295,6 +1347,7 @@ ENTRY(\sym)
 	XCPT_FRAME
 	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	espfix_adjust_stack
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
@@ -1323,6 +1376,30 @@ zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
 
+	/*
+	 * Switch from the espfix stack to the proper stack: tricky stuff.
+	 * On the stack right now is 5 words of exception frame,
+	 * error code/oldeax, RDI, and the return value, so no additional
+	 * stack is available.
+	 *
+	 * We will always be using the user space GS on entry.
+	*/
+ENTRY(espfix_fix_stack)
+	SWAPGS
+	cld
+	movq PER_CPU_VAR(kernel_stack),%rdi
+	subq $8*8,%rdi
+	/* Use the real stack to hold these registers for now */
+	movq %rsi,-8(%rdi)
+	movq %rcx,-16(%rdi)
+	movq %rsp,%rsi
+	movl $8,%ecx
+	rep;movsq
+	leaq -(10*8)(%rdi),%rsp
+	popq %rcx
+	popq %rsi
+	SWAPGS
+	retq
 
 	/* Reload gs selector with exception handling */
 	/* edi:  new selector */
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
new file mode 100644
index 000000000000..ff8479628ff2
--- /dev/null
+++ b/arch/x86/kernel/espfix_64.c
@@ -0,0 +1,171 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *   Copyright 2014 Intel Corporation; author: H. Peter Anvin
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/gfp.h>
+#include <asm/pgtable.h>
+
+#define ESPFIX_STACK_SIZE	64
+#define ESPFIX_BASE_ADDR	(-2ULL << PGDIR_SHIFT)
+
+#if CONFIG_NR_CPUS >= (8 << 20)/ESPFIX_STACK_SIZE
+# error "Need more than one PGD for the ESPFIX hack"
+#endif
+
+#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+#define ESPFIX_PGD_FLAGS (__PAGE_KERNEL & ~_PAGE_DIRTY)
+#define ESPFIX_PUD_FLAGS (__PAGE_KERNEL & ~_PAGE_DIRTY)
+#define ESPFIX_PMD_FLAGS (__PAGE_KERNEL & ~_PAGE_DIRTY)
+#define ESPFIX_PTE_FLAGS __PAGE_KERNEL
+
+/* This contains the *bottom* address of the espfix stack */
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+
+/* Initialization mutex - should this be a spinlock? */
+static DEFINE_MUTEX(espfix_init_mutex);
+
+static __page_aligned_bss pud_t espfix_pud_page[PTRS_PER_PUD]
+	__aligned(PAGE_SIZE);
+
+/* This returns the bottom address of the espfix stack for a specific CPU */
+static inline unsigned long espfix_base_addr(int cpu)
+{
+	unsigned long addr = cpu * ESPFIX_STACK_SIZE;
+
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
+/*
+ * Check to see if the espfix stuff is already installed.
+ * We do this once before grabbing the lock and, if we have to,
+ * once after.
+ */
+static bool espfix_already_there(unsigned long addr)
+{
+	const pgd_t *pgd_p;
+	pgd_t pgd;
+	const pud_t *pud_p;
+	pud_t pud;
+	const pmd_t *pmd_p;
+	pmd_t pmd;
+	const pte_t *pte_p;
+	pte_t pte;
+	int n;
+
+	pgd_p = &init_level4_pgt[pgd_index(addr)];
+	pgd = ACCESS_ONCE(*pgd_p);
+	if (!pgd_present(pgd))
+		return false;
+
+	pud_p = &espfix_pud_page[pud_index(addr)];
+	for (n = 0; n < ESPFIX_PUD_CLONES; n++) {
+		pud = ACCESS_ONCE(pud_p[n]);
+		if (!pud_present(pud))
+			return false;
+	}
+
+	pmd_p = pmd_offset(&pud, addr);
+	for (n = 0; n < ESPFIX_PMD_CLONES; n++) {
+		pmd = ACCESS_ONCE(pmd_p[n]);
+		if (!pmd_present(pmd))
+			return false;
+	}
+
+	pte_p = pte_offset_kernel(&pmd, addr);
+	for (n = 0; n < ESPFIX_PTE_CLONES; n++) {
+		pte = ACCESS_ONCE(pte_p[n*PTE_STRIDE]);
+		if (!pte_present(pte))
+			return false;
+	}
+
+	return true;		/* All aliases present and accounted for */
+}
+
+void init_espfix_cpu(void)
+{
+	int cpu = smp_processor_id();
+	unsigned long addr;
+	pgd_t pgd, *pgd_p;
+	pud_t pud, *pud_p;
+	pmd_t pmd, *pmd_p;
+	pte_t pte, *pte_p;
+	int n;
+	void *stack_page;
+
+	cpu = smp_processor_id();
+	BUG_ON(cpu >= (8 << 20)/ESPFIX_STACK_SIZE);
+
+	/* We only have to do this once... */
+	if (likely(this_cpu_read(espfix_stack)))
+		return;		/* Already initialized */
+
+	addr = espfix_base_addr(cpu);
+
+	/* Did another CPU already set this up? */
+	if (likely(espfix_already_there(addr)))
+		goto done;
+
+	mutex_lock(&espfix_init_mutex);
+
+	if (unlikely(espfix_already_there(addr)))
+		goto unlock_done;
+
+	pgd_p = &init_level4_pgt[pgd_index(addr)];
+	pgd = *pgd_p;
+	if (!pgd_present(pgd)) {
+		/* This can only happen on the BSP */
+		pgd = __pgd(__pa(espfix_pud_page) |
+			    (ESPFIX_PGD_FLAGS & __supported_pte_mask));
+		set_pgd(pgd_p, pgd);
+	}
+
+	pud_p = &espfix_pud_page[pud_index(addr)];
+	pud = *pud_p;
+	if (!pud_present(pud)) {
+		pmd_p = (pmd_t *)__get_free_page(PGALLOC_GFP);
+		pud = __pud(__pa(pmd_p) |
+			    (ESPFIX_PUD_FLAGS & __supported_pte_mask));
+		for (n = 0; n < ESPFIX_PUD_CLONES; n++)
+			set_pud(&pud_p[n], pud);
+	}
+
+	pmd_p = pmd_offset(&pud, addr);
+	pmd = *pmd_p;
+	if (!pmd_present(pmd)) {
+		pte_p = (pte_t *)__get_free_page(PGALLOC_GFP);
+		pmd = __pmd(__pa(pte_p) |
+			    (ESPFIX_PMD_FLAGS & __supported_pte_mask));
+		for (n = 0; n < ESPFIX_PMD_CLONES; n++)
+			set_pmd(&pmd_p[n], pmd);
+	}
+
+	pte_p = pte_offset_kernel(&pmd, addr);
+	stack_page = (void *)__get_free_page(GFP_KERNEL);
+	pte = __pte(__pa(stack_page) |
+		    (ESPFIX_PTE_FLAGS & __supported_pte_mask));
+	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
+		set_pte(&pte_p[n*PTE_STRIDE], pte);
+
+unlock_done:
+	mutex_unlock(&espfix_init_mutex);
+done:
+	this_cpu_write(espfix_stack, addr);
+	printk(KERN_ERR "espfix: Initializing espfix for cpu %d, stack @ %p\n",
+		 cpu, (const void *)addr);
+}
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 85126ccbdf6b..dc2d8afcafe9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -32,6 +32,7 @@
  * Manage page tables very early on.
  */
 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
+extern pud_t espfix_pud_page[PTRS_PER_PUD];
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 static unsigned int __initdata next_early_pgt = 2;
 pmdval_t early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index af1d14a9ebda..ebc987398923 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -229,17 +229,6 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 		}
 	}
 
-	/*
-	 * On x86-64 we do not support 16-bit segments due to
-	 * IRET leaking the high bits of the kernel stack address.
-	 */
-#ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit) {
-		error = -EINVAL;
-		goto out_unlock;
-	}
-#endif
-
 	fill_ldt(&ldt, &ldt_info);
 	if (oldmode)
 		ldt.avl = 0;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 34826934d4a7..ff32efb14e33 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -244,6 +244,11 @@ static void notrace start_secondary(void *unused)
 	check_tsc_sync_target();
 
 	/*
+	 * Enable the espfix hack for this CPU
+	 */
+	init_espfix_cpu();
+
+	/*
 	 * We need to hold vector_lock so there the set of online cpus
 	 * does not change while we are assigning vectors to cpus.  Holding
 	 * this lock ensures we don't half assign or remove an irq from a cpu.
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 20621d753d5f..96bf767a05fc 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -327,6 +327,8 @@ void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd)
 	int i;
 	struct pg_state st = {};
 
+	st.to_dmesg = true;
+
 	if (pgd) {
 		start = pgd;
 		st.to_dmesg = true;
diff --git a/init/main.c b/init/main.c
index 9c7fd4c9249f..6cccf5524b3c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -648,6 +648,10 @@ asmlinkage void __init start_kernel(void)
 
 	ftrace_init();
 
+#ifdef CONFIG_X86_64
+	init_espfix_cpu();
+#endif
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
-- 
1.9.0

