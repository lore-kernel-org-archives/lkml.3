Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3CULwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:52:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3CULwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:52:44 -0400
Date: Thu, 21 Mar 2013 04:51:11 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-bc96b361cbf90e61d2665b1305cd2c4ac1fd9cfc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1363574507-18808-2-git-send-email-namhyung@kernel.org>
References: <1363574507-18808-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add a test case for checking sw clock event frequency
Git-Commit-ID: bc96b361cbf90e61d2665b1305cd2c4ac1fd9cfc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:51:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc96b361cbf90e61d2665b1305cd2c4ac1fd9cfc
Gitweb:     http://git.kernel.org/tip/bc96b361cbf90e61d2665b1305cd2c4ac1fd9cfc
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 18 Mar 2013 11:41:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 18 Mar 2013 11:43:16 -0300

perf tests: Add a test case for checking sw clock event frequency

This test case checks frequency conversion of hrtimer-based software
clock events (cpu-clock, task-clock) have valid (non-1) periods.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363574507-18808-2-git-send-email-namhyung@kernel.org
[ committer note: Moved .sample_freq to outside named init block to cope with some gcc versions ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |   1 +
 tools/perf/tests/builtin-test.c |   4 ++
 tools/perf/tests/sw-clock.c     | 119 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 125 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8e1bba3..0230b75 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -514,6 +514,7 @@ LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
 LIB_OBJS += $(OUTPUT)tests/task-exit.o
+LIB_OBJS += $(OUTPUT)tests/sw-clock.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 9b5c70a..0918ada 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -90,6 +90,10 @@ static struct test {
 		.func = test__task_exit,
 	},
 	{
+		.desc = "Test software clock events have valid period values",
+		.func = test__sw_clock_freq,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
new file mode 100644
index 0000000..2e41e2d
--- /dev/null
+++ b/tools/perf/tests/sw-clock.c
@@ -0,0 +1,119 @@
+#include <unistd.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sys/mman.h>
+
+#include "tests.h"
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/cpumap.h"
+#include "util/thread_map.h"
+
+#define NR_LOOPS  1000000
+
+/*
+ * This test will open software clock events (cpu-clock, task-clock)
+ * then check their frequency -> period conversion has no artifact of
+ * setting period to 1 forcefully.
+ */
+static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
+{
+	int i, err = -1;
+	volatile int tmp = 0;
+	u64 total_periods = 0;
+	int nr_samples = 0;
+	union perf_event *event;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist;
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_SOFTWARE,
+		.config = clock_id,
+		.sample_type = PERF_SAMPLE_PERIOD,
+		.exclude_kernel = 1,
+		.disabled = 1,
+		.freq = 1,
+	};
+
+	attr.sample_freq = 10000;
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL) {
+		pr_debug("perf_evlist__new\n");
+		return -1;
+	}
+
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_free_evlist;
+	}
+	perf_evlist__add(evlist, evsel);
+
+	evlist->cpus = cpu_map__dummy_new();
+	evlist->threads = thread_map__new_by_tid(getpid());
+	if (!evlist->cpus || !evlist->threads) {
+		err = -ENOMEM;
+		pr_debug("Not enough memory to create thread/cpu maps\n");
+		goto out_delete_maps;
+	}
+
+	perf_evlist__open(evlist);
+
+	err = perf_evlist__mmap(evlist, 128, true);
+	if (err < 0) {
+		pr_debug("failed to mmap event: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_close_evlist;
+	}
+
+	perf_evlist__enable(evlist);
+
+	/* collect samples */
+	for (i = 0; i < NR_LOOPS; i++)
+		tmp++;
+
+	perf_evlist__disable(evlist);
+
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+		struct perf_sample sample;
+
+		if (event->header.type != PERF_RECORD_SAMPLE)
+			continue;
+
+		err = perf_evlist__parse_sample(evlist, event, &sample);
+		if (err < 0) {
+			pr_debug("Error during parse sample\n");
+			goto out_unmap_evlist;
+		}
+
+		total_periods += sample.period;
+		nr_samples++;
+	}
+
+	if ((u64) nr_samples == total_periods) {
+		pr_debug("All (%d) samples have period value of 1!\n",
+			 nr_samples);
+		err = -1;
+	}
+
+out_unmap_evlist:
+	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
+out_free_evlist:
+	perf_evlist__delete(evlist);
+	return err;
+}
+
+int test__sw_clock_freq(void)
+{
+	int ret;
+
+	ret = __test__sw_clock_freq(PERF_COUNT_SW_CPU_CLOCK);
+	if (!ret)
+		ret = __test__sw_clock_freq(PERF_COUNT_SW_TASK_CLOCK);
+
+	return ret;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index b33b328..dd7feae 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -26,5 +26,6 @@ int test__python_use(void);
 int test__bp_signal(void);
 int test__bp_signal_overflow(void);
 int test__task_exit(void);
+int test__sw_clock_freq(void);
 
 #endif /* TESTS_H */
