Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaE2EAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:00:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53491 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaE2D6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:38 -0400
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
Subject: [PATCH 19/27] perf top: Convert to hist_entry_iter
Date: Thu, 29 May 2014 12:58:22 +0900
Message-Id: <1401335910-16832-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reuse hist_entry_iter__add() function to share the similar code with
perf report.  Note that it needs to be called with hists.lock so tweak
some internal functions not to deadlock or hold the lock too long.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 75 ++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 12e2e1227e47..b101f1aa4ef0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -196,6 +196,12 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 
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
@@ -203,6 +209,8 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 		       sym->name);
 		sleep(1);
 	}
+
+	pthread_mutex_lock(&he->hists->lock);
 }
 
 static void perf_top__show_details(struct perf_top *top)
@@ -238,24 +246,6 @@ out_unlock:
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
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
-	return he;
-}
-
 static void perf_top__print_sym_table(struct perf_top *top)
 {
 	char bf[160];
@@ -659,6 +649,25 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 	return 0;
 }
 
+static int hist_iter__top_callback(struct hist_entry_iter *iter,
+				   struct addr_location *al, void *arg)
+{
+	struct perf_top *top = arg;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
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
@@ -666,8 +675,6 @@ static void perf_event__process_sample(struct perf_tool *tool,
 				       struct machine *machine)
 {
 	struct perf_top *top = container_of(tool, struct perf_top, tool);
-	struct symbol *parent = NULL;
-	u64 ip = sample->ip;
 	struct addr_location al;
 	int err;
 
@@ -742,25 +749,23 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	}
 
 	if (al.sym == NULL || !al.sym->ignore) {
-		struct hist_entry *he;
+		struct hist_entry_iter iter = {
+			.add_entry_cb = hist_iter__top_callback,
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
+		err = hist_entry_iter__add(&iter, &al, evsel, sample,
+					   top->max_stack, top);
+		if (err < 0)
+			pr_err("Problem incrementing symbol period, skipping event\n");
 
-		if (sort__has_sym)
-			perf_top__record_precise_ip(top, he, evsel->idx, ip);
+		pthread_mutex_unlock(&evsel->hists.lock);
 	}
 
 	return;
-- 
1.9.2

