Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaLATXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:23:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26412 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbaLATXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:08 -0500
Message-Id: <20141201192307.365034599@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 5/9] ftrace/x86: Simplify save_mcount_regs on getting RIP
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-ftrace-x86-Simplify-save_mcount_regs-on-getting-RIP.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently save_mcount_regs is passed a "skip" parameter to know how much
stack updated the pt_regs, as it tries to keep the saved pt_regs in the
same location for all users. This is rather stupid, especially since the
part stored on the pt_regs has nothing to do with what is suppose to be
in that location.

Instead of doing that, just pass in an "added" parameter that lets that
macro know how much stack was added before it was called so that it
can get to the RIP.  But the difference is that it will now offset the
pt_regs by that "added" count. The caller now needs to take care of
the offset of the pt_regs.

This will make it easier to simplify the code later.

Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 4f1b27642495..596ac330c1db 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -37,12 +37,12 @@
  * be saved in the locations that pt_regs has them in.
  */
 
-/* skip is set if the stack was already partially adjusted */
-.macro save_mcount_regs skip=0
+/* @added: the amount of stack added before calling this */
+.macro save_mcount_regs added=0
 	 /*
 	  * We add enough stack to save all regs.
 	  */
-	subq $(SS+8-\skip), %rsp
+	subq $(SS+8), %rsp
 	movq %rax, RAX(%rsp)
 	movq %rcx, RCX(%rsp)
 	movq %rdx, RDX(%rsp)
@@ -51,11 +51,11 @@
 	movq %r8, R8(%rsp)
 	movq %r9, R9(%rsp)
 	 /* Move RIP to its proper location */
-	movq SS+8(%rsp), %rdi
+	movq SS+8+\added(%rsp), %rdi
 	movq %rdi, RIP(%rsp)
 	.endm
 
-.macro restore_mcount_regs skip=0
+.macro restore_mcount_regs
 	movq R9(%rsp), %r9
 	movq R8(%rsp), %r8
 	movq RDI(%rsp), %rdi
@@ -63,12 +63,12 @@
 	movq RDX(%rsp), %rdx
 	movq RCX(%rsp), %rcx
 	movq RAX(%rsp), %rax
-	addq $(SS+8-\skip), %rsp
+	addq $(SS+8), %rsp
 	.endm
 
 /* skip is set if stack has been adjusted */
-.macro ftrace_caller_setup trace_label skip=0
-	save_mcount_regs \skip
+.macro ftrace_caller_setup trace_label added=0
+	save_mcount_regs \added
 
 	/* Save this location */
 GLOBAL(\trace_label)
@@ -79,9 +79,9 @@ GLOBAL(\trace_label)
 	subq $MCOUNT_INSN_SIZE, %rdi
 	/* Load the parent_ip into the second parameter */
 #ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
+	movq SS+16+\added(%rsp), %rsi
 #else
-	movq 8(%rbp), %rsi
+	movq 8+\added(%rbp), %rsi
 #endif
 .endm
 
@@ -156,10 +156,10 @@ GLOBAL(ftrace_stub)
 END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
-	/* Save the current flags before compare (in SS location)*/
+	/* Save the current flags before any operations that can change them */
 	pushfq
 
-	/* skip=8 to skip flags saved in SS */
+	/* added 8 bytes to save flags */
 	ftrace_caller_setup ftrace_regs_caller_op_ptr 8
 
 	/* Save the rest of pt_regs */
@@ -172,15 +172,15 @@ ENTRY(ftrace_regs_caller)
 	movq %rbp, RBP(%rsp)
 	movq %rbx, RBX(%rsp)
 	/* Copy saved flags */
-	movq SS(%rsp), %rcx
+	movq SS+8(%rsp), %rcx
 	movq %rcx, EFLAGS(%rsp)
 	/* Kernel segments */
 	movq $__KERNEL_DS, %rcx
 	movq %rcx, SS(%rsp)
 	movq $__KERNEL_CS, %rcx
 	movq %rcx, CS(%rsp)
-	/* Stack - skipping return address */
-	leaq SS+16(%rsp), %rcx
+	/* Stack - skipping return address and flags */
+	leaq SS+8*3(%rsp), %rcx
 	movq %rcx, RSP(%rsp)
 
 	/* regs go into 4th parameter */
@@ -195,11 +195,11 @@ GLOBAL(ftrace_regs_call)
 
 	/* Copy flags back to SS, to restore them */
 	movq EFLAGS(%rsp), %rax
-	movq %rax, SS(%rsp)
+	movq %rax, SS+8(%rsp)
 
 	/* Handlers can change the RIP */
 	movq RIP(%rsp), %rax
-	movq %rax, SS+8(%rsp)
+	movq %rax, SS+8*2(%rsp)
 
 	/* restore the rest of pt_regs */
 	movq R15(%rsp), %r15
@@ -210,8 +210,7 @@ GLOBAL(ftrace_regs_call)
 	movq RBP(%rsp), %rbp
 	movq RBX(%rsp), %rbx
 
-	/* skip=8 to skip flags saved in SS */
-	restore_mcount_regs 8
+	restore_mcount_regs
 
 	/* Restore flags */
 	popfq
-- 
2.1.3


