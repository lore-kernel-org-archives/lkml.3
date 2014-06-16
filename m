Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbaFPSPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:41 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:38609 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789AbaFPSPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:32 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] perf bench: futex: Replace --silent option with global --format
Date: Mon, 16 Jun 2014 11:14:24 -0700
Message-Id: <1402942467-10671-7-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the already existing '--format simple' option in perf-bench
is/should be equivalent to disabling any verbose output. Replace
it and free up the -s option specific to the futex benchmark.
Furthermore only show the raw output if used, as it is intended
to make scripting/parsing easier.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/futex-hash.c    | 32 +++++++++++++++++++++++---------
 tools/perf/bench/futex-requeue.c | 34 +++++++++++++++++++++++-----------
 tools/perf/bench/futex-wake.c    | 33 ++++++++++++++++++++++-----------
 3 files changed, 68 insertions(+), 31 deletions(-)

diff --git a/tools/perf/bench/futex-hash.c b/tools/perf/bench/futex-hash.c
index a84206e..14791eb 100644
--- a/tools/perf/bench/futex-hash.c
+++ b/tools/perf/bench/futex-hash.c
@@ -25,7 +25,7 @@ static unsigned int nthreads = 0;
 static unsigned int nsecs    = 10;
 /* amount of futexes per thread */
 static unsigned int nfutexes = 1024;
-static bool fshared = false, done = false, silent = false;
+static bool fshared = false, done = false;
 
 struct timeval start, end, runtime;
 static pthread_mutex_t thread_lock;
@@ -44,7 +44,6 @@ static const struct option options[] = {
 	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('r', "runtime", &nsecs,    "Specify runtime (in seconds)"),
 	OPT_UINTEGER('f', "futexes", &nfutexes, "Specify amount of futexes per threads"),
-	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
 	OPT_BOOLEAN( 'S', "shared",  &fshared,  "Use shared futexes instead of private ones"),
 	OPT_END()
 };
@@ -77,7 +76,7 @@ static void *workerfn(void *arg)
 			 */
 			ret = futex_wait(&w->futex[i], 1234, NULL,
 					 fshared ? 0 : FUTEX_PRIVATE_FLAG);
-			if (!silent &&
+			if (bench_format == BENCH_FORMAT_DEFAULT &&
 			    (!ret || errno != EAGAIN || errno != EWOULDBLOCK))
 				warn("Non-expected futex return call");
 		}
@@ -101,9 +100,22 @@ static void print_summary(void)
 	unsigned long avg = avg_stats(&throughput_stats);
 	double stddev = stddev_stats(&throughput_stats);
 
-	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
-	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
+		       !bench_format == BENCH_FORMAT_DEFAULT ? "\n" : "",
+		       avg, rel_stddev_stats(stddev, avg),
+		       (int) runtime.tv_sec);
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf("%ld\n", avg);
+		break;
+	default:
+		/* reaching here is something disaster */
+		fprintf(stderr, "Unknown format:%d\n", bench_format);
+		exit(EXIT_FAILURE);
+
+	}
 }
 
 int bench_futex_hash(int argc, const char **argv,
@@ -135,8 +147,10 @@ int bench_futex_hash(int argc, const char **argv,
 	if (!worker)
 		goto errmem;
 
-	printf("Run summary [PID %d]: %d threads, each operating on %d [%s] futexes for %d secs.\n\n",
-	       getpid(), nthreads, nfutexes, fshared ? "shared":"private", nsecs);
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("Run summary [PID %d]: %d threads, each operating on %d [%s] futexes for %d secs.\n\n",
+		       getpid(), nthreads, nfutexes, fshared ? "shared":"private", nsecs);
+	}
 
 	init_stats(&throughput_stats);
 	pthread_mutex_init(&thread_lock, NULL);
@@ -190,7 +204,7 @@ int bench_futex_hash(int argc, const char **argv,
 	for (i = 0; i < nthreads; i++) {
 		unsigned long t = worker[i].ops/runtime.tv_sec;
 		update_stats(&throughput_stats, t);
-		if (!silent) {
+		if (bench_format == BENCH_FORMAT_DEFAULT) {
 			if (nfutexes == 1)
 				printf("[thread %2d] futex: %p [ %ld ops/sec ]\n",
 				       worker[i].tid, &worker[i].futex[0], t);
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index 732403b..7b211c1 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -30,7 +30,7 @@ static u_int32_t futex1 = 0, futex2 = 0;
 static unsigned int nrequeue = 1;
 
 static pthread_t *worker;
-static bool done = 0, silent = 0;
+static bool done = 0;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats requeuetime_stats, requeued_stats;
@@ -39,7 +39,6 @@ static unsigned int ncpus, threads_starting, nthreads = 0;
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
-	OPT_BOOLEAN( 's', "silent",   &silent,   "Silent mode: do not display data/details"),
 	OPT_END()
 };
 
@@ -54,11 +53,22 @@ static void print_summary(void)
 	double requeuetime_stddev = stddev_stats(&requeuetime_stats);
 	unsigned int requeued_avg = avg_stats(&requeued_stats);
 
-	printf("Requeued %d of %d threads in %.4f ms (+-%.2f%%)\n",
-	       requeued_avg,
-	       nthreads,
-	       requeuetime_avg/1e3,
-	       rel_stddev_stats(requeuetime_stddev, requeuetime_avg));
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf("Requeued %d of %d threads in %.4f ms (+-%.2f%%)\n",
+		       requeued_avg,
+		       nthreads,
+		       requeuetime_avg/1e3,
+		       rel_stddev_stats(requeuetime_stddev, requeuetime_avg));
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf("%.3f\n", requeuetime_avg/1e3);
+		break;
+	default:
+		/* reaching here is something disaster */
+		fprintf(stderr, "Unknown format:%d\n", bench_format);
+		exit(EXIT_FAILURE);
+	}
 }
 
 static void *workerfn(void *arg __maybe_unused)
@@ -127,9 +137,11 @@ int bench_futex_requeue(int argc, const char **argv,
 	if (!worker)
 		err(EXIT_FAILURE, "calloc");
 
-	printf("Run summary [PID %d]: Requeuing %d threads (from %p to %p), "
-	       "%d at a time.\n\n",
-	       getpid(), nthreads, &futex1, &futex2, nrequeue);
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("Run summary [PID %d]: Requeuing %d threads (from %p to %p), "
+		       "%d at a time.\n\n",
+		       getpid(), nthreads, &futex1, &futex2, nrequeue);
+	}
 
 	init_stats(&requeued_stats);
 	init_stats(&requeuetime_stats);
@@ -169,7 +181,7 @@ int bench_futex_requeue(int argc, const char **argv,
 		update_stats(&requeued_stats, nrequeued);
 		update_stats(&requeuetime_stats, runtime.tv_usec);
 
-		if (!silent) {
+		if (bench_format == BENCH_FORMAT_DEFAULT) {
 			printf("[Run %d]: Requeued %d of %d threads in %.4f ms\n",
 			       j + 1, nrequeued, nthreads, runtime.tv_usec/1e3);
 		}
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index 50022cb..eae6d09 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -31,7 +31,7 @@ static u_int32_t futex1 = 0;
 static unsigned int nwakes = 1;
 
 pthread_t *worker;
-static bool done = false, silent = false;
+static bool done = false;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats waketime_stats, wakeup_stats;
@@ -40,7 +40,6 @@ static unsigned int ncpus, threads_starting, nthreads = 0;
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
-	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
 	OPT_END()
 };
 
@@ -68,11 +67,22 @@ static void print_summary(void)
 	double waketime_stddev = stddev_stats(&waketime_stats);
 	unsigned int wakeup_avg = avg_stats(&wakeup_stats);
 
-	printf("Wokeup %d of %d threads in %.4f ms (+-%.2f%%)\n",
-	       wakeup_avg,
-	       nthreads,
-	       waketime_avg/1e3,
-	       rel_stddev_stats(waketime_stddev, waketime_avg));
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf("Wokeup %d of %d threads in %.4f ms (+-%.2f%%)\n",
+		       wakeup_avg,
+		       nthreads,
+		       waketime_avg/1e3,
+		       rel_stddev_stats(waketime_stddev, waketime_avg));
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf("%.4f\n", waketime_avg/1e3);
+		break;
+	default:
+		/* reaching here is something disaster */
+		fprintf(stderr, "Unknown format:%d\n", bench_format);
+		exit(EXIT_FAILURE);
+	}
 }
 
 static void block_threads(pthread_t *w,
@@ -130,9 +140,10 @@ int bench_futex_wake(int argc, const char **argv,
 	if (!worker)
 		err(EXIT_FAILURE, "calloc");
 
-	printf("Run summary [PID %d]: blocking on %d threads (at futex %p), "
-	       "waking up %d at a time.\n\n",
-	       getpid(), nthreads, &futex1, nwakes);
+	if (bench_format == BENCH_FORMAT_DEFAULT)
+		printf("Run summary [PID %d]: blocking on %d threads (at futex %p), "
+		       "waking up %d at a time.\n\n",
+		       getpid(), nthreads, &futex1, nwakes);
 
 	init_stats(&wakeup_stats);
 	init_stats(&waketime_stats);
@@ -167,7 +178,7 @@ int bench_futex_wake(int argc, const char **argv,
 		update_stats(&wakeup_stats, nwoken);
 		update_stats(&waketime_stats, runtime.tv_usec);
 
-		if (!silent) {
+		if (bench_format == BENCH_FORMAT_DEFAULT) {
 			printf("[Run %d]: Wokeup %d of %d threads in %.4f ms\n",
 			       j + 1, nwoken, nthreads, runtime.tv_usec/1e3);
 		}
-- 
1.8.1.4

