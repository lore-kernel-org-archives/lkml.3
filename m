Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaALSdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:33:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaALScz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:32:55 -0500
Date: Sun, 12 Jan 2014 10:32:16 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-336h7z0bi2k51cbfi6mkpo5k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Adopt methods from hists
Git-Commit-ID: f626adffe17632aa7b0e2a7732b49e2c32d477d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:32:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f626adffe17632aa7b0e2a7732b49e2c32d477d8
Gitweb:     http://git.kernel.org/tip/f626adffe17632aa7b0e2a7732b49e2c32d477d8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 18 Dec 2013 17:10:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 11:34:27 -0300

perf annotate: Adopt methods from hists

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
index 2812e7b..91e2526 100644
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
index 8de10b1..43727a9 100644
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
index 63234e3..6cd4823 100644
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
index b621347a..a59743f 100644
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
