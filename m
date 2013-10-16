Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab3JPFDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:03:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65065 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3JPFA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:00:28 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-35-525e1d686a04
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 11/18] perf ftrace: Use pager for displaying result
Date: Wed, 16 Oct 2013 14:00:14 +0900
Message-Id: <1381899621-14638-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
References: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
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
index 676b2aa7590f..83ed6d797087 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -227,6 +227,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
+	signal(SIGPIPE, sig_handler);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -1465,6 +1466,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 						  argv, false, true) < 0)
 		goto out_maps;
 
+	setup_pager();
+
 	ret = do_ftrace_live(ftrace);
 
 out_maps:
@@ -1586,6 +1589,8 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (ftrace->dirname == NULL)
 		ftrace->dirname = DEFAULT_DIRNAME;
 
+	setup_pager();
+
 	ret = do_ftrace_show(ftrace);
 
 	perf_evlist__delete_maps(ftrace->evlist);
@@ -1646,6 +1651,7 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 
 	perf_hpp__init();
 
+	setup_pager();
 	setup_sorting();
 
 	symbol_conf.exclude_other = false;
-- 
1.7.11.7

