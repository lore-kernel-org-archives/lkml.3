Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967041AbaCUBS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:18:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760449AbaCUADs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.13 061/149] x86: Ignore NMIs that come in during early boot
Date: Thu, 20 Mar 2014 17:03:44 -0700
Message-Id: <20140321000439.071622626@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/head_32.S |    7 ++++++-
 arch/x86/kernel/head_64.S |    6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

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
 


