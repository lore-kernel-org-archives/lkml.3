Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaHDNUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaHDNUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:20:46 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6/6] x86: rename some macros and labels, no code changes
Date: Mon,  4 Aug 2014 15:19:46 +0200
Message-Id: <1407158386-6201-7-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com>
References: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename LOAD_ARGS32 to RESTORE_REGS32 to match other RESTORE_* macros.
The "ARGS" part was misleading anyway - we are restoring registers,
not arguments.

Similarly, rename [retint_]restore_args to [retint_]restore_c_regs:
at these labels, we restore registers clobbered by C ABI;
rename int_restore_rest to int_restore_extra_regs.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
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
 arch/x86/ia32/ia32entry.S  | 10 +++++-----
 arch/x86/kernel/entry_64.S | 16 ++++++++--------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 7315179..dd1c5fd 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -51,7 +51,7 @@
 	.endm
 
 	/*
-	 * Reload arg registers from stack in case ptrace changed them.
+	 * Reload registers from stack in case ptrace changed them.
 	 * We don't reload %eax because syscall_trace_enter() returned
 	 * the %rax value we should see.  Instead, we just truncate that
 	 * value to 32 bits again as we did on entry from user mode.
@@ -60,7 +60,7 @@
 	 * If it's -1 to make us punt the syscall, then (u32)-1 is still
 	 * an appropriately invalid value.
 	 */
-	.macro LOAD_ARGS32 _r9=0
+	.macro RESTORE_REGS32 _r9=0
 	.if \_r9
 	movl R9(%rsp),%r9d
 	.endif
@@ -247,7 +247,7 @@ sysenter_tracesys:
 	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
-	LOAD_ARGS32	/* reload args from stack in case ptrace changed it */
+	RESTORE_REGS32	/* reload regs from stack in case ptrace changed it */
 	RESTORE_EXTRA_REGS
 	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
@@ -364,7 +364,7 @@ cstar_tracesys:
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 1	/* reload args from stack in case ptrace changed it */
+	RESTORE_REGS32 1	/* reload regs from stack in case ptrace changed it */
 	RESTORE_EXTRA_REGS
 	xchgl %ebp,%r9d
 	cmpq $(IA32_NR_syscalls-1),%rax
@@ -442,7 +442,7 @@ ia32_tracesys:
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32	/* reload args from stack in case ptrace changed it */
+	RESTORE_REGS32	/* reload args from stack in case ptrace changed it */
 	RESTORE_EXTRA_REGS
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8c6a01d..e9bbe02 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -62,7 +62,7 @@
 
 
 #ifndef CONFIG_PREEMPT
-#define retint_kernel retint_restore_args
+#define retint_kernel retint_restore_c_regs
 #endif
 
 #ifdef CONFIG_PARAVIRT
@@ -494,7 +494,7 @@ int_check_syscall_exit_work:
 	call syscall_trace_leave
 	popq_cfi %rdi
 	andl $~(_TIF_WORK_SYSCALL_EXIT|_TIF_SYSCALL_EMU),%edi
-	jmp int_restore_rest
+	jmp int_restore_extra_regs
 
 int_signal:
 	testl $_TIF_DO_NOTIFY_MASK,%edx
@@ -503,7 +503,7 @@ int_signal:
 	xorl %esi,%esi		# oldset -> arg2
 	call do_notify_resume
 1:	movl $_TIF_WORK_MASK,%edi
-int_restore_rest:
+int_restore_extra_regs:
 	RESTORE_EXTRA_REGS
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
@@ -742,15 +742,15 @@ retint_swapgs:		/* return to user-space */
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_IRETQ
 	SWAPGS
-	jmp restore_args
+	jmp restore_c_regs
 
-retint_restore_args:	/* return to kernel space */
+retint_restore_c_regs:	/* return to kernel space */
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	/*
 	 * The iretq could re-enable interrupts:
 	 */
 	TRACE_IRQS_IRETQ
-restore_args:
+restore_c_regs:
 	RESTORE_C_REGS
 	REMOVE_PTREGS_FROM_STACK 8
 
@@ -855,9 +855,9 @@ retint_signal:
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
 	cmpl $0,PER_CPU_VAR(__preempt_count)
-	jnz  retint_restore_args
+	jnz  retint_restore_c_regs
 	bt   $9,EFLAGS(%rsp)	/* interrupts off? */
-	jnc  retint_restore_args
+	jnc  retint_restore_c_regs
 	call preempt_schedule_irq
 	jmp exit_intr
 #endif
-- 
1.8.1.4

