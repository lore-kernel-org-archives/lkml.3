Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab3KMUUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:20:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32629 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750810Ab3KMUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:20:06 -0500
Date: Wed, 13 Nov 2013 15:20:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] ftrace/x86: Load ftrace_ops in parameter not the
 variable holding it
Message-ID: <20131113152004.459787f9@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Function tracing callbacks expect to have the ftrace_ops that registered it
passed to them, not the address of the variable that holds the ftrace_ops
that registered it.

Use a mov instead of a lea to store the ftrace_ops into the parameter
of the function tracing callback.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S | 4 ++--
 arch/x86/kernel/entry_64.S | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f0dcb0c..15a569a 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1085,7 +1085,7 @@ ENTRY(ftrace_caller)
 	pushl $0	/* Pass NULL as regs pointer */
 	movl 4*4(%esp), %eax
 	movl 0x4(%ebp), %edx
-	leal function_trace_op, %ecx
+	movl function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
@@ -1143,7 +1143,7 @@ ENTRY(ftrace_regs_caller)
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
 	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
 	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
-	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+	movl function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
 	pushl %esp		/* Save pt_regs as 4th parameter */
 
 GLOBAL(ftrace_regs_call)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b077f4c..9ce2567 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -88,7 +88,7 @@ END(function_hook)
 	MCOUNT_SAVE_FRAME \skip
 
 	/* Load the ftrace_ops into the 3rd parameter */
-	leaq function_trace_op, %rdx
+	movq function_trace_op(%rip), %rdx
 
 	/* Load ip into the first parameter */
 	movq RIP(%rsp), %rdi
-- 
1.8.1.4

