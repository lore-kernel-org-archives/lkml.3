Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3LTTVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:21:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38479 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3LTTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:28 -0500
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
Subject: [PATCH 07/35] perf annotate: Add inc_samples method to addr_map_symbol
Date: Fri, 20 Dec 2013 16:08:42 -0300
Message-Id: <1387566550-3524-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since there are three calls that could receive just the struct
addr_map_symbol pointer and call the symbol method.

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
Link: http://lkml.kernel.org/n/tip-d728gz1orgkaknac9ppnzd9e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 11 +++--------
 tools/perf/util/annotate.c  |  5 +++++
 tools/perf/util/annotate.h  |  3 +++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0615a63ae355..9a20c9efb84b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -127,8 +127,7 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 		goto out;
 
 	mx = he->mem_info;
-	err = symbol__inc_addr_samples(mx->daddr.sym, mx->daddr.map,
-				       evsel->idx, mx->daddr.al_addr);
+	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
 	if (err)
 		goto out;
 
@@ -190,15 +189,11 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 					1, 1, 0);
 		if (he) {
 			bx = he->branch_info;
-			err = symbol__inc_addr_samples(bx->from.sym,
-						       bx->from.map, evsel->idx,
-						       bx->from.al_addr);
+			err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
 			if (err)
 				goto out;
 
-			err = symbol__inc_addr_samples(bx->to.sym,
-						       bx->to.map, evsel->idx,
-						       bx->to.al_addr);
+			err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
 			if (err)
 				goto out;
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 93614cd3948f..2812e7b78d0f 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -503,6 +503,11 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 	return __symbol__inc_addr_samples(sym, map, notes, evidx, addr);
 }
 
+int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx)
+{
+	return symbol__inc_addr_samples(ams->sym, ams->map, evidx, ams->al_addr);
+}
+
 static void disasm_line__init_ins(struct disasm_line *dl)
 {
 	dl->ins = ins__find(dl->name);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 834b7b57b788..8de10b1ef027 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -134,6 +134,9 @@ static inline struct annotation *symbol__annotation(struct symbol *sym)
 
 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 			     int evidx, u64 addr);
+
+int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx);
+
 int symbol__alloc_hist(struct symbol *sym);
 void symbol__annotate_zero_histograms(struct symbol *sym);
 
-- 
1.8.1.4

