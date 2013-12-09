Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab3LIKDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:03:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154Ab3LIKDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:03:23 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf script: Add --header/--header-only options
Date: Mon,  9 Dec 2013 11:02:50 +0100
Message-Id: <1386583370-1699-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the perf.data header is always displayed for stdio
output, which is no always useful.

Disabling header information by default and adding following
options to control header output:
  --header      - display header information
  --header-only - display header information only w/o further
                  processing

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
 tools/perf/Documentation/perf-script.txt |  6 ++++++
 tools/perf/builtin-script.c              | 13 ++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index cfdbb1e..ab3ce09 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -209,6 +209,12 @@ OPTIONS
 --show-mmap-events
 	Display mmap related events (e.g. MMAP, MMAP2).
 
+--header
+	Show perf.data header.
+
+--header-only
+	Show only perf.data header.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4484886..495b3b8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1484,6 +1484,8 @@ static int have_cmd(int argc, const char **argv)
 int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool show_full_info = false;
+	bool header = false;
+	bool header_only = false;
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
 	struct perf_session *session;
@@ -1522,6 +1524,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_BOOLEAN(0, "header", &header, "Show data header."),
+	OPT_BOOLEAN(0, "header-only", &header_only, "Show only data header."),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
@@ -1738,6 +1742,12 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (header || header_only) {
+		perf_session__fprintf_info(session, stdout, show_full_info);
+		if (header_only)
+			return 0;
+	}
+
 	script.session = session;
 
 	if (cpu_list) {
@@ -1745,9 +1755,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			return -1;
 	}
 
-	if (!script_name && !generate_script_lang)
-		perf_session__fprintf_info(session, stdout, show_full_info);
-
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
-- 
1.8.3.1

