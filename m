Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbbAOESK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:18:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:25327 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750779AbbAOESI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:18:08 -0500
Message-Id: <20150115041805.976782205@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 23:09:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        x86-ml <x86@kernel.org>
Subject: [RFC][PATCH 1/2] ftrace/jprobes/x86: Allow jprobes to be graph traced if using fentry
References: <20150115040923.755326391@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ftrace-jprobes-x86-Allow-jprobes-to-be-graph-traced-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently when a jprobe handler is called it disables function graph
tracing until the jprobe handler is complete. This means that jprobe
handlers can not be traced, nor can the functions they probe be traced
if fentry is used (the disabling happens around the time the function
graph code is called on the probed function).

If fentry is enabled, then kprobes is used on top of the ftrace
infrastructure when a probe is attached to the beginning of a function
(like jprobes are). In this special case, ftrace has more control of
what happens with the jprobe, and the jprobe can detect that it was
traced.

If the jprobe detects that it was traced by the function graph tracer
(it sees that the return address on th stack was changed to return to
"return_to_handler"), it can return to a fixup function in ftrace that
would allow it to fix the skipped return that it did by calling
jprobe_return().

The solution is two fold. One is to simply add notrace to the
jprobe_return(), as there's no reason to trace it as it is only
a hack for jprobes. The other is to have jprobes detect this in
the breakpoint handler itself. If it sees that the return address
was replaced by the function graph tracer's return_to_handler
hook, it will then call an ftrace helper function that updates
the ftrace return stack data, and will have the regs->ip return
to a fixup_jprobe() handler. When it returns, the handler
will perform the final fixes and return back to the function call.

Note, the function attached to the jprobe may still not be traced
if it is filtered by the function graph tracer, as the regs->ip
is still modified by the jprobe code before it reaches the function
graph code, and it may not match the graph filtered functions.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h    |  3 ++
 arch/x86/include/asm/kprobes.h   |  9 ++++++
 arch/x86/kernel/kprobes/core.c   | 65 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/kprobes/ftrace.c | 12 ++++++++
 arch/x86/kernel/mcount_64.S      | 24 ++++++++++++++-
 5 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index f45acad3c4b6..bfabbb44797f 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -35,6 +35,9 @@ struct dyn_arch_ftrace {
 
 int ftrace_int3_handler(struct pt_regs *regs);
 
+/* Used to keep jprobes from messing with function graph tracing */
+void fixup_jprobe(void);
+
 #define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
 
 #endif /*  CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 4421b5da409d..d4e3d221b896 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -117,4 +117,13 @@ extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 extern int kprobe_int3_handler(struct pt_regs *regs);
 extern int kprobe_debug_handler(struct pt_regs *regs);
+
+/*
+ * If fentry is being used, then it's OK to function graph trace
+ * jprobes, as it is implented on top of the ftrace infrastructure.
+ */
+#if defined(CC_USING_FENTRY) && defined(CONFIG_FUNCTION_GRAPH_TRACER)
+# define ALLOW_JPROBE_GRAPH_TRACER
+#endif
+
 #endif /* _ASM_X86_KPROBES_H */
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 98f654d466e5..971c3803f283 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1021,19 +1021,22 @@ int setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	trace_hardirqs_off();
 	regs->ip = (unsigned long)(jp->entry);
 
+#ifndef ALLOW_JPROBE_GRAPH_TRACER
 	/*
 	 * jprobes use jprobe_return() which skips the normal return
 	 * path of the function, and this messes up the accounting of the
 	 * function graph tracer to get messed up.
 	 *
 	 * Pause function graph tracing while performing the jprobe function.
+	 * Unless we allow for jprobes to be traced.
 	 */
 	pause_graph_tracing();
+#endif
 	return 1;
 }
 NOKPROBE_SYMBOL(setjmp_pre_handler);
 
-void jprobe_return(void)
+void notrace jprobe_return(void)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
@@ -1072,8 +1075,68 @@ int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 			show_regs(regs);
 			BUG();
 		}
+/*
+ * When using fentry (which is not yet used by i386), the jprobe handlers
+ * may use the ftrace infrastructure to implement the calling of the kprobe
+ * (and jprobe) handlers. The jprobe pre handler copies the stack frame and
+ * changes the ip address to call the jprobe callback. The callback calls
+ * jprobe_return() which does an int3 breakpoint to call the jprobe breakpiont
+ * handler which will put back the stack frame and set the regs->ip back to the
+ * originally traced function.
+ *
+ * The problem is, the stack frame can be changed by the function graph tracer
+ * to have it call return_to_handler() that does the tracing of the function
+ * when it returns. The jprobe would swap back the original stack frame
+ * and lose the update. That would in turn, cause the accounting of the
+ * stack frames in ret_stack to get messed up, which is used to put back the
+ * stack frames that were replaced. The result is that the stack frame
+ * would get the wrong value and cause the function to return to the wrong
+ * place which is most definitely followed by a function oops.
+ *
+ * To make things worse, the jprobe callback return value never gets
+ * called due to it using jprobe_return() instead of return.
+ */
+#ifdef ALLOW_JPROBE_GRAPH_TRACER
+		/*
+		 * If function graph tracing traced the function that the
+		 * jprobe attached to, then the function graph tracing
+		 * would have changed the stack return address to point to
+		 * "return_to_handler". If this is the case, then we need to
+		 * do a bit more work in order to not mess up the function
+		 * graph tracer.
+		 */
+		if (*(void **)saved_sp == return_to_handler) {
+			/*
+			 * The current->ret_stack still has the jprobe callback
+			 * in its list. It can not be removed until we are
+			 * at the function frame that set it (when going back
+			 * to regs->ip). Set the ip to the fixup_jprobe
+			 * trampoline, and the stack to the address that was
+			 * saved by the function graph trace. The fixup_jprobe
+			 * will be able to pop the ret_stack for the jprobe
+			 * handler.
+			 */
+			kcb->jprobe_saved_regs.ip = (unsigned long)fixup_jprobe;
+			/*
+			 * Since we are not returning back to the function
+			 * that was probed, the fixup_jprobe needs a way
+			 * to know what to jump back to. Store that in the
+			 * r10 register which callee functions are allowed
+			 * to clobber. Since r10 can be clobbered by the callee,
+			 * the caller must save it if necessary. As the callee
+			 * (probed function) has not been executed yet, the
+			 * value for r10 currently is not important.
+			 *
+			 * Note, as this only happens with fentry which is
+			 * not supported (yet) by i386, we can use the r10
+			 * field directly here.
+			 */
+			kcb->jprobe_saved_regs.r10 = (unsigned long)p->addr;
+		}
+#else
 		/* It's OK to start function graph tracing again */
 		unpause_graph_tracing();
+#endif
 		*regs = kcb->jprobe_saved_regs;
 		memcpy(saved_sp, kcb->jprobes_stack, MIN_STACK_SIZE(saved_sp));
 		preempt_enable_no_resched();
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 5f8f0b3cc674..0fd23d19ed66 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -29,6 +29,18 @@ static nokprobe_inline
 int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 		      struct kprobe_ctlblk *kcb, unsigned long orig_ip)
 {
+#ifdef ALLOW_JPROBE_GRAPH_TRACER
+	/*
+	 * If the function graph tracer traced the jprobe entry then
+	 * the ip address would be set to fixup_jprobe, and we do
+	 * not want to modify that (and we expect that orig_ip to be
+	 * zero in this case as well). Make sure that the regs->ip
+	 * is set back to fixup_jprobe on exit.
+	 */
+	if (!orig_ip && regs->ip == (unsigned long)fixup_jprobe)
+		orig_ip = regs->ip;
+#endif
+
 	/*
 	 * Emulate singlestep (and also recover regs->ip)
 	 * as if there is a 5byte nop
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 94ea120fa21f..fe3ccc99530d 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -323,4 +323,26 @@ GLOBAL(return_to_handler)
 	movq (%rsp), %rax
 	addq $24, %rsp
 	jmp *%rdi
-#endif
+
+/*
+ * A jprobe that is traced or the function it traces is traced, then
+ * it needs to have a special verson of return_to_handler that it
+ * gets set from longjmp_break_handler(). This is because the jprobe
+ * callback is not returning to the function that called it, but instead
+ * it is returning to the function it probed.
+ */
+ENTRY(fixup_jprobe)
+	/* longjmp_break_handler() placed the probed function into r10 */
+	addq $MCOUNT_INSN_SIZE, %r10
+	pushq %r10
+	save_mcount_regs
+	/* No need to check frames here */
+	movq $0, %rdi
+	call ftrace_return_to_handler
+	/* Put the return address back to its proper place */
+	movq %rax, MCOUNT_REG_SIZE+8(%rsp)
+	restore_mcount_regs
+	retq
+END(fixup_jprobe)
+
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
2.1.4


