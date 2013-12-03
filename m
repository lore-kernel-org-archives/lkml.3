Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3LCJBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:01:38 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57245 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3LCJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:00:34 -0500
X-AuditID: 9c930197-b7c3dae000002c11-dc-529d9daf8f27
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 2/3] perf tools: Record sampling time for each entry
Date: Tue,  3 Dec 2013 18:00:28 +0900
Message-Id: <1386061229-19514-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386061229-19514-1-git-send-email-namhyung@kernel.org>
References: <1386061229-19514-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes users might want see a relation between value and time of a
sample.  And the time itself is a very important information to have.
As the sample->period value is a diff of counter values between samples
it might make sense to add time-diff between samples into a hist entry.

To do that, calculate elapsed time for each sample and record it.  The
elapsed time is the diff between current sample->time and previous
sample->time which was saved for each evsel.

Maybe we can use PERF_SAMPLE_READ for the precise result.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  2 +-
 tools/perf/builtin-diff.c     |  2 +-
 tools/perf/builtin-report.c   |  9 +++++----
 tools/perf/builtin-top.c      |  2 +-
 tools/perf/tests/hists_link.c |  4 ++--
 tools/perf/util/evsel.h       |  1 +
 tools/perf/util/hist.c        | 10 ++++++++--
 tools/perf/util/hist.h        |  2 +-
 tools/perf/util/session.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h        |  1 +
 10 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4087ab19823c..dc43a64bf723 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -65,7 +65,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 0, 1, 0);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2444bd..85aa961a647e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -307,7 +307,7 @@ static int hists__add_entry(struct hists *hists,
 			    struct addr_location *al, u64 period,
 			    u64 weight, u64 transaction)
 {
-	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
+	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, 0, weight,
 			       transaction) != NULL)
 		return 0;
 	return -ENOMEM;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1d47fbec4421..eb849e9f7093 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -116,7 +116,7 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 	 * and the he_stat__add_period() function.
 	 */
 	he = __hists__add_entry(&evsel->hists, al, parent, NULL, mi,
-				cost, cost, 0);
+				cost, 0, cost, 0);
 	if (!he)
 		return -ENOMEM;
 
@@ -210,7 +210,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
 		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
-					1, 1, 0);
+					1, 0, 1, 0);
 		if (he) {
 			struct annotation *notes;
 			bx = he->branch_info;
@@ -272,8 +272,9 @@ static int perf_evsel__add_hist_entry(struct perf_tool *tool,
 	}
 
 	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction);
+				sample->period,
+				tool->ordered_samples ? sample->read.time_enabled : 0,
+				sample->weight, sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 03d37a76c612..175bde2a0ece 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -247,7 +247,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 
 	pthread_mutex_lock(&evsel->hists.lock);
 	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
-				sample->period, sample->weight,
+				sample->period, 0, sample->weight,
 				sample->transaction);
 	pthread_mutex_unlock(&evsel->hists.lock);
 	if (he == NULL)
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 173bf42cc03e..7bb952e6be62 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 0, 1, 0);
 			if (he == NULL)
 				goto out;
 
@@ -246,7 +246,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 0, 1, 0);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 20a7c653b74b..ac65fc67972c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -69,6 +69,7 @@ struct perf_evsel {
 	struct hists		hists;
 	u64			first_timestamp;
 	u64			last_timestamp;
+	u64			*prev_timestamps;
 	char			*name;
 	double			scale;
 	const char		*unit;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6ea46ec6593e..8b66921fc1bd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -204,11 +204,12 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 }
 
 static void he_stat__add_period(struct he_stat *he_stat, u64 period,
-				u64 weight)
+				u64 sample_time, u64 weight)
 {
 
 	he_stat->period		+= period;
 	he_stat->weight		+= weight;
+	he_stat->time		+= sample_time;
 	he_stat->nr_events	+= 1;
 }
 
@@ -221,10 +222,12 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->period_guest_us	+= src->period_guest_us;
 	dest->nr_events		+= src->nr_events;
 	dest->weight		+= src->weight;
+	dest->time		+= src->time;
 }
 
 static void hist_entry__decay(struct hist_entry *he)
 {
+	he->stat.time = (he->stat.time * 7) / 8;
 	he->stat.period = (he->stat.period * 7) / 8;
 	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
 	/* XXX need decay for weight too? */
@@ -366,6 +369,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, entry->stat.period,
+					    entry->stat.time,
 					    entry->stat.weight);
 
 			/*
@@ -411,7 +415,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *sym_parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
-				      u64 period, u64 weight, u64 transaction)
+				      u64 period, u64 sample_time,
+				      u64 weight, u64 transaction)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -427,6 +432,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.nr_events = 1,
 			.period	= period,
 			.weight = weight,
+			.time = sample_time,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index bc5acdfc2b4b..0433469812dc 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -89,7 +89,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *parent,
 				      struct branch_info *bi,
-				      struct mem_info *mi, u64 period,
+				      struct mem_info *mi, u64 period, u64 time,
 				      u64 weight, u64 transaction);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e4b158f0586a..f36e95f00a05 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -926,6 +926,48 @@ perf_session__deliver_sample(struct perf_session *session,
 	u64 read_format = evsel->attr.read_format;
 
 	if (tool->ordered_samples) {
+		/* FIXME: need to find a way to determine cpu-wide session */
+		bool per_cpu_session = sample_type & PERF_SAMPLE_CPU;
+
+		sample->read.time_enabled = 0;
+
+		if (per_cpu_session) {
+			u64 *ts = evsel->prev_timestamps;
+
+			if (ts == NULL) {
+				int nr_cpus = session->header.env.nr_cpus_online;
+
+				ts = zalloc(nr_cpus * sizeof(ts));
+				if (ts == NULL)
+					return -ENOMEM;
+
+				evsel->prev_timestamps = ts;
+			}
+
+			if (ts[sample->cpu] != 0) {
+				u64 diff = sample->time - ts[sample->cpu];
+
+				sample->read.time_enabled = diff;
+			}
+			ts[sample->cpu] = sample->time;
+		} else {
+			u64 *ts = evsel->prev_timestamps;
+
+			if (ts == NULL) {
+				ts = zalloc(sizeof(*ts));
+				if (ts == NULL)
+					return -ENOMEM;
+
+				evsel->prev_timestamps = ts;
+			}
+
+			if (*ts != 0) {
+				u64 diff = sample->time - *ts;
+				sample->read.time_enabled = diff;
+			}
+			*ts = sample->time;
+		}
+
 		if (evsel->first_timestamp == 0)
 			evsel->first_timestamp = sample->time;
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff42a609..16aaf0a47346 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -51,6 +51,7 @@ struct he_stat {
 	u64			period_guest_sys;
 	u64			period_guest_us;
 	u64			weight;
+	u64			time;
 	u32			nr_events;
 };
 
-- 
1.7.11.7

