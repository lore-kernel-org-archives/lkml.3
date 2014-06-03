Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaFCSbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:31:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44743 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaFCSbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:31:48 -0400
Date: Tue, 3 Jun 2014 11:31:22 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-1844dbcbe78503e0f4a8996d69da725d5e7a5177@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1401335910-16832-2-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Introduce hists__inc_nr_samples()
Git-Commit-ID: 1844dbcbe78503e0f4a8996d69da725d5e7a5177
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

Commit-ID:  1844dbcbe78503e0f4a8996d69da725d5e7a5177
Gitweb:     http://git.kernel.org/tip/1844dbcbe78503e0f4a8996d69da725d5e7a5177
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 28 May 2014 14:12:18 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:34:55 +0200

perf tools: Introduce hists__inc_nr_samples()

There're some duplicate code for counting number of samples.  Add
hists__inc_nr_samples() and reuse it.

Suggested-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1401335910-16832-2-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
index d30d2c2..bf52461 100644
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
index bc0eec1..4a3b84d 100644
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
index d717683..c38d06c 100644
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
index 5b389ce..5130926 100644
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
index c5ba924..0a71ef4 100644
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
index b262b44..5943ba6 100644
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
index a8418d1..03ae1db 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,6 +119,7 @@ u64 hists__total_period(struct hists *hists);
 void hists__reset_stats(struct hists *hists);
 void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
+void hists__inc_nr_samples(struct hists *hists, bool filtered);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
