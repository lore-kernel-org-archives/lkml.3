Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3CRQdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:33:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49405
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819Ab3CRQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/54] perf annotate: Factor out disasm__calc_percent()
Date: Mon, 18 Mar 2013 13:25:08 -0300
Message-Id: <1363623939-10748-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Factor out calculation of histogram of a symbol into
disasm__calc_percent.  It'll be used for later changes.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   49 ++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index fa347b1..a91d7b1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -603,6 +603,33 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 	return NULL;
 }
 
+static double disasm__calc_percent(struct disasm_line *next,
+				   struct annotation *notes, int evidx,
+				   s64 offset, u64 len, const char **path)
+{
+	struct source_line *src_line = notes->src->lines;
+	struct sym_hist *h = annotation__histogram(notes, evidx);
+	unsigned int hits = 0;
+	double percent = 0.0;
+
+	while (offset < (s64)len &&
+	       (next == NULL || offset < next->offset)) {
+		if (src_line) {
+			if (*path == NULL)
+				*path = src_line[offset].path;
+			percent += src_line[offset].percent;
+		} else
+			hits += h->addr[offset];
+
+		++offset;
+	}
+
+	if (src_line == NULL && h->sum)
+		percent = 100.0 * hits / h->sum;
+
+	return percent;
+}
+
 static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 start,
 		      struct perf_evsel *evsel, u64 len, int min_pcnt, int printed,
 		      int max_lines, struct disasm_line *queue)
@@ -612,33 +639,17 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 	if (dl->offset != -1) {
 		const char *path = NULL;
-		unsigned int hits = 0;
-		double percent = 0.0;
+		double percent;
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 		s64 offset = dl->offset;
 		const u64 addr = start + offset;
 		struct disasm_line *next;
 
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (src_line) {
-				if (path == NULL)
-					path = src_line[offset].path;
-				percent += src_line[offset].percent;
-			} else
-				hits += h->addr[offset];
-
-			++offset;
-		}
-
-		if (src_line == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
-
+		percent = disasm__calc_percent(next, notes, evsel->idx,
+					       offset, len, &path);
 		if (percent < min_pcnt)
 			return -1;
 
-- 
1.7.1

