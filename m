Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3AYWeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:34:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:13316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab3AYWd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="252629026"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/18] perf, tools: Add browser support for transaction flags v6
Date: Fri, 25 Jan 2013 14:33:04 -0800
Message-Id: <1359153192-13409-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add histogram support for the transaction flags. Each flags instance becomes
a separate histogram. Support sorting and displaying the flags in report
and top.

The patch is fairly large, but it's really mostly just plumbing to pass the
flags around.

v2: Increase column. Fix flags decoding. Use longer strings for flags
to be more user friendly.
v3: Fix WERROR=1 build. Tidy display
v4: Readd sort keys to manpage
v5: Reimplement transaction flags display code
v6: Port to latest tree
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |    1 +
 tools/perf/Documentation/perf-top.txt    |    2 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-diff.c                |    8 ++-
 tools/perf/builtin-report.c              |    4 +-
 tools/perf/builtin-top.c                 |    4 +-
 tools/perf/tests/hists_link.c            |    4 +-
 tools/perf/util/hist.c                   |    7 +++-
 tools/perf/util/hist.h                   |    4 +-
 tools/perf/util/sort.c                   |   73 ++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |    2 +
 11 files changed, 98 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 5a8b3cc..1e5ba01 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -75,6 +75,7 @@ OPTIONS
 	- weight: Event specific weight, e.g. memory latency or transaction
 	abort cost. This is the global weight.
 	- local_weight: Local weight version of the weight above.
+	- transaction: Transaction abort flags.
 
 	By default, comm, dso and symbol keys are used.
 	(i.e. --sort comm,dso,symbol)
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index f7ded9d..8c6bf2a 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -114,7 +114,7 @@ Default is to monitor all CPUS.
 --sort::
 	Sort by key(s): pid, comm, dso, symbol, parent, srcline,
         dso_from, dso_to, symbol_to, symbol_from, mispredict,
-        abort, intx,  local_weight, weight
+        abort, intx,  local_weight, weight, transaction
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1bacb7d..cb8fa96 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -62,7 +62,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1, 0);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8f29306..ee54390 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -232,9 +232,10 @@ int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
 
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period,
-			    u64 weight)
+			    u64 weight, u64 transaction)
 {
-	if (__hists__add_entry(self, al, NULL, period, weight) != NULL)
+	if (__hists__add_entry(self, al, NULL, period, weight, transaction)
+	    != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -256,7 +257,8 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight,
+			     sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 13c980e..7b46793 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -147,7 +147,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	}
 
 	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
-					sample->weight);
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -598,7 +598,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict, "
-		   " abort, intx, weight, local_weight"),
+		   " abort, intx, weight, local_weight, transaction"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1c165cf..faa1fa8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -250,7 +250,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct hist_entry *he;
 
 	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
-				sample->weight);
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return NULL;
 
@@ -1081,7 +1081,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
 		   " dso_from, symbol_to, symbol_from, mispredict, srcline,"
-		   " abort, intx, weight, local_weight"),
+		   " abort, intx, weight, local_weight, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index d65abaa..8929de1 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 0);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 0, 0);
 			if (he == NULL)
 				goto out;
 
@@ -247,7 +247,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 0);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 0, 0);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d3e0fcf..2d2e7d4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -115,6 +115,10 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			hists__set_unres_dso_col_len(hists, HISTC_DSO_TO);
 		}
 	}
+
+	if (h->transaction)
+		hists__new_col_len(hists, HISTC_TRANSACTION, 
+				   hist_entry__transaction_len());
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
@@ -378,7 +382,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period,
-				      u64 weight)
+				      u64 weight, u64 transaction)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -397,6 +401,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= self,
+		.transaction = transaction,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 42b075f..f8fafae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -53,6 +53,7 @@ enum hist_column {
 	HISTC_SRCLINE,
 	HISTC_LOCAL_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
+	HISTC_TRANSACTION,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -78,9 +79,10 @@ struct hists {
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period,
-				      u64 weight);
+				      u64 weight, u64 transaction);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
+int hist_entry__transaction_len(void);
 int hist_entry__sort_snprintf(struct hist_entry *self, char *bf, size_t size,
 			      struct hists *hists);
 void hist_entry__free(struct hist_entry *);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5e9c842..fe3b56c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -564,6 +564,78 @@ struct sort_entry sort_global_weight = {
 	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
 };
 
+static int64_t
+sort__transaction_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->transaction - right->transaction;
+}
+
+static inline char *add_str(char *p, const char *str)
+{
+	strcpy(p, str);
+	return p + strlen(str);
+}
+
+static struct txbit {
+	unsigned flag;
+	const char *name;
+	int skip_for_len;
+} txbits[] = {
+	{ PERF_SAMPLE_TXN_ELISION,     "EL ", 0 },
+	{ PERF_SAMPLE_TXN_TRANSACTION, "TX ", 1 },
+	{ PERF_SAMPLE_TXN_SYNC,        "SYNC ", 1 },
+	{ PERF_SAMPLE_TXN_ASYNC,       "ASYNC ", 0 },
+	{ PERF_SAMPLE_TXN_RETRY,       "RETRY ", 0 },
+	{ PERF_SAMPLE_TXN_CONFLICT,    "CON ", 0 },
+	{ PERF_SAMPLE_TXN_CAPACITY,    "CAP ", 1 },
+	{ PERF_SAMPLE_TXN_MEMORY,      "MEM ", 0 },
+	{ PERF_SAMPLE_TXN_MISC,        "MISC ", 0 },
+	{ 0, NULL, 0 }
+};
+
+int hist_entry__transaction_len(void)
+{
+	int i;
+	int len = 0;
+
+	for (i = 0; txbits[i].name; i++) {
+		if (!txbits[i].skip_for_len)
+			len += strlen(txbits[i].name);
+	}
+	len += 4; /* :XX<space> */
+	return len;
+}
+
+static int hist_entry__transaction_snprintf(struct hist_entry *self, char *bf,
+	 			    	    size_t size, unsigned int width)
+{
+	u64 t = self->transaction;
+	char buf[128];
+	char *p = buf;
+	int i;
+
+	for (i = 0; txbits[i].name; i++)
+		if (txbits[i].flag & t)
+			p = add_str(p, txbits[i].name);
+	if (t && !(t & (PERF_SAMPLE_TXN_SYNC|PERF_SAMPLE_TXN_ASYNC)))
+		p = add_str(p, "NEITHER ");
+	if (t & PERF_SAMPLE_TXN_ABORT_MASK) {
+		sprintf(p, ":%" PRIx64,
+			(t & PERF_SAMPLE_TXN_ABORT_MASK) >>
+			PERF_SAMPLE_TXN_ABORT_SHIFT);
+		p += strlen(p);
+	}
+
+	return repsep_snprintf(bf, size, "%-*s", width, buf);
+}
+
+struct sort_entry sort_transaction = {
+	.se_header	= "Transaction                ",
+	.se_cmp		= sort__transaction_cmp,
+	.se_snprintf	= hist_entry__transaction_snprintf,
+	.se_width_idx	= HISTC_TRANSACTION,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -582,6 +654,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
 	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
 	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
+	DIM(SORT_TRANSACTION, "transaction", sort_transaction),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 6ba3020..7b7dfde 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -83,6 +83,7 @@ struct hist_entry {
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
+	u64			transaction;
 	s32			cpu;
 
 	struct hist_entry_diff	diff;
@@ -133,6 +134,7 @@ enum sort_type {
 	SORT_SRCLINE,
 	SORT_LOCAL_WEIGHT,
 	SORT_GLOBAL_WEIGHT,
+	SORT_TRANSACTION,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
-- 
1.7.7.6

