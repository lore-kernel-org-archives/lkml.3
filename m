Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaDYNV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:21:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaDYNOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:14:34 -0400
Date: Fri, 25 Apr 2014 06:14:23 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-820bc81f4cdaac09a8f25040d3a20d86f3da292b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-7-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Account entry stats when it'
 s added to the output tree
Git-Commit-ID: 820bc81f4cdaac09a8f25040d3a20d86f3da292b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  820bc81f4cdaac09a8f25040d3a20d86f3da292b
Gitweb:     http://git.kernel.org/tip/820bc81f4cdaac09a8f25040d3a20d86f3da292b
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 22 Apr 2014 11:44:21 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:32:15 +0200

perf tools: Account entry stats when it's added to the output tree

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
Link: http://lkml.kernel.org/r/1398327843-31845-7-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-annotate.c |  3 +--
 tools/perf/builtin-diff.c     | 13 +++++++++----
 tools/perf/builtin-report.c   | 24 ++++++++++--------------
 tools/perf/util/hist.c        |  1 -
 4 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b..d30d2c2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -46,7 +46,7 @@ struct perf_annotate {
 };
 
 static int perf_evsel__add_sample(struct perf_evsel *evsel,
-				  struct perf_sample *sample,
+				  struct perf_sample *sample __maybe_unused,
 				  struct addr_location *al,
 				  struct perf_annotate *ann)
 {
@@ -70,7 +70,6 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return -ENOMEM;
 
 	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	return ret;
 }
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 52d91ac..f3b10dc 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -341,11 +341,16 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (al.filtered == 0) {
-		evsel->hists.stats.total_non_filtered_period += sample->period;
-		evsel->hists.nr_non_filtered_entries++;
-	}
+	/*
+	 * The total_period is updated here before going to the output
+	 * tree since normally only the baseline hists will call
+	 * hists__output_resort() and precompute needs the total
+	 * period in order to sort entries by percentage delta.
+	 */
 	evsel->hists.stats.total_period += sample->period;
+	if (!al.filtered)
+		evsel->hists.stats.total_non_filtered_period += sample->period;
+
 	return 0;
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index aed5203..89c9528 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -85,6 +85,16 @@ static void report__inc_stats(struct report *rep, struct hist_entry *he)
 	 */
 	if (he->stat.nr_events == 1)
 		rep->nr_entries++;
+
+	/*
+	 * Only counts number of samples at this stage as it's more
+	 * natural to do it here and non-sample events are also
+	 * counted in perf_session_deliver_event().  The dump_trace
+	 * requires this info is ready before going to the output tree.
+	 */
+	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		he->hists->stats.nr_non_filtered_samples++;
 }
 
 static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
@@ -135,10 +145,6 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 
 	report__inc_stats(rep, he);
 
-	evsel->hists.stats.total_period += cost;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
 	err = hist_entry__append_callchain(he, sample);
 out:
 	return err;
@@ -189,13 +195,7 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 				if (err)
 					goto out;
 			}
-
 			report__inc_stats(rep, he);
-
-			evsel->hists.stats.total_period += 1;
-			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-			if (!he->filtered)
-				evsel->hists.stats.nr_non_filtered_samples++;
 		} else
 			goto out;
 	}
@@ -230,10 +230,6 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 
 	report__inc_stats(rep, he);
 
-	evsel->hists.stats.total_period += sample->period;
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
 	return err;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8d5cfcc..6d0d2d7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -382,7 +382,6 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
-	hists->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
