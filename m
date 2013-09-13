Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3IMFir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 01:38:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31898 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3IMFiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 01:38:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] perf: fix core dump for "perf bench all"
Date: Thu, 12 Sep 2013 22:37:47 -0700
Message-Id: <1379050667-4357-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When numa for perf bench is compiled will have core dump.

| #./perf bench numa all
| # Running numa/mem benchmark...
|
| Segmentation fault (core dumped)
| # ./perf bench all
| # Running numa/mem benchmark...
|
| Segmentation fault (core dumped)

Fix it by adding own handler for numa bench. all_suite()
will search and find handler call it first, if can not
find it, will fallback the old way.

Also fix argv setting in that function, we should use [0]
as argc is 1.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 tools/perf/bench/bench.h   |    1 +
 tools/perf/bench/numa.c    |    5 +++--
 tools/perf/builtin-bench.c |   19 +++++++++++++++++--
 3 files changed, 21 insertions(+), 4 deletions(-)

Index: linux-2.6/tools/perf/bench/bench.h
===================================================================
--- linux-2.6.orig/tools/perf/bench/bench.h
+++ linux-2.6/tools/perf/bench/bench.h
@@ -26,6 +26,7 @@
 #endif
 
 extern int bench_numa(int argc, const char **argv, const char *prefix);
+int bench_numa_all(int argc, const char **argv, const char *prefix);
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv,
Index: linux-2.6/tools/perf/bench/numa.c
===================================================================
--- linux-2.6.orig/tools/perf/bench/numa.c
+++ linux-2.6/tools/perf/bench/numa.c
@@ -1691,7 +1691,8 @@ static const char *tests[][MAX_ARGS] = {
 			  "mem",  "-p",  "2", "-t", "16", "-T",  "192", OPT_BW_NOTHP },
 };
 
-static int bench_all(void)
+int bench_numa_all(int argc __maybe_unused, const char **argv __maybe_unused,
+			 const char *prefix __maybe_unused)
 {
 	int nr = ARRAY_SIZE(tests);
 	int ret;
@@ -1718,7 +1719,7 @@ int bench_numa(int argc, const char **ar
 		goto err;
 
 	if (p0.run_all)
-		return bench_all();
+		return bench_numa_all(argc, argv, prefix);
 
 	if (__bench_numa(NULL))
 		goto err;
Index: linux-2.6/tools/perf/builtin-bench.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-bench.c
+++ linux-2.6/tools/perf/builtin-bench.c
@@ -40,7 +40,7 @@ static struct bench_suite numa_suites[]
 	{ "mem",
 	  "Benchmark for NUMA workloads",
 	  bench_numa },
-	suite_all,
+	{ "all", "Test all benchmark suites", bench_numa_all },
 	{ NULL,
 	  NULL,
 	  NULL                  }
@@ -166,6 +166,21 @@ static void all_suite(struct bench_subsy
 	struct bench_suite *suites = subsys->suites;
 
 	argv[1] = NULL;
+
+	/* own all handling ? */
+	for (i = 0; suites[i].fn; i++) {
+		if (!strcmp("all", suites[i].name)) {
+			printf("# Running %s/%s benchmark...\n",
+			       subsys->name,
+			       suites[i].name);
+			fflush(stdout);
+
+			argv[0] = suites[i].name;
+			suites[i].fn(1, argv, NULL);
+			return;
+		}
+	}
+
 	/*
 	 * TODO:
 	 * preparing preset parameters for
@@ -178,7 +193,7 @@ static void all_suite(struct bench_subsy
 		       suites[i].name);
 		fflush(stdout);
 
-		argv[1] = suites[i].name;
+		argv[0] = suites[i].name;
 		suites[i].fn(1, argv, NULL);
 		printf("\n");
 	}
