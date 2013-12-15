Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3LOEcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 23:32:47 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35894 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3LOEcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 23:32:23 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, jason.low2@hp.com,
        Waiman.Long@hp.com, scott.norton@hp.com, aswin@hp.com,
        davidlohr@hp.com
Subject: [PATCH 2/3] perf-bench: add futex-wake microbenchmark
Date: Sat, 14 Dec 2013 20:31:56 -0800
Message-Id: <1387081917-9102-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
References: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block a bunch of threads on a futex and wake them up, N at a time.

This program is particularly useful to measure the latency of nthread wakeups
in non-error situations:  all waiters are queued and all wake calls wakeup
one or more tasks. An example run:

$ perf bench futex -t 512 -r 100
Run summary [PID 27823]: blocking on 512 threads (at futex 0x7e10d4), waking up 1 at a time.

[Run 1]: Wokeup 512 of 512 threads in 6.0080 ms
[Run 2]: Wokeup 512 of 512 threads in 5.2280 ms
[Run 3]: Wokeup 512 of 512 threads in 4.8300 ms
...
[Run 100]: Wokeup 512 of 512 threads in 5.0100 ms
Wokeup 512 of 512 threads in 5.0109 ms (+-2.25%)

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/Makefile.perf      |   1 +
 tools/perf/bench/bench.h      |   1 +
 tools/perf/bench/futex-wake.c | 201 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/bench/futex.h      |  10 +++
 tools/perf/builtin-bench.c    |   1 +
 5 files changed, 214 insertions(+)
 create mode 100644 tools/perf/bench/futex-wake.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index c38cba4..f2e3536 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -417,6 +417,7 @@ endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
+BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 34edb5c..6ac3f1d 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -32,6 +32,7 @@ extern int bench_mem_memcpy(int argc, const char **argv,
 			    const char *prefix __maybe_unused);
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
 extern int bench_futex_hash(int argc, const char **argv, const char *prefix);
+extern int bench_futex_wake(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
new file mode 100644
index 0000000..d096169
--- /dev/null
+++ b/tools/perf/bench/futex-wake.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) 2013  Davidlohr Bueso <davidlohr@hp.com>
+ *
+ * futex-wake: Block a bunch of threads on a futex and wake'em up, N at a time.
+ *
+ * This program is particularly useful to measure the latency of nthread wakeups
+ * in non-error situations:  all waiters are queued and all wake calls wakeup
+ * one or more tasks, and thus the waitqueue is never empty.
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/stat.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+#include "futex.h"
+
+#include <err.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <pthread.h>
+
+/* all threads will block on the same futex */
+static u_int32_t futex1 = 0;
+
+/*
+ * How many wakeups to do at a time.
+ * Default to 1 in order to make the kernel work more.
+ */
+static unsigned int nwakes = 1;
+
+/*
+ * There can be significant variance from run to run,
+ * the more repeats, the more exact the overall avg and
+ * the better idea of the futex latency.
+ */
+static unsigned int repeat = 10;
+
+pthread_t *worker;
+static bool done = 0, silent = 0;
+static pthread_mutex_t thread_lock;
+static pthread_cond_t thread_parent, thread_worker;
+static struct stats waketime_stats, wakeup_stats;
+static unsigned int ncpus, threads_starting, nthreads = 0;
+
+static const struct option options[] = {
+	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
+	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
+	OPT_UINTEGER('r', "repeat",  &repeat,   "Specify amount of times to repeat the run"),
+	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
+	OPT_END()
+};
+
+static const char * const bench_futex_wake_usage[] = {
+	"perf bench futex wake <options>",
+	NULL
+};
+
+static void *workerfn(void *arg __maybe_unused)
+{
+	pthread_mutex_lock(&thread_lock);
+	threads_starting--;
+	if (!threads_starting)
+		pthread_cond_signal(&thread_parent);
+	pthread_cond_wait(&thread_worker, &thread_lock);
+	pthread_mutex_unlock(&thread_lock);
+
+	futex_wait(&futex1, 0, NULL, FUTEX_PRIVATE_FLAG);
+	return NULL;
+}
+
+static void print_summary(void)
+{
+	double waketime_avg = avg_stats(&waketime_stats);
+	double waketime_stddev = stddev_stats(&waketime_stats);
+	unsigned int wakeup_avg = avg_stats(&wakeup_stats);
+
+	printf("Wokeup %d of %d threads in %.4f ms (+-%.2f%%)\n",
+	       wakeup_avg,
+	       nthreads,
+	       waketime_avg/1e3,
+	       rel_stddev_stats(waketime_stddev, waketime_avg));
+}
+
+static void block_threads(pthread_t *w,
+			  pthread_attr_t thread_attr)
+{
+	cpu_set_t cpu;
+	unsigned int i;
+
+	threads_starting = nthreads;
+
+	/* create and block all threads */
+	for (i = 0; i < nthreads; i++) {
+		CPU_ZERO(&cpu);
+		CPU_SET(i % ncpus, &cpu);
+
+		if (pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t), &cpu))
+			err(EXIT_FAILURE, "pthread_attr_setaffinity_np");
+
+		if (pthread_create(&w[i], &thread_attr, workerfn, NULL))
+			err(EXIT_FAILURE, "pthread_create");
+	}
+}
+
+static void toggle_done(int sig __maybe_unused,
+			siginfo_t *info __maybe_unused,
+			void *uc __maybe_unused)
+{
+	done = true;
+}
+
+int bench_futex_wake(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	int ret = 0;
+	unsigned int i, j;
+	struct sigaction act;
+	pthread_attr_t thread_attr;
+
+	argc = parse_options(argc, argv, options, bench_futex_wake_usage, 0);
+	if (argc) {
+		usage_with_options(bench_futex_wake_usage, options);
+		exit(EXIT_FAILURE);
+	}
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+
+	sigfillset(&act.sa_mask);
+	act.sa_sigaction = toggle_done;
+	sigaction(SIGINT, &act, NULL);
+
+	if (!nthreads)
+		nthreads = ncpus;
+
+	worker = calloc(nthreads, sizeof(*worker));
+	if (!worker)
+		err(EXIT_FAILURE, "calloc");
+
+	printf("Run summary [PID %d]: blocking on %d threads (at futex %p), "
+	       "waking up %d at a time.\n\n",
+	       getpid(), nthreads, &futex1, nwakes);
+
+	init_stats(&wakeup_stats);
+	init_stats(&waketime_stats);
+	pthread_attr_init(&thread_attr);
+	pthread_mutex_init(&thread_lock, NULL);
+	pthread_cond_init(&thread_parent, NULL);
+	pthread_cond_init(&thread_worker, NULL);
+
+	for (j = 0; j < repeat && !done; j++) {
+		unsigned int nwoken = 0;
+		struct timeval start, end, runtime;
+
+		/* create, launch & block all threads */
+		block_threads(worker, thread_attr);
+
+		/* make sure all threads are already blocked */
+		pthread_mutex_lock(&thread_lock);
+		while (threads_starting)
+			pthread_cond_wait(&thread_parent, &thread_lock);
+		pthread_cond_broadcast(&thread_worker);
+		pthread_mutex_unlock(&thread_lock);
+
+		usleep(100000);
+
+		/* Ok, all threads are patiently blocked, start waking folks up */
+		gettimeofday(&start, NULL);
+		while (nwoken != nthreads)
+			nwoken += futex_wake(&futex1, nwakes, FUTEX_PRIVATE_FLAG);
+		gettimeofday(&end, NULL);
+		timersub(&end, &start, &runtime);
+
+		update_stats(&wakeup_stats, nwoken);
+		update_stats(&waketime_stats, runtime.tv_usec);
+
+		if (!silent) {
+			printf("[Run %d]: Wokeup %d of %d threads in %.4f ms\n",
+			       j + 1, nwoken, nthreads, runtime.tv_usec/1e3);
+		}
+
+		for (i = 0; i < nthreads; i++) {
+			ret = pthread_join(worker[i], NULL);
+			if (ret)
+				err(EXIT_FAILURE, "pthread_join");
+		}
+
+	}
+
+	/* cleanup & report results */
+	pthread_cond_destroy(&thread_parent);
+	pthread_cond_destroy(&thread_worker);
+	pthread_mutex_destroy(&thread_lock);
+	pthread_attr_destroy(&thread_attr);
+
+	print_summary();
+
+	free(worker);
+	return ret;
+}
diff --git a/tools/perf/bench/futex.h b/tools/perf/bench/futex.h
index 7d0bda5..6ac4509 100644
--- a/tools/perf/bench/futex.h
+++ b/tools/perf/bench/futex.h
@@ -45,4 +45,14 @@ futex_wait(u_int32_t *uaddr, u_int32_t val, struct timespec *timeout, int opflag
 	return futex(uaddr, FUTEX_WAIT, val, timeout, NULL, 0, opflags);
 }
 
+/**
+ * futex_wake() - wake one or more tasks blocked on uaddr
+ * @nr_wake:	wake up to this many tasks
+ */
+static inline int
+futex_wake(u_int32_t *uaddr, int nr_wake, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags);
+}
+
 #endif /* _FUTEX_H */
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index a8b0138..743a30a 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -57,6 +57,7 @@ static struct bench mem_benchmarks[] = {
 
 static struct bench futex_benchmarks[] = {
 	{ "hash",	"Benchmark for futex hash table",               bench_futex_hash	},
+	{ "wake",	"Benchmark for futex wake calls",               bench_futex_wake	},
 	{ "all",	"Test all futex benchmarks",			NULL			},
 	{ NULL,		NULL,						NULL			}
 };
-- 
1.8.1.4

