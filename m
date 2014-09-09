Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaIICok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:44:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34643 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbaIICoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:44:38 -0400
Date: Mon, 8 Sep 2014 19:44:27 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-54eea9957f5763dd1a2555d7e4cb53b4dd389cc6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <01218b493f12ae2f98034b78c9ae085e38e94350.1409954077.git.luto@amacapital.net>
References: <01218b493f12ae2f98034b78c9ae085e38e94350.1409954077.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/seccomp] x86_64, entry: Treat regs->
 ax the same in fastpath and slowpath syscalls
Git-Commit-ID: 54eea9957f5763dd1a2555d7e4cb53b4dd389cc6
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

Commit-ID:  54eea9957f5763dd1a2555d7e4cb53b4dd389cc6
Gitweb:     http://git.kernel.org/tip/54eea9957f5763dd1a2555d7e4cb53b4dd389cc6
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 5 Sep 2014 15:13:55 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 8 Sep 2014 14:14:08 -0700

x86_64, entry: Treat regs->ax the same in fastpath and slowpath syscalls

For slowpath syscalls, we initialize regs->ax to -ENOSYS and stick
the syscall number into regs->orig_ax prior to any possible tracing
and syscall execution.  This is user-visible ABI used by ptrace
syscall emulation and seccomp.

For fastpath syscalls, there's no good reason not to do the same
thing.  It's even slightly simpler than what we're currently doing.
It probably has no measureable performance impact.  It should have
no user-visible effect.

The purpose of this patch is to prepare for two-phase syscall
tracing, in which the first phase might modify the saved RAX without
leaving the fast path.  This change is just subtle enough that I'm
keeping it separate.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/01218b493f12ae2f98034b78c9ae085e38e94350.1409954077.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/calling.h |  6 +++++-
 arch/x86/kernel/entry_64.S     | 13 ++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index cb4c73b..76659b6 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -85,7 +85,7 @@ For 32-bit we have the following conventions - kernel is built with
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
 
-	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
+	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1, rax_enosys=0
 	subq  $9*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
 	movq_cfi rdi, 8*8
@@ -96,7 +96,11 @@ For 32-bit we have the following conventions - kernel is built with
 	movq_cfi rcx, 5*8
 	.endif
 
+	.if \rax_enosys
+	movq $-ENOSYS, 4*8(%rsp)
+	.else
 	movq_cfi rax, 4*8
+	.endif
 
 	.if \save_r891011
 	movq_cfi r8,  3*8
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 2fac134..0bd6d3c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -404,8 +404,8 @@ GLOBAL(system_call_after_swapgs)
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,0
-	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
+	SAVE_ARGS 8, 0, rax_enosys=1
+	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
@@ -417,7 +417,7 @@ system_call_fastpath:
 	andl $__SYSCALL_MASK,%eax
 	cmpl $__NR_syscall_max,%eax
 #endif
-	ja badsys
+	ja ret_from_sys_call  /* and return regs->ax */
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
 	movq %rax,RAX-ARGOFFSET(%rsp)
@@ -476,10 +476,6 @@ sysret_signal:
 	FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
 	jmp int_check_syscall_exit_work
 
-badsys:
-	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
-	jmp ret_from_sys_call
-
 #ifdef CONFIG_AUDITSYSCALL
 	/*
 	 * Fast path for syscall audit without full syscall trace.
@@ -519,7 +515,6 @@ tracesys:
 	jz auditsys
 #endif
 	SAVE_REST
-	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
 	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp,%rdi
 	call syscall_trace_enter
@@ -536,7 +531,7 @@ tracesys:
 	andl $__SYSCALL_MASK,%eax
 	cmpl $__NR_syscall_max,%eax
 #endif
-	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
+	ja   int_ret_from_sys_call	/* RAX(%rsp) is already set */
 	movq %r10,%rcx	/* fixup for C */
 	call *sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
