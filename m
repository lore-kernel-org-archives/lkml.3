Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaDALR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaDALRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/144] x86: Ignore NMIs that come in during early boot
Date: Tue,  1 Apr 2014 12:14:28 +0100
Message-Id: <1396350948-29910-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 5fa10196bdb5f190f595ebd048490ee52dddea0f upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/head_32.S | 7 ++++++-
 arch/x86/kernel/head_64.S | 6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 5dd87a8..4268023 100644
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
 
-- 
1.9.1

