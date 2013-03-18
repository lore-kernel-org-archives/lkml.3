Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3CRQ34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:29:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49417
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab3CRQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 51/54] perf test: Add test case for checking number of EXIT events
Date: Mon, 18 Mar 2013 13:25:36 -0300
Message-Id: <1363623939-10748-52-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The new test__task_exit() test runs a simple "/usr/bin/true" workload and then
checks whether the number of EXIT event is 1 or not.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/87obeljax4.fsf@sejong.aot.lge.com
[ committer note: Fixup conflicts with f4c66b4 ( bp overflow tests ) ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |    1 +
 tools/perf/tests/builtin-test.c |    4 +
 tools/perf/tests/task-exit.c    |  123 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |    1 +
 4 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/tests/task-exit.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 990e9a1..8e1bba3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -513,6 +513,7 @@ LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
+LIB_OBJS += $(OUTPUT)tests/task-exit.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 45d9ad4..9b5c70a 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -86,6 +86,10 @@ static struct test {
 		.func = test__bp_signal_overflow,
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
index 0000000..28fe589
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
index 6cf1ec4..b33b328 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -25,5 +25,6 @@ int test__hists_link(void);
 int test__python_use(void);
 int test__bp_signal(void);
 int test__bp_signal_overflow(void);
+int test__task_exit(void);
 
 #endif /* TESTS_H */
-- 
1.7.1

