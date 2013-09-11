Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3IKFMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:12:10 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60655 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3IKFJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:09:36 -0400
X-AuditID: 9c93017e-b7c00ae000002eb6-6b-522ffb0ed458
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/9] perf tools: Factor out get/free_srcline()
Date: Wed, 11 Sep 2013 14:09:28 +0900
Message-Id: <1378876173-13363-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently external addr2line tool is used for srcline sort key and
annotate with srcline info.  Separate the common code to prepare
upcoming enhancements.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile        |  1 +
 tools/perf/util/annotate.c | 20 ++---------
 tools/perf/util/hist.c     |  2 +-
 tools/perf/util/sort.c     | 17 ++--------
 tools/perf/util/srcline.c  | 83 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h     |  6 ++++
 6 files changed, 97 insertions(+), 32 deletions(-)
 create mode 100644 tools/perf/util/srcline.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c5dc1ad1b8d7..3a10a85c3604 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -361,6 +361,7 @@ LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
+LIB_OBJS += $(OUTPUT)util/srcline.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 4f97ae3ec9c0..e51c8360f2ad 100644
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
index e6c11ccf138c..fa695ce1662a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -530,7 +530,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	free(he->branch_info);
 	free(he->mem_info);
-	free(he->srcline);
+	free_srcline(he->srcline);
 	free(he);
 }
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5ba29fc679c5..0d633a059df4 100644
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
index a53535949043..8c99d732960c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -281,4 +281,10 @@ void dump_stack(void);
 extern unsigned int page_size;
 
 void get_term_dimensions(struct winsize *ws);
+
+#define SRCLINE_UNKNOWN  ((char *) "??:0")
+
+char *get_srcline(const char *dso_name, unsigned long addr);
+void free_srcline(char *srcline);
+
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.7.11.7

