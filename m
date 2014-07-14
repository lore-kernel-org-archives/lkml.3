Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaGNKI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:08:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:30222 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbaGNKGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:06:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434925"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 39/41] perf tools: Allow TSC conversion on any arch
Date: Mon, 14 Jul 2014 13:03:03 +0300
Message-Id: <1405332185-4050-40-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to record a perf.data file on
one architecture and process it on another.
Consequently, TSC conversion functions need
to be moved out of the arch directory.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf            |  2 ++
 tools/perf/arch/x86/util/tsc.c      | 22 +---------------------
 tools/perf/arch/x86/util/tsc.h      |  3 ---
 tools/perf/tests/perf-time-to-tsc.c |  3 +--
 tools/perf/util/tsc.c               | 25 +++++++++++++++++++++++++
 tools/perf/util/tsc.h               | 11 +++++++++++
 6 files changed, 40 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/util/tsc.c
 create mode 100644 tools/perf/util/tsc.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..abca577 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -295,6 +295,7 @@ LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += util/vdso.h
+LIB_H += util/tsc.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -373,6 +374,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/tsc.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 40021fa..3655f24 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -6,29 +6,9 @@
 #include "../../perf.h"
 #include <linux/types.h>
 #include "../../util/debug.h"
+#include "../../util/tsc.h"
 #include "tsc.h"
 
-u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
-{
-	u64 t, quot, rem;
-
-	t = ns - tc->time_zero;
-	quot = t / tc->time_mult;
-	rem  = t % tc->time_mult;
-	return (quot << tc->time_shift) +
-	       (rem << tc->time_shift) / tc->time_mult;
-}
-
-u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc)
-{
-	u64 quot, rem;
-
-	quot = cyc >> tc->time_shift;
-	rem  = cyc & ((1 << tc->time_shift) - 1);
-	return tc->time_zero + quot * tc->time_mult +
-	       ((rem * tc->time_mult) >> tc->time_shift);
-}
-
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc)
 {
diff --git a/tools/perf/arch/x86/util/tsc.h b/tools/perf/arch/x86/util/tsc.h
index 2affe03..2edc4d3 100644
--- a/tools/perf/arch/x86/util/tsc.h
+++ b/tools/perf/arch/x86/util/tsc.h
@@ -14,7 +14,4 @@ struct perf_event_mmap_page;
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc);
 
-u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
-u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
-
 #endif /* TOOLS_PERF_ARCH_X86_UTIL_TSC_H__ */
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 3b7cd4d..0372f6e 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -8,10 +8,9 @@
 #include "evsel.h"
 #include "thread_map.h"
 #include "cpumap.h"
+#include "tsc.h"
 #include "tests.h"
 
-#include "../arch/x86/util/tsc.h"
-
 #define CHECK__(x) {				\
 	while ((x) < 0) {			\
 		pr_debug(#x " failed!\n");	\
diff --git a/tools/perf/util/tsc.c b/tools/perf/util/tsc.c
new file mode 100644
index 0000000..ef4749836
--- /dev/null
+++ b/tools/perf/util/tsc.c
@@ -0,0 +1,25 @@
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#include "tsc.h"
+
+u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
+{
+	u64 t, quot, rem;
+
+	t = ns - tc->time_zero;
+	quot = t / tc->time_mult;
+	rem  = t % tc->time_mult;
+	return (quot << tc->time_shift) +
+	       (rem << tc->time_shift) / tc->time_mult;
+}
+
+u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc)
+{
+	u64 quot, rem;
+
+	quot = cyc >> tc->time_shift;
+	rem  = cyc & ((1 << tc->time_shift) - 1);
+	return tc->time_zero + quot * tc->time_mult +
+	       ((rem * tc->time_mult) >> tc->time_shift);
+}
diff --git a/tools/perf/util/tsc.h b/tools/perf/util/tsc.h
new file mode 100644
index 0000000..4eca848
--- /dev/null
+++ b/tools/perf/util/tsc.h
@@ -0,0 +1,11 @@
+#ifndef __PERF_TSC_H
+#define __PERF_TSC_H
+
+#include <linux/types.h>
+
+#include "../arch/x86/util/tsc.h"
+
+u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
+u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
+
+#endif
-- 
1.8.3.2

