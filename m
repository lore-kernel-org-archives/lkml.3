Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaHHRqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:46:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbaHHRqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:46:00 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 14/17] x86: ia32entry.S: use mov instead of push/pop where possible
Date: Fri,  8 Aug 2014 19:44:37 +0200
Message-Id: <1407519880-6719-15-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mov insns are faster than push/pops: some CPUs can execute
two movs per cycle, but only one push/pop.

Logic is not changed by this patch.

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
 arch/x86/ia32/ia32entry.S | 54 ++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index c70c9a0..844ef4f 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -119,28 +119,25 @@ ENTRY(ia32_sysenter_target)
 	 * disabled irqs, here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	/* Construct iret frame (ss,rsp,rflags,cs,rip) */
+	/* Construct part of iret frame (ss,rsp,rflags) */
  	movl	%ebp,%ebp		/* zero extension */
 	pushq_cfi $__USER32_DS
 	/*CFI_REL_OFFSET ss,0*/
+	movl 	%eax,%eax		/* zero extension */
 	pushq_cfi %rbp
 	CFI_REL_OFFSET rsp,0
 	pushfq_cfi
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	TI_sysenter_return+THREAD_INFO(%rsp,3*8),%r10d
-	CFI_REGISTER rip,r10
-	pushq_cfi $__USER32_CS
-	/*CFI_REL_OFFSET cs,0*/
-	movl	%eax, %eax
-	/* Store thread_info->sysenter_return in rip stack slot */
-	pushq_cfi %r10
-	CFI_REL_OFFSET rip,0
-	/* Store orig_ax */
-	pushq_cfi %rax
-	/* Construct the rest of "struct pt_regs" */
 	cld
-	ALLOC_PTREGS_ON_STACK
+	/* Construct the rest of pt_regs */
+	ALLOC_PTREGS_ON_STACK 3*8 /* 3*8: space for orig_ax,rip,cs */
+	movl	TI_sysenter_return+THREAD_INFO(%rsp,SIZEOF_PTREGS),%r10d
 	SAVE_C_REGS_EXCEPT_R891011
+	movq	%rax,ORIG_RAX(%rsp)
+	/* pt_regs->ip = thread_info->sysenter_return */
+	movq	%r10,RIP(%rsp)
+	CFI_REL_OFFSET rip,RIP
+	movq	$__USER32_CS,CS(%rsp)
 	/*
 	 * no need to do an access_ok check here because rbp has been
 	 * 32bit zero extended
@@ -171,10 +168,12 @@ sysenter_dispatch:
 	jnz	sysexit_audit
 sysexit_from_sys_call:
 	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,SIZEOF_PTREGS)
-	/* clear IF, that popfq doesn't enable interrupts early */
+	/* clear IF, so that popfq won't enable interrupts early */
 	andl	$~0x200,EFLAGS(%rsp)
 	movl	RIP(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
+	movl	RSP(%rsp),%ecx		/* User %esp */
+	CFI_REGISTER rsp,rcx
 	RESTORE_RSI_RDI
 	/* pop everything except ss,rsp,rflags slots */
 	REMOVE_PTREGS_FROM_STACK 8*3
@@ -184,8 +183,6 @@ sysexit_from_sys_call:
 	xorq	%r11,%r11
 	popfq_cfi
 	/*CFI_RESTORE rflags*/
-	popq_cfi %rcx				/* User %esp */
-	CFI_REGISTER rsp,rcx
 	TRACE_IRQS_ON
 	/*
 	 * 32bit SYSEXIT restores eip from edx, esp from ecx.
@@ -307,21 +304,21 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	ALLOC_PTREGS_ON_STACK 6*8	/* space for orig_ax and iret frame */
-	SAVE_C_REGS_EXCEPT_RCX_R891011
-	movl 	%eax,%eax	/* zero extension */
+	movl	%eax,%eax	/* zero extension */
+	ALLOC_PTREGS_ON_STACK 6*8 /* 6*8: space for orig_ax and iret frame */
 	movq	%rax,ORIG_RAX(%rsp)
 	movq	%rcx,RIP(%rsp)
 	CFI_REL_OFFSET rip,RIP
-	movq	%rbp,RCX(%rsp) /* this lies slightly to ptrace */
-	movl	%ebp,%ecx
 	movq	$__USER32_CS,CS(%rsp)
-	movq	$__USER32_DS,SS(%rsp)
 	movq	%r11,EFLAGS(%rsp)
 	/*CFI_REL_OFFSET rflags,EFLAGS*/
 	movq	%r8,RSP(%rsp)
 	CFI_REL_OFFSET rsp,RSP
-	/* iret stack frame is complete now */
+	movq	$__USER32_DS,SS(%rsp)
+	/* iret frame is complete now */
+	SAVE_C_REGS_EXCEPT_RCX_R891011
+	movq	%rbp,RCX(%rsp)	/* this lies slightly to ptrace */
+	movl	%ebp,%ecx
 	/*
 	 * no need to do an access_ok check here because r8 has been
 	 * 32bit zero extended
@@ -447,11 +444,11 @@ ENTRY(ia32_syscall)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%eax
-	pushq_cfi %rax		/* store orig_ax */
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
-	ALLOC_PTREGS_ON_STACK
+	ALLOC_PTREGS_ON_STACK 1*8 /* 1*8: space for orig_ax */
+	movq %rax,ORIG_RAX(%rsp)
 	SAVE_C_REGS_EXCEPT_R891011
 	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
-- 
1.8.1.4

