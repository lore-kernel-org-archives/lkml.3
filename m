Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbbA2IKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51330 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbbA2IKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:12 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 20/42] perf tools: Use thread__comm_time() when adding hist entries
Date: Thu, 29 Jan 2015 17:07:01 +0900
Message-Id: <1422518843-25818-21-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now thread->comm can be handled with time properly, use it to find
correct comm when adding hist entries.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  5 +++--
 tools/perf/builtin-diff.c     |  8 ++++----
 tools/perf/tests/hists_link.c |  4 ++--
 tools/perf/util/hist.c        | 19 ++++++++++---------
 tools/perf/util/hist.h        |  2 +-
 5 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index b89e4c6ed488..50628900f9fa 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -47,7 +47,7 @@ struct perf_annotate {
 };
 
 static int perf_evsel__add_sample(struct perf_evsel *evsel,
-				  struct perf_sample *sample __maybe_unused,
+				  struct perf_sample *sample,
 				  struct addr_location *al,
 				  struct perf_annotate *ann)
 {
@@ -67,7 +67,8 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(hists, al, NULL, NULL, NULL, 1, 1, 0, true);
+	he = __hists__add_entry(hists, al, NULL, NULL, NULL, 1, 1, 0,
+				sample->time, true);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3e2229227062..ddf6f0999838 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -313,10 +313,10 @@ static int formula_fprintf(struct hist_entry *he, struct hist_entry *pair,
 
 static int hists__add_entry(struct hists *hists,
 			    struct addr_location *al, u64 period,
-			    u64 weight, u64 transaction)
+			    u64 weight, u64 transaction, u64 timestamp)
 {
 	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
-			       transaction, true) != NULL)
+			       transaction, timestamp, true) != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -338,8 +338,8 @@ static int diff__process_sample_event(struct perf_tool *tool,
 		return -1;
 	}
 
-	if (hists__add_entry(hists, &al, sample->period,
-			     sample->weight, sample->transaction)) {
+	if (hists__add_entry(hists, &al, sample->period, sample->weight,
+			     sample->transaction, sample->time)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index a731a531a3e2..4f3d45692acb 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -90,7 +90,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(hists, &al, NULL,
-						NULL, NULL, 1, 1, 0, true);
+						NULL, NULL, 1, 1, 0, -1, true);
 			if (he == NULL)
 				goto out;
 
@@ -114,7 +114,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(hists, &al, NULL,
-						NULL, NULL, 1, 1, 0, true);
+						NULL, NULL, 1, 1, 0, -1, true);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 70b48a65064c..4badf2491fbf 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -447,11 +447,11 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
 				      u64 period, u64 weight, u64 transaction,
-				      bool sample_self)
+				      u64 timestamp, bool sample_self)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
-		.comm = thread__comm(al->thread),
+		.comm = thread__comm_time(al->thread, timestamp),
 		.ms = {
 			.map	= al->map,
 			.sym	= al->sym,
@@ -509,13 +509,14 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 {
 	u64 cost;
 	struct mem_info *mi = iter->priv;
+	struct perf_sample *sample = iter->sample;
 	struct hists *hists = evsel__hists(iter->evsel);
 	struct hist_entry *he;
 
 	if (mi == NULL)
 		return -EINVAL;
 
-	cost = iter->sample->weight;
+	cost = sample->weight;
 	if (!cost)
 		cost = 1;
 
@@ -527,7 +528,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 	 * and the he_stat__add_period() function.
 	 */
 	he = __hists__add_entry(hists, al, iter->parent, NULL, mi,
-				cost, cost, 0, true);
+				cost, cost, 0, sample->time, true);
 	if (!he)
 		return -ENOMEM;
 
@@ -628,7 +629,7 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 	 * and not events sampled. Thus we use a pseudo period of 1.
 	 */
 	he = __hists__add_entry(hists, al, iter->parent, &bi[i], NULL,
-				1, 1, 0, true);
+				1, 1, 0, iter->sample->time, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -666,7 +667,7 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 
 	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction, true);
+				sample->transaction, sample->time, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -728,7 +729,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 
 	he = __hists__add_entry(hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction, true);
+				sample->transaction, sample->time, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -772,7 +773,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	struct hist_entry he_tmp = {
 		.cpu = al->cpu,
 		.thread = al->thread,
-		.comm = thread__comm(al->thread),
+		.comm = thread__comm_time(al->thread, sample->time),
 		.ip = al->addr,
 		.ms = {
 			.map = al->map,
@@ -801,7 +802,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 
 	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction, false);
+				sample->transaction, sample->time, false);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2b690d028907..0eed50a5b1f0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -109,7 +109,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct branch_info *bi,
 				      struct mem_info *mi, u64 period,
 				      u64 weight, u64 transaction,
-				      bool sample_self);
+				      u64 timestamp, bool sample_self);
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
 			 int max_stack_depth, void *arg);
-- 
2.2.2

