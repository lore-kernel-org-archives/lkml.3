Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaIBLHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:07:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59857 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaIBLHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:07:08 -0400
Subject: [RFC PATCH v3 4/4] ftracetest: Add XFAIL/XPASS and POSIX.3 std.
 result codes
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 11:06:59 +0000
Message-ID: <20140902110659.3207.67086.stgit@kbuild-f20.novalocal>
In-Reply-To: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add XFAIL, XPASS and POSIX 1003.3 std. codes (UNRESOLVED/
UNTESTED/UNSUPPORTED) as a result code. These are
used for the results that test case is expected to fail or
unsupported feature (by config).
This also introduces PASS/FAIL/XFAIL/XPASS/UNSUP/UNTST/UNRES
result codes for each testcase. Since the results are not
binary, each testcase must use these codes to return the
test result.

Changes in v3:
 - Add UNRESOLVED/UNTESTED codes.
 - Fix to handle undefined codes.
 - Add a document about return codes.
 - Fix to show failure logs.
 - Don't use -e option for echo since dash doesn't support it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/testing/ftrace/README                        |   33 +++++++
 tools/testing/ftrace/ftracetest                    |   95 +++++++++++++++++---
 tools/testing/ftrace/test.d/basic1.tc              |    6 +
 tools/testing/ftrace/test.d/basic2.tc              |    6 +
 tools/testing/ftrace/test.d/basic3.tc              |    9 +-
 .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   15 ++-
 tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   20 ++--
 tools/testing/ftrace/test.d/template               |    8 +-
 8 files changed, 152 insertions(+), 40 deletions(-)

diff --git a/tools/testing/ftrace/README b/tools/testing/ftrace/README
index 5d5de16..758c0c6 100644
--- a/tools/testing/ftrace/README
+++ b/tools/testing/ftrace/README
@@ -37,6 +37,39 @@ and rewrite test description line.
  * The test cases should run on dash (busybox shell) for testing on
    minimal cross-build environments.
 
+ * The test cases must return one of result codes described below.
+
+Return codes
+============
+
+Ftracetest supports following return codes, which are defined as shell
+variables (do not overwrite them.)
+
+ * PASS: The test succeeded as expected.
+
+ * FAIL: The test failed, but was expected to succeed.
+
+ * UNRESOLVED: The test produced unclear or intermidiate results.
+             for example, the test was interrupted
+                       or the test depends on a previous test, which failed.
+                       or the test was set up incorrectly
+
+ * UNTESTED: The test was not run, currently just a placeholder.
+
+ * UNSUPPORTED: The test failed because of lack of feature.
+
+ * XFAIL: The test failed, and was expected to fail.
+
+ * XPASS: The test succeeded, but was expected to fail.
+
+Below shortened valiables are also available.
+
+ * UNRES: means UNRESOLVED.
+
+ * UNTST: means UNTESTED.
+
+ * UNSUP: means UNSUPPORTED.
+
 TODO
 ====
 
diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
index 8d92e74..3db77c5 100755
--- a/tools/testing/ftrace/ftracetest
+++ b/tools/testing/ftrace/ftracetest
@@ -107,22 +107,79 @@ catlog() { #file
 }
 
 # Testcase management
+# Test result codes - Dejagnu extended code
+PASS=0	# The test succeeded.
+FAIL=1	# The test failed, but was expected to succeed.
+UNRESOLVED=2  # The test produced indeterminate results. (e.g. interrupted)
+UNTESTED=3    # The test was not run, currently just a placeholder.
+UNSUPPORTED=4 # The test failed because of lack of feature.
+XFAIL=5	# The test failed, and was expected to fail.
+XPASS=6	# The test succeeded, but was expected to fail.
+# Shortened codes
+UNRES=$UNRESOLVED
+UNTST=$UNTESTED
+UNSUP=$UNSUPPORTED
+
+# Accumulations
 PASSED_CASES=
 FAILED_CASES=
+UNRESOLVED_CASES=
+UNTESTED_CASES=
+UNSUPPORTED_CASES=
+XFAILED_CASES=
+XPASSED_CASES=
+UNDEFINED_CASES=
+
 CASENO=0
 testcase() { # testfile
   CASENO=$((CASENO+1))
   prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
 }
-failed() {
-  prlog "	[FAIL]"
-  FAILED_CASES="$FAILED_CASES $CASENO"
-}
-passed() {
-  prlog "	[PASS]"
-  PASSED_CASES="$PASSED_CASES $CASENO"
-}
 
+eval_result() { # retval
+  case $1 in
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
+      return 0 # this is not a bug
+    ;;
+    $XFAIL)
+      prlog "	[XFAIL]"
+      XFAILED_CASES="$XFAILED_CASES $CASENO"
+      return 0
+    ;;
+    $XPASS)
+      prlog "	[XPASS]"
+      XPASSED_CASES="$XPASSED_CASES $CASENO"
+      return 1 # this can be a bug
+    ;;
+    *)
+      prlog "	[UNDEFINED]"
+      UNDEFINED_CASES="$UNDEFINED_CASES $CASENO"
+      return 1 # this must be a test bug
+    ;;
+  esac
+}
 
 # Run one test case
 run_test() { # testfile
@@ -132,12 +189,12 @@ run_test() { # testfile
   echo "execute: "$1 > $testlog
   (cd $TRACING_DIR; set -x ; . $t) >> $testlog 2>&1
   ret=$?
-  if [ $ret -ne 0 ]; then
-    failed
-    catlog $testlog
-  else
-    passed
+  eval_result $ret
+  if [ $? -eq 0 ]; then
+    # Remove test log if the test was done as it was expected.
     [ $KEEP_LOG -eq 0 ] && rm $testlog
+  else
+    catlog $testlog
   fi
 }
 
@@ -145,8 +202,16 @@ run_test() { # testfile
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
+prlog "# of xpassed: " `echo $XPASSED_CASES | wc -w`
+prlog "# of undefined(test bug): " `echo $UNDEFINED_CASES | wc -w`
+
+# if no error, return 0
+test -z "$FAILED_CASES$XPASSED_CASES$UNDEFINED_CASES$UNRESOLVED_CASES"
diff --git a/tools/testing/ftrace/test.d/basic1.tc b/tools/testing/ftrace/test.d/basic1.tc
index 9980ff1..1e95209 100644
--- a/tools/testing/ftrace/test.d/basic1.tc
+++ b/tools/testing/ftrace/test.d/basic1.tc
@@ -1,3 +1,7 @@
 #!/bin/sh
 # description: Basic trace file check
-test -f README -a -f trace -a -f tracing_on -a -f trace_pipe
+if test -f README -a -f trace -a -f tracing_on -a -f trace_pipe; then
+  exit $PASS
+else
+  exit $FAIL
+fi
diff --git a/tools/testing/ftrace/test.d/basic2.tc b/tools/testing/ftrace/test.d/basic2.tc
index b04f30d..44949e9 100644
--- a/tools/testing/ftrace/test.d/basic2.tc
+++ b/tools/testing/ftrace/test.d/basic2.tc
@@ -1,6 +1,8 @@
 #!/bin/sh
 # description: Basic test for tracers
+test -f available_tracers || exit $FAIL # this is basic feature, must be there.
 for t in `cat available_tracers`; do
-  echo $t > current_tracer || exit 1
+  echo $t > current_tracer || exit $FAIL
 done
-echo nop > current_tracer
+echo nop > current_tracer || exit $FAIL
+exit $PASS
diff --git a/tools/testing/ftrace/test.d/basic3.tc b/tools/testing/ftrace/test.d/basic3.tc
index 0c1a3a2..7bc5a53 100644
--- a/tools/testing/ftrace/test.d/basic3.tc
+++ b/tools/testing/ftrace/test.d/basic3.tc
@@ -1,8 +1,9 @@
 #!/bin/sh
 # description: Basic trace clock test
-[ -f trace_clock ] || exit 1
+[ -f trace_clock ] || exit $FAIL # this is basic feature, must be there
 for c in `cat trace_clock | tr  -d \[\]`; do
-  echo $c > trace_clock || exit 1
-  grep '\['$c'\]' trace_clock || exit 1
+  echo $c > trace_clock || exit $FAIL
+  grep '\['$c'\]' trace_clock || exit $FAIL
 done
-echo local > trace_clock
+echo local > trace_clock || exit $FAIL
+exit $PASS
diff --git a/tools/testing/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
index 5ddfb47..fa3034b 100644
--- a/tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
@@ -1,11 +1,12 @@
 #!/bin/sh
 # description: Kprobe dynamic event - adding and removing
 
-[ -f kprobe_events ] || exit 1
+[ -f kprobe_events ] || exit $UNSUP # this is configurable
 
-echo 0 > events/enable || exit 1
-echo > kprobe_events || exit 1
-echo p:myevent do_fork > kprobe_events || exit 1
-grep myevent kprobe_events || exit 1
-[ -d events/kprobes/myevent ] || exit 1
-echo > kprobe_events
+echo 0 > events/enable || exit $FAIL
+echo > kprobe_events || exit $FAIL
+echo p:myevent do_fork > kprobe_events || exit $FAIL
+grep myevent kprobe_events || exit $FAIL
+[ -d events/kprobes/myevent ] || exit $FAIL
+echo > kprobe_events || exit $FAIL
+exit $PASS
diff --git a/tools/testing/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/ftrace/test.d/kprobe/busy_check.tc
index 588fde97..6f47784 100644
--- a/tools/testing/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/ftrace/test.d/kprobe/busy_check.tc
@@ -1,14 +1,14 @@
 #!/bin/sh
 # description: Kprobe dynamic event - busy event check
 
-[ -f kprobe_events ] || exit 1
-
-echo 0 > events/enable || exit 1
-echo > kprobe_events || exit 1
-echo p:myevent do_fork > kprobe_events || exit 1
-[ -d events/kprobes/myevent ] || exit 1
-echo 1 > events/kprobes/myevent/enable || exit 1
-echo > kprobe_events && exit 1 # this must fail
-echo 0 > events/kprobes/myevent/enable || exit 1
-echo > kprobe_events # this must succeed
+[ -f kprobe_events ] || exit $UNSUP
 
+echo 0 > events/enable || exit $FAIL
+echo > kprobe_events || exit $FAIL
+echo p:myevent do_fork > kprobe_events || exit $FAIL
+[ -d events/kprobes/myevent ] || exit $FAIL
+echo 1 > events/kprobes/myevent/enable || exit $FAIL
+echo > kprobe_events && exit $FAIL # this must fail
+echo 0 > events/kprobes/myevent/enable || exit $FAIL
+echo > kprobe_events || exit $FAIL # this must succeed
+exit $PASS
diff --git a/tools/testing/ftrace/test.d/template b/tools/testing/ftrace/test.d/template
index ce5f735..02b97af 100644
--- a/tools/testing/ftrace/test.d/template
+++ b/tools/testing/ftrace/test.d/template
@@ -1,4 +1,10 @@
 #!/bin/sh
 # description: %HERE DESCRIBE WHAT THIS DOES%
 # you have to add ".tc" extention for your testcase file
-exit 0 # Return 0 if the test is passed, otherwise return !0
+exit $PASS # Return $PASS if the test succeeded.
+# If the test failed, return $FAIL.
+# If the test failed as expected, return $XFAIL.
+# If the test passed, but it was expected to fail, return $XPASS.
+# If the test could not run because of lack of feature, return $UNSUPPORTED
+# If the test returned unclear results, return $UNRESOLVED
+# If the test is a dummy, or a placeholder, return $UNTESTED


