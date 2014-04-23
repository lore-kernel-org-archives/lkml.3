Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaDWBRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:17:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:59745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbaDWBR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:17:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,908,1389772800"; 
   d="txt'?scan'208";a="525779569"
Message-ID: <535714A1.9080502@linux.intel.com>
Date: Tue, 22 Apr 2014 18:17:21 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
Content-Type: multipart/mixed;
 boundary="------------080703080906040401060702"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080703080906040401060702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Another spin of the prototype.  This one avoids the espfix for anything
but #GP, and avoids save/restore/saving registers... one can wonder,
though, how much that actually matters in practice.

It still does redundant SWAPGS on the slow path.  I'm not sure I
personally care enough to optimize that, as it means some fairly
significant restructuring of some of the code paths.  Some of that
restructuring might actually be beneficial, but still...

	-hpa


--------------080703080906040401060702
Content-Type: text/plain; charset=UTF-8;
 name="diff.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff.txt"

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 9264f04a4c55..cea5b9b517f2 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -57,6 +57,8 @@ extern void x86_ce4100_early_setup(void);
 static inline void x86_ce4100_early_setup(void) { }
 #endif
 
+extern void init_espfix_this_cpu(void);
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
index 1e96c3628bf2..7f71c97f59c0 100644
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
@@ -1278,6 +1316,62 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
+/*
+ * Same as errorentry, except use for #GP in case we take the exception
+ * while on the espfix stack.  All other exceptions that are possible while
+ * on the espfix stack use IST, but that is not really practical for #GP
+ * for nesting reasons.
+ */
+.macro errorentry_espfix sym do_sym
+ENTRY(\sym)
+	XCPT_FRAME
+	ASM_CLAC
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	/* Check if we are on the espfix stack */
+	pushq_cfi %rdi
+	pushq_cfi %rsi
+	movq %rsp,%rdi
+	sarq $PGDIR_SHIFT,%rdi
+	cmpl $-2,%edi			/* Are we on the espfix stack? */
+	CFI_REMEMBER_STATE
+	je 1f
+2:
+	subq $RSI-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET RSI-R15
+	call error_entry_rdi_rsi_saved
+	DEFAULT_FRAME 0
+	movq %rsp,%rdi			/* pt_regs pointer */
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
+	call \do_sym
+	jmp error_exit			/* %ebx: no swapgs flag */
+1:
+	CFI_RESTORE_STATE
+	SWAPGS
+	movq PER_CPU_VAR(kernel_stack),%rdi
+	SWAPGS
+	/* Copy data from the espfix stack to the real stack */
+	movq %rsi,-64(%rdi)		/* Saved value of %rsi already */
+	movq 8(%rsp),%rsi
+	movq %rsi,-56(%rdi)
+	movq 16(%rsp),%rsi
+	movq %rsi,-48(%rdi)
+	movq 24(%rsp),%rsi
+	movq %rsi,-40(%rdi)
+	movq 32(%rsp),%rsi
+	movq %rsi,-32(%rdi)
+	movq 40(%rsp),%rsi
+	movq %rsi,-24(%rdi)
+	movq 48(%rsp),%rsi
+	movq %rsi,-16(%rdi)
+	movq 56(%rsp),%rsi
+	movq %rsi,-8(%rdi)
+	leaq -64(%rdi),%rsp
+	jmp 2b
+	CFI_ENDPROC
+END(\sym)
+.endm
+
 #ifdef CONFIG_TRACING
 .macro trace_errorentry sym do_sym
 errorentry trace(\sym) trace(\do_sym)
@@ -1323,7 +1417,6 @@ zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
 
-
 	/* Reload gs selector with exception handling */
 	/* edi:  new selector */
 ENTRY(native_load_gs_index)
@@ -1490,7 +1583,7 @@ zeroentry xen_debug do_debug
 zeroentry xen_int3 do_int3
 errorentry xen_stack_segment do_stack_segment
 #endif
-errorentry general_protection do_general_protection
+errorentry_espfix general_protection do_general_protection
 trace_errorentry page_fault do_page_fault
 #ifdef CONFIG_KVM_GUEST
 errorentry async_page_fault do_async_page_fault
@@ -1567,9 +1660,10 @@ ENTRY(error_entry)
 	XCPT_FRAME
 	CFI_ADJUST_CFA_OFFSET 15*8
 	/* oldrax contains error code */
-	cld
 	movq_cfi rdi, RDI+8
 	movq_cfi rsi, RSI+8
+error_entry_rdi_rsi_saved:
+	cld
 	movq_cfi rdx, RDX+8
 	movq_cfi rcx, RCX+8
 	movq_cfi rax, RAX+8
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
new file mode 100644
index 000000000000..05567d706f92
--- /dev/null
+++ b/arch/x86/kernel/espfix_64.c
@@ -0,0 +1,136 @@
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
+#define ESPFIX_STACK_SIZE	64UL
+#define ESPFIX_STACKS_PER_PAGE	(PAGE_SIZE/ESPFIX_STACK_SIZE)
+
+#define ESPFIX_MAX_CPUS (ESPFIX_STACKS_PER_PAGE << (PGDIR_SHIFT-PAGE_SHIFT-16))
+#if CONFIG_NR_CPUS > ESPFIX_MAX_CPUS
+# error "Need more than one PGD for the ESPFIX hack"
+#endif
+
+#define ESPFIX_BASE_ADDR	(-2UL << PGDIR_SHIFT)
+
+#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+
+/* This contains the *bottom* address of the espfix stack */
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+
+/* Initialization mutex - should this be a spinlock? */
+static DEFINE_MUTEX(espfix_init_mutex);
+
+/* Page allocation bitmap - each page serves ESPFIX_STACKS_PER_PAGE CPUs */
+#define ESPFIX_MAX_PAGES  DIV_ROUND_UP(CONFIG_NR_CPUS, ESPFIX_STACKS_PER_PAGE)
+#define ESPFIX_MAP_SIZE   DIV_ROUND_UP(ESPFIX_MAX_PAGES, BITS_PER_LONG)
+static unsigned long espfix_page_alloc_map[ESPFIX_MAP_SIZE];
+
+static __page_aligned_bss pud_t espfix_pud_page[PTRS_PER_PUD]
+	__aligned(PAGE_SIZE);
+
+/*
+ * This returns the bottom address of the espfix stack for a specific CPU.
+ * The math allows for a non-power-of-two ESPFIX_STACK_SIZE, in which case
+ * we have to account for some amount of padding at the end of each page.
+ */
+static inline unsigned long espfix_base_addr(unsigned int cpu)
+{
+	unsigned long page, addr;
+
+	page = (cpu / ESPFIX_STACKS_PER_PAGE) << PAGE_SHIFT;
+	addr = page + (cpu % ESPFIX_STACKS_PER_PAGE) * ESPFIX_STACK_SIZE;
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
+void init_espfix_this_cpu(void)
+{
+	unsigned int cpu, page;
+	unsigned long addr;
+	pgd_t pgd, *pgd_p;
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
+	if (likely(test_bit(page, espfix_page_alloc_map)))
+		goto done;
+
+	mutex_lock(&espfix_init_mutex);
+
+	/* Did we race on the lock? */
+	if (unlikely(test_bit(page, espfix_page_alloc_map)))
+		goto unlock_done;
+
+	ptemask = __supported_pte_mask;
+
+	pgd_p = &init_level4_pgt[pgd_index(addr)];
+	pgd = *pgd_p;
+	if (!pgd_present(pgd)) {
+		/* This can only happen on the BSP */
+		pgd = __pgd(__pa_symbol(espfix_pud_page) |
+			    (_KERNPG_TABLE & ptemask));
+		set_pgd(pgd_p, pgd);
+	}
+
+	pud_p = &espfix_pud_page[pud_index(addr)];
+	pud = *pud_p;
+	if (!pud_present(pud)) {
+		pmd_p = (pmd_t *)__get_free_page(PGALLOC_GFP);
+		pud = __pud(__pa(pmd_p) | (_KERNPG_TABLE & ptemask));
+		for (n = 0; n < ESPFIX_PUD_CLONES; n++)
+			set_pud(&pud_p[n], pud);
+	}
+
+	pmd_p = pmd_offset(&pud, addr);
+	pmd = *pmd_p;
+	if (!pmd_present(pmd)) {
+		pte_p = (pte_t *)__get_free_page(PGALLOC_GFP);
+		pmd = __pmd(__pa(pte_p) | (_KERNPG_TABLE & ptemask));
+		for (n = 0; n < ESPFIX_PMD_CLONES; n++)
+			set_pmd(&pmd_p[n], pmd);
+	}
+
+	pte_p = pte_offset_kernel(&pmd, addr);
+	stack_page = (void *)__get_free_page(GFP_KERNEL);
+	pte = __pte(__pa(stack_page) | (__PAGE_KERNEL & ptemask));
+	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
+		set_pte(&pte_p[n*PTE_STRIDE], pte);
+
+	/* Job is done for this CPU and any CPU which shares this page */
+	set_bit(page, espfix_page_alloc_map);
+
+unlock_done:
+	mutex_unlock(&espfix_init_mutex);
+done:
+	this_cpu_write(espfix_stack, addr);
+}
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
index 34826934d4a7..7956aad1a710 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -244,6 +244,11 @@ static void notrace start_secondary(void *unused)
 	check_tsc_sync_target();
 
 	/*
+	 * Enable the espfix hack for this CPU
+	 */
+	init_espfix_this_cpu();
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
index 9c7fd4c9249f..6230d4b7ce1b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -617,6 +617,10 @@ asmlinkage void __init start_kernel(void)
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
+#ifdef CONFIG_X86_64
+	/* Should be run before the first non-init thread is created */
+	init_espfix_this_cpu();
+#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);

--------------080703080906040401060702--
