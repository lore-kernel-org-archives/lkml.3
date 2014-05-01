Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaEAV3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:29:04 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60191 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaEAV2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:28:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Aaron Tomlin <atomlin@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>, linux-doc@vger.kernel.org
Subject: [PATCH 4/4] test: validate sysctl_writes_strict
Date: Thu,  1 May 2014 14:26:37 -0700
Message-Id: <1398979597-3589-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398979597-3589-1-git-send-email-keescook@chromium.org>
References: <1398979597-3589-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds several behavioral tests to sysctl string and number writing
to detect unexpected cases that behaved differently when the sysctl
kernel.sysctl_writes_strict != 1.

[ original ]
root@localhost:~# make test_num
== Testing sysctl behavior against /proc/sys/kernel/domainname ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... FAIL
Writing beyond end of sysctl ... FAIL
Writing sysctl with multiple long writes ... FAIL
Writing entire sysctl in short writes ... FAIL
Writing middle of sysctl after unsynchronized seek ... ok
Checking sysctl maxlen is at least 65 ... ok
Checking sysctl keeps original string on overflow append ... FAIL
Checking sysctl stays NULL terminated on write ... ok
Checking sysctl stays NULL terminated on overwrite ... ok
make: *** [test_num] Error 1
root@localhost:~# make test_string
== Testing sysctl behavior against /proc/sys/vm/swappiness ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... FAIL
Writing beyond end of sysctl ... FAIL
Writing sysctl with multiple long writes ... ok
make: *** [test_string] Error 1

[ with CONFIG_PROC_SYSCTL_STRICT_WRITES ]
root@localhost:~# make run_tests
== Testing sysctl behavior against /proc/sys/kernel/domainname ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... ok
Writing beyond end of sysctl ... ok
Writing sysctl with multiple long writes ... ok
Writing entire sysctl in short writes ... ok
Writing middle of sysctl after unsynchronized seek ... ok
Checking sysctl maxlen is at least 65 ... ok
Checking sysctl keeps original string on overflow append ... ok
Checking sysctl stays NULL terminated on write ... ok
Checking sysctl stays NULL terminated on overwrite ... ok
== Testing sysctl behavior against /proc/sys/vm/swappiness ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... ok
Writing beyond end of sysctl ... ok
Writing sysctl with multiple long writes ... ok

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/sysctl.c                                 |    4 +-
 tools/testing/selftests/Makefile                |    1 +
 tools/testing/selftests/sysctl/Makefile         |   19 ++++
 tools/testing/selftests/sysctl/common_tests     |  109 +++++++++++++++++++++++
 tools/testing/selftests/sysctl/run_numerictests |   10 +++
 tools/testing/selftests/sysctl/run_stringtests  |   77 ++++++++++++++++
 6 files changed, 218 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/sysctl/Makefile
 create mode 100644 tools/testing/selftests/sysctl/common_tests
 create mode 100644 tools/testing/selftests/sysctl/run_numerictests
 create mode 100644 tools/testing/selftests/sysctl/run_stringtests

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d5bee7949e4a..51bbf904d694 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1783,8 +1783,8 @@ static int _proc_do_string(char *data, int maxlen, int write,
 
 static void warn_sysctl_write(struct ctl_table *table)
 {
-	pr_warn("%s wrote to %s when file position was not 0!\n",
-		current->task_comm, table->procname);
+	pr_warn("write to %s by %s used a non-zero file position!\n",
+		table->procname, current->comm);
 	pr_warn("This will not be supported in the future.\n");
 	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
 }
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 32487ed18354..e66e710cc595 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -10,6 +10,7 @@ TARGETS += timers
 TARGETS += vm
 TARGETS += powerpc
 TARGETS += user
+TARGETS += sysctl
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/sysctl/Makefile b/tools/testing/selftests/sysctl/Makefile
new file mode 100644
index 000000000000..0a92adaf0865
--- /dev/null
+++ b/tools/testing/selftests/sysctl/Makefile
@@ -0,0 +1,19 @@
+# Makefile for sysctl selftests.
+# Expects kernel.sysctl_writes_strict=1.
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests".
+all:
+
+# Allow specific tests to be selected.
+test_num:
+	@/bin/sh ./run_numerictests
+
+test_string:
+	@/bin/sh ./run_stringtests
+
+run_tests: all test_num test_string
+
+# Nothing to clean up.
+clean:
+
+.PHONY: all run_tests clean test_num test_string
diff --git a/tools/testing/selftests/sysctl/common_tests b/tools/testing/selftests/sysctl/common_tests
new file mode 100644
index 000000000000..17d534b1b7b4
--- /dev/null
+++ b/tools/testing/selftests/sysctl/common_tests
@@ -0,0 +1,109 @@
+#!/bin/sh
+
+TEST_FILE=$(mktemp)
+
+echo "== Testing sysctl behavior against ${TARGET} =="
+
+set_orig()
+{
+	echo "${ORIG}" > "${TARGET}"
+}
+
+set_test()
+{
+	echo "${TEST_STR}" > "${TARGET}"
+}
+
+verify()
+{
+	local seen
+	seen=$(cat "$1")
+	if [ "${seen}" != "${TEST_STR}" ]; then
+		return 1
+	fi
+	return 0
+}
+
+trap 'set_orig; rm -f "${TEST_FILE}"' EXIT
+
+rc=0
+
+echo -n "Writing test file ... "
+echo "${TEST_STR}" > "${TEST_FILE}"
+if ! verify "${TEST_FILE}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl is not set to test value ... "
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+echo -n "Writing sysctl from shell ... "
+set_test
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+echo -n "Resetting sysctl to original value ... "
+set_orig
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+# Now that we've validated the sanity of "set_test" and "set_orig",
+# we can use those functions to set starting states before running
+# specific behavioral tests.
+
+echo -n "Writing entire sysctl in single write ... "
+set_orig
+dd if="${TEST_FILE}" of="${TARGET}" bs=4096 2>/dev/null
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Writing middle of sysctl after synchronized seek ... "
+set_test
+dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 skip=1 2>/dev/null
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Writing beyond end of sysctl ... "
+set_orig
+dd if="${TEST_FILE}" of="${TARGET}" bs=20 seek=2 2>/dev/null
+if verify "${TARGET}"; then
+        echo "FAIL" >&2
+        rc=1
+else
+        echo "ok"
+fi
+
+echo -n "Writing sysctl with multiple long writes ... "
+set_orig
+(perl -e 'print "A" x 50;'; echo "${TEST_STR}") | \
+	dd of="${TARGET}" bs=50 2>/dev/null
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
diff --git a/tools/testing/selftests/sysctl/run_numerictests b/tools/testing/selftests/sysctl/run_numerictests
new file mode 100644
index 000000000000..8510f93f2d14
--- /dev/null
+++ b/tools/testing/selftests/sysctl/run_numerictests
@@ -0,0 +1,10 @@
+#!/bin/sh
+
+SYSCTL="/proc/sys"
+TARGET="${SYSCTL}/vm/swappiness"
+ORIG=$(cat "${TARGET}")
+TEST_STR=$(( $ORIG + 1 ))
+
+. ./common_tests
+
+exit $rc
diff --git a/tools/testing/selftests/sysctl/run_stringtests b/tools/testing/selftests/sysctl/run_stringtests
new file mode 100644
index 000000000000..90a9293d520c
--- /dev/null
+++ b/tools/testing/selftests/sysctl/run_stringtests
@@ -0,0 +1,77 @@
+#!/bin/sh
+
+SYSCTL="/proc/sys"
+TARGET="${SYSCTL}/kernel/domainname"
+ORIG=$(cat "${TARGET}")
+TEST_STR="Testing sysctl"
+
+. ./common_tests
+
+# Only string sysctls support seeking/appending.
+MAXLEN=65
+
+echo -n "Writing entire sysctl in short writes ... "
+set_orig
+dd if="${TEST_FILE}" of="${TARGET}" bs=1 2>/dev/null
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Writing middle of sysctl after unsynchronized seek ... "
+set_test
+dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 2>/dev/null
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl maxlen is at least $MAXLEN ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-2), "B";' | \
+	dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
+if ! grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl keeps original string on overflow append ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
+	dd of="${TARGET}" bs=$(( MAXLEN - 1 )) 2>/dev/null
+if grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl stays NULL terminated on write ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
+	dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
+if grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl stays NULL terminated on overwrite ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-1), "BB";' | \
+	dd of="${TARGET}" bs=$(( $MAXLEN + 1 )) 2>/dev/null
+if grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+exit $rc
-- 
1.7.9.5

