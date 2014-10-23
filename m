Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaJWEEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaJWEEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:04:22 -0400
From: Eric Paris <eparis@redhat.com>
To: rgb@redhat.com
Cc: Eric Paris <eparis@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH] i386/audit: stop scribbling on the stack frame
Date: Thu, 23 Oct 2014 00:04:03 -0400
Message-Id: <1414037043-30647-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit b4f0d3755c5e9cc86292d5fd78261903b4f23d4a was very very dumb.
It was writing over %esp/pt_regs semi-randomly on i686  with the expected
"system can't boot" results.  As noted in:

https://bugs.freedesktop.org/show_bug.cgi?id=85277

This patch stops fscking with pt_regs.  Instead it sets up the registers
for the call to __audit_syscall_entry in the most obvious conceivable
way.  It then does just a tiny tiny touch of magic.  We need to get what
started in PT_EDX into 0(%esp) and PT_ESI into 4(%esp).  This is as easy
as a pair of pushes.

After the call to __audit_syscall_entry all we need to do is get that
now useless junk off the stack (pair of pops) and reload %eax with the
original syscall so other stuff can keep going about it's business.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com
---
 arch/x86/kernel/entry_32.S | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f9e3fab..fb01d22 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -447,15 +447,14 @@ sysenter_exit:
 sysenter_audit:
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
 	jnz syscall_trace_entry
-	addl $4,%esp
-	CFI_ADJUST_CFA_OFFSET -4
-	movl %esi,4(%esp)		/* 5th arg: 4th syscall arg */
-	movl %edx,(%esp)		/* 4th arg: 3rd syscall arg */
-	/* %ecx already in %ecx		   3rd arg: 2nd syscall arg */
-	movl %ebx,%edx			/* 2nd arg: 1st syscall arg */
-	/* %eax already in %eax		   1st arg: syscall number */
+	/* movl PT_EAX(%esp), %eax	already set, syscall number: 1st arg to audit */
+	movl PT_EBX(%esp), %edx		/* ebx/a0: 2nd arg to audit */
+	/* movl PT_ECX(%esp), %ecx	already set, a1: 3nd arg to audit */
+	pushl_cfi PT_ESI(%esp)		/* a3: 5th arg */
+	pushl_cfi PT_EDX+4(%esp)	/* a2: 4th arg */
 	call __audit_syscall_entry
-	pushl_cfi %ebx
+	popl_cfi %ecx /* get that remapped edx off the stack */
+	popl_cfi %ecx /* get that remapped esi off the stack */
 	movl PT_EAX(%esp),%eax		/* reload syscall number */
 	jmp sysenter_do_call
 
-- 
1.9.3

