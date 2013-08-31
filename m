Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3HaSpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:45:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:34803 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab3HaSpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,998,1367996400"; 
   d="scan'208";a="289335861"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 3/3] perf tools: add 'keep tracking' test
Date: Sat, 31 Aug 2013 21:50:53 +0300
Message-Id: <1377975053-3811-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
References: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a test for the newly added PERF_COUNT_SW_DUMMY event.
The test checks that tracking events continue when an
event is disabled but a dummy software event is not
disabled.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile              |   1 +
 tools/perf/tests/builtin-test.c  |   4 +
 tools/perf/tests/keep-tracking.c | 154 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h         |   1 +
 tools/perf/util/evlist.c         |  42 ++++++++++-
 tools/perf/util/evlist.h         |   5 ++
 6 files changed, 205 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/tests/keep-tracking.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ecebfd0..c5dc1ad 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -465,6 +465,7 @@ endif # NO_LIBELF
 ifndef NO_LIBUNWIND
   LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
+LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
 
 ifndef NO_LIBAUDIT
   BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 8ad9415..8bbeba3 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -108,6 +108,10 @@ static struct test {
 		.func = test__sample_parsing,
 	},
 	{
+		.desc = "Test using a dummy software event to keep tracking",
+		.func = test__keep_tracking,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
new file mode 100644
index 0000000..d444ea2
--- /dev/null
+++ b/tools/perf/tests/keep-tracking.c
@@ -0,0 +1,154 @@
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
+ * test__keep_tracking - test using a dummy software event to keep tracking.
+ *
+ * This function implements a test that checks that tracking events continue
+ * when an event is disabled but a dummy software event is not disabled.  If the
+ * test passes %0 is returned, otherwise %-1 is returned.
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
+	CHECK__(parse_events(evlist, "dummy:u"));
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
+	if (perf_evlist__open(evlist) < 0) {
+		fprintf(stderr, " (not supported)");
+		err = 0;
+		goto out_err;
+	}
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
+		pr_debug("First time, failed to find tracking event.\n");
+		goto out_err;
+	}
+
+	/*
+	 * Secondly, test that a 'comm' event can be found when the event is
+	 * disabled with the dummy event still enabled.
+	 */
+
+	perf_evlist__enable(evlist);
+
+	evsel = perf_evlist__last(evlist);
+
+	CHECK__(perf_evlist__disable_event(evlist, evsel));
+
+	comm = "Test COMM 2";
+	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0));
+
+	perf_evlist__disable(evlist);
+
+	found = find_comm(evlist, comm);
+	if (found != 1) {
+		pr_debug("Seconf time, failed to find tracking event.\n");
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
index 83d5b71..c048b58 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -38,5 +38,6 @@ int test__sw_clock_freq(void);
 int test__perf_time_to_tsc(void);
 int test__code_reading(void);
 int test__sample_parsing(void);
+int test__keep_tracking(void);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5df4ca9..b8727ae 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -246,7 +246,7 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (!perf_evsel__is_group_leader(pos))
+			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
@@ -264,7 +264,7 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (!perf_evsel__is_group_leader(pos))
+			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
@@ -273,6 +273,44 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	}
 }
 
+int perf_evlist__disable_event(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel)
+{
+	int cpu, thread, err;
+
+	if (!evsel->fd)
+		return 0;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		for (thread = 0; thread < evlist->threads->nr; thread++) {
+			err = ioctl(FD(evsel, cpu, thread),
+				    PERF_EVENT_IOC_DISABLE, 0);
+			if (err)
+				return err;
+		}
+	}
+	return 0;
+}
+
+int perf_evlist__enable_event(struct perf_evlist *evlist,
+			      struct perf_evsel *evsel)
+{
+	int cpu, thread, err;
+
+	if (!evsel->fd)
+		return -EINVAL;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		for (thread = 0; thread < evlist->threads->nr; thread++) {
+			err = ioctl(FD(evsel, cpu, thread),
+				    PERF_EVENT_IOC_ENABLE, 0);
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
index 841a394..880d713 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -110,6 +110,11 @@ void perf_evlist__munmap(struct perf_evlist *evlist);
 void perf_evlist__disable(struct perf_evlist *evlist);
 void perf_evlist__enable(struct perf_evlist *evlist);
 
+int perf_evlist__disable_event(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel);
+int perf_evlist__enable_event(struct perf_evlist *evlist,
+			      struct perf_evsel *evsel);
+
 void perf_evlist__set_selected(struct perf_evlist *evlist,
 			       struct perf_evsel *evsel);
 
-- 
1.7.11.7

