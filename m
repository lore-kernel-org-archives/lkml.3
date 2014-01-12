Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaALSct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:32:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaALScl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:32:41 -0500
Date: Sun, 12 Jan 2014 10:31:57 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-d728gz1orgkaknac9ppnzd9e@git.kernel.org>
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
Subject: [tip:perf/core] perf annotate:
  Add inc_samples method to addr_map_symbol
Git-Commit-ID: 0f4e7a24d0303eaf12847b4fdf4f2d31553fdc61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:32:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f4e7a24d0303eaf12847b4fdf4f2d31553fdc61
Gitweb:     http://git.kernel.org/tip/0f4e7a24d0303eaf12847b4fdf4f2d31553fdc61
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 18 Dec 2013 16:48:29 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 11:34:19 -0300

perf annotate: Add inc_samples method to addr_map_symbol

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
index 0615a63..9a20c9e 100644
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
index 93614cd..2812e7b 100644
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
index 834b7b5..8de10b1 100644
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
 
