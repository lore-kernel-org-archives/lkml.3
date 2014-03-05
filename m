Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaCENII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:08:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51311 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaCENIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:08:05 -0500
Date: Wed, 5 Mar 2014 14:07:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
Message-ID: <20140305130749.GR3104@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
 <20140228160526.GD1133@krava.brq.redhat.com>
 <tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
 <20140305111415.GU9987@twins.programming.kicks-ass.net>
 <20140305072022.6f69f699@gandalf.local.home>
 <20140305122535.GA9987@twins.programming.kicks-ass.net>
 <20140305073344.2f179931@gandalf.local.home>
 <20140305125421.GB9987@twins.programming.kicks-ass.net>
 <20140305130224.GQ3104@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305130224.GQ3104@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 02:02:24PM +0100, Peter Zijlstra wrote:
> > It also puts trace_page_fault_entries() and trace_do_page_fault() under
> > CONFIG_TRACING. I could only find the entry_32.S user; I suppose the
> > 64bit one is hidden by CPP goo somewhere?
> 
> > +trace_errorentry page_fault normal_do_page_fault
> 
> ah found it; its in there. That also means the normal_do_page_fault()
> thing won't actually compile proper.
> 
> Lemme do one with that.

---
 arch/x86/mm/fault.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e7fa28bf3262..a10c8c792161 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1020,8 +1020,12 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
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
@@ -1245,31 +1249,38 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code,
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
@@ -1277,9 +1288,11 @@ trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
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
