Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaIWTFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:05:31 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:36321 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbaIWTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:05:27 -0400
From: Peter Feiner <pfeiner@google.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: [PATCH 3/3] tools: parallel selftests building & running
Date: Tue, 23 Sep 2014 12:05:23 -0700
Message-Id: <1411499123-18050-3-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411499123-18050-1-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
 <1411499123-18050-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now make -jN builds and runs selftests in parallel. Also, if one
selftest fails to build or run, make will return an error, whereas
before the error was ignored.

Also added missing clean target to user/Makefile so 'make clean' doesn't fail.

Signed-off-by: Peter Feiner <pfeiner@google.com>
---
 tools/testing/selftests/Makefile      | 49 ++++++++++++++---------------------
 tools/testing/selftests/user/Makefile |  2 ++
 2 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 36ff2e4..8c33716 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -18,32 +18,23 @@ TARGETS += firmware
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
 
-all:
-	for TARGET in $(TARGETS); do \
-		make -C $$TARGET; \
-	done;
-
-run_tests: all
-	for TARGET in $(TARGETS); do \
-		make -C $$TARGET run_tests; \
-	done;
-
-hotplug:
-	for TARGET in $(TARGETS_HOTPLUG); do \
-		make -C $$TARGET; \
-	done;
-
-run_hotplug: hotplug
-	for TARGET in $(TARGETS_HOTPLUG); do \
-		make -C $$TARGET run_full_test; \
-	done;
-
-clean_hotplug:
-	for TARGET in $(TARGETS_HOTPLUG); do \
-		make -C $$TARGET clean; \
-	done;
-
-clean:
-	for TARGET in $(TARGETS); do \
-		make -C $$TARGET clean; \
-	done;
+BUILD_TARGETS=$(TARGETS:%=build-%) $(TARGETS_HOTPLUG:%=build-%)
+TEST_TARGETS=$(TARGETS:%=test-%)
+CLEAN_TARGETS=$(TARGETS:%=clean-%) $(TARGETS_HOTPLUG:%=clean-%)
+
+all: $(BUILD_TARGETS)
+
+run_hotplug: test-cpu-hotplug test-memory-hotplug
+
+run_tests: $(TEST_TARGETS)
+
+clean: $(CLEAN_TARGETS)
+
+build-%:
+	$(MAKE) -C $(@:build-%=%)
+
+test-%: build-%
+	$(MAKE) -C $(@:test-%=%) run_tests
+
+clean-%:
+	$(MAKE) -C $(@:clean-%=%) clean
diff --git a/tools/testing/selftests/user/Makefile b/tools/testing/selftests/user/Makefile
index 396255b..8eb6583 100644
--- a/tools/testing/selftests/user/Makefile
+++ b/tools/testing/selftests/user/Makefile
@@ -3,6 +3,8 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
+clean:
+
 run_tests: all
 	@if /sbin/modprobe test_user_copy ; then \
 		rmmod test_user_copy; \
-- 
2.1.0.rc2.206.gedb03e5

