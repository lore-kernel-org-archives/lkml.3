Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbaFCWNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:13:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43055 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbaFCWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:09:03 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 19/32] perf kbuild: remove legacy numa-related build variable
Date: Wed,  4 Jun 2014 00:06:12 +0200
Message-Id: <1401833185-10347-20-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_LIBNUMA_SUPPORT (replaced by CONFIG_LIBNUMA)
---
 tools/perf/Kconfig                    |  4 ++--
 tools/perf/bench/Kbuild               |  2 +-
 tools/perf/builtin-bench.c            |  5 +++--
 tools/perf/config/Makefile            |  8 ++------
 tools/perf/config/Makefile.fix-config | 16 ----------------
 tools/perf/config/Makefile.fix-legacy | 12 ------------
 6 files changed, 8 insertions(+), 39 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index a00bfb6..9bc55fc 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -258,8 +258,8 @@ config LIBUNWIND_DIR
 	  Directory holding the libuwind dependency (headers +
 	  libraries).
 
-config NUMA
-	bool "Numa support (bench)"
+config LIBNUMA
+	bool "Libnuma support"
 	default n
         ---help---
 	  The library libnuma offers facilities to configure NUMA
diff --git a/tools/perf/bench/Kbuild b/tools/perf/bench/Kbuild
index 8883de9..57f87e8 100644
--- a/tools/perf/bench/Kbuild
+++ b/tools/perf/bench/Kbuild
@@ -3,7 +3,7 @@ obj-y += mem-memset.o
 obj-y += sched-messaging.o
 obj-y += sched-pipe.o
 
-obj-$(CONFIG_NUMA) += numa.o
+obj-$(CONFIG_LIBNUMA) += numa.o
 
 obj-$(CONFIG_X86_64) += mem-memcpy-x86-64-asm.o
 obj-$(CONFIG_X86_64) += mem-memset-x86-64-asm.o
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 1e6e777..162b9f5 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -14,6 +14,7 @@
  *  numa  ... NUMA scheduling and MM performance
  *  futex ... Futex performance
  */
+#include "generated/autoconf.h"
 #include "perf.h"
 #include "util/util.h"
 #include "util/parse-options.h"
@@ -33,7 +34,7 @@ struct bench {
 	bench_fn_t	fn;
 };
 
-#ifdef HAVE_LIBNUMA_SUPPORT
+#ifdef CONFIG_LIBNUMA
 static struct bench numa_benchmarks[] = {
 	{ "mem",	"Benchmark for NUMA workloads",			bench_numa		},
 	{ "all",	"Test all NUMA benchmarks",			NULL			},
@@ -72,7 +73,7 @@ struct collection {
 static struct collection collections[] = {
 	{ "sched",	"Scheduler and IPC benchmarks",			sched_benchmarks	},
 	{ "mem",	"Memory access benchmarks",			mem_benchmarks		},
-#ifdef HAVE_LIBNUMA_SUPPORT
+#ifdef CONFIG_LIBNUMA
 	{ "numa",	"NUMA scheduling and MM benchmarks",		numa_benchmarks		},
 #endif
 	{"futex",       "Futex stressing benchmarks",                   futex_benchmarks        },
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 4a21452..770675f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -578,12 +578,11 @@ ifdef CONFIG_BACKTRACE
   endif
 endif
 
-ifndef NO_LIBNUMA
+ifdef CONFIG_LIBNUMA
   ifeq ($(feature-libnuma), 0)
     msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev);
-    NO_LIBNUMA := 1
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBNUMA)
   else
-    CFLAGS += -DHAVE_LIBNUMA_SUPPORT
     EXTLIBS += -lnuma
   endif
 endif
@@ -756,11 +755,8 @@ all:
 	$(call store,CONFIG_X86_64)
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_DEMANGLE)
 	$(call store,NO_LIBELF)
 	$(call store,NO_LIBUNWIND)
-	$(call store,NO_BACKTRACE)
-	$(call store,NO_LIBNUMA)
 	$(call store,NO_LIBBIONIC)
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 6402a47..46842f9 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -37,22 +37,6 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBUNWIND)
 endif
 endif
 
-# NO_BACKTRACE
-ifdef CONFIG_BACKTRACE
-ifdef NO_BACKTRACE
-dummy := $(info Disabling CONFIG_BACKTRACE)
-dummy := $(shell $(CONFIG) -d CONFIG_BACKTRACE)
-endif
-endif
-
-# NO_LIBNUMA
-ifdef CONFIG_NUMA
-ifdef NO_LIBNUMA
-dummy := $(info Disabling CONFIG_NUMA)
-dummy := $(shell $(CONFIG) -d CONFIG_NUMA)
-endif
-endif
-
 # NO_LIBBIONIC
 ifdef CONFIG_BIONIC
 ifdef NO_LIBBIONIC
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 2e93006..15a328e 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -5,10 +5,6 @@ ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
 
-ifndef CONFIG_DEMANGLE
-NO_DEMANGLE := 1
-endif
-
 ifndef CONFIG_LIBELF
 NO_LIBELF := 1
 endif
@@ -17,14 +13,6 @@ ifndef CONFIG_LIBUNWIND
 NO_LIBUNWIND := 1
 endif
 
-ifndef CONFIG_BACKTRACE
-NO_BACKTRACE := 1
-endif
-
-ifndef CONFIG_NUMA
-export NO_LIBNUMA := 1
-endif
-
 ifdef CONFIG_BIONIC
 NO_LIBBIONIC := 1
 endif
-- 
1.9.3

