Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab3G3JU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:20:29 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64877 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab3G3JTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:19:30 -0400
X-AuditID: 9c930179-b7c49ae000000e68-f9-51f7851b1e04
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 15/17] perf ftrace: Add --clock option
Date: Tue, 30 Jul 2013 18:19:12 +0900
Message-Id: <1375175954-798-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375175954-798-1-git-send-email-namhyung@kernel.org>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The --clock (-c) option is for controlling trace_clock.  Default to
'perf' if exists, or 'local'.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index ed889d4dd0ba..25a07db864b4 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -35,6 +35,7 @@ struct perf_ftrace {
 	struct perf_target target;
 	const char *tracer;
 	const char *dirname;
+	const char *clock;
 	struct pevent *pevent;
 	bool show_full_info;
 };
@@ -114,6 +115,9 @@ static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
 	if (reset_tracing_cpu() < 0)
 		return -1;
 
+	if (write_tracing_file("trace_clock", "local") < 0)
+		return -1;
+
 	return 0;
 }
 
@@ -188,6 +192,24 @@ static int reset_tracing_cpu(void)
 	return 0;
 }
 
+static int set_tracing_clock(struct perf_ftrace *ftrace)
+{
+	const char *clock = ftrace->clock;
+
+	if (clock == NULL)
+		clock = "perf";
+
+	if (!write_tracing_file("trace_clock", clock))
+		return 0;
+
+	/* exit if user specified an invalid clock */
+	if (ftrace->clock)
+		return -1;
+
+	pr_debug("'perf' clock is not supported.. falling back to 'local' clock\n");
+	return write_tracing_file("trace_clock", "local");
+}
+
 static int setup_tracing_files(struct perf_ftrace *ftrace)
 {
 	int ret = -1;
@@ -213,6 +235,11 @@ static int setup_tracing_files(struct perf_ftrace *ftrace)
 		goto out;
 	}
 
+	if (set_tracing_clock(ftrace) < 0) {
+		pr_err("failed to set trace clock\n");
+		goto out;
+	}
+
 	if (write_tracing_file("current_tracer", ftrace->tracer) < 0) {
 		pr_err("failed to set current_tracer to %s\n", ftrace->tracer);
 		goto out;
@@ -1475,6 +1502,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 		    "system-wide collection from all CPUs"),
 	OPT_STRING('C', "cpu", &ftrace->target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
+	OPT_STRING('c', "clock", &ftrace->clock, "clock",
+		    "clock to be used for tracer"),
 	OPT_END()
 	};
 
@@ -1517,6 +1546,8 @@ __cmd_ftrace_record(struct perf_ftrace *ftrace, int argc, const char **argv)
 		    "list of cpus to monitor"),
 	OPT_STRING('o', "output", &ftrace->dirname, "dirname",
 		   "input directory name to use (default: perf.data)"),
+	OPT_STRING('c', "clock", &ftrace->clock, "clock",
+		    "clock to be used for tracer"),
 	OPT_END()
 	};
 
-- 
1.7.11.7

