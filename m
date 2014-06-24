Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaFXWwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:52:00 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:62025 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaFXWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:50:21 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        namhyung@kernel.org
Subject: [PATCH 08/13] perf kbuild: remove legacy misc build variables
Date: Wed, 25 Jun 2014 00:47:55 +0200
Message-Id: <1403650080-3130-9-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403650080-3130-1-git-send-email-alexis.berlemont@gmail.com>
References: <1403650080-3130-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR4175wXt-Pov8Yu-ke7KG4FRaBCTYouCs=jK3n0CWi3zw@mail.gmail.com>
References: <CAMesUR4175wXt-Pov8Yu-ke7KG4FRaBCTYouCs=jK3n0CWi3zw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBAUDIT (replaced by CONFIG_LIBAUDIT)
Remove HAVE_LIBAUDIT_SUPPORT from CFLAGS (replaced by CONFIG_LIBAUDIT)
Remove HAVE_TIMERFD_SUPPORT (replaced by CONFIG_TIMERFD)
Remove HAVE_ON_EXIT_SUPPORT (replaced by CONFIG_ON_EXIT)
Remove HAVE_BACKTRACE_SUPPORT (replaced by CONFIG_BACKTRACE)
Remove HAVE_LIBNUMA_SUPPORT (replaced by CONFIG_LIBNUMA)
Remove NO_BIONIC (replaced by CONFIG_BIONIC)
---
 tools/perf/Kconfig                    |  4 ++--
 tools/perf/bench/Kbuild               |  2 +-
 tools/perf/builtin-bench.c            |  5 +++--
 tools/perf/builtin-kvm.c              | 13 +++++++------
 tools/perf/builtin-record.c           |  2 ++
 tools/perf/config/Makefile            | 35 +++++++++++++++++------------------
 tools/perf/config/Makefile.fix-config | 32 --------------------------------
 tools/perf/config/Makefile.fix-legacy | 16 ----------------
 tools/perf/util/util.c                |  5 +++--
 9 files changed, 35 insertions(+), 79 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 026ef67..7bee6f4 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -288,8 +288,8 @@ config LIBUNWIND_DIR
 	  Directory holding the libuwind dependency (headers +
 	  libraries).
 
-config NUMA
-	bool "Numa support (bench)"
+config LIBNUMA
+	bool "Libnuma support"
 	default y
         ---help---
 	  The library libnuma offers facilities to configure NUMA
diff --git a/tools/perf/bench/Kbuild b/tools/perf/bench/Kbuild
index e604fe2..863646a 100644
--- a/tools/perf/bench/Kbuild
+++ b/tools/perf/bench/Kbuild
@@ -6,7 +6,7 @@ obj-y += futex-hash.o
 obj-y += futex-requeue.o
 obj-y += futex-wake.o
 
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
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 0d0d9c7..56811c8 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1,3 +1,4 @@
+#include "generated/autoconf.h"
 #include "builtin.h"
 #include "perf.h"
 
@@ -20,7 +21,7 @@
 #include "util/data.h"
 
 #include <sys/prctl.h>
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 #include <sys/timerfd.h>
 #endif
 
@@ -339,7 +340,7 @@ static void init_kvm_event_record(struct perf_kvm_stat *kvm)
 		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static void clear_events_cache_stats(struct list_head *kvm_events_cache)
 {
 	struct list_head *head;
@@ -788,7 +789,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 		pr_info("\nLost events: %" PRIu64 "\n\n", kvm->lost_events);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static int process_lost_event(struct perf_tool *tool,
 			      union perf_event *event __maybe_unused,
 			      struct perf_sample *sample __maybe_unused,
@@ -879,7 +880,7 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 /* keeping the max events to a modest level to keep
  * the processing of samples per mmap smooth.
  */
@@ -1386,7 +1387,7 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	return kvm_events_report_vcpu(kvm);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static struct perf_evlist *kvm_live_event_list(void)
 {
 	struct perf_evlist *evlist;
@@ -1601,7 +1602,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 	if (!strncmp(argv[1], "rep", 3))
 		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 	if (!strncmp(argv[1], "live", 4))
 		return kvm_events_live(&kvm, argc - 1 , argv + 1);
 #endif
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 378b85b..42c127d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,6 +5,8 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
+
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "perf.h"
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9168a21..6c71c5b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -274,12 +274,14 @@ CFLAGS += -I$(LIB_INCLUDE)
 
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
-ifndef NO_BIONIC
+ifdef CONFIG_BIONIC
   $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
     BIONIC := 1
     EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
     EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  else
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_BIONIC)
   endif
 endif
 
@@ -400,12 +402,11 @@ ifndef NO_LIBUNWIND
   LDFLAGS += $(LIBUNWIND_LDFLAGS)
 endif
 
-ifndef NO_LIBAUDIT
+ifdef CONFIG_LIBAUDIT
   ifneq ($(feature-libaudit), 1)
-    msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
-    NO_LIBAUDIT := 1
+    msg := $(warning No libaudit.h found, disables LIBAUDIT support and 'trace' tool, please install audit-libs-devel or libaudit-dev);
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBAUDIT)
   else
-    CFLAGS += -DHAVE_LIBAUDIT_SUPPORT
     EXTLIBS += -laudit
   endif
 endif
@@ -458,10 +459,12 @@ else
   endif
 endif
 
-ifeq ($(feature-timerfd), 1)
-  CFLAGS += -DHAVE_TIMERFD_SUPPORT
-else
-  msg := $(warning No timerfd support. Disables 'perf kvm stat live');
+ifdef CONFIG_TIMERFD
+  ifneq ($(feature-timerfd), 1)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_TIMERFD)
+  else
+    msg := $(warning No timerfd support. Disables 'perf kvm stat live');
+  endif
 endif
 
 disable-python = $(eval $(disable-python_code))
@@ -577,18 +580,17 @@ ifdef CONFIG_LIBIBERTY_ONLY
   endif
 endif
 
-ifndef NO_BACKTRACE
-  ifeq ($(feature-backtrace), 1)
-    CFLAGS += -DHAVE_BACKTRACE_SUPPORT
+ifdef CONFIG_BACKTRACE
+  ifneq ($(feature-backtrace), 1)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_BACKTRACE)
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
@@ -764,9 +766,6 @@ all:
 	$(call store,NO_LIBPYTHON)
 	$(call store,NO_LIBELF)
 	$(call store,NO_LIBUNWIND)
-	$(call store,NO_BACKTRACE)
-	$(call store,NO_LIBNUMA)
-	$(call store,NO_LIBAUDIT)
 	$(call store,NO_LIBBIONIC)
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 3d84008..2ba684b 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -45,36 +45,4 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBUNWIND)
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
-# NO_LIBAUDIT
-ifdef CONFIG_LIBAUDIT
-ifdef NO_LIBAUDIT
-dummy := $(info Disabling CONFIG_LIBAUDIT)
-dummy := $(shell $(CONFIG) -d CONFIG_LIBAUDIT)
-endif
-endif
-
-# NO_LIBBIONIC
-ifdef CONFIG_BIONIC
-ifdef NO_LIBBIONIC
-dummy := $(info Disabling CONFIG_BIONIC)
-dummy := $(shell $(CONFIG) -d CONFIG_BIONIC)
-endif
-endif
-
 all:
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 64dbb1a..8e32b74 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -16,19 +16,3 @@ endif
 ifndef CONFIG_LIBUNWIND
 NO_LIBUNWIND := 1
 endif
-
-ifndef CONFIG_BACKTRACE
-NO_BACKTRACE := 1
-endif
-
-ifndef CONFIG_NUMA
-export NO_LIBNUMA := 1
-endif
-
-ifndef CONFIG_LIBAUDIT
-NO_LIBAUDIT := 1
-endif
-
-ifdef CONFIG_BIONIC
-NO_LIBBIONIC := 1
-endif
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 95aefa7..6d3e07c 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,8 +1,9 @@
+#include "generated/autoconf.h"
 #include "../perf.h"
 #include "util.h"
 #include <api/fs/fs.h>
 #include <sys/mman.h>
-#ifdef HAVE_BACKTRACE_SUPPORT
+#ifdef CONFIG_BACKTRACE
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -240,7 +241,7 @@ int hex2u64(const char *ptr, u64 *long_val)
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifdef HAVE_BACKTRACE_SUPPORT
+#ifdef CONFIG_BACKTRACE
 void dump_stack(void)
 {
 	void *array[16];
-- 
1.9.3

