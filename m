Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3ENKOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:14:14 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46368 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab3ENKOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:08 -0400
X-AuditID: 9c930197-b7b76ae000003523-44-51920e6a6f69
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/15] perf ftrace: Add a signal handler for SIGSEGV
Date: Tue, 14 May 2013 19:13:59 +0900
Message-Id: <1368526439-31966-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
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
index 6d69bf411314..76bbbf294ec6 100644
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
@@ -602,6 +610,7 @@ static int do_ftrace_record(struct perf_ftrace *ftrace)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
+	signal(SIGSEGV, sig_exit);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -1100,6 +1109,8 @@ static int do_ftrace_show(struct perf_ftrace *ftrace)
 		},
 	};
 
+	signal(SIGSEGV, sig_exit);
+
 	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
 
 	session = perf_session__new(buf, O_RDONLY, false, false, &show.tool);
@@ -1271,6 +1282,8 @@ static int do_ftrace_report(struct perf_ftrace *ftrace)
 	struct machine *machine;
 	struct dso *dso;
 
+	signal(SIGSEGV, sig_exit);
+
 	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
 
 	session = perf_session__new(buf, O_RDONLY, false, false, &report.tool);
-- 
1.7.11.7

