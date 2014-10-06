Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaJFSIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:08:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42625 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaJFSH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:07:58 -0400
Date: Mon, 6 Oct 2014 11:07:42 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-8c7aa698baca5e8f1ba9edb68081f1e7a1abf455@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, anish@chelsio.com, stable@vger.kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, anish@chelsio.com, tglx@linutronix.de,
        stable@vger.kernel.org
In-Reply-To: <395749a5d39a29bd3e4b35899cf3a3c1340e5595.1412189265.git.luto@amacapital.net>
References: <395749a5d39a29bd3e4b35899cf3a3c1340e5595.1412189265.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86_64, entry:
  Filter RFLAGS.NT on entry from userspace
Git-Commit-ID: 8c7aa698baca5e8f1ba9edb68081f1e7a1abf455
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

Commit-ID:  8c7aa698baca5e8f1ba9edb68081f1e7a1abf455
Gitweb:     http://git.kernel.org/tip/8c7aa698baca5e8f1ba9edb68081f1e7a1abf455
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 1 Oct 2014 11:49:04 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 6 Oct 2014 10:53:26 -0700

x86_64, entry: Filter RFLAGS.NT on entry from userspace

The NT flag doesn't do anything in long mode other than causing IRET
to #GP.  Oddly, CPL3 code can still set NT using popf.

Entry via hardware or software interrupt clears NT automatically, so
the only relevant entries are fast syscalls.

If user code causes kernel code to run with NT set, then there's at
least some (small) chance that it could cause trouble.  For example,
user code could cause a call to EFI code with NT set, and who knows
what would happen?  Apparently some games on Wine sometimes do
this (!), and, if an IRET return happens, they will segfault.  That
segfault cannot be handled, because signal delivery fails, too.

This patch programs the CPU to clear NT on entry via SYSCALL (both
32-bit and 64-bit, by my reading of the AMD APM), and it clears NT
in software on entry via SYSENTER.

To save a few cycles, this borrows a trick from Jan Beulich in Xen:
it checks whether NT is set before trying to clear it.  As a result,
it seems to have very little effect on SYSENTER performance on my
machine.

There's another minor bug fix in here: it looks like the CFI
annotations were wrong if CONFIG_AUDITSYSCALL=n.

Testers beware: on Xen, SYSENTER with NT set turns into a GPF.

I haven't touched anything on 32-bit kernels.

The syscall mask change comes from a variant of this patch by Anish
Bhatt.

Note to stable maintainers: there is no known security issue here.
A misguided program can set NT and cause the kernel to try and fail
to deliver SIGSEGV, crashing the program.  This patch fixes Far Cry
on Wine: https://bugs.winehq.org/show_bug.cgi?id=33275

Cc: <stable@vger.kernel.org>
Reported-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/395749a5d39a29bd3e4b35899cf3a3c1340e5595.1412189265.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/ia32entry.S    | 18 +++++++++++++++++-
 arch/x86/kernel/cpu/common.c |  2 +-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb0..711de08 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -151,6 +151,16 @@ ENTRY(ia32_sysenter_target)
 1:	movl	(%rbp),%ebp
 	_ASM_EXTABLE(1b,ia32_badarg)
 	ASM_CLAC
+
+	/*
+	 * Sysenter doesn't filter flags, so we need to clear NT
+	 * ourselves.  To save a few cycles, we can check whether
+	 * NT was set instead of doing an unconditional popfq.
+	 */
+	testl $X86_EFLAGS_NT,EFLAGS(%rsp)	/* saved EFLAGS match cpu */
+	jnz sysenter_fix_flags
+sysenter_flags_fixed:
+
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
@@ -184,6 +194,8 @@ sysexit_from_sys_call:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS_SYSEXIT32
 
+	CFI_RESTORE_STATE
+
 #ifdef CONFIG_AUDITSYSCALL
 	.macro auditsys_entry_common
 	movl %esi,%r9d			/* 6th arg: 4th syscall arg */
@@ -226,7 +238,6 @@ sysexit_from_sys_call:
 	.endm
 
 sysenter_auditsys:
-	CFI_RESTORE_STATE
 	auditsys_entry_common
 	movl %ebp,%r9d			/* reload 6th syscall arg */
 	jmp sysenter_dispatch
@@ -235,6 +246,11 @@ sysexit_audit:
 	auditsys_exit sysexit_from_sys_call
 #endif
 
+sysenter_fix_flags:
+	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
+	popfq_cfi
+	jmp sysenter_flags_fixed
+
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
 	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b4..3126558 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1184,7 +1184,7 @@ void syscall_init(void)
 	/* Flags to clear on syscall */
 	wrmsrl(MSR_SYSCALL_MASK,
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
-	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
+	       X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
 }
 
 /*
