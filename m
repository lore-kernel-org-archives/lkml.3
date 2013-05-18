Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab3ERDTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:19:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596Ab3ERDAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:10 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=kLzPJMssIBYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kCOu-_W2FuQA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=NJo6e_97wZyvM8k38EUA:9 a=jeBq3FmKZ4MA:10 a=hPjdaMEvmhQA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021702.763313147@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [ 132/136 ] tracing: Fix ftrace_dump()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0132-tracing-Fix-ftrace_dump.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ Upstream commit 7fe70b579c9e3daba71635e31b6189394e7b79d3 ]

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
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c          |   62 +++++++++++++++++------------------------
 kernel/trace/trace_selftest.c |    9 +++---
 2 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4a568ba..6fbd63a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4986,36 +4986,32 @@ void trace_init_global_iter(struct trace_iterator *iter)
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
 
@@ -5048,6 +5044,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 
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
@@ -5087,26 +5089,14 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
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
+	atomic_dec(&dump_running);
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
1.7.10.4


