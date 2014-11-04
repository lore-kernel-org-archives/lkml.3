Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaKDPad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:30:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:2435 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753984AbaKDPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:30:30 -0500
Message-Id: <20141104153028.602754370@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:28:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/2 v3] ftracetest: Add a couple of ftrace test cases
References: <20141104152845.521858531@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftracetest-Add-a-couple-of-ftrace-test-cases.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

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
 .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 88 ++++++++++++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter.tc          | 49 ++++++++++++
 .../ftrace/test.d/ftrace/func_profiler.tc          | 76 +++++++++++++++++++
 3 files changed, 213 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
new file mode 100644
index 000000000000..216d5c55776a
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
@@ -0,0 +1,88 @@
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
+disable_tracing
+clear_trace;
+
+# filter something, schedule is always good
+if ! echo "schedule" > set_ftrace_filter; then
+    # test for powerpc 64
+    if ! echo ".schedule" > set_ftrace_filter; then
+	echo "can not enable schedule filter"
+	exit -1
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
+    echo "Graph filtering not working with stack tracer?"
+    exit -1
+fi
+
+# Make sure we did find something
+count=`cat trace | grep 'schedule()' | wc -l` 
+if [ $count -eq 0 ]; then
+    echo "No schedule traces found?"
+    exit -1
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
+    echo "Graph filtering not working after stack tracer disabled?"
+    exit -1
+fi
+
+count=`cat trace | grep 'schedule()' | wc -l` 
+if [ $count -eq 0 ]; then
+    echo "No schedule traces found?"
+    exit -1
+fi
+
+do_reset
+
+exit 0
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
new file mode 100644
index 000000000000..18bda31c4c54
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
@@ -0,0 +1,49 @@
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
+disable_tracing
+clear_trace
+
+# filter something, schedule is always good
+if ! echo "schedule" > set_ftrace_filter; then
+    # test for powerpc 64
+    if ! echo ".schedule" > set_ftrace_filter; then
+	echo "can not enable schedule filter"
+	exit -1
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
+    echo "Graph filtering not working by itself?"
+    exit -1;
+fi
+
+# Make sure we did find something
+count=`cat trace | grep 'schedule()' | wc -l` 
+if [ $count -eq 0 ]; then
+    echo "No schedule traces found?"
+    exit -1
+fi
+
+do_reset
+
+exit 0
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
new file mode 100644
index 000000000000..d09d9a676530
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
@@ -0,0 +1,76 @@
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
+	echo "more than schedule was found"
+	exit 1
+fi
+
+echo "Make sure schedule was traced"
+if ! grep -e 'schedule' trace > /dev/null; then
+	cat trace
+	echo "can not find schedule in trace"
+	exit 1
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
+	echo "no other functions besides schedule was found"
+	exit 1
+fi
+
+reset_tracer
+
+exit 0
-- 
2.1.1


