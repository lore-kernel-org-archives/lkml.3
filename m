Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaDPDGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:06:21 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60120 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaDPDF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 14/17] perf top: Add --fields option to specify output fields
Date: Wed, 16 Apr 2014 12:05:51 +0900
Message-Id: <1397617554-26319-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/Documentation/perf-top.txt | 9 +++++++++
 tools/perf/builtin-top.c              | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 64ed79c43639..feac28017419 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -115,6 +115,15 @@ Default is to monitor all CPUS.
 	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight,
 	local_weight, abort, in_tx, transaction
 
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
index 9309629394dd..7d133dff5e15 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1085,6 +1085,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight,"
 		   " abort, in_tx, transaction"),
+	OPT_STRING(0, "fields", &field_order, "key[,keys...]",
+		   "output field(s): overhead, period, sample plus all of sort keys"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
@@ -1149,6 +1151,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	perf_hpp__init();
 
+	if (setup_output_field() < 0) {
+		parse_options_usage(top_usage, options, "fields", 0);
+		goto out_delete_evlist;
+	}
+
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
-- 
1.9.2

