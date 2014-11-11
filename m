Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaKKLM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:12:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaKKLLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 167/170] x86_64, entry: Filter RFLAGS.NT on entry from userspace
Date: Tue, 11 Nov 2014 11:08:46 +0000
Message-Id: <1415704129-12709-168-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 8c7aa698baca5e8f1ba9edb68081f1e7a1abf455 upstream.

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

Reported-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/395749a5d39a29bd3e4b35899cf3a3c1340e5595.1412189265.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/ia32/ia32entry.S    | 18 +++++++++++++++++-
 arch/x86/kernel/cpu/common.c |  2 +-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb05023c..711de084ab57 100644
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
index ef1b93f18ed1..ae52a082a01c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1176,7 +1176,7 @@ void syscall_init(void)
 	/* Flags to clear on syscall */
 	wrmsrl(MSR_SYSCALL_MASK,
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
-	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
+	       X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
 }
 
 /*
-- 
2.1.0

