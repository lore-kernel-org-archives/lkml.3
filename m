Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3AQUh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:37:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:33901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab3AQUhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:37:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="273439808"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/29] perf, tools: Support sorting by intx, abort branch flags v2
Date: Thu, 17 Jan 2013 12:36:34 -0800
Message-Id: <1358455012-12287-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Extend the perf branch sorting code to support sorting by intx
or abort qualifiers. Also print out those qualifiers.

v2: Readd flags to man pages
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |    4 ++-
 tools/perf/Documentation/perf-top.txt    |    4 ++-
 tools/perf/builtin-report.c              |    3 +-
 tools/perf/builtin-top.c                 |    4 ++-
 tools/perf/perf.h                        |    4 ++-
 tools/perf/util/hist.h                   |    2 +
 tools/perf/util/sort.c                   |   55 ++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |    2 +
 8 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index f4d91be..cb4216d 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -57,7 +57,9 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline,
+        dso_from, dso_to, symbol_to, symbol_from, mispredict,
+        abort, intx
 
 -p::
 --parent=<regex>::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 5b80d84..1398b73 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -112,7 +112,9 @@ Default is to monitor all CPUS.
 
 -s::
 --sort::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline,
+        dso_from, dso_to, symbol_to, symbol_from, mispredict,
+        abort, intx
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fc25100..072c388 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -596,7 +596,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
-		   " dso_from, symbol_to, symbol_from, mispredict"),
+		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
+		   " abort, intx"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff395..6cfb678 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1230,7 +1230,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
+		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
+		   " abort, intx"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2c340e7..c6d315b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -197,7 +197,9 @@ struct ip_callchain {
 struct branch_flags {
 	u64 mispred:1;
 	u64 predicted:1;
-	u64 reserved:62;
+	u64 intx:1;
+	u64 abort:1;
+	u64 reserved:60;
 };
 
 struct branch_entry {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8b091a5..4ae7c25 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -44,6 +44,8 @@ enum hist_column {
 	HISTC_PARENT,
 	HISTC_CPU,
 	HISTC_MISPREDICT,
+	HISTC_INTX,
+	HISTC_ABORT,
 	HISTC_SYMBOL_FROM,
 	HISTC_SYMBOL_TO,
 	HISTC_DSO_FROM,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cfd1c0f..a8d1f1a 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -476,6 +476,55 @@ struct sort_entry sort_mispredict = {
 	.se_width_idx	= HISTC_MISPREDICT,
 };
 
+static int64_t
+sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->branch_info->flags.abort !=
+		right->branch_info->flags.abort;
+}
+
+static int hist_entry__abort_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	static const char *out = ".";
+
+	if (self->branch_info->flags.abort)
+		out = "A";
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+struct sort_entry sort_abort = {
+	.se_header	= "Transaction abort",
+	.se_cmp		= sort__abort_cmp,
+	.se_snprintf	= hist_entry__abort_snprintf,
+	.se_width_idx	= HISTC_ABORT,
+};
+
+static int64_t
+sort__intx_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->branch_info->flags.intx !=
+		right->branch_info->flags.intx;
+}
+
+static int hist_entry__intx_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	static const char *out = ".";
+
+	if (self->branch_info->flags.intx)
+		out = "T";
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+struct sort_entry sort_intx = {
+	.se_header	= "Branch in transaction",
+	.se_cmp		= sort__intx_cmp,
+	.se_snprintf	= hist_entry__intx_snprintf,
+	.se_width_idx	= HISTC_INTX,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -497,6 +546,8 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_ABORT, "abort", sort_abort),
+	DIM(SORT_INTX, "intx", sort_intx)
 };
 
 int sort_dimension__add(const char *tok)
@@ -553,6 +604,10 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_DSO_TO;
 			else if (!strcmp(sd->name, "mispredict"))
 				sort__first_dimension = SORT_MISPREDICT;
+			else if (!strcmp(sd->name, "intx"))
+				sort__first_dimension = SORT_INTX;
+			else if (!strcmp(sd->name, "abort"))
+				sort__first_dimension = SORT_ABORT;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b4e8c3b..f811a0a 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -137,6 +137,8 @@ enum sort_type {
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
 	SORT_SRCLINE,
+	SORT_ABORT,
+	SORT_INTX,
 };
 
 /*
-- 
1.7.7.6

