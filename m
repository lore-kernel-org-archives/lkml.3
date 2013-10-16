Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3JPFBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:01:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62800 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3JPFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:00:29 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-3a-525e1d68955d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 14/18] perf ftrace: Add a signal handler for SIGSEGV
Date: Wed, 16 Oct 2013 14:00:17 +0900
Message-Id: <1381899621-14638-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
References: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's for debugging purpose.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index fa7a9c59e228..8fec8d6df37d 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -41,6 +41,13 @@ struct perf_ftrace {
 
 static bool done;
 
+static void sig_exit(int sig)
+{
+	psignal(sig, "perf");
+	signal(sig, SIG_DFL);
+	raise(sig);
+}
+
 static void sig_handler(int sig __maybe_unused)
 {
 	done = true;
@@ -228,6 +235,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGPIPE, sig_handler);
+	signal(SIGSEGV, sig_exit);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -630,6 +638,7 @@ static int do_ftrace_record(struct perf_ftrace *ftrace)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
+	signal(SIGSEGV, sig_exit);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -1139,6 +1148,8 @@ static int do_ftrace_show(struct perf_ftrace *ftrace)
 		},
 	};
 
+	signal(SIGSEGV, sig_exit);
+
 	canonicalize_directory_name(ftrace->dirname);
 
 	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
@@ -1230,6 +1241,8 @@ static int do_ftrace_report(struct perf_ftrace *ftrace)
 	struct machine *machine;
 	struct dso *dso;
 
+	signal(SIGSEGV, sig_exit);
+
 	canonicalize_directory_name(ftrace->dirname);
 
 	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
-- 
1.7.11.7

