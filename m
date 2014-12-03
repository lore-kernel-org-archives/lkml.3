Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaLCWOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:14:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54270 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751514AbaLCWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:13:53 -0500
Message-Id: <20141203221351.799287058@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 03 Dec 2014 17:13:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Byungchul Park <byungchul.park@lge.com>
Subject: [for-next][PATCH 4/5] tracing: Add additional marks to signal very large time deltas
References: <20141203221311.563559646@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-tracing-Add-additional-marks-to-signal-very-large-ti.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Currently, function graph tracer prints "!" or "+" just before
function execution time to signal a function overhead, depending
on the time. And some tracers tracing latency also print "!" or
"+" just after time to signal overhead, depending on the interval
between events. Even it is usually enough to do that, we sometimes
need to signal for bigger execution time than 100 micro seconds.

For example, I used function graph tracer to detect if there is
any case that exit_mm() takes too much time. I did following steps
in /sys/kernel/debug/tracing. It was easier to detect very large
excution time with patched kernel than with original kernel.

$ echo exit_mm > set_graph_function
$ echo function_graph > current_tracer
$ echo > trace
$ cat trace_pipe > $LOGFILE
 ... (do something and terminate logging)
$ grep "\\$" $LOGFILE
 3) $ 22082032 us |                      } /* kernel_map_pages */
 3) $ 22082040 us |                    } /* free_pages_prepare */
 3) $ 22082113 us |                  } /* free_hot_cold_page */
 3) $ 22083455 us |                } /* free_hot_cold_page_list */
 3) $ 22083895 us |              } /* release_pages */
 3) $ 22177873 us |            } /* free_pages_and_swap_cache */
 3) $ 22178929 us |          } /* unmap_single_vma */
 3) $ 22198885 us |        } /* unmap_vmas */
 3) $ 22206949 us |      } /* exit_mmap */
 3) $ 22207659 us |    } /* mmput */
 3) $ 22207793 us |  } /* exit_mm */

And then, it was easy to find out that a schedule-out occured by
sub_preempt_count() within kernel_map_pages().

To detect very large function exection time caused by either problematic
function implementation or scheduling issues, this patch can be useful.

Link: http://lkml.kernel.org/r/1416789259-24038-1-git-send-email-byungchul.park@lge.com

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt       | 10 +++++++---
 kernel/trace/trace.h                 |  2 ++
 kernel/trace/trace_functions_graph.c | 23 +++--------------------
 kernel/trace/trace_output.c          | 34 +++++++++++++++++++++++++++++-----
 4 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index f10f5f5d260d..8408e040f06f 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -685,9 +685,11 @@ The above is mostly meaningful for kernel developers.
 	 needs to be fixed to be only relative to the same CPU.
 	 The marks are determined by the difference between this
 	 current trace and the next trace.
-	  '!' - greater than preempt_mark_thresh (default 100)
-	  '+' - greater than 1 microsecond
-	  ' ' - less than or equal to 1 microsecond.
+	  '$' - greater than 1 second
+	  '#' - greater than 1000 microsecond
+	  '!' - greater than 100 microsecond
+	  '+' - greater than 10 microsecond
+	  ' ' - less than or equal to 10 microsecond.
 
   The rest is the same as the 'trace' file.
 
@@ -1956,6 +1958,8 @@ want, depending on your needs.
 
   + means that the function exceeded 10 usecs.
   ! means that the function exceeded 100 usecs.
+  # means that the function exceeded 1000 usecs.
+  $ means that the function exceeded 1 sec.
 
 
 - The task/pid field displays the thread cmdline and pid which
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c3a37e55ec8b..3255dfb054a0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -708,6 +708,8 @@ enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
+extern char trace_find_mark(unsigned long long duration);
+
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 100288d10e1f..6c2ab955018c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -730,8 +730,6 @@ static void
 print_graph_duration(unsigned long long duration, struct trace_seq *s,
 		     u32 flags)
 {
-	bool duration_printed = false;
-
 	if (!(flags & TRACE_GRAPH_PRINT_DURATION) ||
 	    !(trace_flags & TRACE_ITER_CONTEXT_INFO))
 		return;
@@ -750,24 +748,9 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 	}
 
 	/* Signal a overhead of time execution to the output */
-	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
-		/* Duration exceeded 100 usecs */
-		if (duration > 100000ULL) {
-			trace_seq_puts(s, "! ");
-			duration_printed = true;
-
-		/* Duration exceeded 10 usecs */
-		} else if (duration > 10000ULL) {
-			trace_seq_puts(s, "+ ");
-			duration_printed = true;
-		}
-	}
-
-	/*
-	 * If we did not exceed the duration tresholds or we dont want
-	 * to print out the overhead. Either way we need to fill out the space.
-	 */
-	if (!duration_printed)
+	if (flags & TRACE_GRAPH_PRINT_OVERHEAD)
+		trace_seq_printf(s, "%c ", trace_find_mark(duration));
+	else
 		trace_seq_puts(s, "  ");
 
 	trace_print_graph_duration(duration, s);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 723818bc83b4..b77b9a697619 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -115,7 +115,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 
 	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
 		trace_seq_printf(p, "0x%lx", val);
-		
+
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -443,7 +443,32 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	return trace_print_lat_fmt(s, entry);
 }
 
-static unsigned long preempt_mark_thresh_us = 100;
+#undef MARK
+#define MARK(v, s) {.val = v, .sym = s}
+/* trace overhead mark */
+static const struct trace_mark {
+	unsigned long long	val; /* unit: nsec */
+	char			sym;
+} mark[] = {
+	MARK(1000000000ULL	, '$'), /* 1 sec */
+	MARK(1000000ULL		, '#'), /* 1000 usecs */
+	MARK(100000ULL		, '!'), /* 100 usecs */
+	MARK(10000ULL		, '+'), /* 10 usecs */
+};
+#undef MARK
+
+char trace_find_mark(unsigned long long d)
+{
+	int i;
+	int size = ARRAY_SIZE(mark);
+
+	for (i = 0; i < size; i++) {
+		if (d >= mark[i].val)
+			break;
+	}
+
+	return (i == size) ? ' ' : mark[i].sym;
+}
 
 static int
 lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
@@ -480,8 +505,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 		trace_seq_printf(
 			s, " %4lldus%c: ",
 			abs_ts,
-			rel_ts > preempt_mark_thresh_us ? '!' :
-			rel_ts > 1 ? '+' : ' ');
+			trace_find_mark(rel_ts * NSEC_PER_USEC));
 
 	} else { /* !verbose && !in_ns */
 		trace_seq_printf(s, " %4lld: ", abs_ts);
@@ -663,7 +687,7 @@ int register_ftrace_event(struct trace_event *event)
 				goto out;
 
 		} else {
-			
+
 			event->type = next_event_type++;
 			list = &ftrace_event_list;
 		}
-- 
2.1.3


