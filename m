Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3COI7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:59:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44624 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3COI7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:59:38 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-dd-5142e2f7f20a
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Generate EXIT event only once per task context
References: <1363332433-7637-1-git-send-email-namhyung@kernel.org>
Date: Fri, 15 Mar 2013 17:59:35 +0900
In-Reply-To: <1363332433-7637-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Fri, 15 Mar 2013 16:27:13 +0900")
Message-ID: <87obeljax4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I added a test case for this.  Please take a look on it too.
This patch is based on my previous evlist cleanup patchset:

  https://lkml.org/lkml/2013/3/15/47


Thanks,
Namhyung



>From df86ff1984a2ab89331a10f5e1fc93f09e260ed9 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 15 Mar 2013 14:58:11 +0900
Subject: [PATCH] perf test: Add test case for checking number of EXIT events

The test__task_exit() runs a simple "/usr/bin/true" workload and then
checks whether the number of EXIT event is 1 or not.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile             |   1 +
 tools/perf/tests/builtin-test.c |   4 ++
 tools/perf/tests/task-exit.c    | 123 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 129 insertions(+)
 create mode 100644 tools/perf/tests/task-exit.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3dcd6273a90b..0145df853af4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -511,6 +511,7 @@ LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
+LIB_OBJS += $(OUTPUT)tests/task-exit.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index acb98e0e39f2..dd00e5e444f8 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -78,6 +78,10 @@ static struct test {
 		.func = test__python_use,
 	},
 	{
+		.desc = "Test number of exit event of a simple workload",
+		.func = test__task_exit,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
new file mode 100644
index 000000000000..28fe5894b061
--- /dev/null
+++ b/tools/perf/tests/task-exit.c
@@ -0,0 +1,123 @@
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "tests.h"
+
+#include <signal.h>
+
+static int exited;
+static int nr_exit;
+
+static void sig_handler(int sig)
+{
+	exited = 1;
+
+	if (sig == SIGUSR1)
+		nr_exit = -1;
+}
+
+/*
+ * This test will start a workload that does nothing then it checks
+ * if the number of exit event reported by the kernel is 1 or not
+ * in order to check the kernel returns correct number of event.
+ */
+int test__task_exit(void)
+{
+	int err = -1;
+	union perf_event *event;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist;
+	struct perf_target target = {
+		.uid		= UINT_MAX,
+		.uses_mmap	= true,
+	};
+	const char *argv[] = { "true", NULL };
+
+	signal(SIGCHLD, sig_handler);
+	signal(SIGUSR1, sig_handler);
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL) {
+		pr_debug("perf_evlist__new\n");
+		return -1;
+	}
+	/*
+	 * We need at least one evsel in the evlist, use the default
+	 * one: "cycles".
+	 */
+	err = perf_evlist__add_default(evlist);
+	if (err < 0) {
+		pr_debug("Not enough memory to create evsel\n");
+		goto out_free_evlist;
+	}
+
+	/*
+	 * Create maps of threads and cpus to monitor. In this case
+	 * we start with all threads and cpus (-1, -1) but then in
+	 * perf_evlist__prepare_workload we'll fill in the only thread
+	 * we're monitoring, the one forked there.
+	 */
+	evlist->cpus = cpu_map__dummy_new();
+	evlist->threads = thread_map__new_by_tid(-1);
+	if (!evlist->cpus || !evlist->threads) {
+		err = -ENOMEM;
+		pr_debug("Not enough memory to create thread/cpu maps\n");
+		goto out_delete_maps;
+	}
+
+	err = perf_evlist__prepare_workload(evlist, &target, argv, false, true);
+	if (err < 0) {
+		pr_debug("Couldn't run the workload!\n");
+		goto out_delete_maps;
+	}
+
+	evsel = perf_evlist__first(evlist);
+	evsel->attr.task = 1;
+	evsel->attr.sample_freq = 0;
+	evsel->attr.inherit = 0;
+	evsel->attr.watermark = 0;
+	evsel->attr.wakeup_events = 1;
+	evsel->attr.exclude_kernel = 1;
+
+	err = perf_evlist__open(evlist);
+	if (err < 0) {
+		pr_debug("Couldn't open the evlist: %s\n", strerror(-err));
+		goto out_delete_maps;
+	}
+
+	if (perf_evlist__mmap(evlist, 128, true) < 0) {
+		pr_debug("failed to mmap events: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_close_evlist;
+	}
+
+	perf_evlist__start_workload(evlist);
+
+retry:
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+		if (event->header.type != PERF_RECORD_EXIT)
+			continue;
+
+		nr_exit++;
+	}
+
+	if (!exited || !nr_exit) {
+		poll(evlist->pollfd, evlist->nr_fds, -1);
+		goto retry;
+	}
+
+	if (nr_exit != 1) {
+		pr_debug("received %d EXIT records\n", nr_exit);
+		err = -1;
+	}
+
+	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
+out_free_evlist:
+	perf_evlist__delete(evlist);
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5de0be1ff4b6..4590c10b7e65 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -23,5 +23,6 @@ int test__dso_data(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
+int test__task_exit(void);
 
 #endif /* TESTS_H */
-- 
1.8.1.4

