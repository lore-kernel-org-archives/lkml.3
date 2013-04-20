Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab3DTTUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:20:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:3592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab3DTTT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="321467967"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/15] perf, tools: Add support for record transaction flags v3
Date: Sat, 20 Apr 2013 12:19:20 -0700
Message-Id: <1366485563-16209-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add the glue in the user tools to record transaction flags with
--transaction (-T was already taken) and dump them.

Followon patches will use them.

v2: Fix manpage
v3: Move transaction to the end
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    4 +-
 tools/perf/Documentation/perf-report.txt |    4 ++
 tools/perf/Documentation/perf-top.txt    |    2 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-diff.c                |    8 ++-
 tools/perf/builtin-record.c              |    2 +
 tools/perf/builtin-report.c              |    4 +-
 tools/perf/builtin-top.c                 |    4 +-
 tools/perf/perf.h                        |    1 +
 tools/perf/tests/hists_link.c            |    6 ++-
 tools/perf/util/event.h                  |    1 +
 tools/perf/util/evsel.c                  |    9 ++++
 tools/perf/util/hist.c                   |    7 ++-
 tools/perf/util/hist.h                   |    4 +-
 tools/perf/util/session.c                |    3 +
 tools/perf/util/sort.c                   |   74 ++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |    2 +
 17 files changed, 123 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 6f3405e..c73dd25 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -185,12 +185,14 @@ is enabled for all the sampling events. The sampled branch type is the same for
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
index 06d5d9b..e59d7af 100644
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
index 1f5192a..1d8278b 100644
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
index db491e9..6d0f8a4 100644
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
index 2d0462d..c6a0a86 100644
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
+	if (hists__add_entry(&evsel->hists, &al, sample->period,
+			     sample->weight, sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1c46dd0..870010d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -958,6 +958,8 @@ const struct option record_options[] = {
 		     parse_branch_stack),
 	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
 		    "sample by weight (on special events only)"),
+	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
+		    "sample transaction flags (special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9a85d66..9d7b17c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -251,7 +251,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	}
 
 	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
-					sample->weight);
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -752,7 +752,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
 		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
-		   "snoop, locked, abort, in_tx"),
+		   "snoop, locked, abort, in_tx, transaction"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c83b1fd..ee9df3d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -252,7 +252,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct hist_entry *he;
 
 	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
-				sample->weight);
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return NULL;
 
@@ -1090,7 +1090,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight,"
-		   " abort, in_tx"),
+		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 4fb573b..5bf680c 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -230,6 +230,7 @@ struct perf_record_opts {
 	u64	     default_interval;
 	u64	     user_interval;
 	u16	     stack_dump_size;
+	bool	     sample_transaction;
 };
 
 #endif
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 89085a9..c1d3ac3 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL,
+						1, 1, 0);
 			if (he == NULL)
 				goto out;
 
@@ -247,7 +248,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1,
+						0);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1813895..536a00a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -89,6 +89,7 @@ struct perf_sample {
 	u64 stream_id;
 	u64 period;
 	u64 weight;
+	u64 transaction;
 	u32 cpu;
 	u32 raw_size;
 	u64 data_src;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 07b1a3a..17f2d2a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -569,6 +569,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
+	if (opts->sample_transaction)
+		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
+
 	attr->mmap = track;
 	attr->comm = track;
 
@@ -1186,6 +1189,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
index 6b32721..9611f15 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -155,6 +155,10 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	hists__new_col_len(hists, HISTC_MEM_LVL, 21 + 3);
 	hists__new_col_len(hists, HISTC_LOCAL_WEIGHT, 12);
 	hists__new_col_len(hists, HISTC_GLOBAL_WEIGHT, 12);
+
+	if (h->transaction)
+		hists__new_col_len(hists, HISTC_TRANSACTION,
+				   hist_entry__transaction_len());
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
@@ -457,7 +461,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period,
-				      u64 weight)
+				      u64 weight, u64 transaction)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -478,6 +482,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.hists	= self,
 		.branch_info = NULL,
 		.mem_info = NULL,
+		.transaction = transaction,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 284a748..63bb98c 100644
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
index cf1fe01..9428c1f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -804,6 +804,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		printf(" . data_src: 0x%"PRIx64"\n", sample->data_src);
+
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		printf("... transaction: %" PRIx64 "\n", sample->transaction);
 }
 
 static struct machine *
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 480c2da..36f00a4 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -904,6 +904,79 @@ struct sort_entry sort_intx = {
 	.se_width_idx	= HISTC_INTX,
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
@@ -928,6 +1001,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
 	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
 	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
+	DIM(SORT_TRANSACTION, "transaction", sort_transaction),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e053d70..14a5564 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -83,6 +83,7 @@ struct hist_entry {
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
+	u64			transaction;
 	s32			cpu;
 
 	struct hist_entry_diff	diff;
@@ -140,6 +141,7 @@ enum sort_type {
 	SORT_MEM_TLB,
 	SORT_MEM_LVL,
 	SORT_MEM_SNOOP,
+	SORT_TRANSACTION,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
-- 
1.7.7.6

