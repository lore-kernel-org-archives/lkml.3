Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaCTFho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:37:44 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61615 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaCTFgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:36:55 -0400
X-AuditID: 9c93017e-b7b10ae000000e66-21-532a7e730c16
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 19/21] perf top: Add --children option
Date: Thu, 20 Mar 2014 14:36:44 +0900
Message-Id: <1395293806-25847-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --children option is for showing accumulated overhead (period)
value as well as self overhead.  It should be used with one of -g or
--call-graph option.

Tested-by: Arun Sharma <asharma@fb.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt | 8 +++++++-
 tools/perf/builtin-top.c              | 7 +++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 50fcf97a7dc9..fd2db1a83de2 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -119,7 +119,7 @@ Default is to monitor all CPUS.
 --fields=::
 	Specify output field - multiple keys can be specified in CSV format.
 	Following fields are available:
-	overhead, overhead_sys, overhead_us, sample and period.
+	overhead, overhead_sys, overhead_us, overhead_children, sample and period.
 	Also it can contain any sort key(s).
 
 	By default, every sort keys not specified in --field will be appended
@@ -161,6 +161,12 @@ Default is to monitor all CPUS.
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
index b08939c7f15b..2a8dc3e0a913 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1103,6 +1103,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "call-graph", &top.record_opts,
 		     "mode[,dump_size]", record_callchain_help,
 		     &parse_callchain_opt),
+	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
+		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &top.max_stack,
 		    "Set the maximum stack depth when parsing the callchain. "
 		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
@@ -1205,6 +1207,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
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

