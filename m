Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546Ab3DBDzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:24 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:34636 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760525Ab3DBDzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:19 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/23] perf: make numa support based on CONFIG_LIBNUMA
Date: Mon,  1 Apr 2013 21:54:27 -0600
Message-Id: <1364874877-5618-14-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile        |   18 +++++++-----------
 tools/perf/Pconfig         |    5 +++++
 tools/perf/builtin-bench.c |    5 +++--
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 969bdd3..3ada6e7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -33,8 +33,6 @@ include config/utilities.mak
 # Define WERROR=0 to disable treating any warnings as errors.
 #
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
-#
-# Define NO_LIBNUMA if you do not want numa perf benchmark
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -837,15 +835,13 @@ ifndef NO_BACKTRACE
        endif
 endif
 
-ifndef NO_LIBNUMA
-	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
-	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
-		msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
-	else
-		BASIC_CFLAGS += -DLIBNUMA_SUPPORT
-		BUILTIN_OBJS += $(OUTPUT)bench/numa.o
-		EXTLIBS += -lnuma
-	endif
+ifdef CONFIG_LIBNUMA
+    FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
+    ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+        $(error No numa.h found. Please install numa-libs-devel or libnuma-dev or unset CONFIG_LIBNUMA)
+    endif
+    BUILTIN_OBJS += $(OUTPUT)bench/numa.o
+    EXTLIBS += -lnuma
 endif
 
 ifdef ASCIIDOC8
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index bec1ac6..c4e20cc 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -44,3 +44,8 @@ config LIBPERL
 
 config LIBPYTHON
     bool "Enable support for python scripting engine"
+
+config LIBNUMA
+    bool "Enable support for libnuma"
+    help
+        Used for 'perf bench numa mem' benchmark
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 77298bf..176a57d 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -21,6 +21,7 @@
 #include "util/parse-options.h"
 #include "builtin.h"
 #include "bench/bench.h"
+#include <linux/kconfig.h>
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -35,7 +36,7 @@ struct bench_suite {
 /* sentinel: easy for help */
 #define suite_all { "all", "Test all benchmark suites", NULL }
 
-#ifdef LIBNUMA_SUPPORT
+#ifdef CONFIG_LIBNUMA
 static struct bench_suite numa_suites[] = {
 	{ "mem",
 	  "Benchmark for NUMA workloads",
@@ -80,7 +81,7 @@ struct bench_subsys {
 };
 
 static struct bench_subsys subsystems[] = {
-#ifdef LIBNUMA_SUPPORT
+#ifdef CONFIG_LIBNUMA
 	{ "numa",
 	  "NUMA scheduling and MM behavior",
 	  numa_suites },
-- 
1.7.10.1

