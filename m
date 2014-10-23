Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaJWWcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:32:50 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:62727 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaJWWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:31:21 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, namhyung@kernel.org, mmarek@suse.cz
Subject: [PATCH v3 09/14] perf kbuild: remove legacy misc build variables
Date: Fri, 24 Oct 2014 00:28:17 +0200
Message-Id: <1414103302-14906-10-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
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
Remove NO_PERF_REGS (replaced by CONFIG_PERF_REGS)

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 tools/perf/Kconfig                    | 12 ++++++++--
 tools/perf/arch/arm/tests/Kbuild      |  2 +-
 tools/perf/arch/x86/tests/Kbuild      |  2 +-
 tools/perf/bench/Kbuild               |  2 +-
 tools/perf/builtin-bench.c            |  5 ++--
 tools/perf/builtin-kvm.c              | 13 ++++++-----
 tools/perf/builtin-record.c           |  2 ++
 tools/perf/config/Makefile            | 43 +++++++++++++----------------------
 tools/perf/config/Makefile.fix-config | 32 --------------------------
 tools/perf/config/Makefile.fix-legacy | 16 -------------
 tools/perf/util/perf_regs.c           |  3 +++
 tools/perf/util/perf_regs.h           |  6 +++--
 tools/perf/util/util.c                |  5 ++--
 13 files changed, 51 insertions(+), 92 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 5f85923..29853a6 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -312,8 +312,8 @@ config LIBUNWIND_DIR
 	  Directory holding the libuwind dependency (headers +
 	  libraries).
 
-config NUMA
-	bool "Numa support (bench)"
+config LIBNUMA
+	bool "Libnuma support"
 	default y
         ---help---
 	  The library libnuma offers facilities to configure NUMA
@@ -327,6 +327,14 @@ config BIONIC
 	  library code developed by Google for their Android operating
 	  system.
 
+config PERF_REGS
+	bool "Cache register accesses"
+	depends on (ARCH = "x86" || ARCH = "arm" || ARCH = "arm64")
+	default y
+        ---help---
+	  Cache register accesses for unwind processing to speed-up
+	  performances.
+
 endmenu
 
 menu "Build"
diff --git a/tools/perf/arch/arm/tests/Kbuild b/tools/perf/arch/arm/tests/Kbuild
index 5d63e9d..1318ed0 100644
--- a/tools/perf/arch/arm/tests/Kbuild
+++ b/tools/perf/arch/arm/tests/Kbuild
@@ -1,2 +1,2 @@
-obj-y += regs_load.o
+obj-$(CONFIG_PERF_REGS) += regs_load.o
 obj-y += dwarf-unwind.o
diff --git a/tools/perf/arch/x86/tests/Kbuild b/tools/perf/arch/x86/tests/Kbuild
index 3b5aa14..8287dae 100644
--- a/tools/perf/arch/x86/tests/Kbuild
+++ b/tools/perf/arch/x86/tests/Kbuild
@@ -1,3 +1,3 @@
 obj-y += perf-time-to-tsc.o
-obj-y += regs_load.o
+obj-$(CONFIG_PERF_REGS) += regs_load.o
 obj-y += dwarf-unwind.o
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
index b9a56fa..5116d25 100644
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
index 400e92e..28371f9 100644
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
 
@@ -123,7 +124,7 @@ static void init_kvm_event_record(struct perf_kvm_stat *kvm)
 		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static void clear_events_cache_stats(struct list_head *kvm_events_cache)
 {
 	struct list_head *head;
@@ -622,7 +623,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 		pr_info("\nLost events: %" PRIu64 "\n\n", kvm->lost_events);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static int process_lost_event(struct perf_tool *tool,
 			      union perf_event *event __maybe_unused,
 			      struct perf_sample *sample __maybe_unused,
@@ -707,7 +708,7 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 /* keeping the max events to a modest level to keep
  * the processing of samples per mmap smooth.
  */
@@ -1199,7 +1200,7 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	return kvm_events_report_vcpu(kvm);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static struct perf_evlist *kvm_live_event_list(void)
 {
 	struct perf_evlist *evlist;
@@ -1414,7 +1415,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 	if (!strncmp(argv[1], "rep", 3))
 		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 	if (!strncmp(argv[1], "live", 4))
 		return kvm_events_live(&kvm, argc - 1 , argv + 1);
 #endif
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2583a9b..dbba96c 100644
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
index 7f87a45..5be574c3 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -16,8 +16,6 @@ CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
 
 include $(src-perf)/config/Makefile.arch
 
-NO_PERF_REGS := 1
-
 # Additional ARCH settings for x86
 ifeq ($(ARCH),x86)
   ifeq ($(IS_X86_64),1)
@@ -26,16 +24,13 @@ ifeq ($(ARCH),x86)
   else
     LIBUNWIND_LIBS = -lunwind -lunwind-x86
   endif
-  NO_PERF_REGS := 0
 endif
 
 ifeq ($(ARCH),arm)
-  NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
 ifeq ($(ARCH),arm64)
-  NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
 endif
 
@@ -68,10 +63,6 @@ else
   FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS)
 endif
 
-ifeq ($(NO_PERF_REGS),0)
-  CFLAGS += -DHAVE_PERF_REGS_SUPPORT
-endif
-
 ifndef NO_LIBELF
   # for linking with debug library, run like:
   # make DEBUG=1 LIBDW_DIR=/opt/libdw/
@@ -301,12 +292,14 @@ ifeq ($(feature-sync-compare-and-swap), 1)
   CFLAGS += -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
 endif
 
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
 
@@ -433,12 +426,11 @@ ifndef NO_LIBUNWIND
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
@@ -491,10 +483,11 @@ else
   endif
 endif
 
-ifeq ($(feature-timerfd), 1)
-  CFLAGS += -DHAVE_TIMERFD_SUPPORT
-else
-  msg := $(warning No timerfd support. Disables 'perf kvm stat live');
+ifdef CONFIG_TIMERFD
+  ifneq ($(feature-timerfd), 1)
+    msg := $(warning No timerfd support. Disables 'perf kvm stat live');
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_TIMERFD)
+  endif
 endif
 
 disable-python = $(eval $(disable-python_code))
@@ -603,18 +596,17 @@ ifdef CONFIG_LIBIBERTY_ONLY
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
@@ -797,9 +789,6 @@ all:
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
diff --git a/tools/perf/util/perf_regs.c b/tools/perf/util/perf_regs.c
index 43168fb..01720b5 100644
--- a/tools/perf/util/perf_regs.c
+++ b/tools/perf/util/perf_regs.c
@@ -1,7 +1,9 @@
 #include <errno.h>
+#include "generated/autoconf.h"
 #include "perf_regs.h"
 #include "event.h"
 
+#ifdef CONFIG_PERF_REGS
 int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
 {
 	int i, idx = 0;
@@ -25,3 +27,4 @@ out:
 	*valp = regs->cache_regs[id];
 	return 0;
 }
+#endif /* CONFIG_PERF_REGS */
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 980dbf7..44d9b08 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,11 +1,13 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
+#include <linux/compiler.h>
 #include <linux/types.h>
+#include "generated/autoconf.h"
 
 struct regs_dump;
 
-#ifdef HAVE_PERF_REGS_SUPPORT
+#ifdef CONFIG_PERF_REGS
 #include <perf_regs.h>
 
 int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
@@ -25,5 +27,5 @@ static inline int perf_reg_value(u64 *valp __maybe_unused,
 {
 	return 0;
 }
-#endif /* HAVE_PERF_REGS_SUPPORT */
+#endif /* CONFIG_PERF_REGS */
 #endif /* __PERF_REGS_H */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index d5eab3f..17667d8 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,9 +1,10 @@
+#include "generated/autoconf.h"
 #include "../perf.h"
 #include "util.h"
 #include "debug.h"
 #include <api/fs/fs.h>
 #include <sys/mman.h>
-#ifdef HAVE_BACKTRACE_SUPPORT
+#ifdef CONFIG_BACKTRACE
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -250,7 +251,7 @@ int hex2u64(const char *ptr, u64 *long_val)
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifdef HAVE_BACKTRACE_SUPPORT
+#ifdef CONFIG_BACKTRACE
 void dump_stack(void)
 {
 	void *array[16];
-- 
2.1.1

