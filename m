Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3K0U0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:26:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab3K0UZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:25:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jean Pihet <jean.pihet@linaro.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/34] perf tools unwinding: Use the per-feature check flags
Date: Wed, 27 Nov 2013 17:16:34 -0300
Message-Id: <1385583394-3703-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@linaro.org>

Use the per-feature check flags for the unwinding feature in order to
correctly compile the libunwind and libunwind-debug-frame feature
checks.

Tested on ARMv7 and ARMv8 with 'make DEBUG=1 LIBUNWIND_DIR=/usr/local -C
tools/perf'

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Link: http://lkml.kernel.org/r/1385045539-24537-3-git-send-email-jean.pihet@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                | 38 +++++++++++++++++--------------
 tools/perf/config/feature-checks/Makefile |  6 ++---
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c55149538d92..80ea6d823908 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -36,6 +36,26 @@ ifeq ($(ARCH),arm)
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
+ifeq ($(LIBUNWIND_LIBS),)
+  NO_LIBUNWIND := 1
+else
+  #
+  # For linking with debug library, run like:
+  #
+  #   make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+  #
+  ifdef LIBUNWIND_DIR
+    LIBUNWIND_CFLAGS  = -I$(LIBUNWIND_DIR)/include
+    LIBUNWIND_LDFLAGS = -L$(LIBUNWIND_DIR)/lib
+  endif
+  LIBUNWIND_LDFLAGS += $(LIBUNWIND_LIBS)
+
+  FEATURE_CHECK_CFLAGS-libunwind = $(LIBUNWIND_CFLAGS)
+  FEATURE_CHECK_LDFLAGS-libunwind = $(LIBUNWIND_LDFLAGS)
+  FEATURE_CHECK_CFLAGS-libunwind-debug-frame = $(LIBUNWIND_CFLAGS)
+  FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS)
+endif
+
 ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
@@ -102,7 +122,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -310,21 +330,7 @@ ifndef NO_LIBELF
   endif # NO_DWARF
 endif # NO_LIBELF
 
-ifeq ($(LIBUNWIND_LIBS),)
-  NO_LIBUNWIND := 1
-endif
-
 ifndef NO_LIBUNWIND
-  #
-  # For linking with debug library, run like:
-  #
-  #   make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-  #
-  ifdef LIBUNWIND_DIR
-    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-  endif
-
   ifneq ($(feature-libunwind), 1)
     msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
     NO_LIBUNWIND := 1
@@ -340,9 +346,7 @@ ifndef NO_LIBUNWIND
       CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
     endif
   endif
-endif
 
-ifndef NO_LIBUNWIND
   CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
   EXTLIBS += $(LIBUNWIND_LIBS)
   CFLAGS += $(LIBUNWIND_CFLAGS)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 87e790017c69..8dffb628dac8 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -38,7 +38,7 @@ BUILD = $(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 ###############################
 
 test-all:
-	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-hello:
 	$(BUILD)
@@ -74,10 +74,10 @@ test-libnuma:
 	$(BUILD) -lnuma
 
 test-libunwind:
-	$(BUILD) $(LIBUNWIND_LIBS) -lelf
+	$(BUILD) -lelf
 
 test-libunwind-debug-frame:
-	$(BUILD) $(LIBUNWIND_LIBS) -lelf
+	$(BUILD) -lelf
 
 test-libaudit:
 	$(BUILD) -laudit
-- 
1.8.1.4

