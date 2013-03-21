Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3CULNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:13:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3CULNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:13:11 -0400
Date: Thu, 21 Mar 2013 04:11:38 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-acf2892270dcc4288c572b1159474c81f3819749@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1362987798-24969-7-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Use perf_evlist__prepare/
 start_workload()
Git-Commit-ID: acf2892270dcc4288c572b1159474c81f3819749
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:11:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acf2892270dcc4288c572b1159474c81f3819749
Gitweb:     http://git.kernel.org/tip/acf2892270dcc4288c572b1159474c81f3819749
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 11 Mar 2013 16:43:18 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:04 -0300

perf stat: Use perf_evlist__prepare/start_workload()

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
 tools/perf/builtin-stat.c | 58 ++++++-----------------------------------------
 1 file changed, 7 insertions(+), 51 deletions(-)

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
