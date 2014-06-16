Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaFPSPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:48 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:24185 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852AbaFPSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:46 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] perf bench: futex: Support operations for shared futexes
Date: Mon, 16 Jun 2014 11:14:27 -0700
Message-Id: <1402942467-10671-10-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike futex-hash, requeuing and wakeup benchmarks do not support
shared futexes, limiting the usefulness of the programs. Correct
this, and allow using the local -S parameter. The default remains
using private futexes.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/futex-hash.c    |  7 +++++--
 tools/perf/bench/futex-requeue.c | 22 ++++++++++++++--------
 tools/perf/bench/futex-wake.c    | 15 ++++++++++-----
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/perf/bench/futex-hash.c b/tools/perf/bench/futex-hash.c
index 14791eb..5175171 100644
--- a/tools/perf/bench/futex-hash.c
+++ b/tools/perf/bench/futex-hash.c
@@ -26,6 +26,7 @@ static unsigned int nsecs    = 10;
 /* amount of futexes per thread */
 static unsigned int nfutexes = 1024;
 static bool fshared = false, done = false;
+static int futex_flag = 0;
 
 struct timeval start, end, runtime;
 static pthread_mutex_t thread_lock;
@@ -74,8 +75,7 @@ static void *workerfn(void *arg)
 			 * such as internal waitqueue handling, thus enlarging
 			 * the critical region protected by hb->lock.
 			 */
-			ret = futex_wait(&w->futex[i], 1234, NULL,
-					 fshared ? 0 : FUTEX_PRIVATE_FLAG);
+			ret = futex_wait(&w->futex[i], 1234, NULL, futex_flag);
 			if (bench_format == BENCH_FORMAT_DEFAULT &&
 			    (!ret || errno != EAGAIN || errno != EWOULDBLOCK))
 				warn("Non-expected futex return call");
@@ -147,6 +147,9 @@ int bench_futex_hash(int argc, const char **argv,
 	if (!worker)
 		goto errmem;
 
+	if (!fshared)
+		futex_flag = FUTEX_PRIVATE_FLAG;
+
 	if (bench_format == BENCH_FORMAT_DEFAULT) {
 		printf("Run summary [PID %d]: %d threads, each operating on %d [%s] futexes for %d secs.\n\n",
 		       getpid(), nthreads, nfutexes, fshared ? "shared":"private", nsecs);
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index 7b211c1..197537b 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -30,15 +30,17 @@ static u_int32_t futex1 = 0, futex2 = 0;
 static unsigned int nrequeue = 1;
 
 static pthread_t *worker;
-static bool done = 0;
+static bool done = false, fshared = false;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats requeuetime_stats, requeued_stats;
 static unsigned int ncpus, threads_starting, nthreads = 0;
+static int futex_flag = 0;
 
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
+	OPT_BOOLEAN('S',  "shared",   &fshared,  "Use shared futexes instead of private ones"),
 	OPT_END()
 };
 
@@ -80,7 +82,7 @@ static void *workerfn(void *arg __maybe_unused)
 	pthread_cond_wait(&thread_worker, &thread_lock);
 	pthread_mutex_unlock(&thread_lock);
 
-	futex_wait(&futex1, 0, NULL, FUTEX_PRIVATE_FLAG);
+	futex_wait(&futex1, 0, NULL, futex_flag);
 	return NULL;
 }
 
@@ -137,10 +139,13 @@ int bench_futex_requeue(int argc, const char **argv,
 	if (!worker)
 		err(EXIT_FAILURE, "calloc");
 
+	if (!fshared)
+		futex_flag = FUTEX_PRIVATE_FLAG;
+
 	if (bench_format == BENCH_FORMAT_DEFAULT) {
-		printf("Run summary [PID %d]: Requeuing %d threads (from %p to %p), "
-		       "%d at a time.\n\n",
-		       getpid(), nthreads, &futex1, &futex2, nrequeue);
+		printf("Run summary [PID %d]: Requeuing %d threads (from [%s] futex %p to %p), "
+		       "%d at a time.\n\n", getpid(), nthreads,
+		       fshared ? "shared":"private", &futex1, &futex2, nrequeue);
 	}
 
 	init_stats(&requeued_stats);
@@ -173,8 +178,9 @@ int bench_futex_requeue(int argc, const char **argv,
 			 * Do not wakeup any tasks blocked on futex1, allowing
 			 * us to really measure futex_wait functionality.
 			 */
-			futex_cmp_requeue(&futex1, 0, &futex2, 0, nrequeue,
-					  FUTEX_PRIVATE_FLAG);
+			futex_cmp_requeue(&futex1, 0, &futex2, 0,
+					  nrequeue, futex_flag);
+
 		gettimeofday(&end, NULL);
 		timersub(&end, &start, &runtime);
 
@@ -187,7 +193,7 @@ int bench_futex_requeue(int argc, const char **argv,
 		}
 
 		/* everybody should be blocked on futex2, wake'em up */
-		nrequeued = futex_wake(&futex2, nthreads, FUTEX_PRIVATE_FLAG);
+		nrequeued = futex_wake(&futex2, nthreads, futex_flag);
 		if (nthreads != nrequeued)
 			warnx("couldn't wakeup all tasks (%d/%d)", nrequeued, nthreads);
 
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index eae6d09..08f62eb 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -31,15 +31,17 @@ static u_int32_t futex1 = 0;
 static unsigned int nwakes = 1;
 
 pthread_t *worker;
-static bool done = false;
+static bool done = false, fshared = false;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats waketime_stats, wakeup_stats;
 static unsigned int ncpus, threads_starting, nthreads = 0;
+static int futex_flag = 0;
 
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
+	OPT_BOOLEAN('S',  "shared",  &fshared,  "Use shared futexes instead of private ones"),
 	OPT_END()
 };
 
@@ -57,7 +59,7 @@ static void *workerfn(void *arg __maybe_unused)
 	pthread_cond_wait(&thread_worker, &thread_lock);
 	pthread_mutex_unlock(&thread_lock);
 
-	futex_wait(&futex1, 0, NULL, FUTEX_PRIVATE_FLAG);
+	futex_wait(&futex1, 0, NULL, futex_flag);
 	return NULL;
 }
 
@@ -140,10 +142,13 @@ int bench_futex_wake(int argc, const char **argv,
 	if (!worker)
 		err(EXIT_FAILURE, "calloc");
 
+	if (!fshared)
+		futex_flag = FUTEX_PRIVATE_FLAG;
+
 	if (bench_format == BENCH_FORMAT_DEFAULT)
-		printf("Run summary [PID %d]: blocking on %d threads (at futex %p), "
+		printf("Run summary [PID %d]: blocking on %d threads (at [%s] futex %p), "
 		       "waking up %d at a time.\n\n",
-		       getpid(), nthreads, &futex1, nwakes);
+		       getpid(), nthreads, fshared ? "shared":"private",  &futex1, nwakes);
 
 	init_stats(&wakeup_stats);
 	init_stats(&waketime_stats);
@@ -171,7 +176,7 @@ int bench_futex_wake(int argc, const char **argv,
 		/* Ok, all threads are patiently blocked, start waking folks up */
 		gettimeofday(&start, NULL);
 		while (nwoken != nthreads)
-			nwoken += futex_wake(&futex1, nwakes, FUTEX_PRIVATE_FLAG);
+			nwoken += futex_wake(&futex1, nwakes, futex_flag);
 		gettimeofday(&end, NULL);
 		timersub(&end, &start, &runtime);
 
-- 
1.8.1.4

