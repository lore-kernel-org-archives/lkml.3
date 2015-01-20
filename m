Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbbATQlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:41:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbbATQlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:41:13 -0500
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
Subject: [PATCH 10/36] perf build: Add probe objects building
Date: Tue, 20 Jan 2015 17:39:07 +0100
Message-Id: <1421771973-6022-11-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the probe objects building under build framework
to be included in the libperf build object.

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
 tools/perf/Build           |  1 +
 tools/perf/Makefile.perf   | 19 +------------------
 tools/perf/config/Makefile |  1 +
 tools/perf/util/Build      |  7 +++++++
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Build b/tools/perf/Build
index 31c4c555cc81..170e4563bb24 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -20,6 +20,7 @@ perf-y += builtin-inject.o
 perf-y += builtin-mem.o
 
 perf-$(CONFIG_AUDIT) += builtin-trace.o
+perf-$(CONFIG_LIBELF) += builtin-probe.o
 
 perf-y += bench/
 perf-y += tests/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e0b1c2227e5b..0cbce83c7244 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -327,9 +327,6 @@ LIB_H += util/data.h
 LIB_H += util/kvm-stat.h
 LIB_H += util/thread-stack.h
 
-LIB_OBJS += $(OUTPUT)util/symbol-elf.o
-LIB_OBJS += $(OUTPUT)util/probe-event.o
-
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/progress.o
@@ -337,8 +334,6 @@ LIB_OBJS += $(OUTPUT)ui/util.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
-BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
-
 PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
@@ -351,19 +346,7 @@ ifneq ($(OUTPUT),)
   CFLAGS += -I$(OUTPUT)
 endif
 
-ifdef NO_LIBELF
-# Remove ELF/DWARF dependent codes
-LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/probe-finder.o,$(LIB_OBJS))
-
-BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
-
-# Use minimal symbol handling
-LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
-
-else # NO_LIBELF
+ifndef NO_LIBELF
 ifndef NO_DWARF
   LIB_OBJS += $(OUTPUT)util/probe-finder.o
   LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0b61ec2c667d..1a3720f2cdbb 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -365,6 +365,7 @@ endif # NO_LIBELF
 ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
   EXTLIBS += -lelf
+  $(call detected,CONFIG_LIBELF)
 
   ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index c107f309d29f..73a0411e2014 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -75,6 +75,13 @@ libperf-y += tsc.o
 libperf-y += cloexec.o
 libperf-y += thread-stack.o
 
+libperf-$(CONFIG_LIBELF) += symbol-elf.o
+libperf-$(CONFIG_LIBELF) += probe-event.o
+
+ifndef CONFIG_LIBELF
+libperf-y += symbol-minimal.o
+endif
+
 CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
 
-- 
1.9.3

