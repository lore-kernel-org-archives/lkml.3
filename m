Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3JZO0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 10:26:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3JZO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 10:26:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/4] perf tools: Split -G and --call-graph for top command
Date: Sat, 26 Oct 2013 16:25:34 +0200
Message-Id: <1382797536-32303-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1382797536-32303-1-git-send-email-jolsa@redhat.com>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Splitting -G and --call-graph for record command, so we could
use '-G' with no option.

The '-G' option now takes NO argument and enables the configured
unwind method, which is currently the frame pointers method.

It will be possible to configure unwind method via config
file in upcoming patches.

All current '-G' arguments is overtaken by --call-graph option.

NOTE The documentation for top --call-graph option
     was wrongly copied from report command.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-top.txt | 18 +++++-------------
 tools/perf/builtin-top.c              | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index c16a09e..d311974 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -143,20 +143,12 @@ Default is to monitor all CPUS.
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
+	implies -g.
 
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 04f5bf2..488fec3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1015,16 +1015,16 @@ out_delete:
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
 
@@ -1110,9 +1110,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &parse_callchain_opt, "fp"),
+	OPT_CALLBACK(0, "call-graph", &top.record_opts,
+		     "mode[,dump_size]", record_callchain_help,
+		     &parse_callchain_opt),
+	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
+			     NULL, "enables call-graph recording",
+			     &callchain_opt),
 	OPT_INTEGER(0, "max-stack", &top.max_stack,
 		    "Set the maximum stack depth when parsing the callchain. "
 		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
-- 
1.7.11.7

