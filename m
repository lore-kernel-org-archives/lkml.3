Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbbARBSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:18:01 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41460 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbbARBRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:17:50 -0500
X-Sasl-enc: gw3xHjfm6KivddJYwofzsW/2JUTyZFetsmWTOxmSz3iU 1421543869
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 3/3] x86_64, entry: Create IRET-compatible stack frame at syscall entry
Date: Sun, 18 Jan 2015 02:17:42 +0100
Message-Id: <1421543862-3552-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421543862-3552-1-git-send-email-heukelum@fastmail.fm>
References: <1421543862-3552-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an IRET-compatible top of stack at syscall entry and use this
information to return to user mode in the sysret path. This removes
the need for the FIXUP_TOP_OF_STACK and RESTORE_TOP_OF_STACK macros.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_64.S | 77 +++++++++++++---------------------------------
 1 file changed, 22 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7adff94..e952839 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -33,8 +33,6 @@
  * - SAVE_REST/RESTORE_REST - Handle the registers not saved by SAVE_ARGS.
  * Gives a full stack frame.
  * - ENTRY/END Define functions in the symbol table.
- * - FIXUP_TOP_OF_STACK/RESTORE_TOP_OF_STACK - Fix up the hardware stack
- * frame that is otherwise undefined after a SYSCALL
  * - TRACE_IRQ_* - Trace hard interrupt state for lock debugging.
  * - idtentry - Define exception entry points.
  */
@@ -130,33 +128,6 @@ ENDPROC(native_usergs_sysret64)
 #endif
 
 /*
- * C code is not supposed to know about undefined top of stack. Every time
- * a C function with an pt_regs argument is called from the SYSCALL based
- * fast path FIXUP_TOP_OF_STACK is needed.
- * RESTORE_TOP_OF_STACK syncs the syscall state after any possible ptregs
- * manipulation.
- */
-
-	/* %rsp:at FRAMEEND */
-	.macro FIXUP_TOP_OF_STACK tmp offset=0
-	movq PER_CPU_VAR(old_rsp),\tmp
-	movq \tmp,RSP+\offset(%rsp)
-	movq $__USER_DS,SS+\offset(%rsp)
-	movq $__USER_CS,CS+\offset(%rsp)
-	movq RIP+\offset(%rsp),\tmp  /* get rip */
-	movq \tmp,RCX+\offset(%rsp)  /* copy it to rcx as sysret would do */
-	movq R11+\offset(%rsp),\tmp  /* get eflags */
-	movq \tmp,EFLAGS+\offset(%rsp)
-	.endm
-
-	.macro RESTORE_TOP_OF_STACK tmp offset=0
-	movq RSP+\offset(%rsp),\tmp
-	movq \tmp,PER_CPU_VAR(old_rsp)
-	movq EFLAGS+\offset(%rsp),\tmp
-	movq \tmp,R11+\offset(%rsp)
-	.endm
-
-/*
  * initial frame state for interrupts (and exceptions without error code)
  */
 	.macro EMPTY_FRAME start=1 offset=0
@@ -272,7 +243,6 @@ ENTRY(ret_from_fork)
 	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
 
-	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
 	jmp ret_from_sys_call			# go to the SYSRET fastpath
 
 1:
@@ -334,16 +304,30 @@ GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
 	movq	PER_CPU_VAR(kernel_stack),%rsp
-	sub $(PTREGS_SIZE-RIP),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8, 0, rax_enosys=1
+
+	/*
+	 * Save user mode rsp (temporarily saved above in old_rsp),
+	 * rflags (%r11), rip (%rcx) and segments (fixed values) on
+	 * the stack as a regular interrupt frame.
+	 */
+	pushq_cfi $__USER_DS
+	/* CFI_REL_OFFSET ss, 0 */
+	pushq_cfi PER_CPU_VAR(old_rsp)
+	CFI_REL_OFFSET rsp, 0
+	pushq_cfi %r11 /* %r11 clobbered (userspace %rflags) */
+	/* CFI_REL_OFFSET rflags, 0 */
+	pushq_cfi $__USER_CS
+	/* CFI_REL_OFFSET cs, 0 */
+	pushq_cfi %rcx /* %rcx clobbered (userspace %rip) */
+	CFI_REL_OFFSET rip, 0
+
+	SAVE_ARGS 8, rax_enosys=1
 	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
-	movq  %rcx,RIP-ARGOFFSET(%rsp)
-	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
@@ -363,7 +347,7 @@ system_call_fastpath:
  */
 ret_from_sys_call:
 	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
-	jnz int_ret_from_sys_call_fixup	/* Go the the slow path */
+	jnz int_ret_from_sys_call	/* Go the the slow path */
 
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -373,19 +357,16 @@ ret_from_sys_call:
 	 * sysretq will re-enable interrupts:
 	 */
 	TRACE_IRQS_ON
+	RESTORE_ARGS addskip=-ARG_SKIP, rstor_rcx=0, rstor_r11=0
 	movq RIP-ARGOFFSET(%rsp),%rcx
 	CFI_REGISTER	rip,rcx
-	RESTORE_ARGS 1,-ARG_SKIP,0
+	mov EFLAGS-ARGOFFSET(%rsp), %r11
 	/*CFI_REGISTER	rflags,r11*/
-	movq	PER_CPU_VAR(old_rsp), %rsp
+	mov RSP-ARGOFFSET(%rsp), %rsp
 	USERGS_SYSRET64
 
 	CFI_RESTORE_STATE
 
-int_ret_from_sys_call_fixup:
-	FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
-	jmp int_ret_from_sys_call
-
 	/* Do syscall tracing */
 tracesys:
 	leaq -REST_SKIP(%rsp), %rdi
@@ -398,7 +379,6 @@ tracesys:
 
 tracesys_phase2:
 	SAVE_REST
-	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp, %rdi
 	movq $AUDIT_ARCH_X86_64, %rsi
 	movq %rax,%rdx
@@ -494,10 +474,8 @@ ENTRY(stub_\func)
 	PARTIAL_FRAME 0
 	SAVE_REST
 	pushq	%r11			/* put it back on stack */
-	FIXUP_TOP_OF_STACK %r11, 8
 	DEFAULT_FRAME 0 8		/* offset 8: return address */
 	call sys_\func
-	RESTORE_TOP_OF_STACK %r11, 8
 	ret $REST_SKIP		/* pop extended registers */
 	CFI_ENDPROC
 END(stub_\func)
@@ -507,9 +485,7 @@ END(stub_\func)
 ENTRY(\label)
 	CFI_STARTPROC
 	PARTIAL_FRAME 0 8		/* offset 8: return address */
-	FIXUP_TOP_OF_STACK %r11, 8-ARGOFFSET
 	call \func
-	RESTORE_TOP_OF_STACK %r11, 8-ARGOFFSET
 	ret
 	CFI_ENDPROC
 END(\label)
@@ -525,7 +501,6 @@ ENTRY(stub_execve)
 	addq $8, %rsp
 	PARTIAL_FRAME 0
 	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
 	call sys_execve
 	movq %rax,RAX(%rsp)
 	RESTORE_REST
@@ -538,9 +513,7 @@ ENTRY(stub_execveat)
 	addq $8, %rsp
 	PARTIAL_FRAME 0
 	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
 	call sys_execveat
-	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
 	RESTORE_REST
 	jmp int_ret_from_sys_call
@@ -556,7 +529,6 @@ ENTRY(stub_rt_sigreturn)
 	addq $8, %rsp
 	PARTIAL_FRAME 0
 	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
 	call sys_rt_sigreturn
 	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
 	RESTORE_REST
@@ -570,7 +542,6 @@ ENTRY(stub_x32_rt_sigreturn)
 	addq $8, %rsp
 	PARTIAL_FRAME 0
 	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
 	call sys32_x32_rt_sigreturn
 	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
 	RESTORE_REST
@@ -583,9 +554,7 @@ ENTRY(stub_x32_execve)
 	addq $8, %rsp
 	PARTIAL_FRAME 0
 	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
 	call compat_sys_execve
-	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
 	RESTORE_REST
 	jmp int_ret_from_sys_call
@@ -597,9 +566,7 @@ ENTRY(stub_x32_execveat)
 	addq $8, %rsp
 	PARTIAL_FRAME 0
 	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
 	call compat_sys_execveat
-	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
 	RESTORE_REST
 	jmp int_ret_from_sys_call
-- 
2.1.0

