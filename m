Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568Ab3GSOPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:15:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3GSOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:55 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=tGu0RMdkLCQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=k0UNxTuNHs8A:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=40MIqcmNAAAA:8 a=7Ev89W78az0QUTzO2gEA:9 a=jeBq3FmKZ4MA:10 a=dGJ0OcVc7YAA:10 a=-tENaG0q7zQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130719141449.914545398@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 10:12:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        Chen Gang <gang.chen@asianux.com>
Subject: [for-next-3.11][PATCH 10/12] tracing: Add ref_data to function and fgraph tracer structs
References: <20130719141224.703522101@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Add-ref_data-to-function-and-fgraph-tracer-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The selftest for function and function graph tracers are defined as
__init, as they are only executed at boot up. The "tracer" structs
that are associated to those tracers are not setup as __init as they
are used after boot. To stop mismatch warnings, those structures
need to be annotated with __ref_data.

Currently, the tracer structures are defined to __read_mostly, as they
do not really change. But in the future they should be converted to
consts, but that will take a little work because they have a "next"
pointer that gets updated when they are registered. That will have to
wait till the next major release.

Link: http://lkml.kernel.org/r/1373596735.17876.84.camel@gandalf.local.home

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                 |    9 +++++++++
 kernel/trace/trace_functions.c       |    2 +-
 kernel/trace/trace_functions_graph.c |    2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4a4f6e1..57b7bb0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -680,6 +680,15 @@ extern int trace_selftest_startup_sched_switch(struct tracer *trace,
 					       struct trace_array *tr);
 extern int trace_selftest_startup_branch(struct tracer *trace,
 					 struct trace_array *tr);
+/*
+ * Tracer data references selftest functions that only occur
+ * on boot up. These can be __init functions. Thus, when selftests
+ * are enabled, then the tracers need to reference __init functions.
+ */
+#define __tracer_data		__refdata
+#else
+/* Tracers are seldom changed. Optimize when selftests are disabled. */
+#define __tracer_data		__read_mostly
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b863f93..38fe148 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -199,7 +199,7 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 	return 0;
 }
 
-static struct tracer function_trace __read_mostly =
+static struct tracer function_trace __tracer_data =
 {
 	.name		= "function",
 	.init		= function_trace_init,
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d56ae9b..b5c0924 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1448,7 +1448,7 @@ static struct trace_event graph_trace_ret_event = {
 	.funcs		= &graph_functions
 };
 
-static struct tracer graph_trace __read_mostly = {
+static struct tracer graph_trace __tracer_data = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
 	.pipe_open	= graph_trace_open,
-- 
1.7.10.4


