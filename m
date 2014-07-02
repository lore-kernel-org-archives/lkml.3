Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaGBPvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:51:45 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:43054 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365AbaGBPvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:51:43 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        keescook@chromium.org, michael@ellerman.id.au,
        benh@kernel.crashing.org, fweisbec@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 linux-next] tools: selftests - create a separate hotplug target for full range test
Date: Wed,  2 Jul 2014 09:51:38 -0600
Message-Id: <1404316298-8870-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems, hot-plug tests could hang forever waiting for cpu and
memory to be ready to be offlined. A special hot-plug target is created
to run full range of hot-plug tests. In default mode, hot-plug tests run
in safe mode with a limited scope. In limited mode, cpu-hotplug test is
run on a single cpu as opposed to all hotplug capable cpus, and memory
hotplug test is run on 2% of hotplug capable memory instead of 10%. In
addition to the above change, cpu-hotplug is chnged to change processor
affinity to cpu 0 so it doesn't impact itself while the test runs.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/Makefile                   | 18 ++++++++
 tools/testing/selftests/README.txt                 | 27 +++++++++--
 tools/testing/selftests/cpu-hotplug/Makefile       |  3 ++
 tools/testing/selftests/cpu-hotplug/on-off-test.sh | 52 +++++++++++++++++++++-
 tools/testing/selftests/memory-hotplug/Makefile    |  3 ++
 .../selftests/memory-hotplug/on-off-test.sh        |  8 ++++
 6 files changed, 105 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index e66e710..4c2aa35 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -12,6 +12,9 @@ TARGETS += powerpc
 TARGETS += user
 TARGETS += sysctl
 
+TARGETS_HOTPLUG = cpu-hotplug
+TARGETS_HOTPLUG += memory-hotplug
+
 all:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET; \
@@ -22,6 +25,21 @@ run_tests: all
 		make -C $$TARGET run_tests; \
 	done;
 
+hotplug:
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET; \
+	done;
+
+run_hotplug: hotplug
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET run_full_test; \
+	done;
+
+clean_hotplug:
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET clean; \
+	done;
+
 clean:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET clean; \
diff --git a/tools/testing/selftests/README.txt b/tools/testing/selftests/README.txt
index 5e2faf9..2660d5f 100644
--- a/tools/testing/selftests/README.txt
+++ b/tools/testing/selftests/README.txt
@@ -4,8 +4,15 @@ The kernel contains a set of "self tests" under the tools/testing/selftests/
 directory. These are intended to be small unit tests to exercise individual
 code paths in the kernel.
 
-Running the selftests
-=====================
+On some systems, hot-plug tests could hang forever waiting for cpu and
+memory to be ready to be offlined. A special hot-plug target is created
+to run full range of hot-plug tests. In default mode, hot-plug tests run
+in safe mode with a limited scope. In limited mode, cpu-hotplug test is
+run on a single cpu as opposed to all hotplug capable cpus, and memory
+hotplug test is run on 2% of hotplug capable memory instead of 10%.
+
+Running the selftests (hotplug tests are run in limited mode)
+=============================================================
 
 To build the tests:
 
@@ -18,14 +25,26 @@ To run the tests:
 
 - note that some tests will require root privileges.
 
-
-To run only tests targetted for a single subsystem:
+To run only tests targeted for a single subsystem: (including
+hotplug targets in limited mode)
 
   $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
 
 See the top-level tools/testing/selftests/Makefile for the list of all possible
 targets.
 
+Running the full range hotplug selftests
+========================================
+
+To build the tests:
+
+  $ make -C tools/testing/selftests hotplug
+
+To run the tests:
+
+  $ make -C tools/testing/selftests run_hotplug
+
+- note that some tests will require root privileges.
 
 Contributing new tests
 ======================
diff --git a/tools/testing/selftests/cpu-hotplug/Makefile b/tools/testing/selftests/cpu-hotplug/Makefile
index 790c23a..e9c28d8 100644
--- a/tools/testing/selftests/cpu-hotplug/Makefile
+++ b/tools/testing/selftests/cpu-hotplug/Makefile
@@ -3,4 +3,7 @@ all:
 run_tests:
 	@/bin/bash ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
+run_full_test:
+	@/bin/bash ./on-off-test.sh -a || echo "cpu-hotplug selftests: [FAIL]"
+
 clean:
diff --git a/tools/testing/selftests/cpu-hotplug/on-off-test.sh b/tools/testing/selftests/cpu-hotplug/on-off-test.sh
index bdde7cf..98b1d65 100644
--- a/tools/testing/selftests/cpu-hotplug/on-off-test.sh
+++ b/tools/testing/selftests/cpu-hotplug/on-off-test.sh
@@ -11,6 +11,8 @@ prerequisite()
 		exit 0
 	fi
 
+	taskset -p 01 $$
+
 	SYSFS=`mount -t sysfs | head -1 | awk '{ print $3 }'`
 
 	if [ ! -d "$SYSFS" ]; then
@@ -22,6 +24,19 @@ prerequisite()
 		echo $msg cpu hotplug is not supported >&2
 		exit 0
 	fi
+
+	echo "CPU online/offline summary:"
+	online_cpus=`cat $SYSFS/devices/system/cpu/online`
+	online_max=${online_cpus##*-}
+	echo -e "\t Cpus in online state: $online_cpus"
+
+	offline_cpus=`cat $SYSFS/devices/system/cpu/offline`
+	if [[ "a$offline_cpus" = "a" ]]; then
+		offline_cpus=0
+	else
+		offline_max=${offline_cpus##*-}
+	fi
+	echo -e "\t Cpus in offline state: $offline_cpus"
 }
 
 #
@@ -113,15 +128,25 @@ offline_cpu_expect_fail()
 }
 
 error=-12
+allcpus=0
 priority=0
+online_cpus=0
+online_max=0
+offline_cpus=0
+offline_max=0
 
-while getopts e:hp: opt; do
+while getopts e:ahp: opt; do
 	case $opt in
 	e)
 		error=$OPTARG
 		;;
+	a)
+		allcpus=1
+		;;
 	h)
-		echo "Usage $0 [ -e errno ] [ -p notifier-priority ]"
+		echo "Usage $0 [ -a ] [ -e errno ] [ -p notifier-priority ]"
+		echo -e "\t default offline one cpu"
+		echo -e "\t run with -a option to offline all cpus"
 		exit
 		;;
 	p)
@@ -138,6 +163,29 @@ fi
 prerequisite
 
 #
+# Safe test (default) - offline and online one cpu
+#
+if [ $allcpus -eq 0 ]; then
+	echo "Limited scope test: one hotplug cpu"
+	echo -e "\t (leaves cpu in the original state):"
+	echo -e "\t online to offline to online: cpu $online_max"
+	offline_cpu_expect_success $online_max
+	online_cpu_expect_success $online_max
+
+	if [[ $offline_cpus -gt 0 ]]; then
+		echo -e "\t offline to online to offline: cpu $offline_max"
+		online_cpu_expect_success $offline_max
+		offline_cpu_expect_success $offline_max
+	fi
+	exit 0
+else
+	echo "Full scope test: all hotplug cpus"
+	echo -e "\t online all offline cpus"
+	echo -e "\t offline all online cpus"
+	echo -e "\t online all offline cpus"
+fi
+
+#
 # Online all hot-pluggable CPUs
 #
 for cpu in `hotplaggable_offline_cpus`; do
diff --git a/tools/testing/selftests/memory-hotplug/Makefile b/tools/testing/selftests/memory-hotplug/Makefile
index 058c76f..d46b8d4 100644
--- a/tools/testing/selftests/memory-hotplug/Makefile
+++ b/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,6 +1,9 @@
 all:
 
 run_tests:
+	@/bin/bash ./on-off-test.sh -r 2 || echo "memory-hotplug selftests: [FAIL]"
+
+run_full_test:
 	@/bin/bash ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
diff --git a/tools/testing/selftests/memory-hotplug/on-off-test.sh b/tools/testing/selftests/memory-hotplug/on-off-test.sh
index a2816f6..6cddde0 100644
--- a/tools/testing/selftests/memory-hotplug/on-off-test.sh
+++ b/tools/testing/selftests/memory-hotplug/on-off-test.sh
@@ -142,10 +142,16 @@ fi
 
 prerequisite
 
+echo "Test scope: $ratio% hotplug memory"
+echo -e "\t online all hotplug memory in offline state"
+echo -e "\t offline $ratio% hotplug memory in online state"
+echo -e "\t online all hotplug memory in offline state"
+
 #
 # Online all hot-pluggable memory
 #
 for memory in `hotplaggable_offline_memory`; do
+	echo offline-online $memory
 	online_memory_expect_success $memory
 done
 
@@ -154,6 +160,7 @@ done
 #
 for memory in `hotpluggable_online_memory`; do
 	if [ $((RANDOM % 100)) -lt $ratio ]; then
+		echo online-offline $memory
 		offline_memory_expect_success $memory
 	fi
 done
@@ -162,6 +169,7 @@ done
 # Online all hot-pluggable memory again
 #
 for memory in `hotplaggable_offline_memory`; do
+	echo offline-online $memory
 	online_memory_expect_success $memory
 done
 
-- 
1.9.1

