Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3JCR25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab3JCR2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:28:55 -0400
From: Petr Holasek <pholasek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Petr Holasek <pholasek@redhat.com>,
        Petr Benas <pbenas@redhat.com>
Subject: [PATCH] perf: Fix failing assertions in perf bench numa
Date: Thu,  3 Oct 2013 19:28:45 +0200
Message-Id: <1380821325-4017-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds more subtle handling of -C and -N parameters in
parse_{cpu,node}_setup_list() functions when there isn't enough NUMA nodes or
CPUs present.
Instead of assertion and terminating benchmark, partial test is skipped
with error message and perf will continue to the next one.

Fixed problem can be easily reproduced on machine with only one NUMA node:

 # Running numa/mem benchmark...

  # Running main, "perf bench numa mem -a"

...

 # Running RAM-bw-remote, "perf bench numa mem -p 1 -t 1 -P 1024 -C 0 -M 1 -s
perf: bench/numa.c:622: parse_setup_node_list: Assertion `!(bind_node_0 < 0 ||
		bind_node_0 >= g->p.nr_nodes)' failed.
Aborted

Signed-off-by: Petr Benas <pbenas@redhat.com>
Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 tools/perf/bench/numa.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c32..64fa01c 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -429,14 +429,14 @@ static int parse_cpu_list(const char *arg)
 	return 0;
 }
 
-static void parse_setup_cpu_list(void)
+static int parse_setup_cpu_list(void)
 {
 	struct thread_data *td;
 	char *str0, *str;
 	int t;
 
 	if (!g->p.cpu_list_str)
-		return;
+		return 0;
 
 	dprintf("g->p.nr_tasks: %d\n", g->p.nr_tasks);
 
@@ -500,8 +500,12 @@ static void parse_setup_cpu_list(void)
 
 		dprintf("CPUs: %d_%d-%d#%dx%d\n", bind_cpu_0, bind_len, bind_cpu_1, step, mul);
 
-		BUG_ON(bind_cpu_0 < 0 || bind_cpu_0 >= g->p.nr_cpus);
-		BUG_ON(bind_cpu_1 < 0 || bind_cpu_1 >= g->p.nr_cpus);
+		if (bind_cpu_0 >= g->p.nr_cpus || bind_cpu_1 >= g->p.nr_cpus) {
+			printf("\nTest not applicable, system has only %d CPUs.\n", g->p.nr_cpus);
+			return -1;
+		}
+
+		BUG_ON(bind_cpu_0 < 0 || bind_cpu_1 < 0);
 		BUG_ON(bind_cpu_0 > bind_cpu_1);
 
 		for (bind_cpu = bind_cpu_0; bind_cpu <= bind_cpu_1; bind_cpu += step) {
@@ -541,6 +545,7 @@ out:
 		printf("# NOTE: %d tasks bound, %d tasks unbound\n", t, g->p.nr_tasks - t);
 
 	free(str0);
+	return 0;
 }
 
 static int parse_cpus_opt(const struct option *opt __maybe_unused,
@@ -561,14 +566,14 @@ static int parse_node_list(const char *arg)
 	return 0;
 }
 
-static void parse_setup_node_list(void)
+static int parse_setup_node_list(void)
 {
 	struct thread_data *td;
 	char *str0, *str;
 	int t;
 
 	if (!g->p.node_list_str)
-		return;
+		return 0;
 
 	dprintf("g->p.nr_tasks: %d\n", g->p.nr_tasks);
 
@@ -619,8 +624,12 @@ static void parse_setup_node_list(void)
 
 		dprintf("NODEs: %d-%d #%d\n", bind_node_0, bind_node_1, step);
 
-		BUG_ON(bind_node_0 < 0 || bind_node_0 >= g->p.nr_nodes);
-		BUG_ON(bind_node_1 < 0 || bind_node_1 >= g->p.nr_nodes);
+		if (bind_node_0 >= g->p.nr_nodes || bind_node_1 >= g->p.nr_nodes) {
+			printf("\nTest not applicable, system has only %d nodes.\n", g->p.nr_nodes);
+			return -1;
+		}
+
+		BUG_ON(bind_node_0 < 0 || bind_node_1 < 0);
 		BUG_ON(bind_node_0 > bind_node_1);
 
 		for (bind_node = bind_node_0; bind_node <= bind_node_1; bind_node += step) {
@@ -651,6 +660,7 @@ out:
 		printf("# NOTE: %d tasks mem-bound, %d tasks unbound\n", t, g->p.nr_tasks - t);
 
 	free(str0);
+	return 0;
 }
 
 static int parse_nodes_opt(const struct option *opt __maybe_unused,
@@ -1356,8 +1366,8 @@ static int init(void)
 	init_thread_data();
 
 	tprintf("#\n");
-	parse_setup_cpu_list();
-	parse_setup_node_list();
+	if (parse_setup_cpu_list() || parse_setup_node_list())
+		return -1;
 	tprintf("#\n");
 
 	print_summary();
@@ -1600,7 +1610,6 @@ static int run_bench_numa(const char *name, const char **argv)
 	return 0;
 
 err:
-	usage_with_options(numa_usage, options);
 	return -1;
 }
 
@@ -1701,8 +1710,7 @@ static int bench_all(void)
 	BUG_ON(ret < 0);
 
 	for (i = 0; i < nr; i++) {
-		if (run_bench_numa(tests[i][0], tests[i] + 1))
-			return -1;
+		run_bench_numa(tests[i][0], tests[i] + 1);
 	}
 
 	printf("\n");
-- 
1.8.3.1

