Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbbAZKO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:14:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbbAZKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:22 -0500
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
Subject: [PATCH 11/36] perf build: Add dwarf objects building
Date: Mon, 26 Jan 2015 11:12:11 +0100
Message-Id: <1422267156-13873-12-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the dwarf objects building under build framework
to be included in the libperf build object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
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
 tools/perf/Makefile.perf   | 7 -------
 tools/perf/config/Makefile | 1 +
 tools/perf/util/Build      | 3 +++
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index a4faa55831a8..bfbbac3da604 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -346,13 +346,6 @@ ifneq ($(OUTPUT),)
   CFLAGS += -I$(OUTPUT)
 endif
 
-ifndef NO_LIBELF
-ifndef NO_DWARF
-  LIB_OBJS += $(OUTPUT)util/probe-finder.o
-  LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
-endif # NO_DWARF
-endif # NO_LIBELF
-
 ifndef NO_LIBDW_DWARF_UNWIND
   LIB_OBJS += $(OUTPUT)util/unwind-libdw.o
   LIB_H += util/unwind-libdw.h
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1a3720f2cdbb..20f00b2effb9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -386,6 +386,7 @@ ifndef NO_LIBELF
       CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
       LDFLAGS += $(LIBDW_LDFLAGS)
       EXTLIBS += -ldw
+      $(call detected,CONFIG_DWARF)
     endif # PERF_HAVE_DWARF_REGS
   endif # NO_DWARF
 endif # NO_LIBELF
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 73a0411e2014..10630fbe43c1 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -82,6 +82,9 @@ ifndef CONFIG_LIBELF
 libperf-y += symbol-minimal.o
 endif
 
+libperf-$(CONFIG_DWARF) += probe-finder.o
+libperf-$(CONFIG_DWARF) += dwarf-aux.o
+
 CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
 
-- 
1.9.3

