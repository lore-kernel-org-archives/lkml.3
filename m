Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab3JNUaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 094/161] perf annotate: Factor out get/free_srcline()
Date: Mon, 14 Oct 2013 17:01:23 -0300
Message-Id: <1381780950-25642-95-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently external addr2line tool is used for srcline sort key and
annotate with srcline info.  Separate the common code to prepare
upcoming enhancements.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf   |  1 +
 tools/perf/util/annotate.c | 20 ++---------
 tools/perf/util/hist.c     |  2 +-
 tools/perf/util/sort.c     | 17 ++--------
 tools/perf/util/srcline.c  | 83 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h     |  5 +++
 6 files changed, 96 insertions(+), 32 deletions(-)
 create mode 100644 tools/perf/util/srcline.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 40c39c39ce80..1f1361531f92 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -363,6 +363,7 @@ LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
+LIB_OBJS += $(OUTPUT)util/srcline.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index c6fd1870f278..d48297d77e19 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1070,7 +1070,7 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 			  (sizeof(src_line->p) * (src_line->nr_pcnt - 1));
 
 	for (i = 0; i < len; i++) {
-		free(src_line->path);
+		free_srcline(src_line->path);
 		src_line = (void *)src_line + sizeof_src_line;
 	}
 
@@ -1087,7 +1087,6 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	u64 start;
 	int i, k;
 	int evidx = evsel->idx;
-	char cmd[PATH_MAX * 2];
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
@@ -1115,10 +1114,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	start = map__rip_2objdump(map, sym->start);
 
 	for (i = 0; i < len; i++) {
-		char *path = NULL;
-		size_t line_len;
 		u64 offset;
-		FILE *fp;
 		double percent_max = 0.0;
 
 		src_line->nr_pcnt = nr_pcnt;
@@ -1135,19 +1131,9 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			goto next;
 
 		offset = start + i;
-		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
-		fp = popen(cmd, "r");
-		if (!fp)
-			goto next;
-
-		if (getline(&path, &line_len, fp) < 0 || !line_len)
-			goto next_close;
-
-		src_line->path = path;
+		src_line->path = get_srcline(filename, offset);
 		insert_source_line(&tmp_root, src_line);
 
-	next_close:
-		pclose(fp);
 	next:
 		src_line = (void *)src_line + sizeof_src_line;
 	}
@@ -1188,7 +1174,7 @@ static void print_summary(struct rb_root *root, const char *filename)
 
 		path = src_line->path;
 		color = get_percent_color(percent_max);
-		color_fprintf(stdout, color, " %s", path);
+		color_fprintf(stdout, color, " %s\n", path);
 
 		node = rb_next(node);
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e6fc38a86e2c..cca03831f41a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -535,7 +535,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	free(he->branch_info);
 	free(he->mem_info);
-	free(he->srcline);
+	free_srcline(he->srcline);
 	free(he);
 }
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 97cf3ef4417c..b7e0ef0445de 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -251,8 +251,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 					unsigned int width __maybe_unused)
 {
 	FILE *fp = NULL;
-	char cmd[PATH_MAX + 2], *path = self->srcline, *nl;
-	size_t line_len;
+	char *path = self->srcline;
 
 	if (path != NULL)
 		goto out_path;
@@ -263,19 +262,9 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
 		goto out_ip;
 
-	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
-		 self->ms.map->dso->long_name, self->ip);
-	fp = popen(cmd, "r");
-	if (!fp)
-		goto out_ip;
-
-	if (getline(&self->srcline, &line_len, fp) < 0 || !line_len)
-		goto out_ip;
+	path = get_srcline(self->ms.map->dso->long_name, self->ip);
+	self->srcline = path;
 
-	nl = strchr(self->srcline, '\n');
-	if (nl != NULL)
-		*nl = '\0';
-	path = self->srcline;
 out_path:
 	if (fp)
 		pclose(fp);
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
new file mode 100644
index 000000000000..7e92cca6f502
--- /dev/null
+++ b/tools/perf/util/srcline.c
@@ -0,0 +1,83 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <linux/kernel.h>
+
+#include "util/util.h"
+#include "util/debug.h"
+
+static int addr2line(const char *dso_name, unsigned long addr,
+		     char **file, unsigned int *line_nr)
+{
+	FILE *fp;
+	char cmd[PATH_MAX];
+	char *filename = NULL;
+	size_t len;
+	char *sep;
+	int ret = 0;
+
+	scnprintf(cmd, sizeof(cmd), "addr2line -e %s %016"PRIx64,
+		  dso_name, addr);
+
+	fp = popen(cmd, "r");
+	if (fp == NULL) {
+		pr_warning("popen failed for %s\n", dso_name);
+		return 0;
+	}
+
+	if (getline(&filename, &len, fp) < 0 || !len) {
+		pr_warning("addr2line has no output for %s\n", dso_name);
+		goto out;
+	}
+
+	sep = strchr(filename, '\n');
+	if (sep)
+		*sep = '\0';
+
+	if (!strcmp(filename, "??:0")) {
+		pr_debug("no debugging info in %s\n", dso_name);
+		free(filename);
+		goto out;
+	}
+
+	sep = strchr(filename, ':');
+	if (sep) {
+		*sep++ = '\0';
+		*file = filename;
+		*line_nr = strtoul(sep, NULL, 0);
+		ret = 1;
+	}
+out:
+	pclose(fp);
+	return ret;
+}
+
+char *get_srcline(const char *dso_name, unsigned long addr)
+{
+	char *file;
+	unsigned line;
+	char *srcline;
+	size_t size;
+
+	if (!addr2line(dso_name, addr, &file, &line))
+		return SRCLINE_UNKNOWN;
+
+	/* just calculate actual length */
+	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
+
+	srcline = malloc(size);
+	if (srcline)
+		snprintf(srcline, size, "%s:%u", file, line);
+	else
+		srcline = SRCLINE_UNKNOWN;
+
+	free(file);
+	return srcline;
+}
+
+void free_srcline(char *srcline)
+{
+	if (srcline && strcmp(srcline, SRCLINE_UNKNOWN) != 0)
+		free(srcline);
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7fd840bf6b62..7c8b43fa8898 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -297,4 +297,9 @@ struct parse_tag {
 };
 
 unsigned long parse_tag_value(const char *str, struct parse_tag *tags);
+
+#define SRCLINE_UNKNOWN  ((char *) "??:0")
+
+char *get_srcline(const char *dso_name, unsigned long addr);
+void free_srcline(char *srcline);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.4

