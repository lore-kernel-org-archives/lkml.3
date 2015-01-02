Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbbABPha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:37:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbbABPh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:37:26 -0500
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
Subject: [PATCH 04/30] perf build: Add bench objects building
Date: Fri,  2 Jan 2015 16:35:46 +0100
Message-Id: <1420212972-21595-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
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
 tools/perf/Makefile.perf   | 21 ++-------------------
 tools/perf/bench/Build     | 11 +++++++++++
 tools/perf/config/Makefile |  2 ++
 4 files changed, 17 insertions(+), 19 deletions(-)
 create mode 100644 tools/perf/bench/Build

diff --git a/tools/perf/Build b/tools/perf/Build
index e69de29bb2d1..9ea828de3fde 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -0,0 +1,2 @@
+perf-y += builtin-bench.o
+perf-y += bench/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f578e1a91250..6d0be78763ec 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -459,19 +459,6 @@ LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
-BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
-# Benchmark modules
-BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
-BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(RAW_ARCH),x86_64)
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
-endif
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
-BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
-BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
-BUILTIN_OBJS += $(OUTPUT)bench/futex-requeue.o
-
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
 BUILTIN_OBJS += $(OUTPUT)builtin-help.o
@@ -590,10 +577,6 @@ ifeq ($(NO_PERF_REGS),0)
   LIB_OBJS += $(OUTPUT)util/perf_regs.o
 endif
 
-ifndef NO_LIBNUMA
-  BUILTIN_OBJS += $(OUTPUT)bench/numa.o
-endif
-
 ifndef NO_ZLIB
   LIB_OBJS += $(OUTPUT)util/zlib.o
 endif
@@ -633,9 +616,9 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		$(CFLAGS) -c $(filter %.c,$^) -o $@
 
-$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
+$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(PERF_IN)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
-               $(BUILTIN_OBJS) $(LIBS) -o $@
+               $(BUILTIN_OBJS) $(PERF_IN) $(LIBS) -o $@
 
 $(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
 	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
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
index f6538544c740..3c73e11954ea 100644
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

