Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaCRIjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:39:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaCRI32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:29:28 -0400
Date: Tue, 18 Mar 2014 01:28:44 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-0fb298cf95c0d8119557b7d4657724a146e0622e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, jason.low2@hp.com, Waiman.Long@hp.com,
        tglx@linutronix.de, scott.norton@hp.com, davidlohr@hp.com,
        aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, jason.low2@hp.com, Waiman.Long@hp.com,
        tglx@linutronix.de, davidlohr@hp.com, scott.norton@hp.com,
        aswin@hp.com
In-Reply-To: <1387081917-9102-4-git-send-email-davidlohr@hp.com>
References: <1387081917-9102-4-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Add futex-requeue microbenchmark
Git-Commit-ID: 0fb298cf95c0d8119557b7d4657724a146e0622e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fb298cf95c0d8119557b7d4657724a146e0622e
Gitweb:     http://git.kernel.org/tip/0fb298cf95c0d8119557b7d4657724a146e0622e
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Sat, 14 Dec 2013 20:31:57 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 11:20:44 -0300

perf bench: Add futex-requeue microbenchmark

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
 tools/perf/Makefile.perf                           |   1 +
 tools/perf/bench/bench.h                           |   1 +
 tools/perf/bench/{futex-wake.c => futex-requeue.c} | 108 +++++++++++----------
 tools/perf/bench/futex.h                           |  13 +++
 tools/perf/builtin-bench.c                         |   1 +
 5 files changed, 75 insertions(+), 49 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6fa5d8b..50d875d 100644
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
index 6ac3f1d..eba4670 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -33,6 +33,7 @@ extern int bench_mem_memcpy(int argc, const char **argv,
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
 extern int bench_futex_hash(int argc, const char **argv, const char *prefix);
 extern int bench_futex_wake(int argc, const char **argv, const char *prefix);
+extern int bench_futex_requeue(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-requeue.c
similarity index 57%
copy from tools/perf/bench/futex-wake.c
copy to tools/perf/bench/futex-requeue.c
index d096169..a1625587 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -1,11 +1,11 @@
 /*
  * Copyright (C) 2013  Davidlohr Bueso <davidlohr@hp.com>
  *
- * futex-wake: Block a bunch of threads on a futex and wake'em up, N at a time.
+ * futex-requeue: Block a bunch of threads on futex1 and requeue them
+ *                on futex2, N at a time.
  *
- * This program is particularly useful to measure the latency of nthread wakeups
- * in non-error situations:  all waiters are queued and all wake calls wakeup
- * one or more tasks, and thus the waitqueue is never empty.
+ * This program is particularly useful to measure the latency of nthread
+ * requeues without waking up any tasks -- thus mimicking a regular futex_wait.
  */
 
 #include "../perf.h"
@@ -21,14 +21,13 @@
 #include <sys/time.h>
 #include <pthread.h>
 
-/* all threads will block on the same futex */
-static u_int32_t futex1 = 0;
+static u_int32_t futex1 = 0, futex2 = 0;
 
 /*
- * How many wakeups to do at a time.
+ * How many tasks to requeue at a time.
  * Default to 1 in order to make the kernel work more.
  */
-static unsigned int nwakes = 1;
+static unsigned int nrequeue = 1;
 
 /*
  * There can be significant variance from run to run,
@@ -37,26 +36,39 @@ static unsigned int nwakes = 1;
  */
 static unsigned int repeat = 10;
 
-pthread_t *worker;
+static pthread_t *worker;
 static bool done = 0, silent = 0;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
-static struct stats waketime_stats, wakeup_stats;
+static struct stats requeuetime_stats, requeued_stats;
 static unsigned int ncpus, threads_starting, nthreads = 0;
 
 static const struct option options[] = {
-	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
-	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
-	OPT_UINTEGER('r', "repeat",  &repeat,   "Specify amount of times to repeat the run"),
-	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
+	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
+	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
+	OPT_UINTEGER('r', "repeat",   &repeat,   "Specify amount of times to repeat the run"),
+	OPT_BOOLEAN( 's', "silent",   &silent,   "Silent mode: do not display data/details"),
 	OPT_END()
 };
 
-static const char * const bench_futex_wake_usage[] = {
-	"perf bench futex wake <options>",
+static const char * const bench_futex_requeue_usage[] = {
+	"perf bench futex requeue <options>",
 	NULL
 };
 
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
 static void *workerfn(void *arg __maybe_unused)
 {
 	pthread_mutex_lock(&thread_lock);
@@ -70,19 +82,6 @@ static void *workerfn(void *arg __maybe_unused)
 	return NULL;
 }
 
-static void print_summary(void)
-{
-	double waketime_avg = avg_stats(&waketime_stats);
-	double waketime_stddev = stddev_stats(&waketime_stats);
-	unsigned int wakeup_avg = avg_stats(&wakeup_stats);
-
-	printf("Wokeup %d of %d threads in %.4f ms (+-%.2f%%)\n",
-	       wakeup_avg,
-	       nthreads,
-	       waketime_avg/1e3,
-	       rel_stddev_stats(waketime_stddev, waketime_avg));
-}
-
 static void block_threads(pthread_t *w,
 			  pthread_attr_t thread_attr)
 {
@@ -111,19 +110,17 @@ static void toggle_done(int sig __maybe_unused,
 	done = true;
 }
 
-int bench_futex_wake(int argc, const char **argv,
-		     const char *prefix __maybe_unused)
+int bench_futex_requeue(int argc, const char **argv,
+			const char *prefix __maybe_unused)
 {
 	int ret = 0;
 	unsigned int i, j;
 	struct sigaction act;
 	pthread_attr_t thread_attr;
 
-	argc = parse_options(argc, argv, options, bench_futex_wake_usage, 0);
-	if (argc) {
-		usage_with_options(bench_futex_wake_usage, options);
-		exit(EXIT_FAILURE);
-	}
+	argc = parse_options(argc, argv, options, bench_futex_requeue_usage, 0);
+	if (argc)
+		goto err;
 
 	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
 
@@ -138,19 +135,19 @@ int bench_futex_wake(int argc, const char **argv,
 	if (!worker)
 		err(EXIT_FAILURE, "calloc");
 
-	printf("Run summary [PID %d]: blocking on %d threads (at futex %p), "
-	       "waking up %d at a time.\n\n",
-	       getpid(), nthreads, &futex1, nwakes);
+	printf("Run summary [PID %d]: Requeuing %d threads (from %p to %p), "
+	       "%d at a time.\n\n",
+	       getpid(), nthreads, &futex1, &futex2, nrequeue);
 
-	init_stats(&wakeup_stats);
-	init_stats(&waketime_stats);
+	init_stats(&requeued_stats);
+	init_stats(&requeuetime_stats);
 	pthread_attr_init(&thread_attr);
 	pthread_mutex_init(&thread_lock, NULL);
 	pthread_cond_init(&thread_parent, NULL);
 	pthread_cond_init(&thread_worker, NULL);
 
 	for (j = 0; j < repeat && !done; j++) {
-		unsigned int nwoken = 0;
+		unsigned int nrequeued = 0;
 		struct timeval start, end, runtime;
 
 		/* create, launch & block all threads */
@@ -165,21 +162,31 @@ int bench_futex_wake(int argc, const char **argv,
 
 		usleep(100000);
 
-		/* Ok, all threads are patiently blocked, start waking folks up */
+		/* Ok, all threads are patiently blocked, start requeueing */
 		gettimeofday(&start, NULL);
-		while (nwoken != nthreads)
-			nwoken += futex_wake(&futex1, nwakes, FUTEX_PRIVATE_FLAG);
+		for (nrequeued = 0; nrequeued < nthreads; nrequeued += nrequeue)
+			/*
+			 * Do not wakeup any tasks blocked on futex1, allowing
+			 * us to really measure futex_wait functionality.
+			 */
+			futex_cmp_requeue(&futex1, 0, &futex2, 0, nrequeue,
+					  FUTEX_PRIVATE_FLAG);
 		gettimeofday(&end, NULL);
 		timersub(&end, &start, &runtime);
 
-		update_stats(&wakeup_stats, nwoken);
-		update_stats(&waketime_stats, runtime.tv_usec);
+		update_stats(&requeued_stats, nrequeued);
+		update_stats(&requeuetime_stats, runtime.tv_usec);
 
 		if (!silent) {
-			printf("[Run %d]: Wokeup %d of %d threads in %.4f ms\n",
-			       j + 1, nwoken, nthreads, runtime.tv_usec/1e3);
+			printf("[Run %d]: Requeued %d of %d threads in %.4f ms\n",
+			       j + 1, nrequeued, nthreads, runtime.tv_usec/1e3);
 		}
 
+		/* everybody should be blocked on futex2, wake'em up */
+		nrequeued = futex_wake(&futex2, nthreads, FUTEX_PRIVATE_FLAG);
+		if (nthreads != nrequeued)
+			warnx("couldn't wakeup all tasks (%d/%d)", nrequeued, nthreads);
+
 		for (i = 0; i < nthreads; i++) {
 			ret = pthread_join(worker[i], NULL);
 			if (ret)
@@ -198,4 +205,7 @@ int bench_futex_wake(int argc, const char **argv,
 
 	free(worker);
 	return ret;
+err:
+	usage_with_options(bench_futex_requeue_usage, options);
+	exit(EXIT_FAILURE);
 }
diff --git a/tools/perf/bench/futex.h b/tools/perf/bench/futex.h
index 6ac4509..71f2844 100644
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
index 743a30a..f600b74 100644
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
