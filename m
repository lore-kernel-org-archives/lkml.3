Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbaGSNQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:39169 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755197AbaGSNQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:13 -0400
Message-Id: <20140719131612.356750295@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 17/32] ftrace: x86: Remove check of obsolete variable function_trace_stop
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0017-ftrace-x86-Remove-check-of-obsolete-variable-functio.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

Link: http://lkml.kernel.org/r/53C54D32.6000000@zytor.com

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig            |  1 -
 arch/x86/kernel/entry_32.S  |  9 ---------
 arch/x86/kernel/mcount_64.S | 18 +-----------------
 3 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749ef0fdc..5b45e8fccaca 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,7 +54,6 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_SYSCALL_TRACEPOINTS
 	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_KVM
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dbaa23e78b36..64762c62e8a7 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1058,9 +1058,6 @@ ENTRY(mcount)
 END(mcount)
 
 ENTRY(ftrace_caller)
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	pushl %eax
 	pushl %ecx
 	pushl %edx
@@ -1092,8 +1089,6 @@ END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
 	pushf	/* push flags before compare (in cs location) */
-	cmpl $0, function_trace_stop
-	jne ftrace_restore_flags
 
 	/*
 	 * i386 does not save SS and ESP when coming from kernel.
@@ -1152,7 +1147,6 @@ GLOBAL(ftrace_regs_call)
 	popf			/* Pop flags at end (no addl to corrupt flags) */
 	jmp ftrace_ret
 
-ftrace_restore_flags:
 	popf
 	jmp  ftrace_stub
 #else /* ! CONFIG_DYNAMIC_FTRACE */
@@ -1161,9 +1155,6 @@ ENTRY(mcount)
 	cmpl $__PAGE_OFFSET, %esp
 	jb ftrace_stub		/* Paging not enabled yet? */
 
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 6b4e3c3b3d74..c73aecf10d34 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -46,10 +46,6 @@ END(function_hook)
 .endm
 
 ENTRY(ftrace_caller)
-	/* Check if tracing was disabled (quick check) */
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	ftrace_caller_setup
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
@@ -73,10 +69,6 @@ ENTRY(ftrace_regs_caller)
 	/* Save the current flags before compare (in SS location)*/
 	pushfq
 
-	/* Check if tracing was disabled (quick check) */
-	cmpl $0, function_trace_stop
-	jne  ftrace_restore_flags
-
 	/* skip=8 to skip flags saved in SS */
 	ftrace_caller_setup 8
 
@@ -131,7 +123,7 @@ GLOBAL(ftrace_regs_call)
 	popfq
 
 	jmp ftrace_return
-ftrace_restore_flags:
+
 	popfq
 	jmp  ftrace_stub
 
@@ -141,9 +133,6 @@ END(ftrace_regs_caller)
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(function_hook)
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 
@@ -182,10 +171,6 @@ END(function_hook)
 ENTRY(ftrace_graph_caller)
 	MCOUNT_SAVE_FRAME
 
-	/* Check if tracing was disabled (quick check) */
-	cmpl $0, function_trace_stop
-	jne  fgraph_skip
-
 #ifdef CC_USING_FENTRY
 	leaq SS+16(%rsp), %rdi
 	movq $0, %rdx	/* No framepointers needed */
@@ -198,7 +183,6 @@ ENTRY(ftrace_graph_caller)
 
 	call	prepare_ftrace_return
 
-fgraph_skip:
 	MCOUNT_RESTORE_FRAME
 
 	retq
-- 
2.0.1


