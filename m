Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3LTTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:09:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38531 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3LTTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/35] perf annotate: Auto allocate symbol per addr hist buckets
Date: Fri, 20 Dec 2013 16:08:40 -0300
Message-Id: <1387566550-3524-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of open coding it in multiple places in 'report' and 'top'.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ay1ushp57qsva9aw59rha5ve@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 59 ++++++++++++---------------------------------
 tools/perf/builtin-top.c    | 13 ++++------
 tools/perf/util/annotate.c  | 26 ++++++++++++++------
 3 files changed, 40 insertions(+), 58 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3a14dbed387c..b75fc361b9bd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -140,22 +140,11 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 			goto out;
 	}
 
-	if (sort__has_sym && he->mem_info->daddr.sym && use_browser > 0) {
-		struct annotation *notes;
-
-		mx = he->mem_info;
-
-		notes = symbol__annotation(mx->daddr.sym);
-		if (notes->src == NULL && symbol__alloc_hist(mx->daddr.sym) < 0)
-			goto out;
-
-		err = symbol__inc_addr_samples(mx->daddr.sym,
-					       mx->daddr.map,
-					       evsel->idx,
-					       mx->daddr.al_addr);
-		if (err)
-			goto out;
-	}
+	mx = he->mem_info;
+	err = symbol__inc_addr_samples(mx->daddr.sym, mx->daddr.map,
+				       evsel->idx, mx->daddr.al_addr);
+	if (err)
+		goto out;
 
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
@@ -214,35 +203,19 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
 					1, 1, 0);
 		if (he) {
-			struct annotation *notes;
 			bx = he->branch_info;
-			if (bx->from.sym && use_browser == 1 && sort__has_sym) {
-				notes = symbol__annotation(bx->from.sym);
-				if (!notes->src
-				    && symbol__alloc_hist(bx->from.sym) < 0)
-					goto out;
-
-				err = symbol__inc_addr_samples(bx->from.sym,
-							       bx->from.map,
-							       evsel->idx,
-							       bx->from.al_addr);
-				if (err)
-					goto out;
-			}
+			err = symbol__inc_addr_samples(bx->from.sym,
+						       bx->from.map, evsel->idx,
+						       bx->from.al_addr);
+			if (err)
+				goto out;
+
+			err = symbol__inc_addr_samples(bx->to.sym,
+						       bx->to.map, evsel->idx,
+						       bx->to.al_addr);
+			if (err)
+				goto out;
 
-			if (bx->to.sym && use_browser == 1 && sort__has_sym) {
-				notes = symbol__annotation(bx->to.sym);
-				if (!notes->src
-				    && symbol__alloc_hist(bx->to.sym) < 0)
-					goto out;
-
-				err = symbol__inc_addr_samples(bx->to.sym,
-							       bx->to.map,
-							       evsel->idx,
-							       bx->to.al_addr);
-				if (err)
-					goto out;
-			}
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 		} else
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 03d37a76c612..73df9c05bad9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -189,14 +189,6 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 	if (pthread_mutex_trylock(&notes->lock))
 		return;
 
-	if (notes->src == NULL && symbol__alloc_hist(sym) < 0) {
-		pthread_mutex_unlock(&notes->lock);
-		pr_err("Not enough memory for annotating '%s' symbol!\n",
-		       sym->name);
-		sleep(1);
-		return;
-	}
-
 	ip = he->ms.map->map_ip(he->ms.map, ip);
 	err = symbol__inc_addr_samples(sym, he->ms.map, counter, ip);
 
@@ -204,6 +196,11 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 
 	if (err == -ERANGE && !he->ms.map->erange_warned)
 		ui__warn_map_erange(he->ms.map, sym, ip);
+	else if (err == -ENOMEM) {
+		pr_err("Not enough memory for annotating '%s' symbol!\n",
+		       sym->name);
+		sleep(1);
+	}
 }
 
 static void perf_top__show_details(struct perf_top *top)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0fcd81ea31ae..93614cd3948f 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -464,17 +464,12 @@ void symbol__annotate_zero_histograms(struct symbol *sym)
 	pthread_mutex_unlock(&notes->lock);
 }
 
-int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
-			     int evidx, u64 addr)
+static int __symbol__inc_addr_samples(struct symbol *sym, struct map *map,
+				      struct annotation *notes, int evidx, u64 addr)
 {
 	unsigned offset;
-	struct annotation *notes;
 	struct sym_hist *h;
 
-	notes = symbol__annotation(sym);
-	if (notes->src == NULL)
-		return -ENOMEM;
-
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
 	if (addr < sym->start || addr > sym->end)
@@ -491,6 +486,23 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
+			     int evidx, u64 addr)
+{
+	struct annotation *notes;
+
+	if (sym == NULL || use_browser != 1 || !sort__has_sym)
+		return 0;
+
+	notes = symbol__annotation(sym);
+	if (notes->src == NULL) {
+		if (symbol__alloc_hist(sym) < 0)
+			return -ENOMEM;
+	}
+
+	return __symbol__inc_addr_samples(sym, map, notes, evidx, addr);
+}
+
 static void disasm_line__init_ins(struct disasm_line *dl)
 {
 	dl->ins = ins__find(dl->name);
-- 
1.8.1.4

