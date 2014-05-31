Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114AbaEaBlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:41:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:29851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932332AbaEaBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:39:27 -0400
Message-Id: <20140531013925.728881915@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 30 May 2014 21:38:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Elliott <elliott@hp.com>
Subject: [for-next][PATCH 2/7] tracing: Add funcgraph_tail option to print function name after
 closing braces
References: <20140531013857.160310242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-Add-funcgraph_tail-option-to-print-function-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

In the function-graph tracer, add a funcgraph_tail option
to print the function name on all } lines, not just
functions whose first line is no longer in the trace
buffer.

If a function calls other traced functions, its total
time appears on its } line.  This change allows grep
to be used to determine the function for which the
line corresponds.

Update Documentation/trace/ftrace.txt to describe
this new option.

Link: http://lkml.kernel.org/p/20140520221041.8359.6782.stgit@beardog.cce.hp.com

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt       | 26 ++++++++++++++++++++++++++
 kernel/trace/trace.h                 |  1 +
 kernel/trace/trace_functions_graph.c |  9 ++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bd365988e8d8..2479b2a0c77c 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -2003,6 +2003,32 @@ want, depending on your needs.
   360.774530 |   1)   0.594 us    |                                          __phys_addr();
 
 
+The function name is always displayed after the closing bracket
+for a function if the start of that function is not in the
+trace buffer.
+
+Display of the function name after the closing bracket may be
+enabled for functions whose start is in the trace buffer,
+allowing easier searching with grep for function durations.
+It is default disabled.
+
+	hide: echo nofuncgraph-tail > trace_options
+	show: echo funcgraph-tail > trace_options
+
+  Example with nofuncgraph-tail (default):
+  0)               |      putname() {
+  0)               |        kmem_cache_free() {
+  0)   0.518 us    |          __phys_addr();
+  0)   1.757 us    |        }
+  0)   2.861 us    |      }
+
+  Example with funcgraph-tail:
+  0)               |      putname() {
+  0)               |        kmem_cache_free() {
+  0)   0.518 us    |          __phys_addr();
+  0)   1.757 us    |        } /* kmem_cache_free() */
+  0)   2.861 us    |      } /* putname() */
+
 You can put some comments on specific functions by using
 trace_printk() For example, if you want to put a comment inside
 the __might_sleep() function, you just have to include
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 68050633255e..217207ad60b3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -725,6 +725,7 @@ extern unsigned long trace_flags;
 #define TRACE_GRAPH_PRINT_DURATION      0x10
 #define TRACE_GRAPH_PRINT_ABS_TIME      0x20
 #define TRACE_GRAPH_PRINT_IRQS          0x40
+#define TRACE_GRAPH_PRINT_TAIL          0x80
 #define TRACE_GRAPH_PRINT_FILL_SHIFT	28
 #define TRACE_GRAPH_PRINT_FILL_MASK	(0x3 << TRACE_GRAPH_PRINT_FILL_SHIFT)
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index af08dd531cb8..4de3e57f723c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -55,11 +55,13 @@ static struct tracer_opt trace_opts[] = {
 	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
 	/* Display interrupts */
 	{ TRACER_OPT(funcgraph-irqs, TRACE_GRAPH_PRINT_IRQS) },
+	/* Display function name after trailing } */
+	{ TRACER_OPT(funcgraph-tail, TRACE_GRAPH_PRINT_TAIL) },
 	{ } /* Empty entry */
 };
 
 static struct tracer_flags tracer_flags = {
-	/* Don't display overruns and proc by default */
+	/* Don't display overruns, proc, or tail by default */
 	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD |
 	       TRACE_GRAPH_PRINT_DURATION | TRACE_GRAPH_PRINT_IRQS,
 	.opts = trace_opts
@@ -1167,9 +1169,10 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	 * If the return function does not have a matching entry,
 	 * then the entry was lost. Instead of just printing
 	 * the '}' and letting the user guess what function this
-	 * belongs to, write out the function name.
+	 * belongs to, write out the function name. Always do
+	 * that if the funcgraph-tail option is enabled.
 	 */
-	if (func_match) {
+	if (func_match && !(flags & TRACE_GRAPH_PRINT_TAIL)) {
 		ret = trace_seq_puts(s, "}\n");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-- 
2.0.0.rc2


