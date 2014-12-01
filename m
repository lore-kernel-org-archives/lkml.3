Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaLATX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:23:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26412 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754026AbaLATXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:10 -0500
Message-Id: <20141201192308.013051967@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 9/9] ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first
 parameter
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0009-ftrace-fgraph-x86-Have-prepare_ftrace_return-take-ip.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function graph helper function prepare_ftrace_return() which does the work
to hijack the parent pointer has that parent pointer as its first parameter.
Instead, if we make it the second parameter and have ip as the first parameter
(self_addr), then it can use the %rdi from save_mcount_regs that loads it
already.

Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c    |  4 ++--
 arch/x86/kernel/mcount_64.S | 11 ++++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 60881d919432..2142376dc8c6 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -871,7 +871,7 @@ static void *addr_from_call(void *ptr)
 	return ptr + MCOUNT_INSN_SIZE + calc.offset;
 }
 
-void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 			   unsigned long frame_pointer);
 
 /*
@@ -964,7 +964,7 @@ int ftrace_disable_ftrace_graph_caller(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
-void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 			   unsigned long frame_pointer)
 {
 	unsigned long old;
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index ddc766efa1f1..94ea120fa21f 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -124,7 +124,7 @@
 	/*
 	 * Now %rdi (the first parameter) has the return address of
 	 * where ftrace_call returns. But the callbacks expect the
-	 * the address of the call itself.
+	 * address of the call itself.
 	 */
 	subq $MCOUNT_INSN_SIZE, %rdi
 	.endm
@@ -289,21 +289,18 @@ END(function_hook)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	/* Saves rbp into %rdx */
+	/* Saves rbp into %rdx and fills first parameter  */
 	save_mcount_regs
 
 #ifdef CC_USING_FENTRY
-	leaq MCOUNT_REG_SIZE+8(%rsp), %rdi
+	leaq MCOUNT_REG_SIZE+8(%rsp), %rsi
 	movq $0, %rdx	/* No framepointers needed */
 #else
 	/* Save address of the return address of traced function */
-	leaq 8(%rdx), %rdi
+	leaq 8(%rdx), %rsi
 	/* ftrace does sanity checks against frame pointers */
 	movq (%rdx), %rdx
 #endif
-	movq RIP(%rsp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rsi
-
 	call	prepare_ftrace_return
 
 	restore_mcount_regs
-- 
2.1.3


