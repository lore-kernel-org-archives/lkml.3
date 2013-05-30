Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362Ab3E3JyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030335Ab3E3Jxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:53:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tests: Add auxiliary events poll automated test
Date: Thu, 30 May 2013 11:53:07 +0200
Message-Id: <1369907587-8963-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
References: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test creates syscall entry event restricted for
user space (we should get no samples) and accepting
auxiliary events (MMAP, COMM, EXIT, FORK).

We test the poll works properly when only auxiliary
events are received.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile             |   1 +
 tools/perf/tests/aux_poll.c     | 176 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |   4 +
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 182 insertions(+)
 create mode 100644 tools/perf/tests/aux_poll.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74fdd2b..64e3ce8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -386,6 +386,7 @@ LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
 LIB_OBJS += $(OUTPUT)tests/task-exit.o
 LIB_OBJS += $(OUTPUT)tests/sw-clock.o
+LIB_OBJS += $(OUTPUT)tests/aux_poll.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/aux_poll.c b/tools/perf/tests/aux_poll.c
new file mode 100644
index 0000000..8c5922d
--- /dev/null
+++ b/tools/perf/tests/aux_poll.c
@@ -0,0 +1,176 @@
+#include <linux/compiler.h>
+#include <signal.h>
+
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "tests.h"
+
+static int exited;
+
+static void sig_handler(int sig __maybe_unused)
+{
+	exited = 1;
+}
+
+static struct perf_evlist *aux_evlist(void)
+{
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist;
+
+	evlist = perf_evlist__new();
+	if (!evlist)
+		return NULL;
+
+	evsel = perf_evsel__newtp("raw_syscalls", "sys_enter", 0);
+	if (evsel == NULL)
+		goto error;
+
+	perf_evlist__add(evlist, evsel);
+	return evlist;
+
+ error:
+	perf_evlist__delete(evlist);
+	return NULL;
+}
+
+/*
+ * This test creates syscall entry event restricted for
+ * user space (we should get no samples) and accepting
+ * auxiliary events (MMAP, COMM, EXIT, FORK).
+ *
+ * We test the poll works properly when only auxiliary
+ * events are received.
+ *
+ */
+int test__aux_poll(void)
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
+	int try = 11, nr_aux = 0;
+
+	signal(SIGCHLD, sig_handler);
+	signal(SIGUSR1, sig_handler);
+
+	evlist = aux_evlist();
+	if (!evlist) {
+		pr_debug("Not enough memory|privilege to create evlist\n");
+		return -ENOMEM;
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
+	evsel->attr.mmap = 1;
+	evsel->attr.comm = 1;
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
+	/*
+	 * First wait (1 second) if we get any response
+	 * via poll, if not we failed.
+	 */
+	while (--try) {
+		err = poll(evlist->pollfd, evlist->nr_fds, 100);
+		if (err > 0)
+			break;
+		else if (err < 0) {
+			if (errno == EINTR)
+				continue;
+			pr_debug("failed: poll returned %d, errno %d '%s'\n",
+				err, errno, strerror(errno));
+			goto out_close_all;
+		}
+	}
+
+	if (!try) {
+		err = -1;
+		pr_debug("failed: no poll response in 1 sec\n");
+		goto out_close_all;
+	}
+
+	pr_debug("got poll response, try %d\n", try);
+	err = 0;
+
+	/*
+	 * Now make sure that all we receive are
+	 * only auxiliary events.
+	 */
+ retry:
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+		switch (event->header.type) {
+		case PERF_RECORD_MMAP:
+		case PERF_RECORD_COMM:
+		case PERF_RECORD_EXIT:
+		case PERF_RECORD_FORK:
+			nr_aux++;
+			continue;
+		default:
+			pr_debug("failed: we should get only aux events\n");
+			goto out;
+		}
+	}
+
+	if (!exited || !nr_aux) {
+		poll(evlist->pollfd, evlist->nr_fds, -1);
+		goto retry;
+	}
+
+	pr_debug("received %d AUX events\n", nr_aux);
+
+ out:
+	if (nr_aux == 0) {
+		pr_debug("failed: no AUX events received\n");
+		err = -1;
+	}
+
+ out_close_all:
+	perf_evlist__munmap(evlist);
+ out_close_evlist:
+	perf_evlist__close(evlist);
+ out_delete_maps:
+	perf_evlist__delete_maps(evlist);
+	perf_evlist__delete(evlist);
+	return err;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 35b45f1466..2479be8 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -94,6 +94,10 @@ static struct test {
 		.func = test__sw_clock_freq,
 	},
 	{
+		.desc = "Test poll syscall for auxiliary events",
+		.func = test__aux_poll,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index dd7feae..c4dff04 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -27,5 +27,6 @@ int test__bp_signal(void);
 int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
+int test__aux_poll(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

