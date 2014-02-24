Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaBXTLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:11:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48055 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaBXTLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:11:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Anton Blanchard <anton@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf annotate: Check availability of annotate when processing samples
Date: Mon, 24 Feb 2014 16:10:44 -0300
Message-Id: <1393269045-11572-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393269045-11572-1-git-send-email-acme@infradead.org>
References: <1393269045-11572-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The TUI of perf report and top support annotation, but stdio and GTK
don't.  So it should be checked before calling hist_entry__inc_addr_
samples() to avoid wasting resources that will never be used.

perf annotate need it regardless of UI and sort keys, so the check
of whether to allocate resources should be on the tools that have
annotate as an option in the TUI, 'report' and 'top', not on the
function called by all of them.

It caused perf annotate on ppc64 to produce zero output, since the
buckets were not being allocated.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392859976-32760-1-git-send-email-namhyung@kernel.org
[ Renamed (report,top)__needs_annotate() to ui__has_annotation() ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 40 ++++++++++++++++++++++++----------------
 tools/perf/builtin-top.c    |  6 ++++--
 tools/perf/util/annotate.c  |  9 ++++++++-
 tools/perf/util/annotate.h  |  2 ++
 4 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3c53ec268fbc..02f985f3a396 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -113,14 +113,16 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (!he)
 		return -ENOMEM;
 
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	if (err)
-		goto out;
+	if (ui__has_annotation()) {
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+		if (err)
+			goto out;
 
-	mx = he->mem_info;
-	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
-	if (err)
-		goto out;
+		mx = he->mem_info;
+		err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
+		if (err)
+			goto out;
+	}
 
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
@@ -164,14 +166,18 @@ static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_loc
 		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
 					1, 1, 0);
 		if (he) {
-			bx = he->branch_info;
-			err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
-			if (err)
-				goto out;
-
-			err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
-			if (err)
-				goto out;
+			if (ui__has_annotation()) {
+				bx = he->branch_info;
+				err = addr_map_symbol__inc_samples(&bx->from,
+								   evsel->idx);
+				if (err)
+					goto out;
+
+				err = addr_map_symbol__inc_samples(&bx->to,
+								   evsel->idx);
+				if (err)
+					goto out;
+			}
 
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
@@ -205,7 +211,9 @@ static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evs
 	if (err)
 		goto out;
 
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 76cd510d34d0..5f989a7d8bc2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -176,7 +176,7 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 {
 	struct annotation *notes;
 	struct symbol *sym;
-	int err;
+	int err = 0;
 
 	if (he == NULL || he->ms.sym == NULL ||
 	    ((top->sym_filter_entry == NULL ||
@@ -190,7 +190,9 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 		return;
 
 	ip = he->ms.map->map_ip(he->ms.map, ip);
-	err = hist_entry__inc_addr_samples(he, counter, ip);
+
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, counter, ip);
 
 	pthread_mutex_unlock(&notes->lock);
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 469eb679fb9d..3aa555ff9d89 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -8,6 +8,8 @@
  */
 
 #include "util.h"
+#include "ui/ui.h"
+#include "sort.h"
 #include "build-id.h"
 #include "color.h"
 #include "cache.h"
@@ -489,7 +491,7 @@ static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 {
 	struct annotation *notes;
 
-	if (sym == NULL || use_browser != 1 || !sort__has_sym)
+	if (sym == NULL)
 		return 0;
 
 	notes = symbol__annotation(sym);
@@ -1399,3 +1401,8 @@ int hist_entry__annotate(struct hist_entry *he, size_t privsize)
 {
 	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
 }
+
+bool ui__has_annotation(void)
+{
+	return use_browser == 1 && sort__has_sym;
+}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b2aef59d6bb2..56ad4f5287de 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -151,6 +151,8 @@ void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
 void symbol__annotate_decay_histogram(struct symbol *sym, int evidx);
 void disasm__purge(struct list_head *head);
 
+bool ui__has_annotation(void);
+
 int symbol__tty_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel, bool print_lines,
 			 bool full_paths, int min_pcnt, int max_lines);
-- 
1.8.1.4

