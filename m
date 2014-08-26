Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbaHZLPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:15:50 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34483 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617AbaHZLPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:15:48 -0400
Subject: [RFC PATCH v2 4/4] ftracetest: Add XFAIL/XPASS/UNSUPPORTED as
 result code
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 26 Aug 2014 11:15:39 +0000
Message-ID: <20140826111539.5711.93588.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal>
References: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add XFAIL, XPASS and UNSUPPORTED as a result code. These are
used for the results that test case is expected to fail or
unsupported feature (by config).
This also introduces PASS/FAIL/XFAIL/XPASS/UNSUP result codes
for each testcase. Since the results are not binary, each
testcase must use these code to return the test result.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/testing/ftrace/ftracetest                    |   61 +++++++++++++++-----
 tools/testing/ftrace/test.d/basic1.tc              |    6 ++
 tools/testing/ftrace/test.d/basic2.tc              |    6 +-
 tools/testing/ftrace/test.d/basic3.tc              |    9 ++-
 .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   15 +++--
 tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   20 +++----
 tools/testing/ftrace/test.d/template               |    6 ++
 7 files changed, 84 insertions(+), 39 deletions(-)

diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
index 0378c8a..bfcd56a 100755
--- a/tools/testing/ftrace/ftracetest
+++ b/tools/testing/ftrace/ftracetest
@@ -107,22 +107,53 @@ catlog() { #file
 }
 
 # Testcase management
+# Test result codes
+PASS=0	# The test succeeded.
+FAIL=1	# The test failed, but was expected to succeed.
+XFAIL=2	# The test failed, and was expected to fail.
+XPASS=3	# The test succeeded, but was expected to fail.
+UNSUP=4 # The test failed because of lack of feature.
+# Accumulations
 PASSED_CASES=
 FAILED_CASES=
+XFAILED_CASES=
+XPASSED_CASES=
+UNSUPPORTED_CASES=
+
 CASENO=0
 testcase() { # testfile
   CASENO=$((CASENO+1))
   prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
 }
-failed() {
-  prlog -e "\t[FAIL]"
-  FAILED_CASES="$FAILED_CASES $CASENO"
-}
-passed() {
-  prlog -e "\t[PASS]"
-  PASSED_CASES="$PASSED_CASES $CASENO"
-}
 
+eval_result() { # retval testlog
+  case $1 in
+    $PASS)
+      prlog -e "\t[PASS]"
+      PASSED_CASES="$PASSED_CASES $CASENO"
+      return 0
+    ;;
+    $FAIL)
+      prlog -e "\t[FAIL]"
+      FAILED_CASES="$FAILED_CASES $CASENO"
+      return 1 # this is a bug
+    ;;
+    $XFAIL)
+      prlog -e "\t[XFAIL]"
+      XFAILED_CASES="$XFAILED_CASES $CASENO"
+      return 0
+    ;;
+    $XPASS)
+      prlog -e "\t[XPASS]"
+      XPASSED_CASES="$XPASSED_CASES $CASENO"
+      return 1 # this can be a bug
+    ;;
+    $UNSUP)
+      prlog -e "\t[UNSUPPORTED]"
+      UNSUPPORTED_CASES="$UNSUPPORTED_CASES $CASENO"
+      return 0 # this is not a bug
+  esac
+}
 
 # Run one test case
 run_test() { # testfile
@@ -132,11 +163,9 @@ run_test() { # testfile
   echo "execute: "$1 > $testlog
   (cd $TRACING_DIR; set -x ; source $t) >> $testlog 2>&1
   ret=$?
-  if [ $ret -ne 0 ]; then
-    failed
-    catlog $testlog
-  else
-    passed
+  eval_result $ret $testlog
+  if [ $? -eq 0 ]; then
+    # Remove test log if the test was done as it was expected.
     [ $KEEP_LOG -eq 0 ] && rm $testlog
   fi
 }
@@ -145,8 +174,12 @@ run_test() { # testfile
 for t in $TEST_CASES; do
   run_test $t
 done
+
 prlog ""
 prlog "# of passed: " `echo $PASSED_CASES | wc -w`
 prlog "# of failed: " `echo $FAILED_CASES | wc -w`
+prlog "# of xfailed: " `echo $XFAILED_CASES | wc -w`
+prlog "# of xpassed: " `echo $XPASSED_CASES | wc -w`
+prlog "# of unsupported: " `echo $UNSUPPORTED_CASES | wc -w`
 
-test -z "$FAILED_CASES" # if no error, return 0
+test -z "$FAILED_CASES$XPASSED_CASES" # if no error, return 0
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
index ce5f735..881eddd 100644
--- a/tools/testing/ftrace/test.d/template
+++ b/tools/testing/ftrace/test.d/template
@@ -1,4 +1,8 @@
 #!/bin/sh
 # description: %HERE DESCRIBE WHAT THIS DOES%
 # you have to add ".tc" extention for your testcase file
-exit 0 # Return 0 if the test is passed, otherwise return !0
+exit $PASS # Return $PASS if the test is passed.
+# If the test is failed, return $FAIL.
+# If the test is failed as expected, return $XFAIL.
+# If the test is passed, but it was expected to fail, return $XPASS.
+# If the test can not run because of lack of feature, return $UNSUP


