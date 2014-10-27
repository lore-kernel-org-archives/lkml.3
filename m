Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJ0CfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:35:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaJ0CfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:35:11 -0400
Date: Sun, 26 Oct 2014 22:34:57 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com, przanoni@gmail.com,
        mingo@kernel.org, hpa@linux.intel.com, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH] i386/audit: stop scribbling on the stack frame
Message-ID: <20141027023457.GY15532@madcap2.tricolour.ca>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>
 <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>
 <alpine.DEB.2.11.1410251034320.5308@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410251034320.5308@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit b4f0d3755c5e9cc86292d5fd78261903b4f23d4a was very very dumb.
It was writing over %esp/pt_regs semi-randomly on i686 with the expected
"system can't boot" results.  As noted in:

https://bugs.freedesktop.org/show_bug.cgi?id=85277

This patch stops fscking with pt_regs.  Instead it sets up the registers
for the call to __audit_syscall_entry in the most obvious conceivable
way.  It then does just a tiny tiny touch of magic.  We need to get what
started in PT_EDX into 0(%esp) and PT_ESI into 4(%esp).  This is as easy
as a pair of pushes using the values still in those registers.

After the call to __audit_syscall_entry all we need to do is get that
now useless junk off the stack (pair of pops) and reload %eax with the
original syscall so other stuff can keep going about it's business.

Reported-by: Paulo Zanoni <przanoni@gmail.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com

---
On 14/10/25, Thomas Gleixner wrote:
> Why are we grabbing that from the stack? AFAICT all arguments are in
> the registers still.

Right, re-arranging the instructions slightly to avoid overwriting %edx
with %ebx before needing it to push onto the stack, how does this look?

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
+	/* movl PT_ECX(%esp), %ecx	already set, a1: 3nd arg to audit */
+	/* movl PT_EAX(%esp), %eax	already set, syscall number: 1st arg to audit */
+	pushl_cfi %esi			/* a3: 5th arg */
+	pushl_cfi %edx			/* a2: 4th arg */
+	movl %ebx, %edx			/* ebx/a0: 2nd arg to audit */
 	call __audit_syscall_entry
-	pushl_cfi %ebx
+	popl_cfi %ecx /* get that remapped edx off the stack */
+	popl_cfi %ecx /* get that remapped esi off the stack */
 	movl PT_EAX(%esp),%eax		/* reload syscall number */
 	jmp sysenter_do_call
 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
