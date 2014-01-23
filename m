Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaAWAOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:14:23 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65170 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbaAWAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:14:19 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-69-52e05ed127b9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 15/21] perf report: Add --children option
Date: Thu, 23 Jan 2014 09:13:59 +0900
Message-Id: <1390436045-16830-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --children option is for showing accumulated overhead (period)
value as well as self overhead.

Tested-by: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/builtin-report.c              | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 09af66298564..36eb1877563f 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -144,6 +144,11 @@ OPTIONS
 
 	Default: fractal,0.5,callee,function.
 
+--children::
+	Accumulate callchain of children to parent entry so that then can
+	show up in the output.  The output will have a new "Children" column
+	and will be sorted on the data.  It requires callchains are recorded.
+
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
 	beyond the specified depth will be ignored. This is a trade-off
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3ed0669d7620..56fe8c00b1be 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -183,6 +183,14 @@ static int report__setup_sample_type(struct report *rep)
 			}
 	}
 
+	if (symbol_conf.cumulate_callchain) {
+		/* Silently ignore if callchain is missing */
+		if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+			symbol_conf.cumulate_callchain = false;
+			perf_hpp__cancel_cumulate();
+		}
+	}
+
 	if (sort__mode == SORT_MODE__BRANCH) {
 		if (!is_pipe &&
 		    !(sample_type & PERF_SAMPLE_BRANCH_STACK)) {
@@ -661,6 +669,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
 		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
+	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
+		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
 		    "Set the maximum stack depth when parsing the callchain, "
 		    "anything beyond the specified depth will be ignored. "
-- 
1.7.11.7

