Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaKEXF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:05:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:3588 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750931AbaKEXFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:05:25 -0500
Date: Wed, 5 Nov 2014 18:05:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2 v4] ftracetest: Add a couple of ftrace test cases
Message-ID: <20141105180521.1e12b87e@gandalf.local.home>
In-Reply-To: <5459E2AB.8020009@hitachi.com>
References: <20141104152845.521858531@goodmis.org>
	<20141104153028.602754370@goodmis.org>
	<87zjc6ulry.fsf@sejong.aot.lge.com>
	<5459E2AB.8020009@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added three test cases to get the feel of adding tests to ftracetest.
The three cases are:

  function profiling test, to make sure function profiling still works
   with function tracing (was a regression)

  function graph filter test to make sure that function graph filtering works.

  function graph filter with stack tracing test to make sure that the function
   graph filter does filter and also continues to filter when another function tracer
   is running (like the stack tracer)

Link: http://lkml.kernel.org/r/20141103212737.696365174@goodmis.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 89 ++++++++++++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter.tc          | 52 +++++++++++++
 .../ftrace/test.d/ftrace/func_profiler.tc          | 80 +++++++++++++++++++
 3 files changed, 221 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
new file mode 100644
index 000000000000..c15e018e0220
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
@@ -0,0 +1,89 @@
+#!/bin/sh
+# description: ftrace - function graph filters with stack tracer
+
+# Make sure that function graph filtering works, and is not
+# affected by other tracers enabled (like stack tracer)
+
+if ! grep -q function_graph available_tracers; then
+    echo "no function graph tracer configured"
+    exit_unsupported
+fi
+
+if [ ! -f set_ftrace_filter ]; then
+    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
+    exit_unsupported
+fi
+
+do_reset() {
+    reset_tracer
+    echo 0 > /proc/sys/kernel/stack_tracer_enabled
+    enable_tracing
+    clear_trace
+    echo > set_ftrace_filter
+}
+
+fail() { # msg
+    do_reset
+    echo $1
+    exit -1
+}
+
+disable_tracing
+clear_trace;
+
+# filter something, schedule is always good
+if ! echo "schedule" > set_ftrace_filter; then
+    # test for powerpc 64
+    if ! echo ".schedule" > set_ftrace_filter; then
+	fail "can not enable schedule filter"
+    fi
+fi
+
+echo function_graph > current_tracer
+
+if [ ! -f stack_trace ]; then
+    echo "Stack tracer not configured"
+    do_reset
+    exit_unsupported;
+fi
+
+echo "Now testing with stack tracer"
+
+echo 1 > /proc/sys/kernel/stack_tracer_enabled
+
+disable_tracing
+clear_trace
+enable_tracing
+sleep 1
+
+count=`cat trace | grep '()' | grep -v schedule | wc -l`
+
+if [ $count -ne 0 ]; then
+    fail "Graph filtering not working with stack tracer?"
+fi
+
+# Make sure we did find something
+count=`cat trace | grep 'schedule()' | wc -l` 
+if [ $count -eq 0 ]; then
+    fail "No schedule traces found?"
+fi
+
+echo 0 > /proc/sys/kernel/stack_tracer_enabled
+clear_trace
+sleep 1
+
+
+count=`cat trace | grep '()' | grep -v schedule | wc -l`
+
+if [ $count -ne 0 ]; then
+    fail "Graph filtering not working after stack tracer disabled?"
+fi
+
+count=`cat trace | grep 'schedule()' | wc -l` 
+if [ $count -eq 0 ]; then
+    fail "No schedule traces found?"
+fi
+
+do_reset
+
+exit 0
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
new file mode 100644
index 000000000000..6af5f6360b18
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
@@ -0,0 +1,52 @@
+#!/bin/sh
+# description: ftrace - function graph filters
+
+# Make sure that function graph filtering works
+
+if ! grep -q function_graph available_tracers; then
+    echo "no function graph tracer configured"
+    exit_unsupported
+fi
+
+do_reset() {
+    reset_tracer
+    enable_tracing
+    clear_trace
+}
+
+fail() { # msg
+    do_reset
+    echo $1
+    exit -1
+}
+
+disable_tracing
+clear_trace
+
+# filter something, schedule is always good
+if ! echo "schedule" > set_ftrace_filter; then
+    # test for powerpc 64
+    if ! echo ".schedule" > set_ftrace_filter; then
+	fail "can not enable schedule filter"
+    fi
+fi
+
+echo function_graph > current_tracer
+enable_tracing
+sleep 1
+# search for functions (has "()" on the line), and make sure
+# that only the schedule function was found
+count=`cat trace | grep '()' | grep -v schedule | wc -l`
+if [ $count -ne 0 ]; then
+    fail "Graph filtering not working by itself?"
+fi
+
+# Make sure we did find something
+count=`cat trace | grep 'schedule()' | wc -l` 
+if [ $count -eq 0 ]; then
+    fail "No schedule traces found?"
+fi
+
+do_reset
+
+exit 0
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
new file mode 100644
index 000000000000..2e719cb1fc4d
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
@@ -0,0 +1,80 @@
+#!/bin/sh
+# description: ftrace - function profiler with function tracing
+
+# There was a bug after a rewrite of the ftrace infrastructure that
+# caused the function_profiler not to be able to run with the function
+# tracer, because the function_profiler used the function_graph tracer
+# and it was assumed the two could not run simultaneously.
+#
+# There was another related bug where the solution to the first bug
+# broke the way filtering of the function tracer worked.
+#
+# This test triggers those bugs on those kernels.
+#
+# We need function_graph and profiling to to run this test
+if ! grep -q function_graph available_tracers; then
+    echo "no function graph tracer configured"
+    exit_unsupported;
+fi
+
+if [ ! -f set_ftrace_filter ]; then
+    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
+    exit_unsupported
+fi
+
+if [ ! -f function_profile_enabled ]; then
+    echo "function_profile_enabled not found, function profiling enabled?"
+    exit_unsupported
+fi
+
+fail() { # mesg
+    reset_tracer
+    echo > set_ftrace_filter
+    echo $1
+    exit -1
+}
+
+echo "Testing function tracer with profiler:"
+echo "enable function tracer"
+echo function > current_tracer
+echo "enable profiler"
+echo 1 > function_profile_enabled
+
+sleep 1
+
+echo "Now filter on just schedule"
+echo '*schedule' > set_ftrace_filter
+clear_trace
+
+echo "Now disable function profiler"
+echo 0 > function_profile_enabled
+
+sleep 1
+
+# make sure only schedule functions exist
+
+echo "testing if only schedule is being traced"
+if grep -v -e '^#' -e 'schedule' trace; then
+	fail "more than schedule was found"
+fi
+
+echo "Make sure schedule was traced"
+if ! grep -e 'schedule' trace > /dev/null; then
+	cat trace
+	fail "can not find schedule in trace"
+fi
+
+echo > set_ftrace_filter
+clear_trace
+
+sleep 1
+
+echo "make sure something other than scheduler is being traced"
+if ! grep -v -e '^#' -e 'schedule' trace > /dev/null; then
+	cat trace
+	fail "no other functions besides schedule was found"
+fi
+
+reset_tracer
+
+exit 0
-- 
1.8.1.4

