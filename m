Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaJCVRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:17:22 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:52783 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752876AbaJCVRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:17:16 -0400
Date: Fri, 3 Oct 2014 17:17:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: [for-next][PATCH] ftracetest: Add POSIX.3 standard and XFAIL result
 codes
Message-ID: <20141003171709.7d0b49d0@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 915de2adb584acea89f3f654a6c9b329f682100f


Masami Hiramatsu (1):
      ftracetest: Add POSIX.3 standard and XFAIL result codes

----
 tools/testing/selftests/ftrace/README              |  37 ++++++
 tools/testing/selftests/ftrace/ftracetest          | 124 ++++++++++++++++++---
 tools/testing/selftests/ftrace/samples/fail.tc     |   4 +
 tools/testing/selftests/ftrace/samples/pass.tc     |   3 +
 .../testing/selftests/ftrace/samples/unresolved.tc |   4 +
 .../selftests/ftrace/samples/unsupported.tc        |   3 +
 tools/testing/selftests/ftrace/samples/untested.tc |   3 +
 tools/testing/selftests/ftrace/samples/xfail.tc    |   3 +
 .../selftests/ftrace/test.d/00basic/basic2.tc      |   3 +-
 .../selftests/ftrace/test.d/00basic/basic3.tc      |   6 +-
 .../ftrace/test.d/kprobe/add_and_remove.tc         |  12 +-
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |  15 ++-
 tools/testing/selftests/ftrace/test.d/template     |   5 +
 13 files changed, 189 insertions(+), 33 deletions(-)
---------------------------
commit 915de2adb584acea89f3f654a6c9b329f682100f
Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date:   Mon Sep 29 12:02:11 2014 +0000

    ftracetest: Add POSIX.3 standard and XFAIL result codes
    
    Add XFAIL and POSIX 1003.3 standard codes (UNRESOLVED/
    UNTESTED/UNSUPPORTED) as result codes. These are used for the
    results that test case is expected to fail or unsupported
    feature (by config).
    
    To return these result code, this introduces exit_unresolved,
    exit_untested, exit_unsupported and exit_xfail functions,
    which use real-time signals to notify the result code to
    ftracetest.
    
    This also set "errexit" option for the testcases, so that
    the tests don't need to exit explicitly.
    
    Note that if the test returns UNRESOLVED/UNSUPPORTED/FAIL,
    its test log including executed commands is shown on console
    and main logfile as below.
    
      ------
      # ./ftracetest samples/
      === Ftrace unit tests ===
      [1] failure-case example        [FAIL]
      execute: /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/fail.tc
      + . /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/fail.tc
      ++ cat non-exist-file
      cat: non-exist-file: No such file or directory
      [2] pass-case example   [PASS]
      [3] unresolved-case example     [UNRESOLVED]
      execute: /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unresolved.tc
      + . /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unresolved.tc
      ++ trap exit_unresolved INT
      ++ kill -INT 29324
      +++ exit_unresolved
      +++ kill -s 38 29265
      +++ exit 0
      [4] unsupported-case example    [UNSUPPORTED]
      execute: /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unsupported.tc
      + . /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unsupported.tc
      ++ exit_unsupported
      ++ kill -s 40 29265
      ++ exit 0
      [5] untested-case example       [UNTESTED]
      [6] xfail-case example  [XFAIL]
    
      # of passed:  1
      # of failed:  1
      # of unresolved:  1
      # of untested:  1
      # of unsupported:  1
      # of xfailed:  1
      # of undefined(test bug):  0
      ------
    
    Link: http://lkml.kernel.org/p/20140929120211.30203.99510.stgit@kbuild-f20.novalocal
    
    Acked-by: Namhyung Kim <namhyung@kernel.org>
    Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/selftests/ftrace/README b/tools/testing/selftests/ftrace/README
index b8631f03e754..182e76fa4b82 100644
--- a/tools/testing/selftests/ftrace/README
+++ b/tools/testing/selftests/ftrace/README
@@ -38,6 +38,43 @@ extension) and rewrite the test description line.
  * The test cases should run on dash (busybox shell) for testing on
    minimal cross-build environments.
 
+ * Note that the tests are run with "set -e" (errexit) option. If any
+   command fails, the test will be terminated immediately.
+
+ * The tests can return some result codes instead of pass or fail by
+   using exit_unresolved, exit_untested, exit_unsupported and exit_xfail.
+
+Result code
+===========
+
+Ftracetest supports following result codes.
+
+ * PASS: The test succeeded as expected. The test which exits with 0 is
+         counted as passed test.
+
+ * FAIL: The test failed, but was expected to succeed. The test which exits
+         with !0 is counted as failed test.
+
+ * UNRESOLVED: The test produced unclear or intermidiate results.
+             for example, the test was interrupted
+                       or the test depends on a previous test, which failed.
+                       or the test was set up incorrectly
+             The test which is in above situation, must call exit_unresolved.
+
+ * UNTESTED: The test was not run, currently just a placeholder.
+             In this case, the test must call exit_untested.
+
+ * UNSUPPORTED: The test failed because of lack of feature.
+               In this case, the test must call exit_unsupported.
+
+ * XFAIL: The test failed, and was expected to fail.
+          To return XFAIL, call exit_xfail from the test.
+
+There are some sample test scripts for result code under samples/.
+You can also run samples as below:
+
+  # ./ftracetest samples/
+
 TODO
 ====
 
diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 4c6c2fad2cda..a8f81c782856 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -114,22 +114,106 @@ prlog "=== Ftrace unit tests ==="
 
 
 # Testcase management
+# Test result codes - Dejagnu extended code
+PASS=0	# The test succeeded.
+FAIL=1	# The test failed, but was expected to succeed.
+UNRESOLVED=2  # The test produced indeterminate results. (e.g. interrupted)
+UNTESTED=3    # The test was not run, currently just a placeholder.
+UNSUPPORTED=4 # The test failed because of lack of feature.
+XFAIL=5	# The test failed, and was expected to fail.
+
+# Accumulations
 PASSED_CASES=
 FAILED_CASES=
+UNRESOLVED_CASES=
+UNTESTED_CASES=
+UNSUPPORTED_CASES=
+XFAILED_CASES=
+UNDEFINED_CASES=
+TOTAL_RESULT=0
+
 CASENO=0
 testcase() { # testfile
   CASENO=$((CASENO+1))
   prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
 }
-failed() {
-  prlog "	[FAIL]"
-  FAILED_CASES="$FAILED_CASES $CASENO"
+
+eval_result() { # retval sigval
+  local retval=$2
+  if [ $2 -eq 0 ]; then
+    test $1 -ne 0 && retval=$FAIL
+  fi
+  case $retval in
+    $PASS)
+      prlog "	[PASS]"
+      PASSED_CASES="$PASSED_CASES $CASENO"
+      return 0
+    ;;
+    $FAIL)
+      prlog "	[FAIL]"
+      FAILED_CASES="$FAILED_CASES $CASENO"
+      return 1 # this is a bug.
+    ;;
+    $UNRESOLVED)
+      prlog "	[UNRESOLVED]"
+      UNRESOLVED_CASES="$UNRESOLVED_CASES $CASENO"
+      return 1 # this is a kind of bug.. something happened.
+    ;;
+    $UNTESTED)
+      prlog "	[UNTESTED]"
+      UNTESTED_CASES="$UNTESTED_CASES $CASENO"
+      return 0
+    ;;
+    $UNSUPPORTED)
+      prlog "	[UNSUPPORTED]"
+      UNSUPPORTED_CASES="$UNSUPPORTED_CASES $CASENO"
+      return 1 # this is not a bug, but the result should be reported.
+    ;;
+    $XFAIL)
+      prlog "	[XFAIL]"
+      XFAILED_CASES="$XFAILED_CASES $CASENO"
+      return 0
+    ;;
+    *)
+      prlog "	[UNDEFINED]"
+      UNDEFINED_CASES="$UNDEFINED_CASES $CASENO"
+      return 1 # this must be a test bug
+    ;;
+  esac
+}
+
+# Signal handling for result codes
+SIG_RESULT=
+SIG_BASE=36	# Use realtime signals
+SIG_PID=$$
+
+SIG_UNRESOLVED=$((SIG_BASE + UNRESOLVED))
+exit_unresolved () {
+  kill -s $SIG_UNRESOLVED $SIG_PID
+  exit 0
+}
+trap 'SIG_RESULT=$UNRESOLVED' $SIG_UNRESOLVED
+
+SIG_UNTESTED=$((SIG_BASE + UNTESTED))
+exit_untested () {
+  kill -s $SIG_UNTESTED $SIG_PID
+  exit 0
 }
-passed() {
-  prlog "	[PASS]"
-  PASSED_CASES="$PASSED_CASES $CASENO"
+trap 'SIG_RESULT=$UNTESTED' $SIG_UNTESTED
+
+SIG_UNSUPPORTED=$((SIG_BASE + UNSUPPORTED))
+exit_unsupported () {
+  kill -s $SIG_UNSUPPORTED $SIG_PID
+  exit 0
 }
+trap 'SIG_RESULT=$UNSUPPORTED' $SIG_UNSUPPORTED
 
+SIG_XFAIL=$((SIG_BASE + XFAIL))
+exit_xfail () {
+  kill -s $SIG_XFAIL $SIG_PID
+  exit 0
+}
+trap 'SIG_RESULT=$XFAIL' $SIG_XFAIL
 
 # Run one test case
 run_test() { # testfile
@@ -137,14 +221,17 @@ run_test() { # testfile
   local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
   testcase $1
   echo "execute: "$1 > $testlog
-  (cd $TRACING_DIR; set -x ; . $1) >> $testlog 2>&1
-  ret=$?
-  if [ $ret -ne 0 ]; then
-    failed
-    catlog $testlog
-  else
-    passed
+  SIG_RESULT=0
+  # setup PID and PPID, $$ is not updated.
+  (cd $TRACING_DIR; read PID _ < /proc/self/stat ;
+   set -e; set -x; . $1) >> $testlog 2>&1
+  eval_result $? $SIG_RESULT
+  if [ $? -eq 0 ]; then
+    # Remove test log if the test was done as it was expected.
     [ $KEEP_LOG -eq 0 ] && rm $testlog
+  else
+    catlog $testlog
+    TOTAL_RESULT=1
   fi
 }
 
@@ -152,8 +239,15 @@ run_test() { # testfile
 for t in $TEST_CASES; do
   run_test $t
 done
+
 prlog ""
 prlog "# of passed: " `echo $PASSED_CASES | wc -w`
 prlog "# of failed: " `echo $FAILED_CASES | wc -w`
-
-test -z "$FAILED_CASES" # if no error, return 0
+prlog "# of unresolved: " `echo $UNRESOLVED_CASES | wc -w`
+prlog "# of untested: " `echo $UNTESTED_CASES | wc -w`
+prlog "# of unsupported: " `echo $UNSUPPORTED_CASES | wc -w`
+prlog "# of xfailed: " `echo $XFAILED_CASES | wc -w`
+prlog "# of undefined(test bug): " `echo $UNDEFINED_CASES | wc -w`
+
+# if no error, return 0
+exit $TOTAL_RESULT
diff --git a/tools/testing/selftests/ftrace/samples/fail.tc b/tools/testing/selftests/ftrace/samples/fail.tc
new file mode 100644
index 000000000000..15e35b956e05
--- /dev/null
+++ b/tools/testing/selftests/ftrace/samples/fail.tc
@@ -0,0 +1,4 @@
+#!/bin/sh
+# description: failure-case example
+cat non-exist-file
+echo "this is not executed"
diff --git a/tools/testing/selftests/ftrace/samples/pass.tc b/tools/testing/selftests/ftrace/samples/pass.tc
new file mode 100644
index 000000000000..d01549370041
--- /dev/null
+++ b/tools/testing/selftests/ftrace/samples/pass.tc
@@ -0,0 +1,3 @@
+#!/bin/sh
+# description: pass-case example
+return 0
diff --git a/tools/testing/selftests/ftrace/samples/unresolved.tc b/tools/testing/selftests/ftrace/samples/unresolved.tc
new file mode 100644
index 000000000000..41e99d3358d1
--- /dev/null
+++ b/tools/testing/selftests/ftrace/samples/unresolved.tc
@@ -0,0 +1,4 @@
+#!/bin/sh
+# description: unresolved-case example
+trap exit_unresolved INT
+kill -INT $PID
diff --git a/tools/testing/selftests/ftrace/samples/unsupported.tc b/tools/testing/selftests/ftrace/samples/unsupported.tc
new file mode 100644
index 000000000000..45910ff13328
--- /dev/null
+++ b/tools/testing/selftests/ftrace/samples/unsupported.tc
@@ -0,0 +1,3 @@
+#!/bin/sh
+# description: unsupported-case example
+exit_unsupported
diff --git a/tools/testing/selftests/ftrace/samples/untested.tc b/tools/testing/selftests/ftrace/samples/untested.tc
new file mode 100644
index 000000000000..35a45946ec60
--- /dev/null
+++ b/tools/testing/selftests/ftrace/samples/untested.tc
@@ -0,0 +1,3 @@
+#!/bin/sh
+# description: untested-case example
+exit_untested
diff --git a/tools/testing/selftests/ftrace/samples/xfail.tc b/tools/testing/selftests/ftrace/samples/xfail.tc
new file mode 100644
index 000000000000..9dd395323259
--- /dev/null
+++ b/tools/testing/selftests/ftrace/samples/xfail.tc
@@ -0,0 +1,3 @@
+#!/bin/sh
+# description: xfail-case example
+cat non-exist-file || exit_xfail
diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
index b04f30df0db3..bf9a7b037924 100644
--- a/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
@@ -1,6 +1,7 @@
 #!/bin/sh
 # description: Basic test for tracers
+test -f available_tracers
 for t in `cat available_tracers`; do
-  echo $t > current_tracer || exit 1
+  echo $t > current_tracer
 done
 echo nop > current_tracer
diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
index 0c1a3a207636..bde6625d9785 100644
--- a/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
@@ -1,8 +1,8 @@
 #!/bin/sh
 # description: Basic trace clock test
-[ -f trace_clock ] || exit 1
+test -f trace_clock
 for c in `cat trace_clock | tr  -d \[\]`; do
-  echo $c > trace_clock || exit 1
-  grep '\['$c'\]' trace_clock || exit 1
+  echo $c > trace_clock
+  grep '\['$c'\]' trace_clock
 done
 echo local > trace_clock
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
index 5ddfb476eceb..1b8b665ab2b3 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
@@ -1,11 +1,11 @@
 #!/bin/sh
 # description: Kprobe dynamic event - adding and removing
 
-[ -f kprobe_events ] || exit 1
+[ -f kprobe_events ] || exit_unsupported # this is configurable
 
-echo 0 > events/enable || exit 1
-echo > kprobe_events || exit 1
-echo p:myevent do_fork > kprobe_events || exit 1
-grep myevent kprobe_events || exit 1
-[ -d events/kprobes/myevent ] || exit 1
+echo 0 > events/enable
+echo > kprobe_events
+echo p:myevent do_fork > kprobe_events
+grep myevent kprobe_events
+test -d events/kprobes/myevent
 echo > kprobe_events
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
index 588fde97e93f..b55c84003587 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
@@ -1,14 +1,13 @@
 #!/bin/sh
 # description: Kprobe dynamic event - busy event check
 
-[ -f kprobe_events ] || exit 1
+[ -f kprobe_events ] || exit_unsupported
 
-echo 0 > events/enable || exit 1
-echo > kprobe_events || exit 1
-echo p:myevent do_fork > kprobe_events || exit 1
-[ -d events/kprobes/myevent ] || exit 1
-echo 1 > events/kprobes/myevent/enable || exit 1
+echo 0 > events/enable
+echo > kprobe_events
+echo p:myevent do_fork > kprobe_events
+test -d events/kprobes/myevent
+echo 1 > events/kprobes/myevent/enable
 echo > kprobe_events && exit 1 # this must fail
-echo 0 > events/kprobes/myevent/enable || exit 1
+echo 0 > events/kprobes/myevent/enable
 echo > kprobe_events # this must succeed
-
diff --git a/tools/testing/selftests/ftrace/test.d/template b/tools/testing/selftests/ftrace/test.d/template
index ce5f735b2e65..5448f7abad5f 100644
--- a/tools/testing/selftests/ftrace/test.d/template
+++ b/tools/testing/selftests/ftrace/test.d/template
@@ -1,4 +1,9 @@
 #!/bin/sh
 # description: %HERE DESCRIBE WHAT THIS DOES%
 # you have to add ".tc" extention for your testcase file
+# Note that all tests are run with "errexit" option.
+
 exit 0 # Return 0 if the test is passed, otherwise return !0
+# If the test could not run because of lack of feature, call exit_unsupported
+# If the test returned unclear results, call exit_unresolved
+# If the test is a dummy, or a placeholder, call exit_untested
