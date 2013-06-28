Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3F1NRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:17:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:34875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3F1NRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:17:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="361090271"
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
Subject: [PATCH 5/5] perf tools: add 'keep tracking' test
Date: Fri, 28 Jun 2013 16:22:21 +0300
Message-Id: <1372425741-1676-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a test for the newly added 'keep tracking' flag for
the PERF_EVENT_IOC_DISABLE IOCTL.  The test checks that
comm events are present when the event is disabled with
the 'keep tracking' flag set.  The test also checks that
comm events are not present when the event is disabled
without the flag set.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile              |   1 +
 tools/perf/tests/builtin-test.c  |   4 +
 tools/perf/tests/keep-tracking.c | 168 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h         |   1 +
 tools/perf/util/evlist.c         |  32 ++++++++
 tools/perf/util/evlist.h         |   5 ++
 6 files changed, 211 insertions(+)
 create mode 100644 tools/perf/tests/keep-tracking.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7a8dc89..9c3642f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -393,6 +393,7 @@ LIB_OBJS += $(OUTPUT)tests/sw-clock.o
 ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
 endif
+LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b7b4049..b0b2b88 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -100,6 +100,10 @@ static struct test {
 	},
 #endif
 	{
+		.desc = "Test event disable IOCTL 'keep tracking' flag",
+		.func = test__keep_tracking,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
new file mode 100644
index 0000000..ce6a1a1
--- /dev/null
+++ b/tools/perf/tests/keep-tracking.c
@@ -0,0 +1,168 @@
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/prctl.h>
+
+#include "parse-events.h"
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "tests.h"
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
+static int find_comm(struct perf_evlist *evlist, const char *comm)
+{
+	union perf_event *event;
+	int i, found;
+
+	found = 0;
+	for (i = 0; i < evlist->nr_mmaps; i++) {
+		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+			if (event->header.type == PERF_RECORD_COMM &&
+			    (pid_t)event->comm.pid == getpid() &&
+			    (pid_t)event->comm.tid == getpid() &&
+			    strcmp(event->comm.comm, comm) == 0)
+				found += 1;
+		}
+	}
+	return found;
+}
+
+/**
+ * test__keep_tracking - test event disable IOCTL with 'keep tracking' flag.
+ *
+ * This function implements a test that checks that tracking events continue
+ * when an event is disabled with the 'keep tracking flag'.  If the test passes
+ * %0 is returned, otherwise %-1 is returned.
+ */
+int test__keep_tracking(void)
+{
+	struct perf_record_opts opts = {
+		.mmap_pages	     = UINT_MAX,
+		.user_freq	     = UINT_MAX,
+		.user_interval	     = ULLONG_MAX,
+		.freq		     = 4000,
+		.target		     = {
+			.uses_mmap   = true,
+		},
+	};
+	struct thread_map *threads = NULL;
+	struct cpu_map *cpus = NULL;
+	struct perf_evlist *evlist = NULL;
+	struct perf_evsel *evsel = NULL;
+	int found, err = -1;
+	const char *comm;
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
+	/*
+	 * First, test that a 'comm' event can be found when the event is
+	 * enabled.
+	 */
+
+	perf_evlist__enable(evlist);
+
+	comm = "Test COMM 1";
+	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0));
+
+	perf_evlist__disable(evlist);
+
+	found = find_comm(evlist, comm);
+	if (found != 1) {
+		pr_debug("Failed to find tracking event.\n");
+		goto out_err;
+	}
+
+	/*
+	 * Secondly, test that a 'comm' event cannot be found when the event is
+	 * disabled without the 'keep tracking' flag.
+	 */
+
+	perf_evlist__enable(evlist);
+
+	CHECK__(perf_evlist__disable_event(evlist, evsel, 0));
+
+	comm = "Test COMM 2";
+	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0));
+
+	perf_evlist__disable(evlist);
+
+	found = find_comm(evlist, comm);
+	if (found) {
+		pr_debug("Found tracking event with the event disabled.\n");
+		goto out_err;
+	}
+
+	/*
+	 * Finally, test that a 'comm' event can be found when the event is
+	 * disabled with the 'keep tracking' flag.
+	 */
+
+	perf_evlist__enable(evlist);
+
+	CHECK__(perf_evlist__disable_event(evlist, evsel,
+					   PERF_IOC_KEEP_TRACKING));
+
+	comm = "Test COMM 3";
+	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0));
+
+	perf_evlist__disable(evlist);
+
+	found = find_comm(evlist, comm);
+	if (found != 1) {
+		pr_debug("PERF_IOC_KEEP_TRACKING flag had no effect.\n");
+		goto out_err;
+	}
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
index 107696e..971172a 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -28,5 +28,6 @@ int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
 int test__perf_time_to_tsc(void);
+int test__keep_tracking(void);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 78331da..abaf63b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -303,6 +303,38 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	}
 }
 
+int perf_evlist__disable_event(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel, int flags)
+{
+	int cpu, thread, err;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		for (thread = 0; thread < evlist->threads->nr; thread++) {
+			err = ioctl(FD(evsel, cpu, thread),
+				    PERF_EVENT_IOC_DISABLE, flags);
+			if (err)
+				return err;
+		}
+	}
+	return 0;
+}
+
+int perf_evlist__enable_event(struct perf_evlist *evlist,
+			      struct perf_evsel *evsel, int flags)
+{
+	int cpu, thread, err;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		for (thread = 0; thread < evlist->threads->nr; thread++) {
+			err = ioctl(FD(evsel, cpu, thread),
+				    PERF_EVENT_IOC_ENABLE, flags);
+			if (err)
+				return err;
+		}
+	}
+	return 0;
+}
+
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nr_cpus = cpu_map__nr(evlist->cpus);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b1be475..3531516 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -104,6 +104,11 @@ void perf_evlist__munmap(struct perf_evlist *evlist);
 void perf_evlist__disable(struct perf_evlist *evlist);
 void perf_evlist__enable(struct perf_evlist *evlist);
 
+int perf_evlist__disable_event(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel, int flags);
+int perf_evlist__enable_event(struct perf_evlist *evlist,
+			      struct perf_evsel *evsel, int flags);
+
 void perf_evlist__set_selected(struct perf_evlist *evlist,
 			       struct perf_evsel *evsel);
 
-- 
1.7.11.7

