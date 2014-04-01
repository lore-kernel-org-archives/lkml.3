Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaDAP2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:28:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:20801 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751617AbaDAP2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:28:49 -0400
Date: Tue, 1 Apr 2014 11:28:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [GIT PULL] tracing: Cleanups and new features for tracing
Message-ID: <20140401112847.62d5b067@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Most of the changes were largely clean ups, and some documentation.
But there were a few features that were added.

Uprobes now work with event triggers and multi buffers.
Uprobes have support under ftrace and perf.

The big feature is that the function tracer can now be used within the
multi buffer instances. That is, you can now trace some functions
in one buffer, others in another buffer, all functions in a third buffer
and so on. They are basically agnostic from each other. This only
works for the function tracer and not for the function graph trace,
although you can have the function graph tracer running in the top level
buffer (or any tracer for that matter) and have different function tracing
going on in the sub buffers.

Note, I'm still working on a change with Mathieu Desnoyers because of
the tracepoint updates that caused ftrace to break. 3.14 had a quick fix
for the problem, but we are now working on a cleaner solution. His
solution requires changes from both my urgent branch (which was
included in 3.14) as well as my 3.15 updates. I'm pushing what I have
now so that we can work on a clean solution. The real fix is actually a
nice cleanup of the code that shrinks the overhead a bit. We are
working on some small details, but something should be ready, and
tested before the merge window closes. If you pull this branch, I'll
base the work off of that pull commit (and still run it through all
my tests), so that his code has both the 3.14 and 3.15 updates.

Please pull the latest trace-3.15 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.15

Tag SHA1: 0e0cdda7cee4e1ba7bbaf77dc718aaba028bab16
Head SHA1: 3862807880acc0adaef6749738d210c9f45c3049


Aaron Tomlin (1):
      tracing: Add BUG_ON when stack end location is over written

Filipe Brandenburger (2):
      tracing: Correctly expand len expressions from __dynamic_array macro
      tracing: Evaluate len expression only once in __dynamic_array macro

Jiri Slaby (6):
      ftrace: Cleanup of global variables ftrace_new_pgs and ftrace_update_cnt
      ftrace: Inline the code from ftrace_dyn_table_alloc()
      ftrace: Pass retval through return in ftrace_dyn_arch_init()
      ftrace: Do not pass data to ftrace_dyn_arch_init
      ftrace: Remove freelist from struct dyn_ftrace
      ftrace: Fix compilation warning about control_ops_free

Mathieu Desnoyers (3):
      tracepoints: API doc update to data argument
      tracepoints: API doc update to tracepoint_probe_register() return value
      tracepoint: Remove unused API functions

Namhyung Kim (4):
      tracing/uprobes: Rename uprobe_{trace,perf}_print() functions
      tracing/uprobes: Move argument fetching to uprobe_dispatcher()
      tracing/uprobes: Support event triggering
      tracing/uprobes: Support mix of ftrace and perf

Petr Mladek (3):
      ftrace/x86: One more missing sync after fixup of function modification failure
      ftrace: Warn on error when modifying ftrace function
      ftrace/x86: BUG when ftrace recovery fails

Sasha Levin (1):
      ftrace: Constify ftrace_text_reserved

Steven Rostedt (5):
      tracing: Add trace_clock=<clock> kernel parameter
      tracing: Move raw output code from macro to standalone function
      tracing: Move event storage for array from macro to standalone function
      tracing: Use helper functions in event assignment to shrink macro size
      tracing: Warn if a tracepoint is not set via debugfs

Steven Rostedt (Red Hat) (19):
      tracing: Pass trace_array to set_flag callback
      tracing: Pass trace_array to flag_changed callback
      tracing: Set up infrastructure to allow tracers for instances
      tracing: Only let top level have option files
      ftrace: Add private data to ftrace_ops
      ftrace: Copy ops private to global_ops private
      tracing: Disable tracers before deletion of instance
      tracing: Convert tracer->enabled to counter
      ftrace: Allow instances to use function tracing
      ftrace: Pass in global_ops for use with filtering files
      ftrace: Allow for function tracing instance to filter functions
      ftrace: Have static function trace clear ENABLED flag on unregister
      ftrace/x86: Run a sync after fixup on failure
      tracepoint: Do not waste memory on mods with no tracepoints
      ftrace/x86: Have ftrace_write() return -EPERM and clean up callers
      tracing: Fix event header writeback.h to include tracepoint.h
      tracing: Fix event header migrate.h to include tracepoint.h
      tracing/module: Replace include of tracepoint.h with jump_label.h in module.h
      Revert "tracing: Move event storage for array from macro to standalone function"

zhangwei(Jovi) (1):
      tracing/uprobes: Support ftrace_event_file base multibuffer

----
 Documentation/trace/ftrace-design.txt |   5 +-
 arch/arm/kernel/ftrace.c              |   4 +-
 arch/blackfin/kernel/ftrace.c         |   5 +-
 arch/ia64/kernel/ftrace.c             |   4 +-
 arch/metag/kernel/ftrace.c            |   5 +-
 arch/microblaze/kernel/ftrace.c       |   5 +-
 arch/mips/kernel/ftrace.c             |   5 +-
 arch/powerpc/kernel/ftrace.c          |   7 +-
 arch/s390/kernel/ftrace.c             |   3 +-
 arch/sh/kernel/ftrace.c               |   5 +-
 arch/sparc/kernel/ftrace.c            |   6 +-
 arch/tile/kernel/ftrace.c             |   4 +-
 arch/x86/kernel/ftrace.c              |  55 ++++----
 include/linux/ftrace.h                |  27 ++--
 include/linux/ftrace_event.h          |  28 ++++
 include/linux/module.h                |   2 +-
 include/linux/tracepoint.h            |  18 ---
 include/trace/events/migrate.h        |   2 +
 include/trace/events/writeback.h      |   1 +
 include/trace/ftrace.h                |  38 ++---
 kernel/trace/blktrace.c               |   3 +-
 kernel/trace/ftrace.c                 | 162 ++++++++++++----------
 kernel/trace/trace.c                  | 187 +++++++++++++++++++------
 kernel/trace/trace.h                  |  38 ++++-
 kernel/trace/trace_events.c           |  30 ++++
 kernel/trace/trace_functions.c        | 143 +++++++++++++------
 kernel/trace/trace_functions_graph.c  |   3 +-
 kernel/trace/trace_irqsoff.c          |  10 +-
 kernel/trace/trace_kprobe.c           |  17 ---
 kernel/trace/trace_nop.c              |   5 +-
 kernel/trace/trace_output.c           |  31 +++++
 kernel/trace/trace_probe.h            |  17 +++
 kernel/trace/trace_sched_wakeup.c     |  10 +-
 kernel/trace/trace_stack.c            |   3 +
 kernel/trace/trace_uprobe.c           | 191 ++++++++++++++++++--------
 kernel/tracepoint.c                   | 251 +++++-----------------------------
 36 files changed, 739 insertions(+), 591 deletions(-)
---------------------------
diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 79fcafc..3f669b9 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -358,11 +358,8 @@ Every arch has an init callback function.  If you need to do something early on
 to initialize some state, this is the time to do that.  Otherwise, this simple
 function below should be sufficient for most people:
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	/* return value is done indirectly via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 34e5664..c108ddc 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -156,10 +156,8 @@ int ftrace_make_nop(struct module *mod,
 	return ret;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/blackfin/kernel/ftrace.c b/arch/blackfin/kernel/ftrace.c
index 9277905..095de0f 100644
--- a/arch/blackfin/kernel/ftrace.c
+++ b/arch/blackfin/kernel/ftrace.c
@@ -65,11 +65,8 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(ip, call, sizeof(call));
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	/* return value is done indirectly via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 
diff --git a/arch/ia64/kernel/ftrace.c b/arch/ia64/kernel/ftrace.c
index 7fc8c96..3b0c2aa 100644
--- a/arch/ia64/kernel/ftrace.c
+++ b/arch/ia64/kernel/ftrace.c
@@ -198,9 +198,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 }
 
 /* run from kstop_machine */
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
diff --git a/arch/metag/kernel/ftrace.c b/arch/metag/kernel/ftrace.c
index a774f32..ed1d685 100644
--- a/arch/metag/kernel/ftrace.c
+++ b/arch/metag/kernel/ftrace.c
@@ -117,10 +117,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 }
 
 /* run from kstop_machine */
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	/* The return code is returned via data */
-	writel(0, data);
-
 	return 0;
 }
diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index e8a5e9c..bbcd253 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -171,11 +171,8 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	return ret;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 185ba25..1ba7afe 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -198,7 +198,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(FTRACE_CALL_IP, new);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
 	/* Encode the instructions when booting */
 	ftrace_dyn_arch_init_insns();
@@ -206,9 +206,6 @@ int __init ftrace_dyn_arch_init(void *data)
 	/* Remove "b ftrace_stub" to ensure ftrace_caller() is executed */
 	ftrace_modify_code(MCOUNT_ADDR, INSN_NOP);
 
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif	/* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 9b27b29..71ce4cb 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -531,13 +531,8 @@ void arch_ftrace_update_code(int command)
 		ftrace_disable_ftrace_graph_caller();
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	/* caller expects data to be zero */
-	unsigned long *p = data;
-
-	*p = 0;
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 224db03..54d6493 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -130,9 +130,8 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return 0;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	*(unsigned long *) data = 0;
 	return 0;
 }
 
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index 30e1319..3c74f53 100644
--- a/arch/sh/kernel/ftrace.c
+++ b/arch/sh/kernel/ftrace.c
@@ -272,11 +272,8 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	return ftrace_modify_code(rec->ip, old, new);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	/* The return code is retured via data */
-	__raw_writel(0, (unsigned long)data);
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
index 03ab022..0a2d2dd 100644
--- a/arch/sparc/kernel/ftrace.c
+++ b/arch/sparc/kernel/ftrace.c
@@ -82,12 +82,8 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(ip, old, new);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	unsigned long *p = data;
-
-	*p = 0;
-
 	return 0;
 }
 #endif
diff --git a/arch/tile/kernel/ftrace.c b/arch/tile/kernel/ftrace.c
index f1c4520..8d52d83 100644
--- a/arch/tile/kernel/ftrace.c
+++ b/arch/tile/kernel/ftrace.c
@@ -167,10 +167,8 @@ int ftrace_make_nop(struct module *mod,
 	return ret;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e625319..52819e8 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -308,7 +308,10 @@ static int ftrace_write(unsigned long ip, const char *val, int size)
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
 		ip = (unsigned long)__va(__pa_symbol(ip));
 
-	return probe_kernel_write((void *)ip, val, size);
+	if (probe_kernel_write((void *)ip, val, size))
+		return -EPERM;
+
+	return 0;
 }
 
 static int add_break(unsigned long ip, const char *old)
@@ -323,10 +326,7 @@ static int add_break(unsigned long ip, const char *old)
 	if (memcmp(replaced, old, MCOUNT_INSN_SIZE) != 0)
 		return -EINVAL;
 
-	if (ftrace_write(ip, &brk, 1))
-		return -EPERM;
-
-	return 0;
+	return ftrace_write(ip, &brk, 1);
 }
 
 static int add_brk_on_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -425,7 +425,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 
 	/* If this does not have a breakpoint, we are done */
 	if (ins[0] != brk)
-		return -1;
+		return 0;
 
 	nop = ftrace_nop_replace();
 
@@ -455,7 +455,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 	}
 
  update:
-	return probe_kernel_write((void *)ip, &nop[0], 1);
+	return ftrace_write(ip, nop, 1);
 }
 
 static int add_update_code(unsigned long ip, unsigned const char *new)
@@ -463,9 +463,7 @@ static int add_update_code(unsigned long ip, unsigned const char *new)
 	/* skip breakpoint */
 	ip++;
 	new++;
-	if (ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1))
-		return -EPERM;
-	return 0;
+	return ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1);
 }
 
 static int add_update_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -520,10 +518,7 @@ static int finish_update_call(struct dyn_ftrace *rec, unsigned long addr)
 
 	new = ftrace_call_replace(ip, addr);
 
-	if (ftrace_write(ip, new, 1))
-		return -EPERM;
-
-	return 0;
+	return ftrace_write(ip, new, 1);
 }
 
 static int finish_update_nop(struct dyn_ftrace *rec)
@@ -533,9 +528,7 @@ static int finish_update_nop(struct dyn_ftrace *rec)
 
 	new = ftrace_nop_replace();
 
-	if (ftrace_write(ip, new, 1))
-		return -EPERM;
-	return 0;
+	return ftrace_write(ip, new, 1);
 }
 
 static int finish_update(struct dyn_ftrace *rec, int enable)
@@ -632,8 +625,14 @@ void ftrace_replace_code(int enable)
 	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
-		remove_breakpoint(rec);
+		/*
+		 * Breakpoints are handled only when this function is in
+		 * progress. The system could not work with them.
+		 */
+		if (remove_breakpoint(rec))
+			BUG();
 	}
+	run_sync();
 }
 
 static int
@@ -655,16 +654,19 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 	run_sync();
 
 	ret = ftrace_write(ip, new_code, 1);
-	if (ret) {
-		ret = -EPERM;
-		goto out;
-	}
-	run_sync();
+	/*
+	 * The breakpoint is handled only when this function is in progress.
+	 * The system could not work if we could not remove it.
+	 */
+	BUG_ON(ret);
  out:
+	run_sync();
 	return ret;
 
  fail_update:
-	probe_kernel_write((void *)ip, &old_code[0], 1);
+	/* Also here the system could not work with the breakpoint */
+	if (ftrace_write(ip, old_code, 1))
+		BUG();
 	goto out;
 }
 
@@ -678,11 +680,8 @@ void arch_ftrace_update_code(int command)
 	atomic_dec(&modifying_ftrace_code);
 }
 
-int __init ftrace_dyn_arch_init(void *data)
+int __init ftrace_dyn_arch_init(void)
 {
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f4233b1..9212b01 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -92,6 +92,7 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * STUB   - The ftrace_ops is just a place holder.
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
+ * DELETED - The ops are being deleted, do not let them be registered again.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -103,13 +104,26 @@ enum {
 	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
 	FTRACE_OPS_FL_STUB			= 1 << 7,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
+	FTRACE_OPS_FL_DELETED			= 1 << 9,
 };
 
+/*
+ * Note, ftrace_ops can be referenced outside of RCU protection.
+ * (Although, for perf, the control ops prevent that). If ftrace_ops is
+ * allocated and not part of kernel core data, the unregistering of it will
+ * perform a scheduling on all CPUs to make sure that there are no more users.
+ * Depending on the load of the system that may take a bit of time.
+ *
+ * Any private data added must also take care not to be freed and if private
+ * data is added to a ftrace_ops that is in core code, the user of the
+ * ftrace_ops must perform a schedule_on_each_cpu() before freeing it.
+ */
 struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
 	int __percpu			*disabled;
+	void				*private;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
@@ -285,7 +299,7 @@ extern void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
 extern void unregister_ftrace_function_probe_all(char *glob);
 
-extern int ftrace_text_reserved(void *start, void *end);
+extern int ftrace_text_reserved(const void *start, const void *end);
 
 extern int ftrace_nr_registered_ops(void);
 
@@ -316,12 +330,9 @@ enum {
 #define FTRACE_REF_MAX		((1UL << 29) - 1)
 
 struct dyn_ftrace {
-	union {
-		unsigned long		ip; /* address of mcount call-site */
-		struct dyn_ftrace	*freelist;
-	};
+	unsigned long		ip; /* address of mcount call-site */
 	unsigned long		flags;
-	struct dyn_arch_ftrace		arch;
+	struct dyn_arch_ftrace	arch;
 };
 
 int ftrace_force_update(void);
@@ -409,7 +420,7 @@ ftrace_set_early_filter(struct ftrace_ops *ops, char *buf, int enable);
 
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
-extern int ftrace_dyn_arch_init(void *data);
+extern int ftrace_dyn_arch_init(void);
 extern void ftrace_replace_code(int enable);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
@@ -541,7 +552,7 @@ static inline __init int unregister_ftrace_command(char *cmd_name)
 {
 	return -EINVAL;
 }
-static inline int ftrace_text_reserved(void *start, void *end)
+static inline int ftrace_text_reserved(const void *start, const void *end)
 {
 	return 0;
 }
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4e4cc28..cdc9759 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -163,6 +163,8 @@ void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 
 void tracing_record_cmdline(struct task_struct *tsk);
 
+int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...);
+
 struct event_filter;
 
 enum trace_reg {
@@ -197,6 +199,32 @@ struct ftrace_event_class {
 extern int ftrace_event_reg(struct ftrace_event_call *event,
 			    enum trace_reg type, void *data);
 
+int ftrace_output_event(struct trace_iterator *iter, struct ftrace_event_call *event,
+			char *fmt, ...);
+
+int ftrace_event_define_field(struct ftrace_event_call *call,
+			      char *type, int len, char *item, int offset,
+			      int field_size, int sign, int filter);
+
+struct ftrace_event_buffer {
+	struct ring_buffer		*buffer;
+	struct ring_buffer_event	*event;
+	struct ftrace_event_file	*ftrace_file;
+	void				*entry;
+	unsigned long			flags;
+	int				pc;
+};
+
+void *ftrace_event_buffer_reserve(struct ftrace_event_buffer *fbuffer,
+				  struct ftrace_event_file *ftrace_file,
+				  unsigned long len);
+
+void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer);
+
+int ftrace_event_define_field(struct ftrace_event_call *call,
+			      char *type, int len, char *item, int offset,
+			      int field_size, int sign, int filter);
+
 enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
diff --git a/include/linux/module.h b/include/linux/module.h
index eaf60ff..5a50539 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -15,7 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
-#include <linux/tracepoint.h>
+#include <linux/jump_label.h>
 #include <linux/export.h>
 
 #include <linux/percpu.h>
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index accc497..a3b2837 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -48,12 +48,6 @@ extern int tracepoint_probe_register(const char *name, void *probe, void *data);
 extern int
 tracepoint_probe_unregister(const char *name, void *probe, void *data);
 
-extern int tracepoint_probe_register_noupdate(const char *name, void *probe,
-					      void *data);
-extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
-						void *data);
-extern void tracepoint_probe_update_all(void);
-
 #ifdef CONFIG_MODULES
 struct tp_module {
 	struct list_head list;
@@ -62,18 +56,6 @@ struct tp_module {
 };
 #endif /* CONFIG_MODULES */
 
-struct tracepoint_iter {
-#ifdef CONFIG_MODULES
-	struct tp_module *module;
-#endif /* CONFIG_MODULES */
-	struct tracepoint * const *tracepoint;
-};
-
-extern void tracepoint_iter_start(struct tracepoint_iter *iter);
-extern void tracepoint_iter_next(struct tracepoint_iter *iter);
-extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
-extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-
 /*
  * tracepoint_synchronize_unregister must be called between the last tracepoint
  * probe unregistration and the end of module exit to make sure there is no
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index 3075ffb..4e4f2f8 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -4,6 +4,8 @@
 #if !defined(_TRACE_MIGRATE_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_MIGRATE_H
 
+#include <linux/tracepoint.h>
+
 #define MIGRATE_MODE						\
 	{MIGRATE_ASYNC,		"MIGRATE_ASYNC"},		\
 	{MIGRATE_SYNC_LIGHT,	"MIGRATE_SYNC_LIGHT"},		\
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index c7bbbe7..309a086 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -4,6 +4,7 @@
 #if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_WRITEBACK_H
 
+#include <linux/tracepoint.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1a8b28d..d1d9187 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -265,11 +265,9 @@ static notrace enum print_line_t					\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 			 struct trace_event *event)			\
 {									\
-	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##template *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p = &iter->tmp_seq;				\
-	int ret;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -281,13 +279,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	field = (typeof(field))entry;					\
 									\
 	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, "%s: ", #call);			\
-	if (ret)							\
-		ret = trace_seq_printf(s, print);			\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
-									\
-	return TRACE_TYPE_HANDLED;					\
+	return ftrace_output_call(iter, #call, print);			\
 }									\
 static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	.trace			= ftrace_raw_output_##call,		\
@@ -373,10 +365,11 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				\
+	__item_length = (len) * sizeof(type);				\
 	__data_offsets->item = __data_size +				\
 			       offsetof(typeof(*entry), __data);	\
-	__data_offsets->item |= (len * sizeof(type)) << 16;		\
-	__data_size += (len) * sizeof(type);
+	__data_offsets->item |= __item_length << 16;			\
+	__data_size += __item_length;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item,			\
@@ -388,6 +381,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
 	int __data_size = 0;						\
+	int __maybe_unused __item_length;				\
 	struct ftrace_raw_##call __maybe_unused *entry;			\
 									\
 	tstruct;							\
@@ -544,37 +538,27 @@ static notrace void							\
 ftrace_raw_event_##call(void *__data, proto)				\
 {									\
 	struct ftrace_event_file *ftrace_file = __data;			\
-	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	struct ring_buffer_event *event;				\
+	struct ftrace_event_buffer fbuffer;				\
 	struct ftrace_raw_##call *entry;				\
-	struct ring_buffer *buffer;					\
-	unsigned long irq_flags;					\
 	int __data_size;						\
-	int pc;								\
 									\
 	if (ftrace_trigger_soft_disabled(ftrace_file))			\
 		return;							\
 									\
-	local_save_flags(irq_flags);					\
-	pc = preempt_count();						\
-									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
-	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,	\
-				 event_call->event.type,		\
-				 sizeof(*entry) + __data_size,		\
-				 irq_flags, pc);			\
-	if (!event)							\
+	entry = ftrace_event_buffer_reserve(&fbuffer, ftrace_file,	\
+				 sizeof(*entry) + __data_size);		\
+									\
+	if (!entry)							\
 		return;							\
-	entry	= ring_buffer_event_data(event);			\
 									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
-	event_trigger_unlock_commit(ftrace_file, buffer, event, entry, \
-				    irq_flags, pc);		       \
+	ftrace_event_buffer_commit(&fbuffer);				\
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b418cb0..0d758ca 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1427,7 +1427,8 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 	return print_one_line(iter, true);
 }
 
-static int blk_tracer_set_flag(u32 old_flags, u32 bit, int set)
+static int
+blk_tracer_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	/* don't output context-info for blk_classic output */
 	if (bit == TRACE_BLK_OPT_CLASSIC) {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d..1fd4b94 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -237,14 +237,13 @@ static int control_ops_alloc(struct ftrace_ops *ops)
 	return 0;
 }
 
-static void control_ops_free(struct ftrace_ops *ops)
-{
-	free_percpu(ops->disabled);
-}
-
 static void update_global_ops(void)
 {
-	ftrace_func_t func;
+	ftrace_func_t func = ftrace_global_list_func;
+	void *private = NULL;
+
+	/* The list has its own recursion protection. */
+	global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
 
 	/*
 	 * If there's only one function registered, then call that
@@ -254,23 +253,17 @@ static void update_global_ops(void)
 	if (ftrace_global_list == &ftrace_list_end ||
 	    ftrace_global_list->next == &ftrace_list_end) {
 		func = ftrace_global_list->func;
+		private = ftrace_global_list->private;
 		/*
 		 * As we are calling the function directly.
 		 * If it does not have recursion protection,
 		 * the function_trace_op needs to be updated
 		 * accordingly.
 		 */
-		if (ftrace_global_list->flags & FTRACE_OPS_FL_RECURSION_SAFE)
-			global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
-		else
+		if (!(ftrace_global_list->flags & FTRACE_OPS_FL_RECURSION_SAFE))
 			global_ops.flags &= ~FTRACE_OPS_FL_RECURSION_SAFE;
-	} else {
-		func = ftrace_global_list_func;
-		/* The list has its own recursion protection. */
-		global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
 	}
 
-
 	/* If we filter on pids, update to use the pid function */
 	if (!list_empty(&ftrace_pids)) {
 		set_ftrace_pid_function(func);
@@ -278,6 +271,7 @@ static void update_global_ops(void)
 	}
 
 	global_ops.func = func;
+	global_ops.private = private;
 }
 
 static void ftrace_sync(struct work_struct *work)
@@ -437,6 +431,9 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
+	if (ops->flags & FTRACE_OPS_FL_DELETED)
+		return -EINVAL;
+
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
@@ -1172,8 +1169,6 @@ struct ftrace_page {
 	int			size;
 };
 
-static struct ftrace_page *ftrace_new_pgs;
-
 #define ENTRY_SIZE sizeof(struct dyn_ftrace)
 #define ENTRIES_PER_PAGE (PAGE_SIZE / ENTRY_SIZE)
 
@@ -1560,7 +1555,7 @@ unsigned long ftrace_location(unsigned long ip)
  * the function tracer. It checks the ftrace internal tables to
  * determine if the address belongs or not.
  */
-int ftrace_text_reserved(void *start, void *end)
+int ftrace_text_reserved(const void *start, const void *end)
 {
 	unsigned long ret;
 
@@ -1994,6 +1989,7 @@ int __weak ftrace_arch_code_modify_post_process(void)
 void ftrace_modify_all_code(int command)
 {
 	int update = command & FTRACE_UPDATE_TRACE_FUNC;
+	int err = 0;
 
 	/*
 	 * If the ftrace_caller calls a ftrace_ops func directly,
@@ -2005,8 +2001,11 @@ void ftrace_modify_all_code(int command)
 	 * to make sure the ops are having the right functions
 	 * traced.
 	 */
-	if (update)
-		ftrace_update_ftrace_func(ftrace_ops_list_func);
+	if (update) {
+		err = ftrace_update_ftrace_func(ftrace_ops_list_func);
+		if (FTRACE_WARN_ON(err))
+			return;
+	}
 
 	if (command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
@@ -2019,13 +2018,16 @@ void ftrace_modify_all_code(int command)
 		/* If irqs are disabled, we are in stop machine */
 		if (!irqs_disabled())
 			smp_call_function(ftrace_sync_ipi, NULL, 1);
-		ftrace_update_ftrace_func(ftrace_trace_function);
+		err = ftrace_update_ftrace_func(ftrace_trace_function);
+		if (FTRACE_WARN_ON(err))
+			return;
 	}
 
 	if (command & FTRACE_START_FUNC_RET)
-		ftrace_enable_ftrace_graph_caller();
+		err = ftrace_enable_ftrace_graph_caller();
 	else if (command & FTRACE_STOP_FUNC_RET)
-		ftrace_disable_ftrace_graph_caller();
+		err = ftrace_disable_ftrace_graph_caller();
+	FTRACE_WARN_ON(err);
 }
 
 static int __ftrace_modify_code(void *data)
@@ -2093,6 +2095,11 @@ static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
 static int global_start_up;
 
+static void control_ops_free(struct ftrace_ops *ops)
+{
+	free_percpu(ops->disabled);
+}
+
 static void ftrace_startup_enable(int command)
 {
 	if (saved_ftrace_func != ftrace_trace_function) {
@@ -2244,7 +2251,6 @@ static void ftrace_shutdown_sysctl(void)
 }
 
 static cycle_t		ftrace_update_time;
-static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
 static inline int ops_traces_mod(struct ftrace_ops *ops)
@@ -2300,11 +2306,12 @@ static int referenced_filters(struct dyn_ftrace *rec)
 	return cnt;
 }
 
-static int ftrace_update_code(struct module *mod)
+static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
+	unsigned long update_cnt = 0;
 	unsigned long ref = 0;
 	bool test = false;
 	int i;
@@ -2330,9 +2337,8 @@ static int ftrace_update_code(struct module *mod)
 	}
 
 	start = ftrace_now(raw_smp_processor_id());
-	ftrace_update_cnt = 0;
 
-	for (pg = ftrace_new_pgs; pg; pg = pg->next) {
+	for (pg = new_pgs; pg; pg = pg->next) {
 
 		for (i = 0; i < pg->index; i++) {
 			int cnt = ref;
@@ -2353,7 +2359,7 @@ static int ftrace_update_code(struct module *mod)
 			if (!ftrace_code_disable(mod, p))
 				break;
 
-			ftrace_update_cnt++;
+			update_cnt++;
 
 			/*
 			 * If the tracing is enabled, go ahead and enable the record.
@@ -2372,11 +2378,9 @@ static int ftrace_update_code(struct module *mod)
 		}
 	}
 
-	ftrace_new_pgs = NULL;
-
 	stop = ftrace_now(raw_smp_processor_id());
 	ftrace_update_time = stop - start;
-	ftrace_update_tot_cnt += ftrace_update_cnt;
+	ftrace_update_tot_cnt += update_cnt;
 
 	return 0;
 }
@@ -2468,22 +2472,6 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	return NULL;
 }
 
-static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
-{
-	int cnt;
-
-	if (!num_to_init) {
-		pr_info("ftrace: No functions to be traced?\n");
-		return -1;
-	}
-
-	cnt = num_to_init / ENTRIES_PER_PAGE;
-	pr_info("ftrace: allocating %ld entries in %d pages\n",
-		num_to_init, cnt + 1);
-
-	return 0;
-}
-
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
 
 struct ftrace_iterator {
@@ -2871,7 +2859,9 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(&global_ops,
+	struct ftrace_ops *ops = inode->i_private;
+
+	return ftrace_regex_open(ops,
 			FTRACE_ITER_FILTER | FTRACE_ITER_DO_HASH,
 			inode, file);
 }
@@ -2879,7 +2869,9 @@ ftrace_filter_open(struct inode *inode, struct file *file)
 static int
 ftrace_notrace_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(&global_ops, FTRACE_ITER_NOTRACE,
+	struct ftrace_ops *ops = inode->i_private;
+
+	return ftrace_regex_open(ops, FTRACE_ITER_NOTRACE,
 				 inode, file);
 }
 
@@ -4109,6 +4101,36 @@ static const struct file_operations ftrace_graph_notrace_fops = {
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
+void ftrace_create_filter_files(struct ftrace_ops *ops,
+				struct dentry *parent)
+{
+
+	trace_create_file("set_ftrace_filter", 0644, parent,
+			  ops, &ftrace_filter_fops);
+
+	trace_create_file("set_ftrace_notrace", 0644, parent,
+			  ops, &ftrace_notrace_fops);
+}
+
+/*
+ * The name "destroy_filter_files" is really a misnomer. Although
+ * in the future, it may actualy delete the files, but this is
+ * really intended to make sure the ops passed in are disabled
+ * and that when this function returns, the caller is free to
+ * free the ops.
+ *
+ * The "destroy" name is only to match the "create" name that this
+ * should be paired with.
+ */
+void ftrace_destroy_filter_files(struct ftrace_ops *ops)
+{
+	mutex_lock(&ftrace_lock);
+	if (ops->flags & FTRACE_OPS_FL_ENABLED)
+		ftrace_shutdown(ops, 0);
+	ops->flags |= FTRACE_OPS_FL_DELETED;
+	mutex_unlock(&ftrace_lock);
+}
+
 static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 {
 
@@ -4118,11 +4140,7 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("enabled_functions", 0444,
 			d_tracer, NULL, &ftrace_enabled_fops);
 
-	trace_create_file("set_ftrace_filter", 0644, d_tracer,
-			NULL, &ftrace_filter_fops);
-
-	trace_create_file("set_ftrace_notrace", 0644, d_tracer,
-				    NULL, &ftrace_notrace_fops);
+	ftrace_create_filter_files(&global_ops, d_tracer);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	trace_create_file("set_graph_function", 0444, d_tracer,
@@ -4238,9 +4256,6 @@ static int ftrace_process_locs(struct module *mod,
 	/* Assign the last page to ftrace_pages */
 	ftrace_pages = pg;
 
-	/* These new locations need to be initialized */
-	ftrace_new_pgs = start_pg;
-
 	/*
 	 * We only need to disable interrupts on start up
 	 * because we are modifying code that an interrupt
@@ -4251,7 +4266,7 @@ static int ftrace_process_locs(struct module *mod,
 	 */
 	if (!mod)
 		local_irq_save(flags);
-	ftrace_update_code(mod);
+	ftrace_update_code(mod, start_pg);
 	if (!mod)
 		local_irq_restore(flags);
 	ret = 0;
@@ -4360,30 +4375,27 @@ struct notifier_block ftrace_module_exit_nb = {
 	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
 };
 
-extern unsigned long __start_mcount_loc[];
-extern unsigned long __stop_mcount_loc[];
-
 void __init ftrace_init(void)
 {
-	unsigned long count, addr, flags;
+	extern unsigned long __start_mcount_loc[];
+	extern unsigned long __stop_mcount_loc[];
+	unsigned long count, flags;
 	int ret;
 
-	/* Keep the ftrace pointer to the stub */
-	addr = (unsigned long)ftrace_stub;
-
 	local_irq_save(flags);
-	ftrace_dyn_arch_init(&addr);
+	ret = ftrace_dyn_arch_init();
 	local_irq_restore(flags);
-
-	/* ftrace_dyn_arch_init places the return code in addr */
-	if (addr)
+	if (ret)
 		goto failed;
 
 	count = __stop_mcount_loc - __start_mcount_loc;
-
-	ret = ftrace_dyn_table_alloc(count);
-	if (ret)
+	if (!count) {
+		pr_info("ftrace: No functions to be traced?\n");
 		goto failed;
+	}
+
+	pr_info("ftrace: allocating %ld entries in %ld pages\n",
+		count, count / ENTRIES_PER_PAGE + 1);
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
@@ -4431,7 +4443,13 @@ static inline void ftrace_startup_enable(int command) { }
 			(ops)->flags |= FTRACE_OPS_FL_ENABLED;		\
 		___ret;							\
 	})
-# define ftrace_shutdown(ops, command) __unregister_ftrace_function(ops)
+# define ftrace_shutdown(ops, command)					\
+	({								\
+		int ___ret = __unregister_ftrace_function(ops);		\
+		if (!___ret)						\
+			(ops)->flags &= ~FTRACE_OPS_FL_ENABLED;		\
+		___ret;							\
+	})
 
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 815c878..c90f55d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -73,7 +73,8 @@ static struct tracer_flags dummy_tracer_flags = {
 	.opts = dummy_tracer_opt
 };
 
-static int dummy_set_flag(u32 old_flags, u32 bit, int set)
+static int
+dummy_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	return 0;
 }
@@ -118,7 +119,7 @@ enum ftrace_dump_mode ftrace_dump_on_oops;
 /* When set, tracing will stop when a WARN*() is hit */
 int __disable_trace_on_warning;
 
-static int tracing_set_tracer(const char *buf);
+static int tracing_set_tracer(struct trace_array *tr, const char *buf);
 
 #define MAX_TRACER_SIZE		100
 static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
@@ -180,6 +181,17 @@ static int __init set_trace_boot_options(char *str)
 }
 __setup("trace_options=", set_trace_boot_options);
 
+static char trace_boot_clock_buf[MAX_TRACER_SIZE] __initdata;
+static char *trace_boot_clock __initdata;
+
+static int __init set_trace_boot_clock(char *str)
+{
+	strlcpy(trace_boot_clock_buf, str, MAX_TRACER_SIZE);
+	trace_boot_clock = trace_boot_clock_buf;
+	return 0;
+}
+__setup("trace_clock=", set_trace_boot_clock);
+
 
 unsigned long long ns2usecs(cycle_t nsec)
 {
@@ -1230,7 +1242,7 @@ int register_tracer(struct tracer *type)
 
 	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
 	/* Do we want this tracer to start on bootup? */
-	tracing_set_tracer(type->name);
+	tracing_set_tracer(&global_trace, type->name);
 	default_bootup_tracer = NULL;
 	/* disable other selftests, since this will break it. */
 	tracing_selftest_disabled = true;
@@ -3121,27 +3133,52 @@ static int tracing_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+/*
+ * Some tracers are not suitable for instance buffers.
+ * A tracer is always available for the global array (toplevel)
+ * or if it explicitly states that it is.
+ */
+static bool
+trace_ok_for_array(struct tracer *t, struct trace_array *tr)
+{
+	return (tr->flags & TRACE_ARRAY_FL_GLOBAL) || t->allow_instances;
+}
+
+/* Find the next tracer that this trace array may use */
+static struct tracer *
+get_tracer_for_array(struct trace_array *tr, struct tracer *t)
+{
+	while (t && !trace_ok_for_array(t, tr))
+		t = t->next;
+
+	return t;
+}
+
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
+	struct trace_array *tr = m->private;
 	struct tracer *t = v;
 
 	(*pos)++;
 
 	if (t)
-		t = t->next;
+		t = get_tracer_for_array(tr, t->next);
 
 	return t;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
+	struct trace_array *tr = m->private;
 	struct tracer *t;
 	loff_t l = 0;
 
 	mutex_lock(&trace_types_lock);
-	for (t = trace_types; t && l < *pos; t = t_next(m, t, &l))
-		;
+
+	t = get_tracer_for_array(tr, trace_types);
+	for (; t && l < *pos; t = t_next(m, t, &l))
+			;
 
 	return t;
 }
@@ -3176,10 +3213,21 @@ static const struct seq_operations show_traces_seq_ops = {
 
 static int show_traces_open(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
+	struct seq_file *m;
+	int ret;
+
 	if (tracing_disabled)
 		return -ENODEV;
 
-	return seq_open(file, &show_traces_seq_ops);
+	ret = seq_open(file, &show_traces_seq_ops);
+	if (ret)
+		return ret;
+
+	m = file->private_data;
+	m->private = tr;
+
+	return 0;
 }
 
 static ssize_t
@@ -3339,13 +3387,14 @@ static int tracing_trace_options_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int __set_tracer_option(struct tracer *trace,
+static int __set_tracer_option(struct trace_array *tr,
 			       struct tracer_flags *tracer_flags,
 			       struct tracer_opt *opts, int neg)
 {
+	struct tracer *trace = tr->current_trace;
 	int ret;
 
-	ret = trace->set_flag(tracer_flags->val, opts->bit, !neg);
+	ret = trace->set_flag(tr, tracer_flags->val, opts->bit, !neg);
 	if (ret)
 		return ret;
 
@@ -3357,8 +3406,9 @@ static int __set_tracer_option(struct tracer *trace,
 }
 
 /* Try to assign a tracer specific option */
-static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
+static int set_tracer_option(struct trace_array *tr, char *cmp, int neg)
 {
+	struct tracer *trace = tr->current_trace;
 	struct tracer_flags *tracer_flags = trace->flags;
 	struct tracer_opt *opts = NULL;
 	int i;
@@ -3367,8 +3417,7 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 		opts = &tracer_flags->opts[i];
 
 		if (strcmp(cmp, opts->name) == 0)
-			return __set_tracer_option(trace, trace->flags,
-						   opts, neg);
+			return __set_tracer_option(tr, trace->flags, opts, neg);
 	}
 
 	return -EINVAL;
@@ -3391,7 +3440,7 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 
 	/* Give the tracer a chance to approve the change */
 	if (tr->current_trace->flag_changed)
-		if (tr->current_trace->flag_changed(tr->current_trace, mask, !!enabled))
+		if (tr->current_trace->flag_changed(tr, mask, !!enabled))
 			return -EINVAL;
 
 	if (enabled)
@@ -3440,7 +3489,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
 
 	/* If no option could be set, test the specific tracer options */
 	if (!trace_options[i])
-		ret = set_tracer_option(tr->current_trace, cmp, neg);
+		ret = set_tracer_option(tr, cmp, neg);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -3869,10 +3918,26 @@ create_trace_option_files(struct trace_array *tr, struct tracer *tracer);
 static void
 destroy_trace_option_files(struct trace_option_dentry *topts);
 
-static int tracing_set_tracer(const char *buf)
+/*
+ * Used to clear out the tracer before deletion of an instance.
+ * Must have trace_types_lock held.
+ */
+static void tracing_set_nop(struct trace_array *tr)
+{
+	if (tr->current_trace == &nop_trace)
+		return;
+	
+	tr->current_trace->enabled--;
+
+	if (tr->current_trace->reset)
+		tr->current_trace->reset(tr);
+
+	tr->current_trace = &nop_trace;
+}
+
+static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 {
 	static struct trace_option_dentry *topts;
-	struct trace_array *tr = &global_trace;
 	struct tracer *t;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	bool had_max_tr;
@@ -3900,9 +3965,15 @@ static int tracing_set_tracer(const char *buf)
 	if (t == tr->current_trace)
 		goto out;
 
+	/* Some tracers are only allowed for the top level buffer */
+	if (!trace_ok_for_array(t, tr)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	trace_branch_disable();
 
-	tr->current_trace->enabled = false;
+	tr->current_trace->enabled--;
 
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
@@ -3925,9 +3996,11 @@ static int tracing_set_tracer(const char *buf)
 		free_snapshot(tr);
 	}
 #endif
-	destroy_trace_option_files(topts);
-
-	topts = create_trace_option_files(tr, t);
+	/* Currently, only the top instance has options */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		destroy_trace_option_files(topts);
+		topts = create_trace_option_files(tr, t);
+	}
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (t->use_max_tr && !had_max_tr) {
@@ -3944,7 +4017,7 @@ static int tracing_set_tracer(const char *buf)
 	}
 
 	tr->current_trace = t;
-	tr->current_trace->enabled = true;
+	tr->current_trace->enabled++;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
@@ -3956,6 +4029,7 @@ static ssize_t
 tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
+	struct trace_array *tr = filp->private_data;
 	char buf[MAX_TRACER_SIZE+1];
 	int i;
 	size_t ret;
@@ -3975,7 +4049,7 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
 		buf[i] = 0;
 
-	err = tracing_set_tracer(buf);
+	err = tracing_set_tracer(tr, buf);
 	if (err)
 		return err;
 
@@ -4683,25 +4757,10 @@ static int tracing_clock_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
-				   size_t cnt, loff_t *fpos)
+static int tracing_set_clock(struct trace_array *tr, const char *clockstr)
 {
-	struct seq_file *m = filp->private_data;
-	struct trace_array *tr = m->private;
-	char buf[64];
-	const char *clockstr;
 	int i;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	clockstr = strstrip(buf);
-
 	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++) {
 		if (strcmp(trace_clocks[i].name, clockstr) == 0)
 			break;
@@ -4729,6 +4788,32 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 
 	mutex_unlock(&trace_types_lock);
 
+	return 0;
+}
+
+static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *fpos)
+{
+	struct seq_file *m = filp->private_data;
+	struct trace_array *tr = m->private;
+	char buf[64];
+	const char *clockstr;
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	clockstr = strstrip(buf);
+
+	ret = tracing_set_clock(tr, clockstr);
+	if (ret)
+		return ret;
+
 	*fpos += cnt;
 
 	return cnt;
@@ -5689,7 +5774,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (!!(topt->flags->val & topt->opt->bit) != val) {
 		mutex_lock(&trace_types_lock);
-		ret = __set_tracer_option(topt->tr->current_trace, topt->flags,
+		ret = __set_tracer_option(topt->tr, topt->flags,
 					  topt->opt, !val);
 		mutex_unlock(&trace_types_lock);
 		if (ret)
@@ -6096,7 +6181,9 @@ static int instance_delete(const char *name)
 
 	list_del(&tr->list);
 
+	tracing_set_nop(tr);
 	event_trace_del_tracer(tr);
+	ftrace_destroy_function_files(tr);
 	debugfs_remove_recursive(tr->dir);
 	free_percpu(tr->trace_buffer.data);
 	ring_buffer_free(tr->trace_buffer.buffer);
@@ -6191,6 +6278,12 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 {
 	int cpu;
 
+	trace_create_file("available_tracers", 0444, d_tracer,
+			tr, &show_traces_fops);
+
+	trace_create_file("current_tracer", 0644, d_tracer,
+			tr, &set_tracer_fops);
+
 	trace_create_file("tracing_cpumask", 0644, d_tracer,
 			  tr, &tracing_cpumask_fops);
 
@@ -6221,6 +6314,9 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("tracing_on", 0644, d_tracer,
 			  tr, &rb_simple_fops);
 
+	if (ftrace_create_function_files(tr, d_tracer))
+		WARN(1, "Could not allocate function filter files");
+
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_file("snapshot", 0644, d_tracer,
 			  tr, &snapshot_fops);
@@ -6243,12 +6339,6 @@ static __init int tracer_init_debugfs(void)
 
 	init_tracer_debugfs(&global_trace, d_tracer);
 
-	trace_create_file("available_tracers", 0444, d_tracer,
-			&global_trace, &show_traces_fops);
-
-	trace_create_file("current_tracer", 0644, d_tracer,
-			&global_trace, &set_tracer_fops);
-
 #ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
@@ -6506,6 +6596,13 @@ __init static int tracer_alloc_buffers(void)
 
 	trace_init_cmdlines();
 
+	if (trace_boot_clock) {
+		ret = tracing_set_clock(&global_trace, trace_boot_clock);
+		if (ret < 0)
+			pr_warning("Trace clock %s not defined, going back to default\n",
+				   trace_boot_clock);
+	}
+
 	/*
 	 * register_tracer() might reference current_trace, so it
 	 * needs to be set before we register anything. This is
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 02b592f..ffc314b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -210,6 +210,11 @@ struct trace_array {
 	struct list_head	events;
 	cpumask_var_t		tracing_cpumask; /* only trace on set CPUs */
 	int			ref;
+#ifdef CONFIG_FUNCTION_TRACER
+	struct ftrace_ops	*ops;
+	/* function tracing enabled */
+	int			function_enabled;
+#endif
 };
 
 enum {
@@ -355,14 +360,16 @@ struct tracer {
 	void			(*print_header)(struct seq_file *m);
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	/* If you handled the flag setting, return 0 */
-	int			(*set_flag)(u32 old_flags, u32 bit, int set);
+	int			(*set_flag)(struct trace_array *tr,
+					    u32 old_flags, u32 bit, int set);
 	/* Return 0 if OK with change, else return non-zero */
-	int			(*flag_changed)(struct tracer *tracer,
+	int			(*flag_changed)(struct trace_array *tr,
 						u32 mask, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
+	int			enabled;
 	bool			print_max;
-	bool			enabled;
+	bool			allow_instances;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	bool			use_max_tr;
 #endif
@@ -812,13 +819,36 @@ static inline int ftrace_trace_task(struct task_struct *task)
 	return test_tsk_trace_trace(task);
 }
 extern int ftrace_is_dead(void);
+int ftrace_create_function_files(struct trace_array *tr,
+				 struct dentry *parent);
+void ftrace_destroy_function_files(struct trace_array *tr);
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	return 1;
 }
 static inline int ftrace_is_dead(void) { return 0; }
-#endif
+static inline int
+ftrace_create_function_files(struct trace_array *tr,
+			     struct dentry *parent)
+{
+	return 0;
+}
+static inline void ftrace_destroy_function_files(struct trace_array *tr) { }
+#endif /* CONFIG_FUNCTION_TRACER */
+
+#if defined(CONFIG_FUNCTION_TRACER) && defined(CONFIG_DYNAMIC_FTRACE)
+void ftrace_create_filter_files(struct ftrace_ops *ops,
+				struct dentry *parent);
+void ftrace_destroy_filter_files(struct ftrace_ops *ops);
+#else
+/*
+ * The ops parameter passed in is usually undefined.
+ * This must be a macro.
+ */
+#define ftrace_create_filter_files(ops, parent) do { } while (0)
+#define ftrace_destroy_filter_files(ops) do { } while (0)
+#endif /* CONFIG_FUNCTION_TRACER && CONFIG_DYNAMIC_FTRACE */
 
 int ftrace_event_is_function(struct ftrace_event_call *call);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e71ffd4..2f7b8e3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -194,6 +194,36 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);
 
+void *ftrace_event_buffer_reserve(struct ftrace_event_buffer *fbuffer,
+				  struct ftrace_event_file *ftrace_file,
+				  unsigned long len)
+{
+	struct ftrace_event_call *event_call = ftrace_file->event_call;
+
+	local_save_flags(fbuffer->flags);
+	fbuffer->pc = preempt_count();
+	fbuffer->ftrace_file = ftrace_file;
+
+	fbuffer->event =
+		trace_event_buffer_lock_reserve(&fbuffer->buffer, ftrace_file,
+						event_call->event.type, len,
+						fbuffer->flags, fbuffer->pc);
+	if (!fbuffer->event)
+		return NULL;
+
+	fbuffer->entry = ring_buffer_event_data(fbuffer->event);
+	return fbuffer->entry;
+}
+EXPORT_SYMBOL_GPL(ftrace_event_buffer_reserve);
+
+void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer)
+{
+	event_trigger_unlock_commit(fbuffer->ftrace_file, fbuffer->buffer,
+				    fbuffer->event, fbuffer->entry,
+				    fbuffer->flags, fbuffer->pc);
+}
+EXPORT_SYMBOL_GPL(ftrace_event_buffer_commit);
+
 int ftrace_event_reg(struct ftrace_event_call *call,
 		     enum trace_reg type, void *data)
 {
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 38fe148..5b781d2 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -13,32 +13,106 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/slab.h>
 #include <linux/fs.h>
 
 #include "trace.h"
 
-/* function tracing enabled */
-static int			ftrace_function_enabled;
+static void tracing_start_function_trace(struct trace_array *tr);
+static void tracing_stop_function_trace(struct trace_array *tr);
+static void
+function_trace_call(unsigned long ip, unsigned long parent_ip,
+		    struct ftrace_ops *op, struct pt_regs *pt_regs);
+static void
+function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
+			  struct ftrace_ops *op, struct pt_regs *pt_regs);
+static struct ftrace_ops trace_ops;
+static struct ftrace_ops trace_stack_ops;
+static struct tracer_flags func_flags;
+
+/* Our option */
+enum {
+	TRACE_FUNC_OPT_STACK	= 0x1,
+};
+
+static int allocate_ftrace_ops(struct trace_array *tr)
+{
+	struct ftrace_ops *ops;
+
+	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
+	if (!ops)
+		return -ENOMEM;
 
-static struct trace_array	*func_trace;
+	/* Currently only the non stack verision is supported */
+	ops->func = function_trace_call;
+	ops->flags = FTRACE_OPS_FL_RECURSION_SAFE;
+
+	tr->ops = ops;
+	ops->private = tr;
+	return 0;
+}
+
+
+int ftrace_create_function_files(struct trace_array *tr,
+				 struct dentry *parent)
+{
+	int ret;
+
+	/* The top level array uses the "global_ops". */
+	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL)) {
+		ret = allocate_ftrace_ops(tr);
+		if (ret)
+			return ret;
+	}
+
+	ftrace_create_filter_files(tr->ops, parent);
+
+	return 0;
+}
 
-static void tracing_start_function_trace(void);
-static void tracing_stop_function_trace(void);
+void ftrace_destroy_function_files(struct trace_array *tr)
+{
+	ftrace_destroy_filter_files(tr->ops);
+	kfree(tr->ops);
+	tr->ops = NULL;
+}
 
 static int function_trace_init(struct trace_array *tr)
 {
-	func_trace = tr;
+	struct ftrace_ops *ops;
+
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		/* There's only one global tr */
+		if (!trace_ops.private) {
+			trace_ops.private = tr;
+			trace_stack_ops.private = tr;
+		}
+
+		if (func_flags.val & TRACE_FUNC_OPT_STACK)
+			ops = &trace_stack_ops;
+		else
+			ops = &trace_ops;
+		tr->ops = ops;
+	} else if (!tr->ops) {
+		/*
+		 * Instance trace_arrays get their ops allocated
+		 * at instance creation. Unless it failed
+		 * the allocation.
+		 */
+		return -ENOMEM;
+	}
+
 	tr->trace_buffer.cpu = get_cpu();
 	put_cpu();
 
 	tracing_start_cmdline_record();
-	tracing_start_function_trace();
+	tracing_start_function_trace(tr);
 	return 0;
 }
 
 static void function_trace_reset(struct trace_array *tr)
 {
-	tracing_stop_function_trace();
+	tracing_stop_function_trace(tr);
 	tracing_stop_cmdline_record();
 }
 
@@ -47,25 +121,18 @@ static void function_trace_start(struct trace_array *tr)
 	tracing_reset_online_cpus(&tr->trace_buffer);
 }
 
-/* Our option */
-enum {
-	TRACE_FUNC_OPT_STACK	= 0x1,
-};
-
-static struct tracer_flags func_flags;
-
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip,
 		    struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
-	struct trace_array *tr = func_trace;
+	struct trace_array *tr = op->private;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	int bit;
 	int cpu;
 	int pc;
 
-	if (unlikely(!ftrace_function_enabled))
+	if (unlikely(!tr->function_enabled))
 		return;
 
 	pc = preempt_count();
@@ -91,14 +158,14 @@ static void
 function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 			  struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
-	struct trace_array *tr = func_trace;
+	struct trace_array *tr = op->private;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
 	int cpu;
 	int pc;
 
-	if (unlikely(!ftrace_function_enabled))
+	if (unlikely(!tr->function_enabled))
 		return;
 
 	/*
@@ -128,7 +195,6 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 	local_irq_restore(flags);
 }
 
-
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = function_trace_call,
@@ -153,29 +219,21 @@ static struct tracer_flags func_flags = {
 	.opts = func_opts
 };
 
-static void tracing_start_function_trace(void)
+static void tracing_start_function_trace(struct trace_array *tr)
 {
-	ftrace_function_enabled = 0;
-
-	if (func_flags.val & TRACE_FUNC_OPT_STACK)
-		register_ftrace_function(&trace_stack_ops);
-	else
-		register_ftrace_function(&trace_ops);
-
-	ftrace_function_enabled = 1;
+	tr->function_enabled = 0;
+	register_ftrace_function(tr->ops);
+	tr->function_enabled = 1;
 }
 
-static void tracing_stop_function_trace(void)
+static void tracing_stop_function_trace(struct trace_array *tr)
 {
-	ftrace_function_enabled = 0;
-
-	if (func_flags.val & TRACE_FUNC_OPT_STACK)
-		unregister_ftrace_function(&trace_stack_ops);
-	else
-		unregister_ftrace_function(&trace_ops);
+	tr->function_enabled = 0;
+	unregister_ftrace_function(tr->ops);
 }
 
-static int func_set_flag(u32 old_flags, u32 bit, int set)
+static int
+func_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	switch (bit) {
 	case TRACE_FUNC_OPT_STACK:
@@ -183,12 +241,14 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 		if (!!set == !!(func_flags.val & TRACE_FUNC_OPT_STACK))
 			break;
 
+		unregister_ftrace_function(tr->ops);
+
 		if (set) {
-			unregister_ftrace_function(&trace_ops);
-			register_ftrace_function(&trace_stack_ops);
+			tr->ops = &trace_stack_ops;
+			register_ftrace_function(tr->ops);
 		} else {
-			unregister_ftrace_function(&trace_stack_ops);
-			register_ftrace_function(&trace_ops);
+			tr->ops = &trace_ops;
+			register_ftrace_function(tr->ops);
 		}
 
 		break;
@@ -208,6 +268,7 @@ static struct tracer function_trace __tracer_data =
 	.wait_pipe	= poll_wait_pipe,
 	.flags		= &func_flags,
 	.set_flag	= func_set_flag,
+	.allow_instances = true,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_function,
 #endif
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 0b99120..deff112 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1476,7 +1476,8 @@ void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
-static int func_graph_set_flag(u32 old_flags, u32 bit, int set)
+static int
+func_graph_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	if (bit == TRACE_GRAPH_PRINT_IRQS)
 		ftrace_graph_skip_irqs = !set;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2aefbee..4bf812f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -160,7 +160,8 @@ static struct ftrace_ops trace_ops __read_mostly =
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+static int
+irqsoff_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	int cpu;
 
@@ -266,7 +267,8 @@ __trace_function(struct trace_array *tr,
 #else
 #define __trace_function trace_function
 
-static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+static int
+irqsoff_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	return -EINVAL;
 }
@@ -570,8 +572,10 @@ static void irqsoff_function_set(int set)
 		unregister_irqsoff_function(is_graph());
 }
 
-static int irqsoff_flag_changed(struct tracer *tracer, u32 mask, int set)
+static int irqsoff_flag_changed(struct trace_array *tr, u32 mask, int set)
 {
+	struct tracer *tracer = tr->current_trace;
+
 	if (mask & TRACE_ITER_FUNCTION)
 		irqsoff_function_set(set);
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index bdbae45..d021d21 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -35,11 +35,6 @@ struct trace_kprobe {
 	struct trace_probe	tp;
 };
 
-struct event_file_link {
-	struct ftrace_event_file	*file;
-	struct list_head		list;
-};
-
 #define SIZEOF_TRACE_KPROBE(n)				\
 	(offsetof(struct trace_kprobe, tp.args) +	\
 	(sizeof(struct probe_arg) * (n)))
@@ -387,18 +382,6 @@ enable_trace_kprobe(struct trace_kprobe *tk, struct ftrace_event_file *file)
 	return ret;
 }
 
-static struct event_file_link *
-find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
-{
-	struct event_file_link *link;
-
-	list_for_each_entry(link, &tp->files, list)
-		if (link->file == file)
-			return link;
-
-	return NULL;
-}
-
 /*
  * Disable trace_probe
  * if the file is NULL, disable "perf" handler, or disable "trace" handler.
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 394f944..69a5cc9 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -62,7 +62,7 @@ static void nop_trace_reset(struct trace_array *tr)
  * If you don't implement it, then the flag setting will be
  * automatically accepted.
  */
-static int nop_set_flag(u32 old_flags, u32 bit, int set)
+static int nop_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	/*
 	 * Note that you don't need to update nop_flags.val yourself.
@@ -96,6 +96,7 @@ struct tracer nop_trace __read_mostly =
 	.selftest	= trace_selftest_startup_nop,
 #endif
 	.flags		= &nop_flags,
-	.set_flag	= nop_set_flag
+	.set_flag	= nop_set_flag,
+	.allow_instances = true,
 };
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed32284..ca0e79e2 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -439,6 +439,37 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 }
 EXPORT_SYMBOL(ftrace_raw_output_prep);
 
+static int ftrace_output_raw(struct trace_iterator *iter, char *name,
+			     char *fmt, va_list ap)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	ret = trace_seq_printf(s, "%s: ", name);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_vprintf(s, fmt, ap);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = ftrace_output_raw(iter, name, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ftrace_output_call);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index b73574a..fb1ab5d 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -288,6 +288,11 @@ struct trace_probe {
 	struct probe_arg		args[];
 };
 
+struct event_file_link {
+	struct ftrace_event_file	*file;
+	struct list_head		list;
+};
+
 static inline bool trace_probe_is_enabled(struct trace_probe *tp)
 {
 	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
@@ -316,6 +321,18 @@ static inline int is_good_name(const char *name)
 	return 1;
 }
 
+static inline struct event_file_link *
+find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
+{
+	struct event_file_link *link;
+
+	list_for_each_entry(link, &tp->files, list)
+		if (link->file == file)
+			return link;
+
+	return NULL;
+}
+
 extern int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		   struct probe_arg *parg, bool is_return, bool is_kprobe);
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 6e32635..e14da5e 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -179,8 +179,10 @@ static void wakeup_function_set(int set)
 		unregister_wakeup_function(is_graph());
 }
 
-static int wakeup_flag_changed(struct tracer *tracer, u32 mask, int set)
+static int wakeup_flag_changed(struct trace_array *tr, u32 mask, int set)
 {
+	struct tracer *tracer = tr->current_trace;
+
 	if (mask & TRACE_ITER_FUNCTION)
 		wakeup_function_set(set);
 
@@ -209,7 +211,8 @@ static void stop_func_tracer(int graph)
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+static int
+wakeup_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 
 	if (!(bit & TRACE_DISPLAY_GRAPH))
@@ -311,7 +314,8 @@ __trace_function(struct trace_array *tr,
 #else
 #define __trace_function trace_function
 
-static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+static int
+wakeup_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 {
 	return -EINVAL;
 }
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index e6be585..21b320e 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -13,6 +13,7 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/magic.h>
 
 #include <asm/setup.h>
 
@@ -144,6 +145,8 @@ check_stack(unsigned long ip, unsigned long *stack)
 			i++;
 	}
 
+	BUG_ON(current != &init_task &&
+		*(end_of_stack(current)) != STACK_END_MAGIC);
  out:
 	arch_spin_unlock(&max_stack_lock);
 	local_irq_restore(flags);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 79e52d9..e447336 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -260,6 +260,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 		goto error;
 
 	INIT_LIST_HEAD(&tu->list);
+	INIT_LIST_HEAD(&tu->tp.files);
 	tu->consumer.handler = uprobe_dispatcher;
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
@@ -758,31 +759,32 @@ static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
 	mutex_unlock(&ucb->mutex);
 }
 
-static void uprobe_trace_print(struct trace_uprobe *tu,
-				unsigned long func, struct pt_regs *regs)
+static void __uprobe_trace_func(struct trace_uprobe *tu,
+				unsigned long func, struct pt_regs *regs,
+				struct uprobe_cpu_buffer *ucb, int dsize,
+				struct ftrace_event_file *ftrace_file)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, dsize, esize;
+	int size, esize;
 	struct ftrace_event_call *call = &tu->tp.call;
 
-	dsize = __get_data_size(&tu->tp, regs);
-	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+	WARN_ON(call != ftrace_file->event_call);
 
-	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->tp.size + dsize > PAGE_SIZE))
+	if (WARN_ON_ONCE(tu->tp.size + dsize > PAGE_SIZE))
 		return;
 
-	ucb = uprobe_buffer_get();
-	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
+	if (ftrace_trigger_soft_disabled(ftrace_file))
+		return;
 
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = esize + tu->tp.size + dsize;
-	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, 0, 0);
+	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
+						call->event.type, size, 0, 0);
 	if (!event)
-		goto out;
+		return;
 
 	entry = ring_buffer_event_data(event);
 	if (is_ret_probe(tu)) {
@@ -796,25 +798,36 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 
 	memcpy(data, ucb->buf, tu->tp.size + dsize);
 
-	if (!call_filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
-
-out:
-	uprobe_buffer_put(ucb);
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry, 0, 0);
 }
 
 /* uprobe handler */
-static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
+			     struct uprobe_cpu_buffer *ucb, int dsize)
 {
-	if (!is_ret_probe(tu))
-		uprobe_trace_print(tu, 0, regs);
+	struct event_file_link *link;
+
+	if (is_ret_probe(tu))
+		return 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(link, &tu->tp.files, list)
+		__uprobe_trace_func(tu, 0, regs, ucb, dsize, link->file);
+	rcu_read_unlock();
+
 	return 0;
 }
 
 static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
-				struct pt_regs *regs)
+				 struct pt_regs *regs,
+				 struct uprobe_cpu_buffer *ucb, int dsize)
 {
-	uprobe_trace_print(tu, func, regs);
+	struct event_file_link *link;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(link, &tu->tp.files, list)
+		__uprobe_trace_func(tu, func, regs, ucb, dsize, link->file);
+	rcu_read_unlock();
 }
 
 /* Event entry printers */
@@ -861,12 +874,24 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
 				struct mm_struct *mm);
 
 static int
-probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
+probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
+		   filter_func_t filter)
 {
-	int ret = 0;
+	bool enabled = trace_probe_is_enabled(&tu->tp);
+	struct event_file_link *link = NULL;
+	int ret;
+
+	if (file) {
+		link = kmalloc(sizeof(*link), GFP_KERNEL);
+		if (!link)
+			return -ENOMEM;
 
-	if (trace_probe_is_enabled(&tu->tp))
-		return -EINTR;
+		link->file = file;
+		list_add_tail_rcu(&link->list, &tu->tp.files);
+
+		tu->tp.flags |= TP_FLAG_TRACE;
+	} else
+		tu->tp.flags |= TP_FLAG_PROFILE;
 
 	ret = uprobe_buffer_enable();
 	if (ret < 0)
@@ -874,24 +899,49 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
 
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
-	tu->tp.flags |= flag;
+	if (enabled)
+		return 0;
+
 	tu->consumer.filter = filter;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
-	if (ret)
-		tu->tp.flags &= ~flag;
+	if (ret) {
+		if (file) {
+			list_del(&link->list);
+			kfree(link);
+			tu->tp.flags &= ~TP_FLAG_TRACE;
+		} else
+			tu->tp.flags &= ~TP_FLAG_PROFILE;
+	}
 
 	return ret;
 }
 
-static void probe_event_disable(struct trace_uprobe *tu, int flag)
+static void
+probe_event_disable(struct trace_uprobe *tu, struct ftrace_event_file *file)
 {
 	if (!trace_probe_is_enabled(&tu->tp))
 		return;
 
+	if (file) {
+		struct event_file_link *link;
+
+		link = find_event_file_link(&tu->tp, file);
+		if (!link)
+			return;
+
+		list_del_rcu(&link->list);
+		/* synchronize with u{,ret}probe_trace_func */
+		synchronize_sched();
+		kfree(link);
+
+		if (!list_empty(&tu->tp.files))
+			return;
+	}
+
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
-	tu->tp.flags &= ~flag;
+	tu->tp.flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
 
 	uprobe_buffer_disable();
 }
@@ -1014,31 +1064,24 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 	return ret;
 }
 
-static void uprobe_perf_print(struct trace_uprobe *tu,
-				unsigned long func, struct pt_regs *regs)
+static void __uprobe_perf_func(struct trace_uprobe *tu,
+			       unsigned long func, struct pt_regs *regs,
+			       struct uprobe_cpu_buffer *ucb, int dsize)
 {
 	struct ftrace_event_call *call = &tu->tp.call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
-	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, dsize, esize;
+	int size, esize;
 	int rctx;
 
-	dsize = __get_data_size(&tu->tp, regs);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
-		return;
-
 	size = esize + tu->tp.size + dsize;
 	size = ALIGN(size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
 		return;
 
-	ucb = uprobe_buffer_get();
-	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
-
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
 	if (hlist_empty(head))
@@ -1068,46 +1111,49 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
-	uprobe_buffer_put(ucb);
 }
 
 /* uprobe profile handler */
-static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs,
+			    struct uprobe_cpu_buffer *ucb, int dsize)
 {
 	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
 		return UPROBE_HANDLER_REMOVE;
 
 	if (!is_ret_probe(tu))
-		uprobe_perf_print(tu, 0, regs);
+		__uprobe_perf_func(tu, 0, regs, ucb, dsize);
 	return 0;
 }
 
 static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
-				struct pt_regs *regs)
+				struct pt_regs *regs,
+				struct uprobe_cpu_buffer *ucb, int dsize)
 {
-	uprobe_perf_print(tu, func, regs);
+	__uprobe_perf_func(tu, func, regs, ucb, dsize);
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
-static
-int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type, void *data)
+static int
+trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
+		      void *data)
 {
 	struct trace_uprobe *tu = event->data;
+	struct ftrace_event_file *file = data;
 
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return probe_event_enable(tu, TP_FLAG_TRACE, NULL);
+		return probe_event_enable(tu, file, NULL);
 
 	case TRACE_REG_UNREGISTER:
-		probe_event_disable(tu, TP_FLAG_TRACE);
+		probe_event_disable(tu, file);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return probe_event_enable(tu, TP_FLAG_PROFILE, uprobe_perf_filter);
+		return probe_event_enable(tu, NULL, uprobe_perf_filter);
 
 	case TRACE_REG_PERF_UNREGISTER:
-		probe_event_disable(tu, TP_FLAG_PROFILE);
+		probe_event_disable(tu, NULL);
 		return 0;
 
 	case TRACE_REG_PERF_OPEN:
@@ -1127,8 +1173,11 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
+	struct uprobe_cpu_buffer *ucb;
+	int dsize, esize;
 	int ret = 0;
 
+
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
@@ -1137,13 +1186,29 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 
 	current->utask->vaddr = (unsigned long) &udd;
 
+#ifdef CONFIG_PERF_EVENTS
+	if ((tu->tp.flags & TP_FLAG_TRACE) == 0 &&
+	    !uprobe_perf_filter(&tu->consumer, 0, current->mm))
+		return UPROBE_HANDLER_REMOVE;
+#endif
+
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
+		return 0;
+
+	dsize = __get_data_size(&tu->tp, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
+
 	if (tu->tp.flags & TP_FLAG_TRACE)
-		ret |= uprobe_trace_func(tu, regs);
+		ret |= uprobe_trace_func(tu, regs, ucb, dsize);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (tu->tp.flags & TP_FLAG_PROFILE)
-		ret |= uprobe_perf_func(tu, regs);
+		ret |= uprobe_perf_func(tu, regs, ucb, dsize);
 #endif
+	uprobe_buffer_put(ucb);
 	return ret;
 }
 
@@ -1152,6 +1217,8 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 {
 	struct trace_uprobe *tu;
 	struct uprobe_dispatch_data udd;
+	struct uprobe_cpu_buffer *ucb;
+	int dsize, esize;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
@@ -1160,13 +1227,23 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 
 	current->utask->vaddr = (unsigned long) &udd;
 
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
+		return 0;
+
+	dsize = __get_data_size(&tu->tp, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
+
 	if (tu->tp.flags & TP_FLAG_TRACE)
-		uretprobe_trace_func(tu, func, regs);
+		uretprobe_trace_func(tu, func, regs, ucb, dsize);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (tu->tp.flags & TP_FLAG_PROFILE)
-		uretprobe_perf_func(tu, func, regs);
+		uretprobe_perf_func(tu, func, regs, ucb, dsize);
 #endif
+	uprobe_buffer_put(ucb);
 	return 0;
 }
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 29f2654..65d9f94 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -62,14 +62,12 @@ struct tracepoint_entry {
 	struct hlist_node hlist;
 	struct tracepoint_func *funcs;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
+	int enabled;	/* Tracepoint enabled */
 	char name[0];
 };
 
 struct tp_probes {
-	union {
-		struct rcu_head rcu;
-		struct list_head list;
-	} u;
+	struct rcu_head rcu;
 	struct tracepoint_func probes[0];
 };
 
@@ -82,7 +80,7 @@ static inline void *allocate_probes(int count)
 
 static void rcu_free_old_probes(struct rcu_head *head)
 {
-	kfree(container_of(head, struct tp_probes, u.rcu));
+	kfree(container_of(head, struct tp_probes, rcu));
 }
 
 static inline void release_probes(struct tracepoint_func *old)
@@ -90,7 +88,7 @@ static inline void release_probes(struct tracepoint_func *old)
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
 			struct tp_probes, probes[0]);
-		call_rcu_sched(&tp_probes->u.rcu, rcu_free_old_probes);
+		call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
 	}
 }
 
@@ -237,6 +235,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
 	memcpy(&e->name[0], name, name_len);
 	e->funcs = NULL;
 	e->refcount = 0;
+	e->enabled = 0;
 	hlist_add_head(&e->hlist, head);
 	return e;
 }
@@ -316,6 +315,7 @@ static void tracepoint_update_probe_range(struct tracepoint * const *begin,
 		if (mark_entry) {
 			set_tracepoint(&mark_entry, *iter,
 					!!mark_entry->refcount);
+			mark_entry->enabled = !!mark_entry->refcount;
 		} else {
 			disable_tracepoint(*iter);
 		}
@@ -373,13 +373,26 @@ tracepoint_add_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_register -  Connect a probe to a tracepoint
  * @name: tracepoint name
  * @probe: probe handler
+ * @data: probe private data
+ *
+ * Returns:
+ * - 0 if the probe was successfully registered, and tracepoint
+ *   callsites are currently loaded for that probe,
+ * - -ENODEV if the probe was successfully registered, but no tracepoint
+ *   callsite is currently loaded for that probe,
+ * - other negative error value on error.
+ *
+ * When tracepoint_probe_register() returns either 0 or -ENODEV,
+ * parameters @name, @probe, and @data may be used by the tracepoint
+ * infrastructure until the probe is unregistered.
  *
- * Returns 0 if ok, error value on error.
  * The probe address must at least be aligned on the architecture pointer size.
  */
 int tracepoint_probe_register(const char *name, void *probe, void *data)
 {
 	struct tracepoint_func *old;
+	struct tracepoint_entry *entry;
+	int ret = 0;
 
 	mutex_lock(&tracepoints_mutex);
 	old = tracepoint_add_probe(name, probe, data);
@@ -388,9 +401,13 @@ int tracepoint_probe_register(const char *name, void *probe, void *data)
 		return PTR_ERR(old);
 	}
 	tracepoint_update_probes();		/* may update entry */
+	entry = get_tracepoint(name);
+	/* Make sure the entry was enabled */
+	if (!entry || !entry->enabled)
+		ret = -ENODEV;
 	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_register);
 
@@ -415,6 +432,7 @@ tracepoint_remove_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
  * @name: tracepoint name
  * @probe: probe function pointer
+ * @data: probe private data
  *
  * We do not need to call a synchronize_sched to make sure the probes have
  * finished running before doing a module unload, because the module unload
@@ -438,204 +456,16 @@ int tracepoint_probe_unregister(const char *name, void *probe, void *data)
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
 
-static LIST_HEAD(old_probes);
-static int need_update;
-
-static void tracepoint_add_old_probes(void *old)
-{
-	need_update = 1;
-	if (old) {
-		struct tp_probes *tp_probes = container_of(old,
-			struct tp_probes, probes[0]);
-		list_add(&tp_probes->u.list, &old_probes);
-	}
-}
-
-/**
- * tracepoint_probe_register_noupdate -  register a probe but not connect
- * @name: tracepoint name
- * @probe: probe handler
- *
- * caller must call tracepoint_probe_update_all()
- */
-int tracepoint_probe_register_noupdate(const char *name, void *probe,
-				       void *data)
-{
-	struct tracepoint_func *old;
-
-	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_add_probe(name, probe, data);
-	if (IS_ERR(old)) {
-		mutex_unlock(&tracepoints_mutex);
-		return PTR_ERR(old);
-	}
-	tracepoint_add_old_probes(old);
-	mutex_unlock(&tracepoints_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tracepoint_probe_register_noupdate);
-
-/**
- * tracepoint_probe_unregister_noupdate -  remove a probe but not disconnect
- * @name: tracepoint name
- * @probe: probe function pointer
- *
- * caller must call tracepoint_probe_update_all()
- */
-int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
-					 void *data)
-{
-	struct tracepoint_func *old;
-
-	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_remove_probe(name, probe, data);
-	if (IS_ERR(old)) {
-		mutex_unlock(&tracepoints_mutex);
-		return PTR_ERR(old);
-	}
-	tracepoint_add_old_probes(old);
-	mutex_unlock(&tracepoints_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tracepoint_probe_unregister_noupdate);
-
-/**
- * tracepoint_probe_update_all -  update tracepoints
- */
-void tracepoint_probe_update_all(void)
-{
-	LIST_HEAD(release_probes);
-	struct tp_probes *pos, *next;
-
-	mutex_lock(&tracepoints_mutex);
-	if (!need_update) {
-		mutex_unlock(&tracepoints_mutex);
-		return;
-	}
-	if (!list_empty(&old_probes))
-		list_replace_init(&old_probes, &release_probes);
-	need_update = 0;
-	tracepoint_update_probes();
-	mutex_unlock(&tracepoints_mutex);
-	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
-		list_del(&pos->u.list);
-		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
-	}
-}
-EXPORT_SYMBOL_GPL(tracepoint_probe_update_all);
-
-/**
- * tracepoint_get_iter_range - Get a next tracepoint iterator given a range.
- * @tracepoint: current tracepoints (in), next tracepoint (out)
- * @begin: beginning of the range
- * @end: end of the range
- *
- * Returns whether a next tracepoint has been found (1) or not (0).
- * Will return the first tracepoint in the range if the input tracepoint is
- * NULL.
- */
-static int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
-	struct tracepoint * const *begin, struct tracepoint * const *end)
-{
-	if (!*tracepoint && begin != end) {
-		*tracepoint = begin;
-		return 1;
-	}
-	if (*tracepoint >= begin && *tracepoint < end)
-		return 1;
-	return 0;
-}
-
-#ifdef CONFIG_MODULES
-static void tracepoint_get_iter(struct tracepoint_iter *iter)
-{
-	int found = 0;
-	struct tp_module *iter_mod;
-
-	/* Core kernel tracepoints */
-	if (!iter->module) {
-		found = tracepoint_get_iter_range(&iter->tracepoint,
-				__start___tracepoints_ptrs,
-				__stop___tracepoints_ptrs);
-		if (found)
-			goto end;
-	}
-	/* Tracepoints in modules */
-	mutex_lock(&tracepoints_mutex);
-	list_for_each_entry(iter_mod, &tracepoint_module_list, list) {
-		/*
-		 * Sorted module list
-		 */
-		if (iter_mod < iter->module)
-			continue;
-		else if (iter_mod > iter->module)
-			iter->tracepoint = NULL;
-		found = tracepoint_get_iter_range(&iter->tracepoint,
-			iter_mod->tracepoints_ptrs,
-			iter_mod->tracepoints_ptrs
-				+ iter_mod->num_tracepoints);
-		if (found) {
-			iter->module = iter_mod;
-			break;
-		}
-	}
-	mutex_unlock(&tracepoints_mutex);
-end:
-	if (!found)
-		tracepoint_iter_reset(iter);
-}
-#else /* CONFIG_MODULES */
-static void tracepoint_get_iter(struct tracepoint_iter *iter)
-{
-	int found = 0;
-
-	/* Core kernel tracepoints */
-	found = tracepoint_get_iter_range(&iter->tracepoint,
-			__start___tracepoints_ptrs,
-			__stop___tracepoints_ptrs);
-	if (!found)
-		tracepoint_iter_reset(iter);
-}
-#endif /* CONFIG_MODULES */
-
-void tracepoint_iter_start(struct tracepoint_iter *iter)
-{
-	tracepoint_get_iter(iter);
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_start);
-
-void tracepoint_iter_next(struct tracepoint_iter *iter)
-{
-	iter->tracepoint++;
-	/*
-	 * iter->tracepoint may be invalid because we blindly incremented it.
-	 * Make sure it is valid by marshalling on the tracepoints, getting the
-	 * tracepoints from following modules if necessary.
-	 */
-	tracepoint_get_iter(iter);
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_next);
-
-void tracepoint_iter_stop(struct tracepoint_iter *iter)
-{
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
-
-void tracepoint_iter_reset(struct tracepoint_iter *iter)
-{
-#ifdef CONFIG_MODULES
-	iter->module = NULL;
-#endif /* CONFIG_MODULES */
-	iter->tracepoint = NULL;
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
 #ifdef CONFIG_MODULES
 static int tracepoint_module_coming(struct module *mod)
 {
-	struct tp_module *tp_mod, *iter;
+	struct tp_module *tp_mod;
 	int ret = 0;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	/*
 	 * We skip modules that taint the kernel, especially those with different
 	 * module headers (for forced load), to make sure we don't cause a crash.
@@ -651,23 +481,7 @@ static int tracepoint_module_coming(struct module *mod)
 	}
 	tp_mod->num_tracepoints = mod->num_tracepoints;
 	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
-
-	/*
-	 * tracepoint_module_list is kept sorted by struct module pointer
-	 * address for iteration on tracepoints from a seq_file that can release
-	 * the mutex between calls.
-	 */
-	list_for_each_entry_reverse(iter, &tracepoint_module_list, list) {
-		BUG_ON(iter == tp_mod);	/* Should never be in the list twice */
-		if (iter < tp_mod) {
-			/* We belong to the location right after iter. */
-			list_add(&tp_mod->list, &iter->list);
-			goto module_added;
-		}
-	}
-	/* We belong to the beginning of the list */
-	list_add(&tp_mod->list, &tracepoint_module_list);
-module_added:
+	list_add_tail(&tp_mod->list, &tracepoint_module_list);
 	tracepoint_update_probe_range(mod->tracepoints_ptrs,
 		mod->tracepoints_ptrs + mod->num_tracepoints);
 end:
@@ -679,6 +493,9 @@ static int tracepoint_module_going(struct module *mod)
 {
 	struct tp_module *pos;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	mutex_lock(&tracepoints_mutex);
 	tracepoint_update_probe_range(mod->tracepoints_ptrs,
 		mod->tracepoints_ptrs + mod->num_tracepoints);
