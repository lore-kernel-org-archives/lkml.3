Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049AbaGQQPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:15:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:52791 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922AbaGQQPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:15:19 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/33] perf tools: Allow TSC conversion on any arch
Date: Thu, 17 Jul 2014 13:12:35 -0300
Message-Id: <1405613555-23380-34-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

It is possible to record a perf.data file on one architecture and
process it on another.

Consequently, TSC conversion functions need to be moved out of the arch
directory.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-40-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 90c498378a54..3308b22a1660 100644
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
@@ -374,6 +375,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/tsc.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 40021fa3129b..3655f24c3170 100644
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
index 2affe0366b59..2edc4d31065c 100644
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
index 3b7cd4d32dcb..0372f6edca20 100644
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
index 000000000000..ef4749836ce9
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
index 000000000000..4eca84887c8a
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
1.9.3

