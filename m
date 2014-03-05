Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaCEMyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:54:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaCEMyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:54:37 -0500
Date: Wed, 5 Mar 2014 13:54:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
Message-ID: <20140305125421.GB9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
 <20140228160526.GD1133@krava.brq.redhat.com>
 <tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
 <20140305111415.GU9987@twins.programming.kicks-ass.net>
 <20140305072022.6f69f699@gandalf.local.home>
 <20140305122535.GA9987@twins.programming.kicks-ass.net>
 <20140305073344.2f179931@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305073344.2f179931@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 07:33:44AM -0500, Steven Rostedt wrote:
> Then we better make sure that __do_page_fault() is never inlined.
> Otherwise, it wont be available to trace.
> 
> I'm fine with adding "notrace" to do_page_fault() and to
> trace_do_page_fault() as long as we also include a "noinline" to
> __do_page_fault(). Would need a comment stating why that noinline is
> there though.

When CONFIG_TRACING there's two callers, which makes it highly unlikely
GCC would inline the massive __do_page_fault() function, but sure.

How about something like so then; still has the normal_do_page_fault()
thing, although I suppose we could drop that.

It also puts trace_page_fault_entries() and trace_do_page_fault() under
CONFIG_TRACING. I could only find the entry_32.S user; I suppose the
64bit one is hidden by CPP goo somewhere?

---
 arch/x86/include/asm/traps.h |  2 +-
 arch/x86/kernel/entry_32.S   |  2 +-
 arch/x86/kernel/entry_64.S   |  2 +-
 arch/x86/kernel/kvm.c        |  2 +-
 arch/x86/mm/fault.c          | 42 +++++++++++++++++++++++++++---------------
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 58d66fe06b61..1280f72deea8 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -71,7 +71,7 @@ dotraplinkage void do_double_fault(struct pt_regs *, long);
 asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
 #endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
-dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
+dotraplinkage void normal_do_page_fault(struct pt_regs *, unsigned long);
 #ifdef CONFIG_TRACING
 dotraplinkage void trace_do_page_fault(struct pt_regs *, unsigned long);
 #endif
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f4697889..9a9f64755da8 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1257,7 +1257,7 @@ END(trace_page_fault)
 ENTRY(page_fault)
 	RING0_EC_FRAME
 	ASM_CLAC
-	pushl_cfi $do_page_fault
+	pushl_cfi $normal_do_page_fault
 	ALIGN
 error_code:
 	/* the function address is in %gs's slot on the stack */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c3628bf2..7d49812741ac 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1491,7 +1491,7 @@ zeroentry xen_int3 do_int3
 errorentry xen_stack_segment do_stack_segment
 #endif
 errorentry general_protection do_general_protection
-trace_errorentry page_fault do_page_fault
+trace_errorentry page_fault normal_do_page_fault
 #ifdef CONFIG_KVM_GUEST
 errorentry async_page_fault do_async_page_fault
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 713f1b3bad52..9e7db22ec437 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -259,7 +259,7 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
-		do_page_fault(regs, error_code);
+		normal_do_page_fault(regs, error_code);
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e7fa28bf3262..8134e5ada329 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1020,10 +1020,13 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
  * routines.
+ *
+ * This function must have noinline because both callers
+ * {normal,trace}_do_page_fault() have notrace on. Having this an actual function
+ * guarantees there's a function trace entry.
  */
-static void __kprobes
-__do_page_fault(struct pt_regs *regs, unsigned long error_code,
-		unsigned long address)
+static void __kprobes noinline
+do_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -1245,31 +1248,38 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code,
 	up_read(&mm->mmap_sem);
 }
 
-dotraplinkage void __kprobes
-do_page_fault(struct pt_regs *regs, unsigned long error_code)
+dotraplinkage void __kprobes notrace
+normal_do_page_fault(struct pt_regs *regs, unsigned long error_code)
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
-	__do_page_fault(regs, error_code, address);
+	do_page_fault(regs, error_code, address);
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
@@ -1277,9 +1287,11 @@ trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 * the faulting address now.
 	 */
 	unsigned long address = read_cr2();
+	enum ctx_state prev_state;
 
 	prev_state = exception_enter();
-	trace_page_fault_entries(regs, error_code);
-	__do_page_fault(regs, error_code, address);
+	trace_page_fault_entries(address, regs, error_code);
+	do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
+#endif
