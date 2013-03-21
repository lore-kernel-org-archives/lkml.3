Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3CULYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:24:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56519 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3CULYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:24:46 -0400
Date: Thu, 21 Mar 2013 04:23:10 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e64aa75bf5559be3ce72e53ae28b76a2f633ca06@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-11-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-11-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Use disasm__calc_percent()
Git-Commit-ID: e64aa75bf5559be3ce72e53ae28b76a2f633ca06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:23:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e64aa75bf5559be3ce72e53ae28b76a2f633ca06
Gitweb:     http://git.kernel.org/tip/e64aa75bf5559be3ce72e53ae28b76a2f633ca06
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 5 Mar 2013 14:53:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:06 -0300

perf annotate browser: Use disasm__calc_percent()

The disasm_line__calc_percent() which was used by annotate browser code
almost duplicates disasm__calc_percent.  Let's get rid of the code
duplication.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-11-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c | 50 +++++++++++----------------------------
 tools/perf/util/annotate.c        |  4 ++--
 tools/perf/util/annotate.h        |  4 ++++
 3 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 62369f0..8b16926 100644
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
index 05e34df..d102716 100644
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
index 68f851e..6f3c16f 100644
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
