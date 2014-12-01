Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaLATXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:23:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:18104 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752908AbaLATXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:08 -0500
Message-Id: <20141201192307.208107286@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [for-next][PATCH 4/9] ftrace/x86: Have save_mcount_regs store RIP in %rdi for first
 parameter
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ftrace-x86-Have-save_mcount_regs-store-RIP-in-rdi-fo.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of having save_mcount_regs store the RIP in %rdx as a temp register
to place it in the proper location of the pt_regs on the stack. Use the
%rdi register as the temp register. This lets us remove the extra store
in the ftrace_caller_setup macro.

Link: http://lkml.kernel.org/r/CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 0a693d011980..4f1b27642495 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -51,8 +51,8 @@
 	movq %r8, R8(%rsp)
 	movq %r9, R9(%rsp)
 	 /* Move RIP to its proper location */
-	movq SS+8(%rsp), %rdx
-	movq %rdx, RIP(%rsp)
+	movq SS+8(%rsp), %rdi
+	movq %rdi, RIP(%rsp)
 	.endm
 
 .macro restore_mcount_regs skip=0
@@ -75,8 +75,7 @@ GLOBAL(\trace_label)
 	/* Load the ftrace_ops into the 3rd parameter */
 	movq function_trace_op(%rip), %rdx
 
-	/* Load ip into the first parameter */
-	movq RIP(%rsp), %rdi
+	/* %rdi already has %rip from the save_mcount_regs macro */
 	subq $MCOUNT_INSN_SIZE, %rdi
 	/* Load the parent_ip into the second parameter */
 #ifdef CC_USING_FENTRY
-- 
2.1.3


