Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaESG0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:26:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59627 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaESG0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:26:09 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@rehdat.com>
Subject: [PATCH 14/20] perf top: Add --fields option to specify output fields
Date: Mon, 19 May 2014 15:25:56 +0900
Message-Id: <1400480762-22852-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --fields option is to allow user setup output field in any order.
It can recieve any sort keys and following (hpp) fields:

  overhead, overhead_sys, overhead_us, sample and period

If guest profiling is enabled, overhead_guest_{sys,us} will be
available too.

More more information, please see previous patch "perf report:
Add -F option to specify output fields"

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt |  9 +++++++++
 tools/perf/builtin-top.c              | 15 +++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index df863288752a..dcfa54c851e9 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -116,6 +116,15 @@ Default is to monitor all CPUS.
 	local_weight, abort, in_tx, transaction, overhead, sample, period.
 	Please see description of --sort in the perf-report man page.
 
+--fields=::
+	Specify output field - multiple keys can be specified in CSV format.
+	Following fields are available:
+	overhead, overhead_sys, overhead_us, sample and period.
+	Also it can contain any sort key(s).
+
+	By default, every sort keys not specified in --field will be appended
+	automatically.
+
 -n::
 --show-nr-samples::
 	Show a column with the number of samples.
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 280945bab66d..5b389ce4cd15 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1085,6 +1085,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
 		   " Please refer the man page for the complete list."),
+	OPT_STRING(0, "fields", &field_order, "key[,keys...]",
+		   "output field(s): overhead, period, sample plus all of sort keys"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
@@ -1138,17 +1140,18 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(top_usage, options);
 
 	sort__mode = SORT_MODE__TOP;
+	/* display thread wants entries to be collapsed in a different tree */
+	sort__need_collapse = 1;
 
 	if (setup_sorting() < 0) {
-		parse_options_usage(top_usage, options, "s", 1);
+		if (sort_order)
+			parse_options_usage(top_usage, options, "s", 1);
+		if (field_order)
+			parse_options_usage(sort_order ? NULL : top_usage,
+					    options, "fields", 0);
 		goto out_delete_evlist;
 	}
 
-	/* display thread wants entries to be collapsed in a different tree */
-	sort__need_collapse = 1;
-
-	perf_hpp__init();
-
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
-- 
1.9.2

