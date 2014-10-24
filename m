Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaJXIhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:37:05 -0400
Received: from mail-bl2on0100.outbound.protection.outlook.com ([65.55.169.100]:54592
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755723AbaJXIY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:24:59 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 04/29] nios2: Exception handling
Date: Fri, 24 Oct 2014 16:24:06 +0800
Message-ID: <1414139071-3818-5-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(19580405001)(62966002)(229853001)(48376002)(80022003)(46102003)(97736003)(44976005)(85852003)(106466001)(31966008)(76176999)(85306004)(50466002)(76482002)(89996001)(93916002)(77096002)(107046002)(50226001)(21056001)(99396003)(6806004)(575784001)(4396001)(120916001)(42186005)(19580395003)(92566001)(88136002)(2201001)(102836001)(87286001)(95666004)(105596002)(68736004)(64706001)(36756003)(92726001)(33646002)(20776003)(50986999)(84676001)(77156001)(104166001)(47776003)(87936001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1PR03MB598;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CH1PR03MB598;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the exception entry code (kernel/entry.S) and
misaligned exception.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/kernel/entry.S      | 559 +++++++++++++++++++++++++++++++++++++++++
 arch/nios2/kernel/misaligned.c | 255 +++++++++++++++++++
 2 files changed, 814 insertions(+)
 create mode 100644 arch/nios2/kernel/entry.S
 create mode 100644 arch/nios2/kernel/misaligned.c

diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
new file mode 100644
index 0000000..29c7aec
--- /dev/null
+++ b/arch/nios2/kernel/entry.S
@@ -0,0 +1,559 @@
+/*
+ * linux/arch/nios2/kernel/entry.S
+ *
+ * Copyright (C) 2013-2014  Altera Corporation
+ * Copyright (C) 2009, Wind River Systems Inc
+ *
+ * Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * Based on:
+ *
+ * linux/arch/nios2/kernel/entry.S
+ *
+ *  Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1998  D. Jeff Dionne <jeff@lineo.ca>,
+ *                      Kenneth Albanowski <kjahds@kjahds.com>,
+ *  Copyright (C) 2000  Lineo Inc. (www.lineo.com)
+ *  Copyright (C) 2004  Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Linux/m68k support by Hamish Macdonald
+ *
+ * 68060 fixes by Jesper Skov
+ * ColdFire support by Greg Ungerer (gerg@snapgear.com)
+ * 5307 fixes by David W. Miller
+ * linux 2.4 support David McCullough <davidm@snapgear.com>
+ */
+
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/asm-macros.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/setup.h>
+#include <asm/entry.h>
+#include <asm/unistd.h>
+#include <asm/processor.h>
+
+.macro GET_THREAD_INFO reg
+.if THREAD_SIZE & 0xffff0000
+	andhi	\reg, sp, %hi(~(THREAD_SIZE-1))
+.else
+	addi	\reg, r0, %lo(~(THREAD_SIZE-1))
+	and	\reg, \reg, sp
+.endif
+.endm
+
+.macro	kuser_cmpxchg_check
+	/*
+	 * Make sure our user space atomic helper is restarted if it was
+	 * interrupted in a critical region.
+	 * ea-4 = address of interrupted insn (ea must be preserved).
+	 * sp = saved regs.
+	 * cmpxchg_ldw = first critical insn, cmpxchg_stw = last critical insn.
+	 * If ea <= cmpxchg_stw and ea > cmpxchg_ldw then saved EA is set to
+	 * cmpxchg_ldw + 4.
+	*/
+	/* et = cmpxchg_stw + 4 */
+	movui   et, (KUSER_BASE + 4 + (cmpxchg_stw - __kuser_helper_start))
+	bgtu	ea, et, 1f
+
+	subi	et, et, (cmpxchg_stw - cmpxchg_ldw) /* et = cmpxchg_ldw + 4 */
+	bltu	ea, et, 1f
+	stw	et, PT_EA(sp)	/* fix up EA */
+	mov	ea, et
+1:
+.endm
+
+.section .rodata
+.align 4
+exception_table:
+	.word unhandled_exception	/* 0 - Reset */
+	.word unhandled_exception	/* 1 - Processor-only Reset */
+	.word external_interrupt	/* 2 - Interrupt */
+	.word handle_trap		/* 3 - Trap Instruction */
+
+	.word instruction_trap		/* 4 - Unimplemented instruction */
+	.word handle_illegal		/* 5 - Illegal instruction */
+	.word handle_unaligned		/* 6 - Misaligned data access */
+	.word handle_unaligned		/* 7 - Misaligned destination address */
+
+	.word handle_diverror		/* 8 - Division error */
+	.word protection_exception_ba	/* 9 - Supervisor-only instr. address */
+	.word protection_exception_instr /* 10 - Supervisor only instruction */
+	.word protection_exception_ba	/* 11 - Supervisor only data address */
+
+	.word unhandled_exception	/* 12 - Double TLB miss (data) */
+	.word protection_exception_pte	/* 13 - TLB permission violation (x) */
+	.word protection_exception_pte	/* 14 - TLB permission violation (r) */
+	.word protection_exception_pte	/* 15 - TLB permission violation (w) */
+
+	.word unhandled_exception	/* 16 - MPU region violation */
+
+trap_table:
+	.word	handle_system_call	/* 0  */
+	.word	instruction_trap	/* 1  */
+	.word	instruction_trap	/* 2  */
+	.word	instruction_trap	/* 3  */
+	.word	instruction_trap	/* 4  */
+	.word	instruction_trap	/* 5  */
+	.word	instruction_trap	/* 6  */
+	.word	instruction_trap	/* 7  */
+	.word	instruction_trap	/* 8  */
+	.word	instruction_trap	/* 9  */
+	.word	instruction_trap	/* 10 */
+	.word	instruction_trap	/* 11 */
+	.word	instruction_trap	/* 12 */
+	.word	instruction_trap	/* 13 */
+	.word	instruction_trap	/* 14 */
+	.word	instruction_trap	/* 15 */
+	.word	instruction_trap	/* 16 */
+	.word	instruction_trap	/* 17 */
+	.word	instruction_trap	/* 18 */
+	.word	instruction_trap	/* 19 */
+	.word	instruction_trap	/* 20 */
+	.word	instruction_trap	/* 21 */
+	.word	instruction_trap	/* 22 */
+	.word	instruction_trap	/* 23 */
+	.word	instruction_trap	/* 24 */
+	.word	instruction_trap	/* 25 */
+	.word	instruction_trap	/* 26 */
+	.word	instruction_trap	/* 27 */
+	.word	instruction_trap	/* 28 */
+	.word	instruction_trap	/* 29 */
+	.word	instruction_trap	/* 30 */
+	.word	handle_breakpoint	/* 31 */
+
+.text
+.set noat
+.set nobreak
+
+ENTRY(inthandler)
+	SAVE_ALL
+
+	kuser_cmpxchg_check
+
+	/* Clear EH bit before we get a new excpetion in the kernel
+	 * and after we have saved it to the exception frame. This is done
+	 * wheter it's trap, tlb-miss or interrupt. If we don't do this
+	 * estatus is not updated the next exception.
+	 */
+	rdctl	r24, status
+	movi	r9, %lo(~STATUS_EH)
+	and	r24, r24, r9
+	wrctl	status, r24
+
+	/* Read cause and vector and branch to the associated handler */
+	mov	r4, sp
+	rdctl	r5, exception
+	movia	r9, exception_table
+	add	r24, r9, r5
+	ldw	r24, 0(r24)
+	jmp	r24
+
+
+/***********************************************************************
+ * Handle traps
+ ***********************************************************************
+ */
+ENTRY(handle_trap)
+	ldw	r24, -4(ea)	/* instruction that caused the exception */
+	srli	r24, r24, 4
+	andi	r24, r24, 0x7c
+	movia	r9,trap_table
+	add	r24, r24, r9
+	ldw	r24, 0(r24)
+	jmp	r24
+
+
+/***********************************************************************
+ * Handle system calls
+ ***********************************************************************
+ */
+ENTRY(handle_system_call)
+	/* Enable interrupts */
+	rdctl	r10, status
+	ori	r10, r10, STATUS_PIE
+	wrctl	status, r10
+
+	/* Reload registers destroyed by common code. */
+	ldw	r4, PT_R4(sp)
+	ldw	r5, PT_R5(sp)
+
+local_restart:
+	/* Check that the requested system call is within limits */
+	movui	r1, __NR_syscalls
+	bgeu	r2, r1, ret_invsyscall
+	slli	r1, r2, 2
+	movhi	r11, %hiadj(sys_call_table)
+	add	r1, r1, r11
+	ldw	r1, %lo(sys_call_table)(r1)
+	beq	r1, r0, ret_invsyscall
+
+	/* Check if we are being traced */
+	GET_THREAD_INFO r11
+	ldw	r11,TI_FLAGS(r11)
+	BTBNZ   r11,r11,TIF_SYSCALL_TRACE,traced_system_call
+
+	/* Execute the system call */
+	callr	r1
+
+	/* If the syscall returns a negative result:
+	 *   Set r7 to 1 to indicate error,
+	 *   Negate r2 to get a positive error code
+	 * If the syscall returns zero or a positive value:
+	 *   Set r7 to 0.
+	 * The sigreturn system calls will skip the code below by
+	 * adding to register ra. To avoid destroying registers
+	 */
+translate_rc_and_ret:
+	movi	r1, 0
+	bge	r2, zero, 3f
+	sub	r2, zero, r2
+	movi	r1, 1
+3:
+	stw	r2, PT_R2(sp)
+	stw	r1, PT_R7(sp)
+end_translate_rc_and_ret:
+
+ret_from_exception:
+	ldw	r1, PT_ESTATUS(sp)
+	/* if so, skip resched, signals */
+	TSTBNZ	r1, r1, ESTATUS_EU, Luser_return
+
+restore_all:
+	rdctl	r10, status			/* disable intrs */
+	andi	r10, r10, %lo(~STATUS_PIE)
+	wrctl	status, r10
+	RESTORE_ALL
+	eret
+
+	/* If the syscall number was invalid return ENOSYS */
+ret_invsyscall:
+	movi	r2, -ENOSYS
+	br	translate_rc_and_ret
+
+	/* This implements the same as above, except it calls
+	 * do_syscall_trace_enter and do_syscall_trace_exit before and after the
+	 * syscall in order for utilities like strace and gdb to work.
+	 */
+traced_system_call:
+	SAVE_SWITCH_STACK
+	call	do_syscall_trace_enter
+	RESTORE_SWITCH_STACK
+
+	/* Create system call register arguments. The 5th and 6th
+	   arguments on stack are already in place at the beginning
+	   of pt_regs. */
+	ldw	r2, PT_R2(sp)
+	ldw	r4, PT_R4(sp)
+	ldw	r5, PT_R5(sp)
+	ldw	r6, PT_R6(sp)
+	ldw	r7, PT_R7(sp)
+
+	/* Fetch the syscall function, we don't need to check the boundaries
+	 * since this is already done.
+	 */
+	slli	r1, r2, 2
+	movhi	r11,%hiadj(sys_call_table)
+	add	r1, r1, r11
+	ldw	r1, %lo(sys_call_table)(r1)
+
+	callr	r1
+
+	/* If the syscall returns a negative result:
+	 *   Set r7 to 1 to indicate error,
+	 *   Negate r2 to get a positive error code
+	 * If the syscall returns zero or a positive value:
+	 *   Set r7 to 0.
+	 * The sigreturn system calls will skip the code below by
+	 * adding to register ra. To avoid destroying registers
+	 */
+translate_rc_and_ret2:
+	movi	r1, 0
+	bge	r2, zero, 4f
+	sub	r2, zero, r2
+	movi	r1, 1
+4:
+	stw	r2, PT_R2(sp)
+	stw	r1, PT_R7(sp)
+end_translate_rc_and_ret2:
+	SAVE_SWITCH_STACK
+	call	do_syscall_trace_exit
+	RESTORE_SWITCH_STACK
+	br	ret_from_exception
+
+Luser_return:
+	GET_THREAD_INFO	r11			/* get thread_info pointer */
+	ldw	r10, TI_FLAGS(r11)		/* get thread_info->flags */
+	ANDI32	r11, r10, _TIF_WORK_MASK
+	beq	r11, r0, restore_all		/* Nothing to do */
+	BTBZ	r1, r10, TIF_NEED_RESCHED, Lsignal_return
+
+	/* Reschedule work */
+	call	schedule
+	br	ret_from_exception
+
+Lsignal_return:
+	ANDI32	r1, r10, _TIF_SIGPENDING | _TIF_NOTIFY_RESUME
+	beq	r1, r0, restore_all
+	mov	r4, sp			/* pt_regs */
+	SAVE_SWITCH_STACK
+	call	do_notify_resume
+	beq	r2, r0, no_work_pending
+	RESTORE_SWITCH_STACK
+	/* prepare restart syscall here without leaving kernel */
+	ldw	r2, PT_R2(sp)	/* reload syscall number in r2 */
+	ldw 	r4, PT_R4(sp)	/* reload syscall arguments r4-r9 */
+	ldw 	r5, PT_R5(sp)
+	ldw 	r6, PT_R6(sp)
+	ldw 	r7, PT_R7(sp)
+	ldw 	r8, PT_R8(sp)
+	ldw 	r9, PT_R9(sp)
+	br	local_restart	/* restart syscall */
+
+no_work_pending:
+	RESTORE_SWITCH_STACK
+	br	ret_from_exception
+
+/***********************************************************************
+ * Handle external interrupts.
+ ***********************************************************************
+ */
+/*
+ * This is the generic interrupt handler (for all hardware interrupt
+ * sources). It figures out the vector number and calls the appropriate
+ * interrupt service routine directly.
+ */
+external_interrupt:
+	rdctl	r12, ipending
+	rdctl	r9, ienable
+	and	r12, r12, r9
+	/* skip if no interrupt is pending */
+	beq	r12, r0, ret_from_interrupt
+
+	movi	r24, -1
+	stw	r24, PT_ORIG_R2(sp)
+
+	/*
+	 * Process an external hardware interrupt.
+	 */
+
+	addi	ea, ea, -4	/* re-issue the interrupted instruction */
+	stw	ea, PT_EA(sp)
+2:	movi	r4, %lo(-1)	/* Start from bit position 0,
+					highest priority */
+				/* This is the IRQ # for handler call */
+1:	andi	r10, r12, 1	/* Isolate bit we are interested in */
+	srli	r12, r12, 1	/* shift count is costly without hardware
+					multiplier */
+	addi	r4, r4, 1
+	beq	r10, r0, 1b
+	mov	r5, sp		/* Setup pt_regs pointer for handler call */
+	call	do_IRQ
+	rdctl	r12, ipending	/* check again if irq still pending */
+	rdctl	r9, ienable	/* Isolate possible interrupts */
+	and	r12, r12, r9
+	bne	r12, r0, 2b
+	/* br	ret_from_interrupt */ /* fall throught to ret_from_interrupt */
+
+ENTRY(ret_from_interrupt)
+	ldw	r1, PT_ESTATUS(sp)	/* check if returning to kernel */
+	TSTBNZ	r1, r1, ESTATUS_EU, Luser_return
+
+#ifdef CONFIG_PREEMPT
+	GET_THREAD_INFO	r1
+	ldw	r4, TI_PREEMPT_COUNT(r1)
+	bne	r4, r0, restore_all
+
+need_resched:
+	ldw	r4, TI_FLAGS(r1)		/* ? Need resched set */
+	BTBZ	r10, r4, TIF_NEED_RESCHED, restore_all
+	ldw	r4, PT_ESTATUS(sp)	/* ? Interrupts off */
+	andi	r10, r4, ESTATUS_EPIE
+	beq	r10, r0, restore_all
+	movia	r4, PREEMPT_ACTIVE
+	stw	r4, TI_PREEMPT_COUNT(r1)
+	rdctl	r10, status		/* enable intrs again */
+	ori	r10, r10 ,STATUS_PIE
+	wrctl	status, r10
+	PUSH	r1
+	call	schedule
+	POP	r1
+	mov	r4, r0
+	stw	r4, TI_PREEMPT_COUNT(r1)
+	rdctl	r10, status		/* disable intrs */
+	andi	r10, r10, %lo(~STATUS_PIE)
+	wrctl	status, r10
+	br	need_resched
+#else
+	br	restore_all
+#endif
+
+/***********************************************************************
+ * A few syscall wrappers
+ ***********************************************************************
+ */
+/*
+ * int clone(unsigned long clone_flags, unsigned long newsp,
+ *		int __user * parent_tidptr, int __user * child_tidptr,
+ *		int tls_val)
+ */
+ENTRY(sys_clone)
+	SAVE_SWITCH_STACK
+	addi	sp, sp, -4
+	stw	r7, 0(sp)	/* Pass 5th arg thru stack */
+	mov	r7, r6		/* 4th arg is 3rd of clone() */
+	mov	r6, zero	/* 3rd arg always 0 */
+	call	do_fork
+	addi	sp, sp, 4
+	RESTORE_SWITCH_STACK
+	ret
+
+ENTRY(sys_rt_sigreturn)
+	SAVE_SWITCH_STACK
+	mov	r4, sp
+	call	do_rt_sigreturn
+	RESTORE_SWITCH_STACK
+	addi	ra, ra, (end_translate_rc_and_ret - translate_rc_and_ret)
+	ret
+
+/***********************************************************************
+ * A few other wrappers and stubs
+ ***********************************************************************
+ */
+protection_exception_pte:
+	rdctl	r6, pteaddr
+	slli	r6, r6, 10
+	call	do_page_fault
+	br	ret_from_exception
+
+protection_exception_ba:
+	rdctl	r6, badaddr
+	call	do_page_fault
+	br	ret_from_exception
+
+protection_exception_instr:
+	call	handle_supervisor_instr
+	br	ret_from_exception
+
+handle_breakpoint:
+	call	breakpoint_c
+	br	ret_from_exception
+
+#ifdef CONFIG_NIOS2_ALIGNMENT_TRAP
+handle_unaligned:
+	SAVE_SWITCH_STACK
+	call	handle_unaligned_c
+	RESTORE_SWITCH_STACK
+	br	ret_from_exception
+#else
+handle_unaligned:
+	call	handle_unaligned_c
+	br	ret_from_exception
+#endif
+
+handle_illegal:
+	call	handle_illegal_c
+	br	ret_from_exception
+
+handle_diverror:
+	call	handle_diverror_c
+	br	ret_from_exception
+
+/*
+ * Beware - when entering resume, prev (the current task) is
+ * in r4, next (the new task) is in r5, don't change these
+ * registers.
+ */
+ENTRY(resume)
+
+	rdctl	r7, status			/* save thread status reg */
+	stw	r7, TASK_THREAD + THREAD_KPSR(r4)
+
+	andi	r7, r7, %lo(~STATUS_PIE)	/* disable interrupts */
+	wrctl	status, r7
+
+	SAVE_SWITCH_STACK
+	stw	sp, TASK_THREAD + THREAD_KSP(r4)/* save kernel stack pointer */
+	ldw	sp, TASK_THREAD + THREAD_KSP(r5)/* restore new thread stack */
+	movia	r24, _current_thread		/* save thread */
+	GET_THREAD_INFO r1
+	stw	r1, 0(r24)
+	RESTORE_SWITCH_STACK
+
+	ldw	r7, TASK_THREAD + THREAD_KPSR(r5)/* restore thread status reg */
+	wrctl	status, r7
+	ret
+
+ENTRY(ret_from_fork)
+	call	schedule_tail
+	br	ret_from_exception
+
+ENTRY(ret_from_kernel_thread)
+	call	schedule_tail
+	mov	r4,r17	/* arg */
+	callr	r16	/* function */
+	br	ret_from_exception
+
+/*
+ * Kernel user helpers.
+ *
+ * Each segment is 64-byte aligned and will be mapped to the <User space>.
+ * New segments (if ever needed) must be added after the existing ones.
+ * This mechanism should be used only for things that are really small and
+ * justified, and not be abused freely.
+ *
+ */
+
+ /* Filling pads with undefined instructions. */
+.macro	kuser_pad sym size
+	.if	((. - \sym) & 3)
+	.rept	(4 - (. - \sym) & 3)
+	.byte	0
+	.endr
+	.endif
+	.rept	((\size - (. - \sym)) / 4)
+	.word	0xdeadbeef
+	.endr
+.endm
+
+	.align	6
+	.globl	__kuser_helper_start
+__kuser_helper_start:
+
+__kuser_helper_version:				/* @ 0x1000 */
+	.word	((__kuser_helper_end - __kuser_helper_start) >> 6)
+
+__kuser_cmpxchg:				/* @ 0x1004 */
+	/*
+	 * r4 pointer to exchange variable
+	 * r5 old value
+	 * r6 new value
+	 */
+cmpxchg_ldw:
+	ldw	r2, 0(r4)			/* load current value */
+	sub	r2, r2, r5			/* compare with old value */
+	bne	r2, zero, cmpxchg_ret
+
+	/* We had a match, store the new value */
+cmpxchg_stw:
+	stw	r6, 0(r4)
+cmpxchg_ret:
+	ret
+
+	kuser_pad __kuser_cmpxchg, 64
+
+	.globl	__kuser_sigtramp
+__kuser_sigtramp:
+	movi	r2, __NR_rt_sigreturn
+	trap
+
+	kuser_pad __kuser_sigtramp, 64
+
+	.globl	__kuser_helper_end
+__kuser_helper_end:
diff --git a/arch/nios2/kernel/misaligned.c b/arch/nios2/kernel/misaligned.c
new file mode 100644
index 0000000..db5c54a
--- /dev/null
+++ b/arch/nios2/kernel/misaligned.c
@@ -0,0 +1,255 @@
+/*
+ *  linux/arch/nios2/kernel/misaligned.c
+ *
+ *  basic emulation for mis-aligned accesses on the NIOS II cpu
+ *  modeled after the version for arm in arm/alignment.c
+ *
+ *  Brad Parker <brad@heeltoe.com>
+ *  Copyright (C) 2010 Ambient Corporation
+ *  Copyright (c) 2010 Altera Corporation, San Jose, California, USA.
+ *  Copyright (c) 2010 Arrow Electronics, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of
+ * this archive for more details.
+ */
+
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/proc_fs.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+
+#include <asm/traps.h>
+#include <asm/unaligned.h>
+
+/* instructions we emulate */
+#define INST_LDHU	0x0b
+#define INST_STH	0x0d
+#define INST_LDH	0x0f
+#define INST_STW	0x15
+#define INST_LDW	0x17
+
+static unsigned long ma_user, ma_kern, ma_skipped, ma_half, ma_word;
+
+static unsigned int ma_usermode;
+#define UM_WARN		0x01
+#define UM_FIXUP	0x02
+#define UM_SIGNAL	0x04
+#define KM_WARN		0x08
+
+/* see arch/nios2/include/asm/ptrace.h */
+static u8 sys_stack_frame_reg_offset[] = {
+	/* struct pt_regs */
+	8, 9, 10, 11, 12, 13, 14, 15, 1, 2, 3, 4, 5, 6, 7, 0,
+	/* struct switch_stack */
+	16, 17, 18, 19, 20, 21, 22, 23, 0, 0, 0, 0, 0, 0, 0, 0
+};
+
+static int reg_offsets[32];
+
+static inline u32 get_reg_val(struct pt_regs *fp, int reg)
+{
+	u8 *p = ((u8 *)fp) + reg_offsets[reg];
+	return *(u32 *)p;
+}
+
+static inline void put_reg_val(struct pt_regs *fp, int reg, u32 val)
+{
+	u8 *p = ((u8 *)fp) + reg_offsets[reg];
+	*(u32 *)p = val;
+}
+
+/*
+ * (mis)alignment handler
+ */
+asmlinkage void handle_unaligned_c(struct pt_regs *fp, int cause)
+{
+	u32 isn, addr, val;
+	int in_kernel;
+	u8 a, b, d0, d1, d2, d3;
+	u16 imm16;
+	unsigned int fault;
+
+	/* back up one instruction */
+	fp->ea -= 4;
+
+	if (fixup_exception(fp)) {
+		ma_skipped++;
+		return;
+	}
+
+	in_kernel = !user_mode(fp);
+
+	isn = *(unsigned long *)(fp->ea);
+
+	fault = 0;
+
+	/* do fixup if in kernel or mode turned on */
+	if (in_kernel || (ma_usermode & UM_FIXUP)) {
+		/* decompose instruction */
+		a = (isn >> 27) & 0x1f;
+		b = (isn >> 22) & 0x1f;
+		imm16 = (isn >> 6) & 0xffff;
+		addr = get_reg_val(fp, a) + imm16;
+
+		/* do fixup to saved registers */
+		switch (isn & 0x3f) {
+		case INST_LDHU:
+			fault |= __get_user(d0, (u8 *)(addr+0));
+			fault |= __get_user(d1, (u8 *)(addr+1));
+			val = (d1 << 8) | d0;
+			put_reg_val(fp, b, val);
+			ma_half++;
+			break;
+		case INST_STH:
+			val = get_reg_val(fp, b);
+			d1 = val >> 8;
+			d0 = val >> 0;
+
+			pr_debug("sth: ra=%d (%08x) rb=%d (%08x), imm16 %04x addr %08x val %08x\n",
+				a, get_reg_val(fp, a),
+				b, get_reg_val(fp, b),
+				imm16, addr, val);
+
+			if (in_kernel) {
+				*(u8 *)(addr+0) = d0;
+				*(u8 *)(addr+1) = d1;
+			} else {
+				fault |= __put_user(d0, (u8 *)(addr+0));
+				fault |= __put_user(d1, (u8 *)(addr+1));
+			}
+			ma_half++;
+			break;
+		case INST_LDH:
+			fault |= __get_user(d0, (u8 *)(addr+0));
+			fault |= __get_user(d1, (u8 *)(addr+1));
+			val = (short)((d1 << 8) | d0);
+			put_reg_val(fp, b, val);
+			ma_half++;
+			break;
+		case INST_STW:
+			val = get_reg_val(fp, b);
+			d3 = val >> 24;
+			d2 = val >> 16;
+			d1 = val >> 8;
+			d0 = val >> 0;
+			if (in_kernel) {
+				*(u8 *)(addr+0) = d0;
+				*(u8 *)(addr+1) = d1;
+				*(u8 *)(addr+2) = d2;
+				*(u8 *)(addr+3) = d3;
+			} else {
+				fault |= __put_user(d0, (u8 *)(addr+0));
+				fault |= __put_user(d1, (u8 *)(addr+1));
+				fault |= __put_user(d2, (u8 *)(addr+2));
+				fault |= __put_user(d3, (u8 *)(addr+3));
+			}
+			ma_word++;
+			break;
+		case INST_LDW:
+			fault |= __get_user(d0, (u8 *)(addr+0));
+			fault |= __get_user(d1, (u8 *)(addr+1));
+			fault |= __get_user(d2, (u8 *)(addr+2));
+			fault |= __get_user(d3, (u8 *)(addr+3));
+			val = (d3 << 24) | (d2 << 16) | (d1 << 8) | d0;
+			put_reg_val(fp, b, val);
+			ma_word++;
+			break;
+		}
+	}
+
+	addr = RDCTL(CTL_BADADDR);
+	cause >>= 2;
+
+	if (fault) {
+		if (in_kernel) {
+			pr_err("fault during kernel misaligned fixup @ %#lx; addr 0x%08lx; isn=0x%08x\n",
+				fp->ea, (long unsigned int)addr,
+				(unsigned int)isn);
+		} else {
+			pr_err("fault during user misaligned fixup @ %#lx; isn=%08x addr=0x%08x sp=0x%08lx pid=%d\n",
+				fp->ea,
+				(unsigned int)isn, addr, fp->sp,
+				current->pid);
+
+			_exception(SIGSEGV, fp, SEGV_MAPERR, fp->ea);
+			return;
+		}
+	}
+
+	/*
+	 * kernel mode -
+	 *  note exception and skip bad instruction (return)
+	 */
+	if (in_kernel) {
+		ma_kern++;
+		fp->ea += 4;
+
+		if (ma_usermode & KM_WARN) {
+			pr_err("kernel unaligned access @ %#lx; BADADDR 0x%08lx; cause=%d, isn=0x%08lx\n",
+				fp->ea,
+				(long unsigned int)addr, cause,
+				(long unsigned int)isn);
+			/* show_regs(fp); */
+		}
+
+		return;
+	}
+
+	ma_user++;
+
+	/*
+	 * user mode -
+	 *  possibly warn,
+	 *  possibly send SIGBUS signal to process
+	 */
+	if (ma_usermode & UM_WARN) {
+		pr_err("user unaligned access @ %#lx; isn=0x%08lx ea=0x%08lx ra=0x%08lx sp=0x%08lx\n",
+			(unsigned long)addr, (unsigned long)isn,
+			fp->ea, fp->ra, fp->sp);
+	}
+
+	if (ma_usermode & UM_SIGNAL)
+		_exception(SIGBUS, fp, BUS_ADRALN, fp->ea);
+	else
+		fp->ea += 4;	/* else advance */
+}
+
+static void __init misaligned_calc_reg_offsets(void)
+{
+	int i, r, offset;
+
+	/* pre-calc offsets of registers on sys call stack frame */
+	offset = 0;
+
+	/* struct pt_regs */
+	for (i = 0; i < 16; i++) {
+		r = sys_stack_frame_reg_offset[i];
+		reg_offsets[r] = offset;
+		offset += 4;
+	}
+
+	/* struct switch_stack */
+	offset = -sizeof(struct switch_stack);
+	for (i = 16; i < 32; i++) {
+		r = sys_stack_frame_reg_offset[i];
+		reg_offsets[r] = offset;
+		offset += 4;
+	}
+}
+
+
+static int __init misaligned_init(void)
+{
+	/* default mode - silent fix */
+	ma_usermode = UM_FIXUP | KM_WARN;
+
+	misaligned_calc_reg_offsets();
+
+	return 0;
+}
+
+fs_initcall(misaligned_init);
-- 
1.8.2.1

