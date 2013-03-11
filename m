Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3CKHnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:43:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42341 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3CKHna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:43:30 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-c4-513d8b203c75
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 6/7] perf evlist: Add want_signal parameter to perf_evlist__prepare_workload()
Date: Mon, 11 Mar 2013 16:43:17 +0900
Message-Id: <1362987798-24969-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In case a caller doesn't want to receive SIGUSR1 when the child failed
to exec().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c    | 3 ++-
 tools/perf/builtin-trace.c     | 2 +-
 tools/perf/tests/perf-record.c | 3 ++-
 tools/perf/util/evlist.c       | 6 ++++--
 tools/perf/util/evlist.h       | 3 ++-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2a43c4423f6a..80cc3ea07788 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -475,7 +475,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
-						    argv, opts->pipe_output);
+						    argv, opts->pipe_output,
+						    true);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
 			goto out_delete_session;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3d9944c3d851..f0c20ef0cd1c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -462,7 +462,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evlist, &trace->opts.target,
-						    argv, false);
+						    argv, false, false);
 		if (err < 0) {
 			printf("Couldn't run the workload!\n");
 			goto out_delete_evlist;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index a1c41b7d3c07..ffab5a41ff0a 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -93,7 +93,8 @@ int test__PERF_RECORD(void)
 	 * so that we have time to open the evlist (calling sys_perf_event_open
 	 * on all the fds) and then mmap them.
 	 */
-	err = perf_evlist__prepare_workload(evlist, &opts.target, argv, false);
+	err = perf_evlist__prepare_workload(evlist, &opts.target, argv,
+					    false, false);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
 		goto out_delete_maps;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 9a337f091b22..5b012b8d7a14 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -746,7 +746,8 @@ out_err:
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
-				  const char *argv[], bool pipe_output)
+				  const char *argv[], bool pipe_output,
+				  bool want_signal)
 {
 	int child_ready_pipe[2], go_pipe[2];
 	char bf;
@@ -796,7 +797,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		execvp(argv[0], (char **)argv);
 
 		perror(argv[0]);
-		kill(getppid(), SIGUSR1);
+		if (want_signal)
+			kill(getppid(), SIGUSR1);
 		exit(-1);
 	}
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 276a5acc56e6..c096da7d6d58 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -87,7 +87,8 @@ void perf_evlist__config(struct perf_evlist *evlist,
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
-				  const char *argv[], bool pipe_output);
+				  const char *argv[], bool pipe_output,
+				  bool want_signal);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-- 
1.7.11.7

