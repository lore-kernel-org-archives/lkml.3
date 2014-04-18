Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaDRSVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:21:31 -0400
Received: from [207.46.163.241] ([207.46.163.241]:39625 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751139AbaDRSVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:21:25 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 03/28] nios2: Kernel booting and initialization
Date: Sat, 19 Apr 2014 02:19:06 +0800
Message-ID: <1397845149-3141-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(22564002)(46102001)(2009001)(50226001)(99396002)(92726001)(19580395003)(31966008)(48376002)(50986999)(76176999)(92566001)(16796002)(74662001)(76482001)(97736001)(2201001)(74502001)(77156001)(86362001)(575784001)(42186004)(4396001)(36756003)(93916002)(62966002)(81542001)(81342001)(84676001)(6806004)(83322001)(19580405001)(33646001)(80022001)(80976001)(50466002)(44976005)(87286001)(85852003)(87936001)(79102001)(89996001)(83072002)(88136002)(47776003)(77982001)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB017;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E26DF104.E0DEDF85.6CCD5271.2FB6359.20A4C;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the kernel booting and the initial setup code.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/entry.h | 152 +++++++++++++++++++++++++++++
 arch/nios2/include/asm/setup.h |  38 ++++++++
 arch/nios2/kernel/head.S       | 175 +++++++++++++++++++++++++++++++++
 arch/nios2/kernel/setup.c      | 214 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 579 insertions(+)
 create mode 100644 arch/nios2/include/asm/entry.h
 create mode 100644 arch/nios2/include/asm/setup.h
 create mode 100644 arch/nios2/kernel/head.S
 create mode 100644 arch/nios2/kernel/setup.c

diff --git a/arch/nios2/include/asm/entry.h b/arch/nios2/include/asm/entry.h
new file mode 100644
index 0000000..8b7cddd086b02f1a404198244ca5a21178a0aadc
--- /dev/null
+++ b/arch/nios2/include/asm/entry.h
@@ -0,0 +1,152 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * Based on m68knommu asm/entry.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_ENTRY_H
+#define _ASM_NIOS2_ENTRY_H
+
+#ifdef __ASSEMBLY__
+
+#include <asm/processor.h>
+#include <asm/registers.h>
+#include <asm/asm-offsets.h>
+
+/*
+ * Stack layout in 'ret_from_exception':
+ *
+ * This allows access to the syscall arguments in registers r4-r8
+ *
+ *	 0(sp) - r8
+ *	 4(sp) - r9
+ *	 8(sp) - r10
+ *	 C(sp) - r11
+ *	10(sp) - r12
+ *	14(sp) - r13
+ *	18(sp) - r14
+ *	1C(sp) - r15
+ *	20(sp) - r1
+ *	24(sp) - r2
+ *	28(sp) - r3
+ *	2C(sp) - r4
+ *	30(sp) - r5
+ *	34(sp) - r6
+ *	38(sp) - r7
+ *	3C(sp) - orig_r2
+ *	40(sp) - ra
+ *	44(sp) - fp
+ *	48(sp) - sp
+ *	4C(sp) - gp
+ *	50(sp) - estatus
+ *	54(sp) - status_extension (NOMMU only)
+ *	58(sp) - ea
+ */
+
+/*
+ * Standard Nios2 interrupt entry and exit macros.
+ * Must be called with interrupts disabled.
+ */
+.macro SAVE_ALL
+	rdctl	r24, estatus
+	andi	r24, r24, ESTATUS_EU
+	beq	r24, r0, 1f /* In supervisor mode, already on kernel stack */
+
+	movia	r24, _current_thread	/* Switch to current kernel stack */
+	ldw	r24, 0(r24)		/* using the thread_info */
+	addi	r24, r24, THREAD_SIZE-PT_REGS_SIZE
+	stw	sp, PT_SP(r24)		/* Save user stack before changing */
+	mov	sp, r24
+	br	2f
+
+1 :	mov	r24, sp
+	addi	sp, sp, -PT_REGS_SIZE	/* Backup the kernel stack pointer */
+	stw	r24, PT_SP(sp)
+2 :	stw	r1, PT_R1(sp)
+	stw	r2, PT_R2(sp)
+	stw	r3, PT_R3(sp)
+	stw	r4, PT_R4(sp)
+	stw	r5, PT_R5(sp)
+	stw	r6, PT_R6(sp)
+	stw	r7, PT_R7(sp)
+	stw	r8, PT_R8(sp)
+	stw	r9, PT_R9(sp)
+	stw	r10, PT_R10(sp)
+	stw	r11, PT_R11(sp)
+	stw	r12, PT_R12(sp)
+	stw	r13, PT_R13(sp)
+	stw	r14, PT_R14(sp)
+	stw	r15, PT_R15(sp)
+	stw	r2, PT_ORIG_R2(sp)
+	stw	r7, PT_ORIG_R7(sp)
+
+	stw	ra, PT_RA(sp)
+	stw	fp, PT_FP(sp)
+	stw	gp, PT_GP(sp)
+	rdctl	r24, estatus
+	stw	r24, PT_ESTATUS(sp)
+	stw	ea, PT_EA(sp)
+.endm
+
+.macro RESTORE_ALL
+	ldw	r1, PT_R1(sp)		/* Restore registers */
+	ldw	r2, PT_R2(sp)
+	ldw	r3, PT_R3(sp)
+	ldw	r4, PT_R4(sp)
+	ldw	r5, PT_R5(sp)
+	ldw	r6, PT_R6(sp)
+	ldw	r7, PT_R7(sp)
+	ldw	r8, PT_R8(sp)
+	ldw	r9, PT_R9(sp)
+	ldw	r10, PT_R10(sp)
+	ldw	r11, PT_R11(sp)
+	ldw	r12, PT_R12(sp)
+	ldw	r13, PT_R13(sp)
+	ldw	r14, PT_R14(sp)
+	ldw	r15, PT_R15(sp)
+	ldw	ra, PT_RA(sp)
+	ldw	fp, PT_FP(sp)
+	ldw	gp, PT_GP(sp)
+	ldw	r24, PT_ESTATUS(sp)
+	wrctl	estatus, r24
+	ldw	ea, PT_EA(sp)
+	ldw	sp, PT_SP(sp)		/* Restore sp last */
+.endm
+
+.macro	SAVE_SWITCH_STACK
+	addi	sp, sp, -SWITCH_STACK_SIZE
+	stw	r16, SW_R16(sp)
+	stw	r17, SW_R17(sp)
+	stw	r18, SW_R18(sp)
+	stw	r19, SW_R19(sp)
+	stw	r20, SW_R20(sp)
+	stw	r21, SW_R21(sp)
+	stw	r22, SW_R22(sp)
+	stw	r23, SW_R23(sp)
+	stw	fp, SW_FP(sp)
+	stw	gp, SW_GP(sp)
+	stw	ra, SW_RA(sp)
+.endm
+
+.macro	RESTORE_SWITCH_STACK
+	ldw	r16, SW_R16(sp)
+	ldw	r17, SW_R17(sp)
+	ldw	r18, SW_R18(sp)
+	ldw	r19, SW_R19(sp)
+	ldw	r20, SW_R20(sp)
+	ldw	r21, SW_R21(sp)
+	ldw	r22, SW_R22(sp)
+	ldw	r23, SW_R23(sp)
+	ldw	fp, SW_FP(sp)
+	ldw	gp, SW_GP(sp)
+	ldw	ra, SW_RA(sp)
+	addi	sp, sp, SWITCH_STACK_SIZE
+.endm
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_NIOS2_ENTRY_H */
diff --git a/arch/nios2/include/asm/setup.h b/arch/nios2/include/asm/setup.h
new file mode 100644
index 0000000..a3e05a7f977a5de50439a1595146a280577ba015
--- /dev/null
+++ b/arch/nios2/include/asm/setup.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef _ASM_NIOS2_SETUP_H
+#define _ASM_NIOS2_SETUP_H
+
+#include <asm-generic/setup.h>
+
+#ifndef __ASSEMBLY__
+# ifdef __KERNEL__
+
+extern char exception_handler_hook[];
+extern char fast_handler[];
+extern char fast_handler_end[];
+
+extern void pagetable_init(void);
+
+extern void setup_early_printk(void);
+
+# endif/* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_NIOS2_SETUP_H */
diff --git a/arch/nios2/kernel/head.S b/arch/nios2/kernel/head.S
new file mode 100644
index 0000000..cff8fa4f610afe4518ed470aecd97169af0272d1
--- /dev/null
+++ b/arch/nios2/kernel/head.S
@@ -0,0 +1,175 @@
+/*
+ * Copyright (C) 2009 Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ * Copyright (C) 2001 Vic Phillips, Microtronix Datacom Ltd.
+ *
+ * Based on head.S for Altera's Excalibur development board with nios processor
+ *
+ * Based on the following from the Excalibur sdk distribution:
+ *	NA_MemoryMap.s, NR_JumpToStart.s, NR_Setup.s, NR_CWPManager.s
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+#include <asm/processor.h>
+#include <asm/cache.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+#include <asm/asm-macros.h>
+
+/*
+ * ZERO_PAGE is a special page that is used for zero-initialized
+ * data and COW.
+ */
+.data
+.global empty_zero_page
+.align 12
+empty_zero_page:
+	.space	PAGE_SIZE
+
+/*
+ * This global variable is used as an extension to the nios'
+ * STATUS register to emulate a user/supervisor mode.
+ */
+	.data
+	.align	2
+	.set noat
+
+	.global _current_thread
+_current_thread:
+	.long	0
+/*
+ * Input(s): passed from u-boot
+ *   r4 - Optional pointer to a board information structure.
+ *   r5 - Optional pointer to the physical starting address of the init RAM
+ *        disk.
+ *   r6 - Optional pointer to the physical ending address of the init RAM
+ *        disk.
+ *   r7 - Optional pointer to the physical starting address of any kernel
+ *        command-line parameters.
+ */
+
+/*
+ * First executable code - detected and jumped to by the ROM bootstrap
+ * if the code resides in flash (looks for "Nios" at offset 0x0c from
+ * the potential executable image).
+ */
+	__HEAD
+ENTRY(_start)
+	wrctl	status, r0		/* Disable interrupts */
+
+	/* Flush all cache lines within the instruction cache */
+	movia	r1, NIOS2_ICACHE_SIZE
+	movui	r2, NIOS2_ICACHE_LINE_SIZE
+
+text_flush:
+	flushi	r1
+	sub	r1, r1, r2
+	bgt	r1, r0, text_flush
+	br	1f
+
+	/*
+	 * This is the default location for the exception handler. Code in jump
+	 * to our handler
+	 */
+ENTRY(exception_handler_hook)
+	movia	r24, inthandler
+	jmp	r24
+
+ENTRY(fast_handler)
+	nextpc et
+helper:
+	stw	r3, r3save - helper(et)
+
+	rdctl	r3 , pteaddr
+	srli	r3, r3, 12
+	slli	r3, r3, 2
+	movia	et, pgd_current
+
+	ldw	et, 0(et)
+	add	r3, et, r3
+	ldw	et, 0(r3)
+
+	rdctl	r3, pteaddr
+	andi	r3, r3, 0xfff
+	add	et, r3, et
+	ldw	et, 0(et)
+	wrctl	tlbacc, et
+	nextpc	et
+helper2:
+	ldw	r3, r3save - helper2(et)
+	subi	ea, ea, 4
+	eret
+r3save:
+	.word 0x0
+ENTRY(fast_handler_end)
+
+1:
+	/*
+	 * After flushing the instruction cache, we must flush the data
+	 * cache.
+	 */
+	movia	r1, NIOS2_DCACHE_SIZE
+	movui	r2, NIOS2_DCACHE_LINE_SIZE
+
+data_flush:
+	flushd	0(r1)
+	sub	r1, r1, r2
+	bgt	r1, r0, data_flush
+
+	nextpc	r1			/* Find out where we are */
+chkadr:
+	movia	r2, chkadr
+	beq	r1, r2,finish_move	/* We are running in RAM done */
+	addi	r1, r1,(_start - chkadr)	/* Source */
+	movia	r2, _start		/* Destination */
+	movia	r3, __bss_start		/* End of copy */
+
+loop_move:				/* r1: src, r2: dest, r3: last dest */
+	ldw	r8, 0(r1)		/* load a word from [r1] */
+	stw	r8, 0(r2)		/* store a word to dest [r2] */
+	flushd	0(r2)			/* Flush cache for safety */
+	addi 	r1, r1, 4		/* inc the src addr */
+	addi	r2, r2, 4		/* inc the dest addr */
+	blt	r2, r3, loop_move
+
+	movia	r1, finish_move		/* VMA(_start)->l1 */
+	jmp	r1			/* jmp to _start */
+
+finish_move:
+
+	/* Mask off all possible interrupts */
+	wrctl	ienable, r0
+
+	/* Clear .bss */
+	movia	r2, __bss_start
+	movia	r1, __bss_stop
+1:
+	stb	r0, 0(r2)
+	addi	r2, r2, 1
+	bne	r1, r2, 1b
+
+	movia	r1, init_thread_union	/* set stack at top of the task union */
+	addi	sp, r1, THREAD_SIZE
+	movia	r2, _current_thread	/* Remember current thread */
+	stw	r1, 0(r2)
+
+	movia	r1, nios2_boot_init	/* save args r4-r7 passed from u-boot */
+	callr	r1
+
+	movia	r1, start_kernel	/* call start_kernel as a subroutine */
+	callr	r1
+
+	/* If we return from start_kernel, break to the oci debugger and
+	 * buggered we are.
+	 */
+	break
+
+	/* End of startup code */
+.set at
diff --git a/arch/nios2/kernel/setup.c b/arch/nios2/kernel/setup.c
new file mode 100644
index 0000000..549f391baa75b6dc759e54d77facd929b29cfabb
--- /dev/null
+++ b/arch/nios2/kernel/setup.c
@@ -0,0 +1,214 @@
+/*
+ * Nios2-specific parts of system setup
+ *
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ * Copyright (C) 2001 Vic Phillips <vic@microtronix.com>
+ *
+ * based on kernel/setup.c from m68knommu
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/console.h>
+#include <linux/bootmem.h>
+#include <linux/initrd.h>
+#include <linux/of_fdt.h>
+
+#include <asm/mmu_context.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/prom.h>
+#include <asm/cpuinfo.h>
+
+unsigned long memory_start;
+EXPORT_SYMBOL(memory_start);
+
+unsigned long memory_end;
+EXPORT_SYMBOL(memory_end);
+
+unsigned long memory_size;
+
+/*				r1  r2  r3  r4  r5  r6  r7  r8  r9 r10 r11*/
+/*				r12 r13 r14 r15 or2 ra  fp  sp  gp es  ste  ea*/
+static struct pt_regs fake_regs = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0,
+					0};
+
+/* Copy a short hook instruction sequence to the exception address */
+static inline void copy_exception_handler(unsigned int addr)
+{
+	unsigned int start = (unsigned int) exception_handler_hook;
+	volatile unsigned int tmp = 0;
+
+	__asm__ __volatile__ (
+		"ldw	%2,0(%0)\n"
+		"stw	%2,0(%1)\n"
+		"ldw	%2,4(%0)\n"
+		"stw	%2,4(%1)\n"
+		"ldw	%2,8(%0)\n"
+		"stw	%2,8(%1)\n"
+		"flushd	0(%1)\n"
+		"flushd	4(%1)\n"
+		"flushd	8(%1)\n"
+		"flushi %1\n"
+		"addi	%1,%1,4\n"
+		"flushi %1\n"
+		"addi	%1,%1,4\n"
+		"flushi %1\n"
+		: /* no output registers */
+		: "r" (start), "r" (addr), "r" (tmp)
+		: "memory"
+	);
+}
+
+/* Copy the fast TLB miss handler */
+static inline void copy_fast_tlb_miss_handler(unsigned int addr)
+{
+	unsigned int start = (unsigned int) fast_handler;
+	unsigned int end = (unsigned int) fast_handler_end;
+	volatile unsigned int tmp = 0;
+
+	__asm__ __volatile__ (
+		"1:\n"
+		"	ldw	%3,0(%0)\n"
+		"	stw	%3,0(%1)\n"
+		"	flushd	0(%1)\n"
+		"	flushi	%1\n"
+		"	addi	%0,%0,4\n"
+		"	addi	%1,%1,4\n"
+		"	bne	%0,%2,1b\n"
+		: /* no output registers */
+		: "r" (start), "r" (addr), "r" (end), "r" (tmp)
+		: "memory"
+	);
+}
+
+/*
+ * save args passed from u-boot, called from head.S
+ *
+ * @r4: NIOS magic
+ * @r5: initrd start
+ * @r6: initrd end or fdt
+ * @r7: kernel command line
+ */
+asmlinkage void __init nios2_boot_init(unsigned r4, unsigned r5, unsigned r6,
+				       unsigned r7)
+{
+	unsigned dtb_passed = 0;
+	char cmdline_passed[COMMAND_LINE_SIZE] = { 0, };
+
+#if defined(CONFIG_PASS_CMDLINE)
+	if (r4 == 0x534f494e) { /* r4 is magic NIOS */
+#if defined(CONFIG_BLK_DEV_INITRD)
+		if (r5) { /* initramfs */
+			initrd_start = r5;
+			initrd_end = r6;
+		}
+#endif /* CONFIG_BLK_DEV_INITRD */
+		dtb_passed = r6;
+
+		if (r7)
+			strncpy(cmdline_passed, (char *)r7, COMMAND_LINE_SIZE);
+	}
+#endif
+
+	early_init_devtree((void *)dtb_passed);
+
+#ifndef CONFIG_CMDLINE_FORCE
+	if (cmdline_passed[0])
+		strncpy(boot_command_line, cmdline_passed, COMMAND_LINE_SIZE);
+#ifdef CONFIG_CMDLINE_IGNORE_DTB
+	else
+		strncpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+#endif
+#endif
+}
+
+void __init setup_arch(char **cmdline_p)
+{
+	int bootmap_size;
+
+	console_verbose();
+
+	memory_start = PAGE_ALIGN((unsigned long)__pa(_end));
+	memory_end = (unsigned long) CONFIG_MEM_BASE + memory_size;
+
+	init_mm.start_code = (unsigned long) _stext;
+	init_mm.end_code = (unsigned long) _etext;
+	init_mm.end_data = (unsigned long) _edata;
+	init_mm.brk = (unsigned long) _end;
+	init_task.thread.kregs = &fake_regs;
+
+	/* Keep a copy of command line */
+	*cmdline_p = boot_command_line;
+
+	/*
+	 * give all the memory to the bootmap allocator,  tell it to put the
+	 * boot mem_map at the start of memory
+	 */
+	pr_debug("init_bootmem_node(?,%#lx, %#x, %#lx)\n",
+		PFN_UP(memory_start), PFN_DOWN(PHYS_OFFSET),
+		PFN_DOWN(memory_end));
+	bootmap_size = init_bootmem_node(NODE_DATA(0),
+					 PFN_UP(memory_start),
+					 PFN_DOWN(PHYS_OFFSET),
+					 PFN_DOWN(memory_end));
+
+	/*
+	 * free the usable memory,  we have to make sure we do not free
+	 * the bootmem bitmap so we then reserve it after freeing it :-)
+	 */
+	pr_debug("free_bootmem(%#lx, %#lx)\n",
+		memory_start, memory_end - memory_start);
+	free_bootmem(memory_start, memory_end - memory_start);
+
+	/*
+	 * Reserve the bootmem bitmap itself as well. We do this in two
+	 * steps (first step was init_bootmem()) because this catches
+	 * the (very unlikely) case of us accidentally initializing the
+	 * bootmem allocator with an invalid RAM area.
+	 *
+	 * Arguments are start, size
+	 */
+	pr_debug("reserve_bootmem(%#lx, %#x)\n", memory_start, bootmap_size);
+	reserve_bootmem(memory_start, bootmap_size, BOOTMEM_DEFAULT);
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (initrd_start) {
+		reserve_bootmem(virt_to_phys((void *)initrd_start),
+				initrd_end - initrd_start, BOOTMEM_DEFAULT);
+	}
+#endif /* CONFIG_BLK_DEV_INITRD */
+
+	unflatten_and_copy_device_tree();
+
+	setup_cpuinfo();
+
+	copy_exception_handler(cpuinfo.exception_addr);
+
+	mmu_init();
+
+	copy_fast_tlb_miss_handler(cpuinfo.fast_tlb_miss_exc_addr);
+
+	/*
+	 * Initialize MMU context handling here because data from cpuinfo is
+	 * needed for this.
+	 */
+	mmu_context_init();
+
+	/*
+	 * get kmalloc into gear
+	 */
+	paging_init();
+
+#if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+}
-- 
1.8.3.2

