Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3KAHd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:33:57 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44679 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3KAHdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:33:19 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-27-5273593d402c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/5] perf report: Postpone setting up browser after parsing options
Date: Fri,  1 Nov 2013 16:33:12 +0900
Message-Id: <1383291195-24386-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383291195-24386-1-git-send-email-namhyung@kernel.org>
References: <1383291195-24386-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If setup_browser() called earlier than option parsing, the actual
error message can be discarded during the terminal reset.  So move it
after setup_sorting() checks whether the sort keys are valid.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 98d3891392e2..4df3161c7df2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -905,13 +905,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			input_name = "perf.data";
 	}
 
-	if (strcmp(input_name, "-") != 0)
-		setup_browser(true);
-	else {
-		use_browser = 0;
-		perf_hpp__init();
-	}
-
 	file.path  = input_name;
 	file.force = report.force;
 
@@ -957,6 +950,18 @@ repeat:
 	if (setup_sorting() < 0)
 		usage_with_options(report_usage, options);
 
+	if (parent_pattern != default_parent_pattern) {
+		if (sort_dimension__add("parent") < 0)
+			goto error;
+	}
+
+	if (strcmp(input_name, "-") != 0)
+		setup_browser(true);
+	else {
+		use_browser = 0;
+		perf_hpp__init();
+	}
+
 	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
@@ -986,11 +991,6 @@ repeat:
 	if (symbol__init() < 0)
 		goto error;
 
-	if (parent_pattern != default_parent_pattern) {
-		if (sort_dimension__add("parent") < 0)
-			goto error;
-	}
-
 	if (argc) {
 		/*
 		 * Special case: if there's an argument left then assume that
-- 
1.7.11.7

