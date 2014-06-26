Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaFZUeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:34:02 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:38393 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbaFZUeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:34:01 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        keescook@chromium.org, michael@ellerman.id.au, fweisbec@gmail.com,
        benh@kernel.crashing.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: selftests - create a separate hotplug target
Date: Thu, 26 Jun 2014 14:33:56 -0600
Message-Id: <1403814836-16964-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems, hotplug tests could hang forever waiting for cpu and
memory to be ready to be offlined. A special hotplug target is created,
which will help run non-hotplug tests and run hotplug tests as a special
case. Individual hotplug tests can still be run as a special target
targeted for a single subsystem.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/Makefile   | 20 ++++++++++++++++++--
 tools/testing/selftests/README.txt | 24 +++++++++++++++++++++---
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index e66e710..8b3f029 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -1,8 +1,6 @@
 TARGETS = breakpoints
-TARGETS += cpu-hotplug
 TARGETS += efivarfs
 TARGETS += kcmp
-TARGETS += memory-hotplug
 TARGETS += mqueue
 TARGETS += net
 TARGETS += ptrace
@@ -12,6 +10,9 @@ TARGETS += powerpc
 TARGETS += user
 TARGETS += sysctl
 
+TARGETS_HOTPLUG = cpu-hotplug
+TARGETS_HOTPLUG += memory-hotplug
+
 all:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET; \
@@ -22,6 +23,21 @@ run_tests: all
 		make -C $$TARGET run_tests; \
 	done;
 
+hotplug:
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET; \
+	done;
+
+run_hotplug: hotplug
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET run_tests; \
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
index 5e2faf9..af050cd 100644
--- a/tools/testing/selftests/README.txt
+++ b/tools/testing/selftests/README.txt
@@ -4,8 +4,13 @@ The kernel contains a set of "self tests" under the tools/testing/selftests/
 directory. These are intended to be small unit tests to exercise individual
 code paths in the kernel.
 
-Running the selftests
-=====================
+On some systems, hotplug tests could hang forever waiting for cpu and
+memory to be ready to be offlined. A special hotplug target is created,
+which will help run non-hotplug tests and run hotplug tests as a special
+case.
+
+Running the selftests (non-hotplug tests)
+=========================================
 
 To build the tests:
 
@@ -19,13 +24,26 @@ To run the tests:
 - note that some tests will require root privileges.
 
 
-To run only tests targetted for a single subsystem:
+To run only tests targeted for a single subsystem: (including
+hotplug targets)
 
   $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
 
 See the top-level tools/testing/selftests/Makefile for the list of all possible
 targets.
 
+Running the hotplug selftests
+==============================
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
-- 
1.9.1

