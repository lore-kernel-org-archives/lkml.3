Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaANF2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:28:05 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51192 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaANF0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:07 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-b1-52d4ca68e753
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 21/24] perf top: Convert to hist_entry_iter
Date: Tue, 14 Jan 2014 14:25:54 +0900
Message-Id: <1389677157-30513-22-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reuse hist_entry_iter__add() function to share the similar code with
perf report.  Note that it needs to be called with hists.lock so tweak
some internal functions not to deadlock or hold the lock too long.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 78 ++++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c574c291383c..9de14f71c196 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -194,6 +194,12 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 
 	pthread_mutex_unlock(&notes->lock);
 
+	/*
+	 * This function is now called with he->hists->lock held.
+	 * Release it before going to sleep.
+	 */
+	pthread_mutex_unlock(&he->hists->lock);
+
 	if (err == -ERANGE && !he->ms.map->erange_warned)
 		ui__warn_map_erange(he->ms.map, sym, ip);
 	else if (err == -ENOMEM) {
@@ -201,6 +207,8 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 		       sym->name);
 		sleep(1);
 	}
+
+	pthread_mutex_lock(&he->hists->lock);
 }
 
 static void perf_top__show_details(struct perf_top *top)
@@ -236,24 +244,6 @@ out_unlock:
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
-						     struct addr_location *al,
-						     struct perf_sample *sample)
-{
-	struct hist_entry *he;
-
-	pthread_mutex_lock(&evsel->hists.lock);
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction, true);
-	pthread_mutex_unlock(&evsel->hists.lock);
-	if (he == NULL)
-		return NULL;
-
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	return he;
-}
-
 static void perf_top__print_sym_table(struct perf_top *top)
 {
 	char bf[160];
@@ -657,6 +647,28 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 	return 0;
 }
 
+static int hist_iter_cb(struct hist_entry_iter *iter, struct addr_location *al,
+			bool single, void *arg)
+{
+	struct perf_top *top = arg;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+
+	if (single)
+		hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+	if (sort__has_sym) {
+		u64 ip = al->addr;
+
+		if (al->map)
+			ip = al->map->unmap_ip(al->map, ip);
+
+		perf_top__record_precise_ip(top, he, evsel->idx, ip);
+	}
+
+	return 0;
+}
+
 static void perf_event__process_sample(struct perf_tool *tool,
 				       const union perf_event *event,
 				       struct perf_evsel *evsel,
@@ -664,8 +676,6 @@ static void perf_event__process_sample(struct perf_tool *tool,
 				       struct machine *machine)
 {
 	struct perf_top *top = container_of(tool, struct perf_top, tool);
-	struct symbol *parent = NULL;
-	u64 ip = sample->ip;
 	struct addr_location al;
 	int err;
 
@@ -741,25 +751,23 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	}
 
 	if (al.sym == NULL || !al.sym->ignore) {
-		struct hist_entry *he;
+		struct hist_entry_iter iter = {
+			.add_entry_cb = hist_iter_cb,
+		};
 
-		err = sample__resolve_callchain(sample, &parent, evsel, &al,
-						top->max_stack);
-		if (err)
-			return;
+		if (symbol_conf.cumulate_callchain)
+			iter.ops = &hist_iter_cumulative;
+		else
+			iter.ops = &hist_iter_normal;
 
-		he = perf_evsel__add_hist_entry(evsel, &al, sample);
-		if (he == NULL) {
-			pr_err("Problem incrementing symbol period, skipping event\n");
-			return;
-		}
+		pthread_mutex_lock(&evsel->hists.lock);
 
-		err = hist_entry__append_callchain(he, sample);
-		if (err)
-			return;
+		err = hist_entry_iter__add(&iter, &al, evsel, event, sample,
+					   top->max_stack, top);
+		if (err < 0)
+			pr_err("Problem incrementing symbol period, skipping event\n");
 
-		if (sort__has_sym)
-			perf_top__record_precise_ip(top, he, evsel->idx, ip);
+		pthread_mutex_unlock(&evsel->hists.lock);
 	}
 
 	return;
-- 
1.7.11.7

