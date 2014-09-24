Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaIXQ27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:28:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:31246 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753426AbaIXQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:28:01 -0400
Message-Id: <20140924162759.470524361@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 24 Sep 2014 12:27:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 1/3] ftracetest: Initial commit for ftracetest
References: <20140924162719.481050866@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftracetest-Initial-commit-for-ftracetest.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

ftracetest is a collection of testcase shell-scripts for ftrace.
To avoid regressions of ftrace, these testcases check correct
ftrace behaviors. If someone would like to add any features on
ftrace, the patch series should have at least one testcase for
checking the new behavior.

Link: http://lkml.kernel.org/p/20140922234250.23415.68758.stgit@kbuild-f20.novalocal

Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 MAINTAINERS                                    |   1 +
 tools/testing/selftests/Makefile               |   1 +
 tools/testing/selftests/ftrace/Makefile        |   7 ++
 tools/testing/selftests/ftrace/README          |  45 +++++++
 tools/testing/selftests/ftrace/ftracetest      | 159 +++++++++++++++++++++++++
 tools/testing/selftests/ftrace/test.d/template |   4 +
 6 files changed, 217 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/Makefile
 create mode 100644 tools/testing/selftests/ftrace/README
 create mode 100755 tools/testing/selftests/ftrace/ftracetest
 create mode 100644 tools/testing/selftests/ftrace/test.d/template

diff --git a/MAINTAINERS b/MAINTAINERS
index 670b3dcce2de..bb455d0ae12a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9310,6 +9310,7 @@ F:	include/*/ftrace.h
 F:	include/linux/trace*.h
 F:	include/trace/
 F:	kernel/trace/
+F:	tools/testing/selftests/ftrace/
 
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 36ff2e4c7b6f..45f145c6f843 100644
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
index 000000000000..76cc9f156267
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
index 000000000000..b8631f03e754
--- /dev/null
+++ b/tools/testing/selftests/ftrace/README
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
diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
new file mode 100755
index 000000000000..4c6c2fad2cda
--- /dev/null
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -0,0 +1,159 @@
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
+prlog "=== Ftrace unit tests ==="
+
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
index 000000000000..ce5f735b2e65
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/template
@@ -0,0 +1,4 @@
+#!/bin/sh
+# description: %HERE DESCRIBE WHAT THIS DOES%
+# you have to add ".tc" extention for your testcase file
+exit 0 # Return 0 if the test is passed, otherwise return !0
-- 
2.0.1


