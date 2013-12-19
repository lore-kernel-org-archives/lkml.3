Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3LSHAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:00:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47179 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3LSHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:00:15 -0500
X-AuditID: 9c930179-b7bedae000000f15-6f-52b2997d3c6d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/6] perf report: Use pr_*() functions if possible
Date: Thu, 19 Dec 2013 16:00:06 +0900
Message-Id: <1387436411-20160-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There're some places printing a message to stdout/err directly.  It
should be converted to use proper error printing functions instead.

If it's not possible, just do it when --stdio was enabled only.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3a14dbed387c..a1f72b471a96 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -321,8 +321,8 @@ static int process_sample_event(struct perf_tool *tool,
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
-		fprintf(stderr, "problem processing %d event, skipping it.\n",
-			event->header.type);
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
 		return -1;
 	}
 
@@ -552,15 +552,17 @@ static int __cmd_report(struct perf_report *rep)
 		desc);
 	}
 
-	if (verbose > 3)
-		perf_session__fprintf(session, stdout);
+	if (use_browser == 0) {
+		if (verbose > 3)
+			perf_session__fprintf(session, stdout);
 
-	if (verbose > 2)
-		perf_session__fprintf_dsos(session, stdout);
+		if (verbose > 2)
+			perf_session__fprintf_dsos(session, stdout);
 
-	if (dump_trace) {
-		perf_session__fprintf_nr_events(session, stdout);
-		return 0;
+		if (dump_trace) {
+			perf_session__fprintf_nr_events(session, stdout);
+			return 0;
+		}
 	}
 
 	nr_samples = 0;
@@ -720,7 +722,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		return -1;
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
-		fprintf(stderr, "Can't register callchain params\n");
+		pr_err("Can't register callchain params\n");
 		return -1;
 	}
 	return 0;
@@ -942,7 +944,7 @@ repeat:
 	}
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
-			fprintf(stderr, "branch and mem mode incompatible\n");
+			pr_err("branch and mem mode incompatible\n");
 			goto error;
 		}
 		sort__mode = SORT_MODE__MEMORY;
-- 
1.7.11.7

