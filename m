Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaB0N2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:28:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaB0N2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:28:37 -0500
Date: Thu, 27 Feb 2014 05:28:11 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0695e57b9a6a5eb856a58cf488f715b3bb7366a0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1392825179-5228-2-git-send-email-jolsa@redhat.com>
References: <1392825179-5228-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Factor features display code
Git-Commit-ID: 0695e57b9a6a5eb856a58cf488f715b3bb7366a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0695e57b9a6a5eb856a58cf488f715b3bb7366a0
Gitweb:     http://git.kernel.org/tip/0695e57b9a6a5eb856a58cf488f715b3bb7366a0
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Feb 2014 16:52:54 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:35 -0300

perf tools: Factor features display code

Currently the we display all detected features/libraries by following
rules:

 - if one of the features is missing
 - if it's build from clean tree

This patch changes changes this behavior in several ways.

- We no longer display all detected features, only detected libraries
  are displayed by default:

  $ make
    BUILD:   Doing 'make -j4' parallel build

  Auto-detecting system features:
  ...                         dwarf: [ on  ]
  ...                         glibc: [ on  ]
  ...                          gtk2: [ on  ]
  ...                      libaudit: [ on  ]
  ...                        libbfd: [ on  ]
  ...                        libelf: [ on  ]
  ...                       libnuma: [ on  ]
  ...                       libperl: [ on  ]
  ...                     libpython: [ on  ]
  ...                      libslang: [ on  ]
  ...                     libunwind: [ on  ]

  The assumption is, that above libraries are the most interesting part
of the detection, while we don't care much about detection of on-exit
support.

- If all above libraries are detected, the default is not shown on
  subsequent builds.

- If one of the above libraries is missing, the detection output is
  forced.

- The features status is stored in PERF-FEATURES file and the detection
  output is forced in case the there's difference between the file
  contents and currently detected features.

- If you want to see all detected features, you can use VF=1 make
  variable, that forces the detected features output.

  $ make VF=1
    BUILD:   Doing 'make -j4' parallel build

  Auto-detecting system features:
  ...                         dwarf: [ on  ]
  ...                         glibc: [ on  ]
  ...                          gtk2: [ on  ]
  ...                      libaudit: [ on  ]
  ...                        libbfd: [ on  ]
  ...                        libelf: [ on  ]
  ...                       libnuma: [ on  ]
  ...                       libperl: [ on  ]
  ...                     libpython: [ on  ]
  ...                      libslang: [ on  ]
  ...                     libunwind: [ on  ]
  ...                     backtrace: [ on  ]
  ...                fortify-source: [ on  ]
  ...                  gtk2-infobar: [ on  ]
  ...             libelf-getphdrnum: [ on  ]
  ...                   libelf-mmap: [ on  ]
  ...             libpython-version: [ on  ]
  ...                       on-exit: [ on  ]
  ...            stackprotector-all: [ on  ]
  ...                       timerfd: [ on  ]
  ...         libunwind-debug-frame: [ OFF ]
  ...                        bionic: [ OFF ]

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392825179-5228-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf   |   4 +-
 tools/perf/config/Makefile | 123 ++++++++++++++++++++++++++++++---------------
 2 files changed, 85 insertions(+), 42 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 5fedd69..bde91f8 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -7,6 +7,8 @@ include config/utilities.mak
 
 # Define V to have a more verbose compile.
 #
+# Define VF to have a more verbose feature check output.
+#
 # Define O to save output files in a separate directory.
 #
 # Define ARCH as name of target architecture if you want cross-builds.
@@ -897,7 +899,7 @@ config-clean:
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
-	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
+	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(python-clean)
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1686583..39e6e6c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -149,6 +149,32 @@ CORE_FEATURE_TESTS =			\
 	stackprotector-all		\
 	timerfd
 
+LIB_FEATURE_TESTS =			\
+	dwarf				\
+	glibc				\
+	gtk2				\
+	libaudit			\
+	libbfd				\
+	libelf				\
+	libnuma				\
+	libperl				\
+	libpython			\
+	libslang			\
+	libunwind
+
+VF_FEATURE_TESTS =			\
+	backtrace			\
+	fortify-source			\
+	gtk2-infobar			\
+	libelf-getphdrnum		\
+	libelf-mmap			\
+	libpython-version		\
+	on-exit				\
+	stackprotector-all		\
+	timerfd				\
+	libunwind-debug-frame		\
+	bionic
+
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
 # mentioned in this list we need to refactor this ;-).
@@ -161,17 +187,6 @@ endef
 $(foreach feat,$(CORE_FEATURE_TESTS),$(call set_test_all_flags,$(feat)))
 
 #
-# So here we detect whether test-all was rebuilt, to be able
-# to skip the print-out of the long features list if the file
-# existed before and after it was built:
-#
-ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all.bin),)
-  test-all-failed := 1
-else
-  test-all-failed := 0
-endif
-
-#
 # Special fast-path for the 'all features are available' case:
 #
 $(call feature_check,all,$(MSG))
@@ -180,15 +195,6 @@ $(call feature_check,all,$(MSG))
 # Just in case the build freshly failed, make sure we print the
 # feature matrix:
 #
-ifeq ($(feature-all), 0)
-  test-all-failed := 1
-endif
-
-ifeq ($(test-all-failed),1)
-  $(info )
-  $(info Auto-detecting system features:)
-endif
-
 ifeq ($(feature-all), 1)
   #
   # test-all.c passed - just set all the core feature flags to 1:
@@ -199,27 +205,6 @@ else
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
-#
-# Print the result of the feature test:
-#
-feature_print = $(eval $(feature_print_code)) $(info $(MSG))
-
-define feature_print_code
-  ifeq ($(feature-$(1)), 1)
-    MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
-  else
-    MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
-  endif
-endef
-
-#
-# Only print out our features if we rebuilt the testcases or if a test failed:
-#
-ifeq ($(test-all-failed), 1)
-  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_print,$(feat)))
-  $(info )
-endif
-
 ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
@@ -602,3 +587,59 @@ ifdef DESTDIR
 plugindir=$(libdir)/traceevent/plugins
 plugindir_SQ= $(subst ','\'',$(plugindir))
 endif
+
+#
+# Print the result of the feature test:
+#
+feature_print = $(eval $(feature_print_code)) $(info $(MSG))
+
+define feature_print_code
+  ifeq ($(feature-$(1)), 1)
+    MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+  else
+    MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+  endif
+endef
+
+PERF_FEATURES := $(foreach feat,$(LIB_FEATURE_TESTS),feature-$(feat)($(feature-$(feat))))
+PERF_FEATURES_FILE := $(shell touch $(OUTPUT)PERF-FEATURES; cat $(OUTPUT)PERF-FEATURES)
+
+# The $(display_lib) controls the default detection message
+# output. It's set if:
+# - detected features differes from stored features from
+#   last build (in PERF-FEATURES file)
+# - one of the $(LIB_FEATURE_TESTS) is not detected
+# - VF is enabled
+
+ifneq ("$(PERF_FEATURES)","$(PERF_FEATURES_FILE)")
+  $(shell echo "$(PERF_FEATURES)" > $(OUTPUT)PERF-FEATURES)
+  display_lib := 1
+endif
+
+feature_check = $(eval $(feature_check_code))
+define feature_check_code
+  ifneq ($(feature-$(1)), 1)
+    display_lib := 1
+  endif
+endef
+
+$(foreach feat,$(LIB_FEATURE_TESTS),$(call feature_check,$(feat)))
+
+ifeq ($(VF),1)
+  display_lib := 1
+  display_vf := 1
+endif
+
+ifeq ($(display_lib),1)
+  $(info )
+  $(info Auto-detecting system features:)
+  $(foreach feat,$(LIB_FEATURE_TESTS),$(call feature_print,$(feat),))
+endif
+
+ifeq ($(display_vf),1)
+  $(foreach feat,$(VF_FEATURE_TESTS),$(call feature_print,$(feat),))
+endif
+
+ifeq ($(display_lib),1)
+  $(info )
+endif
