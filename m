Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaLVPac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:30:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:53917 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbaLVPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:30:29 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Joe Mario <jmario@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/10] perf mem: Move the mem_operations global to struct perf_mem
Date: Mon, 22 Dec 2014 12:30:01 -0300
Message-Id: <1419262209-9464-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419262209-9464-1-git-send-email-acme@kernel.org>
References: <1419262209-9464-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like the other parameters, grouping it on the builtin-mem specific
config area: struct perf_mem.

Acked-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Fowles <rfowles@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ad8ns5l51ongemfsir3zy09x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-mem.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 1eded0a3a509..9b5663950a4d 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -10,21 +10,17 @@
 #define MEM_OPERATION_LOAD	0x1
 #define MEM_OPERATION_STORE	0x2
 
-/*
- * default to both load an store sampling
- */
-static int mem_operation = MEM_OPERATION_LOAD | MEM_OPERATION_STORE;
-
 struct perf_mem {
 	struct perf_tool	tool;
 	char const		*input_name;
 	bool			hide_unresolved;
 	bool			dump_raw;
+	int			operation;
 	const char		*cpu_list;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(int argc, const char **argv, struct perf_mem *mem)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -37,17 +33,17 @@ static int __cmd_record(int argc, const char **argv)
 
 	rec_argv[i++] = "record";
 
-	if (mem_operation & MEM_OPERATION_LOAD)
+	if (mem->operation & MEM_OPERATION_LOAD)
 		rec_argv[i++] = "-W";
 
 	rec_argv[i++] = "-d";
 
-	if (mem_operation & MEM_OPERATION_LOAD) {
+	if (mem->operation & MEM_OPERATION_LOAD) {
 		rec_argv[i++] = "-e";
 		rec_argv[i++] = "cpu/mem-loads/pp";
 	}
 
-	if (mem_operation & MEM_OPERATION_STORE) {
+	if (mem->operation & MEM_OPERATION_STORE) {
 		rec_argv[i++] = "-e";
 		rec_argv[i++] = "cpu/mem-stores/pp";
 	}
@@ -177,7 +173,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 	 * there is no weight (cost) associated with stores, so don't print
 	 * the column
 	 */
-	if (!(mem_operation & MEM_OPERATION_LOAD))
+	if (!(mem->operation & MEM_OPERATION_LOAD))
 		rep_argv[i++] = "--sort=mem,sym,dso,symbol_daddr,"
 				"dso_daddr,tlb,locked";
 
@@ -273,9 +269,13 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 			.ordered_events	= true,
 		},
 		.input_name		 = "perf.data",
+		/*
+		 * default to both load an store sampling
+		 */
+		.operation		 = MEM_OPERATION_LOAD | MEM_OPERATION_STORE,
 	};
 	const struct option mem_options[] = {
-	OPT_CALLBACK('t', "type", &mem_operation,
+	OPT_CALLBACK('t', "type", &mem.operation,
 		   "type", "memory operations(load,store) Default load,store",
 		    parse_mem_ops),
 	OPT_BOOLEAN('D', "dump-raw-samples", &mem.dump_raw,
@@ -302,7 +302,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 	argc = parse_options_subcommand(argc, argv, mem_options, mem_subcommands,
 					mem_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 
-	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
+	if (!argc || !(strncmp(argv[0], "rec", 3) || mem.operation))
 		usage_with_options(mem_usage, mem_options);
 
 	if (!mem.input_name || !strlen(mem.input_name)) {
@@ -313,7 +313,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
+		return __cmd_record(argc, argv, &mem);
 	else if (!strncmp(argv[0], "rep", 3))
 		return report_events(argc, argv, &mem);
 	else
-- 
1.9.3

