Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3CUJ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:56:12 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50150 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3CUJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:56:08 -0400
Date: Thu, 21 Mar 2013 10:56:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130321095602.GA15605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: fd4a5aef002bb57e8a35ed34d8a878034b9bde94 perf/x86: Add SNB/SNB-EP scheduling constraints for cycle_activity event

A fair chunk of the linecount comes from a fix for a tracing bug that 
corrupts latency tracing buffers when the overwrite mode is changed on
the fly - the rest is mostly assorted fewliner fixlets.

Thanks,

	Ingo

------------------>
Ananth N Mavinakayanahalli (1):
      perf probe: Fix segfault

Jack Mitchell (1):
      libtraceevent: Remove hard coded include to /usr/local/include in Makefile

Jiri Olsa (1):
      perf record: Fix -C option

Marcin Slusarz (1):
      perf tools: check if -DFORTIFY_SOURCE=2 is allowed

Masami Hiramatsu (2):
      kprobes: Make hash_64() as always inlined
      kprobes/x86: Check Interrupt Flag modifier when registering probe

Michael Ellerman (2):
      perf annotate: Fix build with NO_NEWT=1
      perf report: Fix build with NO_NEWT=1

Namhyung Kim (2):
      perf: Reset hwc->last_period on sw clock events
      perf: Generate EXIT event only once per task context

Stephane Eranian (1):
      perf/x86: Add SNB/SNB-EP scheduling constraints for cycle_activity event

Steven Rostedt (Red Hat) (5):
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()
      tracing: Protect tracer flags with trace_types_lock
      tracing: Keep overwrite in sync between regular and snapshot buffers
      tracing: Prevent buffer overwrite disabled for latency tracers

Sukadev Bhattiprolu (1):
      perf/POWER7: Create a sysfs format entry for Power7 events

Vinson Lee (1):
      perf tools: Fix LIBNUMA build with glibc 2.12 and older.


 arch/powerpc/perf/power7-pmu.c         | 13 ++++++++
 arch/x86/include/asm/kprobes.h         |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c |  4 +++
 arch/x86/kernel/kprobes/core.c         |  5 ++-
 include/linux/hash.h                   |  3 +-
 kernel/events/core.c                   |  8 +++--
 kernel/trace/ftrace.c                  |  4 +--
 kernel/trace/trace.c                   | 59 +++++++++++++++++++++++++++-------
 kernel/trace/trace.h                   |  6 ++++
 kernel/trace/trace_irqsoff.c           | 19 ++++++++---
 kernel/trace/trace_sched_wakeup.c      | 18 ++++++++---
 tools/lib/traceevent/Makefile          |  2 +-
 tools/perf/Makefile                    |  8 ++++-
 tools/perf/bench/bench.h               | 24 ++++++++++++++
 tools/perf/builtin-record.c            |  6 ++--
 tools/perf/util/hist.h                 |  5 +--
 tools/perf/util/strlist.c              |  2 +-
 17 files changed, 152 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index b554879..3c475d6 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -420,7 +420,20 @@ static struct attribute_group power7_pmu_events_group = {
 	.attrs = power7_events_attr,
 };
 
+PMU_FORMAT_ATTR(event, "config:0-19");
+
+static struct attribute *power7_pmu_format_attr[] = {
+	&format_attr_event.attr,
+	NULL,
+};
+
+struct attribute_group power7_pmu_format_group = {
+	.name = "format",
+	.attrs = power7_pmu_format_attr,
+};
+
 static const struct attribute_group *power7_pmu_attr_groups[] = {
+	&power7_pmu_format_group,
 	&power7_pmu_events_group,
 	NULL,
 };
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index d3ddd17..5a6d287 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -77,6 +77,7 @@ struct arch_specific_insn {
 	 * a post_handler or break_handler).
 	 */
 	int boostable;
+	bool if_modifier;
 };
 
 struct arch_optimized_insn {
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 529c893..dab7580 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -101,6 +101,10 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
+	INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x06a3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 3f06e61..7bfe318 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -375,6 +375,9 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 	else
 		p->ainsn.boostable = -1;
 
+	/* Check whether the instruction modifies Interrupt Flag or not */
+	p->ainsn.if_modifier = is_IF_modifier(p->ainsn.insn);
+
 	/* Also, displacement change doesn't affect the first byte */
 	p->opcode = p->ainsn.insn[0];
 }
@@ -434,7 +437,7 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (X86_EFLAGS_TF | X86_EFLAGS_IF));
-	if (is_IF_modifier(p->ainsn.insn))
+	if (p->ainsn.if_modifier)
 		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
 }
 
diff --git a/include/linux/hash.h b/include/linux/hash.h
index 61c97ae..f09a0ae 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -15,6 +15,7 @@
  */
 
 #include <asm/types.h>
+#include <linux/compiler.h>
 
 /* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
 #define GOLDEN_RATIO_PRIME_32 0x9e370001UL
@@ -31,7 +32,7 @@
 #error Wordsize not 32 or 64
 #endif
 
-static inline u64 hash_64(u64 val, unsigned int bits)
+static __always_inline u64 hash_64(u64 val, unsigned int bits)
 {
 	u64 hash = val;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..59412d0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4434,12 +4434,15 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 			if (ctxn < 0)
 				goto next;
 			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+			if (ctx)
+				perf_event_task_ctx(ctx, task_event);
 		}
-		if (ctx)
-			perf_event_task_ctx(ctx, task_event);
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
+	if (task_event->task_ctx)
+		perf_event_task_ctx(task_event->task_ctx, task_event);
+
 	rcu_read_unlock();
 }
 
@@ -5647,6 +5650,7 @@ static void perf_swevent_init_hrtimer(struct perf_event *event)
 		event->attr.sample_period = NSEC_PER_SEC / freq;
 		hwc->sample_period = event->attr.sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
+		hwc->last_period = hwc->sample_period;
 		event->attr.freq = 0;
 	}
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ab25b88..6893d5a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3104,8 +3104,8 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 					continue;
 			}
 
-			hlist_del(&entry->node);
-			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
+			hlist_del_rcu(&entry->node);
+			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
 	__disable_ftrace_function_probe();
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1f835a8..4f1dade 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -704,7 +704,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf;
 
 	if (trace_stop_count)
 		return;
@@ -719,6 +719,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	arch_spin_lock(&ftrace_max_lock);
 
+	buf = tr->buffer;
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
@@ -2880,11 +2881,25 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 	return -EINVAL;
 }
 
-static void set_tracer_flags(unsigned int mask, int enabled)
+/* Some tracers require overwrite to stay enabled */
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
+{
+	if (tracer->enabled && (mask & TRACE_ITER_OVERWRITE) && !set)
+		return -1;
+
+	return 0;
+}
+
+int set_tracer_flag(unsigned int mask, int enabled)
 {
 	/* do nothing if flag is already set */
 	if (!!(trace_flags & mask) == !!enabled)
-		return;
+		return 0;
+
+	/* Give the tracer a chance to approve the change */
+	if (current_trace->flag_changed)
+		if (current_trace->flag_changed(current_trace, mask, !!enabled))
+			return -EINVAL;
 
 	if (enabled)
 		trace_flags |= mask;
@@ -2894,18 +2909,24 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 	if (mask == TRACE_ITER_RECORD_CMD)
 		trace_event_enable_cmd_record(enabled);
 
-	if (mask == TRACE_ITER_OVERWRITE)
+	if (mask == TRACE_ITER_OVERWRITE) {
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+#ifdef CONFIG_TRACER_MAX_TRACE
+		ring_buffer_change_overwrite(max_tr.buffer, enabled);
+#endif
+	}
 
 	if (mask == TRACE_ITER_PRINTK)
 		trace_printk_start_stop_comm(enabled);
+
+	return 0;
 }
 
 static int trace_set_options(char *option)
 {
 	char *cmp;
 	int neg = 0;
-	int ret = 0;
+	int ret = -ENODEV;
 	int i;
 
 	cmp = strstrip(option);
@@ -2915,19 +2936,20 @@ static int trace_set_options(char *option)
 		cmp += 2;
 	}
 
+	mutex_lock(&trace_types_lock);
+
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
-			set_tracer_flags(1 << i, !neg);
+			ret = set_tracer_flag(1 << i, !neg);
 			break;
 		}
 	}
 
 	/* If no option could be set, test the specific tracer options */
-	if (!trace_options[i]) {
-		mutex_lock(&trace_types_lock);
+	if (!trace_options[i])
 		ret = set_tracer_option(current_trace, cmp, neg);
-		mutex_unlock(&trace_types_lock);
-	}
+
+	mutex_unlock(&trace_types_lock);
 
 	return ret;
 }
@@ -2937,6 +2959,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
 	char buf[64];
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2946,7 +2969,9 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
-	trace_set_options(buf);
+	ret = trace_set_options(buf);
+	if (ret < 0)
+		return ret;
 
 	*ppos += cnt;
 
@@ -3250,6 +3275,9 @@ static int tracing_set_tracer(const char *buf)
 		goto out;
 
 	trace_branch_disable();
+
+	current_trace->enabled = false;
+
 	if (current_trace->reset)
 		current_trace->reset(tr);
 
@@ -3294,6 +3322,7 @@ static int tracing_set_tracer(const char *buf)
 	}
 
 	current_trace = t;
+	current_trace->enabled = true;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
@@ -4780,7 +4809,13 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (val != 0 && val != 1)
 		return -EINVAL;
-	set_tracer_flags(1 << index, val);
+
+	mutex_lock(&trace_types_lock);
+	ret = set_tracer_flag(1 << index, val);
+	mutex_unlock(&trace_types_lock);
+
+	if (ret < 0)
+		return ret;
 
 	*ppos += cnt;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 57d7e53..2081971 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -283,11 +283,15 @@ struct tracer {
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	/* If you handled the flag setting, return 0 */
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
+	/* Return 0 if OK with change, else return non-zero */
+	int			(*flag_changed)(struct tracer *tracer,
+						u32 mask, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	bool			print_max;
 	bool			use_max_tr;
 	bool			allocated_snapshot;
+	bool			enabled;
 };
 
 
@@ -943,6 +947,8 @@ extern const char *__stop___trace_bprintk_fmt[];
 
 void trace_printk_init_buffers(void);
 void trace_printk_start_comm(void);
+int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
+int set_tracer_flag(unsigned int mask, int enabled);
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 713a2ca..443b25b 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -32,7 +32,7 @@ enum {
 
 static int trace_type __read_mostly;
 
-static int save_lat_flag;
+static int save_flags;
 
 static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
 static int start_irqsoff_tracer(struct trace_array *tr, int graph);
@@ -558,8 +558,11 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |= TRACE_ITER_LATENCY_FMT;
+	save_flags = trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
 
 	tracing_max_latency = 0;
 	irqsoff_trace = tr;
@@ -573,10 +576,13 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_irqsoff_tracer(tr, is_graph());
 
-	if (!save_lat_flag)
-		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -609,6 +615,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
@@ -642,6 +649,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
@@ -677,6 +685,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.print_line     = irqsoff_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= irqsoff_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 75aa97f..fde652c 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -36,7 +36,7 @@ static void __wakeup_reset(struct trace_array *tr);
 static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
 static void wakeup_graph_return(struct ftrace_graph_ret *trace);
 
-static int save_lat_flag;
+static int save_flags;
 
 #define TRACE_DISPLAY_GRAPH     1
 
@@ -540,8 +540,11 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
-	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
-	trace_flags |= TRACE_ITER_LATENCY_FMT;
+	save_flags = trace_flags;
+
+	/* non overwrite screws up the latency tracers */
+	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
 
 	tracing_max_latency = 0;
 	wakeup_trace = tr;
@@ -563,12 +566,15 @@ static int wakeup_rt_tracer_init(struct trace_array *tr)
 
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
+	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
+	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+
 	stop_wakeup_tracer(tr);
 	/* make sure we put back any tasks we are tracing */
 	wakeup_reset(tr);
 
-	if (!save_lat_flag)
-		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
+	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
@@ -594,6 +600,7 @@ static struct tracer wakeup_tracer __read_mostly =
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
@@ -615,6 +622,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.print_line	= wakeup_print_line,
 	.flags		= &tracer_flags,
 	.set_flag	= wakeup_set_flag,
+	.flag_changed	= trace_keep_overwrite,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index a20e320..0b0a907 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -122,7 +122,7 @@ export Q VERBOSE
 
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-INCLUDES = -I. -I/usr/local/include $(CONFIG_INCLUDES)
+INCLUDES = -I. $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..bb74c79 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -95,7 +95,7 @@ ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
 ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6 -D_FORTIFY_SOURCE=2
+  CFLAGS_OPTIMIZE = -O6
 endif
 
 ifdef PARSER_DEBUG
@@ -180,6 +180,12 @@ ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-W
        CFLAGS := $(CFLAGS) -Wvolatile-register-var
 endif
 
+ifndef PERF_DEBUG
+	ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+		CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
+	endif
+endif
+
 ### --- END CONFIGURATION SECTION ---
 
 ifeq ($(srctree),)
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index a5223e6..0fdc852 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,30 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+/*
+ * The madvise transparent hugepage constants were added in glibc
+ * 2.13. For compatibility with older versions of glibc, define these
+ * tokens if they are not already defined.
+ *
+ * PA-RISC uses different madvise values from other architectures and
+ * needs to be special-cased.
+ */
+#ifdef __hppa__
+# ifndef MADV_HUGEPAGE
+#  define MADV_HUGEPAGE		67
+# endif
+# ifndef MADV_NOHUGEPAGE
+#  define MADV_NOHUGEPAGE	68
+# endif
+#else
+# ifndef MADV_HUGEPAGE
+#  define MADV_HUGEPAGE		14
+# endif
+# ifndef MADV_NOHUGEPAGE
+#  define MADV_NOHUGEPAGE	15
+# endif
+#endif
+
 extern int bench_numa(int argc, const char **argv, const char *prefix);
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 774c907..f1a939e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -573,13 +573,15 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 					 perf_event__synthesize_guest_os, tool);
 	}
 
-	if (!opts->target.system_wide)
+	if (perf_target__has_task(&opts->target))
 		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
 						  process_synthesized_event,
 						  machine);
-	else
+	else if (perf_target__has_cpu(&opts->target))
 		err = perf_event__synthesize_threads(tool, process_synthesized_event,
 					       machine);
+	else /* command specified */
+		err = 0;
 
 	if (err != 0)
 		goto out_delete_session;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3862468..226a4ae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -208,8 +208,9 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 	return 0;
 }
 
-#define K_LEFT -1
-#define K_RIGHT -2
+#define K_LEFT  -1000
+#define K_RIGHT -2000
+#define K_SWITCH_INPUT_DATA -3000
 #endif
 
 #ifdef GTK2_SUPPORT
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 55433aa..eabdce0 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -143,7 +143,7 @@ struct strlist *strlist__new(bool dupstr, const char *list)
 		slist->rblist.node_delete = strlist__node_delete;
 
 		slist->dupstr	 = dupstr;
-		if (slist && strlist__parse_list(slist, list) != 0)
+		if (list && strlist__parse_list(slist, list) != 0)
 			goto out_error;
 	}
 
