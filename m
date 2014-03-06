Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaCFOxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:53:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaCFOxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:53:22 -0500
Date: Thu, 6 Mar 2014 15:53:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH] x86: Further robustify CR2 handling vs tracing
Message-ID: <20140306145300.GO9987@twins.programming.kicks-ass.net>
References: <tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
 <20140305111415.GU9987@twins.programming.kicks-ass.net>
 <20140305072022.6f69f699@gandalf.local.home>
 <20140305122535.GA9987@twins.programming.kicks-ass.net>
 <20140305123635.GP3104@twins.programming.kicks-ass.net>
 <20140305080018.4be698f7@gandalf.local.home>
 <20140305130849.GC9987@twins.programming.kicks-ass.net>
 <53179915.40408@zytor.com>
 <20140306084050.GE9987@twins.programming.kicks-ass.net>
 <20140306060215.2a78efc2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306060215.2a78efc2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: Further robustify CR2 handling vs tracing
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 5 Mar 2014 14:07:49 +0100

Building on commit 0ac09f9f8cd1 ("x86, trace: Fix CR2 corruption when
tracing page faults") this patch addresses another few issues:

 - Now that read_cr2() is lifted into trace_do_page_fault(), we should
   pass the address to trace_page_fault_entries() to avoid it
   re-reading a potentially changed cr2.

 - Put both trace_do_page_fault() and trace_page_fault_entries() under
   CONFIG_TRACING.

 - Mark both fault entry functions {,trace_}do_page_fault() as notrace
   to avoid getting __mcount or other function entry trace callbacks
   before we've observed CR2.

 - Mark __do_page_fault() as noinline to guarantee the function tracer
   does get to see the fault.

Cc: jolsa@redhat.com
Cc: vincent.weaver@maine.edu
Cc: tglx@linutronix.de
Cc: hpa@linux.intel.com
Cc: mingo@kernel.org
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/mm/fault.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1020,8 +1020,12 @@ static inline bool smap_violation(int er
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
  * routines.
+ *
+ * This function must have noinline because both callers
+ * {,trace_}do_page_fault() have notrace on. Having this an actual function
+ * guarantees there's a function trace entry.
  */
-static void __kprobes
+static void __kprobes noinline
 __do_page_fault(struct pt_regs *regs, unsigned long error_code,
 		unsigned long address)
 {
@@ -1245,31 +1249,38 @@ __do_page_fault(struct pt_regs *regs, un
 	up_read(&mm->mmap_sem);
 }
 
-dotraplinkage void __kprobes
+dotraplinkage void __kprobes notrace
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
+	unsigned long address = read_cr2(); /* Get the faulting address */
 	enum ctx_state prev_state;
-	/* Get the faulting address: */
-	unsigned long address = read_cr2();
+
+	/*
+	 * We must have this function tagged with __kprobes, notrace and call
+	 * read_cr2() before calling anything else. To avoid calling any kind
+	 * of tracing machinery before we've observed the CR2 value.
+	 *
+	 * exception_{enter,exit}() contain all sorts of tracepoints.
+	 */
 
 	prev_state = exception_enter();
 	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
 
-static void trace_page_fault_entries(struct pt_regs *regs,
+#ifdef CONFIG_TRACING
+static void trace_page_fault_entries(unsigned long address, struct pt_regs *regs,
 				     unsigned long error_code)
 {
 	if (user_mode(regs))
-		trace_page_fault_user(read_cr2(), regs, error_code);
+		trace_page_fault_user(address, regs, error_code);
 	else
-		trace_page_fault_kernel(read_cr2(), regs, error_code);
+		trace_page_fault_kernel(address, regs, error_code);
 }
 
-dotraplinkage void __kprobes
+dotraplinkage void __kprobes notrace
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
-	enum ctx_state prev_state;
 	/*
 	 * The exception_enter and tracepoint processing could
 	 * trigger another page faults (user space callchain
@@ -1277,9 +1288,11 @@ trace_do_page_fault(struct pt_regs *regs
 	 * the faulting address now.
 	 */
 	unsigned long address = read_cr2();
+	enum ctx_state prev_state;
 
 	prev_state = exception_enter();
-	trace_page_fault_entries(regs, error_code);
+	trace_page_fault_entries(address, regs, error_code);
 	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
+#endif /* CONFIG_TRACING */
