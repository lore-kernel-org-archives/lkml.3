Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3A2KsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:48:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab3A2KsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:48:16 -0500
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/2] perf: Make -lnuma optional
Date: Tue, 29 Jan 2013 11:48:12 +0100
Message-Id: <1359456492-22156-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

a0c17eadf3bf9 ("perf: Add 'perf bench numa mem' NUMA performance
measurement suite") added -lnuma to the EXTLIBS but we use those when
checking for other libraries like libelf, libunwind, etc and the checks
failed even when the dev libraries are installed on the system:

    CHK libelf
/usr/bin/ld: cannot find -lnuma
collect2: error: ld returned 1 exit status
    CHK glibc
Makefile:552: No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev
    CHK libunwind
/usr/bin/ld: cannot find -lnuma
collect2: error: ld returned 1 exit status
Makefile:586: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99
...

So, add glue to detect the presence of -lnuma and build perf bench numa
only then.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/perf/Makefile                 | 7 +++++++
 tools/perf/builtin-bench.c          | 4 ++++
 tools/perf/config/feature-tests.mak | 9 +++++++++
 3 files changed, 20 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b62dbc0d974a..2f6558404620 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -533,6 +533,13 @@ ifneq ($(MAKECMDGOALS),tags)
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
+#
+FLAGS_NUMA=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_NUMA),$(FLAGS_NUMA),libnuma),y)
+	BASIC_CFLAGS += -DNO_NUMA
+	EXTLIBS := $(filter-out -lnuma,$(EXTLIBS))
+	BUILTIN_OBJS := $(filter-out $(OUTPUT)bench/numa.o,$(BUILTIN_OBJS))
+endif # NUMA
 
 ifdef NO_LIBELF
 	NO_DWARF := 1
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e5d514bf5365..b4ec5af42ada 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -35,6 +35,7 @@ struct bench_suite {
 /* sentinel: easy for help */
 #define suite_all { "all", "Test all benchmark suites", NULL }
 
+#ifndef NO_NUMA
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
+#ifndef NO_NUMA
 	{ "numa",
 	  "NUMA scheduling and MM behavior",
 	  numa_suites },
+#endif
 	{ "sched",
 	  "scheduler and IPC mechanism",
 	  sched_suites },
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index f5ac77485a4f..a47684b4fe1e 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -225,3 +225,12 @@ int main(void)
 	return on_exit(NULL, NULL);
 }
 endef
+
+define SOURCE_NUMA
+#include <numa.h>
+
+int main(void)
+{
+	return numa_available();
+}
+endef
-- 
1.8.1.rc3

