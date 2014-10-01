Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaJAEvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:51:42 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38932 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaJAEvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:51:38 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
Date: Tue, 30 Sep 2014 21:51:27 -0700
Message-Id: <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1412138935.git.luto@amacapital.net>
References: <cover.1412138935.git.luto@amacapital.net>
In-Reply-To: <cover.1412138935.git.luto@amacapital.net>
References: <cover.1412138935.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Testers beware: on Xen, SYSENTER with NT set turns into a GPF.

I haven't touched anything on 32-bit kernels.

The syscall mask change comes from a variant of this patch by Anish
Bhatt.

Cc: stable@vger.kernel.org
Reported-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/ia32/ia32entry.S    | 12 ++++++++++++
 arch/x86/kernel/cpu/common.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb05023c..44d1dd371454 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -151,6 +151,18 @@ ENTRY(ia32_sysenter_target)
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
+	jz 1f
+	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
+	popfq_cfi
+1:
+
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b42bd6f..31265580c38a 100644
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
-- 
1.9.3

