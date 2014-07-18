Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537AbaGRE2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:28:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaGRE21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:28:27 -0400
Date: Thu, 17 Jul 2014 21:28:09 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-bbb2cea7e8dd496b41558df1a0ec9205497b7ebf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <20140717105500.GG516@krava.redhat.com>
References: <20140717105500.GG516@krava.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add --debug optionto set debug variable
Git-Commit-ID: bbb2cea7e8dd496b41558df1a0ec9205497b7ebf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbb2cea7e8dd496b41558df1a0ec9205497b7ebf
Gitweb:     http://git.kernel.org/tip/bbb2cea7e8dd496b41558df1a0ec9205497b7ebf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 17 Jul 2014 12:55:00 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jul 2014 12:58:59 -0300

perf tools: Add --debug optionto set debug variable

Adding --debug option as a way to setup debug variables.  Starting with
support for verbose, more will come.

It's possible to use it now with report command:
  $ perf --debug verbose   ...
  $ perf --debug verbose=2 ...

I'll need this support to add separated debug variable for ordered
events change in order to separate debug output out of standard verbose
stream.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140717105500.GG516@krava.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf.txt | 10 ++++++++-
 tools/perf/perf.c                 | 13 +++++++++++-
 tools/perf/util/debug.c           | 44 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/debug.h           |  2 ++
 4 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index 0eeb247..d240bb2 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -8,7 +8,15 @@ perf - Performance analysis tools for Linux
 SYNOPSIS
 --------
 [verse]
-'perf' [--version] [--help] COMMAND [ARGS]
+'perf' [--version] [--help] [OPTIONS] COMMAND [ARGS]
+
+OPTIONS
+-------
+--debug::
+	Setup debug variable (just verbose for now) in value
+	range (0, 10). Use like:
+	  --debug verbose   # sets verbose = 1
+	  --debug verbose=2 # sets verbose = 2
 
 DESCRIPTION
 -----------
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 95c58fc..eed3fb2 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,11 +13,12 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
+#include "util/debug.h"
 #include <api/fs/debugfs.h>
 #include <pthread.h>
 
 const char perf_usage_string[] =
-	"perf [--version] [--help] COMMAND [ARGS]";
+	"perf [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]";
 
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
@@ -212,6 +213,16 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				printf("%s ", p->cmd);
 			}
 			exit(0);
+		} else if (!strcmp(cmd, "--debug")) {
+			if (*argc < 2) {
+				fprintf(stderr, "No variable specified for --debug.\n");
+				usage(perf_usage_string);
+			}
+			if (perf_debug_option((*argv)[1]))
+				usage(perf_usage_string);
+
+			(*argv)++;
+			(*argc)--;
 		} else {
 			fprintf(stderr, "Unknown option: %s\n", cmd);
 			usage(perf_usage_string);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index c208d6f..71d4193 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -105,3 +105,47 @@ void trace_event(union perf_event *event)
 	}
 	printf(".\n");
 }
+
+static struct debug_variable {
+	const char *name;
+	int *ptr;
+} debug_variables[] = {
+	{ .name = "verbose", .ptr = &verbose },
+	{ .name = NULL, }
+};
+
+int perf_debug_option(const char *str)
+{
+	struct debug_variable *var = &debug_variables[0];
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
index 1cb8081..89fb6b0 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -39,4 +39,6 @@ void pr_stat(const char *fmt, ...);
 
 int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 
+int perf_debug_option(const char *str);
+
 #endif	/* __PERF_DEBUG_H */
