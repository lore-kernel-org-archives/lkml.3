Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbbATQp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:45:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbbATQpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:45:55 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/36] perf build: Add bench objects building
Date: Tue, 20 Jan 2015 17:39:03 +0100
Message-Id: <1421771973-6022-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move bench objects building under build framework
and enable perf-in.o rule.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Build           |  2 ++
 tools/perf/Makefile.perf   | 38 ++++++++++++++++----------------------
 tools/perf/bench/Build     | 11 +++++++++++
 tools/perf/config/Makefile |  2 ++
 4 files changed, 31 insertions(+), 22 deletions(-)
 create mode 100644 tools/perf/Build
 create mode 100644 tools/perf/bench/Build

diff --git a/tools/perf/Build b/tools/perf/Build
new file mode 100644
index 000000000000..9ea828de3fde
--- /dev/null
+++ b/tools/perf/Build
@@ -0,0 +1,2 @@
+perf-y += builtin-bench.o
+perf-y += bench/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 8087f97ee4e8..710730308618 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -93,6 +93,7 @@ $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 	@touch $(OUTPUT)PERF-VERSION-FILE
 
 CC = $(CROSS_COMPILE)gcc
+LD = $(CROSS_COMPILE)ld
 AR = $(CROSS_COMPILE)ar
 PKG_CONFIG = $(CROSS_COMPILE)pkg-config
 
@@ -464,21 +465,6 @@ LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
-BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
-# Benchmark modules
-BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
-BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(ARCH), x86)
-ifeq ($(IS_64_BIT), 1)
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
-endif
-endif
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
-BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
-BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
-BUILTIN_OBJS += $(OUTPUT)bench/futex-requeue.o
-
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
 BUILTIN_OBJS += $(OUTPUT)builtin-help.o
@@ -597,10 +583,6 @@ ifeq ($(NO_PERF_REGS),0)
   LIB_OBJS += $(OUTPUT)util/perf_regs.o
 endif
 
-ifndef NO_LIBNUMA
-  BUILTIN_OBJS += $(OUTPUT)bench/numa.o
-endif
-
 ifndef NO_ZLIB
   LIB_OBJS += $(OUTPUT)util/zlib.o
 endif
@@ -627,14 +609,22 @@ shell_compatibility_test: please_set_SHELL_PATH_to_a_more_modern_shell
 strip: $(PROGRAMS) $(OUTPUT)perf
 	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
 
+PERF_IN := $(OUTPUT)perf-in.o
+
+export srctree OUTPUT RM CC LD AR CFLAGS V
+build := -f $(srctree)/tools/build/Makefile.build dir=. obj
+
+$(PERF_IN): FORCE
+	@$(MAKE) $(build)=perf
+
 $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		$(CFLAGS) -c $(filter %.c,$^) -o $@
 
-$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
+$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(PERF_IN)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
-               $(BUILTIN_OBJS) $(LIBS) -o $@
+               $(BUILTIN_OBJS) $(PERF_IN) $(LIBS) -o $@
 
 $(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
 	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
@@ -989,6 +979,8 @@ config-clean:
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
+	@find . -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
+	@$(RM) .config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
@@ -1004,7 +996,9 @@ else
     GIT-HEAD-PHONY =
 endif
 
+FORCE:
+
 .PHONY: all install clean config-clean strip install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
+.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS FORCE
 
diff --git a/tools/perf/bench/Build b/tools/perf/bench/Build
new file mode 100644
index 000000000000..5ce98023d518
--- /dev/null
+++ b/tools/perf/bench/Build
@@ -0,0 +1,11 @@
+perf-y += sched-messaging.o
+perf-y += sched-pipe.o
+perf-y += mem-memcpy.o
+perf-y += futex-hash.o
+perf-y += futex-wake.o
+perf-y += futex-requeue.o
+
+perf-$(CONFIG_X86_64) += mem-memcpy-x86-64-asm.o
+perf-$(CONFIG_X86_64) += mem-memset-x86-64-asm.o
+
+perf-$(CONFIG_NUMA) += numa.o
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index bd60ca04d5da..1938432969ab 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -28,6 +28,7 @@ ifeq ($(ARCH),x86)
     CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
     LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
+    $(call detected,CONFIG_X86_64)
   else
     LIBUNWIND_LIBS = -lunwind -lunwind-x86
   endif
@@ -633,6 +634,7 @@ ifndef NO_LIBNUMA
   else
     CFLAGS += -DHAVE_LIBNUMA_SUPPORT
     EXTLIBS += -lnuma
+    $(call detected,CONFIG_NUMA)
   endif
 endif
 
-- 
1.9.3

