Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3C1RGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:06:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36350 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab3C1RCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/36] perf tools: Add support for weight v7 (modified)
Date: Thu, 28 Mar 2013 14:02:24 -0300
Message-Id: <1364490156-32064-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359040242-8269-6-git-send-email-eranian@google.com
[ committer note: changed to cope with fc5871ed and the hists_link perf test entry ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    6 ++++
 tools/perf/Documentation/perf-report.txt |    2 +-
 tools/perf/Documentation/perf-top.txt    |    2 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-diff.c                |    7 ++--
 tools/perf/builtin-record.c              |    2 +
 tools/perf/builtin-report.c              |    8 +++--
 tools/perf/builtin-top.c                 |    5 ++-
 tools/perf/perf.h                        |    1 +
 tools/perf/tests/hists_link.c            |    4 +-
 tools/perf/util/event.h                  |    1 +
 tools/perf/util/evsel.c                  |   10 ++++++
 tools/perf/util/hist.c                   |   23 ++++++++++----
 tools/perf/util/hist.h                   |    8 ++++-
 tools/perf/util/session.c                |    3 ++
 tools/perf/util/sort.c                   |   45 ++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |    3 ++
 17 files changed, 110 insertions(+), 22 deletions(-)

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
index 71f1551..7d5f4f3 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -59,7 +59,7 @@ OPTIONS
 --sort=::
 	Sort histogram entries by given key(s) - multiple keys can be specified
 	in CSV format.  Following sort keys are available:
-	pid, comm, dso, symbol, parent, cpu, srcline.
+	pid, comm, dso, symbol, parent, cpu, srcline, weight, local_weight.
 
 	Each key has following meaning:
 
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index a414bc9..9f1a2fe 100644
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
index ae36f3c..db491e9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -63,7 +63,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d207a97..2d0462d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -231,9 +231,10 @@ int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
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
@@ -255,7 +256,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 78a41fd..cdf58ec 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -953,6 +953,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
+		    "sample by weight (on special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b5ea26c..e31f070 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -98,7 +98,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
 		he = __hists__add_branch_entry(&evsel->hists, al, parent,
-				&bi[i], 1);
+				&bi[i], 1, 1);
 		if (he) {
 			struct annotation *notes;
 			err = -ENOMEM;
@@ -156,7 +156,8 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
+					sample->weight);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -644,7 +645,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
-		   " dso_to, dso_from, symbol_to, symbol_from, mispredict"),
+		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
+		   " weight, local_weight"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b5520ad..67bdb9f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -251,7 +251,8 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
+				sample->weight);
 	if (he == NULL)
 		return NULL;
 
@@ -1088,7 +1089,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 74659ec..32bd102 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -218,6 +218,7 @@ struct perf_record_opts {
 	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
+	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
 	unsigned int freq;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index e0c0267..89085a9 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
 			if (he == NULL)
 				goto out;
 
@@ -247,7 +247,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
 			if (he == NULL)
 				goto out;
 
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
index 1adb824..23061a6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -563,6 +563,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->branch_sample_type = opts->branch_stack;
 	}
 
+	if (opts->sample_weight)
+		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+
 	attr->mmap = track;
 	attr->comm = track;
 
@@ -1017,6 +1020,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 	data->period = 1;
+	data->weight = 0;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!evsel->attr.sample_id_all)
@@ -1167,6 +1171,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
index f855941..97ddd18 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -155,9 +155,11 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
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
 
@@ -169,12 +171,14 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
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
@@ -282,7 +286,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 static struct hist_entry *add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      u64 period)
+				      u64 period,
+				      u64 weight)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -306,7 +311,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period);
+			he_stat__add_period(&he->stat, period, weight);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -345,7 +350,8 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period)
+					     u64 period,
+					     u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -359,6 +365,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.stat = {
 			.period	= period,
 			.nr_events = 1,
+			.weight = weight,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
@@ -366,12 +373,13 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
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
@@ -385,13 +393,14 @@ struct hist_entry *__hists__add_entry(struct hists *self,
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
index 8483313..121cc14 100644
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
index c8ba120..627be09 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -798,6 +798,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		printf("... weight: %" PRIu64 "\n", sample->weight);
 }
 
 static struct machine *
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d41926c..d66bcd3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -464,6 +464,49 @@ struct sort_entry sort_mispredict = {
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
@@ -480,6 +523,8 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b13e56f..3939250 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,6 +49,7 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
+	u64			weight;
 	u32			nr_events;
 };
 
@@ -130,6 +131,8 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
+	SORT_LOCAL_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
-- 
1.7.1

