Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaKKVmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:42:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:55229 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752326AbaKKVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:42:09 -0500
Message-Id: <20141111214207.281254881@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 11 Nov 2014 16:41:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6/6] ftracetest: Add basic event tracing test cases
References: <20141111214127.196849367@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0006-ftracetest-Add-basic-event-tracing-test-cases.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

This patch adds basic event tracing tests like enable/disable with
top-level, subsystem-level and individual event files.

  # ./ftracetest
  === Ftrace unit tests ===
  [1] Basic trace file check	[PASS]
  [2] Basic trace clock test	[PASS]
  [3] Basic event tracing check	[PASS]
  [4] Basic test for tracers	[PASS]
  [5] event tracing - enable/disable with top level files	[PASS]
  [6] event tracing - enable/disable with subsystem level files	[PASS]
  [7] event tracing - enable/disable with event level files	[PASS]
  [8] ftrace - function graph filters	[PASS]
  [9] ftrace - function profiler with function tracing	[PASS]
  [10] ftrace - function graph filters with stack tracer	[PASS]
  [11] Kretprobe dynamic event with arguments	[PASS]
  [12] Kprobe dynamic event - busy event check	[PASS]
  [13] Kprobe dynamic event with arguments	[PASS]
  [14] Kprobe dynamic event - adding and removing	[PASS]

  # of passed:  14
  # of failed:  0
  # of unresolved:  0
  # of untested:  0
  # of unsupported:  0
  # of xfailed:  0
  # of undefined(test bug):  0

Link: http://lkml.kernel.org/r/1415239470-28705-3-git-send-email-namhyung@kernel.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../selftests/ftrace/test.d/00basic/basic4.tc      |  5 ++
 .../selftests/ftrace/test.d/event/event-enable.tc  | 53 ++++++++++++++++++++++
 .../ftrace/test.d/event/subsystem-enable.tc        | 53 ++++++++++++++++++++++
 .../ftrace/test.d/event/toplevel-enable.tc         | 47 +++++++++++++++++++
 4 files changed, 158 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic4.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/event/event-enable.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc

diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic4.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic4.tc
new file mode 100644
index 000000000000..fd9c49a13612
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/00basic/basic4.tc
@@ -0,0 +1,5 @@
+#!/bin/sh
+# description: Basic event tracing check
+test -f available_events -a -f set_event -a -d events
+# check scheduler events are available
+grep -q sched available_events && exit 0 || exit -1
\ No newline at end of file
diff --git a/tools/testing/selftests/ftrace/test.d/event/event-enable.tc b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
new file mode 100644
index 000000000000..668616d9bb03
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
@@ -0,0 +1,53 @@
+#!/bin/sh
+# description: event tracing - enable/disable with event level files
+
+do_reset() {
+    echo > set_event
+    clear_trace
+}
+
+fail() { #msg
+    do_reset
+    echo $1
+    exit -1
+}
+
+if [ ! -f set_event -o ! -d events/sched ]; then
+    echo "event tracing is not supported"
+    exit_unsupported
+fi
+
+reset_tracer
+do_reset
+
+echo 'sched:sched_switch' > set_event
+usleep 1
+
+count=`cat trace | grep sched_switch | wc -l`
+if [ $count -eq 0 ]; then
+    fail "sched_switch events are not recorded"
+fi
+
+do_reset
+
+echo 1 > events/sched/sched_switch/enable
+usleep 1
+
+count=`cat trace | grep sched_switch | wc -l`
+if [ $count -eq 0 ]; then
+    fail "sched_switch events are not recorded"
+fi
+
+do_reset
+
+echo 0 > events/sched/sched_switch/enable
+usleep 1
+
+count=`cat trace | grep sched_switch | wc -l`
+if [ $count -ne 0 ]; then
+    fail "sched_switch events should not be recorded"
+fi
+
+do_reset
+
+exit 0
diff --git a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
new file mode 100644
index 000000000000..655c415b6e7f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
@@ -0,0 +1,53 @@
+#!/bin/sh
+# description: event tracing - enable/disable with subsystem level files
+
+do_reset() {
+    echo > set_event
+    clear_trace
+}
+
+fail() { #msg
+    do_reset
+    echo $1
+    exit -1
+}
+
+if [ ! -f set_event -o ! -d events/sched ]; then
+    echo "event tracing is not supported"
+    exit_unsupported
+fi
+
+reset_tracer
+do_reset
+
+echo 'sched:*' > set_event
+usleep 1
+
+count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+if [ $count -lt 3 ]; then
+    fail "at least fork, exec and exit events should be recorded"
+fi
+
+do_reset
+
+echo 1 > events/sched/enable
+usleep 1
+
+count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+if [ $count -lt 3 ]; then
+    fail "at least fork, exec and exit events should be recorded"
+fi
+
+do_reset
+
+echo 0 > events/sched/enable
+usleep 1
+
+count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+if [ $count -ne 0 ]; then
+    fail "any of scheduler events should not be recorded"
+fi
+
+do_reset
+
+exit 0
diff --git a/tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc b/tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc
new file mode 100644
index 000000000000..480845774007
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc
@@ -0,0 +1,47 @@
+#!/bin/sh
+# description: event tracing - enable/disable with top level files
+
+do_reset() {
+    echo > set_event
+    clear_trace
+}
+
+fail() { #msg
+    do_reset
+    echo $1
+    exit -1
+}
+
+if [ ! -f available_events -o ! -f set_event -o ! -d events ]; then
+    echo "event tracing is not supported"
+    exit_unsupported
+fi
+
+reset_tracer
+do_reset
+
+echo '*:*' > set_event
+count=`cat trace | grep -v ^# | wc -l`
+if [ $count -eq 0 ]; then
+    fail "none of events are recorded"
+fi
+
+do_reset
+
+echo 1 > events/enable
+count=`cat trace | grep -v ^# | wc -l`
+if [ $count -eq 0 ]; then
+    fail "none of events are recorded"
+fi
+
+do_reset
+
+echo 0 > events/enable
+count=`cat trace | grep -v ^# | wc -l`
+if [ $count -ne 0 ]; then
+    fail "any of events should not be recorded"
+fi
+
+do_reset
+
+exit 0
-- 
2.1.1


