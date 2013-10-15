Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab3JOFSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:18:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3JOFSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:18:15 -0400
Date: Mon, 14 Oct 2013 22:18:01 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b3b64a12239e758573316df19cbbaf0126887440@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Improve printout-of auto-detected features
Git-Commit-ID: b3b64a12239e758573316df19cbbaf0126887440
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:18:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3b64a12239e758573316df19cbbaf0126887440
Gitweb:     http://git.kernel.org/tip/b3b64a12239e758573316df19cbbaf0126887440
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 2 Oct 2013 10:01:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:54 +0200

tools/perf/build: Improve printout-of auto-detected features

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
index 581a942..fb6ec06 100644
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
