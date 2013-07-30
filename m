Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3G3JUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:20:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47887 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365Ab3G3JTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:19:30 -0400
X-AuditID: 9c930179-b7c49ae000000e68-f8-51f7851af3c5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 14/17] perf ftrace: Add a signal handler for SIGSEGV
Date: Tue, 30 Jul 2013 18:19:11 +0900
Message-Id: <1375175954-798-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375175954-798-1-git-send-email-namhyung@kernel.org>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
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
index ad71d0412a7e..ed889d4dd0ba 100644
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
@@ -613,6 +621,7 @@ static int do_ftrace_record(struct perf_ftrace *ftrace)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
+	signal(SIGSEGV, sig_exit);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -1120,6 +1129,8 @@ static int do_ftrace_show(struct perf_ftrace *ftrace)
 		},
 	};
 
+	signal(SIGSEGV, sig_exit);
+
 	canonicalize_directory_name(ftrace->dirname);
 
 	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
@@ -1211,6 +1222,8 @@ static int do_ftrace_report(struct perf_ftrace *ftrace)
 	struct machine *machine;
 	struct dso *dso;
 
+	signal(SIGSEGV, sig_exit);
+
 	canonicalize_directory_name(ftrace->dirname);
 
 	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
-- 
1.7.11.7

