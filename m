Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3JGL6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:34 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55046 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3JGL6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:22 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 36/50] tools/perf/build: Speed up auto-detection
Date: Mon,  7 Oct 2013 13:56:29 +0200
Message-Id: <1381147003-2574-37-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The detection of certain rarely detected features can be delayed
to when they are actually needed.

So speed up the common case of auto-detection by pre-building only
a core set of features and populating only their feature-flags.

[ Features not listed in CORE_FEATURES need to built explicitly
  via the feature_check() function. ]

(Also order the feature names alphabetically, while at it.)

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-xQkuveknd0gqla1dfxrqKpkl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                | 48 ++++++++++++++++++++++++++++--------------------
 tools/perf/config/feature-checks/Makefile | 31 ++++++++++++++++---------------
 2 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9a27aa9..25f09a5 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -105,30 +105,35 @@ endef
 $(info )
 $(info Auto-detecting system features:)
 
-FEATURE_TESTS =				\
-	hello				\
-	stackprotector-all		\
-	stackprotector			\
-	volatile-register-var		\
+#
+# Note that this is not a complete list of all feature tests, just
+# those that are typically built on a fully configured system.
+#
+# [ Feature tests not mentioned here have to be built explicitly in
+#   the rule that uses them - an example for that is the 'bionic'
+#   feature check. ]
+#
+CORE_FEATURE_TESTS =			\
+	backtrace			\
+	dwarf				\
 	fortify-source			\
-	bionic				\
-	libelf				\
 	glibc				\
-	dwarf				\
-	libelf-mmap			\
-	libelf-getphdrnum		\
-	libunwind			\
-	libaudit			\
-	libslang			\
 	gtk2				\
 	gtk2-infobar			\
+	libaudit			\
+	libbfd				\
+	libelf				\
+	libelf-getphdrnum		\
+	libelf-mmap			\
+	libnuma				\
 	libperl				\
 	libpython			\
 	libpython-version		\
-	libbfd				\
+	libslang			\
+	libunwind			\
 	on-exit				\
-	backtrace			\
-	libnuma
+	stackprotector-all		\
+	volatile-register-var
 
 #
 # Special fast-path for the 'all features are available' case:
@@ -136,10 +141,13 @@ FEATURE_TESTS =				\
 $(call feature_check,all)
 
 ifeq ($(feature-all), 1)
-  $(foreach feat,$(FEATURE_TESTS),$(call feature_set,$(feat)))
+  #
+  # test-all.c passed - just set all the core feature flags to 1:
+  #
+  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) -i -j -C config/feature-checks >/dev/null 2>&1)
-  $(foreach feat,$(FEATURE_TESTS),$(call feature_check,$(feat)))
+  $(shell $(MAKE) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
 feature_print = $(eval $(feature_print_code))
@@ -156,7 +164,7 @@ define feature_print_code
   $(info $(MSG))
 endef
 
-$(foreach feat,$(FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
+$(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
 
 # newline at the end of the feature printouts:
 $(info )
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index b031669..2967a07 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,28 +1,29 @@
 
 FILES=					\
-	test-hello			\
-	test-stackprotector-all		\
-	test-stackprotector		\
-	test-volatile-register-var	\
-	test-fortify-source		\
+	test-all			\
+	test-backtrace			\
 	test-bionic			\
-	test-libelf			\
-	test-glibc			\
 	test-dwarf			\
-	test-libelf-mmap		\
-	test-libelf-getphdrnum		\
-	test-libunwind			\
-	test-libaudit			\
-	test-libslang			\
+	test-fortify-source		\
+	test-glibc			\
 	test-gtk2			\
 	test-gtk2-infobar		\
+	test-hello			\
+	test-libaudit			\
+	test-libbfd			\
+	test-libelf			\
+	test-libelf-getphdrnum		\
+	test-libelf-mmap		\
+	test-libnuma			\
 	test-libperl			\
 	test-libpython			\
 	test-libpython-version		\
-	test-libbfd			\
+	test-libslang			\
+	test-libunwind			\
 	test-on-exit			\
-	test-backtrace			\
-	test-libnuma
+	test-stackprotector-all		\
+	test-stackprotector		\
+	test-volatile-register-var
 
 CC := $(CC) -MD
 
-- 
1.7.11.7

