Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3J1TRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:17:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3J1TRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:17:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf top: Split -G and --call-graph
Date: Mon, 28 Oct 2013 16:16:40 -0300
Message-Id: <1382987801-21896-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382987801-21896-1-git-send-email-acme@infradead.org>
References: <1382987801-21896-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Splitting -G and --call-graph for record command, so we could use '-G'
with no option.

The '-G' option now takes NO argument and enables the configured unwind
method, which is currently the frame pointers method.

It will be possible to configure unwind method via config file in
upcoming patches.

All current '-G' arguments is overtaken by --call-graph option.

NOTE: The documentation for top --call-graph option
      was wrongly copied from report command.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: David Ahern <dsahern@gmail.com>
Tested-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1382797536-32303-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt | 18 +++++-------------
 tools/perf/builtin-top.c              | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 58d6598a9686..6a118e71d003 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -140,20 +140,12 @@ Default is to monitor all CPUS.
 --asm-raw::
 	Show raw instruction encoding of assembly instructions.
 
--G [type,min,order]::
+-G::
+	Enables call-graph (stack chain/backtrace) recording.
+
 --call-graph::
-        Display call chains using type, min percent threshold and order.
-	type can be either:
-	- flat: single column, linear exposure of call chains.
-	- graph: use a graph tree, displaying absolute overhead rates.
-	- fractal: like graph, but displays relative rates. Each branch of
-		 the tree is considered as a new profiled object.
-
-	order can be either:
-	- callee: callee based call graph.
-	- caller: inverted caller based call graph.
-
-	Default: fractal,0.5,callee.
+	Setup and enable call-graph (stack chain/backtrace) recording,
+	implies -G.
 
 --ignore-callees=<regex>::
         Ignore callees of the function(s) matching the given regex.
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 212214162bb2..0df298a0e946 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1016,16 +1016,16 @@ out_delete:
 }
 
 static int
-parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	/*
-	 * --no-call-graph
-	 */
-	if (unset)
-		return 0;
-
 	symbol_conf.use_callchain = true;
+	return record_callchain_opt(opt, arg, unset);
+}
 
+static int
+parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+{
+	symbol_conf.use_callchain = true;
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
@@ -1106,9 +1106,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &parse_callchain_opt, "fp"),
+	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
+			   NULL, "enables call-graph recording",
+			   &callchain_opt),
+	OPT_CALLBACK(0, "call-graph", &top.record_opts,
+		     "mode[,dump_size]", record_callchain_help,
+		     &parse_callchain_opt),
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
 		   "ignore callees of these functions in call graphs",
 		   report_parse_ignore_callees_opt),
-- 
1.8.1.4

