Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3CRQhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:37:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49370
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639Ab3CRQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/54] perf evlist: Add want_signal parameter to perf_evlist__prepare_workload()
Date: Mon, 18 Mar 2013 13:25:04 -0300
Message-Id: <1363623939-10748-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In case a caller doesn't want to receive SIGUSR1 when the child failed
to exec().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    3 ++-
 tools/perf/builtin-trace.c     |    2 +-
 tools/perf/tests/perf-record.c |    3 ++-
 tools/perf/util/evlist.c       |    6 ++++--
 tools/perf/util/evlist.h       |    3 ++-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2a43c44..80cc3ea 100644
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
index 3d9944c..f0c20ef 100644
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
index a1c41b7..ffab5a4 100644
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
index 9a337f0..5b012b8 100644
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
index 276a5ac..c096da7 100644
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
1.7.1

