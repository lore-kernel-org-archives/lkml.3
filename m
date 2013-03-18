Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3CRQhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:37:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49372
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab3CRQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/54] perf evlist: Pass struct perf_target to perf_evlist__prepare_workload()
Date: Mon, 18 Mar 2013 13:25:02 -0300
Message-Id: <1363623939-10748-18-git-send-email-acme@infradead.org>
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

It's a preparation step of removing @opts arg from the function so that
it can be used more widely.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    3 ++-
 tools/perf/builtin-trace.c     |    3 ++-
 tools/perf/tests/perf-record.c |    2 +-
 tools/perf/util/evlist.c       |    3 ++-
 tools/perf/util/evlist.h       |    1 +
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e3261ea..a803017 100644
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
index 6198eb1..1de3971 100644
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
index f6ba75a..adf6b4a 100644
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
index 7d71a69..291884c 100644
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
index 9a7b76e..e089906 100644
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
1.7.1

