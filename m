Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaJXUbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:31:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaJXUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:31:32 -0400
Date: Fri, 24 Oct 2014 13:31:16 -0700
From: tip-bot for Eric Paris <tipbot@zytor.com>
Message-ID: <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>
Cc: przanoni@gmail.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        rgb@redhat.com, hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: linux-kernel@vger.kernel.org, eparis@redhat.com, przanoni@gmail.com,
        mingo@kernel.org, hpa@linux.intel.com, tglx@linutronix.de,
        rgb@redhat.com, hpa@zytor.com
In-Reply-To: <1414037043-30647-1-git-send-email-eparis@redhat.com>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] i386/audit: stop scribbling on the stack frame
Git-Commit-ID: 26c2d2b39128adba276d140eefa2745591b88536
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

Commit-ID:  26c2d2b39128adba276d140eefa2745591b88536
Gitweb:     http://git.kernel.org/tip/26c2d2b39128adba276d140eefa2745591b88536
Author:     Eric Paris <eparis@redhat.com>
AuthorDate: Thu, 23 Oct 2014 00:04:03 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 24 Oct 2014 13:27:56 -0700

i386/audit: stop scribbling on the stack frame

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

Reported-by: Paulo Zanoni <przanoni@gmail.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Link: http://lkml.kernel.org/r/1414037043-30647-1-git-send-email-eparis@redhat.com
Cc: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/entry_32.S | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index b553ed8..344b63f 100644
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
 
