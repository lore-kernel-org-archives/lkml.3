Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaB0N3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:29:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54731 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaB0N3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:29:17 -0500
Date: Thu, 27 Feb 2014 05:28:23 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8d79076a3c5dbe45109fd15d2489168fbbb28a3d@git.kernel.org>
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
In-Reply-To: <1392825179-5228-3-git-send-email-jolsa@redhat.com>
References: <1392825179-5228-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add variable display for VF make output
Git-Commit-ID: 8d79076a3c5dbe45109fd15d2489168fbbb28a3d
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

Commit-ID:  8d79076a3c5dbe45109fd15d2489168fbbb28a3d
Gitweb:     http://git.kernel.org/tip/8d79076a3c5dbe45109fd15d2489168fbbb28a3d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Feb 2014 16:52:55 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:36 -0300

perf tools: Add variable display for VF make output

Adding dump of interesting build directories to the make VF=1 output.

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

  ...                        prefix: /home/jolsa
  ...                        bindir: /home/jolsa/bin
  ...                        libdir: /home/jolsa/lib64
  ...                    sysconfdir: /home/jolsa/etc

Adding functions to print variable/text in features display -
feature_print_var/feature_print_text (feature_print_text is used in next
patches).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392825179-5228-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 39e6e6c..97a64c4 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -591,9 +591,9 @@ endif
 #
 # Print the result of the feature test:
 #
-feature_print = $(eval $(feature_print_code)) $(info $(MSG))
+feature_print_status = $(eval $(feature_print_status_code)) $(info $(MSG))
 
-define feature_print_code
+define feature_print_status_code
   ifeq ($(feature-$(1)), 1)
     MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
   else
@@ -601,6 +601,16 @@ define feature_print_code
   endif
 endef
 
+feature_print_var = $(eval $(feature_print_var_code)) $(info $(MSG))
+define feature_print_var_code
+    MSG = $(shell printf '...%30s: %s' $(1) $($(1)))
+endef
+
+feature_print_text = $(eval $(feature_print_text_code)) $(info $(MSG))
+define feature_print_text_code
+    MSG = $(shell printf '...%30s: %s' $(1) $(2))
+endef
+
 PERF_FEATURES := $(foreach feat,$(LIB_FEATURE_TESTS),feature-$(feat)($(feature-$(feat))))
 PERF_FEATURES_FILE := $(shell touch $(OUTPUT)PERF-FEATURES; cat $(OUTPUT)PERF-FEATURES)
 
@@ -633,11 +643,16 @@ endif
 ifeq ($(display_lib),1)
   $(info )
   $(info Auto-detecting system features:)
-  $(foreach feat,$(LIB_FEATURE_TESTS),$(call feature_print,$(feat),))
+  $(foreach feat,$(LIB_FEATURE_TESTS),$(call feature_print_status,$(feat),))
 endif
 
 ifeq ($(display_vf),1)
-  $(foreach feat,$(VF_FEATURE_TESTS),$(call feature_print,$(feat),))
+  $(foreach feat,$(VF_FEATURE_TESTS),$(call feature_print_status,$(feat),))
+  $(info )
+  $(call feature_print_var,prefix)
+  $(call feature_print_var,bindir)
+  $(call feature_print_var,libdir)
+  $(call feature_print_var,sysconfdir)
 endif
 
 ifeq ($(display_lib),1)
