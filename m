Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbbAZKOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:14:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbbAZKOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:21 -0500
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
Subject: [PATCH 12/36] perf build: Add dwarf unwind objects building
Date: Mon, 26 Jan 2015 11:12:12 +0100
Message-Id: <1422267156-13873-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the dwarf unwind objects building under build
framework to be included in the libperf build object.

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
 tools/perf/Makefile.perf   | 9 ---------
 tools/perf/config/Makefile | 2 ++
 tools/perf/util/Build      | 3 +++
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bfbbac3da604..c680f8a5a4b4 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -346,15 +346,6 @@ ifneq ($(OUTPUT),)
   CFLAGS += -I$(OUTPUT)
 endif
 
-ifndef NO_LIBDW_DWARF_UNWIND
-  LIB_OBJS += $(OUTPUT)util/unwind-libdw.o
-  LIB_H += util/unwind-libdw.h
-endif
-
-ifndef NO_LIBUNWIND
-  LIB_OBJS += $(OUTPUT)util/unwind-libunwind.o
-endif
-
 ifndef NO_SLANG
   LIB_OBJS += $(OUTPUT)ui/browser.o
   LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 20f00b2effb9..2b4b273cf804 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -414,9 +414,11 @@ ifdef NO_LIBUNWIND
     dwarf-post-unwind := 0
   else
     dwarf-post-unwind-text := libdw
+    $(call detected,CONFIG_LIBDW_DWARF_UNWIND)
   endif
 else
   dwarf-post-unwind-text := libunwind
+  $(call detected,CONFIG_LIBUNWIND)
   # Enable libunwind support by default.
   ifndef NO_LIBDW_DWARF_UNWIND
     NO_LIBDW_DWARF_UNWIND := 1
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 10630fbe43c1..0401a80bab09 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -85,6 +85,9 @@ endif
 libperf-$(CONFIG_DWARF) += probe-finder.o
 libperf-$(CONFIG_DWARF) += dwarf-aux.o
 
+libperf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
+libperf-$(CONFIG_LIBUNWIND)          += unwind-libunwind.o
+
 CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
 
-- 
1.9.3

