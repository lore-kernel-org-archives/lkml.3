Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbbANVtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:49:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbbANVt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:49:28 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] x86: add comments about various syscall instructions, no code changes
Date: Wed, 14 Jan 2015 22:48:15 +0100
Message-Id: <1421272101-16847-5-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSCALL/SYSRET and SYSENTER/SYSEXIT have weird semantics.
Moreover, they differ in 32- and 64-bit mode.
What is saved? What is not? Is rsp set? Are interrupts disabled?
People tend to not remember these details well enough.

This patch adds comments which explain in detail
what registers are modified by each of these instructions.
The comments are placed immediately before corresponding
entry and exit points.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/ia32/ia32entry.S  | 133 ++++++++++++++++++++++++++++-----------------
 arch/x86/kernel/entry_64.S |  32 ++++++-----
 2 files changed, 102 insertions(+), 63 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 9f4c877..366f633 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -99,22 +99,25 @@ ENDPROC(native_irq_enable_sysexit)
 /*
  * 32bit SYSENTER instruction entry.
  *
+ * SYSENTER loads ss, rsp, cs, and rip from previously programmed MSRs.
+ * IF and VM in rflags are cleared (IOW: interrupts are off).
+ * SYSENTER does not save anything on the stack,
+ * and does not save old rip (!!!) and rflags.
+ *
  * Arguments:
- * %eax	System call number.
- * %ebx Arg1
- * %ecx Arg2
- * %edx Arg3
- * %esi Arg4
- * %edi Arg5
- * %ebp user stack
- * 0(%ebp) Arg6	
- * 	
- * Interrupts off.
- *	
+ * eax  system call number
+ * ebx  arg1
+ * ecx  arg2
+ * edx  arg3
+ * esi  arg4
+ * edi  arg5
+ * ebp  user stack
+ * 0(%ebp) arg6
+ *
  * This is purely a fast path. For anything complicated we use the int 0x80
- * path below.	Set up a complete hardware stack frame to share code
+ * path below. We set up a complete hardware stack frame to share code
  * with the int 0x80 path.
- */ 	
+ */
 ENTRY(ia32_sysenter_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -128,6 +131,7 @@ ENTRY(ia32_sysenter_target)
 	 * disabled irqs, here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
+	/* Construct iret frame (ss,rsp,rflags,cs,rip) */
  	movl	%ebp,%ebp		/* zero extension */
 	pushq_cfi $__USER32_DS
 	/*CFI_REL_OFFSET ss,0*/
@@ -140,14 +144,19 @@ ENTRY(ia32_sysenter_target)
 	pushq_cfi $__USER32_CS
 	/*CFI_REL_OFFSET cs,0*/
 	movl	%eax, %eax
+	/* Store thread_info->sysenter_return in rip stack slot */
 	pushq_cfi %r10
 	CFI_REL_OFFSET rip,0
+	/* Store orig_ax */
 	pushq_cfi %rax
+	/* Construct the rest of "struct pt_regs" */
 	cld
 	ALLOC_PT_GPREGS_ON_STACK
 	SAVE_C_REGS_EXCEPT_R891011
- 	/* no need to do an access_ok check here because rbp has been
- 	   32bit zero extended */ 
+	/*
+	 * no need to do an access_ok check here because rbp has been
+	 * 32bit zero extended
+	 */
 	ASM_STAC
 1:	movl	(%rbp),%ebp
 	_ASM_EXTABLE(1b,ia32_badarg)
@@ -184,6 +193,7 @@ sysexit_from_sys_call:
 	movl	RIP(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
 	RESTORE_RSI_RDI
+	/* pop everything except ss,rsp,rflags slots */
 	REMOVE_PT_GPREGS_FROM_STACK 3*8
 	xorq	%r8,%r8
 	xorq	%r9,%r9
@@ -194,6 +204,10 @@ sysexit_from_sys_call:
 	popq_cfi %rcx				/* User %esp */
 	CFI_REGISTER rsp,rcx
 	TRACE_IRQS_ON
+	/*
+	 * 32bit SYSEXIT restores eip from edx, esp from ecx.
+	 * cs and ss are loaded from MSRs.
+	 */
 	ENABLE_INTERRUPTS_SYSEXIT32
 
 	CFI_RESTORE_STATE
@@ -274,23 +288,33 @@ ENDPROC(ia32_sysenter_target)
 /*
  * 32bit SYSCALL instruction entry.
  *
+ * 32bit SYSCALL saves rip to rcx, clears rflags.RF, then saves rflags to r11,
+ * then loads new ss, cs, and rip from previously programmed MSRs.
+ * rflags gets masked by a value from another MSR (so CLD and CLAC
+ * are not needed). SYSCALL does not save anything on the stack
+ * and does not change rsp.
+ *
+ * Note: rflags saving+masking-with-MSR happens only in Long mode
+ * (in legacy 32bit mode, IF, RF and VM bits are cleared and that's it).
+ * Don't get confused: rflags saving+masking depends on Long Mode Active bit
+ * (EFER.LMA=1), NOT on bitness of userspace where SYSCALL executes
+ * or target CS descriptor's L bit (SYSCALL does not read segment descriptors).
+ *
  * Arguments:
- * %eax	System call number.
- * %ebx Arg1
- * %ecx return EIP 
- * %edx Arg3
- * %esi Arg4
- * %edi Arg5
- * %ebp Arg2    [note: not saved in the stack frame, should not be touched]
- * %esp user stack 
- * 0(%esp) Arg6
- * 	
- * Interrupts off.
- *	
+ * eax  system call number
+ * ecx  return address
+ * ebx  arg1
+ * ebp  arg2	(note: not saved in the stack frame, should not be touched)
+ * edx  arg3
+ * esi  arg4
+ * edi  arg5
+ * esp  user stack
+ * 0(%esp) arg6
+ *
  * This is purely a fast path. For anything complicated we use the int 0x80
- * path below.	Set up a complete hardware stack frame to share code
- * with the int 0x80 path.	
- */ 	
+ * path below. We set up a complete hardware stack frame to share code
+ * with the int 0x80 path.
+ */
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -306,7 +330,7 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	ALLOC_PT_GPREGS_ON_STACK 8
+	ALLOC_PT_GPREGS_ON_STACK 8	/* +8: space for orig_ax */
 	SAVE_C_REGS_EXCEPT_RCX_R891011
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX(%rsp)
@@ -320,9 +344,11 @@ ENTRY(ia32_cstar_target)
 	/*CFI_REL_OFFSET rflags,EFLAGS*/
 	movq	%r8,RSP(%rsp)
 	CFI_REL_OFFSET rsp,RSP
-	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-	/* hardware stack frame is complete now */	
+	/* iret stack frame is complete now */
+	/*
+	 * no need to do an access_ok check here because r8 has been
+	 * 32bit zero extended
+	 */
 	ASM_STAC
 1:	movl	(%r8),%r9d
 	_ASM_EXTABLE(1b,ia32_badarg)
@@ -355,8 +381,15 @@ sysretl_from_sys_call:
 	TRACE_IRQS_ON
 	movl RSP(%rsp),%esp
 	CFI_RESTORE rsp
+	/*
+	 * 64bit->32bit SYSRET restores eip from ecx,
+	 * eflags from r11 (but RF and VM bits are forced to 0),
+	 * cs and ss are loaded from MSRs.
+	 * (Note: 32bit->32bit SYSRET is different: since r11
+	 * does not exist, it merely sets eflags.IF=1).
+	 */
 	USERGS_SYSRET32
-	
+
 #ifdef CONFIG_AUDITSYSCALL
 cstar_auditsys:
 	CFI_RESTORE_STATE
@@ -394,26 +427,26 @@ ia32_badarg:
 	jmp ia32_sysret
 	CFI_ENDPROC
 
-/* 
- * Emulated IA32 system calls via int 0x80. 
+/*
+ * Emulated IA32 system calls via int 0x80.
  *
- * Arguments:	 
- * %eax	System call number.
- * %ebx Arg1
- * %ecx Arg2
- * %edx Arg3
- * %esi Arg4
- * %edi Arg5
- * %ebp Arg6    [note: not saved in the stack frame, should not be touched]
+ * Arguments:
+ * eax  system call number
+ * ebx  arg1
+ * ecx  arg2
+ * edx  arg3
+ * esi  arg4
+ * edi  arg5
+ * ebp  arg6	(note: not saved in the stack frame, should not be touched)
  *
  * Notes:
- * Uses the same stack frame as the x86-64 version.	
- * All registers except %eax must be saved (but ptrace may violate that)
+ * Uses the same stack frame as the x86-64 version.
+ * All registers except eax must be saved (but ptrace may violate that).
  * Arguments are zero extended. For system calls that want sign extension and
  * take long arguments a wrapper is needed. Most calls can just be called
  * directly.
- * Assumes it is only called from user space and entered with interrupts off.	
- */ 				
+ * Assumes it is only called from user space and entered with interrupts off.
+ */
 
 ENTRY(ia32_syscall)
 	CFI_STARTPROC32	simple
@@ -432,7 +465,7 @@ ENTRY(ia32_syscall)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%eax
-	pushq_cfi %rax
+	pushq_cfi %rax		/* store orig_ax */
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c9259f4..3498274 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -255,25 +255,25 @@ ENTRY(ret_from_fork)
 END(ret_from_fork)
 
 /*
- * System call entry. Up to 6 arguments in registers are supported.
+ * 64bit SYSCALL instruction entry. Up to 6 arguments in registers.
  *
- * SYSCALL does not save anything on the stack and does not change the
- * stack pointer.  However, it does mask the flags register for us, so
- * CLD and CLAC are not needed.
- */
-
-/*
- * Register setup:
+ * 64bit SYSCALL saves rip to rcx, clears rflags.RF, then saves rflags to r11,
+ * then loads new ss, cs, and rip from previously programmed MSRs.
+ * rflags gets masked by a value from another MSR (so CLD and CLAC
+ * are not needed). SYSCALL does not save anything on the stack
+ * and does not change rsp.
+ *
+ * Registers on entry:
  * rax  system call number
+ * rcx  return address
+ * r11  saved rflags (note: r11 is callee-clobbered register in C ABI)
  * rdi  arg0
- * rcx  return address for syscall/sysret, C arg3
  * rsi  arg1
  * rdx  arg2
- * r10  arg3 	(--> moved to rcx for C)
+ * r10  arg3 (needs to be moved to rcx to conform to C ABI)
  * r8   arg4
  * r9   arg5
- * r11  eflags for syscall/sysret, temporary for C
- * r12-r15,rbp,rbx saved by C code, not touched.
+ * (note: r12-r15,rbp,rbx are callee-preserved in C ABI)
  *
  * Interrupts are off on entry.
  * Only called from user space.
@@ -301,13 +301,14 @@ ENTRY(system_call)
 GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
+	/* kernel_stack is set so that 5 slots (iret frame) are preallocated */
 	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	ALLOC_PT_GPREGS_ON_STACK 8
+	ALLOC_PT_GPREGS_ON_STACK 8		/* +8: space for orig_ax */
 	SAVE_C_REGS_EXCEPT_RAX_RCX
 	movq	$-ENOSYS,RAX(%rsp)
 	movq_cfi rax,(ORIG_RAX)
@@ -350,6 +351,11 @@ sysret_check:
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	movq	PER_CPU_VAR(old_rsp), %rsp
+	/*
+	 * 64bit SYSRET restores rip from rcx,
+	 * rflags from r11 (but RF and VM bits are forced to 0),
+	 * cs and ss are loaded from MSRs.
+	 */
 	USERGS_SYSRET64
 
 	CFI_RESTORE_STATE
-- 
1.8.1.4

