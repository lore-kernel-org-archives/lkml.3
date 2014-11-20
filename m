Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbaKTAPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:15:43 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60929 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaKTAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:15:41 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com, Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v5 2/2] tracing: add additional marks to signal very large time
Date: Thu, 20 Nov 2014 09:15:35 +0900
Message-Id: <1416442535-31188-3-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
References: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Currently, function graph tracer prints "!" or "+" just before
function execution time to signal a function overhead, depending
on the time. And some tracers tracing latency also print "!" or
"+" just after time to signal overhead, depending on the interval
between events. Even it is usually enough to do that, we sometimes
need to be signaled for bigger execution time than 100 micro seconds.

For example, I used function graph tracer to detect if there is
any case that exit_mm() takes too much time. I did following steps
in /sys/kernel/debug/tracing. It was easier to detect very big
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

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 Documentation/trace/ftrace.txt       |   10 +++++++---
 kernel/trace/trace.h                 |    2 ++
 kernel/trace/trace_functions_graph.c |    7 +------
 kernel/trace/trace_output.c          |   35 +++++++++++++++++++++++++++++-----
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 4da4261..64efb3e 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -680,9 +680,11 @@ The above is mostly meaningful for kernel developers.
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
 
@@ -1951,6 +1953,8 @@ want, depending on your needs.
 
   + means that the function exceeded 10 usecs.
   ! means that the function exceeded 100 usecs.
+  # means that the function exceeded 1000 usecs.
+  $ means that the function exceeded 1 sec.
 
 
 - The task/pid field displays the thread cmdline and pid which
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 385391f..0aaf10d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -719,6 +719,8 @@ enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
+extern char trace_find_mark(unsigned long long duration);
+
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index cb33f46..1ecb1ad 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -822,12 +822,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 
 	/* Signal a overhead of time execution to the output */
 	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
-		/* Duration exceeded 100 usecs */
-		if (duration > 100000ULL)
-			ret = trace_seq_puts(s, "! ");
-		/* Duration exceeded 10 usecs */
-		else if (duration > 10000ULL)
-			ret = trace_seq_puts(s, "+ ");
+		ret = trace_seq_printf(s, "%c ", trace_find_mark(duration));
 	}
 
 	/*
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c6977d5..8d19f3d 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -124,7 +124,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 
 	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
 		trace_seq_printf(p, "0x%lx", val);
-		
+
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -471,7 +471,33 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
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
+	MARK(0ULL		, ' '), /* 0 usecs */
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
+	return (i == size)? ' ' : mark[i].sym;
+}
 
 static int
 lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
@@ -506,8 +532,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 		return trace_seq_printf(
 				s, " %4lldus%c: ",
 				abs_ts,
-				rel_ts > preempt_mark_thresh_us ? '!' :
-				  rel_ts > 1 ? '+' : ' ');
+				trace_find_mark(rel_ts * NSEC_PER_USEC));
 	} else { /* !verbose && !in_ns */
 		return trace_seq_printf(s, " %4lld: ", abs_ts);
 	}
@@ -692,7 +717,7 @@ int register_ftrace_event(struct trace_event *event)
 				goto out;
 
 		} else {
-			
+
 			event->type = next_event_type++;
 			list = &ftrace_event_list;
 		}
-- 
1.7.9.5

