Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaLDP4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:56:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:54179 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754421AbaLDPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:55:46 -0500
Message-Id: <20141204155544.367019591@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 04 Dec 2014 10:55:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 2/2] ftracetest: Add --verbose option for showing echo output
References: <20141204155517.575600663@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftracetest-Add-verbose-option-for-showing-echo-outpu.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add --verbose/-v option for showing echo output in testcases.
This is good for checking the progress of testcases which
take a longer time to run.

To implement this feature, all the testcase failures are
captured in ftracetest and send signal to set SIG_RESULT=FAIL.

Link: http://lkml.kernel.org/r/20141204194123.7376.22964.stgit@localhost.localdomain

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/ftracetest | 33 +++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index e8b402193a82..da48812ab95e 100755
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
 
@@ -139,12 +145,8 @@ testcase() { # testfile
   prlog -n "[$CASENO]$desc"
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
@@ -188,6 +190,9 @@ SIG_RESULT=
 SIG_BASE=36	# Use realtime signals
 SIG_PID=$$
 
+SIG_FAIL=$((SIG_BASE + FAIL))
+trap 'SIG_RESULT=$FAIL' $SIG_FAIL
+
 SIG_UNRESOLVED=$((SIG_BASE + UNRESOLVED))
 exit_unresolved () {
   kill -s $SIG_UNRESOLVED $SIG_PID
@@ -216,6 +221,12 @@ exit_xfail () {
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
@@ -223,10 +234,12 @@ run_test() { # testfile
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
-- 
2.1.3


