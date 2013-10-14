Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3JNUoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:44:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38521 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab3JNUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 038/161] tools/perf/build: Improve printout-of auto-detected features
Date: Mon, 14 Oct 2013 17:00:27 -0300
Message-Id: <1381780950-25642-39-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

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
index 581a94211fea..fb6ec069f541 100644
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
@@ -137,9 +135,33 @@ CORE_FEATURE_TESTS =			\
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
@@ -151,11 +173,10 @@ else
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
@@ -165,10 +186,13 @@ define feature_print_code
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
1.8.1.4

