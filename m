Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3JOF3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:29:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab3JOF3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:30 -0400
Date: Mon, 14 Oct 2013 22:28:42 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-a9faa0cab619fad380c2669825aa84212943d528@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        jolsa@redhat.com, acme@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        jolsa@redhat.com, acme@infradead.org, tglx@linutronix.de
In-Reply-To: <20130917114256.GA31159@gmail.com>
References: <20130917114256.GA31159@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench sched: Add --threaded option
Git-Commit-ID: a9faa0cab619fad380c2669825aa84212943d528
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:28:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9faa0cab619fad380c2669825aa84212943d528
Gitweb:     http://git.kernel.org/tip/a9faa0cab619fad380c2669825aa84212943d528
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 23 Sep 2013 10:17:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:25 -0300

perf bench sched: Add --threaded option

Allow the measurement of thread versus process context switch
performance.

The default stays at 'process' based measurement, like lmbench's lat_ctx
benchmark.

Sample output:

 comet:~/tip/tools/perf> taskset 1 ./perf bench sched pipe
 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two processes

     Total time: 4.138 [sec]

       4.138729 usecs/op
         241620 ops/sec
 comet:~/tip/tools/perf> taskset 1 ./perf bench sched pipe --threaded
 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two threads

     Total time: 3.667 [sec]

       3.667667 usecs/op
         272652 ops/sec

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Link: http://lkml.kernel.org/r/20130917114256.GA31159@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/sched-pipe.c | 115 +++++++++++++++++++++++++++++++-----------
 1 file changed, 86 insertions(+), 29 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 69cfba8..07a8d76 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -7,9 +7,7 @@
  * Based on pipe-test-1m.c by Ingo Molnar <mingo@redhat.com>
  *  http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
  * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
- *
  */
-
 #include "../perf.h"
 #include "../util/util.h"
 #include "../util/parse-options.h"
@@ -28,12 +26,24 @@
 #include <sys/time.h>
 #include <sys/types.h>
 
+#include <pthread.h>
+
+struct thread_data {
+	int			nr;
+	int			pipe_read;
+	int			pipe_write;
+	pthread_t		pthread;
+};
+
 #define LOOPS_DEFAULT 1000000
-static int loops = LOOPS_DEFAULT;
+static	int			loops = LOOPS_DEFAULT;
+
+/* Use processes by default: */
+static bool			threaded;
 
 static const struct option options[] = {
-	OPT_INTEGER('l', "loop", &loops,
-		    "Specify number of loops"),
+	OPT_INTEGER('l', "loop",	&loops,		"Specify number of loops"),
+	OPT_BOOLEAN('T', "threaded",	&threaded,	"Specify threads/process based task setup"),
 	OPT_END()
 };
 
@@ -42,13 +52,37 @@ static const char * const bench_sched_pipe_usage[] = {
 	NULL
 };
 
-int bench_sched_pipe(int argc, const char **argv,
-		     const char *prefix __maybe_unused)
+static void *worker_thread(void *__tdata)
 {
-	int pipe_1[2], pipe_2[2];
+	struct thread_data *td = __tdata;
 	int m = 0, i;
+	int ret;
+
+	for (i = 0; i < loops; i++) {
+		if (!td->nr) {
+			ret = read(td->pipe_read, &m, sizeof(int));
+			BUG_ON(ret != sizeof(int));
+			ret = write(td->pipe_write, &m, sizeof(int));
+			BUG_ON(ret != sizeof(int));
+		} else {
+			ret = write(td->pipe_write, &m, sizeof(int));
+			BUG_ON(ret != sizeof(int));
+			ret = read(td->pipe_read, &m, sizeof(int));
+			BUG_ON(ret != sizeof(int));
+		}
+	}
+
+	return NULL;
+}
+
+int bench_sched_pipe(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	struct thread_data threads[2], *td;
+	int pipe_1[2], pipe_2[2];
 	struct timeval start, stop, diff;
 	unsigned long long result_usec = 0;
+	int nr_threads = 2;
+	int t;
 
 	/*
 	 * why does "ret" exist?
@@ -58,43 +92,66 @@ int bench_sched_pipe(int argc, const char **argv,
 	int __maybe_unused ret, wait_stat;
 	pid_t pid, retpid __maybe_unused;
 
-	argc = parse_options(argc, argv, options,
-			     bench_sched_pipe_usage, 0);
+	argc = parse_options(argc, argv, options, bench_sched_pipe_usage, 0);
 
 	BUG_ON(pipe(pipe_1));
 	BUG_ON(pipe(pipe_2));
 
-	pid = fork();
-	assert(pid >= 0);
-
 	gettimeofday(&start, NULL);
 
-	if (!pid) {
-		for (i = 0; i < loops; i++) {
-			ret = read(pipe_1[0], &m, sizeof(int));
-			ret = write(pipe_2[1], &m, sizeof(int));
-		}
-	} else {
-		for (i = 0; i < loops; i++) {
-			ret = write(pipe_1[1], &m, sizeof(int));
-			ret = read(pipe_2[0], &m, sizeof(int));
+	for (t = 0; t < nr_threads; t++) {
+		td = threads + t;
+
+		td->nr = t;
+
+		if (t == 0) {
+			td->pipe_read = pipe_1[0];
+			td->pipe_write = pipe_2[1];
+		} else {
+			td->pipe_write = pipe_1[1];
+			td->pipe_read = pipe_2[0];
 		}
 	}
 
-	gettimeofday(&stop, NULL);
-	timersub(&stop, &start, &diff);
 
-	if (pid) {
+	if (threaded) {
+
+		for (t = 0; t < nr_threads; t++) {
+			td = threads + t;
+
+			ret = pthread_create(&td->pthread, NULL, worker_thread, td);
+			BUG_ON(ret);
+		}
+
+		for (t = 0; t < nr_threads; t++) {
+			td = threads + t;
+
+			ret = pthread_join(td->pthread, NULL);
+			BUG_ON(ret);
+		}
+
+	} else {
+		pid = fork();
+		assert(pid >= 0);
+
+		if (!pid) {
+			worker_thread(threads + 0);
+			exit(0);
+		} else {
+			worker_thread(threads + 1);
+		}
+
 		retpid = waitpid(pid, &wait_stat, 0);
 		assert((retpid == pid) && WIFEXITED(wait_stat));
-	} else {
-		exit(0);
 	}
 
+	gettimeofday(&stop, NULL);
+	timersub(&stop, &start, &diff);
+
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
-		printf("# Executed %d pipe operations between two tasks\n\n",
-			loops);
+		printf("# Executed %d pipe operations between two %s\n\n",
+			loops, threaded ? "threads" : "processes");
 
 		result_usec = diff.tv_sec * 1000000;
 		result_usec += diff.tv_usec;
