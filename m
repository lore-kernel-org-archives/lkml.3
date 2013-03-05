Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab3CEFyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:54:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53847 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592Ab3CEFxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:53 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-1d-5135886dd60b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 10/12] perf annotate browser: Use disasm__calc_percent()
Date: Tue,  5 Mar 2013 14:53:30 +0900
Message-Id: <1362462812-30885-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The disasm_line__calc_percent() which was used by annotate browser
code almost duplicates disasm__calc_percent.  Let's get rid of the
code duplication.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 50 +++++++++++----------------------------
 tools/perf/util/annotate.c        |  4 ++--
 tools/perf/util/annotate.h        |  4 ++++
 3 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 62369f0b6608..8b16926dd56e 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -240,40 +240,6 @@ static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 	return ret;
 }
 
-static double disasm_line__calc_percent(struct disasm_line *dl, struct symbol *sym, int evidx)
-{
-	double percent = 0.0;
-
-	if (dl->offset != -1) {
-		int len = sym->end - sym->start;
-		unsigned int hits = 0;
-		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evidx);
-		s64 offset = dl->offset;
-		struct disasm_line *next;
-
-		next = disasm__get_next_ip_line(&notes->src->source, dl);
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (src_line) {
-				percent += src_line[offset].p[0].percent;
-			} else
-				hits += h->addr[offset];
-
-			++offset;
-		}
-		/*
- 		 * If the percentage wasn't already calculated in
- 		 * symbol__get_source_line, do it now:
- 		 */
-		if (src_line == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
-	}
-
-	return percent;
-}
-
 static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl)
 {
 	struct rb_node **p = &root->rb_node;
@@ -337,7 +303,8 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 	struct map_symbol *ms = browser->b.priv;
 	struct symbol *sym = ms->sym;
 	struct annotation *notes = symbol__annotation(sym);
-	struct disasm_line *pos;
+	struct disasm_line *pos, *next;
+	s64 len = symbol__size(sym);
 
 	browser->entries = RB_ROOT;
 
@@ -345,7 +312,18 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
-		bpos->percent[0] = disasm_line__calc_percent(pos, sym, evsel->idx);
+		const char *path = NULL;
+
+		if (pos->offset == -1) {
+			RB_CLEAR_NODE(&bpos->rb_node);
+			continue;
+		}
+
+		next = disasm__get_next_ip_line(&notes->src->source, pos);
+		bpos->percent[0] = disasm__calc_percent(notes, evsel->idx,
+					pos->offset, next ? next->offset : len,
+				        &path);
+
 		if (bpos->percent[0] < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 05e34df5d041..d102716c43a1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -603,8 +603,8 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 	return NULL;
 }
 
-static double disasm__calc_percent(struct annotation *notes, int evidx,
-				   s64 offset, s64 end, const char **path)
+double disasm__calc_percent(struct annotation *notes, int evidx, s64 offset,
+			    s64 end, const char **path)
 {
 	struct source_line *src_line = notes->src->lines;
 	double percent = 0.0;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 68f851e6c685..6f3c16f01ab4 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -50,6 +50,8 @@ bool ins__is_jump(const struct ins *ins);
 bool ins__is_call(const struct ins *ins);
 int ins__scnprintf(struct ins *ins, char *bf, size_t size, struct ins_operands *ops);
 
+struct annotation;
+
 struct disasm_line {
 	struct list_head    node;
 	s64		    offset;
@@ -68,6 +70,8 @@ void disasm_line__free(struct disasm_line *dl);
 struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disasm_line *pos);
 int disasm_line__scnprintf(struct disasm_line *dl, char *bf, size_t size, bool raw);
 size_t disasm__fprintf(struct list_head *head, FILE *fp);
+double disasm__calc_percent(struct annotation *notes, int evidx, s64 offset,
+			    s64 end, const char **path);
 
 struct sym_hist {
 	u64		sum;
-- 
1.7.11.7

