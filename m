Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbbAOESd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:18:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:49836 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751750AbbAOESV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:18:21 -0500
Message-Id: <20150115041806.128955813@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 23:09:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        x86-ml <x86@kernel.org>
Subject: [RFC][PATCH 2/2] ftrace/jprobes/x86: Have function being probed be graph traced
References: <20150115040923.755326391@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-ftrace-jprobes-x86-Have-function-being-probed-be-gra.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Because jprobes replaces the stack frame to call the jprobe handler with
the function arguments, if kprobes/jprobes uses ftrace (fentry)
infrastructure for its implementation, it messes with the tracing of
the function graph tracer.

The jprobe gets set up from the ftrace fentry trampoline and it
changes the regs->ip from the called function to call the jprobe
handler. The function graph tracing happens after the function
tracing and the function graph will see the jprobe ip address
instead of the function that was called. If the functions were
filtered, the jprobe ip address would not match what it expected
to see, and the graph tracer will not trace the function.

Add a new trampoline called ftrace_trace_addr that jprobes always
calls if the jprobe itself was not traced, and kprobes uses the
ftrace (fentry) infrastructure. The ftrace_trace_addr will reset
the ip address with the function that was probed and recall the
ftrace_graph_caller.

In case the jprobe itself was traced, the fixup_jprobe will call
ftrace_graph_caller.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h    |  1 +
 arch/x86/kernel/kprobes/core.c   | 33 ++++++++++++++++++++-------------
 arch/x86/kernel/kprobes/ftrace.c |  4 +++-
 arch/x86/kernel/mcount_64.S      | 14 +++++++++++++-
 4 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index bfabbb44797f..d725c816ea05 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -37,6 +37,7 @@ int ftrace_int3_handler(struct pt_regs *regs);
 
 /* Used to keep jprobes from messing with function graph tracing */
 void fixup_jprobe(void);
+void ftrace_trace_addr(void);
 
 #define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
 
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 971c3803f283..fd6d91a85e3b 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1098,6 +1098,22 @@ int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
  */
 #ifdef ALLOW_JPROBE_GRAPH_TRACER
 		/*
+		 * Since we are not returning back to the function
+		 * that was probed, the fixup_jprobe and ftrace_trace_addr
+		 * needs a way to know what to jump back to. Store that in the
+		 * r10 register, which callee functions are allowed
+		 * to clobber. Since r10 can be clobbered by the callee,
+		 * the caller must save it if necessary. As the callee
+		 * (probed function) has not been executed yet, the
+		 * value for r10 currently is not important.
+		 *
+		 * Note, as this only happens with fentry which is
+		 * not supported (yet) by i386, we can use the r10
+		 * field directly here.
+		 */
+		kcb->jprobe_saved_regs.r10 = (unsigned long)p->addr;
+
+		/*
 		 * If function graph tracing traced the function that the
 		 * jprobe attached to, then the function graph tracing
 		 * would have changed the stack return address to point to
@@ -1117,21 +1133,12 @@ int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 			 * handler.
 			 */
 			kcb->jprobe_saved_regs.ip = (unsigned long)fixup_jprobe;
+		} else {
 			/*
-			 * Since we are not returning back to the function
-			 * that was probed, the fixup_jprobe needs a way
-			 * to know what to jump back to. Store that in the
-			 * r10 register which callee functions are allowed
-			 * to clobber. Since r10 can be clobbered by the callee,
-			 * the caller must save it if necessary. As the callee
-			 * (probed function) has not been executed yet, the
-			 * value for r10 currently is not important.
-			 *
-			 * Note, as this only happens with fentry which is
-			 * not supported (yet) by i386, we can use the r10
-			 * field directly here.
+			 * See if function graph tracing is enabled and
+			 * trace this function if necessary.
 			 */
-			kcb->jprobe_saved_regs.r10 = (unsigned long)p->addr;
+			kcb->jprobe_saved_regs.ip = ftrace_trace_addr;
 		}
 #else
 		/* It's OK to start function graph tracing again */
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 0fd23d19ed66..317377f1df26 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -37,7 +37,9 @@ int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 	 * zero in this case as well). Make sure that the regs->ip
 	 * is set back to fixup_jprobe on exit.
 	 */
-	if (!orig_ip && regs->ip == (unsigned long)fixup_jprobe)
+	if (!orig_ip &&
+	    (regs->ip == (unsigned long)fixup_jprobe ||
+	     regs->ip == (unsigned long)ftrace_trace_addr))
 		orig_ip = regs->ip;
 #endif
 
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index fe3ccc99530d..b6caf6d1e10e 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -333,7 +333,6 @@ GLOBAL(return_to_handler)
  */
 ENTRY(fixup_jprobe)
 	/* longjmp_break_handler() placed the probed function into r10 */
-	addq $MCOUNT_INSN_SIZE, %r10
 	pushq %r10
 	save_mcount_regs
 	/* No need to check frames here */
@@ -341,8 +340,21 @@ ENTRY(fixup_jprobe)
 	call ftrace_return_to_handler
 	/* Put the return address back to its proper place */
 	movq %rax, MCOUNT_REG_SIZE+8(%rsp)
+	movq MCOUNT_REG_SIZE(%rsp), %rdi
+	leaq MCOUNT_REG_SIZE+8(%rsp), %rsi
+	movq $0, %rdx	/* No framepointers needed */
+	call prepare_ftrace_return
 	restore_mcount_regs
+	/* Skip over the fentry call */
+	addq $MCOUNT_INSN_SIZE, 0(%rsp)
 	retq
 END(fixup_jprobe)
 
+ENTRY(ftrace_trace_addr)
+	/* longjmp_break_handler() saved our return address in r10 */
+	pushq %r10
+	addq $MCOUNT_INSN_SIZE, 0(%rsp)
+	jmp ftrace_graph_caller
+END(ftrace_trace_addr)
+
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
2.1.4


