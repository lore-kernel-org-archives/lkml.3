Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaBXT4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:56:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaBXT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/12] perf tools: Add variable display for VF make output
Date: Mon, 24 Feb 2014 16:56:33 -0300
Message-Id: <1393271800-17505-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index 39e6e6cca8ed..97a64c4631d3 100644
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
-- 
1.8.1.4

