Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab3EGNlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3EGNlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 064/118] tracing: Fix ftrace_dump()
Date: Tue,  7 May 2013 14:38:30 +0100
Message-Id: <1367933964-1564-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 7fe70b579c9e3daba71635e31b6189394e7b79d3 upstream.

ftrace_dump() had a lot of issues. What ftrace_dump() does, is when
ftrace_dump_on_oops is set (via a kernel parameter or sysctl), it
will dump out the ftrace buffers to the console when either a oops,
panic, or a sysrq-z occurs.

This was written a long time ago when ftrace was fragile to recursion.
But it wasn't written well even for that.

There's a possible deadlock that can occur if a ftrace_dump() is happening
and an NMI triggers another dump. This is because it grabs a lock
before checking if the dump ran.

It also totally disables ftrace, and tracing for no good reasons.

As the ring_buffer now checks if it is read via a oops or NMI, where
there's a chance that the buffer gets corrupted, it will disable
itself. No need to have ftrace_dump() do the same.

ftrace_dump() is now cleaned up where it uses an atomic counter to
make sure only one dump happens at a time. A simple atomic_inc_return()
is enough that is needed for both other CPUs and NMIs. No need for
a spinlock, as if one CPU is running the dump, no other CPU needs
to do it too.

The tracing_on variable is turned off and not turned on. The original
code did this, but it wasn't pretty. By just disabling this variable
we get the result of not seeing traces that happen between crashes.

For sysrq-z, it doesn't get turned on, but the user can always write
a '1' to the tracing_on file. If they are using sysrq-z, then they should
know about tracing_on.

The new code is much easier to read and less error prone. No more
deadlock possibility when an NMI triggers here.

Reported-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ luis: backport to 3.5:
  - adjust context
  - use the static per_cpu arrays ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c          | 62 ++++++++++++++++++-------------------------
 kernel/trace/trace_selftest.c |  9 ++++---
 2 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 34c61b2..28e2b14 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4968,36 +4968,32 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	iter->cpu_file = TRACE_PIPE_ALL_CPU;
 }
 
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
+void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 {
-	static arch_spinlock_t ftrace_dump_lock =
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
+	static atomic_t dump_running;
 	unsigned int old_userobj;
-	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0, cpu;
 
-	/* only one dump */
-	local_irq_save(flags);
-	arch_spin_lock(&ftrace_dump_lock);
-	if (dump_ran)
-		goto out;
-
-	dump_ran = 1;
+	/* Only allow one dump user at a time. */
+	if (atomic_inc_return(&dump_running) != 1) {
+		atomic_dec(&dump_running);
+		return;
+	}
 
+	/*
+	 * Always turn off tracing when we dump.
+	 * We don't need to show trace output of what happens
+	 * between multiple crashes.
+	 *
+	 * If the user does a sysrq-z, then they can re-enable
+	 * tracing with echo 1 > tracing_on.
+	 */
 	tracing_off();
 
-	/* Did function tracer already get disabled? */
-	if (ftrace_is_dead()) {
-		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
-		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
-	}
-
-	if (disable_tracing)
-		ftrace_kill();
+	local_irq_save(flags);
 
 	trace_init_global_iter(&iter);
 
@@ -5030,6 +5026,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
+	/* Did function tracer already get disabled? */
+	if (ftrace_is_dead()) {
+		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
+	}
+
 	/*
 	 * We need to stop all tracing on all CPUS to read the
 	 * the next buffer. This is a bit expensive, but is
@@ -5069,26 +5071,14 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		printk(KERN_TRACE "---------------------------------\n");
 
  out_enable:
-	/* Re-enable tracing if requested */
-	if (!disable_tracing) {
-		trace_flags |= old_userobj;
+	trace_flags |= old_userobj;
 
-		for_each_tracing_cpu(cpu) {
-			atomic_dec(&iter.tr->data[cpu]->disabled);
-		}
-		tracing_on();
+	for_each_tracing_cpu(cpu) {
+		atomic_dec(&iter.tr->data[cpu]->disabled);
 	}
-
- out:
-	arch_spin_unlock(&ftrace_dump_lock);
+ 	atomic_dec(&dump_running);
 	local_irq_restore(flags);
 }
-
-/* By default: disable tracing after the dump */
-void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
-{
-	__ftrace_dump(true, oops_dump_mode);
-}
 EXPORT_SYMBOL_GPL(ftrace_dump);
 
 __init static int tracer_alloc_buffers(void)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 288541f..09fd98a 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -461,8 +461,6 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 /* Maximum number of functions to trace before diagnosing a hang */
 #define GRAPH_MAX_FUNC_TEST	100000000
 
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode);
 static unsigned int graph_hang_thresh;
 
 /* Wrap the real function entry probe to avoid possible hanging */
@@ -472,8 +470,11 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
 	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
 		ftrace_graph_stop();
 		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
-		if (ftrace_dump_on_oops)
-			__ftrace_dump(false, DUMP_ALL);
+		if (ftrace_dump_on_oops) {
+			ftrace_dump(DUMP_ALL);
+			/* ftrace_dump() disables tracing */
+			tracing_on();
+		}
 		return 0;
 	}
 
-- 
1.8.1.2

