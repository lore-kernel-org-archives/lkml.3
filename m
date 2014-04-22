Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaDVIvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:51:11 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62731 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaDVIt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:49:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/9] perf tools: Introduce hists__inc_dump_events()
Date: Tue, 22 Apr 2014 17:49:46 +0900
Message-Id: <1398156591-11001-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now event stats are accounted at the hists__output_resort(), but if
dump_trace is enabled (via -D option of perf report/annotate), the
perf will not go be there and output will miss the sample events
count.  The hists__inc_dump_events() will take care of it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  1 +
 tools/perf/builtin-report.c   |  3 +++
 tools/perf/util/hist.c        | 13 +++++++++++++
 tools/perf/util/hist.h        |  1 +
 4 files changed, 18 insertions(+)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 469bd5fcb824..be89afbacd39 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -68,6 +68,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 	if (he == NULL)
 		return -ENOMEM;
 
+	hists__inc_dump_events(&evsel->hists);
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5691f55ddd4d..04258e131da4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -124,6 +124,7 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 	}
 
 	rep->nr_samples++;
+	hists__inc_dump_events(&evsel->hists);
 	if (he->stat.nr_events == 1) {
 		/* count new entries only */
 		rep->nr_entries++;
@@ -181,6 +182,7 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 			}
 
 			rep->nr_samples++;
+			hists__inc_dump_events(&evsel->hists);
 			if (he->stat.nr_events == 1) {
 				/* count new entries only */
 				rep->nr_entries++;
@@ -218,6 +220,7 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 
 	rep->nr_samples++;
+	hists__inc_dump_events(&evsel->hists);
 	if (he->stat.nr_events == 1) {
 		/* count new entries only */
 		rep->nr_entries++;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f955ae5a41c5..883340d7d43e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -333,6 +333,19 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	__events_stats__add(&hists->stats, type, 1);
 }
 
+void hists__inc_dump_events(struct hists *hists)
+{
+	if (!dump_trace)
+		return;
+
+	/*
+	 * If dump_trace is enabled, perf will exit before accounting
+	 * sample events during hists__output_resort().  Thus it needs to
+	 * be done separately.
+	 */
+	__events_stats__add(&hists->stats, PERF_RECORD_SAMPLE, 1);
+}
+
 static void hists__add_nr_events(struct hists *hists, u32 type, u32 val)
 {
 	__events_stats__add(&hists->stats, type, val);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5a0343eb22e2..185bd41be2ce 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -118,6 +118,7 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 u64 hists__total_period(struct hists *hists);
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
+void hists__inc_dump_events(struct hists *hists);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
-- 
1.9.2

