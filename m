Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaJXIZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:25:12 -0400
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:13184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750964AbaJXIY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:24:57 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 03/29] nios2: Kernel booting and initialization
Date: Fri, 24 Oct 2014 16:24:05 +0800
Message-ID: <1414139071-3818-4-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(84676001)(97736003)(95666004)(77096002)(77156001)(76482002)(76176999)(44976005)(50986999)(6806004)(120916001)(21056001)(99396003)(85306004)(50466002)(42186005)(48376002)(85852003)(89996001)(15975445006)(19580395003)(15202345003)(19580405001)(68736004)(88136002)(31966008)(87936001)(102836001)(87286001)(92726001)(92566001)(2201001)(33646002)(104166001)(107046002)(62966002)(106466001)(36756003)(4396001)(64706001)(47776003)(50226001)(80022003)(86362001)(46102003)(93916002)(575784001)(105596002)(229853001)(20776003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB215;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB215;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB081;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the kernel booting and the initial setup code.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/entry.h | 120 +++++++++++++++++++++++
 arch/nios2/include/asm/setup.h |  38 +++++++
 arch/nios2/kernel/head.S       | 175 +++++++++++++++++++++++++++++++++
 arch/nios2/kernel/setup.c      | 218 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 551 insertions(+)
 create mode 100644 arch/nios2/include/asm/entry.h
 create mode 100644 arch/nios2/include/asm/setup.h
 create mode 100644 arch/nios2/kernel/head.S
 create mode 100644 arch/nios2/kernel/setup.c

diff --git a/arch/nios2/include/asm/entry.h b/arch/nios2/include/asm/entry.h
new file mode 100644
index 0000000..cf37f55
--- /dev/null
+++ b/arch/nios2/include/asm/entry.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
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
index 0000000..a3e05a7
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
index 0000000..372ce4a
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
+	/* Initialize all cache lines within the instruction cache */
+	movia	r1, NIOS2_ICACHE_SIZE
+	movui	r2, NIOS2_ICACHE_LINE_SIZE
+
+icache_init:
+	initi	r1
+	sub	r1, r1, r2
+	bgt	r1, r0, icache_init
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
+	 * After the instruction cache is initialized, the data cache must
+	 * also be initialized.
+	 */
+	movia	r1, NIOS2_DCACHE_SIZE
+	movui	r2, NIOS2_DCACHE_LINE_SIZE
+
+dcache_init:
+	initd	0(r1)
+	sub	r1, r1, r2
+	bgt	r1, r0, dcache_init
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
index 0000000..cb3121f
--- /dev/null
+++ b/arch/nios2/kernel/setup.c
@@ -0,0 +1,218 @@
+/*
+ * Nios2-specific parts of system setup
+ *
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ * Copyright (C) 2001 Vic Phillips <vic@microtronix.com>
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
+	if (start == addr) {
+		/* The CPU exception address already points to the handler. */
+		return;
+	}
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
+		"flushp\n"
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
+		"	flushp\n"
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
+#if defined(CONFIG_NIOS2_PASS_CMDLINE)
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
+#ifdef CONFIG_NIOS2_CMDLINE_IGNORE_DTB
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
+	memory_end = (unsigned long) CONFIG_NIOS2_MEM_BASE + memory_size;
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
+	min_low_pfn = PFN_UP(memory_start);
+	max_low_pfn = PFN_DOWN(memory_end);
+	max_mapnr = max_low_pfn;
+
+	/*
+	 * give all the memory to the bootmap allocator,  tell it to put the
+	 * boot mem_map at the start of memory
+	 */
+	pr_debug("init_bootmem_node(?,%#lx, %#x, %#lx)\n",
+		min_low_pfn, PFN_DOWN(PHYS_OFFSET), max_low_pfn);
+	bootmap_size = init_bootmem_node(NODE_DATA(0),
+					min_low_pfn, PFN_DOWN(PHYS_OFFSET),
+					max_low_pfn);
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
1.8.2.1

