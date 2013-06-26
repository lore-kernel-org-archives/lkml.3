Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3FZHOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:14:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58756 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3FZHOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:34 -0400
X-AuditID: 9c930179-b7cafae000004567-a1-51ca94d36ef5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/19] perf ftrace: Add --clock option
Date: Wed, 26 Jun 2013 16:14:20 +0900
Message-Id: <1372230862-15861-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
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
index 3b6bcc29715b..48dc54851765 100644
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
@@ -113,6 +114,9 @@ static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
 	if (reset_tracing_cpu() < 0)
 		return -1;
 
+	if (write_tracing_file("trace_clock", "local") < 0)
+		return -1;
+
 	return 0;
 }
 
@@ -187,6 +191,24 @@ static int reset_tracing_cpu(void)
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
@@ -212,6 +234,11 @@ static int setup_tracing_files(struct perf_ftrace *ftrace)
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
@@ -1445,6 +1472,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 		    "system-wide collection from all CPUs"),
 	OPT_STRING('C', "cpu", &ftrace->target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
+	OPT_STRING('c', "clock", &ftrace->clock, "clock",
+		    "clock to be used for tracer"),
 	OPT_END()
 	};
 
@@ -1487,6 +1516,8 @@ __cmd_ftrace_record(struct perf_ftrace *ftrace, int argc, const char **argv)
 		    "list of cpus to monitor"),
 	OPT_STRING('o', "output", &ftrace->dirname, "dirname",
 		   "input directory name to use (default: perf.data)"),
+	OPT_STRING('c', "clock", &ftrace->clock, "clock",
+		    "clock to be used for tracer"),
 	OPT_END()
 	};
 
-- 
1.7.11.7

