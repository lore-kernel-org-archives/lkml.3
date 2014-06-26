Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbaFZRBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:01:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757839AbaFZQ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:54 -0400
Message-Id: <20140626165851.883708348@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFA][PATCH 16/27] ftrace: x86: Remove check of obsolete variable function_trace_stop
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0016-ftrace-x86-Remove-check-of-obsolete-variable-functio.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig            |  1 -
 arch/x86/kernel/entry_32.S  |  9 ---------
 arch/x86/kernel/mcount_64.S | 18 +-----------------
 3 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fcefdda5136d..e9df49244741 100644
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
index f0da82b8e634..e352cad614d4 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1052,9 +1052,6 @@ ENTRY(mcount)
 END(mcount)
 
 ENTRY(ftrace_caller)
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
 	pushl %eax
 	pushl %ecx
 	pushl %edx
@@ -1086,8 +1083,6 @@ END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
 	pushf	/* push flags before compare (in cs location) */
-	cmpl $0, function_trace_stop
-	jne ftrace_restore_flags
 
 	/*
 	 * i386 does not save SS and ESP when coming from kernel.
@@ -1146,7 +1141,6 @@ GLOBAL(ftrace_regs_call)
 	popf			/* Pop flags at end (no addl to corrupt flags) */
 	jmp ftrace_ret
 
-ftrace_restore_flags:
 	popf
 	jmp  ftrace_stub
 #else /* ! CONFIG_DYNAMIC_FTRACE */
@@ -1155,9 +1149,6 @@ ENTRY(mcount)
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
2.0.0


