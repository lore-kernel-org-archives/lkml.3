Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaDVIvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:51:07 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62708 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaDVIt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:49:57 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/9] perf tools: Account entry stats when it's added to the output tree
Date: Tue, 22 Apr 2014 17:49:45 +0900
Message-Id: <1398156591-11001-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, accounting each sample is done in multiple places - once
when adding them to the input tree, other when adding them to the
output tree.  It's not only confusing but also can cause a subtle
problem since concurrent processing like in perf top might see the
updated stats before adding entries into the output tree - like seeing
more (blank) lines at the end and/or slight inaccurate percentage.

To fix this, only account the entries when it's moved into the output
tree so that they cannot be seen prematurely.  There're some
exceptional cases here and there - they should be addressed separately
with comments.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c | 26 ++++++++++----------------
 tools/perf/builtin-report.c   | 13 -------------
 tools/perf/builtin-top.c      |  4 ----
 tools/perf/util/hist.c        |  3 ++-
 4 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b79b61..469bd5fcb824 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -46,12 +46,11 @@ struct perf_annotate {
 };
 
 static int perf_evsel__add_sample(struct perf_evsel *evsel,
-				  struct perf_sample *sample,
+				  struct perf_sample *sample __maybe_unused,
 				  struct addr_location *al,
 				  struct perf_annotate *ann)
 {
 	struct hist_entry *he;
-	int ret;
 
 	if (ann->sym_hist_filter != NULL &&
 	    (al->sym == NULL ||
@@ -69,10 +68,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 	if (he == NULL)
 		return -ENOMEM;
 
-	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	return ret;
+	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
 static int process_sample_event(struct perf_tool *tool,
@@ -234,19 +230,17 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	total_nr_samples = 0;
 	evlist__for_each(session->evlist, pos) {
 		struct hists *hists = &pos->hists;
-		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
-		if (nr_samples > 0) {
-			total_nr_samples += nr_samples;
-			hists__collapse_resort(hists, NULL);
-			hists__output_resort(hists);
+		hists__collapse_resort(hists, NULL);
+		hists__output_resort(hists);
 
-			if (symbol_conf.event_group &&
-			    !perf_evsel__is_group_leader(pos))
-				continue;
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos))
+			continue;
 
-			hists__find_annotations(hists, pos, ann);
-		}
+		hists__find_annotations(hists, pos, ann);
+
+		total_nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	}
 
 	if (total_nr_samples == 0) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 375fc504386e..5691f55ddd4d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -129,10 +129,6 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 		rep->nr_entries++;
 	}
 
-	evsel->hists.stats.total_period += cost;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
 	err = hist_entry__append_callchain(he, sample);
 out:
 	return err;
@@ -189,11 +185,6 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 				/* count new entries only */
 				rep->nr_entries++;
 			}
-
-			evsel->hists.stats.total_period += 1;
-			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-			if (!he->filtered)
-				evsel->hists.stats.nr_non_filtered_samples++;
 		} else
 			goto out;
 	}
@@ -232,10 +223,6 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 		rep->nr_entries++;
 	}
 
-	evsel->hists.stats.total_period += sample->period;
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
 	return err;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 37d30460bada..fb87c16b2038 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -252,10 +252,6 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	if (he == NULL)
 		return NULL;
 
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-
 	return he;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1c77714f668d..f955ae5a41c5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -344,9 +344,11 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 		hists__calc_col_len(hists, h);
 		hists->nr_non_filtered_entries++;
 		hists->stats.total_non_filtered_period += h->stat.period;
+		hists->stats.nr_non_filtered_samples += h->stat.nr_events;
 	}
 	hists->nr_entries++;
 	hists->stats.total_period += h->stat.period;
+	hists__add_nr_events(hists, PERF_RECORD_SAMPLE, h->stat.nr_events);
 }
 
 static u8 symbol__parent_filter(const struct symbol *parent)
@@ -414,7 +416,6 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
-	hists->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-- 
1.9.2

