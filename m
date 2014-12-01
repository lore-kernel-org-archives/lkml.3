Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaLATYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:24:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:45513 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753643AbaLATXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:09 -0500
Message-Id: <20141201192306.905584317@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 2/9] ftrace/x86: Move MCOUNT_SAVE_FRAME out of header file
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftrace-x86-Move-MCOUNT_SAVE_FRAME-out-of-header-file.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Linus pointed out that MCOUNT_SAVE_FRAME is used in only a single file
and that there's no reason that it should be in a header file.
Move the macro to the code that uses it.

Link: http://lkml.kernel.org/r/CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h | 33 ---------------------------------
 arch/x86/kernel/mcount_64.S   | 29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index e1f7fecaa7d6..f45acad3c4b6 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -1,39 +1,6 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
-#ifdef __ASSEMBLY__
-
-	/* skip is set if the stack was already partially adjusted */
-	.macro MCOUNT_SAVE_FRAME skip=0
-	 /*
-	  * We add enough stack to save all regs.
-	  */
-	subq $(SS+8-\skip), %rsp
-	movq %rax, RAX(%rsp)
-	movq %rcx, RCX(%rsp)
-	movq %rdx, RDX(%rsp)
-	movq %rsi, RSI(%rsp)
-	movq %rdi, RDI(%rsp)
-	movq %r8, R8(%rsp)
-	movq %r9, R9(%rsp)
-	 /* Move RIP to its proper location */
-	movq SS+8(%rsp), %rdx
-	movq %rdx, RIP(%rsp)
-	.endm
-
-	.macro MCOUNT_RESTORE_FRAME skip=0
-	movq R9(%rsp), %r9
-	movq R8(%rsp), %r8
-	movq RDI(%rsp), %rdi
-	movq RSI(%rsp), %rsi
-	movq RDX(%rsp), %rdx
-	movq RCX(%rsp), %rcx
-	movq RAX(%rsp), %rax
-	addq $(SS+8-\skip), %rsp
-	.endm
-
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CC_USING_FENTRY
 # define MCOUNT_ADDR		((long)(__fentry__))
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 24842c701660..94fe46725fe0 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,6 +21,35 @@
 # define function_hook	mcount
 #endif
 
+/* skip is set if the stack was already partially adjusted */
+.macro MCOUNT_SAVE_FRAME skip=0
+	 /*
+	  * We add enough stack to save all regs.
+	  */
+	subq $(SS+8-\skip), %rsp
+	movq %rax, RAX(%rsp)
+	movq %rcx, RCX(%rsp)
+	movq %rdx, RDX(%rsp)
+	movq %rsi, RSI(%rsp)
+	movq %rdi, RDI(%rsp)
+	movq %r8, R8(%rsp)
+	movq %r9, R9(%rsp)
+	 /* Move RIP to its proper location */
+	movq SS+8(%rsp), %rdx
+	movq %rdx, RIP(%rsp)
+	.endm
+
+.macro MCOUNT_RESTORE_FRAME skip=0
+	movq R9(%rsp), %r9
+	movq R8(%rsp), %r8
+	movq RDI(%rsp), %rdi
+	movq RSI(%rsp), %rsi
+	movq RDX(%rsp), %rdx
+	movq RCX(%rsp), %rcx
+	movq RAX(%rsp), %rax
+	addq $(SS+8-\skip), %rsp
+	.endm
+
 /* skip is set if stack has been adjusted */
 .macro ftrace_caller_setup trace_label skip=0
 	MCOUNT_SAVE_FRAME \skip
-- 
2.1.3


