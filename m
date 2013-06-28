Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3F1NRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:17:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:10827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3F1NQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:16:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="361090206"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 3/5] perf tools: add test for converting perf time to/from TSC
Date: Fri, 28 Jun 2013 16:22:19 +0300
Message-Id: <1372425741-1676-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test uses the newly added cap_usr_time_zero and time_zero of
perf_event_mmap_page.  TSC from rdtsc is compared with the time
from 2 perf events.  The test passes if the calculated times are
all in the correct order.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile                 |   3 +
 tools/perf/arch/x86/Makefile        |   2 +
 tools/perf/arch/x86/util/tsc.c      |  59 ++++++++++++
 tools/perf/arch/x86/util/tsc.h      |  20 ++++
 tools/perf/tests/builtin-test.c     |   6 ++
 tools/perf/tests/perf-time-to-tsc.c | 177 ++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h            |   1 +
 7 files changed, 268 insertions(+)
 create mode 100644 tools/perf/arch/x86/util/tsc.c
 create mode 100644 tools/perf/arch/x86/util/tsc.h
 create mode 100644 tools/perf/tests/perf-time-to-tsc.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 203cb0e..7a8dc89 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -390,6 +390,9 @@ LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
 LIB_OBJS += $(OUTPUT)tests/task-exit.o
 LIB_OBJS += $(OUTPUT)tests/sw-clock.o
+ifeq ($(ARCH),x86)
+LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
+endif
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 815841c..8801fe0 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -6,3 +6,5 @@ ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
+LIB_H += arch/$(ARCH)/util/tsc.h
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
new file mode 100644
index 0000000..f111744
--- /dev/null
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -0,0 +1,59 @@
+#include <stdbool.h>
+#include <errno.h>
+
+#include <linux/perf_event.h>
+
+#include "../../perf.h"
+#include "../../util/types.h"
+#include "../../util/debug.h"
+#include "tsc.h"
+
+u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
+{
+	u64 time, quot, rem;
+
+	time = ns - tc->time_zero;
+	quot = time / tc->time_mult;
+	rem  = time % tc->time_mult;
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
+
+int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
+			     struct perf_tsc_conversion *tc)
+{
+	bool cap_usr_time_zero;
+	u32 seq;
+	int i = 0;
+
+	while (1) {
+		seq = pc->lock;
+		rmb();
+		tc->time_mult = pc->time_mult;
+		tc->time_shift = pc->time_shift;
+		tc->time_zero = pc->time_zero;
+		cap_usr_time_zero = pc->cap_usr_time_zero;
+		rmb();
+		if (pc->lock == seq && !(seq & 1))
+			break;
+		if (++i > 10000) {
+			pr_debug("failed to get perf_event_mmap_page lock\n");
+			return -EINVAL;
+		}
+	}
+
+	if (!cap_usr_time_zero)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
diff --git a/tools/perf/arch/x86/util/tsc.h b/tools/perf/arch/x86/util/tsc.h
new file mode 100644
index 0000000..a24dec8
--- /dev/null
+++ b/tools/perf/arch/x86/util/tsc.h
@@ -0,0 +1,20 @@
+#ifndef TOOLS_PERF_ARCH_X86_UTIL_TSC_H__
+#define TOOLS_PERF_ARCH_X86_UTIL_TSC_H__
+
+#include "../../util/types.h"
+
+struct perf_tsc_conversion {
+	u16 time_shift;
+	u32 time_mult;
+	u64 time_zero;
+};
+
+struct perf_event_mmap_page;
+
+int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
+			     struct perf_tsc_conversion *tc);
+
+u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
+u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
+
+#endif /* TOOLS_PERF_ARCH_X86_UTIL_TSC_H__ */
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 35b45f1466..b7b4049 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -93,6 +93,12 @@ static struct test {
 		.desc = "Test software clock events have valid period values",
 		.func = test__sw_clock_freq,
 	},
+#if defined(__x86_64__) || defined(__i386__)
+	{
+		.desc = "Test converting perf time to TSC",
+		.func = test__perf_time_to_tsc,
+	},
+#endif
 	{
 		.func = NULL,
 	},
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
new file mode 100644
index 0000000..0ab61b1
--- /dev/null
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -0,0 +1,177 @@
+#include <stdio.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <inttypes.h>
+#include <sys/prctl.h>
+
+#include "parse-events.h"
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "tests.h"
+
+#include "../arch/x86/util/tsc.h"
+
+#define CHECK__(x) {				\
+	while ((x) < 0) {			\
+		pr_debug(#x " failed!\n");	\
+		goto out_err;			\
+	}					\
+}
+
+#define CHECK_NOT_NULL__(x) {			\
+	while ((x) == NULL) {			\
+		pr_debug(#x " failed!\n");	\
+		goto out_err;			\
+	}					\
+}
+
+static u64 rdtsc(void)
+{
+	unsigned int low, high;
+
+	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+
+	return low | ((u64)high) << 32;
+}
+
+/**
+ * test__perf_time_to_tsc - test converting perf time to TSC.
+ *
+ * This function implements a test that checks that the conversion of perf time
+ * to and from TSC is consistent with the order of events.  If the test passes
+ * %0 is returned, otherwise %-1 is returned.  If TSC conversion is not
+ * supported then then the test passes but " (not supported)" is printed.
+ */
+int test__perf_time_to_tsc(void)
+{
+	struct perf_record_opts opts = {
+		.mmap_pages	     = UINT_MAX,
+		.user_freq	     = UINT_MAX,
+		.user_interval	     = ULLONG_MAX,
+		.freq		     = 4000,
+		.target		     = {
+			.uses_mmap   = true,
+		},
+		.sample_time	     = true,
+	};
+	struct thread_map *threads = NULL;
+	struct cpu_map *cpus = NULL;
+	struct perf_evlist *evlist = NULL;
+	struct perf_evsel *evsel = NULL;
+	int err = -1, ret, i;
+	const char *comm1, *comm2;
+	struct perf_tsc_conversion tc;
+	struct perf_event_mmap_page *pc;
+	union perf_event *event;
+	u64 test_tsc, comm1_tsc, comm2_tsc;
+	u64 test_time, comm1_time = 0, comm2_time = 0;
+
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
+	CHECK_NOT_NULL__(threads);
+
+	cpus = cpu_map__new(NULL);
+	CHECK_NOT_NULL__(cpus);
+
+	evlist = perf_evlist__new();
+	CHECK_NOT_NULL__(evlist);
+
+	perf_evlist__set_maps(evlist, cpus, threads);
+
+	CHECK__(parse_events(evlist, "cycles:u"));
+
+	perf_evlist__config(evlist, &opts);
+
+	evsel = perf_evlist__first(evlist);
+
+	evsel->attr.comm = 1;
+	evsel->attr.disabled = 1;
+	evsel->attr.enable_on_exec = 0;
+
+	CHECK__(perf_evlist__open(evlist));
+
+	CHECK__(perf_evlist__mmap(evlist, UINT_MAX, false));
+
+	pc = evlist->mmap[0].base;
+	ret = perf_read_tsc_conversion(pc, &tc);
+	if (ret) {
+		if (ret == -EOPNOTSUPP) {
+			fprintf(stderr, " (not supported)");
+			return 0;
+		}
+		goto out_err;
+	}
+
+	perf_evlist__enable(evlist);
+
+	comm1 = "Test COMM 1";
+	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm1, 0, 0, 0));
+
+	test_tsc = rdtsc();
+
+	comm2 = "Test COMM 2";
+	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm2, 0, 0, 0));
+
+	perf_evlist__disable(evlist);
+
+	for (i = 0; i < evlist->nr_mmaps; i++) {
+		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+			struct perf_sample sample;
+
+			if (event->header.type != PERF_RECORD_COMM ||
+			    (pid_t)event->comm.pid != getpid() ||
+			    (pid_t)event->comm.tid != getpid())
+				continue;
+
+			if (strcmp(event->comm.comm, comm1) == 0) {
+				CHECK__(perf_evsel__parse_sample(evsel, event,
+								 &sample));
+				comm1_time = sample.time;
+			}
+			if (strcmp(event->comm.comm, comm2) == 0) {
+				CHECK__(perf_evsel__parse_sample(evsel, event,
+								 &sample));
+				comm2_time = sample.time;
+			}
+		}
+	}
+
+	if (!comm1_time || !comm2_time)
+		goto out_err;
+
+	test_time = tsc_to_perf_time(test_tsc, &tc);
+	comm1_tsc = perf_time_to_tsc(comm1_time, &tc);
+	comm2_tsc = perf_time_to_tsc(comm2_time, &tc);
+
+	pr_debug("1st event perf time %"PRIu64" tsc %"PRIu64"\n",
+		 comm1_time, comm1_tsc);
+	pr_debug("rdtsc          time %"PRIu64" tsc %"PRIu64"\n",
+		 test_time, test_tsc);
+	pr_debug("2nd event perf time %"PRIu64" tsc %"PRIu64"\n",
+		 comm2_time, comm2_tsc);
+
+	if (test_time <= comm1_time ||
+	    test_time >= comm2_time)
+		goto out_err;
+
+	if (test_tsc <= comm1_tsc ||
+	    test_tsc >= comm2_tsc)
+		goto out_err;
+
+	err = 0;
+
+out_err:
+	if (evlist) {
+		perf_evlist__disable(evlist);
+		perf_evlist__munmap(evlist);
+		perf_evlist__close(evlist);
+		perf_evlist__delete(evlist);
+	}
+	if (cpus)
+		cpu_map__delete(cpus);
+	if (threads)
+		thread_map__delete(threads);
+
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index dd7feae..107696e 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -27,5 +27,6 @@ int test__bp_signal(void);
 int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
+int test__perf_time_to_tsc(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

