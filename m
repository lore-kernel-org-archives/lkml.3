Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LJUcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:32:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34325 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3LJUbj (ORCPT
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
Subject: [PATCH 22/34] perf script: Add --header/--header-only options
Date: Tue, 10 Dec 2013 17:31:04 -0300
Message-Id: <1386707476-12370-3-git-send-email-acme@infradead.org>
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

  --header      - display header information
  --header-only - display header information only w/o further
                  processing

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386583370-1699-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |  6 ++++++
 tools/perf/builtin-script.c              | 13 ++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index c2a5071cf8f8..05f9a0a6784c 100644
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
index 7a571fb7eb8a..f8ab125aac48 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1494,6 +1494,8 @@ static int have_cmd(int argc, const char **argv)
 int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool show_full_info = false;
+	bool header = false;
+	bool header_only = false;
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
 	struct perf_session *session;
@@ -1532,6 +1534,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
 		   "do various checks like samples ordering and lost events"),
+	OPT_BOOLEAN(0, "header", &header, "Show data header."),
+	OPT_BOOLEAN(0, "header-only", &header_only, "Show only data header."),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
@@ -1748,6 +1752,12 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -1755,9 +1765,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			return -1;
 	}
 
-	if (!script_name && !generate_script_lang)
-		perf_session__fprintf_info(session, stdout, show_full_info);
-
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
-- 
1.8.1.4

