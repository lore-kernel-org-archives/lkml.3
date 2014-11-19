Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbaKSXcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:32:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:10043 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754766AbaKSX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:12 -0500
Message-Id: <20141119232709.430348427@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 01/18] tracing: Fix race of function probes counting
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Fix-race-of-function-probes-counting.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function probe counting for traceon and traceoff suffered a race
condition where if the probe was executing on two or more CPUs at the
same time, it could decrement the counter by more than one when
disabling (or enabling) the tracer only once.

The way the traceon and traceoff probes are suppose to work is that
they disable (or enable) tracing once per count. If a user were to
echo 'schedule:traceoff:3' into set_ftrace_filter, then when the
schedule function was called, it would disable tracing. But the count
should only be decremented once (to 2). Then if the user enabled tracing
again (via tracing_on file), the next call to schedule would disable
tracing again and the count would be decremented to 1.

But if multiple CPUS called schedule at the same time, it is possible
that the count would be decremented more than once because of the
simple "count--" used.

By reading the count into a local variable and using memory barriers
we can guarantee that the count would only be decremented once per
disable (or enable).

The stack trace probe had a similar race, but here the stack trace will
decrement for each time it is called. But this had the read-modify-
write race, where it could stack trace more than the number of times
that was specified. This case we use a cmpxchg to stack trace only the
number of times specified.

The dump probes can still use the old "update_count()" function as
they only run once, and that is controlled by the dump logic
itself.

Link: http://lkml.kernel.org/r/20141118134643.4b550ee4@gandalf.local.home

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c | 117 +++++++++++++++++++++++++++++++++--------
 1 file changed, 96 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index a8e0c7666164..973db52eb070 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -261,37 +261,74 @@ static struct tracer function_trace __tracer_data =
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-static int update_count(void **data)
+static void update_traceon_count(void **data, int on)
 {
-	unsigned long *count = (long *)data;
+	long *count = (long *)data;
+	long old_count = *count;
 
-	if (!*count)
-		return 0;
+	/*
+	 * Tracing gets disabled (or enabled) once per count.
+	 * This function can be called at the same time on mulitple CPUs.
+	 * It is fine if both disable (or enable) tracing, as disabling
+	 * (or enabling) the second time doesn't do anything as the
+	 * state of the tracer is already disabled (or enabled).
+	 * What needs to be synchronized in this case is that the count
+	 * only gets decremented once, even if the tracer is disabled
+	 * (or enabled) twice, as the second one is really a nop.
+	 *
+	 * The memory barriers guarantee that we only decrement the
+	 * counter once. First the count is read to a local variable
+	 * and a read barrier is used to make sure that it is loaded
+	 * before checking if the tracer is in the state we want.
+	 * If the tracer is not in the state we want, then the count
+	 * is guaranteed to be the old count.
+	 *
+	 * Next the tracer is set to the state we want (disabled or enabled)
+	 * then a write memory barrier is used to make sure that
+	 * the new state is visible before changing the counter by
+	 * one minus the old counter. This guarantees that another CPU
+	 * executing this code will see the new state before seeing
+	 * the new counter value, and would not do anthing if the new
+	 * counter is seen.
+	 *
+	 * Note, there is no synchronization between this and a user
+	 * setting the tracing_on file. But we currently don't care
+	 * about that.
+	 */
+	if (!old_count)
+		return;
 
-	if (*count != -1)
-		(*count)--;
+	/* Make sure we see count before checking tracing state */
+	smp_rmb();
 
-	return 1;
+	if (on == !!tracing_is_on())
+		return;
+
+	if (on)
+		tracing_on();
+	else
+		tracing_off();
+
+	/* unlimited? */
+	if (old_count == -1)
+		return;
+
+	/* Make sure tracing state is visible before updating count */
+	smp_wmb();
+
+	*count = old_count - 1;
 }
 
 static void
 ftrace_traceon_count(unsigned long ip, unsigned long parent_ip, void **data)
 {
-	if (tracing_is_on())
-		return;
-
-	if (update_count(data))
-		tracing_on();
+	update_traceon_count(data, 1);
 }
 
 static void
 ftrace_traceoff_count(unsigned long ip, unsigned long parent_ip, void **data)
 {
-	if (!tracing_is_on())
-		return;
-
-	if (update_count(data))
-		tracing_off();
+	update_traceon_count(data, 0);
 }
 
 static void
@@ -330,11 +367,49 @@ ftrace_stacktrace(unsigned long ip, unsigned long parent_ip, void **data)
 static void
 ftrace_stacktrace_count(unsigned long ip, unsigned long parent_ip, void **data)
 {
-	if (!tracing_is_on())
-		return;
+	long *count = (long *)data;
+	long old_count;
+	long new_count;
 
-	if (update_count(data))
-		trace_dump_stack(STACK_SKIP);
+	/*
+	 * Stack traces should only execute the number of times the
+	 * user specified in the counter.
+	 */
+	do {
+
+		if (!tracing_is_on())
+			return;
+
+		old_count = *count;
+
+		if (!old_count)
+			return;
+
+		/* unlimited? */
+		if (old_count == -1) {
+			trace_dump_stack(STACK_SKIP);
+			return;
+		}
+
+		new_count = old_count - 1;
+		new_count = cmpxchg(count, old_count, new_count);
+		if (new_count == old_count)
+			trace_dump_stack(STACK_SKIP);
+
+	} while (new_count != old_count);
+}
+
+static int update_count(void **data)
+{
+	unsigned long *count = (long *)data;
+
+	if (!*count)
+		return 0;
+
+	if (*count != -1)
+		(*count)--;
+
+	return 1;
 }
 
 static void
-- 
2.1.1


