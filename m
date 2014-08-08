Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaHHRp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:45:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbaHHRpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:45:54 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 13/17] x86: ia32entry.S: fold IA32_ARG_FIXUP macro into its callers
Date: Fri,  8 Aug 2014 19:44:36 +0200
Message-Id: <1407519880-6719-14-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of a small macro - one with conditional expansion - does more harm
than good. It obfuscates code, with minimal code reuse.

For example, because of obfuscation it's not obvious that
in ia32_sysenter_target, we can optimize loading of r9 -
currently it is loaded with a detour through ebp.

This patch folds IA32_ARG_FIXUP macro into its callers.

No code changes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
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
 arch/x86/ia32/ia32entry.S | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 8cd08de..c70c9a0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -30,17 +30,6 @@
 
 	.section .entry.text, "ax"
 
-	.macro IA32_ARG_FIXUP noebp=0
-	movl	%edi,%r8d
-	.if \noebp
-	.else
-	movl	%ebp,%r9d
-	.endif
-	xchg	%ecx,%esi
-	movl	%ebx,%edi
-	movl	%edx,%edx	/* zero extension */
-	.endm 
-
 	/* clobbers %rax */
 	.macro  CLEAR_RREGS _r9=rax
 	xorl 	%eax,%eax
@@ -167,7 +156,12 @@ ENTRY(ia32_sysenter_target)
 	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	ia32_badsys
 sysenter_do_call:
-	IA32_ARG_FIXUP
+	/* 32bit syscall -> 64bit C ABI argument conversion */
+	movl	%edi,%r8d	/* arg5 */
+	movl	%ebp,%r9d	/* arg6 */
+	xchg	%ecx,%esi	/* rsi:arg2, rcx:arg4 */
+	movl	%ebx,%edi	/* arg1 */
+	movl	%edx,%edx	/* arg3 (zero extension) */
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX(%rsp)
@@ -343,7 +337,12 @@ ENTRY(ia32_cstar_target)
 	cmpq $IA32_NR_syscalls-1,%rax
 	ja  ia32_badsys
 cstar_do_call:
-	IA32_ARG_FIXUP 1
+	/* 32bit syscall -> 64bit C ABI argument conversion */
+	movl	%edi,%r8d	/* arg5 */
+	/* r9 already loaded */	/* arg6 */
+	xchg	%ecx,%esi	/* rsi:arg2, rcx:arg4 */
+	movl	%ebx,%edi	/* arg1 */
+	movl	%edx,%edx	/* arg3 (zero extension) */
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
 	movq %rax,RAX(%rsp)
@@ -460,7 +459,12 @@ ENTRY(ia32_syscall)
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 ia32_do_call:
-	IA32_ARG_FIXUP
+	/* 32bit syscall -> 64bit C ABI argument conversion */
+	movl %edi,%r8d	/* arg5 */
+	movl %ebp,%r9d	/* arg6 */
+	xchg %ecx,%esi	/* rsi:arg2, rcx:arg4 */
+	movl %ebx,%edi	/* arg1 */
+	movl %edx,%edx	/* arg3 (zero extension) */
 	call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
 ia32_sysret:
 	movq %rax,RAX(%rsp)
-- 
1.8.1.4

