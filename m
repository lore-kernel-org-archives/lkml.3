Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaIRME5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:04:57 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60587 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaIRMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:04:54 -0400
Subject: [PATCH v4 1/4] ftracetest: Initial commit for ftracetest
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 18 Sep 2014 12:04:45 +0000
Message-ID: <20140918120445.28308.57538.stgit@kbuild-f20.novalocal>
In-Reply-To: <20140918120437.28308.72301.stgit@kbuild-f20.novalocal>
References: <20140918120437.28308.72301.stgit@kbuild-f20.novalocal>
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

Changes in v4:
 - Move this under selftests. :)
 - Add a copyright and note of GPLv2.
 - Fix documents acconding to Steven's comments.
 - Fix a small bug pointed by Namhyng.

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
 MAINTAINERS                                    |    1 
 tools/testing/selftests/Makefile               |    1 
 tools/testing/selftests/ftrace/Makefile        |    7 +
 tools/testing/selftests/ftrace/README          |   46 +++++++
 tools/testing/selftests/ftrace/ftracetest      |  157 ++++++++++++++++++++++++
 tools/testing/selftests/ftrace/test.d/template |    4 +
 6 files changed, 216 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/Makefile
 create mode 100644 tools/testing/selftests/ftrace/README
 create mode 100755 tools/testing/selftests/ftrace/ftracetest
 create mode 100644 tools/testing/selftests/ftrace/test.d/template

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e7866a..29e22db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9295,6 +9295,7 @@ F:	include/*/ftrace.h
 F:	include/linux/trace*.h
 F:	include/trace/
 F:	kernel/trace/
+F:	tools/testing/selftests/ftrace
 
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 36ff2e4..45f145c 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -14,6 +14,7 @@ TARGETS += powerpc
 TARGETS += user
 TARGETS += sysctl
 TARGETS += firmware
+TARGETS += ftrace
 
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
new file mode 100644
index 0000000..76cc9f1
--- /dev/null
+++ b/tools/testing/selftests/ftrace/Makefile
@@ -0,0 +1,7 @@
+all:
+
+run_tests:
+	@/bin/sh ./ftracetest || echo "ftrace selftests: [FAIL]"
+
+clean:
+	rm -rf logs/*
diff --git a/tools/testing/selftests/ftrace/README b/tools/testing/selftests/ftrace/README
new file mode 100644
index 0000000..ee2cef7
--- /dev/null
+++ b/tools/testing/selftests/ftrace/README
@@ -0,0 +1,46 @@
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
+Copy test.d/template to your testcase (whose filename must have *.tc
+extension) and rewrite the test description line.
+
+ * The working directory of the script is <debugfs>/tracing/.
+
+ * Take care with side effects as the tests are run with root privilege.
+
+ * The tests should not run for a long period of time (more than 1 min.)
+   These are to be unit tests.
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
diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
new file mode 100755
index 0000000..02f4e7a
--- /dev/null
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -0,0 +1,157 @@
+#!/bin/sh
+
+# ftracetest - Ftrace test shell scripts
+#
+# Copyright (C) Hitachi Ltd., 2014
+#  Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
+#
+# Released under the terms of the GPL v2.
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
+  (cd $TRACING_DIR; set -x ; . $1) >> $testlog 2>&1
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
diff --git a/tools/testing/selftests/ftrace/test.d/template b/tools/testing/selftests/ftrace/test.d/template
new file mode 100644
index 0000000..ce5f735
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/template
@@ -0,0 +1,4 @@
+#!/bin/sh
+# description: %HERE DESCRIBE WHAT THIS DOES%
+# you have to add ".tc" extention for your testcase file
+exit 0 # Return 0 if the test is passed, otherwise return !0


