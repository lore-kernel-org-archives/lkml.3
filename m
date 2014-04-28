Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaD1MBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:01:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbaD1MBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:01:31 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/7] perf tests: Add thread maps lookup automated tests
Date: Mon, 28 Apr 2014 14:00:01 +0200
Message-Id: <1398686405-31951-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398686405-31951-1-git-send-email-jolsa@kernel.org>
References: <1398686405-31951-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test for memory maps lookup within multiple machines
threads.

The test creates 4 threads and separated memory maps. It checks that we
could use thread__find_addr_map function with thread object based on TID
to find memory maps.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1397490723-1992-2-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf              |   1 +
 tools/perf/perf.h                     |   6 +
 tools/perf/tests/builtin-test.c       |   4 +
 tools/perf/tests/mmap-thread-lookup.c | 233 ++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h              |   1 +
 5 files changed, 245 insertions(+)
 create mode 100644 tools/perf/tests/mmap-thread-lookup.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 0807e4c..16d4f4e 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -416,6 +416,7 @@ ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
 endif
 endif
+LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 5c11eca..ebdad33 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -15,6 +15,9 @@
 #ifndef __NR_futex
 # define __NR_futex 240
 #endif
+#ifndef __NR_gettid
+# define __NR_gettid 224
+#endif
 #endif
 
 #if defined(__x86_64__)
@@ -29,6 +32,9 @@
 #ifndef __NR_futex
 # define __NR_futex 202
 #endif
+#ifndef __NR_gettid
+# define __NR_gettid 186
+#endif
 #endif
 
 #ifdef __powerpc__
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index ceb9dae..bb60792 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -128,6 +128,10 @@ static struct test {
 		.func = test__hists_filter,
 	},
 	{
+		.desc = "Test mmap thread lookup",
+		.func = test__mmap_thread_lookup,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/mmap-thread-lookup.c b/tools/perf/tests/mmap-thread-lookup.c
new file mode 100644
index 0000000..4a456fe
--- /dev/null
+++ b/tools/perf/tests/mmap-thread-lookup.c
@@ -0,0 +1,233 @@
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <pthread.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include "debug.h"
+#include "tests.h"
+#include "machine.h"
+#include "thread_map.h"
+#include "symbol.h"
+#include "thread.h"
+
+#define THREADS 4
+
+static int go_away;
+
+struct thread_data {
+	pthread_t	pt;
+	pid_t		tid;
+	void		*map;
+	int		ready[2];
+};
+
+static struct thread_data threads[THREADS];
+
+static int thread_init(struct thread_data *td)
+{
+	void *map;
+
+	map = mmap(NULL, page_size,
+		   PROT_READ|PROT_WRITE|PROT_EXEC,
+		   MAP_SHARED|MAP_ANONYMOUS, -1, 0);
+
+	if (map == MAP_FAILED) {
+		perror("mmap failed");
+		return -1;
+	}
+
+	td->map = map;
+	td->tid = syscall(SYS_gettid);
+
+	pr_debug("tid = %d, map = %p\n", td->tid, map);
+	return 0;
+}
+
+static void *thread_fn(void *arg)
+{
+	struct thread_data *td = arg;
+	ssize_t ret;
+	int go;
+
+	if (thread_init(td))
+		return NULL;
+
+	/* Signal thread_create thread is initialized. */
+	ret = write(td->ready[1], &go, sizeof(int));
+	if (ret != sizeof(int)) {
+		pr_err("failed to notify\n");
+		return NULL;
+	}
+
+	while (!go_away) {
+		/* Waiting for main thread to kill us. */
+		usleep(100);
+	}
+
+	munmap(td->map, page_size);
+	return NULL;
+}
+
+static int thread_create(int i)
+{
+	struct thread_data *td = &threads[i];
+	int err, go;
+
+	if (pipe(td->ready))
+		return -1;
+
+	err = pthread_create(&td->pt, NULL, thread_fn, td);
+	if (!err) {
+		/* Wait for thread initialization. */
+		ssize_t ret = read(td->ready[0], &go, sizeof(int));
+		err = ret != sizeof(int);
+	}
+
+	close(td->ready[0]);
+	close(td->ready[1]);
+	return err;
+}
+
+static int threads_create(void)
+{
+	struct thread_data *td0 = &threads[0];
+	int i, err = 0;
+
+	go_away = 0;
+
+	/* 0 is main thread */
+	if (thread_init(td0))
+		return -1;
+
+	for (i = 1; !err && i < THREADS; i++)
+		err = thread_create(i);
+
+	return err;
+}
+
+static int threads_destroy(void)
+{
+	struct thread_data *td0 = &threads[0];
+	int i, err = 0;
+
+	/* cleanup the main thread */
+	munmap(td0->map, page_size);
+
+	go_away = 1;
+
+	for (i = 1; !err && i < THREADS; i++)
+		err = pthread_join(threads[i].pt, NULL);
+
+	return err;
+}
+
+typedef int (*synth_cb)(struct machine *machine);
+
+static int synth_all(struct machine *machine)
+{
+	return perf_event__synthesize_threads(NULL,
+					      perf_event__process,
+					      machine, 0);
+}
+
+static int synth_process(struct machine *machine)
+{
+	struct thread_map *map;
+	int err;
+
+	map = thread_map__new_by_pid(getpid());
+
+	err = perf_event__synthesize_thread_map(NULL, map,
+						perf_event__process,
+						machine, 0);
+
+	thread_map__delete(map);
+	return err;
+}
+
+static int mmap_events(synth_cb synth)
+{
+	struct machines machines;
+	struct machine *machine;
+	int err, i;
+
+	/*
+	 * The threads_create will not return before all threads
+	 * are spawned and all created memory map.
+	 *
+	 * They will loop until threads_destroy is called, so we
+	 * can safely run synthesizing function.
+	 */
+	TEST_ASSERT_VAL("failed to create threads", !threads_create());
+
+	machines__init(&machines);
+	machine = &machines.host;
+
+	dump_trace = verbose > 1 ? 1 : 0;
+
+	err = synth(machine);
+
+	dump_trace = 0;
+
+	TEST_ASSERT_VAL("failed to destroy threads", !threads_destroy());
+	TEST_ASSERT_VAL("failed to synthesize maps", !err);
+
+	/*
+	 * All data is synthesized, try to find map for each
+	 * thread object.
+	 */
+	for (i = 0; i < THREADS; i++) {
+		struct thread_data *td = &threads[i];
+		struct addr_location al;
+		struct thread *thread;
+
+		thread = machine__findnew_thread(machine, getpid(), td->tid);
+
+		pr_debug("looking for map %p\n", td->map);
+
+		thread__find_addr_map(thread, machine,
+				      PERF_RECORD_MISC_USER, MAP__FUNCTION,
+				      (unsigned long) (td->map + 1), &al);
+
+		if (!al.map) {
+			pr_debug("failed, couldn't find map\n");
+			err = -1;
+			break;
+		}
+
+		pr_debug("map %p, addr %" PRIx64 "\n", al.map, al.map->start);
+	}
+
+	machine__delete_threads(machine);
+	machines__exit(&machines);
+	return err;
+}
+
+/*
+ * This test creates 'THREADS' number of threads (including
+ * main thread) and each thread creates memory map.
+ *
+ * When threads are created, we synthesize them with both
+ * (separate tests):
+ *   perf_event__synthesize_thread_map (process based)
+ *   perf_event__synthesize_threads    (global)
+ *
+ * We test we can find all memory maps via:
+ *   thread__find_addr_map
+ *
+ * by using all thread objects.
+ */
+int test__mmap_thread_lookup(void)
+{
+	/* perf_event__synthesize_threads synthesize */
+	TEST_ASSERT_VAL("failed with sythesizing all",
+			!mmap_events(synth_all));
+
+	/* perf_event__synthesize_thread_map synthesize */
+	TEST_ASSERT_VAL("failed with sythesizing process",
+			!mmap_events(synth_process));
+
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index fe39163..82e8061 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -42,6 +42,7 @@ int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
 int test__hists_filter(void);
+int test__mmap_thread_lookup(void);
 
 #if defined(__x86_64__) || defined(__i386__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.8.3.1

