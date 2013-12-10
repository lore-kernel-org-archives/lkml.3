Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3LJUcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:32:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3LJUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/34 v2] perf report: Add --header/--header-only options
Date: Tue, 10 Dec 2013 17:31:03 -0300
Message-Id: <1386707476-12370-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently the perf.data header is always displayed for stdio output,
which is no always useful.

Disabling header information by default and adding following options to
control header output:

  --header      - display header information (old default)
  --header-only - display header information only w/o further
                  processing, forces stdio output

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386583370-1699-2-git-send-email-jolsa@redhat.com
[ Added single line explaining talking about the new --header* options,
  to address David Ahern comment; better man page entry for the new options,
  from Namhyung Kim ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |  9 +++++++++
 tools/perf/builtin-report.c              | 22 +++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 10a279871251..8eab8a4bdeb8 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -237,6 +237,15 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--header::
+	Show header information in the perf.data file.  This includes
+	various information like hostname, OS and perf version, cpu/mem
+	info, perf command line, event list and so on.  Currently only
+	--stdio output supports this feature.
+
+--header-only::
+	Show only perf.data header (forces --stdio).
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cf8e66ba594..3a14dbed387c 100644
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
@@ -970,6 +976,16 @@ repeat:
 		perf_hpp__init();
 	}
 
+	if (report.header || report.header_only) {
+		perf_session__fprintf_info(session, stdout,
+					   report.show_full_info);
+		if (report.header_only)
+			return 0;
+	} else if (use_browser == 0) {
+		fputs("# To display the perf.data header info, please use --header/--header-only options.\n#\n",
+		      stdout);
+	}
+
 	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
-- 
1.8.1.4

