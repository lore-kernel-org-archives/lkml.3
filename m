Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab3EJOxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:53:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56833 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580Ab3EJOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.159934819@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [004/118] tracing: Fix stack tracer with fentry use
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit d4ecbfc49b4b1d4b597fb5ba9e4fa25d62f105c5 upstream.

When gcc 4.6 on x86 is used, the function tracer will use the new
option -mfentry which does a call to "fentry" at every function
instead of "mcount". The significance of this is that fentry is
called as the first operation of the function instead of the mcount
usage of being called after the stack.

This causes the stack tracer to show some bogus results for the size
of the last function traced, as well as showing "ftrace_call" instead
of the function. This is due to the stack frame not being set up
by the function that is about to be traced.

 # cat stack_trace
        Depth    Size   Location    (48 entries)
        -----    ----   --------
  0)     4824     216   ftrace_call+0x5/0x2f
  1)     4608     112   ____cache_alloc+0xb7/0x22d
  2)     4496      80   kmem_cache_alloc+0x63/0x12f

The 216 size for ftrace_call includes both the ftrace_call stack
(which includes the saving of registers it does), as well as the
stack size of the parent.

To fix this, if CC_USING_FENTRY is defined, then the stack_tracer
will reserve the first item in stack_dump_trace[] array when
calling save_stack_trace(), and it will fill it in with the parent ip.
Then the code will look for the parent pointer on the stack and
give the real size of the parent's stack pointer:

 # cat stack_trace
        Depth    Size   Location    (14 entries)
        -----    ----   --------
  0)     2640      48   update_group_power+0x26/0x187
  1)     2592     224   update_sd_lb_stats+0x2a5/0x4ac
  2)     2368     160   find_busiest_group+0x31/0x1f1
  3)     2208     256   load_balance+0xd9/0x662

I'm Cc'ing stable, although it's not urgent, as it only shows bogus
size for item #0, the rest of the trace is legit. It should still be
corrected in previous stable releases.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_stack.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -17,13 +17,27 @@
 
 #define STACK_TRACE_ENTRIES 500
 
+/*
+ * If fentry is used, then the function being traced will
+ * jump to fentry directly before it sets up its stack frame.
+ * We need to ignore that one and record the parent. Since
+ * the stack frame for the traced function wasn't set up yet,
+ * the stack_trace wont see the parent. That needs to be added
+ * manually to stack_dump_trace[] as the first element.
+ */
+#ifdef CC_USING_FENTRY
+# define add_func	1
+#else
+# define add_func	0
+#endif
+
 static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES+1] =
 	 { [0 ... (STACK_TRACE_ENTRIES)] = ULONG_MAX };
 static unsigned stack_dump_index[STACK_TRACE_ENTRIES];
 
 static struct stack_trace max_stack_trace = {
-	.max_entries		= STACK_TRACE_ENTRIES,
-	.entries		= stack_dump_trace,
+	.max_entries		= STACK_TRACE_ENTRIES - add_func,
+	.entries		= &stack_dump_trace[add_func],
 };
 
 static unsigned long max_stack_size;
@@ -38,7 +52,7 @@ int stack_tracer_enabled;
 static int last_stack_tracer_enabled;
 
 static inline void
-check_stack(unsigned long *stack)
+check_stack(unsigned long ip, unsigned long *stack)
 {
 	unsigned long this_size, flags;
 	unsigned long *p, *top, *start;
@@ -69,6 +83,17 @@ check_stack(unsigned long *stack)
 	save_stack_trace(&max_stack_trace);
 
 	/*
+	 * When fentry is used, the traced function does not get
+	 * its stack frame set up, and we lose the parent.
+	 * Add that one in manally. We set up save_stack_trace()
+	 * to not touch the first element in this case.
+	 */
+	if (add_func) {
+		stack_dump_trace[0] = ip;
+		max_stack_trace.nr_entries++;
+	}
+
+	/*
 	 * Now find where in the stack these are.
 	 */
 	i = 0;
@@ -124,7 +149,7 @@ stack_trace_call(unsigned long ip, unsig
 	if (per_cpu(trace_active, cpu)++ != 0)
 		goto out;
 
-	check_stack(&stack);
+	check_stack(parent_ip, &stack);
 
  out:
 	per_cpu(trace_active, cpu)--;

