Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaHECqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:46:05 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47620 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaHECqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:46:01 -0400
Subject: [RFC PATCH 1/3] ftracetest: Initial commit for ftracetest
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 05 Aug 2014 02:45:51 +0000
Message-ID: <20140805024551.23693.63562.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
References: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/testing/ftrace/README          |   38 ++++++++++
 tools/testing/ftrace/ftracetest      |  133 ++++++++++++++++++++++++++++++++++
 tools/testing/ftrace/test.d/template |    4 +
 3 files changed, 175 insertions(+)
 create mode 100644 tools/testing/ftrace/README
 create mode 100755 tools/testing/ftrace/ftracetest
 create mode 100644 tools/testing/ftrace/test.d/template

diff --git a/tools/testing/ftrace/README b/tools/testing/ftrace/README
new file mode 100644
index 0000000..16de781
--- /dev/null
+++ b/tools/testing/ftrace/README
@@ -0,0 +1,38 @@
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
+TODO
+====
+
+ * Fancy colored output :)
+
+ * Integrate with selftest?
diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
new file mode 100755
index 0000000..5a7c9f8
--- /dev/null
+++ b/tools/testing/ftrace/ftracetest
@@ -0,0 +1,133 @@
+#!/bin/bash
+# ftracetest - Ftrace test shell scripts
+# Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
+
+usage() { # errno [message]
+[ "$2" ] && echo $2
+echo "Usage: ftracetest [options] [testcase(s)]"
+echo " Options:"
+echo "		-h|--help  Show help message"
+echo "		-k|--keep  Keep passed test logs"
+echo "		-d|--debug Debug mode (trace all shell commands)"
+exit $1
+}
+
+# Utilities
+absdir() { # file_path
+  (cd `dirname $1`; pwd)
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
+parse_opts() { # opts
+  OPT_TEST_CASES=
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
+    *)
+      if [ -f "$1" ]; then
+        OPT_TEST_CASES="$OPT_TEST_CASES `absdir $1`/`basename $1`"
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
+TEST_CASES=`find $TEST_DIR -name *.tc`
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
+  echo $@ | tee -a $LOG_FILE
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
+  prlog -e "\t[FAILED]"
+  FAILED_CASES="$FAILED_CASES $CASENO"
+}
+passed() {
+  prlog -e "\t[PASSED]"
+  PASSED_CASES="$PASSED_CASES $CASENO"
+}
+
+
+# Run one test case
+function run_test() { # testfile
+  local testname=`basename $1`
+  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
+  testcase $1
+  echo "execute: "$1 > $testlog
+  (cd $TRACING_DIR; set -x ; source $t) >> $testlog 2>&1
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
+prlog "Passed: " `echo $PASSED_CASES | wc -w`
+prlog "Failed: " `echo $FAILED_CASES | wc -w`
+
+test -z "$FAILED_CASES" # if no error, return 0
diff --git a/tools/testing/ftrace/test.d/template b/tools/testing/ftrace/test.d/template
new file mode 100644
index 0000000..e855b65
--- /dev/null
+++ b/tools/testing/ftrace/test.d/template
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: %HERE DESCRIBE WHAT THIS DOES%
+# you have to add ".tc" extention for your testcase file
+exit 0 # Return 0 if the test is passed, otherwise return !0


