Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3LCQK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:10:27 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34405 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LCQKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:10:06 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 2/2] perf: unwinding: use the per-feature check flags
Date: Tue,  3 Dec 2013 17:09:46 +0100
Message-Id: <1386086986-30805-3-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386086986-30805-1-git-send-email-jean.pihet@linaro.org>
References: <1386086986-30805-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the per-feature check flags for the unwinding feature in order
to correctly compile the libunwind and libunwind-debug-frame feature
checks.

Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR set
in 'make -C tools/perf'

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/config/Makefile                | 48 +++++++++++++++++--------------
 tools/perf/config/feature-checks/Makefile |  6 ++--
 2 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c551495..cd62286 100644
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
@@ -339,14 +345,12 @@ ifndef NO_LIBUNWIND
       # non-ARM has no dwarf_find_debug_frame() function:
       CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
     endif
-  endif
-endif
 
-ifndef NO_LIBUNWIND
-  CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
-  EXTLIBS += $(LIBUNWIND_LIBS)
-  CFLAGS += $(LIBUNWIND_CFLAGS)
-  LDFLAGS += $(LIBUNWIND_LDFLAGS)
+    CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
+    EXTLIBS += $(LIBUNWIND_LIBS)
+    CFLAGS += $(LIBUNWIND_CFLAGS)
+    LDFLAGS += $(LIBUNWIND_LDFLAGS)
+  endif # ifneq ($(feature-libunwind), 1)
 endif
 
 ifndef NO_LIBAUDIT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 87e7900..8dffb62 100644
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
1.7.11.7

