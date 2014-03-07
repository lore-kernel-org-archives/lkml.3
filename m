Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaCGXIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:08:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaCGXIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:08:07 -0500
Date: Fri, 7 Mar 2014 15:07:06 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d4078e232267ff53f3b030b9698a3c001db4dbec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jolsa@redhat.com, vincent.weaver@maine.edu,
        rostedt@goodmis.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, jolsa@redhat.com, vincent.weaver@maine.edu,
        rostedt@goodmis.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20140306145300.GO9987@twins.programming.kicks-ass.net>
References: <20140306145300.GO9987@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, trace:
  Further robustify CR2 handling vs tracing
Git-Commit-ID: d4078e232267ff53f3b030b9698a3c001db4dbec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4078e232267ff53f3b030b9698a3c001db4dbec
Gitweb:     http://git.kernel.org/tip/d4078e232267ff53f3b030b9698a3c001db4dbec
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 5 Mar 2014 14:07:49 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 6 Mar 2014 10:58:18 -0800

x86, trace: Further robustify CR2 handling vs tracing

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

Cc: <jolsa@redhat.com>
Cc: <vincent.weaver@maine.edu>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140306145300.GO9987@twins.programming.kicks-ass.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/fault.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e7fa28b..a10c8c7 100644
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
@@ -1245,31 +1249,38 @@ good_area:
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
