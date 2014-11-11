Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaKKU46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:56:58 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40542 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaKKU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:56:57 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
Date: Tue, 11 Nov 2014 12:56:52 -0800
Message-Id: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This causes all non-NMI kernel entries from userspace to run on the
normal kernel stack.

This means that machine check recovery can happen in non-atomic
context.  It also obviates the need for the paranoid_userspace path.

Borislav has referred to this idea as the tail wagging the dog.  I
think that's okay -- the dog was pretty ugly.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 61 +++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb03fb3..9c0a7311af0d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1064,6 +1064,9 @@ ENTRY(\sym)
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 
 	.if \paranoid
+	CFI_REMEMBER_STATE
+	testl $3, CS(%rsp)		/* If coming from userspace, switch */
+	jnz 1f				/* stacks. */
 	call save_paranoid
 	.else
 	call error_entry
@@ -1104,6 +1107,36 @@ ENTRY(\sym)
 	jmp error_exit			/* %ebx: no swapgs flag */
 	.endif
 
+	.if \paranoid
+	CFI_RESTORE_STATE
+	/*
+	 * Paranoid entry from userspace.  Switch stacks and treat it
+	 * as a normal entry.  This means that paranoid handlers
+	 * run in real process context if user_mode(regs).
+	 */
+1:
+	call error_entry
+
+	DEFAULT_FRAME 0
+
+	movq %rsp,%rdi			/* pt_regs pointer */
+	call sync_regs
+	movq %rax,%rsp			/* switch stack */
+
+	movq %rsp,%rdi			/* pt_regs pointer */
+
+	.if \has_error_code
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
+	.else
+	xorl %esi,%esi			/* no error code */
+	.endif
+
+	call \do_sym
+
+	jmp error_exit			/* %ebx: no swapgs flag */
+	.endif
+
 	CFI_ENDPROC
 END(\sym)
 .endm
@@ -1324,8 +1357,6 @@ ENTRY(paranoid_exit)
 	TRACE_IRQS_OFF_DEBUG
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz paranoid_restore
-	testl $3,CS(%rsp)
-	jnz   paranoid_userspace
 paranoid_swapgs:
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
@@ -1335,32 +1366,6 @@ paranoid_restore:
 	TRACE_IRQS_IRETQ_DEBUG 0
 	RESTORE_ALL 8
 	jmp irq_return
-paranoid_userspace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz paranoid_swapgs
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz paranoid_schedule
-	movl %ebx,%edx			/* arg3: thread flags */
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	jmp paranoid_userspace
-paranoid_schedule:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	SCHEDULE_USER
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	TRACE_IRQS_OFF
-	jmp paranoid_userspace
 	CFI_ENDPROC
 END(paranoid_exit)
 
-- 
1.9.3

