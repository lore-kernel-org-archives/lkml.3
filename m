Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaE2D6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:58:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53174 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaE2D6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:33 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 01/27] perf tools: Introduce hists__inc_nr_samples()
Date: Thu, 29 May 2014 12:58:04 +0900
Message-Id: <1401335910-16832-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There're some duplicate code for counting number of samples.  Add
hists__inc_nr_samples() and reuse it.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c   | 2 +-
 tools/perf/builtin-report.c     | 4 +---
 tools/perf/builtin-sched.c      | 2 +-
 tools/perf/builtin-top.c        | 5 +----
 tools/perf/tests/hists_filter.c | 4 +---
 tools/perf/util/hist.c          | 7 +++++++
 tools/perf/util/hist.h          | 1 +
 7 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index d30d2c2e2a7a..bf52461a88bd 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -70,7 +70,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return -ENOMEM;
 
 	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	hists__inc_nr_samples(&evsel->hists, true);
 	return ret;
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bc0eec1ce4be..4a3b84dd4f41 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -92,9 +92,7 @@ static void report__inc_stats(struct report *rep, struct hist_entry *he)
 	 * counted in perf_session_deliver_event().  The dump_trace
 	 * requires this info is ready before going to the output tree.
 	 */
-	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		he->hists->stats.nr_non_filtered_samples++;
+	hists__inc_nr_samples(he->hists, he->filtered);
 }
 
 static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d7176830b9b2..c38d06c04775 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1428,7 +1428,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 	int err = 0;
 
 	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	hists__inc_nr_samples(&evsel->hists, true);
 
 	if (evsel->handler != NULL) {
 		tracepoint_handler f = evsel->handler;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5b389ce4cd15..51309264d210 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -252,10 +252,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	if (he == NULL)
 		return NULL;
 
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-
+	hists__inc_nr_samples(&evsel->hists, he->filtered);
 	return he;
 }
 
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index c5ba924a3581..0a71ef4b9158 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -85,9 +85,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			fake_samples[i].map = al.map;
 			fake_samples[i].sym = al.sym;
 
-			hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
-			if (!he->filtered)
-				he->hists->stats.nr_non_filtered_samples++;
+			hists__inc_nr_samples(he->hists, he->filtered);
 		}
 	}
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b262b44b7a65..5943ba60f193 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -800,6 +800,13 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	events_stats__inc(&hists->stats, type);
 }
 
+void hists__inc_nr_samples(struct hists *hists, bool filtered)
+{
+	events_stats__inc(&hists->stats, PERF_RECORD_SAMPLE);
+	if (!filtered)
+		hists->stats.nr_non_filtered_samples++;
+}
+
 static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 						 struct hist_entry *pair)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a8418d19808d..03ae1dbb1b15 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,6 +119,7 @@ u64 hists__total_period(struct hists *hists);
 void hists__reset_stats(struct hists *hists);
 void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
+void hists__inc_nr_samples(struct hists *hists, bool filtered);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
-- 
1.9.2

