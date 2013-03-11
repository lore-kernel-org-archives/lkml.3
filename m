Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3CKHno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:43:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42341 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3CKHnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:43:31 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-d6-513d8b21fc4c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 7/7] perf stat: use perf_evlist__prepare/start_workload()
Date: Mon, 11 Mar 2013 16:43:18 +0900
Message-Id: <1362987798-24969-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf stat had an open code to the duplicated work.  Use the helper
as it now can be called without struct perf_record_opts.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-stat.c | 58 ++++++-----------------------------------------
 1 file changed, 7 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 20ffaf98782e..69fe6ed89627 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -337,16 +337,14 @@ static void print_interval(void)
 	}
 }
 
-static int __run_perf_stat(int argc __maybe_unused, const char **argv)
+static int __run_perf_stat(int argc, const char **argv)
 {
 	char msg[512];
 	unsigned long long t0, t1;
 	struct perf_evsel *counter;
 	struct timespec ts;
 	int status = 0;
-	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
-	char buf;
 
 	if (interval) {
 		ts.tv_sec  = interval / 1000;
@@ -362,55 +360,12 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 		return -1;
 	}
 
-	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
-		perror("failed to create pipes");
-		return -1;
-	}
-
 	if (forks) {
-		if ((child_pid = fork()) < 0)
-			perror("failed to fork");
-
-		if (!child_pid) {
-			close(child_ready_pipe[0]);
-			close(go_pipe[1]);
-			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
-
-			/*
-			 * Do a dummy execvp to get the PLT entry resolved,
-			 * so we avoid the resolver overhead on the real
-			 * execvp call.
-			 */
-			execvp("", (char **)argv);
-
-			/*
-			 * Tell the parent we're ready to go
-			 */
-			close(child_ready_pipe[1]);
-
-			/*
-			 * Wait until the parent tells us to go.
-			 */
-			if (read(go_pipe[0], &buf, 1) == -1)
-				perror("unable to read pipe");
-
-			execvp(argv[0], (char **)argv);
-
-			perror(argv[0]);
-			exit(-1);
+		if (perf_evlist__prepare_workload(evsel_list, &target, argv,
+						  false, false) < 0) {
+			perror("failed to prepare workload");
+			return -1;
 		}
-
-		if (perf_target__none(&target))
-			evsel_list->threads->map[0] = child_pid;
-
-		/*
-		 * Wait for the child to be ready to exec.
-		 */
-		close(child_ready_pipe[1]);
-		close(go_pipe[0]);
-		if (read(child_ready_pipe[0], &buf, 1) == -1)
-			perror("unable to read pipe");
-		close(child_ready_pipe[0]);
 	}
 
 	if (group)
@@ -457,7 +412,8 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
 	if (forks) {
-		close(go_pipe[1]);
+		perf_evlist__start_workload(evsel_list);
+
 		if (interval) {
 			while (!waitpid(child_pid, &status, WNOHANG)) {
 				nanosleep(&ts, NULL);
-- 
1.7.11.7

