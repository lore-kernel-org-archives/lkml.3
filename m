Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaIICox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:44:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaIICov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:44:51 -0400
Date: Mon, 8 Sep 2014 19:44:40 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-1dcf74f6edfc3a9acd84d83d8865dd9e2a3b1d1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <a3dbd267ee990110478d349f78cccfdac5497a84.1409954077.git.luto@amacapital.net>
References: <a3dbd267ee990110478d349f78cccfdac5497a84.1409954077.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/seccomp] x86_64, entry:
  Use split-phase syscall_trace_enter for 64-bit syscalls
Git-Commit-ID: 1dcf74f6edfc3a9acd84d83d8865dd9e2a3b1d1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dcf74f6edfc3a9acd84d83d8865dd9e2a3b1d1e
Gitweb:     http://git.kernel.org/tip/1dcf74f6edfc3a9acd84d83d8865dd9e2a3b1d1e
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 5 Sep 2014 15:13:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 8 Sep 2014 14:14:12 -0700

x86_64, entry: Use split-phase syscall_trace_enter for 64-bit syscalls

On KVM on my box, this reduces the overhead from an always-accept
seccomp filter from ~130ns to ~17ns.  Most of that comes from
avoiding IRET on every syscall when seccomp is enabled.

In extremely approximate hacked-up benchmarking, just bypassing IRET
saves about 80ns, so there's another 43ns of savings here from
simplifying the seccomp path.

The diffstat is also rather nice :)

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/a3dbd267ee990110478d349f78cccfdac5497a84.1409954077.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/entry_64.S | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0bd6d3c..df088bb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -478,22 +478,6 @@ sysret_signal:
 
 #ifdef CONFIG_AUDITSYSCALL
 	/*
-	 * Fast path for syscall audit without full syscall trace.
-	 * We just call __audit_syscall_entry() directly, and then
-	 * jump back to the normal fast path.
-	 */
-auditsys:
-	movq %r10,%r9			/* 6th arg: 4th syscall arg */
-	movq %rdx,%r8			/* 5th arg: 3rd syscall arg */
-	movq %rsi,%rcx			/* 4th arg: 2nd syscall arg */
-	movq %rdi,%rdx			/* 3rd arg: 1st syscall arg */
-	movq %rax,%rsi			/* 2nd arg: syscall number */
-	movl $AUDIT_ARCH_X86_64,%edi	/* 1st arg: audit arch */
-	call __audit_syscall_entry
-	LOAD_ARGS 0		/* reload call-clobbered registers */
-	jmp system_call_fastpath
-
-	/*
 	 * Return fast path for syscall audit.  Call __audit_syscall_exit()
 	 * directly and then jump back to the fast path with TIF_SYSCALL_AUDIT
 	 * masked off.
@@ -510,17 +494,25 @@ sysret_audit:
 
 	/* Do syscall tracing */
 tracesys:
-#ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	jz auditsys
-#endif
+	leaq -REST_SKIP(%rsp), %rdi
+	movq $AUDIT_ARCH_X86_64, %rsi
+	call syscall_trace_enter_phase1
+	test %rax, %rax
+	jnz tracesys_phase2		/* if needed, run the slow path */
+	LOAD_ARGS 0			/* else restore clobbered regs */
+	jmp system_call_fastpath	/*      and return to the fast path */
+
+tracesys_phase2:
 	SAVE_REST
 	FIXUP_TOP_OF_STACK %rdi
-	movq %rsp,%rdi
-	call syscall_trace_enter
+	movq %rsp, %rdi
+	movq $AUDIT_ARCH_X86_64, %rsi
+	movq %rax,%rdx
+	call syscall_trace_enter_phase2
+
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
-	 * We don't reload %rax because syscall_trace_enter() returned
+	 * We don't reload %rax because syscall_trace_entry_phase2() returned
 	 * the value it wants us to use in the table lookup.
 	 */
 	LOAD_ARGS ARGOFFSET, 1
