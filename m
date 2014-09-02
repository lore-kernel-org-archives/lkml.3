Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaIBLGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:06:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38990 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaIBLGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:06:49 -0400
Subject: [RFC PATCH v3 1/4] ftracetest: Initial commit for ftracetest
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 11:06:39 +0000
Message-ID: <20140902110639.3207.38388.stgit@kbuild-f20.novalocal>
In-Reply-To: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftracetest is a collection of testcase shell-scripts for ftrace.
To avoid regressions of ftrace, these testcases check correct
ftrace behaviors. If someone would like to add any features on
ftrace, the patch series should have at least one testcase for
checking the new behavior.

Changes in v3:
 - Use "." instead of "source".
 - Don't use -e option for echo since dash doesn't support it.

Changes in v2:
 - Remove unneeded 'function' keyword.
 - Add abspath and find_testcases.
 - Make OPT_TEST_CASES a local var.
 - Ensure given testcase ended with .tc.
 - Accept a directory option which has multiple testcases.
 - Change [PASSED]/[FAILED] to [PASS]/[FAIL]
 - Change the basic shell to sh (dash).

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/testing/ftrace/README          |   45 ++++++++++
 tools/testing/ftrace/ftracetest      |  152 ++++++++++++++++++++++++++++++++++
 tools/testing/ftrace/test.d/template |    4 +
 3 files changed, 201 insertions(+)
 create mode 100644 tools/testing/ftrace/README
 create mode 100755 tools/testing/ftrace/ftracetest
 create mode 100644 tools/testing/ftrace/test.d/template

diff --git a/tools/testing/ftrace/README b/tools/testing/ftrace/README
new file mode 100644
index 0000000..5d5de16
--- /dev/null
+++ b/tools/testing/ftrace/README
@@ -0,0 +1,45 @@
+Linux Ftrace Testcases
+
+This is a collection of testcases for ftrace tracing feature in the Linux
+kernel. Since ftrace exports interfaces via the debugfs, we just need
+shell scripts for testing. Feel free to add new test cases.
+
+Running the ftrace testcases
+============================
+
+At first, you need to be the root user to run this script.
+To run all testcases:
+
+  $ sudo ./ftracetest
+
+To run specific testcases:
+
+  # ./ftracetest test.d/basic3.tc
+
+Or you can also run testcases under given directory:
+
+  # ./ftracetest test.d/kprobe/
+
+Contributing new testcases
+==========================
+
+Copy test.d/template to your testcase (whose filename must has *.tc extension)
+and rewrite test description line.
+
+ * The working directory of the script is <debugfs>/tracing/.
+
+ * Take care about the side effect, because that is run with root privilege.
+
+ * Don't take too long. It's a kind of unit test.
+
+ * You can add a directory for your testcases under test.d/ if needed.
+
+ * The test cases should run on dash (busybox shell) for testing on
+   minimal cross-build environments.
+
+TODO
+====
+
+ * Fancy colored output :)
+
+ * Integrate with selftest?
diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
new file mode 100755
index 0000000..8d92e74
--- /dev/null
+++ b/tools/testing/ftrace/ftracetest
@@ -0,0 +1,152 @@
+#!/bin/sh
+# ftracetest - Ftrace test shell scripts
+# Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
+
+usage() { # errno [message]
+[ "$2" ] && echo $2
+echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
+echo " Options:"
+echo "		-h|--help  Show help message"
+echo "		-k|--keep  Keep passed test logs"
+echo "		-d|--debug Debug mode (trace all shell commands)"
+exit $1
+}
+
+errexit() { # message
+  echo "Error: $1" 1>&2
+  exit 1
+}
+
+# Ensuring user privilege
+if [ `id -u` -ne 0 ]; then
+  errexit "this must be run by root user"
+fi
+
+# Utilities
+absdir() { # file_path
+  (cd `dirname $1`; pwd)
+}
+
+abspath() {
+  echo `absdir $1`/`basename $1`
+}
+
+find_testcases() { #directory
+  echo `find $1 -name \*.tc`
+}
+
+parse_opts() { # opts
+  local OPT_TEST_CASES=
+  local OPT_TEST_DIR=
+
+  while [ "$1" ]; do
+    case "$1" in
+    --help|-h)
+      usage 0
+    ;;
+    --keep|-k)
+      KEEP_LOG=1
+      shift 1
+    ;;
+    --debug|-d)
+      DEBUG=1
+      shift 1
+    ;;
+    *.tc)
+      if [ -f "$1" ]; then
+        OPT_TEST_CASES="$OPT_TEST_CASES `abspath $1`"
+        shift 1
+      else
+        usage 1 "$1 is not a testcase"
+      fi
+      ;;
+    *)
+      if [ -d "$1" ]; then
+        OPT_TEST_DIR=`abspath $1`
+        OPT_TEST_CASES="$OPT_TEST_CASES `find_testcases $OPT_TEST_DIR`"
+        shift 1
+      else
+        usage 1 "Invalid option ($1)"
+      fi
+    ;;
+    esac
+  done
+  if [ "$OPT_TEST_CASES" ]; then
+    TEST_CASES=$OPT_TEST_CASES
+  fi
+}
+
+# Parameters
+DEBUGFS_DIR=`grep debugfs /proc/mounts | cut -f2 -d' '`
+TRACING_DIR=$DEBUGFS_DIR/tracing
+TOP_DIR=`absdir $0`
+TEST_DIR=$TOP_DIR/test.d
+TEST_CASES=`find_testcases $TEST_DIR`
+LOG_DIR=$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`/
+KEEP_LOG=0
+DEBUG=0
+# Parse command-line options
+parse_opts $*
+
+[ $DEBUG -ne 0 ] && set -x
+
+# Verify parameters
+if [ -z "$DEBUGFS_DIR" -o ! -d "$TRACING_DIR" ]; then
+  errexit "No ftrace directory found"
+fi
+
+# Preparing logs
+LOG_FILE=$LOG_DIR/ftracetest.log
+mkdir -p $LOG_DIR || errexit "Failed to make a log directory: $LOG_DIR"
+date > $LOG_FILE
+prlog() { # messages
+  echo "$@" | tee -a $LOG_FILE
+}
+catlog() { #file
+  cat $1 | tee -a $LOG_FILE
+}
+
+# Testcase management
+PASSED_CASES=
+FAILED_CASES=
+CASENO=0
+testcase() { # testfile
+  CASENO=$((CASENO+1))
+  prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
+}
+failed() {
+  prlog "	[FAIL]"
+  FAILED_CASES="$FAILED_CASES $CASENO"
+}
+passed() {
+  prlog "	[PASS]"
+  PASSED_CASES="$PASSED_CASES $CASENO"
+}
+
+
+# Run one test case
+run_test() { # testfile
+  local testname=`basename $1`
+  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
+  testcase $1
+  echo "execute: "$1 > $testlog
+  (cd $TRACING_DIR; set -x ; . $t) >> $testlog 2>&1
+  ret=$?
+  if [ $ret -ne 0 ]; then
+    failed
+    catlog $testlog
+  else
+    passed
+    [ $KEEP_LOG -eq 0 ] && rm $testlog
+  fi
+}
+
+# Main loop
+for t in $TEST_CASES; do
+  run_test $t
+done
+prlog ""
+prlog "# of passed: " `echo $PASSED_CASES | wc -w`
+prlog "# of failed: " `echo $FAILED_CASES | wc -w`
+
+test -z "$FAILED_CASES" # if no error, return 0
diff --git a/tools/testing/ftrace/test.d/template b/tools/testing/ftrace/test.d/template
new file mode 100644
index 0000000..ce5f735
--- /dev/null
+++ b/tools/testing/ftrace/test.d/template
@@ -0,0 +1,4 @@
+#!/bin/sh
+# description: %HERE DESCRIBE WHAT THIS DOES%
+# you have to add ".tc" extention for your testcase file
+exit 0 # Return 0 if the test is passed, otherwise return !0


