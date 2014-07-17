Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaGQIVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:21:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58805 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaGQIV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:21:26 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH] perf stat: Pass PERF_STAT_RUN environment variable for each run
Date: Thu, 17 Jul 2014 17:21:06 +0900
Message-Id: <1405585266-28268-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf stat runs multiple times via -r option, it's sometimes
useful for a workload to know which run it executing.  So pass new
PERF_STAT_RUN environment variable to the workload for each run
(starting from 1).

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-stat.c |  8 +++++---
 tools/perf/util/evlist.c  | 10 +++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 65a151e36067..53b3c99be5b3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -144,6 +144,8 @@ static struct timespec		ref_time;
 static struct cpu_map		*aggr_map;
 static int			(*aggr_get_id)(struct cpu_map *m, int cpu);
 
+int stat_run;
+
 static volatile int done = 0;
 
 struct perf_stat {
@@ -1674,7 +1676,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf stat [<options>] [<command>]",
 		NULL
 	};
-	int status = -EINVAL, run_idx;
+	int status = -EINVAL;
 	const char *mode;
 
 	setlocale(LC_ALL, "");
@@ -1812,10 +1814,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	signal(SIGABRT, skip_signal);
 
 	status = 0;
-	for (run_idx = 0; forever || run_idx < run_count; run_idx++) {
+	for (stat_run = 1; forever || stat_run <= run_count; stat_run++) {
 		if (run_count != 1 && verbose)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
-				run_idx + 1);
+				stat_run);
 
 		status = run_perf_stat(argc, argv);
 		if (forever && status != -1) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 59ef2802fcf6..3bd86aeea99d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1031,6 +1031,7 @@ out_err:
 	return err;
 }
 
+extern int stat_run;
 int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *target,
 				  const char *argv[], bool pipe_output,
 				  void (*exec_error)(int signo, siginfo_t *info, void *ucontext))
@@ -1055,6 +1056,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 	}
 
 	if (!evlist->workload.pid) {
+		char buf[32];
+
 		if (pipe_output)
 			dup2(2, 1);
 
@@ -1075,7 +1078,12 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 		if (read(go_pipe[0], &bf, 1) == -1)
 			perror("unable to read pipe");
 
-		execvp(argv[0], (char **)argv);
+		if (stat_run) {
+			snprintf(buf, sizeof(buf), "%d", stat_run);
+			setenv("PERF_STAT_RUN", buf, 1);
+		}
+
+		execvpe(argv[0], (char **)argv, environ);
 
 		if (exec_error) {
 			union sigval val;
-- 
2.0.1

