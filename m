Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbbARBRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:17:52 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41915 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbbARBRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:17:47 -0500
X-Sasl-enc: lSVPcX7oWWRWjFwy+Lrvrfo2eEdihWU8YupOjvvzBVd2 1421543866
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/3] x86_64: remove KERNEL_STACK_OFFSET from THREAD_INFO macro
Date: Sun, 18 Jan 2015 02:17:40 +0100
Message-Id: <1421543862-3552-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421543862-3552-1-git-send-email-heukelum@fastmail.fm>
References: <1421543862-3552-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the macro THREAD_INFO(reg,offset), the offset is relative to
KERNEL_STACK_OFFSET. Change the macro and all its uses so that
offset is given as the current top of stack in the pt_regs frame.
The generated code is identical.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/ia32/ia32entry.S          | 30 +++++++++++++++---------------
 arch/x86/include/asm/calling.h     |  1 +
 arch/x86/include/asm/thread_info.h |  2 +-
 arch/x86/kernel/entry_64.S         |  4 ++--
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 156ebca..1c74f39 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -135,7 +135,7 @@ ENTRY(ia32_sysenter_target)
 	CFI_REL_OFFSET rsp,0
 	pushfq_cfi
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	TI_sysenter_return+THREAD_INFO(%rsp,3*8-KERNEL_STACK_OFFSET),%r10d
+	movl	TI_sysenter_return+THREAD_INFO(%rsp,EFLAGS),%r10d
 	CFI_REGISTER rip,r10
 	pushq_cfi $__USER32_CS
 	/*CFI_REL_OFFSET cs,0*/
@@ -161,8 +161,8 @@ ENTRY(ia32_sysenter_target)
 	jnz sysenter_fix_flags
 sysenter_flags_fixed:
 
-	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,ARGOFFSET)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 	cmpq	$(IA32_NR_syscalls-1),%rax
@@ -174,10 +174,10 @@ sysenter_dispatch:
 	movq	%rax,RAX-ARGOFFSET(%rsp)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jnz	sysexit_audit
 sysexit_from_sys_call:
-	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,ARGOFFSET)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl	$~0x200,EFLAGS-ARGOFFSET(%rsp)
 	movl	RIP-ARGOFFSET(%rsp),%edx		/* User %eip */
@@ -216,7 +216,7 @@ sysexit_from_sys_call:
 	.endm
 
 	.macro auditsys_exit exit
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
@@ -231,7 +231,7 @@ sysexit_from_sys_call:
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl %edi,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jz \exit
 	CLEAR_RREGS -ARGOFFSET
 	jmp int_with_check
@@ -253,7 +253,7 @@ sysenter_fix_flags:
 
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
@@ -324,8 +324,8 @@ ENTRY(ia32_cstar_target)
 1:	movl	(%r8),%r9d
 	_ASM_EXTABLE(1b,ia32_badarg)
 	ASM_CLAC
-	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,ARGOFFSET)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 	cmpq $IA32_NR_syscalls-1,%rax
@@ -337,10 +337,10 @@ cstar_dispatch:
 	movq %rax,RAX-ARGOFFSET(%rsp)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jnz sysretl_audit
 sysretl_from_sys_call:
-	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,ARGOFFSET)
 	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
@@ -368,7 +368,7 @@ sysretl_audit:
 
 cstar_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jz cstar_auditsys
 #endif
 	xchgl %r9d,%ebp
@@ -434,8 +434,8 @@ ENTRY(ia32_syscall)
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
 	SAVE_ARGS 0,1,0
-	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,ARGOFFSET)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jnz ia32_tracesys
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 1f1297b..16ab13d 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -81,6 +81,7 @@ For 32-bit we have the following conventions - kernel is built with
 #define EFLAGS		144
 #define RSP		152
 #define SS		160
+#define PTREGS_SIZE	168
 
 #define ARGOFFSET	R11
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e82e95a..471037d 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -190,7 +190,7 @@ static inline unsigned long current_stack_pointer(void)
  * Same if PER_CPU_VAR(kernel_stack) is, perhaps with some offset, already in
  * a certain register (to be used in assembler memory operands).
  */
-#define THREAD_INFO(reg, off) KERNEL_STACK_OFFSET+(off)-THREAD_SIZE(reg)
+#define THREAD_INFO(reg, off) PTREGS_SIZE-(off)-THREAD_SIZE(reg)
 
 #endif
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index db13655..9f9ca20 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -343,7 +343,7 @@ GLOBAL(system_call_after_swapgs)
 	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
 #if __SYSCALL_MASK == ~0
@@ -361,7 +361,7 @@ system_call_fastpath:
  * Has incomplete stack frame and undefined top of stack.
  */
 ret_from_sys_call:
-	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,ARGOFFSET)
 	jnz int_ret_from_sys_call_fixup	/* Go the the slow path */
 
 	LOCKDEP_SYS_EXIT
-- 
2.1.0

