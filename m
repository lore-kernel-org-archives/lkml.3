Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3JaG4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:56:24 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43539 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3JaG4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:21 -0400
X-AuditID: 9c930197-b7b3eae00000122e-bf-5271ff12417a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 01/14] perf tools: Consolidate __hists__add_*entry()
Date: Thu, 31 Oct 2013 15:56:03 +0900
Message-Id: <1383202576-28141-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The __hists__add_{branch,mem}_entry() did almost same thing that
__hists__add_entry() does.  Consolidate them into one.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  2 +-
 tools/perf/builtin-diff.c     |  3 +-
 tools/perf/builtin-report.c   | 16 +++++++---
 tools/perf/builtin-top.c      |  5 +--
 tools/perf/tests/hists_link.c |  6 ++--
 tools/perf/util/hist.c        | 73 +++++--------------------------------------
 tools/perf/util/hist.h        | 18 ++---------
 7 files changed, 30 insertions(+), 93 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6c5ae57831f6..4087ab19823c 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -65,7 +65,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1, 0);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b605009e803f..3b67ea2444bd 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -307,7 +307,8 @@ static int hists__add_entry(struct hists *hists,
 			    struct addr_location *al, u64 period,
 			    u64 weight, u64 transaction)
 {
-	if (__hists__add_entry(hists, al, NULL, period, weight, transaction) != NULL)
+	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
+			       transaction) != NULL)
 		return 0;
 	return -ENOMEM;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 98d3891392e2..a7a8f7769629 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -115,7 +115,8 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 	 * and this is indirectly achieved by passing period=weight here
 	 * and the he_stat__add_period() function.
 	 */
-	he = __hists__add_mem_entry(&evsel->hists, al, parent, mi, cost, cost);
+	he = __hists__add_entry(&evsel->hists, al, parent, NULL, mi,
+				cost, cost, 0);
 	if (!he)
 		return -ENOMEM;
 
@@ -200,12 +201,16 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 
 		err = -ENOMEM;
 
+		/* overwrite the 'al' to branch-to info */
+		al->map = bi[i].to.map;
+		al->sym = bi[i].to.sym;
+		al->addr = bi[i].to.addr;
 		/*
 		 * The report shows the percentage of total branches captured
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
-		he = __hists__add_branch_entry(&evsel->hists, al, parent,
-				&bi[i], 1, 1);
+		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
+					1, 1, 0);
 		if (he) {
 			struct annotation *notes;
 			bx = he->branch_info;
@@ -266,8 +271,9 @@ static int perf_evsel__add_hist_entry(struct perf_tool *tool,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
-				sample->weight, sample->transaction);
+	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 04f5bf2d8e10..5c538a43f263 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -246,8 +246,9 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct hist_entry *he;
 
 	pthread_mutex_lock(&evsel->hists.lock);
-	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
-				sample->weight, sample->transaction);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction);
 	pthread_mutex_unlock(&evsel->hists.lock);
 	if (he == NULL)
 		return NULL;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index b51abcb2c243..76992aba00a7 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						1, 1, 0);
+						NULL, NULL, 1, 1, 0);
 			if (he == NULL)
 				goto out;
 
@@ -245,8 +245,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1,
-						0);
+			he = __hists__add_entry(&evsel->hists, &al, NULL,
+						NULL, NULL, 1, 1, 0);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7e80253074b0..e6f953190443 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -407,71 +407,12 @@ out:
 	return he;
 }
 
-struct hist_entry *__hists__add_mem_entry(struct hists *hists,
-					  struct addr_location *al,
-					  struct symbol *sym_parent,
-					  struct mem_info *mi,
-					  u64 period,
-					  u64 weight)
-{
-	struct hist_entry entry = {
-		.thread	= al->thread,
-		.ms = {
-			.map	= al->map,
-			.sym	= al->sym,
-		},
-		.stat = {
-			.period	= period,
-			.weight = weight,
-			.nr_events = 1,
-		},
-		.cpu	= al->cpu,
-		.ip	= al->addr,
-		.level	= al->level,
-		.parent = sym_parent,
-		.filtered = symbol__parent_filter(sym_parent),
-		.hists = hists,
-		.mem_info = mi,
-		.branch_info = NULL,
-	};
-	return add_hist_entry(hists, &entry, al, period, weight);
-}
-
-struct hist_entry *__hists__add_branch_entry(struct hists *hists,
-					     struct addr_location *al,
-					     struct symbol *sym_parent,
-					     struct branch_info *bi,
-					     u64 period,
-					     u64 weight)
-{
-	struct hist_entry entry = {
-		.thread	= al->thread,
-		.ms = {
-			.map	= bi->to.map,
-			.sym	= bi->to.sym,
-		},
-		.cpu	= al->cpu,
-		.ip	= bi->to.addr,
-		.level	= al->level,
-		.stat = {
-			.period	= period,
-			.nr_events = 1,
-			.weight = weight,
-		},
-		.parent = sym_parent,
-		.filtered = symbol__parent_filter(sym_parent),
-		.branch_info = bi,
-		.hists	= hists,
-		.mem_info = NULL,
-	};
-
-	return add_hist_entry(hists, &entry, al, period, weight);
-}
-
 struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 period,
-				      u64 weight, u64 transaction)
+				      struct symbol *sym_parent,
+				      struct branch_info *bi,
+				      struct mem_info *mi,
+				      u64 period, u64 weight, u64 transaction)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -483,15 +424,15 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.ip	= al->addr,
 		.level	= al->level,
 		.stat = {
-			.period	= period,
 			.nr_events = 1,
+			.period	= period,
 			.weight = weight,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= hists,
-		.branch_info = NULL,
-		.mem_info = NULL,
+		.branch_info = bi,
+		.mem_info = mi,
 		.transaction = transaction,
 	};
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9d2d022cdb79..307f1c742563 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -86,7 +86,9 @@ struct hists {
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *parent, u64 period,
+				      struct symbol *parent,
+				      struct branch_info *bi,
+				      struct mem_info *mi, u64 period,
 				      u64 weight, u64 transaction);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
@@ -95,20 +97,6 @@ int hist_entry__sort_snprintf(struct hist_entry *self, char *bf, size_t size,
 			      struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
-struct hist_entry *__hists__add_branch_entry(struct hists *self,
-					     struct addr_location *al,
-					     struct symbol *sym_parent,
-					     struct branch_info *bi,
-					     u64 period,
-					     u64 weight);
-
-struct hist_entry *__hists__add_mem_entry(struct hists *self,
-					  struct addr_location *al,
-					  struct symbol *sym_parent,
-					  struct mem_info *mi,
-					  u64 period,
-					  u64 weight);
-
 void hists__output_resort(struct hists *self);
 void hists__collapse_resort(struct hists *self, struct ui_progress *prog);
 
-- 
1.7.11.7

