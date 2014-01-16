Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaAPRUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:20:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11753 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753151AbaAPRUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:20:10 -0500
Message-Id: <20140116172007.826288521@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 16 Jan 2014 12:18:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Subject: [RFC][PATCH 2/2] preempt: Show preempt disable stack on schedule bugs
References: <20140116171824.748919700@goodmis.org>
Content-Disposition: inline; filename=0002-preempt-Show-preempt-disable-stack-on-schedule-bugs.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There's been a few times where a function was called that did not have a
matching preempt_enable() for the preempt_disable().

For example, if a function deep in a call chain was called, and did a
preempt_disable() but due to an early exit of the routine, did not do a
matching preempt_enable(), it may not warn about this until later.

bar() {
  preempt_disable();
  [...]
  if (ret < 0)
     return;
  [...]
}

foo() {
  [...]
  bar();
  [...]
}

foo();
schedule();

Getting the "scheduling while atomic" warning detects the bug, but it
does not let you know where the bug happened. It may take several trials
to figure out where the missing preempt_enable() was. Some times those
functions are very deep and that makes it even more difficult to find.

The original real-time patch had a feature, written by Ingo Molnar, to trace
all the locations that disabled preemption for each process. On a bug, it
would report where the preemption was disabled.

I started with his code and modified it to be a bit simpler, as he never
meant that code to be mainline. First, as preempt disabling is really more
of a CPU state and not a process state, I made the stacks just per cpu
arrays. This eliminates any changes needed by sched.h or the task_struct.

The only times the preempt trace is needed is when scheduling while atomic
or might sleep bugs are found. This information is only printed in those
cases (not on all bug reports).

I renamed the config option from PREEMPT_TRACE to PREEMPT_STACK to prevent
confusion from the tracing facility PREEMPT_TRACER that traces the length
that preemption is disabled.

Using a struct to save the ip and parent ip together also keeps the code
a bit cleaner than using two different arrays.

Using a module that creates a kernel thread that calls a function
bad_preempt_disable() that just calls preempt_disable() with no matching
preempt_enable(), and then calls schedule, the output can be seen as the
following:

BUG: scheduling while atomic: task1/3889/0x00000002
Modules linked in: sched_bug(O) [..]
CPU: 7 PID: 3889 Comm: task1 Tainted: G           O 3.13.0-rc8-test+ #28
Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
 0000000000000007 ffff8800c87a1dd8 ffffffff81627676 ffff88011ebcf5d0
 ffff8800ca0eaf00 ffff8800c87a1df8 ffffffff81623825 0000000000000002
 ffff88011ebd3600 ffff8800c87a1e78 ffffffff8162b0f5 ffff8800c87a1e28
Call Trace:
 [<ffffffff81627676>] dump_stack+0x4f/0x7c
 [<ffffffff81623825>] __schedule_bug+0x59/0x6e
 [<ffffffff8162b0f5>] __schedule+0x6b5/0x7e0
 [<ffffffff816329f1>] ? preempt_count_sub+0xb1/0x100
 [<ffffffffa06d9020>] ? bad_preempt_disable+0x20/0x20 [sched_bug]
 [<ffffffff8162b339>] schedule+0x29/0x70
 [<ffffffffa06d9038>] dead_thread+0x18/0x78 [sched_bug]
 [<ffffffff81073559>] kthread+0xc9/0xe0
 [<ffffffff81620000>] ? pci_add_new_bus+0x150/0x3b0
 [<ffffffff81073490>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8163676c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81073490>] ? flush_kthread_worker+0xb0/0xb0
---------------------------
| preempt count: 00000002 ]
| 2-level deep critical section nesting:
----------------------------------------
.. [<ffffffffa06d9013>] .... bad_preempt_disable+0x13/0x20 [sched_bug]
.....[<ffffffffa06d9033>] ..   ( <= dead_thread+0x13/0x78 [sched_bug])
.. [<ffffffff8162aa89>] .... __schedule+0x49/0x7e0
.....[<ffffffff8162b339>] ..   ( <= schedule+0x29/0x70)

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.debug   | 16 ++++++++++++++
 2 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 68b0c1f..336b2c0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2341,8 +2341,51 @@ notrace unsigned long get_parent_ip(unsigned long addr)
 
 #ifdef CONFIG_DEBUG_PREEMPT_COUNT
 
+#ifdef CONFIG_PREEMPT_STACK
+# define MAX_PREEMPT_STACK 25
+struct preempt_stack {
+	unsigned long		ip;
+	unsigned long		parent_ip;
+};
+
+static DEFINE_PER_CPU(struct preempt_stack,
+		      preempt_stack_trace[MAX_PREEMPT_STACK]);
+
+void print_preempt_trace(void)
+{
+	struct preempt_stack *stack;
+	unsigned int count;
+	unsigned int i, lim;
+
+	stack = this_cpu_ptr(preempt_stack_trace);
+
+	count = preempt_count();
+
+	lim = count & PREEMPT_MASK;
+
+	if (lim >= MAX_PREEMPT_STACK)
+		lim = MAX_PREEMPT_STACK-1;
+	printk(KERN_ERR "---------------------------\n");
+	printk(KERN_CONT "| preempt count: %08x ]\n", count);
+	printk(KERN_CONT "| %d-level deep critical section nesting:\n", lim);
+	printk(KERN_CONT "----------------------------------------\n");
+	for (i = 1; i <= lim; i++) {
+		printk(KERN_CONT ".. [<%08lx>] .... %pS\n",
+		       stack[i].ip, (void *)stack[i].ip);
+		printk(KERN_CONT ".....[<%08lx>] ..   ( <= %pS)\n",
+		       stack[i].parent_ip, (void *)stack[i].parent_ip);
+	}
+	printk(KERN_CONT "\n");
+}
+#else
+static inline void print_preempt_trace(void) { }
+#endif
+
 void __kprobes preempt_count_add(int val)
 {
+	unsigned long ip = CALLER_ADDR0;
+	unsigned long parent_ip = get_parent_ip(CALLER_ADDR1);
+
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Underflow?
@@ -2351,6 +2394,19 @@ void __kprobes preempt_count_add(int val)
 		return;
 #endif
 	__preempt_count_add(val);
+
+#ifdef CONFIG_PREEMPT_STACK
+	if (val < SOFTIRQ_OFFSET) {
+		unsigned int idx = preempt_count() & PREEMPT_MASK;
+		if (idx < MAX_PREEMPT_STACK) {
+			struct preempt_stack *stack;
+			stack = this_cpu_ptr(preempt_stack_trace);
+			stack[idx].ip = ip;
+			stack[idx].parent_ip = parent_ip;
+		}
+	}
+#endif
+
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -2359,7 +2415,7 @@ void __kprobes preempt_count_add(int val)
 				PREEMPT_MASK - 10);
 #endif
 	if (preempt_count() == val)
-		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+		trace_preempt_off(ip, parent_ip);
 }
 EXPORT_SYMBOL(preempt_count_add);
 
@@ -2403,6 +2459,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
+	print_preempt_trace();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
 }
 
@@ -6388,6 +6445,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	if (irqs_disabled())
 		print_irqtrace_events(current);
 	dump_stack();
+	print_preempt_trace();
 }
 EXPORT_SYMBOL(__might_sleep);
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8cf7819..b7999a4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -810,6 +810,22 @@ config DEBUG_PREEMPT
 	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
 	  will detect preemption count underflows.
 
+config PREEMPT_STACK
+	bool "Keep a record of preempt disabled locations"
+	depends on DEBUG_KERNEL
+	depends on PREEMPT
+	select DEBUG_PREEMPT_COUNT
+	help
+	 When enabled, it keeps track of the last 25 locations that disabled
+	 preemption. This is useful to debug a "scheduling while atomic" error.
+	 Sometimes it is hard to find what left preemption disabled, and this
+	 utility can help.
+
+	 Saying yes to this will introduce an overhead, as all preempt disabled
+	 calls are being tracked.
+
+	 If unsure, say N.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"
 
 config DEBUG_RT_MUTEXES
-- 
1.8.4.3


