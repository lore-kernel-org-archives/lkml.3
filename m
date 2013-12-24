Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3LXIYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:24:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44569 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3LXIWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:22:37 -0500
X-AuditID: 9c930179-b7c89ae000006438-1f-52b9444a148f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 19/21] perf top: Add --children option
Date: Tue, 24 Dec 2013 17:22:25 +0900
Message-Id: <1387873347-28838-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
index 6a7a76496c94..10395cbfef19 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1179,6 +1179,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "call-graph", &top.record_opts,
 		     "mode[,dump_size]", record_callchain_help,
 		     &parse_callchain_opt),
+	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
+		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &top.max_stack,
 		    "Set the maximum stack depth when parsing the callchain. "
 		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
@@ -1278,6 +1280,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
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

