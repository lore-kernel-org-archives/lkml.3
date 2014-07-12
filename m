Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaGLV47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 17:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaGLV4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 17:56:54 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] perf tools: Add --debug optionto set debug variable
Date: Sat, 12 Jul 2014 23:56:28 +0200
Message-Id: <1405202188-5029-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405202188-5029-1-git-send-email-jolsa@kernel.org>
References: <1405202188-5029-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding --debug option as a way to setup debug variables.
Starting with support for verbose, more will come.

It's possible to use it now with report command:
  $ perf report --debug verbose
  $ perf report --debug verbose=2

I'll need this support to add separated debug variable
for ordered events change in order to separate debug
output out of standard verbose stream.

Also removing unneeded getopt.h includes.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  6 +++++
 tools/perf/builtin-report.c              |  2 ++
 tools/perf/util/debug.c                  | 45 ++++++++++++++++++++++++++++++++
 tools/perf/util/debug.h                  |  3 +++
 tools/perf/util/probe-finder.c           |  1 -
 tools/perf/util/trace-event-read.c       |  1 -
 6 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index d2b59af..53b6ad8 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -25,6 +25,12 @@ OPTIONS
 --verbose::
         Be more verbose. (show symbol address, etc)
 
+--debug::
+        Setup debug variable (just verbose for now) in value
+        range (0, 10). Use like:
+           --debug verbose   # sets verbose = 1
+           --debug verbose=2 # sets verbose = 2
+
 -n::
 --show-nr-samples::
 	Show the number of samples for each symbol
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 21d830b..deb8f1e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -679,6 +679,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
 		     "how to display percentage of filtered entries", parse_filter_percentage),
+	OPT_CALLBACK(0, "debug", NULL, "variable[=VALUE]",
+		     "set debug variable (verbose)", perf_debug_option),
 	OPT_END()
 	};
 	struct perf_data_file file = {
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index c208d6f..54bd12a 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -105,3 +105,48 @@ void trace_event(union perf_event *event)
 	}
 	printf(".\n");
 }
+
+static struct variables_t {
+	const char *name;
+	int *ptr;
+} variables[] = {
+	{ .name = "verbose", .ptr = &verbose },
+	{ .name = NULL, }
+};
+
+int perf_debug_option(const struct option *opt __maybe_unused, const char *str,
+		      int unset __maybe_unused)
+{
+	struct variables_t *var = &variables[0];
+	char *vstr, *s = strdup(str);
+	int v = 1;
+
+	vstr = strchr(s, '=');
+	if (vstr)
+		*vstr++ = 0;
+
+	while (var->name) {
+		if (!strcmp(s, var->name))
+			break;
+		var++;
+	}
+
+	if (!var->name) {
+		pr_err("Unknown debug variable name '%s'\n", s);
+		free(s);
+		return -1;
+	}
+
+	if (vstr) {
+		v = atoi(vstr);
+		/*
+		 * Allow only values in range (0, 10),
+		 * otherwise set 0.
+		 */
+		v = (v < 0) || (v > 10) ? 0 : v;
+	}
+
+	*var->ptr = v;
+	free(s);
+	return 0;
+}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 1cb8081..295fee5 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -7,6 +7,7 @@
 #include "../ui/helpline.h"
 #include "../ui/progress.h"
 #include "../ui/util.h"
+#include "parse-options.h"
 
 extern int verbose;
 extern bool quiet, dump_trace;
@@ -39,4 +40,6 @@ void pr_stat(const char *fmt, ...);
 
 int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 
+int perf_debug_option(const struct option *opt, const char *str, int unset);
+
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 98e3047..dca9145 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -26,7 +26,6 @@
 #include <errno.h>
 #include <stdio.h>
 #include <unistd.h>
-#include <getopt.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index ea3fd7f..54d9e9b 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -22,7 +22,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <stdarg.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-- 
1.8.3.1

