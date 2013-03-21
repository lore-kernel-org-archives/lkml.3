Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3CULKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:10:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab3CULKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:10:49 -0400
Date: Thu, 21 Mar 2013 04:09:19 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-119fa3c922ff53a334507e198b2e3c66e99f54dc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1362987798-24969-5-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Do not pass struct record_opts to perf_evlist__prepare_workload()
Git-Commit-ID: 119fa3c922ff53a334507e198b2e3c66e99f54dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:09:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  119fa3c922ff53a334507e198b2e3c66e99f54dc
Gitweb:     http://git.kernel.org/tip/119fa3c922ff53a334507e198b2e3c66e99f54dc
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 11 Mar 2013 16:43:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:02 -0300

perf evlist: Do not pass struct record_opts to perf_evlist__prepare_workload()

Since it's only used for checking ->pipe_output, we can pass the result
directly.

Now the perf_evlist__prepare_workload() don't have a dependency of
struct perf_record_opts, it can be called from other places like perf
stat.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    | 2 +-
 tools/perf/builtin-trace.c     | 2 +-
 tools/perf/tests/perf-record.c | 2 +-
 tools/perf/util/evlist.c       | 5 ++---
 tools/perf/util/evlist.h       | 3 +--
 5 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a803017..2a43c44 100644
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
index 1de3971..3d9944c 100644
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
index adf6b4a..a1c41b7 100644
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
index 291884c..9a337f0 100644
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
index e089906..276a5ac 100644
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
