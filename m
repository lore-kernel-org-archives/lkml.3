Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037AbaFCSf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:35:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984AbaFCSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:35:20 -0400
Date: Tue, 3 Jun 2014 11:35:05 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7c50391f536ea6ed1e75b0f4d90922a2606da3de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-20-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-20-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Convert to hist_entry_iter
Git-Commit-ID: 7c50391f536ea6ed1e75b0f4d90922a2606da3de
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

Commit-ID:  7c50391f536ea6ed1e75b0f4d90922a2606da3de
Gitweb:     http://git.kernel.org/tip/7c50391f536ea6ed1e75b0f4d90922a2606da3de
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 7 Jan 2014 17:41:03 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:06 +0200

perf top: Convert to hist_entry_iter

Reuse hist_entry_iter__add() function to share the similar code with
perf report.  Note that it needs to be called with hists.lock so tweak
some internal functions not to deadlock or hold the lock too long.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1401335910-16832-20-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-top.c | 76 ++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 12e2e12..b1cb5f5 100644
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
@@ -659,6 +649,26 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 	return 0;
 }
 
+static int hist_iter__top_callback(struct hist_entry_iter *iter,
+				   struct addr_location *al, bool single,
+				   void *arg)
+{
+	struct perf_top *top = arg;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+
+	if (sort__has_sym && single) {
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
@@ -666,8 +676,6 @@ static void perf_event__process_sample(struct perf_tool *tool,
 				       struct machine *machine)
 {
 	struct perf_top *top = container_of(tool, struct perf_top, tool);
-	struct symbol *parent = NULL;
-	u64 ip = sample->ip;
 	struct addr_location al;
 	int err;
 
@@ -742,25 +750,23 @@ static void perf_event__process_sample(struct perf_tool *tool,
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
