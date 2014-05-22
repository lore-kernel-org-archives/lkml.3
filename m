Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaEVMXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:23:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbaEVMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:23:11 -0400
Date: Thu, 22 May 2014 05:23:01 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-6fe8c26d7ab9fbd6748fc40ca5fea1e3131e7236@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-15-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-15-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top:
  Add --fields option to specify output fields
Git-Commit-ID: 6fe8c26d7ab9fbd6748fc40ca5fea1e3131e7236
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6fe8c26d7ab9fbd6748fc40ca5fea1e3131e7236
Gitweb:     http://git.kernel.org/tip/6fe8c26d7ab9fbd6748fc40ca5fea1e3131e7236
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 4 Mar 2014 11:01:41 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:36 +0200

perf top: Add --fields option to specify output fields

The --fields option is to allow user setup output field in any order.
It can receive any sort keys and following (hpp) fields:

  overhead, overhead_sys, overhead_us, sample and period

If guest profiling is enabled, overhead_guest_{sys,us} will be
available too.

More more information, please see previous patch "perf report:
Add -F option to specify output fields"

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-15-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-top.txt |  9 +++++++++
 tools/perf/builtin-top.c              | 15 +++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index df86328..dcfa54c 100644
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
index 280945b..5b389ce 100644
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
