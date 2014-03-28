Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaC2P2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:28:22 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45689 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaC2P2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:28:15 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 27/29] ktap: add testsuite and benchmark(tools/ktap/test/*)
Date: Fri, 28 Mar 2014 10:45:22 -0400
Message-Id: <1396017924-7754-28-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktap testsuite is based on perl-prove framwork.
More info can read from test/README.

The test framework is contributed by Yichun Zhang (agentzh)

ktap run the test suite in parallel defaultly:
        prove -j4 -r test/

There also have several benchmark script to compare performance
between ktap with stap.

The benchmark shows that:
1). ktap number computation and comparsion overhead is bigger than stap,
    nearly 10+%.

2). Perf backend tracing overhead is bigger than raw tracepoint/kprobe.

3). ktap table operation overhead is smaller than stap, nearly 10+%.

(This benchmark result only tell the data in my box)

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/test/README                   |  69 ++++
 tools/ktap/test/arithmetic.t             | 109 ++++++
 tools/ktap/test/benchmark/cmp_neq.sh     | 158 +++++++++
 tools/ktap/test/benchmark/cmp_profile.sh |  54 +++
 tools/ktap/test/benchmark/cmp_table.sh   | 112 +++++++
 tools/ktap/test/benchmark/sembench.c     | 556 +++++++++++++++++++++++++++++++
 tools/ktap/test/cli-arg.t                |  25 ++
 tools/ktap/test/concat.t                 |  21 ++
 tools/ktap/test/count.t                  |  25 ++
 tools/ktap/test/deadloop.t               |  37 ++
 tools/ktap/test/fibonacci.t              |  42 +++
 tools/ktap/test/function.t               |  78 +++++
 tools/ktap/test/if.t                     |  32 ++
 tools/ktap/test/kprobe.t                 |  82 +++++
 tools/ktap/test/kretprobe.t              |  35 ++
 tools/ktap/test/len.t                    |  27 ++
 tools/ktap/test/lib/Test/ktap.pm         | 128 +++++++
 tools/ktap/test/looping.t                |  46 +++
 tools/ktap/test/one-liner.t              |  48 +++
 tools/ktap/test/pairs.t                  |  52 +++
 tools/ktap/test/stack_overflow.t         |  22 ++
 tools/ktap/test/syntax-err.t             |  19 ++
 tools/ktap/test/table.t                  |  81 +++++
 tools/ktap/test/time.t                   |  59 ++++
 tools/ktap/test/timer.t                  |  65 ++++
 tools/ktap/test/tracepoint.t             |  53 +++
 tools/ktap/test/util/reindex             |  61 ++++
 tools/ktap/test/zerodivide.t             |  21 ++
 28 files changed, 2117 insertions(+)
 create mode 100644 tools/ktap/test/README
 create mode 100644 tools/ktap/test/arithmetic.t
 create mode 100644 tools/ktap/test/benchmark/cmp_neq.sh
 create mode 100644 tools/ktap/test/benchmark/cmp_profile.sh
 create mode 100644 tools/ktap/test/benchmark/cmp_table.sh
 create mode 100644 tools/ktap/test/benchmark/sembench.c
 create mode 100644 tools/ktap/test/cli-arg.t
 create mode 100644 tools/ktap/test/concat.t
 create mode 100644 tools/ktap/test/count.t
 create mode 100644 tools/ktap/test/deadloop.t
 create mode 100644 tools/ktap/test/fibonacci.t
 create mode 100644 tools/ktap/test/function.t
 create mode 100644 tools/ktap/test/if.t
 create mode 100644 tools/ktap/test/kprobe.t
 create mode 100644 tools/ktap/test/kretprobe.t
 create mode 100644 tools/ktap/test/len.t
 create mode 100644 tools/ktap/test/lib/Test/ktap.pm
 create mode 100644 tools/ktap/test/looping.t
 create mode 100644 tools/ktap/test/one-liner.t
 create mode 100644 tools/ktap/test/pairs.t
 create mode 100644 tools/ktap/test/stack_overflow.t
 create mode 100644 tools/ktap/test/syntax-err.t
 create mode 100644 tools/ktap/test/table.t
 create mode 100644 tools/ktap/test/time.t
 create mode 100644 tools/ktap/test/timer.t
 create mode 100644 tools/ktap/test/tracepoint.t
 create mode 100755 tools/ktap/test/util/reindex
 create mode 100644 tools/ktap/test/zerodivide.t

diff --git a/tools/ktap/test/README b/tools/ktap/test/README
new file mode 100644
index 0000000..5a628e1
--- /dev/null
+++ b/tools/ktap/test/README
@@ -0,0 +1,69 @@
+This directory contains the test suite for ktap.
+
+Prerequisites
+-------------
+
+One needs to install perl and CPAN modules Test::Base and IPC::Run
+before running the tests. After perl is installed, the "cpan" utility
+can be used to install the CPAN modules required:
+
+    cpan Test::Base IPC::Run
+
+Alternatively you can just install the pre-built binary packages
+provided by your Linux distribution vendor. For example, on Fedora, you
+just need to run
+
+    yum install perl-Test-Base perl-IPC-Run
+
+Running tests
+-------------
+
+You are required to run the tests from the root directory of this project.
+
+You can run the whole test suite like this:
+
+    prove -r test/
+
+To utilize multiple CPU cores while running the tests, it is also
+supported to spawn multiple processes to run the test files in parallel,
+as in
+
+    prove -j4 -r test/
+
+Then 4 processes will be spawned to run the tests at the same time.
+
+To run individual .t test files, just specify their file paths
+explicitly:
+
+    prove test/cli-args.t test/one-liner.t
+
+If you just want to run an individual test case in a particular .t
+file, then just add the line
+
+    --- ONLY
+
+to the end of the test block you want to run and run that .t file
+normally with the "prove" utility.
+
+Similarly, if you want to skip a particular test block, add the line
+
+    --- SKIP
+
+to that test block.
+
+Test file formatting
+--------------------
+
+We do have a "reindex" tool to automatically re-format
+the .t test files, so that you do not have to manually get the test
+serial numbers exactly right, like "TEST 1: ", "TEST 2: " and etc,
+nor manually keep 3 blank lines between adjacent test blocks. For
+example,
+
+    ./test/util/reindex test/cli-arg.t
+
+or re-format all the .t files:
+
+    ./test/util/reindex test/*.t
+
+Always run this tool before committing your newly editted tests.
diff --git a/tools/ktap/test/arithmetic.t b/tools/ktap/test/arithmetic.t
new file mode 100644
index 0000000..e56daf0
--- /dev/null
+++ b/tools/ktap/test/arithmetic.t
@@ -0,0 +1,109 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: arithmetic
+--- src
+if (1 > 2) {
+	print("failed")
+}
+
+if (200 < 100) {
+	print("failed")
+}
+
+if (1 == nil) {
+	print("failed")
+}
+
+if (1 != nil) {
+	print("1 != nil")
+}
+
+if (nil == 1) {
+	print("failed")
+}
+
+if (nil != 1) {
+	print("nil != 1")
+}
+
+if (1 == "test") {
+	print("failed")
+}
+
+if (1 != "test") {
+	print("1 != 'test'")
+}
+
+if ("test" == 1) {
+	print("failed")
+}
+
+if ("test" != 1) {
+	print("'test' != 1")
+}
+
+if ("1234" == "1") {
+	print("failed")
+}
+
+if ("1234" != "1") {
+	print("'1234' != '1'")
+}
+
+
+
+var a = 4
+var b = 5
+
+if ((a + b) != 9) {
+	print("failed")
+}
+
+if ((a - b) != -1) {
+	print("failed")
+}
+
+if ((a * b) != 20) {
+	print("failed")
+}
+
+if ((a % b) != 4) {
+	print("failed")
+}
+
+if ((a / b) != 0) {
+	print("failed")
+}
+
+
+
+#below checking only valid for 64-bit system
+
+var c = 0x1234567812345678
+var d = 0x2
+
+if (c + d != 0x123456781234567a) {
+	print("failed")
+}
+
+if (-1 != 0xffffffffffffffff) {
+	print("failed")
+}
+
+--- out
+1 != nil
+nil != 1
+1 != 'test'
+'test' != 1
+'1234' != '1'
+
+--- err
+
+
diff --git a/tools/ktap/test/benchmark/cmp_neq.sh b/tools/ktap/test/benchmark/cmp_neq.sh
new file mode 100644
index 0000000..da69131
--- /dev/null
+++ b/tools/ktap/test/benchmark/cmp_neq.sh
@@ -0,0 +1,158 @@
+#!/bin/sh
+
+# This script compare number equality performance between ktap and stap.
+# It also compare different ktap tracing interfaces.
+#
+# 1. ktap -e 'trace syscalls:sys_enter_futex {}'
+# 2. ktap -e 'kdebug.tracepoint("sys_enter_futex", function () {})'
+# 3. ktap -e 'trace probe:SyS_futex uaddr=%di {}'
+# 4. ktap -e 'kdebug.kprobe("SyS_futex", function () {})'
+# 5. stap -e 'probe syscall.futex {}'
+# 6. ktap -d -e 'trace syscalls:sys_enter_futex {}'
+# 7. ktap -d -e 'kdebug.tracepoint("sys_enter_futex", function () {})'
+# 8. ktap -e 'trace syscalls:sys_enter_futex /kernel_buildin_filter/ {}'
+
+#Result:
+#ktap number computation and comparsion overhead is bigger than stap,
+#nearly 10+% (4 vs. 5 in above)), ktap is not very slow.
+#
+#Perf backend tracing overhead is big, because it need copy temp buffer, and
+#code path is very long than direct callback(1 vs. 4 in above).
+
+gcc -o sembench sembench.c -O2 -lpthread
+
+COMMAND="./sembench -t 200 -w 20 -r 30 -o 2"
+
+#------------------------------------------------------------#
+
+echo -e "without tracing:"
+#$COMMAND; $COMMAND; $COMMAND
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'trace syscalls:sys_enter_futex {
+	var uaddr = arg2
+        if (uaddr == 0x100 || uaddr == 0x200 || uaddr == 0x300 ||
+	    uaddr == 0x400 || uaddr == 0x500 || uaddr == 0x600 ||
+	    uaddr == 0x700 || uaddr == 0x800 || uaddr == 0x900 ||
+	    uaddr == 0x1000) {
+                printf("%x %x\n", arg1, arg2)
+        }}' &
+
+echo -e "\nktap tracing: trace syscalls:sys_enter_futex { if (arg2 == 0x100 || arg2 == 0x200 ... }"
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'kdebug.tracepoint("sys_enter_futex", function () {
+	var arg = arg2
+        if (arg == 0x100 || arg == 0x200 || arg == 0x300 || arg == 0x400 ||
+            arg == 0x500 || arg == 0x600 || arg == 0x700 || arg == 0x800 ||
+            arg == 0x900 || arg == 0x1000) {
+                printf("%x %x\n", arg1, arg2)
+        }})' &
+
+echo -e '\nktap tracing: kdebug.tracepoint("sys_enter_futex", function (xxx) {})'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'trace probe:SyS_futex uaddr=%di {
+	var arg = arg1
+        if (arg == 0x100 || arg == 0x200 || arg == 0x300 || arg == 0x400 ||
+            arg == 0x500 || arg == 0x600 || arg == 0x700 || arg == 0x800 ||
+            arg == 0x900 || arg == 0x1000) {
+                printf("%x\n", arg1)
+        }}' &
+echo -e '\nktap tracing: trace probe:SyS_futex uaddr=%di {...}'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+
+#------------------------------------------------------------#
+../../ktap -q -e 'kdebug.kprobe("SyS_futex", function () {
+	var uaddr = 1
+        if (uaddr == 0x100 || uaddr == 0x200 || uaddr == 0x300 ||
+	    uaddr == 0x400 || uaddr == 0x500 || uaddr == 0x600 ||
+	    uaddr == 0x700 || uaddr == 0x800 || uaddr == 0x900 ||
+	    uaddr == 0x1000) {
+                printf("%x\n", uaddr)
+	}})' &
+echo -e '\nktap tracing: kdebug.kprobe("SyS_futex", function () {})'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+stap -e 'probe syscall.futex {
+	uaddr = $uaddr
+        if (uaddr == 0x100 || uaddr == 0x200 || uaddr == 0x300 ||
+	    uaddr == 0x400 || uaddr == 0x500 || uaddr == 0x600 ||
+	    uaddr == 0x700 || uaddr == 0x800 || uaddr == 0x900 ||
+	    uaddr == 0x1000) {
+                printf("%x\n", uaddr)
+        }}' &
+
+echo -e "\nstap tracing: probe syscall.futex { if (uaddr == 0x100 || addr == 0x200 ... }"
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof stap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+
+../../ktap -d -q -e 'trace syscalls:sys_enter_futex {
+	var uaddr = arg2
+        if (uaddr == 0x100 || uaddr == 0x200 || uaddr == 0x300 ||
+	    uaddr == 0x400 || uaddr == 0x500 || uaddr == 0x600 ||
+	    uaddr == 0x700 || uaddr == 0x800 || uaddr == 0x900 ||
+	    uaddr == 0x1000) {
+                printf("%x %x\n", arg1, arg2)
+        }}' &
+
+echo -e "\nktap tracing dry-run: trace syscalls:sys_enter_futex { if (arg2 == 0x100 || arg2 == 0x200 ... }"
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+
+#------------------------------------------------------------#
+
+../../ktap -d -q -e 'kdebug.tracepoint("sys_enter_futex", function () {
+	var arg = arg2
+        if (arg == 0x100 || arg == 0x200 || arg == 0x300 || arg == 0x400 ||
+            arg == 0x500 || arg == 0x600 || arg == 0x700 || arg == 0x800 ||
+            arg == 0x900 || arg == 0x1000) {
+                printf("%x %x\n", arg1, arg2)
+        }})' &
+
+echo -e '\nktap tracing dry-run: kdebug.tracepoint("sys_enter_futex", function (xxx) {})'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'trace syscalls:sys_enter_futex /
+	uaddr == 0x100 || uaddr == 0x200 || uaddr == 0x300 || uaddr == 0x400 ||
+	uaddr == 0x500 || uaddr == 0x600 || uaddr == 0x700 || uaddr == 0x800 ||
+	uaddr == 0x900 || uaddr == 0x1000/ {
+		printf("%x %x\n", arg1, arg2)
+	}' &
+
+echo -e "\nktap tracing: trace syscalls:sys_enter_futex /uaddr == 0x100 || uaddr == 0x200 .../ {}"
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+rm -rf ./sembench
+
diff --git a/tools/ktap/test/benchmark/cmp_profile.sh b/tools/ktap/test/benchmark/cmp_profile.sh
new file mode 100644
index 0000000..c400d8d
--- /dev/null
+++ b/tools/ktap/test/benchmark/cmp_profile.sh
@@ -0,0 +1,54 @@
+#!/bin/sh
+
+# This script compare stack profiling performance between ktap and stap.
+#
+# 1. ktap -e 'profile-1000us { s[stack(-1, 12)] += 1 }'
+# 2. stap -e 'probe timer.profile { s[backtrace()] += 1 }'
+# 3. stap -e 'probe timer.profile { s[backtrace()] <<< 1 }'
+
+#Result:
+#Currently the stack profiling overhead is nearly same between ktap and stap.
+#
+#ktap reslove kernel stack to string in runtime, which is very time consuming,
+#optimize it in future.
+
+
+gcc -o sembench sembench.c -O2 -lpthread
+
+COMMAND="./sembench -t 200 -w 20 -r 30 -o 2"
+
+#------------------------------------------------------------#
+
+echo -e "without tracing:"
+$COMMAND; $COMMAND; $COMMAND
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'var s = table.new(0, 20000) profile-1000us { s[stack(-1, 12)] += 1 }' &
+
+echo -e "\nktap tracing: profile-1000us { s[stack(-1, 12)] += 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+stap -o /dev/null -e 'global s[20000]; probe timer.profile { s[backtrace()] += 1 }' &
+
+echo -e "\nstap tracing: probe timer.profile { s[backtrace()] += 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pkill stap
+
+#------------------------------------------------------------#
+
+stap -o /dev/null -e 'global s[20000]; probe timer.profile { s[backtrace()] <<< 1 }' &
+
+echo -e "\nstap tracing: probe timer.profile { s[backtrace()] <<< 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pkill stap
+
+#------------------------------------------------------------#
+
+
+rm -rf ./sembench
+
diff --git a/tools/ktap/test/benchmark/cmp_table.sh b/tools/ktap/test/benchmark/cmp_table.sh
new file mode 100644
index 0000000..6e3f12f
--- /dev/null
+++ b/tools/ktap/test/benchmark/cmp_table.sh
@@ -0,0 +1,112 @@
+#!/bin/sh
+
+# This script compare table performance between ktap and stap.
+#
+# 1. ktap -e 'trace syscalls:sys_enter_futex { s[execname] += 1 }'
+# 2. ktap -e 'kdebug.tracepoint("sys_enter_futex", function () { s[execname] += 1 })'
+# 3. ktap -e 'kdebug.kprobe("SyS_futex", function () { s[execname] += 1 })'
+# 4. stap -e 'probe syscall.futex { s[execname()] += 1 }'
+# 5. ktap -e 'kdebug.kprobe("SyS_futex", function () { s[probename] += 1 })'
+# 6. stap -e 'probe syscall.futex { s[name] += 1 }'
+# 7. ktap -e 'kdebug.kprobe("SyS_futex", function () { s["constant_string_key"] += 1 })'
+# 8. stap -e 'probe syscall.futex { s["constant_string_key"] += 1 }'
+
+#Result:
+#Currently ktap table operation overhead is smaller than stap.
+
+
+gcc -o sembench sembench.c -O2 -lpthread
+
+COMMAND="./sembench -t 200 -w 20 -r 30 -o 2"
+
+#------------------------------------------------------------#
+
+echo -e "without tracing:"
+$COMMAND; $COMMAND; $COMMAND
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'var s = {} trace syscalls:sys_enter_futex { s[execname] += 1 }' &
+
+echo -e "\nktap tracing: trace syscalls:sys_enter_futex { s[execname] += 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'var s = {} kdebug.tracepoint("sys_enter_futex", function () {
+	s[execname] += 1 })' &
+
+echo -e '\nktap tracing: kdebug.tracepoint("sys_enter_futex", function () { s[execname] += 1})'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'var s = {} kdebug.kprobe("SyS_futex", function () {
+	s[execname] += 1 })' &
+
+echo -e '\nktap tracing: kdebug.kprobe("SyS_futex", function () { s[execname] += 1 })'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+stap -e 'global s; probe syscall.futex { s[execname()] += 1 }' &
+
+echo -e "\nstap tracing: probe syscall.futex { s[execname()] += 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pkill stap
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'var s = {} kdebug.kprobe("SyS_futex", function () {
+	s[probename] += 1 })' &
+
+echo -e '\nktap tracing: kdebug.kprobe("SyS_futex", function () { s[probename] += 1 })'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+stap -e 'global s; probe syscall.futex { s[name] += 1 }' &
+
+echo -e "\nstap tracing: probe syscall.futex { s[name] += 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pkill stap
+
+#------------------------------------------------------------#
+
+../../ktap -q -e 'var s = {} s["const_string_key"] = 0 kdebug.kprobe("SyS_futex", function () {
+	s["const_string_key"] += 1 })' &
+
+echo -e '\nktap tracing: kdebug.kprobe("SyS_futex", function () { s["const_string_key"] += 1 })'
+$COMMAND; $COMMAND; $COMMAND
+pid=`pidof ktap`
+disown $pid; kill -9 $pid; sleep 1
+
+#------------------------------------------------------------#
+
+stap -e 'global s; probe syscall.futex { s["const_string_key"] += 1 }' &
+
+echo -e "\nstap tracing: probe syscall.futex { s["const_string_key"] += 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pkill stap
+
+#------------------------------------------------------------#
+
+stap -o /dev/null -e 'global s; probe syscall.futex { s["const_string_key"] <<< 1 }' &
+
+echo -e "\nstap tracing: probe syscall.futex { s["const_string_key"] <<< 1 }"
+$COMMAND; $COMMAND; $COMMAND
+pkill stap
+
+#------------------------------------------------------------#
+
+
+rm -rf ./sembench
+
diff --git a/tools/ktap/test/benchmark/sembench.c b/tools/ktap/test/benchmark/sembench.c
new file mode 100644
index 0000000..5dfccd5
--- /dev/null
+++ b/tools/ktap/test/benchmark/sembench.c
@@ -0,0 +1,556 @@
+/*
+ * copyright Oracle 2007.  Licensed under GPLv2
+ * To compile: gcc -Wall -o sembench sembench.c -lpthread
+ *
+ * usage: sembench -t thread count -w wakenum -r runtime -o op
+ * op can be: 0 (ipc sem) 1 (nanosleep) 2 (futexes)
+ *
+ * example:
+ *	sembench -t 1024 -w 512 -r 60 -o 2
+ * runs 1024 threads, waking up 512 at a time, running for 60 seconds using
+ * futex locking.
+ *
+ */
+#define  _GNU_SOURCE
+#define _POSIX_C_SOURCE 199309
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/sem.h>
+#include <sys/ipc.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <pthread.h>
+#include <unistd.h>
+#include <string.h>
+#include <time.h>
+#include <sys/time.h>
+#include <sys/syscall.h>
+#include <errno.h>
+
+#define VERSION "0.2"
+
+/* futexes have been around since 2.5.something, but it still seems I
+ * need to make my own syscall.  Sigh.
+ */
+#define FUTEX_WAIT              0
+#define FUTEX_WAKE              1
+#define FUTEX_FD                2
+#define FUTEX_REQUEUE           3
+#define FUTEX_CMP_REQUEUE       4
+#define FUTEX_WAKE_OP           5
+static inline int futex (int *uaddr, int op, int val,
+			 const struct timespec *timeout,
+			 int *uaddr2, int val3)
+{
+	return syscall(__NR_futex, uaddr, op, val, timeout, uaddr2, val3);
+}
+
+static void smp_mb(void)
+{
+	__sync_synchronize();
+}
+
+static int all_done = 0;
+static int timeout_test = 0;
+
+#define SEMS_PERID 250
+
+struct sem_operations;
+
+struct lockinfo {
+	unsigned long id;
+	unsigned long index;
+	int data;
+	pthread_t tid;
+	struct lockinfo *next;
+	struct sem_operations *ops;
+	unsigned long ready;
+};
+
+struct sem_wakeup_info {
+	int wakeup_count;
+	struct sembuf sb[SEMS_PERID];
+};
+
+struct sem_operations {
+	void (*wait)(struct lockinfo *l);
+	int (*wake)(struct sem_wakeup_info *wi, int num_semids, int num);
+	void (*setup)(struct sem_wakeup_info **wi, int num_semids);
+	void (*cleanup)(int num_semids);
+	char *name;
+};
+
+int *semid_lookup = NULL;
+
+pthread_mutex_t worklist_mutex = PTHREAD_MUTEX_INITIALIZER;
+static unsigned long total_burns = 0;
+static unsigned long min_burns = ~0UL;
+static unsigned long max_burns = 0;
+
+/* currently running threads */
+static int thread_count = 0;
+
+struct lockinfo *worklist = NULL;
+static int workers_started = 0;
+
+/* total threads started */
+static int num_threads = 2048;
+
+static void worklist_add(struct lockinfo *l)
+{
+	smp_mb();
+	l->ready = 1;
+}
+
+static struct lockinfo *worklist_rm(void)
+{
+	static int last_index = 0;
+	int i;
+	struct lockinfo *l;
+
+	for (i = 0; i < num_threads; i++) {
+		int test = (last_index + i) % num_threads;
+
+		l = worklist + test;
+		smp_mb();
+		if (l->ready) {
+			l->ready = 0;
+			last_index = test;
+			return l;
+		}
+	}
+	return NULL;
+}
+
+/* ipc semaphore post& wait */
+void wait_ipc_sem(struct lockinfo *l)
+{
+	struct sembuf sb;
+	int ret;
+	struct timespec *tvp = NULL;
+	struct timespec tv = { 0, 1 };
+
+	sb.sem_num = l->index;
+	sb.sem_flg = 0;
+
+	sb.sem_op = -1;
+	l->data = 1;
+
+	if (timeout_test && (l->id % 5) == 0)
+		tvp = &tv;
+
+	worklist_add(l);
+	ret = semtimedop(semid_lookup[l->id], &sb, 1, tvp);
+
+	while(l->data != 0 && tvp) {
+		struct timespec tv2 = { 0, 500 };
+		nanosleep(&tv2, NULL);
+	}
+
+	if (l->data != 0) {
+		if (tvp)
+			return;
+		fprintf(stderr, "wakeup without data update\n");
+		exit(1);
+	}
+	if (ret) {
+		if (errno == EAGAIN && tvp)
+			return;
+		perror("semtimed op");
+		exit(1);
+	}
+}
+
+int ipc_wake_some(struct sem_wakeup_info *wi, int num_semids, int num)
+{
+	int i;
+	int ret;
+	struct lockinfo *l;
+	int found = 0;
+
+	for (i = 0; i < num_semids; i++) {
+		wi[i].wakeup_count = 0;
+	}
+	while(num > 0) {
+		struct sembuf *sb;
+		l = worklist_rm();
+		if (!l)
+			break;
+		if (l->data != 1)
+			fprintf(stderr, "warning, lockinfo data was %d\n",
+				l->data);
+		l->data = 0;
+		sb = wi[l->id].sb + wi[l->id].wakeup_count;
+		sb->sem_num = l->index;
+		sb->sem_op = 1;
+		sb->sem_flg = IPC_NOWAIT;
+		wi[l->id].wakeup_count++;
+		found++;
+		num--;
+	}
+	if (!found)
+		return 0;
+	for (i = 0; i < num_semids; i++) {
+		int wakeup_total;
+		int cur;
+		int offset = 0;
+		if (!wi[i].wakeup_count)
+			continue;
+		wakeup_total = wi[i].wakeup_count;
+		while(wakeup_total > 0) {
+			cur = wakeup_total > 64 ? 64 : wakeup_total;
+			ret = semtimedop(semid_lookup[i], wi[i].sb + offset,
+					 cur, NULL);
+			if (ret) {
+				perror("semtimedop");
+				exit(1);
+			}
+			offset += cur;
+			wakeup_total -= cur;
+		}
+	}
+	return found;
+}
+
+void setup_ipc_sems(struct sem_wakeup_info **wi, int num_semids)
+{
+	int i;
+	*wi = malloc(sizeof(**wi) * num_semids);
+	semid_lookup = malloc(num_semids * sizeof(int));
+	for(i = 0; i < num_semids; i++) {
+		semid_lookup[i] = semget(IPC_PRIVATE, SEMS_PERID,
+					 IPC_CREAT | 0777);
+		if (semid_lookup[i] < 0) {
+			perror("semget");
+			exit(1);
+		}
+	}
+	sleep(10);
+}
+
+void cleanup_ipc_sems(int num)
+{
+	int i;
+	for (i = 0; i < num; i++) {
+		semctl(semid_lookup[i], 0, IPC_RMID);
+	}
+}
+
+struct sem_operations ipc_sem_ops = {
+	.wait = wait_ipc_sem,
+	.wake = ipc_wake_some,
+	.setup = setup_ipc_sems,
+	.cleanup = cleanup_ipc_sems,
+	.name = "ipc sem operations",
+};
+
+/* futex post & wait */
+void wait_futex_sem(struct lockinfo *l)
+{
+	int ret;
+	l->data = 1;
+	worklist_add(l);
+	while(l->data == 1) {
+		ret = futex(&l->data, FUTEX_WAIT, 1, NULL, NULL, 0);
+		/*
+		if (ret && ret != EWOULDBLOCK) {
+			perror("futex wait");
+			exit(1);
+		}*/
+	}
+}
+
+int futex_wake_some(struct sem_wakeup_info *wi, int num_semids, int num)
+{
+	int i;
+	int ret;
+	struct lockinfo *l;
+	int found = 0;
+
+	for (i = 0; i < num; i++) {
+		l = worklist_rm();
+		if (!l)
+			break;
+		if (l->data != 1)
+			fprintf(stderr, "warning, lockinfo data was %d\n",
+				l->data);
+		l->data = 0;
+		ret = futex(&l->data, FUTEX_WAKE, 1, NULL, NULL, 0);
+		if (ret < 0) {
+			perror("futex wake");
+			exit(1);
+		}
+		found++;
+	}
+	return found;
+}
+
+void setup_futex_sems(struct sem_wakeup_info **wi, int num_semids)
+{
+	return;
+}
+
+void cleanup_futex_sems(int num)
+{
+	return;
+}
+
+struct sem_operations futex_sem_ops = {
+	.wait = wait_futex_sem,
+	.wake = futex_wake_some,
+	.setup = setup_futex_sems,
+	.cleanup = cleanup_futex_sems,
+	.name = "futex sem operations",
+};
+
+/* nanosleep sems here */
+void wait_nanosleep_sem(struct lockinfo *l)
+{
+	int ret;
+	struct timespec tv = { 0, 1000000 };
+	int count = 0;
+
+	l->data = 1;
+	worklist_add(l);
+	while(l->data) {
+		ret = nanosleep(&tv, NULL);
+		if (ret) {
+			perror("nanosleep");
+			exit(1);
+		}
+		count++;
+	}
+}
+
+int nanosleep_wake_some(struct sem_wakeup_info *wi, int num_semids, int num)
+{
+	int i;
+	struct lockinfo *l;
+
+	for (i = 0; i < num; i++) {
+		l = worklist_rm();
+		if (!l)
+			break;
+		if (l->data != 1)
+			fprintf(stderr, "warning, lockinfo data was %d\n",
+				l->data);
+		l->data = 0;
+	}
+	return i;
+}
+
+void setup_nanosleep_sems(struct sem_wakeup_info **wi, int num_semids)
+{
+	return;
+}
+
+void cleanup_nanosleep_sems(int num)
+{
+	return;
+}
+
+struct sem_operations nanosleep_sem_ops = {
+	.wait = wait_nanosleep_sem,
+	.wake = nanosleep_wake_some,
+	.setup = setup_nanosleep_sems,
+	.cleanup = cleanup_nanosleep_sems,
+	.name = "nano sleep sem operations",
+};
+
+void *worker(void *arg)
+{
+	struct lockinfo *l = (struct lockinfo *)arg;
+	int burn_count = 0;
+	pthread_t tid = pthread_self();
+	size_t pagesize = getpagesize();
+	char *buf = malloc(pagesize);
+
+	if (!buf) {
+		perror("malloc");
+		exit(1);
+	}
+
+	l->tid = tid;
+	workers_started = 1;
+	smp_mb();
+
+	while(!all_done) {
+		l->ops->wait(l);
+		if (all_done)
+			break;
+		burn_count++;
+	}
+	pthread_mutex_lock(&worklist_mutex);
+	total_burns += burn_count;
+	if (burn_count < min_burns)
+		min_burns = burn_count;
+	if (burn_count > max_burns)
+		max_burns = burn_count;
+	thread_count--;
+	pthread_mutex_unlock(&worklist_mutex);
+	return (void *)0;
+}
+
+void print_usage(void)
+{
+	printf("usage: sembench [-t threads] [-w wake incr] [-r runtime]");
+	printf("                [-o num] (0=ipc, 1=nanosleep, 2=futex)\n");
+	exit(1);
+}
+
+#define NUM_OPERATIONS 3
+struct sem_operations *allops[NUM_OPERATIONS] = { &ipc_sem_ops,
+						&nanosleep_sem_ops,
+						&futex_sem_ops};
+
+int main(int ac, char **av) {
+	int ret;
+	int i;
+	int semid = 0;
+	int sem_num = 0;
+	int burn_count = 0;
+	struct sem_wakeup_info *wi = NULL;
+	struct timeval start;
+	struct timeval now;
+	int num_semids = 0;
+	int wake_num = 256;
+	int run_secs = 30;
+	int pagesize = getpagesize();
+	char *buf = malloc(pagesize);
+	struct sem_operations *ops = allops[0];
+	cpu_set_t cpu_mask;
+	cpu_set_t target_mask;
+	int target_cpu = 0;
+	int max_cpu = -1;
+
+	if (!buf) {
+		perror("malloc");
+		exit(1);
+	}
+	for (i = 1; i < ac; i++) {
+		if (strcmp(av[i], "-t") == 0) {
+			if (i == ac -1)
+				print_usage();
+			num_threads = atoi(av[i+1]);
+			i++;
+		} else if (strcmp(av[i], "-w") == 0) {
+			if (i == ac -1)
+				print_usage();
+			wake_num = atoi(av[i+1]);
+			i++;
+		} else if (strcmp(av[i], "-r") == 0) {
+			if (i == ac -1)
+				print_usage();
+			run_secs = atoi(av[i+1]);
+			i++;
+		} else if (strcmp(av[i], "-o") == 0) {
+			int index;
+			if (i == ac -1)
+				print_usage();
+			index = atoi(av[i+1]);
+			if (index >= NUM_OPERATIONS) {
+				fprintf(stderr, "invalid operations %d\n",
+					index);
+				exit(1);
+			}
+			ops = allops[index];
+			i++;
+		} else if (strcmp(av[i], "-T") == 0) {
+			timeout_test = 1;
+		} else if (strcmp(av[i], "-h") == 0) {
+			print_usage();
+		}
+	}
+	num_semids = (num_threads + SEMS_PERID - 1) / SEMS_PERID;
+	ops->setup(&wi, num_semids);
+
+	ret = sched_getaffinity(0, sizeof(cpu_set_t), &cpu_mask);
+	if (ret) {
+		perror("sched_getaffinity");
+		exit(1);
+	}
+	for (i = 0; i < CPU_SETSIZE; i++)
+		if (CPU_ISSET(i, &cpu_mask))
+			max_cpu = i;
+	if (max_cpu == -1) {
+		fprintf(stderr, "sched_getaffinity returned empty mask\n");
+		exit(1);
+	}
+
+	CPU_ZERO(&target_mask);
+
+	worklist = malloc(sizeof(*worklist) * num_threads);
+	memset(worklist, 0, sizeof(*worklist) * num_threads);
+
+	for (i = 0; i < num_threads; i++) {
+		struct lockinfo *l;
+		pthread_t tid;
+		thread_count++;
+		l = worklist + i;
+		if (!l) {
+			perror("malloc");
+			exit(1);
+		}
+		l->id = semid;
+		l->index = sem_num++;
+		l->ops = ops;
+		if (sem_num >= SEMS_PERID) {
+			semid++;
+			sem_num = 0;
+		}
+		ret = pthread_create(&tid, NULL, worker, (void *)l);
+		if (ret) {
+			perror("pthread_create");
+			exit(1);
+		}
+
+		while (!CPU_ISSET(target_cpu, &cpu_mask)) {
+			target_cpu++;
+			if (target_cpu > max_cpu)
+				target_cpu = 0;
+		}
+		CPU_SET(target_cpu, &target_mask);
+		ret = pthread_setaffinity_np(tid, sizeof(cpu_set_t),
+					     &target_mask);
+		CPU_CLR(target_cpu, &target_mask);
+		target_cpu++;
+
+		ret = pthread_detach(tid);
+		if (ret) {
+			perror("pthread_detach");
+			exit(1);
+		}
+	}
+	while(!workers_started) {
+		smp_mb();
+		usleep(200);
+	}
+	gettimeofday(&start, NULL);
+	//fprintf(stderr, "main loop going\n");
+	while(1) {
+		ops->wake(wi, num_semids, wake_num);
+		burn_count++;
+		gettimeofday(&now, NULL);
+		if (now.tv_sec - start.tv_sec >= run_secs)
+			break;
+	}
+	//fprintf(stderr, "all done\n");
+	all_done = 1;
+	while(thread_count > 0) {
+		ops->wake(wi, num_semids, wake_num);
+		usleep(200);
+	}
+	//printf("%d threads, waking %d at a time\n", num_threads, wake_num);
+	//printf("using %s\n", ops->name);
+	//printf("main thread burns: %d\n", burn_count);
+	//printf("worker burn count total %lu min %lu max %lu avg %lu\n",
+	//       total_burns, min_burns, max_burns, total_burns / num_threads);
+	printf("%d seconds: %lu worker burns per second\n",
+		(int)(now.tv_sec - start.tv_sec),
+		total_burns / (now.tv_sec - start.tv_sec));
+	ops->cleanup(num_semids);
+	return 0;
+}
+
diff --git a/tools/ktap/test/cli-arg.t b/tools/ktap/test/cli-arg.t
new file mode 100644
index 0000000..4bf3f6c
--- /dev/null
+++ b/tools/ktap/test/cli-arg.t
@@ -0,0 +1,25 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: sanity
+--- args: 1 testing "2 3 4"
+--- src
+printf("arg 0: %s\n", arg[0])
+printf("arg 1: %d\n", arg[1])
+printf("arg 2: %s\n", arg[2])
+printf("arg 3: %s\n", arg[2])
+
+--- out_like chop
+^arg 0: /tmp/\S+\.kp
+arg 1: 1
+arg 2: testing
+arg 3: testing$
+
+--- err
+
diff --git a/tools/ktap/test/concat.t b/tools/ktap/test/concat.t
new file mode 100644
index 0000000..12e33ee
--- /dev/null
+++ b/tools/ktap/test/concat.t
@@ -0,0 +1,21 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: string concat
+--- src
+var a = "123"
+var b = "456"
+
+print(a..b)
+
+--- out
+123456
+--- err
+
+
diff --git a/tools/ktap/test/count.t b/tools/ktap/test/count.t
new file mode 100644
index 0000000..972bf86
--- /dev/null
+++ b/tools/ktap/test/count.t
@@ -0,0 +1,25 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: count
+--- src
+var t = {}
+
+t["key"] += 1
+print(t["key"])
+
+t["key"] += 1
+print(t["key"])
+
+--- out
+1
+2
+--- err
+
+
diff --git a/tools/ktap/test/deadloop.t b/tools/ktap/test/deadloop.t
new file mode 100644
index 0000000..3fc4f97
--- /dev/null
+++ b/tools/ktap/test/deadloop.t
@@ -0,0 +1,37 @@
+# vi: ft= et ts=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: exit dead loop
+--- src
+tick-1s {
+	exit()
+}
+
+tick-3s {
+	print("dead loop not exited")
+}
+
+while (1) {}
+
+--- out_like
+error: loop execute count exceed max limit(.*)
+--- err
+
+
+
+=== TEST 2: dead loop killed by signal
+--- src
+
+while (1) {}
+
+--- out_like
+error: loop execute count exceed max limit(.*)
+
+--- err
+
diff --git a/tools/ktap/test/fibonacci.t b/tools/ktap/test/fibonacci.t
new file mode 100644
index 0000000..f92d244
--- /dev/null
+++ b/tools/ktap/test/fibonacci.t
@@ -0,0 +1,42 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: regular recursive fibonacci
+--- src
+function fib(n) {
+	if (n < 2) {
+		return n
+	}
+	return fib(n-1) + fib(n-2)
+}
+
+print(fib(20))
+--- out
+6765
+--- err
+
+
+
+=== TEST 2: tail recursive fibonacci
+--- src
+function fib(n) {
+	function f(iter, res, next) {
+		if (iter == 0) {
+			return res;
+		}
+		return f(iter-1, next, res+next)
+	}
+	return f(n, 0, 1)
+}
+
+print(fib(20))
+--- out
+6765
+--- err
+
diff --git a/tools/ktap/test/function.t b/tools/ktap/test/function.t
new file mode 100644
index 0000000..cd44ccb
--- /dev/null
+++ b/tools/ktap/test/function.t
@@ -0,0 +1,78 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: function
+--- src
+### basic function call ###
+function f1(a, b) {
+	return a + b
+}
+
+print(f1(2, 3))
+
+### return string ###
+function f2() {
+	return "function return"
+}
+
+print(f2())
+
+### closure testing ### 
+function f4() {
+	var f5 = function(a, b) {
+		return a * b
+	}
+	return f5
+}
+
+var f = f4()
+print(f(9, 9))
+
+### closure with lexcial variable ### 
+var i = 1
+function f6() {
+	i = 5
+	var f7 = function(a, b) {
+		return a * b + i
+	}
+	return f7
+}
+
+f = f6()
+print(f(9, 9))
+
+i = 6
+print(f(9, 9))
+
+### tail call
+### stack should not overflow in tail call mechanism
+var a = 0
+function f8(i) {
+	if (i == 1000000) {
+		a = 1000000
+		return
+	}
+	# must add return here, otherwise stack overflow
+	return f8(i+1)
+}
+
+f8(0)
+print(a)
+
+--- out
+5
+function return
+81
+86
+87
+1000000
+
+--- err
+
+
diff --git a/tools/ktap/test/if.t b/tools/ktap/test/if.t
new file mode 100644
index 0000000..05989f2
--- /dev/null
+++ b/tools/ktap/test/if.t
@@ -0,0 +1,32 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: test if
+--- src
+
+if (false) {
+	print("failed")
+}
+
+if (nil) {
+	print("failed")
+}
+
+# ktap only think false and nil is "real false", number 0 is true
+# it's same as lua
+# Might change it in future, to make similar with C
+if (0) {
+	print("number 0 is true")
+}
+
+--- out
+number 0 is true
+--- err
+
+
diff --git a/tools/ktap/test/kprobe.t b/tools/ktap/test/kprobe.t
new file mode 100644
index 0000000..4ea342e
--- /dev/null
+++ b/tools/ktap/test/kprobe.t
@@ -0,0 +1,82 @@
+# vi: ft= et ts=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: kprobe
+--- opts: -q
+--- src
+
+var n = 0
+trace probe:schedule {
+	n = n + 1
+}
+
+# share same event id with previous one
+trace probe:schedule {
+}
+
+# test event filter
+trace probe:do_sys_open dfd=%di filename=%si flags=%dx mode=%cx /dfd==1/ { }
+
+tick-1s {
+	print(n==0)
+	exit()
+}
+--- out
+false
+--- err
+
+
+
+=== TEST 2: kretprobe
+--- opts: -q
+--- src
+var n = 0
+trace probe:__schedule%return {
+	n = n + 1
+}
+
+tick-1s {
+	print(n==0)
+	exit()
+}
+
+--- out
+false
+--- err
+
+
+=== TEST 3: only can be called in mainthread
+--- opts: -q
+--- src
+
+trace probe:schedule {
+	trace *:* {
+	}
+}
+
+--- out
+error: only mainthread can create function
+--- err
+
+
+=== TEST 4: can not be called in trace_end context
+--- opts: -q
+--- src
+
+trace_end {
+	trace *:* {
+	}
+}
+
+--- out
+error: kdebug.trace_by_id only can be called in RUNNING state
+--- err
+
+
+
diff --git a/tools/ktap/test/kretprobe.t b/tools/ktap/test/kretprobe.t
new file mode 100644
index 0000000..2ee76ec
--- /dev/null
+++ b/tools/ktap/test/kretprobe.t
@@ -0,0 +1,35 @@
+# vi: ft= et ts=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: kprobe
+--- opts: -q
+--- src
+
+var n = 0
+trace probe:schedule {
+	n = n + 1
+}
+
+# share same event id with previous one
+trace probe:schedule {
+}
+
+# test event filter
+trace probe:do_sys_open dfd=%di filename=%si flags=%dx mode=%cx /dfd==1/ { }
+
+tick-1s {
+	print(n==0)
+	exit()
+}
+
+--- out
+false
+--- err
+
+
diff --git a/tools/ktap/test/len.t b/tools/ktap/test/len.t
new file mode 100644
index 0000000..9de5253
--- /dev/null
+++ b/tools/ktap/test/len.t
@@ -0,0 +1,27 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: len
+--- src
+var a = "123456789"
+
+print(len(a))
+
+var b = {}
+b[0] = 0
+b[1] = 1
+b["keys"] = "values"
+
+print(len(b))
+
+--- out
+9
+3
+--- err
+
diff --git a/tools/ktap/test/lib/Test/ktap.pm b/tools/ktap/test/lib/Test/ktap.pm
new file mode 100644
index 0000000..94c551f
--- /dev/null
+++ b/tools/ktap/test/lib/Test/ktap.pm
@@ -0,0 +1,128 @@
+# Copyright (C) Yichun Zhang (agentzh)
+
+package Test::ktap;
+
+use Test::Base -Base;
+use POSIX ();
+use IPC::Run ();
+
+our @EXPORT = qw( run_tests );
+
+sub run_tests () {
+    for my $block (Test::Base::blocks()) {
+        run_test($block);
+    }
+}
+
+sub bail_out (@) {
+    Test::More::BAIL_OUT(@_);
+}
+
+sub parse_cmd ($) {
+    my $cmd = shift;
+    my @cmd;
+    while (1) {
+        if ($cmd =~ /\G\s*"(.*?)"/gmsc) {
+            push @cmd, $1;
+
+        } elsif ($cmd =~ /\G\s*'(.*?)'/gmsc) {
+            push @cmd, $1;
+
+        } elsif ($cmd =~ /\G\s*(\S+)/gmsc) {
+            push @cmd, $1;
+
+        } else {
+            last;
+        }
+    }
+    return @cmd;
+}
+
+sub run_test ($) {
+    my $block = shift;
+    my $name = $block->name;
+
+    my $timeout = $block->timeout() || 10;
+    my $opts = $block->opts;
+    my $args = $block->args;
+
+    my $cmd = "./ktap";
+
+    if (defined $opts) {
+        $cmd .= " $opts";
+    }
+
+    my $kpfile;
+    if (defined $block->src) {
+        $kpfile = POSIX::tmpnam() . ".kp";
+        open my $out, ">$kpfile" or
+            bail_out("cannot open $kpfile for writing: $!");
+        print $out ($block->src);
+        close $out;
+        $cmd .= " $kpfile"
+    }
+
+    if (defined $args) {
+        $cmd .= " $args";
+    }
+
+    #warn "CMD: $cmd\n";
+
+    my @cmd = parse_cmd($cmd);
+
+    my ($out, $err);
+
+    eval {
+        IPC::Run::run(\@cmd, \undef, \$out, \$err,
+                      IPC::Run::timeout($timeout));
+    };
+    if ($@) {
+        # timed out
+        if ($@ =~ /timeout/) {
+            if (!defined $block->expect_timeout) {
+                fail("$name: ktap process timed out");
+            }
+	} else {
+            fail("$name: failed to run command [$cmd]: $@");
+        }
+    }
+
+    my $ret = ($? >> 8);
+
+    if (defined $kpfile) {
+        unlink $kpfile;
+    }
+
+    if (defined $block->out) {
+        is $out, $block->out, "$name - stdout eq okay";
+    }
+
+    my $regex = $block->out_like;
+    if (defined $regex) {
+        if (!ref $regex) {
+            $regex = qr/$regex/ms;
+        }
+        like $out, $regex, "$name - stdout like okay";
+    }
+
+    if (defined $block->err) {
+        is $err, $block->err, "$name - stderr eq okay";
+    }
+
+    $regex = $block->err_like;
+    if (defined $regex) {
+        if (!ref $regex) {
+            $regex = qr/$regex/ms;
+        }
+        like $err, $regex, "$name - stderr like okay";
+    }
+
+    my $exp_ret = $block->ret;
+    if (!defined $exp_ret) {
+        $exp_ret = 0;
+    }
+    is $ret, $exp_ret, "$name - exit code okay";
+}
+
+1;
+# vi: et
diff --git a/tools/ktap/test/looping.t b/tools/ktap/test/looping.t
new file mode 100644
index 0000000..3f61118
--- /dev/null
+++ b/tools/ktap/test/looping.t
@@ -0,0 +1,46 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: looping
+--- src
+
+### basic while-loop testing
+var a = 1
+while (a < 1000) {
+	a = a + 1
+}
+
+print(a)
+
+### break testing
+### Note that ktap don't have continue keyword
+var a = 1
+while (a < 1000) {
+	if (a == 10) {
+		break
+	}
+	a = a + 1
+}
+
+print(a)
+
+### for-loop testing
+var b = 0
+for (c = 0, 1000, 1) {
+	b = b + 1
+}
+
+print(b)
+
+--- out
+1000
+10
+1001
+--- err
+
diff --git a/tools/ktap/test/one-liner.t b/tools/ktap/test/one-liner.t
new file mode 100644
index 0000000..9998b1a
--- /dev/null
+++ b/tools/ktap/test/one-liner.t
@@ -0,0 +1,48 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: print
+--- args: -e 'print("one-liner testing")'
+--- out
+one-liner testing
+--- err
+
+
+
+=== TEST 2: exit
+--- args: -e 'exit() print("failed")'
+--- out
+--- err
+
+
+
+=== TEST 3: syscalls in "ls"
+--- args: -e 'trace syscalls:* { print(argstr) }' -- ls
+--- out_like
+sys_mprotect -> 0x0
+.*?
+sys_close\(fd: \d+\)
+--- err
+
+
+
+=== TEST 4: trace ktap syscalls
+--- args: -e 'trace syscalls:* { print(argstr) }' -- ./ktap -e 'print("trace ktap by self")'
+--- out_like
+sys_mprotect -> 0x0
+.*?
+sys_close\(fd: \d+\)
+--- err
+
+=== TEST 5: trace ktap function calls
+--- args: -q -e 'trace probe:kp_* {print(argstr)}' -- ./ktap samples/helloworld.kp
+--- out_like
+kp_vm_new_state: (.*)
+.*?
+
diff --git a/tools/ktap/test/pairs.t b/tools/ktap/test/pairs.t
new file mode 100644
index 0000000..bcf57cf
--- /dev/null
+++ b/tools/ktap/test/pairs.t
@@ -0,0 +1,52 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: looping
+--- src
+
+var t = {}
+t[1] = 101
+t[2] = 102
+t[3] = 103
+t["key_1"] = "value_1"
+t["key_2"] = "value_2"
+t["key_3"] = "value_3"
+
+var n = 0
+
+for (k, v in pairs(t)) {
+	n = n + 1
+
+	if (k == 1 && v != 101) {
+		print("failed")
+	}
+	if (k == 2 && v != 102) {
+		print("failed")
+	}
+	if (k == 3 && v != 103) {
+		print("failed")
+	}
+	if (k == "key_1" && v != "value_1") {
+		print("failed")
+	}
+	if (k == "key_2" && v != "value_2") {
+		print("failed")
+	}
+	if (k == "key_3" && v != "value_3") {
+		print("failed")
+	}
+}
+
+if (n != len(t)) {
+	print("failed")
+}
+
+--- out
+--- err
+
diff --git a/tools/ktap/test/stack_overflow.t b/tools/ktap/test/stack_overflow.t
new file mode 100644
index 0000000..702d389
--- /dev/null
+++ b/tools/ktap/test/stack_overflow.t
@@ -0,0 +1,22 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: stack overflow
+--- src
+function f(a) {
+	        return 1 + f(a+1)
+}
+
+print(f(0))
+
+--- out_like
+(.*)stack overflow(.*)
+--- err
+
+
diff --git a/tools/ktap/test/syntax-err.t b/tools/ktap/test/syntax-err.t
new file mode 100644
index 0000000..b400c2f
--- /dev/null
+++ b/tools/ktap/test/syntax-err.t
@@ -0,0 +1,19 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: bad assignment (unexpected eof)
+--- src
+a =
+
+--- out
+--- err_like
+unexpected symbol near '<eof>'
+
+--- ret: 255
+
diff --git a/tools/ktap/test/table.t b/tools/ktap/test/table.t
new file mode 100644
index 0000000..f7c52d8
--- /dev/null
+++ b/tools/ktap/test/table.t
@@ -0,0 +1,81 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: table
+--- src
+
+### table testing ###
+var x = {}
+x[1] = "1"
+if (x[1] != "1") {
+	print("failed")
+}
+
+x[1] = 22222222222222222222222222222222222222222
+if (x[1] != 22222222222222222222222222222222222222222) {
+	print("failed")
+}
+
+x[1] = "jovi"
+if (x[1] != "jovi") {
+	print("failed")
+}
+
+x[11111111111111111111111111111111] = "jovi"
+if (x[11111111111111111111111111111111] != "jovi") {
+	print("failed")
+}
+
+x["jovi"] = 1
+if (x["jovi"] != 1) {
+	print("failed")
+}
+
+x["long string....................................."] = 1
+if (x["long string....................................."] != 1) {
+	print("failed")
+}
+
+# issue: subx must declare firstly, otherwise kernel will oops
+var subx = {}
+subx["test"] = "this is test"
+x["test"] = subx
+if (x["test"]["test"] != "this is test") {
+	print("failed")
+}
+
+var tbl = table.new(9999, 0)
+var i = 1
+while (i < 10000) {
+	tbl[i] = i	
+	i = i + 1
+}
+
+var i = 1
+while (i < 10000) {
+	if (tbl[i] != i) {
+		print("failed")
+	}
+	i = i + 1
+}
+
+#### table initization
+var days = {"Sunday", "Monday", "Tuesday", "Wednesday",
+		"Thursday", "Friday", "Saturday"}
+
+if (days[2] != "Monday") {
+	print("failed")
+}
+
+
+--- out
+--- err
+
+
+
diff --git a/tools/ktap/test/time.t b/tools/ktap/test/time.t
new file mode 100644
index 0000000..eb1d5fe
--- /dev/null
+++ b/tools/ktap/test/time.t
@@ -0,0 +1,59 @@
+# vi: ft= ts=4 sw=4 et
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+our $SecPattern = time();
+$SecPattern =~ s{(\d)\d$}{ my $a = $1; my $b = $a + 1; "[$a$b]\\d" }e;
+
+#warn $SecPattern;
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: gettimeofday_s
+--- src
+var begin = gettimeofday_s()
+printf("sec: %d\n", begin)
+printf("elapsed: %d\n", begin - gettimeofday_s())
+
+--- out_like eval
+qr/^sec: $::SecPattern
+elapsed: 0$/
+
+--- err
+
+
+
+=== TEST 2: gettimeofday_ms
+--- src
+printf("%d\n", gettimeofday_ms())
+
+--- out_like eval
+qr/^$::SecPattern\d{3}$/
+
+--- err
+
+
+
+=== TEST 3: gettimeofday_us
+--- src
+printf("%d", gettimeofday_us())
+
+--- out_like eval
+qr/^$::SecPattern\d{6}$/
+
+--- err
+
+
+
+=== TEST 4: gettimeofday_ns
+--- src
+printf("%d", gettimeofday_ns())
+
+--- out_like eval
+qr/^$::SecPattern\d{9}$/
+
+--- err
+
diff --git a/tools/ktap/test/timer.t b/tools/ktap/test/timer.t
new file mode 100644
index 0000000..2be2be2
--- /dev/null
+++ b/tools/ktap/test/timer.t
@@ -0,0 +1,65 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: timer
+--- opts: -q
+--- src
+
+var n1 = 0
+var n2 = 0
+
+tick-1s {
+	n1 = n1 + 1
+}
+
+tick-1s {
+	n2 = n2 + 1
+}
+
+tick-4s {
+	if (n1 == 0 || n2 == 0) {
+		print("failed")
+	}
+	exit()
+}
+
+--- out
+--- err
+
+
+=== TEST 2: cannot call timer.tick in trace_end context
+--- opts: -q
+--- src
+
+trace_end {
+	tick-1s {
+		print("error")
+	}
+}
+
+--- out
+error: timer.tick only can be called in RUNNING state
+--- err
+
+
+=== TEST 3: cannot call timer.profile in trace_end context
+--- opts: -q
+--- src
+
+trace_end {
+	profile-1s {
+		print("error")
+	}
+}
+
+--- out
+error: timer.profile only can be called in RUNNING state
+
+--- err
+
diff --git a/tools/ktap/test/tracepoint.t b/tools/ktap/test/tracepoint.t
new file mode 100644
index 0000000..f504da1
--- /dev/null
+++ b/tools/ktap/test/tracepoint.t
@@ -0,0 +1,53 @@
+# vi: ft= et ts=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: tracepoint
+--- opts: -q
+--- src
+
+var n = 0
+
+trace sched:* {
+	n = n + 1
+}
+
+tick-1s {
+	if (n == 0) {
+		print("failed")
+	}
+	exit()
+}
+
+--- out
+--- err
+
+
+=== TEST 2: enable all tracepoints in dry-run mode
+--- opts: -q -d
+--- src
+
+trace *:* {}
+
+--- out
+--- err
+--- expect_timeout
+--- timeout: 10
+
+
+=== TEST 3: test kdebug.tracepoint
+--- opts: -q
+--- src
+
+kdebug.tracepoint("sys_enter_open", function () {})
+tick-1s {
+	exit()
+}
+
+--- out
+--- err
diff --git a/tools/ktap/test/util/reindex b/tools/ktap/test/util/reindex
new file mode 100755
index 0000000..e4e1b4e
--- /dev/null
+++ b/tools/ktap/test/util/reindex
@@ -0,0 +1,61 @@
+#!/usr/bin/env perl
+
+# reindex
+# reindex .t files for Test::Base based test files
+# Copyright (C) Yichun Zhang (agentzh)
+
+use strict;
+use warnings;
+
+use Getopt::Std;
+
+my %opts;
+getopts('hb:', \%opts);
+if ($opts{h} or ! @ARGV) {
+    die "Usage: reindex [-b 0] t/*.t\n";
+}
+
+my $init = $opts{b};
+$init = 1 if not defined $init;
+
+my @files = map glob, @ARGV;
+for my $file (@files) {
+    next if -d $file or $file !~ /\.t_?$/;
+    reindex($file);
+}
+
+sub reindex {
+    my $file = $_[0];
+    open my $in, $file or
+        die "Can't open $file for reading: $!";
+    my @lines;
+    my $counter = $init;
+    my $changed;
+    while (<$in>) {
+        s/\r$//;
+        my $num;
+        s/ ^ === \s+ TEST \s+ (\d+)/$num=$1; "=== TEST " . $counter++/xie;
+        next if !defined $num;
+        if ($num != $counter-1) {
+            $changed++;
+        }
+    } continue {
+        push @lines, $_;
+    }
+    close $in;
+    my $text = join '', @lines;
+    $text =~ s/(?x) \n+ === \s+ TEST/\n\n\n\n=== TEST/ixsg;
+    $text =~ s/__(DATA|END)__\n+=== TEST/__${1}__\n\n=== TEST/;
+    #$text =~ s/\n+$/\n\n/s;
+    if (! $changed and $text eq join '', @lines) {
+        warn "reindex: $file:\tskipped.\n";
+        return;
+    }
+    open my $out, "> $file" or
+        die "Can't open $file for writing: $!";
+    binmode $out;
+    print $out $text;
+    close $out;
+
+    warn "reindex: $file:\tdone.\n";
+}
diff --git a/tools/ktap/test/zerodivide.t b/tools/ktap/test/zerodivide.t
new file mode 100644
index 0000000..daf1ff6
--- /dev/null
+++ b/tools/ktap/test/zerodivide.t
@@ -0,0 +1,21 @@
+# vi: ft= et tw=4 sw=4
+
+use lib 'test/lib';
+use Test::ktap 'no_plan';
+
+run_tests();
+
+__DATA__
+
+=== TEST 1: zero divide
+--- src
+
+var a = 1/0
+#should not go here
+print("failed")
+
+--- out_like
+(.*)divide 0(.*)
+--- err
+
+
-- 
1.8.1.4

