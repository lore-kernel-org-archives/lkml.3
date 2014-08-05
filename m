Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaHEOxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:53:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbaHEOxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:53:38 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 8/8] x86: add comments about various syscall instructions, no code changes
Date: Tue,  5 Aug 2014 16:52:34 +0200
Message-Id: <1407250354-29525-9-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
References: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSCALL/SYSRET and SYSTENTER/SYSEXIT have weird semantics.
Moreover, they differ in 32- and 64-bit mode.
What is saved? What is not? Is rsp set? Are interrupts disabled?
People tend to not rememeber these details well enough.

This patch adds comments which explain in detail
what registers are modified by each of these instructions.
The comments are placed immediately before corresponding
entry and exit points.

While at it, I noticed that our 32bit SYSCALL/SYSRET code
seems to believe that r11 contains saved eflags.
This is not true (only 64-bit mode does that).
Added comment about that.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/ia32/ia32entry.S  | 125 +++++++++++++++++++++++++++------------------
 arch/x86/kernel/entry_64.S |  32 +++++++-----
 2 files changed, 94 insertions(+), 63 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4402bbe..9c31ece 100644
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
 	ALLOC_PTREGS_ON_STACK
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
@@ -174,6 +183,7 @@ sysexit_from_sys_call:
 	movl	RIP(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
 	RESTORE_RSI_RDI
+	/* pop everything except ss,rsp,rflags slots */
 	REMOVE_PTREGS_FROM_STACK 8*3
 	xorq	%r8,%r8
 	xorq	%r9,%r9
@@ -184,6 +194,10 @@ sysexit_from_sys_call:
 	popq_cfi %rcx				/* User %esp */
 	CFI_REGISTER rsp,rcx
 	TRACE_IRQS_ON
+	/*
+	 * 32bit SYSEXIT restores eip from edx, esp from ecx.
+	 * cs and ss are loaded from MSRs.
+	 */
 	ENABLE_INTERRUPTS_SYSEXIT32
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -258,23 +272,25 @@ ENDPROC(ia32_sysenter_target)
 /*
  * 32bit SYSCALL instruction entry.
  *
+ * 32bit SYSCALL loads ss, cs, and rip from previously programmed MSRs.
+ * IF, RF and VM in rflags are cleared (IOW: interrupts are off).
+ * SYSCALL does not save anything on the stack and does not change rsp.
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
@@ -290,7 +306,7 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	ALLOC_PTREGS_ON_STACK 8
+	ALLOC_PTREGS_ON_STACK 8	/* +8: space for orig_ax */
 	SAVE_C_REGS_EXCEPT_RCX_R891011
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX(%rsp)
@@ -300,13 +316,16 @@ ENTRY(ia32_cstar_target)
 	movl	%ebp,%ecx
 	movq	$__USER32_CS,CS(%rsp)
 	movq	$__USER32_DS,SS(%rsp)
+	/* huh?? 32bit SYSCALL doesn't save rflags in r11 (24594_APM_v3.pdf) */
 	movq	%r11,EFLAGS(%rsp)
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
@@ -331,6 +350,7 @@ sysretl_from_sys_call:
 	RESTORE_RSI_RDI_RDX
 	movl RIP(%rsp),%ecx
 	CFI_REGISTER rip,rcx
+	/* huh?? 32bit SYSRET does not restore rflags from r11 */
 	movl EFLAGS(%rsp),%r11d
 	/*CFI_REGISTER rflags,r11*/
 	xorq	%r10,%r10
@@ -339,8 +359,13 @@ sysretl_from_sys_call:
 	TRACE_IRQS_ON
 	movl RSP(%rsp),%esp
 	CFI_RESTORE rsp
+	/*
+	 * 32bit SYSRET restores eip from ecx,
+	 * rflags.IF is set to 1 (interrupts enabled),
+	 * cs and ss are loaded from MSRs.
+	 */
 	USERGS_SYSRET32
-	
+
 #ifdef CONFIG_AUDITSYSCALL
 cstar_auditsys:
 	CFI_RESTORE_STATE
@@ -378,26 +403,26 @@ ia32_badarg:
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
@@ -416,7 +441,7 @@ ENTRY(ia32_syscall)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%eax
-	pushq_cfi %rax
+	pushq_cfi %rax		/* store orig_ax */
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e9bbe02..4a2e3ab 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -256,25 +256,25 @@ ENTRY(ret_from_fork)
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
@@ -302,13 +302,14 @@ ENTRY(system_call)
 GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
+	/* kernel_stack is set so that 5 slots (iret frame) are preallocated */
 	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	ALLOC_PTREGS_ON_STACK 8
+	ALLOC_PTREGS_ON_STACK 8		/* +8: space for orig_ax */
 	SAVE_C_REGS
 	movq  %rax,ORIG_RAX(%rsp)
 	movq  %rcx,RIP(%rsp)
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

