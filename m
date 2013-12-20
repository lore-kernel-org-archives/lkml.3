Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3LTTJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:09:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38447 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3LTTJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:27 -0500
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
Subject: [PATCH 09/35] perf annotate: Adopt methods from hists
Date: Fri, 20 Dec 2013 16:08:44 -0300
Message-Id: <1387566550-3524-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Those are just wrappers to annotation methods, so move them to
annotate.c

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
Link: http://lkml.kernel.org/n/tip-336h7z0bi2k51cbfi6mkpo5k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 10 ++++++++++
 tools/perf/util/annotate.h |  5 +++++
 tools/perf/util/hist.c     | 11 -----------
 tools/perf/util/hist.h     |  3 ---
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 2812e7b78d0f..91e25269bb27 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -508,6 +508,11 @@ int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx)
 	return symbol__inc_addr_samples(ams->sym, ams->map, evidx, ams->al_addr);
 }
 
+int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
+{
+	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
+}
+
 static void disasm_line__init_ins(struct disasm_line *dl)
 {
 	dl->ins = ins__find(dl->name);
@@ -1393,3 +1398,8 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map,
 
 	return 0;
 }
+
+int hist_entry__annotate(struct hist_entry *he, size_t privsize)
+{
+	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
+}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 8de10b1ef027..43727a9b93cd 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -137,10 +137,15 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx);
 
+int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 addr);
+
 int symbol__alloc_hist(struct symbol *sym);
 void symbol__annotate_zero_histograms(struct symbol *sym);
 
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
+
+int hist_entry__annotate(struct hist_entry *he, size_t privsize);
+
 int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym);
 int symbol__annotate_printf(struct symbol *sym, struct map *map,
 			    struct perf_evsel *evsel, bool full_paths,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 63234e37583c..6cd4823a7a8b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,4 +1,3 @@
-#include "annotate.h"
 #include "util.h"
 #include "build-id.h"
 #include "hist.h"
@@ -807,16 +806,6 @@ void hists__filter_by_symbol(struct hists *hists)
 	}
 }
 
-int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
-{
-	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
-}
-
-int hist_entry__annotate(struct hist_entry *he, size_t privsize)
-{
-	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
-}
-
 void events_stats__inc(struct events_stats *stats, u32 type)
 {
 	++stats->nr_events[0];
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b621347a1585..a59743fa3ef7 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -111,9 +111,6 @@ size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp);
 
-int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 addr);
-int hist_entry__annotate(struct hist_entry *he, size_t privsize);
-
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
 void hists__filter_by_symbol(struct hists *hists);
-- 
1.8.1.4

