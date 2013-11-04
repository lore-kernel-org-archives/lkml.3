Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3KDSCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:02:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3KDR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/29] perf report: Postpone setting up browser after parsing options
Date: Mon,  4 Nov 2013 14:58:56 -0300
Message-Id: <1383587947-17419-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If setup_browser() called earlier than option parsing, the actual error
message can be discarded during the terminal reset.  So move it after
setup_sorting() checks whether the sort keys are valid.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Enthusiastically-Supported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383291195-24386-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

