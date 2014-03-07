Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaCGXPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:15:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaCGXPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:15:43 -0500
Date: Fri, 7 Mar 2014 15:15:28 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-5fa10196bdb5f190f595ebd048490ee52dddea0f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, dzickus@redhat.com
In-Reply-To: <1394221143-29713-1-git-send-email-dzickus@redhat.com>
References: <1394221143-29713-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Ignore NMIs that come in during early boot
Git-Commit-ID: 5fa10196bdb5f190f595ebd048490ee52dddea0f
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

Commit-ID:  5fa10196bdb5f190f595ebd048490ee52dddea0f
Gitweb:     http://git.kernel.org/tip/5fa10196bdb5f190f595ebd048490ee52dddea0f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 7 Mar 2014 15:05:20 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 7 Mar 2014 15:08:14 -0800

x86: Ignore NMIs that come in during early boot

Don Zickus reports:

A customer generated an external NMI using their iLO to test kdump
worked.  Unfortunately, the machine hung.  Disabling the nmi_watchdog
made things work.

I speculated the external NMI fired, caused the machine to panic (as
expected) and the perf NMI from the watchdog came in and was latched.
My guess was this somehow caused the hang.

   ----

It appears that the latched NMI stays latched until the early page
table generation on 64 bits, which causes exceptions to happen which
end in IRET, which re-enable NMI.  Therefore, ignore NMIs that come in
during early execution, until we have proper exception handling.

Reported-and-tested-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1394221143-29713-1-git-send-email-dzickus@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # v3.5+, older with some backport effort
---
 arch/x86/kernel/head_32.S | 7 ++++++-
 arch/x86/kernel/head_64.S | 6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 81ba276..d2a2159 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -544,6 +544,10 @@ ENDPROC(early_idt_handlers)
 	/* This is global to keep gas from relaxing the jumps */
 ENTRY(early_idt_handler)
 	cld
+
+	cmpl $X86_TRAP_NMI,(%esp)
+	je is_nmi		# Ignore NMI
+
 	cmpl $2,%ss:early_recursion_flag
 	je hlt_loop
 	incl %ss:early_recursion_flag
@@ -594,8 +598,9 @@ ex_entry:
 	pop %edx
 	pop %ecx
 	pop %eax
-	addl $8,%esp		/* drop vector number and error code */
 	decl %ss:early_recursion_flag
+is_nmi:
+	addl $8,%esp		/* drop vector number and error code */
 	iret
 ENDPROC(early_idt_handler)
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e1aabdb..33f36c7 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -343,6 +343,9 @@ early_idt_handlers:
 ENTRY(early_idt_handler)
 	cld
 
+	cmpl $X86_TRAP_NMI,(%rsp)
+	je is_nmi		# Ignore NMI
+
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
@@ -405,8 +408,9 @@ ENTRY(early_idt_handler)
 	popq %rdx
 	popq %rcx
 	popq %rax
-	addq $16,%rsp		# drop vector number and error code
 	decl early_recursion_flag(%rip)
+is_nmi:
+	addq $16,%rsp		# drop vector number and error code
 	INTERRUPT_RETURN
 ENDPROC(early_idt_handler)
 
