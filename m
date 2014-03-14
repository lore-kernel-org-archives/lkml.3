Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbaCNVat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:30:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbaCNVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Low <jason.low2@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/16] perf bench: Add futex-requeue microbenchmark
Date: Fri, 14 Mar 2014 18:29:57 -0300
Message-Id: <1394832610-17818-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Block a bunch of threads on a futex and requeue them on another, N at a
time.

This program is particularly useful to measure the latency of nthread
requeues without waking up any tasks -- thus mimicking a regular
futex_wait.

An example run:

  $ perf bench futex requeue -r 100 -t 64
  Run summary [PID 151011]: Requeuing 64 threads (from 0x7d15c4 to 0x7d15c8), 1 at a time.

  [Run 1]: Requeued 64 of 64 threads in 0.0400 ms
  [Run 2]: Requeued 64 of 64 threads in 0.0390 ms
  [Run 3]: Requeued 64 of 64 threads in 0.0400 ms
  ...
  [Run 100]: Requeued 64 of 64 threads in 0.0390 ms
  Requeued 64 of 64 threads in 0.0399 ms (+-0.37%)

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Darren Hart <dvhart@linux.intel.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <Waiman.Long@hp.com>
Link: http://lkml.kernel.org/r/1387081917-9102-4-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf         |   1 +
 tools/perf/bench/bench.h         |   1 +
 tools/perf/bench/futex-requeue.c | 211 +++++++++++++++++++++++++++++++++++++++
 tools/perf/bench/futex.h         |  13 +++
 tools/perf/builtin-bench.c       |   1 +
 5 files changed, 227 insertions(+)
 create mode 100644 tools/perf/bench/futex-requeue.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6fa5d8b74635..50d875d970c4 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -428,6 +428,7 @@ BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
+BUILTIN_OBJS += $(OUTPUT)bench/futex-requeue.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 6ac3f1d083cc..eba46709b279 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -33,6 +33,7 @@ extern int bench_mem_memcpy(int argc, const char **argv,
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
 extern int bench_futex_hash(int argc, const char **argv, const char *prefix);
 extern int bench_futex_wake(int argc, const char **argv, const char *prefix);
+extern int bench_futex_requeue(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
new file mode 100644
index 000000000000..a16255876f1d
--- /dev/null
+++ b/tools/perf/bench/futex-requeue.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright (C) 2013  Davidlohr Bueso <davidlohr@hp.com>
+ *
+ * futex-requeue: Block a bunch of threads on futex1 and requeue them
+ *                on futex2, N at a time.
+ *
+ * This program is particularly useful to measure the latency of nthread
+ * requeues without waking up any tasks -- thus mimicking a regular futex_wait.
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
+static u_int32_t futex1 = 0, futex2 = 0;
+
+/*
+ * How many tasks to requeue at a time.
+ * Default to 1 in order to make the kernel work more.
+ */
+static unsigned int nrequeue = 1;
+
+/*
+ * There can be significant variance from run to run,
+ * the more repeats, the more exact the overall avg and
+ * the better idea of the futex latency.
+ */
+static unsigned int repeat = 10;
+
+static pthread_t *worker;
+static bool done = 0, silent = 0;
+static pthread_mutex_t thread_lock;
+static pthread_cond_t thread_parent, thread_worker;
+static struct stats requeuetime_stats, requeued_stats;
+static unsigned int ncpus, threads_starting, nthreads = 0;
+
+static const struct option options[] = {
+	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
+	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
+	OPT_UINTEGER('r', "repeat",   &repeat,   "Specify amount of times to repeat the run"),
+	OPT_BOOLEAN( 's', "silent",   &silent,   "Silent mode: do not display data/details"),
+	OPT_END()
+};
+
+static const char * const bench_futex_requeue_usage[] = {
+	"perf bench futex requeue <options>",
+	NULL
+};
+
+static void print_summary(void)
+{
+	double requeuetime_avg = avg_stats(&requeuetime_stats);
+	double requeuetime_stddev = stddev_stats(&requeuetime_stats);
+	unsigned int requeued_avg = avg_stats(&requeued_stats);
+
+	printf("Requeued %d of %d threads in %.4f ms (+-%.2f%%)\n",
+	       requeued_avg,
+	       nthreads,
+	       requeuetime_avg/1e3,
+	       rel_stddev_stats(requeuetime_stddev, requeuetime_avg));
+}
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
+int bench_futex_requeue(int argc, const char **argv,
+			const char *prefix __maybe_unused)
+{
+	int ret = 0;
+	unsigned int i, j;
+	struct sigaction act;
+	pthread_attr_t thread_attr;
+
+	argc = parse_options(argc, argv, options, bench_futex_requeue_usage, 0);
+	if (argc)
+		goto err;
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
+	printf("Run summary [PID %d]: Requeuing %d threads (from %p to %p), "
+	       "%d at a time.\n\n",
+	       getpid(), nthreads, &futex1, &futex2, nrequeue);
+
+	init_stats(&requeued_stats);
+	init_stats(&requeuetime_stats);
+	pthread_attr_init(&thread_attr);
+	pthread_mutex_init(&thread_lock, NULL);
+	pthread_cond_init(&thread_parent, NULL);
+	pthread_cond_init(&thread_worker, NULL);
+
+	for (j = 0; j < repeat && !done; j++) {
+		unsigned int nrequeued = 0;
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
+		/* Ok, all threads are patiently blocked, start requeueing */
+		gettimeofday(&start, NULL);
+		for (nrequeued = 0; nrequeued < nthreads; nrequeued += nrequeue)
+			/*
+			 * Do not wakeup any tasks blocked on futex1, allowing
+			 * us to really measure futex_wait functionality.
+			 */
+			futex_cmp_requeue(&futex1, 0, &futex2, 0, nrequeue,
+					  FUTEX_PRIVATE_FLAG);
+		gettimeofday(&end, NULL);
+		timersub(&end, &start, &runtime);
+
+		update_stats(&requeued_stats, nrequeued);
+		update_stats(&requeuetime_stats, runtime.tv_usec);
+
+		if (!silent) {
+			printf("[Run %d]: Requeued %d of %d threads in %.4f ms\n",
+			       j + 1, nrequeued, nthreads, runtime.tv_usec/1e3);
+		}
+
+		/* everybody should be blocked on futex2, wake'em up */
+		nrequeued = futex_wake(&futex2, nthreads, FUTEX_PRIVATE_FLAG);
+		if (nthreads != nrequeued)
+			warnx("couldn't wakeup all tasks (%d/%d)", nrequeued, nthreads);
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
+err:
+	usage_with_options(bench_futex_requeue_usage, options);
+	exit(EXIT_FAILURE);
+}
diff --git a/tools/perf/bench/futex.h b/tools/perf/bench/futex.h
index 6ac45093fac4..71f2844cf97f 100644
--- a/tools/perf/bench/futex.h
+++ b/tools/perf/bench/futex.h
@@ -55,4 +55,17 @@ futex_wake(u_int32_t *uaddr, int nr_wake, int opflags)
 	return futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags);
 }
 
+/**
+* futex_cmp_requeue() - requeue tasks from uaddr to uaddr2
+* @nr_wake:        wake up to this many tasks
+* @nr_requeue:        requeue up to this many tasks
+*/
+static inline int
+futex_cmp_requeue(u_int32_t *uaddr, u_int32_t val, u_int32_t *uaddr2, int nr_wake,
+		 int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE, nr_wake, nr_requeue, uaddr2,
+		 val, opflags);
+}
+
 #endif /* _FUTEX_H */
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 743a30a8baa0..f600b74216da 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -58,6 +58,7 @@ static struct bench mem_benchmarks[] = {
 static struct bench futex_benchmarks[] = {
 	{ "hash",	"Benchmark for futex hash table",               bench_futex_hash	},
 	{ "wake",	"Benchmark for futex wake calls",               bench_futex_wake	},
+	{ "requeue",	"Benchmark for futex requeue calls",            bench_futex_requeue	},
 	{ "all",	"Test all futex benchmarks",			NULL			},
 	{ NULL,		NULL,						NULL			}
 };
-- 
1.8.1.4

