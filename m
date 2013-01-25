Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3AYWBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:01:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:28320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3AYWBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:01:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="252613519"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/12] perf, tools: Support sorting by intx, abort branch flags v2
Date: Fri, 25 Jan 2013 14:00:44 -0800
Message-Id: <1359151245-13179-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Extend the perf branch sorting code to support sorting by intx
or abort qualifiers. Also print out those qualifiers.

This also fixes up some of the existing sort key documentation.

We do not support notx here, because it's simply not showing
the intx flag.

v2: Readd flags to man pages
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |    4 ++-
 tools/perf/Documentation/perf-top.txt    |    4 ++-
 tools/perf/builtin-report.c              |    2 +-
 tools/perf/builtin-top.c                 |    4 ++-
 tools/perf/perf.h                        |    4 ++-
 tools/perf/util/hist.h                   |    2 +
 tools/perf/util/sort.c                   |   51 ++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |    2 +
 8 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 848a0dc..eaf23ab 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -71,7 +71,7 @@ OPTIONS
 	entries are displayed as "[other]".
 	- cpu: cpu number the task ran at the time of sample
 	- srcline: filename and line number executed at the time of sample.  The
-	DWARF debuggin info must be provided.
+	DWARF debugging info must be provided.
 
 	By default, comm, dso and symbol keys are used.
 	(i.e. --sort comm,dso,symbol)
@@ -85,6 +85,8 @@ OPTIONS
 	- symbol_from: name of function branched from
 	- symbol_to: name of function branched to
 	- mispredict: "N" for predicted branch, "Y" for mispredicted branch
+	- intx: branch in TSX transaction
+	- abort: TSX transaction abort.
 
 	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
 	and symbol_to, see '--branch-stack'.
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index a414bc9..93970b7 100644
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
index 47a8644..d51a66d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -596,7 +596,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
-		   " dso_to, dso_from, symbol_to, symbol_from, mispredict"),
+		   " dso_to, dso_from, symbol_to, symbol_from, mispredict, abort, intx"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7978c81..9e08cec 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1078,7 +1078,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
+		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
+		   " abort, intx"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 8f3bf38..eb049df 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -193,7 +193,9 @@ struct ip_callchain {
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
index 3862468..36a8565 100644
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
index 7ad6239..b7a4100 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -472,6 +472,55 @@ struct sort_entry sort_mispredict = {
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
@@ -500,6 +549,8 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 	DIM(SORT_SYM_FROM, "symbol_from", sort_sym_from),
 	DIM(SORT_SYM_TO, "symbol_to", sort_sym_to),
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
+	DIM(SORT_ABORT, "abort", sort_abort),
+	DIM(SORT_INTX, "intx", sort_intx),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e994ad3e..6755d28 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -138,6 +138,8 @@ enum sort_type {
 	SORT_SYM_FROM,
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
+	SORT_ABORT,
+	SORT_INTX,
 };
 
 /*
-- 
1.7.7.6

