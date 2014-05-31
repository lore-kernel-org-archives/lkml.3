Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015AbaEaBjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:39:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:29851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932689AbaEaBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:39:28 -0400
Message-Id: <20140531013926.171750224@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 30 May 2014 21:39:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 4/7] tracing: Add tracepoint benchmark tracepoint
References: <20140531013857.160310242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Add-tracepoint-benchmark-tracepoint.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In order to help benchmark the time tracepoints take, a new config
option is added called CONFIG_TRACEPOINT_BENCHMARK. When this option
is set a tracepoint is created called "benchmark:benchmark_event".
When the tracepoint is enabled, it kicks off a kernel thread that
goes into an infinite loop (calling cond_sched() to let other tasks
run), and calls the tracepoint. Each iteration will record the time
it took to write to the tracepoint and the next iteration that
data will be passed to the tracepoint itself. That is, the tracepoint
will report the time it took to do the previous tracepoint.
The string written to the tracepoint is a static string of 128 bytes
to keep the time the same. The initial string is simply a write of
"START". The second string records the cold cache time of the first
write which is not added to the rest of the calculations.

As it is a tight loop, it benchmarks as hot cache. That's fine because
we care most about hot paths that are probably in cache already.

An example of the output:

     START
     first=3672 [COLD CACHED]
     last=632 first=3672 max=632 min=632 avg=316 std=446 std^2=199712
     last=278 first=3672 max=632 min=278 avg=303 std=316 std^2=100337
     last=277 first=3672 max=632 min=277 avg=296 std=258 std^2=67064
     last=273 first=3672 max=632 min=273 avg=292 std=224 std^2=50411
     last=273 first=3672 max=632 min=273 avg=288 std=200 std^2=40389
     last=281 first=3672 max=632 min=273 avg=287 std=183 std^2=33666

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig           |  30 +++++++
 kernel/trace/Makefile          |   3 +
 kernel/trace/trace_benchmark.c | 176 +++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_benchmark.h |  41 ++++++++++
 4 files changed, 250 insertions(+)
 create mode 100644 kernel/trace/trace_benchmark.c
 create mode 100644 kernel/trace/trace_benchmark.h

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8639819f6cef..d4409356f40d 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -535,6 +535,36 @@ config MMIOTRACE_TEST
 
 	  Say N, unless you absolutely know what you are doing.
 
+config TRACEPOINT_BENCHMARK
+        bool "Add tracepoint that benchmarks tracepoints"
+	help
+	 This option creates the tracepoint "benchmark:benchmark_event".
+	 When the tracepoint is enabled, it kicks off a kernel thread that
+	 goes into an infinite loop (calling cond_sched() to let other tasks
+	 run), and calls the tracepoint. Each iteration will record the time
+	 it took to write to the tracepoint and the next iteration that
+	 data will be passed to the tracepoint itself. That is, the tracepoint
+	 will report the time it took to do the previous tracepoint.
+	 The string written to the tracepoint is a static string of 128 bytes
+	 to keep the time the same. The initial string is simply a write of
+	 "START". The second string records the cold cache time of the first
+	 write which is not added to the rest of the calculations.
+
+	 As it is a tight loop, it benchmarks as hot cache. That's fine because
+	 we care most about hot paths that are probably in cache already.
+
+	 An example of the output:
+
+	      START
+	      first=3672 [COLD CACHED]
+	      last=632 first=3672 max=632 min=632 avg=316 std=446 std^2=199712
+	      last=278 first=3672 max=632 min=278 avg=303 std=316 std^2=100337
+	      last=277 first=3672 max=632 min=277 avg=296 std=258 std^2=67064
+	      last=273 first=3672 max=632 min=273 avg=292 std=224 std^2=50411
+	      last=273 first=3672 max=632 min=273 avg=288 std=200 std^2=40389
+	      last=281 first=3672 max=632 min=273 avg=287 std=183 std^2=33666
+
+
 config RING_BUFFER_BENCHMARK
 	tristate "Ring buffer benchmark stress tester"
 	depends on RING_BUFFER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 1378e84fbe39..2611613f14f1 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -17,6 +17,7 @@ ifdef CONFIG_TRACING_BRANCHES
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_trace_benchmark.o := -I$(src)
 CFLAGS_trace_events_filter.o := -I$(src)
 
 obj-$(CONFIG_TRACE_CLOCK) += trace_clock.o
@@ -62,4 +63,6 @@ endif
 obj-$(CONFIG_PROBE_EVENTS) += trace_probe.o
 obj-$(CONFIG_UPROBE_EVENT) += trace_uprobe.o
 
+obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
+
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_benchmark.c b/kernel/trace/trace_benchmark.c
new file mode 100644
index 000000000000..7dc1c42dfee2
--- /dev/null
+++ b/kernel/trace/trace_benchmark.c
@@ -0,0 +1,176 @@
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/trace_clock.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace_benchmark.h"
+
+static struct task_struct *bm_event_thread;
+
+static char bm_str[BENCHMARK_EVENT_STRLEN] = "START";
+
+static u64 bm_total;
+static u64 bm_totalsq;
+static u64 bm_last;
+static u64 bm_max;
+static u64 bm_min;
+static u64 bm_first;
+static s64 bm_cnt;
+
+/*
+ * This gets called in a loop recording the time it took to write
+ * the tracepoint. What it writes is the time statistics of the last
+ * tracepoint write. As there is nothing to write the first time
+ * it simply writes "START". As the first write is cold cache and
+ * the rest is hot, we save off that time in bm_first and it is
+ * reported as "first", which is shown in the second write to the
+ * tracepoint. The "first" field is writen within the statics from
+ * then on but never changes.
+ */
+static void trace_do_benchmark(void)
+{
+	u64 start;
+	u64 stop;
+	u64 delta;
+	s64 stddev;
+	u64 seed;
+	u64 seedsq;
+	u64 last_seed;
+	unsigned int avg;
+	unsigned int std = 0;
+
+	/* Only run if the tracepoint is actually active */
+	if (!trace_benchmark_event_enabled())
+		return;
+
+	local_irq_disable();
+	start = trace_clock_local();
+	trace_benchmark_event(bm_str);
+	stop = trace_clock_local();
+	local_irq_enable();
+
+	bm_cnt++;
+
+	delta = stop - start;
+
+	/*
+	 * The first read is cold cached, keep it separate from the
+	 * other calculations.
+	 */
+	if (bm_cnt == 1) {
+		bm_first = delta;
+		scnprintf(bm_str, BENCHMARK_EVENT_STRLEN,
+			  "first=%llu [COLD CACHED]", bm_first);
+		return;
+	}
+
+	bm_last = delta;
+
+	bm_total += delta;
+	bm_totalsq += delta * delta;
+
+	if (delta > bm_max)
+		bm_max = delta;
+	if (!bm_min || delta < bm_min)
+		bm_min = delta;
+
+	if (bm_cnt > 1) {
+		/*
+		 * Apply Welford's method to calculate standard deviation:
+		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
+		 */
+		stddev = (u64)bm_cnt * bm_totalsq - bm_total * bm_total;
+		do_div(stddev, bm_cnt);
+		do_div(stddev, bm_cnt - 1);
+	} else
+		stddev = 0;
+
+	delta = bm_total;
+	do_div(delta, bm_cnt);
+	avg = delta;
+
+	if (stddev > 0) {
+		int i = 0;
+		/*
+		 * stddev is the square of standard deviation but
+		 * we want the actualy number. Use the average
+		 * as our seed to find the std.
+		 *
+		 * The next try is:
+		 *  x = (x + N/x) / 2
+		 *
+		 * Where N is the squared number to find the square
+		 * root of.
+		 */
+		seed = avg;
+		do {
+			last_seed = seed;
+			seed = stddev;
+			if (!last_seed)
+				break;
+			do_div(seed, last_seed);
+			seed += last_seed;
+			do_div(seed, 2);
+		} while (i++ < 10 && last_seed != seed);
+
+		std = seed;
+	}
+
+	scnprintf(bm_str, BENCHMARK_EVENT_STRLEN,
+		  "last=%llu first=%llu max=%llu min=%llu avg=%u std=%d std^2=%lld",
+		  bm_last, bm_first, bm_max, bm_min, avg, std, stddev);
+}
+
+static int benchmark_event_kthread(void *arg)
+{
+	/* sleep a bit to make sure the tracepoint gets activated */
+	msleep(100);
+
+	while (!kthread_should_stop()) {
+
+		trace_do_benchmark();
+
+		/*
+		 * We don't go to sleep, but let others
+		 * run as well.
+		 */
+		cond_resched();
+	}
+
+	return 0;
+}
+
+/*
+ * When the benchmark tracepoint is enabled, it calls this
+ * function and the thread that calls the tracepoint is created.
+ */
+void trace_benchmark_reg(void)
+{
+	bm_event_thread = kthread_run(benchmark_event_kthread,
+				      NULL, "event_benchmark");
+	WARN_ON(!bm_event_thread);
+}
+
+/*
+ * When the benchmark tracepoint is disabled, it calls this
+ * function and the thread that calls the tracepoint is deleted
+ * and all the numbers are reset.
+ */
+void trace_benchmark_unreg(void)
+{
+	if (!bm_event_thread)
+		return;
+
+	kthread_stop(bm_event_thread);
+
+	strcpy(bm_str, "START");
+	bm_total = 0;
+	bm_totalsq = 0;
+	bm_last = 0;
+	bm_max = 0;
+	bm_min = 0;
+	bm_cnt = 0;
+	/* bm_first doesn't need to be reset but reset it anyway */
+	bm_first = 0;
+}
diff --git a/kernel/trace/trace_benchmark.h b/kernel/trace/trace_benchmark.h
new file mode 100644
index 000000000000..3c1df1df4e29
--- /dev/null
+++ b/kernel/trace/trace_benchmark.h
@@ -0,0 +1,41 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM benchmark
+
+#if !defined(_TRACE_BENCHMARK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BENCHMARK_H
+
+#include <linux/tracepoint.h>
+
+extern void trace_benchmark_reg(void);
+extern void trace_benchmark_unreg(void);
+
+#define BENCHMARK_EVENT_STRLEN		128
+
+TRACE_EVENT_FN(benchmark_event,
+
+	TP_PROTO(const char *str),
+
+	TP_ARGS(str),
+
+	TP_STRUCT__entry(
+		__array(	char,	str,	BENCHMARK_EVENT_STRLEN	)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->str, str, BENCHMARK_EVENT_STRLEN);
+	),
+
+	TP_printk("%s", __entry->str),
+
+	trace_benchmark_reg, trace_benchmark_unreg
+);
+
+#endif /* _TRACE_BENCHMARK_H */
+
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_benchmark
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.0.0.rc2


