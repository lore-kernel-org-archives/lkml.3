Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab3JOFSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:18:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3JOFSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:18:07 -0400
Date: Mon, 14 Oct 2013 22:17:52 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-f1138ec66e839ce90c58af0c264db33271d73466@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Speed up auto-detection
Git-Commit-ID: f1138ec66e839ce90c58af0c264db33271d73466
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:17:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1138ec66e839ce90c58af0c264db33271d73466
Gitweb:     http://git.kernel.org/tip/f1138ec66e839ce90c58af0c264db33271d73466
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 2 Oct 2013 09:54:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:53 +0200

tools/perf/build: Speed up auto-detection

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
 tools/perf/config/Makefile                | 49 ++++++++++++++++++-------------
 tools/perf/config/feature-checks/Makefile | 31 +++++++++----------
 2 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index cbd7cdc..581a942 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -105,30 +105,36 @@ endef
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
+	stackprotector			\
+	stackprotector-all		\
+	volatile-register-var
 
 #
 # Special fast-path for the 'all features are available' case:
@@ -136,10 +142,13 @@ FEATURE_TESTS =				\
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
@@ -156,7 +165,7 @@ define feature_print_code
   $(info $(MSG))
 endef
 
-$(foreach feat,$(FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
+$(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
 
 # newline at the end of the feature printouts:
 $(info )
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 4b855e0..d4c55ac 100644
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
 
