Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaJCFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:25:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaJCFZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:25:55 -0400
Date: Thu, 2 Oct 2014 22:25:40 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-86c87e13f8a5dffc6cc7b0f37340f815dc172945@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dave@stgolabs.net, tglx@linutronix.de,
        dbueso@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dave@stgolabs.net, tglx@linutronix.de, dbueso@suse.de
In-Reply-To: <1412008868-22328-1-git-send-email-dave@stgolabs.net>
References: <1412008868-22328-1-git-send-email-dave@stgolabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench futex:
  Support operations for shared futexes
Git-Commit-ID: 86c87e13f8a5dffc6cc7b0f37340f815dc172945
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

Commit-ID:  86c87e13f8a5dffc6cc7b0f37340f815dc172945
Gitweb:     http://git.kernel.org/tip/86c87e13f8a5dffc6cc7b0f37340f815dc172945
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Mon, 29 Sep 2014 09:41:07 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Sep 2014 15:43:21 -0300

perf bench futex: Support operations for shared futexes

Unlike futex-hash, requeuing and wakeup benchmarks do not support shared
futexes, limiting the usefulness of the programs. Correct this, and
allow using the local -S parameter. The default remains using private
futexes.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Davidlohr Bueso <dbueso@suse.de>
Link: http://lkml.kernel.org/r/1412008868-22328-1-git-send-email-dave@stgolabs.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/futex-hash.c    |  7 +++++--
 tools/perf/bench/futex-requeue.c | 24 +++++++++++++++---------
 tools/perf/bench/futex-wake.c    | 15 ++++++++++-----
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/tools/perf/bench/futex-hash.c b/tools/perf/bench/futex-hash.c
index a84206e..fc9bebd 100644
--- a/tools/perf/bench/futex-hash.c
+++ b/tools/perf/bench/futex-hash.c
@@ -26,6 +26,7 @@ static unsigned int nsecs    = 10;
 /* amount of futexes per thread */
 static unsigned int nfutexes = 1024;
 static bool fshared = false, done = false, silent = false;
+static int futex_flag = 0;
 
 struct timeval start, end, runtime;
 static pthread_mutex_t thread_lock;
@@ -75,8 +76,7 @@ static void *workerfn(void *arg)
 			 * such as internal waitqueue handling, thus enlarging
 			 * the critical region protected by hb->lock.
 			 */
-			ret = futex_wait(&w->futex[i], 1234, NULL,
-					 fshared ? 0 : FUTEX_PRIVATE_FLAG);
+			ret = futex_wait(&w->futex[i], 1234, NULL, futex_flag);
 			if (!silent &&
 			    (!ret || errno != EAGAIN || errno != EWOULDBLOCK))
 				warn("Non-expected futex return call");
@@ -135,6 +135,9 @@ int bench_futex_hash(int argc, const char **argv,
 	if (!worker)
 		goto errmem;
 
+	if (!fshared)
+		futex_flag = FUTEX_PRIVATE_FLAG;
+
 	printf("Run summary [PID %d]: %d threads, each operating on %d [%s] futexes for %d secs.\n\n",
 	       getpid(), nthreads, nfutexes, fshared ? "shared":"private", nsecs);
 
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index 732403b..9837a88 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -30,16 +30,18 @@ static u_int32_t futex1 = 0, futex2 = 0;
 static unsigned int nrequeue = 1;
 
 static pthread_t *worker;
-static bool done = 0, silent = 0;
+static bool done = false, silent = false, fshared = false;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats requeuetime_stats, requeued_stats;
 static unsigned int ncpus, threads_starting, nthreads = 0;
+static int futex_flag = 0;
 
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
 	OPT_BOOLEAN( 's', "silent",   &silent,   "Silent mode: do not display data/details"),
+	OPT_BOOLEAN( 'S', "shared",   &fshared,  "Use shared futexes instead of private ones"),
 	OPT_END()
 };
 
@@ -70,7 +72,7 @@ static void *workerfn(void *arg __maybe_unused)
 	pthread_cond_wait(&thread_worker, &thread_lock);
 	pthread_mutex_unlock(&thread_lock);
 
-	futex_wait(&futex1, 0, NULL, FUTEX_PRIVATE_FLAG);
+	futex_wait(&futex1, 0, NULL, futex_flag);
 	return NULL;
 }
 
@@ -127,9 +129,12 @@ int bench_futex_requeue(int argc, const char **argv,
 	if (!worker)
 		err(EXIT_FAILURE, "calloc");
 
-	printf("Run summary [PID %d]: Requeuing %d threads (from %p to %p), "
-	       "%d at a time.\n\n",
-	       getpid(), nthreads, &futex1, &futex2, nrequeue);
+	if (!fshared)
+		futex_flag = FUTEX_PRIVATE_FLAG;
+
+	printf("Run summary [PID %d]: Requeuing %d threads (from [%s] %p to %p), "
+	       "%d at a time.\n\n",  getpid(), nthreads,
+	       fshared ? "shared":"private", &futex1, &futex2, nrequeue);
 
 	init_stats(&requeued_stats);
 	init_stats(&requeuetime_stats);
@@ -156,13 +161,14 @@ int bench_futex_requeue(int argc, const char **argv,
 
 		/* Ok, all threads are patiently blocked, start requeueing */
 		gettimeofday(&start, NULL);
-		for (nrequeued = 0; nrequeued < nthreads; nrequeued += nrequeue)
+		for (nrequeued = 0; nrequeued < nthreads; nrequeued += nrequeue) {
 			/*
 			 * Do not wakeup any tasks blocked on futex1, allowing
 			 * us to really measure futex_wait functionality.
 			 */
-			futex_cmp_requeue(&futex1, 0, &futex2, 0, nrequeue,
-					  FUTEX_PRIVATE_FLAG);
+			futex_cmp_requeue(&futex1, 0, &futex2, 0,
+					  nrequeue, futex_flag);
+		}
 		gettimeofday(&end, NULL);
 		timersub(&end, &start, &runtime);
 
@@ -175,7 +181,7 @@ int bench_futex_requeue(int argc, const char **argv,
 		}
 
 		/* everybody should be blocked on futex2, wake'em up */
-		nrequeued = futex_wake(&futex2, nthreads, FUTEX_PRIVATE_FLAG);
+		nrequeued = futex_wake(&futex2, nthreads, futex_flag);
 		if (nthreads != nrequeued)
 			warnx("couldn't wakeup all tasks (%d/%d)", nrequeued, nthreads);
 
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index 50022cb..929f762 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -31,16 +31,18 @@ static u_int32_t futex1 = 0;
 static unsigned int nwakes = 1;
 
 pthread_t *worker;
-static bool done = false, silent = false;
+static bool done = false, silent = false, fshared = false;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats waketime_stats, wakeup_stats;
 static unsigned int ncpus, threads_starting, nthreads = 0;
+static int futex_flag = 0;
 
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
 	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
+	OPT_BOOLEAN( 'S', "shared",  &fshared,  "Use shared futexes instead of private ones"),
 	OPT_END()
 };
 
@@ -58,7 +60,7 @@ static void *workerfn(void *arg __maybe_unused)
 	pthread_cond_wait(&thread_worker, &thread_lock);
 	pthread_mutex_unlock(&thread_lock);
 
-	futex_wait(&futex1, 0, NULL, FUTEX_PRIVATE_FLAG);
+	futex_wait(&futex1, 0, NULL, futex_flag);
 	return NULL;
 }
 
@@ -130,9 +132,12 @@ int bench_futex_wake(int argc, const char **argv,
 	if (!worker)
 		err(EXIT_FAILURE, "calloc");
 
-	printf("Run summary [PID %d]: blocking on %d threads (at futex %p), "
+	if (!fshared)
+		futex_flag = FUTEX_PRIVATE_FLAG;
+
+	printf("Run summary [PID %d]: blocking on %d threads (at [%s] futex %p), "
 	       "waking up %d at a time.\n\n",
-	       getpid(), nthreads, &futex1, nwakes);
+	       getpid(), nthreads, fshared ? "shared":"private",  &futex1, nwakes);
 
 	init_stats(&wakeup_stats);
 	init_stats(&waketime_stats);
@@ -160,7 +165,7 @@ int bench_futex_wake(int argc, const char **argv,
 		/* Ok, all threads are patiently blocked, start waking folks up */
 		gettimeofday(&start, NULL);
 		while (nwoken != nthreads)
-			nwoken += futex_wake(&futex1, nwakes, FUTEX_PRIVATE_FLAG);
+			nwoken += futex_wake(&futex1, nwakes, futex_flag);
 		gettimeofday(&end, NULL);
 		timersub(&end, &start, &runtime);
 
