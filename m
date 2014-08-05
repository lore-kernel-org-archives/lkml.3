Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaHEOx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbaHEOx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:53:26 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6/8] x86: mass removal of ARGOFFSET
Date: Tue,  5 Aug 2014 16:52:32 +0200
Message-Id: <1407250354-29525-7-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
References: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARGOFFSET is zero now, removing it changes no code.
A few macros lost "offset" parameter, since it is always zero now too.

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
 arch/x86/ia32/ia32entry.S      | 140 ++++++++++++++++++++---------------------
 arch/x86/include/asm/calling.h |   2 -
 arch/x86/kernel/entry_64.S     |  66 +++++++++----------
 3 files changed, 103 insertions(+), 105 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index d0ca63b..20eba33 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -41,13 +41,13 @@
 	movl	%edx,%edx	/* zero extension */
 	.endm 
 
-	/* clobbers %eax */	
-	.macro  CLEAR_RREGS offset=0, _r9=rax
+	/* clobbers %rax */
+	.macro  CLEAR_RREGS _r9=rax
 	xorl 	%eax,%eax
-	movq	%rax,\offset+R11(%rsp)
-	movq	%rax,\offset+R10(%rsp)
-	movq	%\_r9,\offset+R9(%rsp)
-	movq	%rax,\offset+R8(%rsp)
+	movq	%rax,R11(%rsp)
+	movq	%rax,R10(%rsp)
+	movq	%\_r9,R9(%rsp)
+	movq	%rax,R8(%rsp)
 	.endm
 
 	/*
@@ -60,14 +60,14 @@
 	 * If it's -1 to make us punt the syscall, then (u32)-1 is still
 	 * an appropriately invalid value.
 	 */
-	.macro LOAD_ARGS32 offset, _r9=0
+	.macro LOAD_ARGS32 _r9=0
 	.if \_r9
-	movl \offset+R9(%rsp),%r9d
+	movl R9(%rsp),%r9d
 	.endif
-	movl \offset+RCX(%rsp),%ecx
-	movl \offset+RDX(%rsp),%edx
-	movl \offset+RSI(%rsp),%esi
-	movl \offset+RDI(%rsp),%edi
+	movl RCX(%rsp),%ecx
+	movl RDX(%rsp),%edx
+	movl RSI(%rsp),%esi
+	movl RDI(%rsp),%edi
 	movl %eax,%eax			/* zero extension */
 	.endm
 	
@@ -152,8 +152,8 @@ ENTRY(ia32_sysenter_target)
 1:	movl	(%rbp),%ebp
 	_ASM_EXTABLE(1b,ia32_badarg)
 	ASM_CLAC
-	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 	cmpq	$(IA32_NR_syscalls-1),%rax
@@ -162,16 +162,16 @@ sysenter_do_call:
 	IA32_ARG_FIXUP
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
-	movq	%rax,RAX-ARGOFFSET(%rsp)
+	movq	%rax,RAX(%rsp)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP)
 	jnz	sysexit_audit
 sysexit_from_sys_call:
-	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
 	/* clear IF, that popfq doesn't enable interrupts early */
-	andl	$~0x200,EFLAGS-ARGOFFSET(%rsp)
-	movl	RIP-ARGOFFSET(%rsp),%edx		/* User %eip */
+	andl	$~0x200,EFLAGS(%rsp)
+	movl	RIP(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
 	RESTORE_RSI_RDI
 	REMOVE_PTREGS_FROM_STACK 8*3
@@ -195,18 +195,18 @@ sysexit_from_sys_call:
 	movl %eax,%esi			/* 2nd arg: syscall number */
 	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
 	call __audit_syscall_entry
-	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
+	movl RAX(%rsp),%eax		/* reload syscall number */
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 	movl %ebx,%edi			/* reload 1st syscall arg */
-	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
-	movl RDX-ARGOFFSET(%rsp),%edx	/* reload 3rd syscall arg */
-	movl RSI-ARGOFFSET(%rsp),%ecx	/* reload 4th syscall arg */
-	movl RDI-ARGOFFSET(%rsp),%r8d	/* reload 5th syscall arg */
+	movl RCX(%rsp),%esi		/* reload 2nd syscall arg */
+	movl RDX(%rsp),%edx		/* reload 3rd syscall arg */
+	movl RSI(%rsp),%ecx		/* reload 4th syscall arg */
+	movl RDI(%rsp),%r8d		/* reload 5th syscall arg */
 	.endm
 
 	.macro auditsys_exit exit
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
@@ -217,13 +217,13 @@ sysexit_from_sys_call:
 1:	setbe %al		/* 1 if error, 0 if not */
 	movzbl %al,%edi		/* zero-extend that into %edi */
 	call __audit_syscall_exit
-	movq RAX-ARGOFFSET(%rsp),%rax	/* reload syscall return value */
+	movq RAX(%rsp),%rax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP)
 	jz \exit
-	CLEAR_RREGS -ARGOFFSET
+	CLEAR_RREGS
 	jmp int_with_check
 	.endm
 
@@ -239,7 +239,7 @@ sysexit_audit:
 
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP)
 	jz	sysenter_auditsys
 #endif
 	SAVE_EXTRA_REGS
@@ -247,7 +247,7 @@ sysenter_tracesys:
 	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32	/* reload args from stack in case ptrace changed it */
 	RESTORE_EXTRA_REGS
 	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
@@ -293,17 +293,17 @@ ENTRY(ia32_cstar_target)
 	ALLOC_PTREGS_ON_STACK 8
 	SAVE_C_REGS_EXCEPT_RCX_R891011
 	movl 	%eax,%eax	/* zero extension */
-	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
-	movq	%rcx,RIP-ARGOFFSET(%rsp)
-	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	movq	%rbp,RCX-ARGOFFSET(%rsp) /* this lies slightly to ptrace */
+	movq	%rax,ORIG_RAX(%rsp)
+	movq	%rcx,RIP(%rsp)
+	CFI_REL_OFFSET rip,RIP
+	movq	%rbp,RCX(%rsp) /* this lies slightly to ptrace */
 	movl	%ebp,%ecx
-	movq	$__USER32_CS,CS-ARGOFFSET(%rsp)
-	movq	$__USER32_DS,SS-ARGOFFSET(%rsp)
-	movq	%r11,EFLAGS-ARGOFFSET(%rsp)
-	/*CFI_REL_OFFSET rflags,EFLAGS-ARGOFFSET*/
-	movq	%r8,RSP-ARGOFFSET(%rsp)	
-	CFI_REL_OFFSET rsp,RSP-ARGOFFSET
+	movq	$__USER32_CS,CS(%rsp)
+	movq	$__USER32_DS,SS(%rsp)
+	movq	%r11,EFLAGS(%rsp)
+	/*CFI_REL_OFFSET rflags,EFLAGS*/
+	movq	%r8,RSP(%rsp)
+	CFI_REL_OFFSET rsp,RSP
 	/* no need to do an access_ok check here because r8 has been
 	   32bit zero extended */ 
 	/* hardware stack frame is complete now */	
@@ -311,8 +311,8 @@ ENTRY(ia32_cstar_target)
 1:	movl	(%r8),%r9d
 	_ASM_EXTABLE(1b,ia32_badarg)
 	ASM_CLAC
-	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 	cmpq $IA32_NR_syscalls-1,%rax
@@ -321,32 +321,32 @@ cstar_do_call:
 	IA32_ARG_FIXUP 1
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
-	movq %rax,RAX-ARGOFFSET(%rsp)
+	movq %rax,RAX(%rsp)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP)
 	jnz sysretl_audit
 sysretl_from_sys_call:
-	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
 	RESTORE_RSI_RDI_RDX
-	movl RIP-ARGOFFSET(%rsp),%ecx
+	movl RIP(%rsp),%ecx
 	CFI_REGISTER rip,rcx
-	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
+	movl EFLAGS(%rsp),%r11d
 	/*CFI_REGISTER rflags,r11*/
 	xorq	%r10,%r10
 	xorq	%r9,%r9
 	xorq	%r8,%r8
 	TRACE_IRQS_ON
-	movl RSP-ARGOFFSET(%rsp),%esp
+	movl RSP(%rsp),%esp
 	CFI_RESTORE rsp
 	USERGS_SYSRET32
 	
 #ifdef CONFIG_AUDITSYSCALL
 cstar_auditsys:
 	CFI_RESTORE_STATE
-	movl %r9d,R9-ARGOFFSET(%rsp)	/* register to be clobbered by call */
+	movl %r9d,R9(%rsp)	/* register to be clobbered by call */
 	auditsys_entry_common
-	movl R9-ARGOFFSET(%rsp),%r9d	/* reload 6th syscall arg */
+	movl R9(%rsp),%r9d	/* reload 6th syscall arg */
 	jmp cstar_dispatch
 
 sysretl_audit:
@@ -355,16 +355,16 @@ sysretl_audit:
 
 cstar_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP)
 	jz cstar_auditsys
 #endif
 	xchgl %r9d,%ebp
 	SAVE_EXTRA_REGS
-	CLEAR_RREGS 0, r9
+	CLEAR_RREGS r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 1	/* reload args from stack in case ptrace changed it */
 	RESTORE_EXTRA_REGS
 	xchgl %ebp,%r9d
 	cmpq $(IA32_NR_syscalls-1),%rax
@@ -422,8 +422,8 @@ ENTRY(ia32_syscall)
 	   this could be a problem. */
 	ALLOC_PTREGS_ON_STACK
 	SAVE_C_REGS_EXCEPT_R891011
-	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
 	jnz ia32_tracesys
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
@@ -431,9 +431,9 @@ ia32_do_call:
 	IA32_ARG_FIXUP
 	call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
 ia32_sysret:
-	movq %rax,RAX-ARGOFFSET(%rsp)
+	movq %rax,RAX(%rsp)
 ia32_ret_from_sys_call:
-	CLEAR_RREGS -ARGOFFSET
+	CLEAR_RREGS
 	jmp int_ret_from_sys_call
 
 ia32_tracesys:
@@ -442,7 +442,7 @@ ia32_tracesys:
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32	/* reload args from stack in case ptrace changed it */
 	RESTORE_EXTRA_REGS
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
@@ -450,7 +450,7 @@ ia32_tracesys:
 END(ia32_syscall)
 
 ia32_badsys:
-	movq $0,ORIG_RAX-ARGOFFSET(%rsp)
+	movq $0,ORIG_RAX(%rsp)
 	movq $-ENOSYS,%rax
 	jmp ia32_sysret
 
@@ -482,17 +482,17 @@ ia32_ptregs_common:
 	CFI_ENDPROC
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,SS+8-ARGOFFSET
-	CFI_REL_OFFSET	rax,RAX-ARGOFFSET
-	CFI_REL_OFFSET	rcx,RCX-ARGOFFSET
-	CFI_REL_OFFSET	rdx,RDX-ARGOFFSET
-	CFI_REL_OFFSET	rsi,RSI-ARGOFFSET
-	CFI_REL_OFFSET	rdi,RDI-ARGOFFSET
-	CFI_REL_OFFSET	rip,RIP-ARGOFFSET
-/*	CFI_REL_OFFSET	cs,CS-ARGOFFSET*/
-/*	CFI_REL_OFFSET	rflags,EFLAGS-ARGOFFSET*/
-	CFI_REL_OFFSET	rsp,RSP-ARGOFFSET
-/*	CFI_REL_OFFSET	ss,SS-ARGOFFSET*/
+	CFI_DEF_CFA	rsp,SS+8
+	CFI_REL_OFFSET	rax,RAX
+	CFI_REL_OFFSET	rcx,RCX
+	CFI_REL_OFFSET	rdx,RDX
+	CFI_REL_OFFSET	rsi,RSI
+	CFI_REL_OFFSET	rdi,RDI
+	CFI_REL_OFFSET	rip,RIP
+/*	CFI_REL_OFFSET	cs,CS*/
+/*	CFI_REL_OFFSET	rflags,EFLAGS*/
+	CFI_REL_OFFSET	rsp,RSP
+/*	CFI_REL_OFFSET	ss,SS*/
 	SAVE_EXTRA_REGS 8
 	call *%rax
 	RESTORE_EXTRA_REGS 8
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 7642948..e8e2e41 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -88,8 +88,6 @@ For 32-bit we have the following conventions - kernel is built with
 #define RSP		19*8
 #define SS		20*8
 
-#define ARGOFFSET	0
-
 	.macro ALLOC_PTREGS_ON_STACK addskip=0
 	subq	$15*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET 15*8+\addskip
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c489a2d..8c6a01d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -73,7 +73,7 @@ ENDPROC(native_usergs_sysret64)
 #endif /* CONFIG_PARAVIRT */
 
 
-.macro TRACE_IRQS_IRETQ offset=ARGOFFSET
+.macro TRACE_IRQS_IRETQ offset=0
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bt   $9,EFLAGS-\offset(%rsp)	/* interrupts off? */
 	jnc  1f
@@ -107,7 +107,7 @@ ENDPROC(native_usergs_sysret64)
 	call debug_stack_reset
 .endm
 
-.macro TRACE_IRQS_IRETQ_DEBUG offset=ARGOFFSET
+.macro TRACE_IRQS_IRETQ_DEBUG offset=0
 	bt   $9,EFLAGS-\offset(%rsp)	/* interrupts off? */
 	jnc  1f
 	TRACE_IRQS_ON_DEBUG
@@ -184,16 +184,16 @@ ENDPROC(native_usergs_sysret64)
  * frame that enables passing a complete pt_regs to a C function.
  */
 	.macro DEFAULT_FRAME start=1 offset=0
-	XCPT_FRAME \start, ORIG_RAX+\offset-ARGOFFSET
-	CFI_REL_OFFSET rdi, RDI+\offset-ARGOFFSET
-	CFI_REL_OFFSET rsi, RSI+\offset-ARGOFFSET
-	CFI_REL_OFFSET rdx, RDX+\offset-ARGOFFSET
-	CFI_REL_OFFSET rcx, RCX+\offset-ARGOFFSET
-	CFI_REL_OFFSET rax, RAX+\offset-ARGOFFSET
-	CFI_REL_OFFSET r8, R8+\offset-ARGOFFSET
-	CFI_REL_OFFSET r9, R9+\offset-ARGOFFSET
-	CFI_REL_OFFSET r10, R10+\offset-ARGOFFSET
-	CFI_REL_OFFSET r11, R11+\offset-ARGOFFSET
+	XCPT_FRAME \start, ORIG_RAX+\offset
+	CFI_REL_OFFSET rdi, RDI+\offset
+	CFI_REL_OFFSET rsi, RSI+\offset
+	CFI_REL_OFFSET rdx, RDX+\offset
+	CFI_REL_OFFSET rcx, RCX+\offset
+	CFI_REL_OFFSET rax, RAX+\offset
+	CFI_REL_OFFSET r8, R8+\offset
+	CFI_REL_OFFSET r9, R9+\offset
+	CFI_REL_OFFSET r10, R10+\offset
+	CFI_REL_OFFSET r11, R11+\offset
 	CFI_REL_OFFSET rbx, RBX+\offset
 	CFI_REL_OFFSET rbp, RBP+\offset
 	CFI_REL_OFFSET r12, R12+\offset
@@ -237,13 +237,13 @@ ENTRY(ret_from_fork)
 
 	RESTORE_EXTRA_REGS
 
-	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
+	testl $3, CS(%rsp)			# from kernel_thread?
 	jz   1f
 
 	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
 
-	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
+	RESTORE_TOP_OF_STACK %rdi
 	jmp ret_from_sys_call			# go to the SYSRET fastpath
 
 1:
@@ -310,10 +310,10 @@ GLOBAL(system_call_after_swapgs)
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	ALLOC_PTREGS_ON_STACK 8
 	SAVE_C_REGS
-	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
-	movq  %rcx,RIP-ARGOFFSET(%rsp)
-	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	movq  %rax,ORIG_RAX(%rsp)
+	movq  %rcx,RIP(%rsp)
+	CFI_REL_OFFSET rip,RIP
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
 	jnz tracesys
 system_call_fastpath:
 #if __SYSCALL_MASK == ~0
@@ -325,7 +325,7 @@ system_call_fastpath:
 	ja badsys
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
-	movq %rax,RAX-ARGOFFSET(%rsp)
+	movq %rax,RAX(%rsp)
 /*
  * Syscall return path ending with SYSRET (fast path)
  * Has incomplete stack frame and undefined top of stack.
@@ -337,7 +337,7 @@ sysret_check:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
+	movl TI_flags+THREAD_INFO(%rsp,RIP),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
 	CFI_REMEMBER_STATE
@@ -346,7 +346,7 @@ sysret_check:
 	 */
 	TRACE_IRQS_ON
 	RESTORE_C_REGS_EXCEPT_RCX
-	movq RIP-ARGOFFSET(%rsp),%rcx
+	movq RIP(%rsp),%rcx
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	movq	PER_CPU_VAR(old_rsp), %rsp
@@ -378,11 +378,11 @@ sysret_signal:
 	 * These all wind up with the iret return path anyway,
 	 * so just join that path right now.
 	 */
-	FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
+	FIXUP_TOP_OF_STACK %r11
 	jmp int_check_syscall_exit_work
 
 badsys:
-	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
+	movq $-ENOSYS,RAX(%rsp)
 	jmp ret_from_sys_call
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -408,7 +408,7 @@ auditsys:
 	 * masked off.
 	 */
 sysret_audit:
-	movq RAX-ARGOFFSET(%rsp),%rsi	/* second arg, syscall return value */
+	movq RAX(%rsp),%rsi	/* second arg, syscall return value */
 	cmpq $-MAX_ERRNO,%rsi	/* is it < -MAX_ERRNO? */
 	setbe %al		/* 1 if so, 0 if not */
 	movzbl %al,%edi		/* zero-extend that into %edi */
@@ -420,7 +420,7 @@ sysret_audit:
 	/* Do syscall tracing */
 tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP)
 	jz auditsys
 #endif
 	SAVE_EXTRA_REGS
@@ -444,7 +444,7 @@ tracesys:
 	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
 	movq %r10,%rcx	/* fixup for C */
 	call *sys_call_table(,%rax,8)
-	movq %rax,RAX-ARGOFFSET(%rsp)
+	movq %rax,RAX(%rsp)
 	/* Use IRET because user could have changed frame */
 
 /*
@@ -528,9 +528,9 @@ END(stub_\func)
 ENTRY(\label)
 	CFI_STARTPROC
 	DEFAULT_FRAME 0, 8		/* offset 8: return address */
-	FIXUP_TOP_OF_STACK %r11, 8-ARGOFFSET
+	FIXUP_TOP_OF_STACK %r11, 8
 	call \func
-	RESTORE_TOP_OF_STACK %r11, 8-ARGOFFSET
+	RESTORE_TOP_OF_STACK %r11, 8
 	ret
 	CFI_ENDPROC
 END(\label)
@@ -702,7 +702,7 @@ common_interrupt:
 	ASM_CLAC
 	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	interrupt do_IRQ
-	/* 0(%rsp): old_rsp-ARGOFFSET */
+	/* 0(%rsp): old_rsp */
 ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
@@ -712,13 +712,13 @@ ret_from_intr:
 	popq %rsi
 	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
 	/* return code expects complete pt_regs - adjust rsp accordingly: */
-	leaq ARGOFFSET-RBP(%rsi), %rsp
+	leaq -RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
-	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
+	CFI_ADJUST_CFA_OFFSET	RBP
 
 exit_intr:
 	GET_THREAD_INFO(%rcx)
-	testl $3,CS-ARGOFFSET(%rsp)
+	testl $3,CS(%rsp)
 	je retint_kernel
 
 	/* Interrupt came from user space */
@@ -856,7 +856,7 @@ retint_signal:
 ENTRY(retint_kernel)
 	cmpl $0,PER_CPU_VAR(__preempt_count)
 	jnz  retint_restore_args
-	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
+	bt   $9,EFLAGS(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
 	call preempt_schedule_irq
 	jmp exit_intr
-- 
1.8.1.4

