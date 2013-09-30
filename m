Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3I3WAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:00:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:51854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab3I3V7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="385921930"
From: Andi Kleen <andi@firstfloor.org>
To: acma@infradead.org
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/6] perf, tools: Add support for record transaction flags v5
Date: Mon, 30 Sep 2013 14:59:02 -0700
Message-Id: <1380578343-31301-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for recording and displaying the transaction flags.
They are essentially a new sort key. Also display them
in a nice way to the user.

v2: Fix manpage
v3: Move transaction to the end
v4: Handle capacity-read/write
v5: Adjust for new names
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |  4 +-
 tools/perf/Documentation/perf-report.txt |  4 ++
 tools/perf/Documentation/perf-top.txt    |  2 +-
 tools/perf/builtin-annotate.c            |  2 +-
 tools/perf/builtin-diff.c                |  8 ++--
 tools/perf/builtin-record.c              |  2 +
 tools/perf/builtin-report.c              |  4 +-
 tools/perf/builtin-top.c                 |  5 +--
 tools/perf/perf.h                        |  1 +
 tools/perf/tests/hists_link.c            |  6 ++-
 tools/perf/util/event.h                  |  1 +
 tools/perf/util/evsel.c                  |  9 ++++
 tools/perf/util/hist.c                   |  7 ++-
 tools/perf/util/hist.h                   |  4 +-
 tools/perf/util/session.c                |  3 ++
 tools/perf/util/sort.c                   | 73 ++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |  2 +
 17 files changed, 122 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 6bec1c9..f732eaa 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -179,12 +179,14 @@ is enabled for all the sampling events. The sampled branch type is the same for
 The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
 Note that this feature may not be available on all processors.
 
--W::
 --weight::
 Enable weightened sampling. An additional weight is recorded per sample and can be
 displayed with the weight and local_weight sort keys.  This currently works for TSX
 abort events and some memory events in precise mode on modern Intel CPUs.
 
+--transaction::
+Record transaction flags for transaction related events.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index ae337e3..be5ad87 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -72,6 +72,10 @@ OPTIONS
 	- cpu: cpu number the task ran at the time of sample
 	- srcline: filename and line number executed at the time of sample.  The
 	DWARF debugging info must be provided.
+	- weight: Event specific weight, e.g. memory latency or transaction
+	abort cost. This is the global weight.
+	- local_weight: Local weight version of the weight above.
+	- transaction: Transaction abort flags.
 
 	By default, comm, dso and symbol keys are used.
 	(i.e. --sort comm,dso,symbol)
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index f852eb5..6d70fbf 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -113,7 +113,7 @@ Default is to monitor all CPUS.
 -s::
 --sort::
 	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight,
-	local_weight, abort, in_tx
+	local_weight, abort, in_tx, transaction
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5ebd0c3..0393d98 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -63,7 +63,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1, 0);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index f28799e..2a78dc8 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -304,9 +304,10 @@ static int formula_fprintf(struct hist_entry *he, struct hist_entry *pair,
 
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
@@ -328,7 +329,8 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period,
+			     sample->weight, sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8384b54..a78db3f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -894,6 +894,8 @@ const struct option record_options[] = {
 		     parse_branch_stack),
 	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
 		    "sample by weight (on special events only)"),
+	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
+		    "sample transaction flags (special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1e84103..8657a3d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -259,7 +259,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	}
 
 	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
-					sample->weight);
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -786,7 +786,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
 		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
-		   "snoop, locked, abort, in_tx"),
+		   "snoop, locked, abort, in_tx, transaction"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6534a37..b3e0229 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -247,9 +247,8 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 
 	pthread_mutex_lock(&evsel->hists.lock);
 	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
-				sample->weight);
+				sample->weight, sample->transaction);
 	pthread_mutex_unlock(&evsel->hists.lock);
-
 	if (he == NULL)
 		return NULL;
 
@@ -1104,7 +1103,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight,"
-		   " abort, in_tx"),
+		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index acf3d66..84502e8 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -233,6 +233,7 @@ struct perf_record_opts {
 	u64	     default_interval;
 	u64	     user_interval;
 	u16	     stack_dump_size;
+	bool	     sample_transaction;
 };
 
 #endif
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 4228ffc..025503a 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -222,7 +222,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL,
+						1, 1, 0);
 			if (he == NULL)
 				goto out;
 
@@ -244,7 +245,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1,
+						0);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index c67ecc4..17d9e16 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -111,6 +111,7 @@ struct perf_sample {
 	u64 stream_id;
 	u64 period;
 	u64 weight;
+	u64 transaction;
 	u32 cpu;
 	u32 raw_size;
 	u64 data_src;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0ce9feb..abe69af 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -681,6 +681,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
 
+	if (opts->sample_transaction)
+		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
+
 	/*
 	 * XXX see the function comment above
 	 *
@@ -1470,6 +1473,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->transaction = 0;
+	if (type & PERF_SAMPLE_TRANSACTION) {
+		data->transaction = *array;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 46a0d35..4714a72 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -160,6 +160,10 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	hists__new_col_len(hists, HISTC_MEM_LVL, 21 + 3);
 	hists__new_col_len(hists, HISTC_LOCAL_WEIGHT, 12);
 	hists__new_col_len(hists, HISTC_GLOBAL_WEIGHT, 12);
+
+	if (h->transaction)
+		hists__new_col_len(hists, HISTC_TRANSACTION,
+				   hist_entry__transaction_len());
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
@@ -466,7 +470,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period,
-				      u64 weight)
+				      u64 weight, u64 transaction)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -487,6 +491,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.hists	= self,
 		.branch_info = NULL,
 		.mem_info = NULL,
+		.transaction = transaction,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f743e96..6a048c0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -59,6 +59,7 @@ enum hist_column {
 	HISTC_MEM_TLB,
 	HISTC_MEM_LVL,
 	HISTC_MEM_SNOOP,
+	HISTC_TRANSACTION,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -84,9 +85,10 @@ struct hists {
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
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 51f5edf..ef5af04 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -855,6 +855,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		printf(" . data_src: 0x%"PRIx64"\n", sample->data_src);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		printf("... transaction: %" PRIx64 "\n", sample->transaction);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		sample_read__printf(sample, evsel->attr.read_format);
 }
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1771566..b4ecc0e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -907,6 +907,78 @@ struct sort_entry sort_in_tx = {
 	.se_width_idx	= HISTC_IN_TX,
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
+	{ PERF_TXN_ELISION,        "EL ",        0 },
+	{ PERF_TXN_TRANSACTION,    "TX ",        1 },
+	{ PERF_TXN_SYNC,           "SYNC ",      1 },
+	{ PERF_TXN_ASYNC,          "ASYNC ",     0 },
+	{ PERF_TXN_RETRY,          "RETRY ",     0 },
+	{ PERF_TXN_CONFLICT,       "CON ",       0 },
+	{ PERF_TXN_CAPACITY_WRITE, "CAP-WRITE ", 1 },
+	{ PERF_TXN_CAPACITY_READ,  "CAP-READ ",  0 },
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
+					    size_t size, unsigned int width)
+{
+	u64 t = self->transaction;
+	char buf[128];
+	char *p = buf;
+	int i;
+
+	buf[0] = 0;
+	for (i = 0; txbits[i].name; i++)
+		if (txbits[i].flag & t)
+			p = add_str(p, txbits[i].name);
+	if (t && !(t & (PERF_TXN_SYNC|PERF_TXN_ASYNC)))
+		p = add_str(p, "NEITHER ");
+	if (t & PERF_TXN_ABORT_MASK) {
+		sprintf(p, ":%" PRIx64,
+			(t & PERF_TXN_ABORT_MASK) >>
+			PERF_TXN_ABORT_SHIFT);
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
@@ -925,6 +997,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
 	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
 	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
+	DIM(SORT_TRANSACTION, "transaction", sort_transaction),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 9dad3a0..bf43336 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -85,6 +85,7 @@ struct hist_entry {
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
+	u64			transaction;
 	s32			cpu;
 
 	struct hist_entry_diff	diff;
@@ -145,6 +146,7 @@ enum sort_type {
 	SORT_SRCLINE,
 	SORT_LOCAL_WEIGHT,
 	SORT_GLOBAL_WEIGHT,
+	SORT_TRANSACTION,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
-- 
1.8.3.1

