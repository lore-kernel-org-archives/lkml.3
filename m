Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3CRQ0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:26:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49408
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab3CRQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/54] perf annotate: Factor out struct source_line_percent
Date: Mon, 18 Mar 2013 13:25:12 -0300
Message-Id: <1363623939-10748-28-git-send-email-acme@infradead.org>
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

The source_line_percent struct contains percentage value of the symbol
histogram.  This is a preparation of event group view change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    2 +-
 tools/perf/util/annotate.c        |   14 +++++++-------
 tools/perf/util/annotate.h        |    8 ++++++--
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 6779847..cfae57f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -257,7 +257,7 @@ static double disasm_line__calc_percent(struct disasm_line *dl, struct symbol *s
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
 			if (src_line) {
-				percent += src_line[offset].percent;
+				percent += src_line[offset].p[0].percent;
 			} else
 				hits += h->addr[offset];
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f080cc4..ebf2596 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -616,7 +616,7 @@ static double disasm__calc_percent(struct annotation *notes, int evidx,
 			if (*path == NULL)
 				*path = src_line[offset].path;
 
-			percent += src_line[offset++].percent;
+			percent += src_line[offset++].p[0].percent;
 		}
 	} else {
 		while (offset < end)
@@ -929,7 +929,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 
 		ret = strcmp(iter->path, src_line->path);
 		if (ret == 0) {
-			iter->percent_sum += src_line->percent;
+			iter->p[0].percent_sum += src_line->p[0].percent;
 			return;
 		}
 
@@ -939,7 +939,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 			p = &(*p)->rb_right;
 	}
 
-	src_line->percent_sum = src_line->percent;
+	src_line->p[0].percent_sum = src_line->p[0].percent;
 
 	rb_link_node(&src_line->node, parent, p);
 	rb_insert_color(&src_line->node, root);
@@ -955,7 +955,7 @@ static void __resort_source_line(struct rb_root *root, struct source_line *src_l
 		parent = *p;
 		iter = rb_entry(parent, struct source_line, node);
 
-		if (src_line->percent_sum > iter->percent_sum)
+		if (src_line->p[0].percent_sum > iter->p[0].percent_sum)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -1025,8 +1025,8 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		u64 offset;
 		FILE *fp;
 
-		src_line[i].percent = 100.0 * h->addr[i] / h->sum;
-		if (src_line[i].percent <= 0.5)
+		src_line[i].p[0].percent = 100.0 * h->addr[i] / h->sum;
+		if (src_line[i].p[0].percent <= 0.5)
 			continue;
 
 		offset = start + i;
@@ -1073,7 +1073,7 @@ static void print_summary(struct rb_root *root, const char *filename)
 		char *path;
 
 		src_line = rb_entry(node, struct source_line, node);
-		percent = src_line->percent_sum;
+		percent = src_line->p[0].percent_sum;
 		color = get_percent_color(percent);
 		path = src_line->path;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 3763954..bb2e3f9 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -74,11 +74,15 @@ struct sym_hist {
 	u64		addr[0];
 };
 
-struct source_line {
-	struct rb_node	node;
+struct source_line_percent {
 	double		percent;
 	double		percent_sum;
+};
+
+struct source_line {
+	struct rb_node	node;
 	char		*path;
+	struct source_line_percent p[1];
 };
 
 /** struct annotated_source - symbols with hits have this attached as in sannotation
-- 
1.7.1

