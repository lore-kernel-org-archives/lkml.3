Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3CRQ3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:29:51 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49424
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974Ab3CRQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:26:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 54/54] perf tests: Add a test case for checking sw clock event frequency
Date: Mon, 18 Mar 2013 13:25:39 -0300
Message-Id: <1363623939-10748-55-git-send-email-acme@infradead.org>
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
 tools/perf/Makefile             |    1 +
 tools/perf/tests/builtin-test.c |    4 +
 tools/perf/tests/sw-clock.c     |  119 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |    1 +
 4 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/tests/sw-clock.c

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
-- 
1.7.1

