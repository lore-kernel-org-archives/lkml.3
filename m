Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaANF2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:28:01 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46794 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaANF0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:07 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-b3-52d4ca6841ab
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 22/24] perf top: Add --children option
Date: Tue, 14 Jan 2014 14:25:55 +0900
Message-Id: <1389677157-30513-23-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --children option is for showing accumulated overhead (period)
value as well as self overhead.  It should be used with one of -g or
--call-graph option.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt | 6 ++++++
 tools/perf/builtin-top.c              | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index cdd8d4946dba..01b6fd1a4428 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -149,6 +149,12 @@ Default is to monitor all CPUS.
 	Setup and enable call-graph (stack chain/backtrace) recording,
 	implies -g.
 
+--children::
+	Accumulate callchain of children to parent entry so that then can
+	show up in the output.  The output will have a new "Children" column
+	and will be sorted on the data.  It requires -g/--call-graph option
+	enabled.
+
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
 	beyond the specified depth will be ignored. This is a trade-off
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9de14f71c196..439e000b0f39 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1087,6 +1087,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "call-graph", &top.record_opts,
 		     "mode[,dump_size]", record_callchain_help,
 		     &parse_callchain_opt),
+	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
+		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &top.max_stack,
 		    "Set the maximum stack depth when parsing the callchain. "
 		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
@@ -1186,6 +1188,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	top.sym_evsel = perf_evlist__first(top.evlist);
 
+	if (!symbol_conf.use_callchain) {
+		symbol_conf.cumulate_callchain = false;
+		perf_hpp__cancel_cumulate();
+	}
+
 	symbol_conf.priv_size = sizeof(struct annotation);
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
-- 
1.7.11.7

