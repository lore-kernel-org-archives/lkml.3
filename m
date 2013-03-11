Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3CKHn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:43:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42341 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3CKHn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:43:29 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-a8-513d8b1e052d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 5/7] perf evlist: Do not pass struct record_opts to perf_evlist__prepare_workload()
Date: Mon, 11 Mar 2013 16:43:16 +0900
Message-Id: <1362987798-24969-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since it's only used for checking ->pipe_output, we can pass the
result directly.

Now the perf_evlist__prepare_workload() don't have a dependency of
struct perf_record_opts, it can be called from other places like perf
stat.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c    | 2 +-
 tools/perf/builtin-trace.c     | 2 +-
 tools/perf/tests/perf-record.c | 2 +-
 tools/perf/util/evlist.c       | 5 ++---
 tools/perf/util/evlist.h       | 3 +--
 5 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a80301797e89..2a43c4423f6a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -475,7 +475,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
-						    opts, argv);
+						    argv, opts->pipe_output);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
 			goto out_delete_session;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1de3971437c9..3d9944c3d851 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -462,7 +462,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evlist, &trace->opts.target,
-						    &trace->opts, argv);
+						    argv, false);
 		if (err < 0) {
 			printf("Couldn't run the workload!\n");
 			goto out_delete_evlist;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index adf6b4a21a60..a1c41b7d3c07 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -93,7 +93,7 @@ int test__PERF_RECORD(void)
 	 * so that we have time to open the evlist (calling sys_perf_event_open
 	 * on all the fds) and then mmap them.
 	 */
-	err = perf_evlist__prepare_workload(evlist, &opts.target, &opts, argv);
+	err = perf_evlist__prepare_workload(evlist, &opts.target, argv, false);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
 		goto out_delete_maps;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 291884c804e9..9a337f091b22 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -746,8 +746,7 @@ out_err:
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
-				  struct perf_record_opts *opts,
-				  const char *argv[])
+				  const char *argv[], bool pipe_output)
 {
 	int child_ready_pipe[2], go_pipe[2];
 	char bf;
@@ -769,7 +768,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 	}
 
 	if (!evlist->workload.pid) {
-		if (opts->pipe_output)
+		if (pipe_output)
 			dup2(2, 1);
 
 		close(child_ready_pipe[0]);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index e089906cb4de..276a5acc56e6 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -87,8 +87,7 @@ void perf_evlist__config(struct perf_evlist *evlist,
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
-				  struct perf_record_opts *opts,
-				  const char *argv[]);
+				  const char *argv[], bool pipe_output);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-- 
1.7.11.7

