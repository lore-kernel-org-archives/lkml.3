Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3DWIeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:34:00 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61901 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3DWIbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:31:22 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-99-517646d25dad
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/14] perf ftrace: Add support for -a and -C option
Date: Tue, 23 Apr 2013 17:31:05 +0900
Message-Id: <1366705872-12132-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -a/--all-cpus and -C/--cpu option is for controlling tracing cpus.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 2025161bbaed..04ca2303b63b 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -18,6 +18,7 @@
 #include "util/evlist.h"
 #include "util/target.h"
 #include "util/thread_map.h"
+#include "util/cpumap.h"
 
 
 #define DEFAULT_TRACER  "function_graph"
@@ -110,6 +111,26 @@ static int set_tracing_pid(struct perf_ftrace *ftrace)
 	return 0;
 }
 
+static int set_tracing_cpu(struct perf_ftrace *ftrace)
+{
+	int i;
+	unsigned long cpumask = 0;
+	char cpumask_str[sizeof(cpumask)*2 + 1];
+
+	if (!perf_target__has_cpu(&ftrace->target))
+		return 0;
+
+	for (i = 0; i < cpu_map__nr(ftrace->evlist->cpus); i++)
+		cpumask |= 1 << ftrace->evlist->cpus->map[i];
+
+	scnprintf(cpumask_str, sizeof(cpumask_str), "%lx", cpumask);
+
+	if (write_tracing_file("tracing_cpumask", cpumask_str) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
 	char *trace_file;
@@ -146,6 +167,11 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 		goto out_reset;
 	}
 
+	if (set_tracing_cpu(ftrace) < 0) {
+		pr_err("failed to set tracing cpumask\n");
+		goto out_reset;
+	}
+
 	if (write_tracing_file("current_tracer", ftrace->tracer) < 0) {
 		pr_err("failed to set current_tracer to %s\n", ftrace->tracer);
 		goto out_reset;
@@ -226,6 +252,10 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "trace on existing process id"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose"),
+	OPT_BOOLEAN('a', "all-cpus", &ftrace.target.system_wide,
+		    "system-wide collection from all CPUs"),
+	OPT_STRING('C', "cpu", &ftrace.target.cpu_list, "cpu",
+		    "list of cpus to monitor"),
 	OPT_END()
 	};
 
-- 
1.7.11.7

