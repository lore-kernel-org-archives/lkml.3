Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020Ab3LIKD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:03:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab3LIKDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:03:20 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf report: Add --header/--header-only options
Date: Mon,  9 Dec 2013 11:02:49 +0100
Message-Id: <1386583370-1699-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the perf.data header is always displayed for stdio
output, which is no always useful.

Disabling header information by default and adding following
options to control header output:
  --header      - display header information (old default)
  --header-only - display header information only w/o further
                  processing, forces stdio output

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-report.txt |  6 ++++++
 tools/perf/builtin-report.c              | 19 ++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 10a2798..e41cbfb 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -237,6 +237,12 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--header
+	Show perf.data header.
+
+--header-only
+	Show only perf.data header (forces --stdio).
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cf8e66..242fd6f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -49,6 +49,8 @@ struct perf_report {
 	bool			show_threads;
 	bool			inverted_callchain;
 	bool			mem_mode;
+	bool			header;
+	bool			header_only;
 	int			max_stack;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
@@ -514,9 +516,6 @@ static int __cmd_report(struct perf_report *rep)
 			return ret;
 	}
 
-	if (use_browser <= 0)
-		perf_session__fprintf_info(session, stdout, rep->show_full_info);
-
 	if (rep->show_threads)
 		perf_read_values_init(&rep->show_threads_values);
 
@@ -820,6 +819,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "gtk", &report.use_gtk, "Use the GTK2 interface"),
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
+	OPT_BOOLEAN(0, "header", &report.header, "Show data header."),
+	OPT_BOOLEAN(0, "header-only", &report.header_only,
+		    "Show only data header."),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
@@ -963,6 +965,10 @@ repeat:
 			goto error;
 	}
 
+	/* Force tty output for header output. */
+	if (report.header || report.header_only)
+		use_browser = 0;
+
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else {
@@ -970,6 +976,13 @@ repeat:
 		perf_hpp__init();
 	}
 
+	if (report.header || report.header_only) {
+		perf_session__fprintf_info(session, stdout,
+					   report.show_full_info);
+		if (report.header_only)
+			return 0;
+	}
+
 	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
-- 
1.8.3.1

