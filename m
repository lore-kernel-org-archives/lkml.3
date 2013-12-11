Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3LKLH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:07:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3LKLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:07:22 -0500
Date: Wed, 11 Dec 2013 03:06:53 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0ehaawv5xc83w6ag03c5hi10@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386583370-1699-3-git-send-email-jolsa@redhat.com>
References: <1386583370-1699-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Add --header/--header-only options
Git-Commit-ID: e90debddf8f26094cd90162b9af2a8ed37ed57cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:07:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e90debddf8f26094cd90162b9af2a8ed37ed57cb
Gitweb:     http://git.kernel.org/tip/e90debddf8f26094cd90162b9af2a8ed37ed57cb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 9 Dec 2013 11:02:50 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:07 -0300

perf script: Add --header/--header-only options

Currently the perf.data header is always displayed for stdio output,
which is no always useful.

Disabling header information by default and adding following options to
control header output:

  --header      - display header information
  --header-only - display header information only w/o further
                  processing

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-0ehaawv5xc83w6ag03c5hi10@git.kernel.org
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
index c2a5071..05f9a0a 100644
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
index 7a571fb..f8ab125 100644
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
