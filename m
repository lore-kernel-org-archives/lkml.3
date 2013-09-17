Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3IQLnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:43:01 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53895 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3IQLnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:43:00 -0400
Date: Tue, 17 Sep 2013 13:42:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf bench sched: Add --threaded 0/1 option
Message-ID: <20130917114256.GA31159@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow the measurement of thread versus process context switch performance.

The default stays at 'process' based measurement, like lmbench's lat_ctx 
benchmark.

Sample output:

 comet:~/tip/tools/perf> taskset 1 ./perf bench sched pipe --threaded 0
 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two processes

     Total time: 4.138 [sec]

       4.138729 usecs/op
         241620 ops/sec
 comet:~/tip/tools/perf> taskset 1 ./perf bench sched pipe --threaded 1
 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two threads

     Total time: 3.667 [sec]

       3.667667 usecs/op
         272652 ops/sec

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 69cfba8..7630dc6 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -28,12 +28,25 @@
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
 static int loops = LOOPS_DEFAULT;
 
+static int threaded = 0;
+
 static const struct option options[] = {
 	OPT_INTEGER('l', "loop", &loops,
 		    "Specify number of loops"),
+	OPT_INTEGER('T', "threaded", &threaded,
+		    "Specify threaded/process based task setup"),
 	OPT_END()
 };
 
@@ -42,13 +55,38 @@ static const char * const bench_sched_pipe_usage[] = {
 	NULL
 };
 
+static void *worker_thread(void *__tdata)
+{
+        struct thread_data *td = __tdata;
+	int m = 0, i;
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
 int bench_sched_pipe(int argc, const char **argv,
 		     const char *prefix __maybe_unused)
 {
+	struct thread_data threads[2], *td;
 	int pipe_1[2], pipe_2[2];
-	int m = 0, i;
 	struct timeval start, stop, diff;
 	unsigned long long result_usec = 0;
+	int nr_threads = 2;
+	int t;
 
 	/*
 	 * why does "ret" exist?
@@ -58,43 +96,66 @@ int bench_sched_pipe(int argc, const char **argv,
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
