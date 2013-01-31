Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3AaKyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:54:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3AaKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:54:52 -0500
Date: Thu, 31 Jan 2013 02:54:27 -0800
From: tip-bot for Peter Hurley <peter@hurleysoftware.com>
Message-ID: <tip-79d824e31692d165f6c7d92bf4d1af0b9d969d76@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peter@hurleysoftware.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        peter@hurleysoftware.com
In-Reply-To: <1359337882-21821-1-git-send-email-peter@hurleysoftware.com>
References: <1359337882-21821-1-git-send-email-peter@hurleysoftware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Make numa benchmark optional
Git-Commit-ID: 79d824e31692d165f6c7d92bf4d1af0b9d969d76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:54:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79d824e31692d165f6c7d92bf4d1af0b9d969d76
Gitweb:     http://git.kernel.org/tip/79d824e31692d165f6c7d92bf4d1af0b9d969d76
Author:     Peter Hurley <peter@hurleysoftware.com>
AuthorDate: Sun, 27 Jan 2013 20:51:22 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:36:21 -0300

perf tools: Make numa benchmark optional

Commit "perf: Add 'perf bench numa mem'..." added a NUMA performance
benchmark to perf. Make this optional and test for required
dependencies.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1359337882-21821-1-git-send-email-peter@hurleysoftware.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 | 16 ++++++++++++++--
 tools/perf/builtin-bench.c          |  4 ++++
 tools/perf/config/feature-tests.mak | 11 +++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b62dbc0..4b1044c 100644
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
@@ -103,7 +105,7 @@ ifdef PARSER_DEBUG
 endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm -lnuma
+EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -492,7 +494,6 @@ LIB_OBJS += $(OUTPUT)tests/python-use.o
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
-BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
 ifeq ($(RAW_ARCH),x86_64)
@@ -839,6 +840,17 @@ ifndef NO_BACKTRACE
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
index e5d514b..77298bf 100644
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
