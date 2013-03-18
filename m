Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3CRQlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:41:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3CRQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/54] perf stat: Use perf_evlist__prepare/start_workload()
Date: Mon, 18 Mar 2013 13:25:05 -0300
Message-Id: <1363623939-10748-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf stat had an open code to the duplicated work.  Use the helper
as it now can be called without struct perf_record_opts.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   58 +++++---------------------------------------
 1 files changed, 7 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 20ffaf9..69fe6ed 100644
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
1.7.1

