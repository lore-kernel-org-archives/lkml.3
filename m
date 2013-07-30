Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab3G3JTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:19:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47887 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab3G3JT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:19:28 -0400
X-AuditID: 9c930179-b7c49ae000000e68-ec-51f78519e387
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 11/17] perf ftrace: Use pager for displaying result
Date: Tue, 30 Jul 2013 18:19:08 +0900
Message-Id: <1375175954-798-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375175954-798-1-git-send-email-namhyung@kernel.org>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's convenient to use pager when seeing many lines of result.

Note that setup_pager() should be called after perf_evlist__
prepare_workload() since they can interfere each other regarding
shared stdio streams.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index bb0a238b8509..f8e363b3c06d 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -227,6 +227,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
+	signal(SIGPIPE, sig_handler);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -1445,6 +1446,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 						  argv, false, true) < 0)
 		goto out_maps;
 
+	setup_pager();
+
 	ret = do_ftrace_live(ftrace);
 
 out_maps:
@@ -1566,6 +1569,8 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (ftrace->dirname == NULL)
 		ftrace->dirname = DEFAULT_DIRNAME;
 
+	setup_pager();
+
 	ret = do_ftrace_show(ftrace);
 
 	perf_evlist__delete_maps(ftrace->evlist);
@@ -1626,6 +1631,7 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 
 	perf_hpp__init();
 
+	setup_pager();
 	setup_sorting();
 
 	symbol_conf.exclude_other = false;
-- 
1.7.11.7

