Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbbAQATw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:19:52 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34982 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbbAQATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:19:45 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3/3] x86_64,entry: Remove the syscall exit audit and schedule optimizations
Date: Fri, 16 Jan 2015 16:19:29 -0800
Message-Id: <22f2aa4a0361707a5cfb1de9d45260b39965dead.1421453410.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421453410.git.luto@amacapital.net>
References: <cover.1421453410.git.luto@amacapital.net>
In-Reply-To: <cover.1421453410.git.luto@amacapital.net>
References: <cover.1421453410.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to optimize rescheduling and audit on syscall exit.  Now
that the full slow path is reasonably fast, remove these
optimizations.  Syscall exit auditing is now handled exclusively by
syscall_trace_leave.

This adds something like 10ns to the previously optimized paths on
my computer, presumably due mostly to SAVE_REST / RESTORE_REST.

I think that we should eventually replace both the syscall and
non-paranoid interrupt exit slow paths with a pair of C functions
along the lines of the syscall entry hooks.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 52 +++++-----------------------------------------
 1 file changed, 5 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index eeab4cf8b2c9..db13655c3a2a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -361,15 +361,12 @@ system_call_fastpath:
  * Has incomplete stack frame and undefined top of stack.
  */
 ret_from_sys_call:
-	movl $_TIF_ALLWORK_MASK,%edi
-	/* edi:	flagmask */
-sysret_check:
+	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	jnz int_ret_from_sys_call_fixup	/* Go the the slow path */
+
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
-	andl %edi,%edx
-	jnz  sysret_careful
 	CFI_REMEMBER_STATE
 	/*
 	 * sysretq will re-enable interrupts:
@@ -383,49 +380,10 @@ sysret_check:
 	USERGS_SYSRET64
 
 	CFI_RESTORE_STATE
-	/* Handle reschedules */
-	/* edx:	work, edi: workmask */
-sysret_careful:
-	bt $TIF_NEED_RESCHED,%edx
-	jnc sysret_signal
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	pushq_cfi %rdi
-	SCHEDULE_USER
-	popq_cfi %rdi
-	jmp sysret_check
 
-	/* Handle a signal */
-sysret_signal:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
-#ifdef CONFIG_AUDITSYSCALL
-	bt $TIF_SYSCALL_AUDIT,%edx
-	jc sysret_audit
-#endif
-	/*
-	 * We have a signal, or exit tracing or single-step.
-	 * These all wind up with the iret return path anyway,
-	 * so just join that path right now.
-	 */
+int_ret_from_sys_call_fixup:
 	FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
-	jmp int_check_syscall_exit_work
-
-#ifdef CONFIG_AUDITSYSCALL
-	/*
-	 * Return fast path for syscall audit.  Call __audit_syscall_exit()
-	 * directly and then jump back to the fast path with TIF_SYSCALL_AUDIT
-	 * masked off.
-	 */
-sysret_audit:
-	movq RAX-ARGOFFSET(%rsp),%rsi	/* second arg, syscall return value */
-	cmpq $-MAX_ERRNO,%rsi	/* is it < -MAX_ERRNO? */
-	setbe %al		/* 1 if so, 0 if not */
-	movzbl %al,%edi		/* zero-extend that into %edi */
-	call __audit_syscall_exit
-	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
-	jmp sysret_check
-#endif	/* CONFIG_AUDITSYSCALL */
+	jmp int_ret_from_sys_call
 
 	/* Do syscall tracing */
 tracesys:
-- 
2.1.0

