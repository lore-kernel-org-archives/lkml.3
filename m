Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaLATZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:25:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:45513 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753138AbaLATXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:09 -0500
Message-Id: <20141201192306.726148907@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 1/9] ftrace/x86: Have static tracing also use ftrace_caller_setup
References: <20141201192225.548178029@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-x86-Have-static-tracing-also-use-ftrace_calle.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Linus pointed out that there were locations that did the hard coded
update of the parent and rip parameters. One of them was the static tracer
which could also use the ftrace_caller_setup to do that work. In fact,
because it did not use it, it is prone to bugs, and since the static
tracer is hardly ever used (who wants function tracing code always being
called?) it doesn't get tested very often. I only run a few "does it still
work" tests on it. But I do not run stress tests on that code. Although,
since it is never turned off, just having it on should be stressful enough.
(especially for the performance folks)

There's no reason that the static tracer can't also use ftrace_caller_setup.
Have it do so.

Link: http://lkml.kernel.org/r/CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1411262304010.3961@nanos

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/mcount_64.S | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 6dc134b8dc70..24842c701660 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,12 +21,6 @@
 # define function_hook	mcount
 #endif
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-
-ENTRY(function_hook)
-	retq
-END(function_hook)
-
 /* skip is set if stack has been adjusted */
 .macro ftrace_caller_setup trace_label skip=0
 	MCOUNT_SAVE_FRAME \skip
@@ -47,6 +41,12 @@ GLOBAL(\trace_label)
 #endif
 .endm
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+ENTRY(function_hook)
+	retq
+END(function_hook)
+
 #ifdef CONFIG_FRAME_POINTER
 /*
  * Stack traces will stop at the ftrace trampoline if the frame pointer
@@ -207,15 +207,7 @@ GLOBAL(ftrace_stub)
 	retq
 
 trace:
-	MCOUNT_SAVE_FRAME
-
-	movq RIP(%rsp), %rdi
-#ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
-#else
-	movq 8(%rbp), %rsi
-#endif
-	subq $MCOUNT_INSN_SIZE, %rdi
+	ftrace_caller_setup ftrace_caller_op_ptr
 
 	call   *ftrace_trace_function
 
-- 
2.1.3


