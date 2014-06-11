Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaFKUXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:23:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37577 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaFKUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:23:19 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 5/5] x86,seccomp: Add a seccomp fastpath
Date: Wed, 11 Jun 2014 13:23:02 -0700
Message-Id: <9e11cd988a0f120606e37b5e275019754e2774da.1402517933.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1402517933.git.luto@amacapital.net>
References: <cover.1402517933.git.luto@amacapital.net>
In-Reply-To: <cover.1402517933.git.luto@amacapital.net>
References: <cover.1402517933.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my VM, getpid takes about 70ns.  Before this patch, adding a
single-instruction always-accept seccomp filter added about 134ns of
overhead to getpid.  With this patch, the overhead is down to about
13ns.

I'm not really thrilled by this patch.  It has two main issues:

1. Calling into code in kernel/seccomp.c from assembly feels ugly.

2. The x86 64-bit syscall entry now has four separate code paths:
fast, seccomp only, audit only, and slow.  This kind of sucks.
Would it be worth trying to rewrite the whole thing in C with a
two-phase slow path approach like I'm using here for seccomp?

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/seccomp.h    |  4 ++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index f9e713a..feb32b2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -683,6 +683,45 @@ sysret_signal:
 	FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
 	jmp int_check_syscall_exit_work
 
+#ifdef CONFIG_SECCOMP
+	/*
+	 * Fast path for seccomp without any other slow path triggers.
+	 */
+seccomp_fastpath:
+	/* Build seccomp_data */
+	pushq %r9				/* args[5] */
+	pushq %r8				/* args[4] */
+	pushq %r10				/* args[3] */
+	pushq %rdx				/* args[2] */
+	pushq %rsi				/* args[1] */
+	pushq %rdi				/* args[0] */
+	pushq RIP-ARGOFFSET+6*8(%rsp)		/* rip */
+	pushq %rax 				/* nr and junk */
+	movl $AUDIT_ARCH_X86_64, 4(%rsp)	/* arch */
+	movq %rsp, %rdi
+	call seccomp_phase1
+	addq $8*8, %rsp
+	cmpq $1, %rax
+	ja seccomp_invoke_phase2
+	LOAD_ARGS 0  /* restore clobbered regs */
+	jb system_call_fastpath
+	jmp ret_from_sys_call
+
+seccomp_invoke_phase2:
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %rdi
+	movq %rax,%rdi
+	call seccomp_phase2
+
+	/* if seccomp says to skip, then set orig_ax to -1 and skip */
+	test %eax,%eax
+	jz 1f
+	movq $-1, ORIG_RAX(%rsp)
+1:
+	mov ORIG_RAX(%rsp), %rax		/* reload rax */
+	jmp system_call_post_trace		/* and maybe do the syscall */
+#endif
+
 #ifdef CONFIG_AUDITSYSCALL
 	/*
 	 * Fast path for syscall audit without full syscall trace.
@@ -717,6 +756,10 @@ sysret_audit:
 
 	/* Do syscall tracing */
 tracesys:
+#ifdef CONFIG_SECCOMP
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SECCOMP),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	jz seccomp_fastpath
+#endif
 #ifdef CONFIG_AUDITSYSCALL
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz auditsys
@@ -725,6 +768,8 @@ tracesys:
 	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp,%rdi
 	call syscall_trace_enter
+
+system_call_post_trace:
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
 	 * We don't reload %rax because syscall_trace_enter() returned
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 4fc7a84..d3d4c52 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -37,8 +37,8 @@ static inline int secure_computing(void)
 #define SECCOMP_PHASE1_OK	0
 #define SECCOMP_PHASE1_SKIP	1
 
-extern u32 seccomp_phase1(struct seccomp_data *sd);
-int seccomp_phase2(u32 phase1_result);
+asmlinkage __visible extern u32 seccomp_phase1(struct seccomp_data *sd);
+asmlinkage __visible int seccomp_phase2(u32 phase1_result);
 #else
 extern void secure_computing_strict(int this_syscall);
 #endif
-- 
1.9.3

