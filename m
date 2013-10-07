Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3JGMCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:02:08 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54778 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3JGL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:23 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 37/50] tools/perf/build: Improve printout-of auto-detected features
Date: Mon,  7 Oct 2013 13:56:30 +0200
Message-Id: <1381147003-2574-38-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the print-out of auto-detected features by making sure that
repeat invocations of 'make' when all features are successfully
detected do not produce the (rather lengthy) autodetection printout.

( When one or more features are missing then we still print out the
  feature detection table, to make sure people are aware of the
  resulting limitations. )

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-qd8sMsshcjomxqx9bQcufmaa@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 25f09a5..7b104e4 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -102,8 +102,6 @@ endef
 #
 # Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
 #
-$(info )
-$(info Auto-detecting system features:)
 
 #
 # Note that this is not a complete list of all feature tests, just
@@ -136,9 +134,33 @@ CORE_FEATURE_TESTS =			\
 	volatile-register-var
 
 #
+# So here we detect whether test-all was rebuilt, to be able
+# to skip the print-out of the long features list if the file
+# existed before and after it was built:
+#
+ifeq ($(wildcard config/feature-checks/test-all),)
+  test-all-failed := 1
+else
+  test-all-failed := 0
+endif
+
+#
 # Special fast-path for the 'all features are available' case:
 #
-$(call feature_check,all)
+$(call feature_check,all,$(MSG))
+
+#
+# Just in case the build freshly failed, make sure we print the
+# feature matrix:
+#
+ifeq ($(feature-all), 0)
+  test-all-failed := 1
+endif
+
+ifeq ($(test-all-failed),1)
+  $(info )
+  $(info Auto-detecting system features:)
+endif
 
 ifeq ($(feature-all), 1)
   #
@@ -150,11 +172,10 @@ else
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
-feature_print = $(eval $(feature_print_code))
-
 #
 # Print the result of the feature test:
 #
+feature_print = $(eval $(feature_print_code))
 define feature_print_code
   ifeq ($(feature-$(1)), 1)
     MSG := $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
@@ -164,10 +185,13 @@ define feature_print_code
   $(info $(MSG))
 endef
 
-$(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
-
-# newline at the end of the feature printouts:
-$(info )
+#
+# Only print out our features if we rebuilt the testcases or if a test failed:
+#
+ifeq ($(test-all-failed), 1)
+  $(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
+  $(info )
+endif
 
 ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
-- 
1.7.11.7

