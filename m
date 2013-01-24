Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3AXPL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:11:27 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41466 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3AXPLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:11:22 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v7 05/18] perf, tools: Add support for weight v7 (modified)
Date: Thu, 24 Jan 2013 16:10:29 +0100
Message-Id: <1359040242-8269-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359040242-8269-1-git-send-email-eranian@google.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf record has a new option -W that enables weightened sampling.

Add sorting support in top/report for the average weight per sample and the
total weight sum. This allows to both compare relative cost per event
and the total cost over the measurement period.

Add the necessary glue to perf report, record and the library.

v2: Merge with new hist refactoring.
v3: Fix manpage. Remove value check.
Rename global_weight to weight and weight to local_weight.
v4: Readd sort keys to manpage
v5: Move weight to end
v6: Move weight to template
v7: Rename weight key.

Original patch from Andi modified by Stephane Eranian <eranian@google.com>
to include ONLY the weight supporting code and apply to pristine 3.8.0-rc4.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    6 ++++
 tools/perf/Documentation/perf-report.txt |    2 +-
 tools/perf/Documentation/perf-top.txt    |    2 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-diff.c                |    7 +++--
 tools/perf/builtin-record.c              |    2 ++
 tools/perf/builtin-report.c              |    7 +++--
 tools/perf/builtin-top.c                 |    5 +--
 tools/perf/perf.h                        |    1 +
 tools/perf/util/event.h                  |    1 +
 tools/perf/util/evsel.c                  |   10 ++++++
 tools/perf/util/hist.c                   |   23 +++++++++-----
 tools/perf/util/hist.h                   |    8 +++--
 tools/perf/util/session.c                |    3 ++
 tools/perf/util/sort.c                   |   49 ++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |    3 ++
 16 files changed, 111 insertions(+), 20 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 938e890..d4da111 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -182,6 +182,12 @@ is enabled for all the sampling events. The sampled branch type is the same for
 The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
 Note that this feature may not be available on all processors.
 
+-W::
+--weight::
+Enable weightened sampling. An additional weight is recorded per sample and can be
+displayed with the weight and local_weight sort keys.  This currently works for TSX
+abort events and some memory events in precise mode on modern Intel CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index f4d91be..88ebd50 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -57,7 +57,7 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight, local_weight.
 
 -p::
 --parent=<regex>::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 5b80d84..48a4089 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -112,7 +112,7 @@ Default is to monitor all CPUS.
 
 -s::
 --sort::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight, local_weight.
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index dc870cf..1bacb7d 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -62,7 +62,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 93b852f..03a322f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -248,9 +248,10 @@ int perf_diff__formula(char *buf, size_t size, struct hist_entry *he)
 }
 
 static int hists__add_entry(struct hists *self,
-			    struct addr_location *al, u64 period)
+			    struct addr_location *al, u64 period,
+			    u64 weight)
 {
-	if (__hists__add_entry(self, al, NULL, period) != NULL)
+	if (__hists__add_entry(self, al, NULL, period, weight) != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -272,7 +273,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f3151d3..8cdadd2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1059,6 +1059,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
+		    "sample by weight (on special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fc25100..3cfe259 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -88,7 +88,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
 		he = __hists__add_branch_entry(&evsel->hists, al, parent,
-				&bi[i], 1);
+				&bi[i], 1, 1);
 		if (he) {
 			struct annotation *notes;
 			err = -ENOMEM;
@@ -146,7 +146,8 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
+					sample->weight);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -596,7 +597,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
-		   " dso_from, symbol_to, symbol_from, mispredict"),
+		   " dso_from, symbol_to, symbol_from, mispredict, weight, local_weight"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff395..df00fe2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -271,7 +271,8 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
+				sample->weight);
 	if (he == NULL)
 		return NULL;
 
@@ -1230,7 +1231,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2c340e7..827a9ea 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -236,6 +236,7 @@ struct perf_record_opts {
 	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
+	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0d573ff..a97fbbe 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -88,6 +88,7 @@ struct perf_sample {
 	u64 id;
 	u64 stream_id;
 	u64 period;
+	u64 weight;
 	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1b16dd1..805d33e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -510,6 +510,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->branch_sample_type = opts->branch_stack;
 	}
 
+	if (opts->sample_weight)
+		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+
 	attr->mmap = track;
 	attr->comm = track;
 
@@ -908,6 +911,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 	data->period = 1;
+	data->weight = 0;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!evsel->attr.sample_id_all)
@@ -1058,6 +1062,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		}
 	}
 
+	data->weight = 0;
+	if (type & PERF_SAMPLE_WEIGHT) {
+		data->weight = *array;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cb17e2a..a8d7647 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -151,9 +151,11 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 	}
 }
 
-static void he_stat__add_period(struct he_stat *he_stat, u64 period)
+static void he_stat__add_period(struct he_stat *he_stat, u64 period,
+				u64 weight)
 {
 	he_stat->period		+= period;
+	he_stat->weight		+= weight;
 	he_stat->nr_events	+= 1;
 }
 
@@ -165,12 +167,14 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->period_guest_sys	+= src->period_guest_sys;
 	dest->period_guest_us	+= src->period_guest_us;
 	dest->nr_events		+= src->nr_events;
+	dest->weight		+= src->weight;
 }
 
 static void hist_entry__decay(struct hist_entry *he)
 {
 	he->stat.period = (he->stat.period * 7) / 8;
 	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
+	/* XXX need decay for weight too? */
 }
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
@@ -270,7 +274,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 static struct hist_entry *add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      u64 period)
+				      u64 period,
+				      u64 weight)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -288,7 +293,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period);
+			he_stat__add_period(&he->stat, period, weight);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -327,7 +332,8 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period)
+					     u64 period,
+					     u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -341,6 +347,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.stat = {
 			.period	= period,
 			.nr_events = 1,
+			.weight = weight,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
@@ -348,12 +355,13 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.hists	= self,
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, weight);
 }
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 period)
+				      struct symbol *sym_parent, u64 period,
+				      u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -367,13 +375,14 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.stat = {
 			.period	= period,
 			.nr_events = 1,
+			.weight = weight,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= self,
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, weight);
 }
 
 int64_t
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8b091a5..c769984a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -49,6 +49,8 @@ enum hist_column {
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
 	HISTC_SRCLINE,
+	HISTC_LOCAL_WEIGHT,
+	HISTC_GLOBAL_WEIGHT,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -73,7 +75,8 @@ struct hists {
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *parent, u64 period);
+				      struct symbol *parent, u64 period,
+				      u64 weight);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__sort_snprintf(struct hist_entry *self, char *bf, size_t size,
@@ -84,7 +87,8 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period);
+					     u64 period,
+					     u64 weight);
 
 void hists__output_resort(struct hists *self);
 void hists__output_resort_threaded(struct hists *hists);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ce6f511..3de9097 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1006,6 +1006,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		printf("... weight: %" PRIu64 "\n", sample->weight);
 }
 
 static struct machine *
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cfd1c0f..633b3e8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -476,6 +476,49 @@ struct sort_entry sort_mispredict = {
 	.se_width_idx	= HISTC_MISPREDICT,
 };
 
+static u64 he_weight(struct hist_entry *he)
+{
+	return he->stat.nr_events ? he->stat.weight / he->stat.nr_events : 0;
+}
+
+static int64_t
+sort__local_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return he_weight(left) - he_weight(right);
+}
+
+static int hist_entry__local_weight_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, he_weight(self));
+}
+
+struct sort_entry sort_local_weight = {
+	.se_header	= "Local Weight",
+	.se_cmp		= sort__local_weight_cmp,
+	.se_snprintf	= hist_entry__local_weight_snprintf,
+	.se_width_idx	= HISTC_LOCAL_WEIGHT,
+};
+
+static int64_t
+sort__global_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->stat.weight - right->stat.weight;
+}
+
+static int hist_entry__global_weight_snprintf(struct hist_entry *self, char *bf,
+					      size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, self->stat.weight);
+}
+
+struct sort_entry sort_global_weight = {
+	.se_header	= "Weight",
+	.se_cmp		= sort__global_weight_cmp,
+	.se_snprintf	= hist_entry__global_weight_snprintf,
+	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -497,6 +540,8 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 };
 
 int sort_dimension__add(const char *tok)
@@ -553,6 +598,10 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_DSO_TO;
 			else if (!strcmp(sd->name, "mispredict"))
 				sort__first_dimension = SORT_MISPREDICT;
+			else if (!strcmp(sd->name, "weight"))
+				sort__first_dimension = SORT_GLOBAL_WEIGHT;
+			else if (!strcmp(sd->name, "local_weight"))
+				sort__first_dimension = SORT_LOCAL_WEIGHT;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b4e8c3b..9af5446 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,6 +49,7 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
+	u64			weight;
 	u32			nr_events;
 };
 
@@ -137,6 +138,8 @@ enum sort_type {
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
 	SORT_SRCLINE,
+	SORT_LOCAL_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
 };
 
 /*
-- 
1.7.9.5

