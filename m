Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3HGNYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:24:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:37973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932921Ab3HGNYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:24:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,833,1367996400"; 
   d="scan'208";a="377485419"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf tools: add 'keep tracking' test
Date: Wed,  7 Aug 2013 16:30:31 +0300
Message-Id: <1375882231-18339-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
References: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/tests/builtin-test.c  |   4 ++
 tools/perf/tests/keep-tracking.c | 150 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h         |   1 +
 tools/perf/util/evlist.c         |  42 ++++++++++-
 tools/perf/util/evlist.h         |   5 ++
 6 files changed, 201 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/tests/keep-tracking.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bfd12d0..0193e7c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -392,6 +392,7 @@ LIB_OBJS += $(OUTPUT)tests/sw-clock.o
 ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
 endif
+LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b7b4049..2a468a1 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -100,6 +100,10 @@ static struct test {
 	},
 #endif
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
index 0000000..74abe00
--- /dev/null
+++ b/tools/perf/tests/keep-tracking.c
@@ -0,0 +1,150 @@
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
index d22202a..3cf420c 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -36,5 +36,6 @@ int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
 int test__perf_time_to_tsc(void);
+int test__keep_tracking(void);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index da2dd92..c9b4ef3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -232,7 +232,7 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (!perf_evsel__is_group_leader(pos))
+			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
@@ -250,7 +250,7 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (!perf_evsel__is_group_leader(pos))
+			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
@@ -259,6 +259,44 @@ void perf_evlist__enable(struct perf_evlist *evlist)
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
index 327abab..825c90a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -101,6 +101,11 @@ void perf_evlist__munmap(struct perf_evlist *evlist);
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

