Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaLHO3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:29:31 -0500
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:48051 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751974AbaLHO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:29:30 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:69:327:355:379:541:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2197:2199:2393:2559:2562:2895:3138:3139:3140:3141:3142:3653:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4470:4605:5007:6119:6261:6609:7774:7875:7903:7904:10004:10848:11026:11657:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12679:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meal70_8ce4a7647ad58
X-Filterd-Recvd-Size: 21090
Date: Mon, 8 Dec 2014 09:29:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] ftracetest: Ftrace self tests for 3.19
Message-ID: <20141208092927.43581dac@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Updates for the ftrace self tests:

 o Added kprobes on ftrace testcase
 o Sort test cases
 o Add file to hold helper functions
 o Use logfile name supported by busybox's mktemp
 o Clear trace buffer after running kprobe test
 o Fix show descriptions when run on dash shell
 o Add --verbose option for showing echo output

Please pull the latest ftracetest-3.19 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftracetest-3.19

Tag SHA1: 7057ffc8fd4f8f8a371a1c9a9123d84ffc6aa4d8
Head SHA1: 57cee23650d768130ff2d80aa4cd0b053feabf97


Heiko Carstens (2):
      ftracetest: Add kprobes on ftrace testcase
      ftracetest: Sort testcases

Masami Hiramatsu (2):
      ftracetest: Fix to show descriptions on dash
      ftracetest: Add --verbose option for showing echo output

Namhyung Kim (3):
      ftracetest: Use logfile name supported by busybox's mktemp
      ftracetest: Clear trace buffer after running kprobe testcases
      ftracetest: Add basic event tracing test cases

Steven Rostedt (Red Hat) (2):
      ftracetest: Add functions file that holds helper functions
      ftracetest: Add a couple of ftrace test cases

----
 tools/testing/selftests/ftrace/ftracetest          | 43 +++++++----
 .../selftests/ftrace/test.d/00basic/basic4.tc      |  5 ++
 .../selftests/ftrace/test.d/event/event-enable.tc  | 53 +++++++++++++
 .../ftrace/test.d/event/subsystem-enable.tc        | 53 +++++++++++++
 .../ftrace/test.d/event/toplevel-enable.tc         | 47 ++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 89 ++++++++++++++++++++++
 .../ftrace/test.d/ftrace/fgraph-filter.tc          | 52 +++++++++++++
 .../ftrace/test.d/ftrace/func_profiler.tc          | 80 +++++++++++++++++++
 tools/testing/selftests/ftrace/test.d/functions    | 16 ++++
 .../ftrace/test.d/kprobe/add_and_remove.tc         |  1 +
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |  1 +
 .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |  1 +
 .../ftrace/test.d/kprobe/kprobe_ftrace.tc          | 55 +++++++++++++
 .../ftrace/test.d/kprobe/kretprobe_args.tc         |  1 +
 14 files changed, 484 insertions(+), 13 deletions(-)
---------------------------
diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 515247601df4..da48812ab95e 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -13,6 +13,7 @@ echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
 echo " Options:"
 echo "		-h|--help  Show help message"
 echo "		-k|--keep  Keep passed test logs"
+echo "		-v|--verbose Show all stdout messages in testcases"
 echo "		-d|--debug Debug mode (trace all shell commands)"
 exit $1
 }
@@ -37,7 +38,7 @@ abspath() {
 }
 
 find_testcases() { #directory
-  echo `find $1 -name \*.tc`
+  echo `find $1 -name \*.tc | sort`
 }
 
 parse_opts() { # opts
@@ -53,6 +54,10 @@ parse_opts() { # opts
       KEEP_LOG=1
       shift 1
     ;;
+    --verbose|-v)
+      VERBOSE=1
+      shift 1
+    ;;
     --debug|-d)
       DEBUG=1
       shift 1
@@ -90,6 +95,7 @@ TEST_CASES=`find_testcases $TEST_DIR`
 LOG_DIR=$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`/
 KEEP_LOG=0
 DEBUG=0
+VERBOSE=0
 # Parse command-line options
 parse_opts $*
 
@@ -135,15 +141,12 @@ TOTAL_RESULT=0
 CASENO=0
 testcase() { # testfile
   CASENO=$((CASENO+1))
-  prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
+  desc=`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
+  prlog -n "[$CASENO]$desc"
 }
 
-eval_result() { # retval sigval
-  local retval=$2
-  if [ $2 -eq 0 ]; then
-    test $1 -ne 0 && retval=$FAIL
-  fi
-  case $retval in
+eval_result() { # sigval
+  case $1 in
     $PASS)
       prlog "	[PASS]"
       PASSED_CASES="$PASSED_CASES $CASENO"
@@ -187,6 +190,9 @@ SIG_RESULT=
 SIG_BASE=36	# Use realtime signals
 SIG_PID=$$
 
+SIG_FAIL=$((SIG_BASE + FAIL))
+trap 'SIG_RESULT=$FAIL' $SIG_FAIL
+
 SIG_UNRESOLVED=$((SIG_BASE + UNRESOLVED))
 exit_unresolved () {
   kill -s $SIG_UNRESOLVED $SIG_PID
@@ -215,17 +221,25 @@ exit_xfail () {
 }
 trap 'SIG_RESULT=$XFAIL' $SIG_XFAIL
 
+__run_test() { # testfile
+  # setup PID and PPID, $$ is not updated.
+  (cd $TRACING_DIR; read PID _ < /proc/self/stat ; set -e; set -x; . $1)
+  [ $? -ne 0 ] && kill -s $SIG_FAIL $SIG_PID
+}
+
 # Run one test case
 run_test() { # testfile
   local testname=`basename $1`
-  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
+  local testlog=`mktemp $LOG_DIR/${testname}-log.XXXXXX`
   testcase $1
   echo "execute: "$1 > $testlog
   SIG_RESULT=0
-  # setup PID and PPID, $$ is not updated.
-  (cd $TRACING_DIR; read PID _ < /proc/self/stat ;
-   set -e; set -x; . $1) >> $testlog 2>&1
-  eval_result $? $SIG_RESULT
+  if [ $VERBOSE -ne 0 ]; then
+    __run_test $1 2>> $testlog | tee -a $testlog
+  else
+    __run_test $1 >> $testlog 2>&1
+  fi
+  eval_result $SIG_RESULT
   if [ $? -eq 0 ]; then
     # Remove test log if the test was done as it was expected.
     [ $KEEP_LOG -eq 0 ] && rm $testlog
@@ -235,6 +249,9 @@ run_test() { # testfile
   fi
 }
 
+# load in the helper functions
+. $TEST_DIR/functions
+
 # Main loop
 for t in $TEST_CASES; do
   run_test $t
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
diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
new file mode 100644
index 000000000000..5d8cd06d920f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -0,0 +1,16 @@
+
+clear_trace() { # reset trace output
+    echo > trace
+}
+
+disable_tracing() { # stop trace recording
+    echo 0 > tracing_on
+}
+
+enable_tracing() { # start trace recording
+    echo 1 > tracing_on
+}
+
+reset_tracer() { # reset the current tracer
+    echo nop > current_tracer
+}
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
index 1b8b665ab2b3..a5a426211129 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
@@ -9,3 +9,4 @@ echo p:myevent do_fork > kprobe_events
 grep myevent kprobe_events
 test -d events/kprobes/myevent
 echo > kprobe_events
+clear_trace
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
index b55c84003587..d8c7bb6581fe 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
@@ -11,3 +11,4 @@ echo 1 > events/kprobes/myevent/enable
 echo > kprobe_events && exit 1 # this must fail
 echo 0 > events/kprobes/myevent/enable
 echo > kprobe_events # this must succeed
+clear_trace
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
index a603d3f8db7b..c45ee2761354 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
@@ -12,5 +12,6 @@ echo 1 > events/kprobes/testprobe/enable
 ( echo "forked")
 echo 0 > events/kprobes/testprobe/enable
 echo "-:testprobe" >> kprobe_events
+clear_trace
 test -d events/kprobes/testprobe && exit 1 || exit 0
 
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
new file mode 100644
index 000000000000..ab41d2b29841
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
@@ -0,0 +1,55 @@
+#!/bin/sh
+# description: Kprobe dynamic event with function tracer
+
+[ -f kprobe_events ] || exit_unsupported # this is configurable
+grep function available_tracers || exit_unsupported # this is configurable
+
+# prepare
+echo nop > current_tracer
+echo do_fork > set_ftrace_filter
+echo 0 > events/enable
+echo > kprobe_events
+echo 'p:testprobe do_fork' > kprobe_events
+
+# kprobe on / ftrace off
+echo 1 > events/kprobes/testprobe/enable
+echo > trace
+( echo "forked")
+grep testprobe trace
+! grep 'do_fork <-' trace
+
+# kprobe on / ftrace on
+echo function > current_tracer
+echo > trace
+( echo "forked")
+grep testprobe trace
+grep 'do_fork <-' trace
+
+# kprobe off / ftrace on
+echo 0 > events/kprobes/testprobe/enable
+echo > trace
+( echo "forked")
+! grep testprobe trace
+grep 'do_fork <-' trace
+
+# kprobe on / ftrace on
+echo 1 > events/kprobes/testprobe/enable
+echo function > current_tracer
+echo > trace
+( echo "forked")
+grep testprobe trace
+grep 'do_fork <-' trace
+
+# kprobe on / ftrace off
+echo nop > current_tracer
+echo > trace
+( echo "forked")
+grep testprobe trace
+! grep 'do_fork <-' trace
+
+# cleanup
+echo nop > current_tracer
+echo > set_ftrace_filter
+echo 0 > events/kprobes/testprobe/enable
+echo > kprobe_events
+echo > trace
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
index 283c29e7f7c4..31717985acc7 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
@@ -12,4 +12,5 @@ echo 1 > events/kprobes/testprobe2/enable
 ( echo "forked")
 echo 0 > events/kprobes/testprobe2/enable
 echo '-:testprobe2' >> kprobe_events
+clear_trace
 test -d events/kprobes/testprobe2 && exit 1 || exit 0
