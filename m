Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776Ab3CEFzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:55:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3CEFxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:51 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-04-5135886a61f0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 08/12] perf annotate: Support event group view for --print-line
Date: Tue,  5 Mar 2013 14:53:28 +0900
Message-Id: <1362462812-30885-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocate source_line_percent according to a number of
group members and save nr_pcnt to the struct source_line.  This
way we can handle multiple events in a general manner.

However since the size of struct source_line is not fixed anymore,
iterating whole source_line should care about its size.

  $ perf annotate --group --stdio --print-line

  Sorted summary for file /lib/ld-2.11.1.so
  ----------------------------------------------
     33.33    0.00 /build/buildd/eglibc-2.11.1/elf/rtld.c:381
     33.33    0.00 /build/buildd/eglibc-2.11.1/elf/dynamic-link.h:128
     33.33    0.00 /build/buildd/eglibc-2.11.1/elf/do-rel.h:105
      0.00   75.00 /build/buildd/eglibc-2.11.1/elf/dynamic-link.h:137
      0.00   25.00 /build/buildd/eglibc-2.11.1/elf/dynamic-link.h:187
  ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 130 +++++++++++++++++++++++++++++++++------------
 tools/perf/util/annotate.h |   1 +
 2 files changed, 98 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ebf2596d7e2e..05e34df5d041 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -607,18 +607,26 @@ static double disasm__calc_percent(struct annotation *notes, int evidx,
 				   s64 offset, s64 end, const char **path)
 {
 	struct source_line *src_line = notes->src->lines;
-	struct sym_hist *h = annotation__histogram(notes, evidx);
-	unsigned int hits = 0;
 	double percent = 0.0;
 
 	if (src_line) {
+		size_t sizeof_src_line = sizeof(*src_line) +
+				sizeof(src_line->p) * (src_line->nr_pcnt - 1);
+
 		while (offset < end) {
+			src_line = (void *)notes->src->lines +
+					(sizeof_src_line * offset);
+
 			if (*path == NULL)
-				*path = src_line[offset].path;
+				*path = src_line->path;
 
-			percent += src_line[offset++].p[0].percent;
+			percent += src_line->p[evidx].percent;
+			offset++;
 		}
 	} else {
+		struct sym_hist *h = annotation__histogram(notes, evidx);
+		unsigned int hits = 0;
+
 		while (offset < end)
 			hits += h->addr[offset++];
 
@@ -658,9 +666,10 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 		for (i = 0; i < nr_percent; i++) {
 			percent = disasm__calc_percent(notes,
-						evsel->idx + i, offset,
-						next ? next->offset : (s64) len,
-						&path);
+					notes->src->lines ? i : evsel->idx + i,
+					offset,
+					next ? next->offset : (s64) len,
+					&path);
 
 			ppercents[i] = percent;
 			if (percent > max_percent)
@@ -921,7 +930,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 	struct source_line *iter;
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
-	int ret;
+	int i, ret;
 
 	while (*p != NULL) {
 		parent = *p;
@@ -929,7 +938,8 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 
 		ret = strcmp(iter->path, src_line->path);
 		if (ret == 0) {
-			iter->p[0].percent_sum += src_line->p[0].percent;
+			for (i = 0; i < src_line->nr_pcnt; i++)
+				iter->p[i].percent_sum += src_line->p[i].percent;
 			return;
 		}
 
@@ -939,12 +949,26 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 			p = &(*p)->rb_right;
 	}
 
-	src_line->p[0].percent_sum = src_line->p[0].percent;
+	for (i = 0; i < src_line->nr_pcnt; i++)
+		src_line->p[i].percent_sum = src_line->p[i].percent;
 
 	rb_link_node(&src_line->node, parent, p);
 	rb_insert_color(&src_line->node, root);
 }
 
+static int cmp_source_line(struct source_line *a, struct source_line *b)
+{
+	int i;
+
+	for (i = 0; i < a->nr_pcnt; i++) {
+		if (a->p[i].percent_sum == b->p[i].percent_sum)
+			continue;
+		return a->p[i].percent_sum > b->p[i].percent_sum;
+	}
+
+	return 0;
+}
+
 static void __resort_source_line(struct rb_root *root, struct source_line *src_line)
 {
 	struct source_line *iter;
@@ -955,7 +979,7 @@ static void __resort_source_line(struct rb_root *root, struct source_line *src_l
 		parent = *p;
 		iter = rb_entry(parent, struct source_line, node);
 
-		if (src_line->p[0].percent_sum > iter->p[0].percent_sum)
+		if (cmp_source_line(src_line, iter))
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -987,12 +1011,18 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct source_line *src_line = notes->src->lines;
+	size_t sizeof_src_line;
 	int i;
 
-	for (i = 0; i < len; i++)
-		free(src_line[i].path);
+	sizeof_src_line = sizeof(*src_line) +
+			  (sizeof(src_line->p) * (src_line->nr_pcnt - 1));
 
-	free(src_line);
+	for (i = 0; i < len; i++) {
+		free(src_line->path);
+		src_line = (void *)src_line + sizeof_src_line;
+	}
+
+	free(notes->src->lines);
 	notes->src->lines = NULL;
 }
 
@@ -1003,17 +1033,30 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 				   const char *filename)
 {
 	u64 start;
-	int i;
+	int i, k;
+	int evidx = evsel->idx;
 	char cmd[PATH_MAX * 2];
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = annotation__histogram(notes, evsel->idx);
+	struct sym_hist *h = annotation__histogram(notes, evidx);
 	struct rb_root tmp_root = RB_ROOT;
+	int nr_pcnt = 1;
+	u64 h_sum = h->sum;
+	size_t sizeof_src_line = sizeof(struct source_line);
+
+	if (perf_evsel__is_group_event(evsel)) {
+		for (i = 1; i < evsel->nr_members; i++) {
+			h = annotation__histogram(notes, evidx + i);
+			h_sum += h->sum;
+		}
+		nr_pcnt = evsel->nr_members;
+		sizeof_src_line += (nr_pcnt - 1) * sizeof(src_line->p);
+	}
 
-	if (!h->sum)
+	if (!h_sum)
 		return 0;
 
-	src_line = notes->src->lines = calloc(len, sizeof(struct source_line));
+	src_line = notes->src->lines = calloc(len, sizeof_src_line);
 	if (!notes->src->lines)
 		return -1;
 
@@ -1024,29 +1067,41 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		size_t line_len;
 		u64 offset;
 		FILE *fp;
+		double percent_max = 0.0;
 
-		src_line[i].p[0].percent = 100.0 * h->addr[i] / h->sum;
-		if (src_line[i].p[0].percent <= 0.5)
-			continue;
+		src_line->nr_pcnt = nr_pcnt;
+
+		for (k = 0; k < nr_pcnt; k++) {
+			h = annotation__histogram(notes, evidx + k);
+			src_line->p[k].percent = 100.0 * h->addr[i] / h->sum;
+
+			if (src_line->p[k].percent > percent_max)
+				percent_max = src_line->p[k].percent;
+		}
+
+		if (percent_max <= 0.5)
+			goto next;
 
 		offset = start + i;
 		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
-			continue;
+			goto next;
 
 		if (getline(&path, &line_len, fp) < 0 || !line_len)
-			goto next;
+			goto next_close;
 
-		src_line[i].path = malloc(sizeof(char) * line_len + 1);
-		if (!src_line[i].path)
-			goto next;
+		src_line->path = malloc(sizeof(char) * line_len + 1);
+		if (!src_line->path)
+			goto next_close;
 
-		strcpy(src_line[i].path, path);
-		insert_source_line(&tmp_root, &src_line[i]);
+		strcpy(src_line->path, path);
+		insert_source_line(&tmp_root, src_line);
 
-	next:
+	next_close:
 		pclose(fp);
+	next:
+		src_line = (void *)src_line + sizeof_src_line;
 	}
 
 	resort_source_line(root, &tmp_root);
@@ -1068,16 +1123,25 @@ static void print_summary(struct rb_root *root, const char *filename)
 
 	node = rb_first(root);
 	while (node) {
-		double percent;
+		double percent, percent_max = 0.0;
 		const char *color;
 		char *path;
+		int i;
 
 		src_line = rb_entry(node, struct source_line, node);
-		percent = src_line->p[0].percent_sum;
-		color = get_percent_color(percent);
+		for (i = 0; i < src_line->nr_pcnt; i++) {
+			percent = src_line->p[i].percent_sum;
+			color = get_percent_color(percent);
+			color_fprintf(stdout, color, " %7.2f", percent);
+
+			if (percent > percent_max)
+				percent_max = percent;
+		}
+
 		path = src_line->path;
+		color = get_percent_color(percent_max);
+		color_fprintf(stdout, color, " %s", path);
 
-		color_fprintf(stdout, color, " %7.2f %s", percent, path);
 		node = rb_next(node);
 	}
 }
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index bb2e3f998983..68f851e6c685 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -82,6 +82,7 @@ struct source_line_percent {
 struct source_line {
 	struct rb_node	node;
 	char		*path;
+	int		nr_pcnt;
 	struct source_line_percent p[1];
 };
 
-- 
1.7.11.7

