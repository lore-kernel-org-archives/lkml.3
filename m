Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3IXKjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:39:07 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:46015 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3IXKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:39:05 -0400
Date: Tue, 24 Sep 2013 12:39:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf bench: Change the procps visible command-name of
 invididual benchmark tests
Message-ID: <20130924103900.GA5085@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Before this patch, looking at 'perf bench sched pipe' behavior over 'top' 
only told us that something related to perf is running:

      PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
    19934 mingo     20   0 54836 1296  952 R 18.6  0.0   0:00.56 perf
    19935 mingo     20   0 54836  384   36 S 18.6  0.0   0:00.56 perf

After the patch it's clearly visible what's going on:

      PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
    19744 mingo     20   0  125m 3536 2644 R 68.2  0.0   0:01.12 sched-pipe
    19745 mingo     20   0  125m 1172  276 R 68.2  0.0   0:01.12 sched-pipe

The benchmark-subsystem name is concatenated with the individual testcase 
name.

Unfortunately 'perf top' does not show the reconfigured name, possibly 
because it caches ->comm[] values and does not recognize changes to them?

[ Also clean up a few bits in builtin-bench.c while at it. ]

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/builtin-bench.c |   58 +++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 17 deletions(-)

Index: linux/tools/perf/builtin-bench.c
===================================================================
--- linux.orig/tools/perf/builtin-bench.c
+++ linux/tools/perf/builtin-bench.c
@@ -1,21 +1,18 @@
 /*
- *
  * builtin-bench.c
  *
  * General benchmarking subsystem provided by perf
  *
  * Copyright (C) 2009, Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
- *
  */
 
 /*
- *
  * Available subsystem list:
+ *
  *  sched ... scheduler and IPC mechanism
  *  mem   ... memory access performance
- *
+ *  numa  ... NUMA placement performance measurements
  */
-
 #include "perf.h"
 #include "util/util.h"
 #include "util/parse-options.h"
@@ -25,11 +22,14 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/prctl.h>
+
+typedef int (*bench_fn_t)(int argc, const char **argv, const char *prefix);
 
 struct bench_suite {
 	const char *name;
 	const char *summary;
-	int (*fn)(int, const char **, const char *);
+	bench_fn_t fn;
 };
 						\
 /* sentinel: easy for help */
@@ -103,16 +103,14 @@ static void dump_suites(int subsys_index
 {
 	int i;
 
-	printf("# List of available suites for %s...\n\n",
-	       subsystems[subsys_index].name);
+	printf("# List of available suites for %s...\n\n", subsystems[subsys_index].name);
 
-	for (i = 0; subsystems[subsys_index].suites[i].name; i++)
+	for (i = 0; subsystems[subsys_index].suites[i].name; i++) {
 		printf("%14s: %s\n",
 		       subsystems[subsys_index].suites[i].name,
 		       subsystems[subsys_index].suites[i].summary);
-
+	}
 	printf("\n");
-	return;
 }
 
 static const char *bench_format_str;
@@ -159,7 +157,34 @@ static int bench_str2int(const char *str
 	return BENCH_FORMAT_UNKNOWN;
 }
 
-static void all_suite(struct bench_subsys *subsys)	  /* FROM HERE */
+/*
+ * Run a specific benchmark but first rename the running task's ->comm[]
+ * to something meaningful:
+ */
+static int run_bench(const char *subsys_name, const char *bench_name, bench_fn_t fn, int argc, const char **argv, const char *prefix)
+{
+	int size;
+	char *name;
+	int ret;
+
+	size = strlen(subsys_name) + 1 + strlen(bench_name) + 1;
+
+	name = zalloc(size);
+	BUG_ON(!name);
+
+	scnprintf(name, size, "%s-%s", subsys_name, bench_name);
+
+	prctl(PR_SET_NAME, name);
+	argv[0] = name;
+
+	ret = fn(argc, argv, prefix);
+
+	free(name);
+
+	return ret;
+}
+
+static void all_suites(struct bench_subsys *subsys)	  /* FROM HERE */
 {
 	int i;
 	const char *argv[2];
@@ -179,7 +204,7 @@ static void all_suite(struct bench_subsy
 		fflush(stdout);
 
 		argv[1] = suites[i].name;
-		suites[i].fn(1, argv, NULL);
+		run_bench(subsys->name, suites[i].name, suites[i].fn, 1, argv, NULL);
 		printf("\n");
 	}
 }
@@ -188,7 +213,7 @@ static void all_subsystem(void)
 {
 	int i;
 	for (i = 0; subsystems[i].suites; i++)
-		all_suite(&subsystems[i]);
+		all_suites(&subsystems[i]);
 }
 
 int cmd_bench(int argc, const char **argv, const char *prefix __maybe_unused)
@@ -231,7 +256,7 @@ int cmd_bench(int argc, const char **arg
 		}
 
 		if (!strcmp(argv[1], "all")) {
-			all_suite(&subsystems[i]);
+			all_suites(&subsystems[i]);
 			goto end;
 		}
 
@@ -244,8 +269,7 @@ int cmd_bench(int argc, const char **arg
 				       subsystems[i].name,
 				       subsystems[i].suites[j].name);
 			fflush(stdout);
-			status = subsystems[i].suites[j].fn(argc - 1,
-							    argv + 1, prefix);
+			status = run_bench(subsystems[i].name, subsystems[i].suites[j].name, subsystems[i].suites[j].fn, argc - 1, argv + 1, prefix);
 			goto end;
 		}
 
