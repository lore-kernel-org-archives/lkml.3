Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3A1Bws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 20:52:48 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:36154 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756371Ab3A1Bwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 20:52:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] perf: Make numa benchmark optional
Date: Sun, 27 Jan 2013 20:51:22 -0500
Message-Id: <1359337882-21821-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1354913744-29902-2-git-send-email-mingo@kernel.org>
References: <1354913744-29902-2-git-send-email-mingo@kernel.org>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "perf: Add 'perf bench numa mem'..." added a NUMA performance
benchmark to perf. Make this optional and test for required
dependencies.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 tools/perf/Makefile                 | 16 ++++++++++++++--
 tools/perf/builtin-bench.c          |  4 ++++
 tools/perf/config/feature-tests.mak | 11 +++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bd9f088..b91dcb0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -47,6 +47,8 @@ include config/utilities.mak
 # backtrace post unwind.
 #
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
+#
+# Define NO_LIBNUMA if you do not want numa perf benchmark
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -104,7 +106,7 @@ ifdef PARSER_DEBUG
 endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm -lnuma
+EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -491,7 +493,6 @@ LIB_OBJS += $(OUTPUT)tests/pmu.o
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
-BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
 ifeq ($(RAW_ARCH),x86_64)
@@ -840,6 +841,17 @@ ifndef NO_BACKTRACE
        endif
 endif
 
+ifndef NO_LIBNUMA
+	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
+	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+		msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
+	else
+		BASIC_CFLAGS += -DLIBNUMA_SUPPORT
+		BUILTIN_OBJS += $(OUTPUT)bench/numa.o
+		EXTLIBS += -lnuma
+	endif
+endif
+
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 441cdb4..3a5c616 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -35,6 +35,7 @@ struct bench_suite {
 /* sentinel: easy for help */
 #define suite_all { "all", "Test all benchmark suites", NULL }
 
+#ifdef LIBNUMA_SUPPORT
 static struct bench_suite numa_suites[] = {
 	{ "mem",
 	  "Benchmark for NUMA workloads",
@@ -44,6 +45,7 @@ static struct bench_suite numa_suites[] = {
 	  NULL,
 	  NULL                  }
 };
+#endif
 
 static struct bench_suite sched_suites[] = {
 	{ "messaging",
@@ -78,9 +80,11 @@ struct bench_subsys {
 };
 
 static struct bench_subsys subsystems[] = {
+#ifdef LIBNUMA_SUPPORT
 	{ "numa",
 	  "NUMA scheduling and MM behavior",
 	  numa_suites },
+#endif
 	{ "sched",
 	  "scheduler and IPC mechanism",
 	  sched_suites },
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index f5ac774..b4eabb4 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -225,3 +225,14 @@ int main(void)
 	return on_exit(NULL, NULL);
 }
 endef
+
+define SOURCE_LIBNUMA
+#include <numa.h>
+#include <numaif.h>
+
+int main(void)
+{
+	numa_available();
+	return 0;
+}
+endef
\ No newline at end of file
-- 
1.8.1.1

