Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3CKHn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:43:29 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42341 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3CKHn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:43:27 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-8b-513d8b1d83b6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/7] perf evlist: Pass struct perf_target to perf_evlist__prepare_workload()
Date: Mon, 11 Mar 2013 16:43:15 +0900
Message-Id: <1362987798-24969-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's a preparation step of removing @opts arg from the function so
that it can be used more widely.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c    | 3 ++-
 tools/perf/builtin-trace.c     | 3 ++-
 tools/perf/tests/perf-record.c | 2 +-
 tools/perf/util/evlist.c       | 3 ++-
 tools/perf/util/evlist.h       | 1 +
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e3261eae0ad7..a80301797e89 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -474,7 +474,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	}
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evsel_list, opts, argv);
+		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
+						    opts, argv);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
 			goto out_delete_session;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6198eb11e1c6..1de3971437c9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -461,7 +461,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evlist, &trace->opts, argv);
+		err = perf_evlist__prepare_workload(evlist, &trace->opts.target,
+						    &trace->opts, argv);
 		if (err < 0) {
 			printf("Couldn't run the workload!\n");
 			goto out_delete_evlist;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index f6ba75a983a8..adf6b4a21a60 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -93,7 +93,7 @@ int test__PERF_RECORD(void)
 	 * so that we have time to open the evlist (calling sys_perf_event_open
 	 * on all the fds) and then mmap them.
 	 */
-	err = perf_evlist__prepare_workload(evlist, &opts, argv);
+	err = perf_evlist__prepare_workload(evlist, &opts.target, &opts, argv);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
 		goto out_delete_maps;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7d71a691b864..291884c804e9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -745,6 +745,7 @@ out_err:
 }
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
+				  struct perf_target *target,
 				  struct perf_record_opts *opts,
 				  const char *argv[])
 {
@@ -800,7 +801,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (perf_target__none(&opts->target))
+	if (perf_target__none(target))
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9a7b76e3a873..e089906cb4de 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -86,6 +86,7 @@ void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
+				  struct perf_target *target,
 				  struct perf_record_opts *opts,
 				  const char *argv[]);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
-- 
1.7.11.7

