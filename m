Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbaFPSPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:23 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:48121 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaFPSPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:20 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] perf bench: sched-messaging: Support multiple runs
Date: Mon, 16 Jun 2014 11:14:21 -0700
Message-Id: <1402942467-10671-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new --repeat option in perf-bench to allow
multiple runs. This makes the avg final result much more
useful for users, including displaying statistics.

Also move up the general information output to be showed
before the actual run is done, thus allowing the user to
know what's going on earlier and not getting in the way
of each individual run.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/sched-messaging.c | 103 +++++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 40 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index df0828a..096ef5a 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -1,16 +1,15 @@
 /*
- *
  * sched-messaging.c
  *
  * messaging: Benchmark for scheduler and IPC mechanisms
  *
  * Based on hackbench by Rusty Russell <rusty@rustcorp.com.au>
  * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
- *
  */
 
 #include "../perf.h"
 #include "../util/util.h"
+#include "../util/stat.h"
 #include "../util/parse-options.h"
 #include "../builtin.h"
 #include "bench.h"
@@ -35,6 +34,7 @@ static bool use_pipes = false;
 static unsigned int loops = 100;
 static bool thread_mode = false;
 static unsigned int num_groups = 10;
+static struct stats runtime_stats;
 
 struct sender_context {
 	unsigned int num_fds;
@@ -251,6 +251,28 @@ static unsigned int group(pthread_t *pth,
 	return num_fds * 2;
 }
 
+static void print_summary(void)
+{
+	double runtime_avg = avg_stats(&runtime_stats);
+	double runtime_stddev = stddev_stats(&runtime_stats);
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf("\n%14s: %.3f sec (+-%.2f%%)\n",
+		       "Avg Total time",
+		       runtime_avg/1e3,
+		       rel_stddev_stats(runtime_stddev, runtime_avg));
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf("%.3f\n", runtime_avg/1e3);
+		break;
+	default:
+		/* reaching here is something disaster */
+		fprintf(stderr, "Unknown format:%d\n", bench_format);
+		exit(EXIT_FAILURE);
+	}
+}
+
 static const struct option options[] = {
 	OPT_BOOLEAN('p', "pipe", &use_pipes,
 		    "Use pipe() instead of socketpair()"),
@@ -269,7 +291,7 @@ static const char * const bench_sched_message_usage[] = {
 int bench_sched_messaging(int argc, const char **argv,
 		    const char *prefix __maybe_unused)
 {
-	unsigned int i, total_children, num_fds = 20;
+	unsigned int i, j, total_children, num_fds = 20;
 	struct timeval start, stop, diff;
 	unsigned long runtime;
 	int readyfds[2], wakefds[2];
@@ -283,51 +305,52 @@ int bench_sched_messaging(int argc, const char **argv,
 	if (!pth_tab)
 		barf("main:malloc()");
 
-	fdpair(readyfds);
-	fdpair(wakefds);
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("# %d sender and receiver %s per group\n",
+		       num_fds, thread_mode ? "threads" : "processes");
+		printf("# %d groups == %d %s run\n\n",
+		       num_groups, num_groups * 2 * num_fds,
+		       thread_mode ? "threads" : "processes");
+	}
+
+	init_stats(&runtime_stats);
 
-	total_children = 0;
-	for (i = 0; i < num_groups; i++)
-		total_children += group(pth_tab+total_children, num_fds,
-					readyfds[1], wakefds[0]);
+	for (j = 0; j < bench_repeat; j++) {
+		fdpair(readyfds);
+		fdpair(wakefds);
 
-	/* Wait for everyone to be ready */
-	for (i = 0; i < total_children; i++)
-		if (read(readyfds[0], &dummy, 1) != 1)
-			barf("Reading for readyfds");
+		total_children = 0;
+		for (i = 0; i < num_groups; i++)
+			total_children += group(pth_tab+total_children, num_fds,
+						readyfds[1], wakefds[0]);
 
-	gettimeofday(&start, NULL);
+		/* Wait for everyone to be ready */
+		for (i = 0; i < total_children; i++)
+			if (read(readyfds[0], &dummy, 1) != 1)
+				barf("Reading for readyfds");
 
-	/* Kick them off */
-	if (write(wakefds[1], &dummy, 1) != 1)
-		barf("Writing to start them");
+		gettimeofday(&start, NULL);
 
-	/* Reap them all */
-	for (i = 0; i < total_children; i++)
-		reap_worker(pth_tab[i]);
+		/* Kick them off */
+		if (write(wakefds[1], &dummy, 1) != 1)
+			barf("Writing to start them");
 
-	gettimeofday(&stop, NULL);
-	timersub(&stop, &start, &diff);
-	runtime = (diff.tv_sec * 1e3) + (diff.tv_usec/1e3);
+		/* Reap them all */
+		for (i = 0; i < total_children; i++)
+			reap_worker(pth_tab[i]);
 
-	switch (bench_format) {
-	case BENCH_FORMAT_DEFAULT:
-		printf("# %d sender and receiver %s per group\n",
-		       num_fds, thread_mode ? "threads" : "processes");
-		printf("# %d groups == %d %s run\n\n",
-		       num_groups, num_groups * 2 * num_fds,
-		       thread_mode ? "threads" : "processes");
-		printf(" %14s: %.3f [sec]\n", "Total time", runtime/1e3);
-		break;
-	case BENCH_FORMAT_SIMPLE:
-		printf("%.3f\n", runtime/1e3);
-		break;
-	default:
-		/* reaching here is something disaster */
-		fprintf(stderr, "Unknown format:%d\n", bench_format);
-		exit(1);
-		break;
+		gettimeofday(&stop, NULL);
+		timersub(&stop, &start, &diff);
+		runtime = (diff.tv_sec * 1e3) + (diff.tv_usec/1e3);
+		update_stats(&runtime_stats, runtime);
+
+		if (bench_format == BENCH_FORMAT_DEFAULT)
+			printf("[Run %d]: Total Time: %.3f sec\n",
+			       j + 1,  runtime/1e3);
+
+		usleep(100000);
 	}
 
+	print_summary();
 	return 0;
 }
-- 
1.8.1.4

