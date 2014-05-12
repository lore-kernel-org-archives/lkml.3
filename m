Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaELWUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:20:09 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:34731 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaELWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:20:07 -0400
Subject: [PATCH 2/2] In the function-graph tracer, add a funcgraph_tail option
To: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
From: Robert Elliott <elliott@hp.com>
Date: Mon, 12 May 2014 17:18:41 -0500
Message-ID: <20140512221841.14555.91944.stgit@beardog.cce.hp.com>
In-Reply-To: <20140512221729.14555.57686.stgit@beardog.cce.hp.com>
References: <20140512221729.14555.57686.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to print the function name on all } lines, not just
functions whose first line is no longer in the trace
buffer.

If a function calls other traced functions, its total
time appears on its } line.  This change allows grep
to be used to determine the function for which the
line corresponds.

Update Documentation/trace/ftrace.txt to describe
this new option.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 Documentation/trace/ftrace.txt       |   26 ++++++++++++++++++++++++++
 kernel/trace/trace.h                 |    1 +
 kernel/trace/trace_functions_graph.c |    9 ++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bd36598..2479b2a 100644
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
index 861668a..5ca365f 100644
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
index ab78221..ba10bb0 100644
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

