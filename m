Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab3JOF0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:26:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33158 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3JOF0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:26:31 -0400
Date: Mon, 14 Oct 2013 22:26:15 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f048d548f803b57ee1dbf66702f398ba69657450@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1378876173-13363-5-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Factor out get/free_srcline()
Git-Commit-ID: f048d548f803b57ee1dbf66702f398ba69657450
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:26:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f048d548f803b57ee1dbf66702f398ba69657450
Gitweb:     http://git.kernel.org/tip/f048d548f803b57ee1dbf66702f398ba69657450
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 11 Sep 2013 14:09:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 15:59:39 -0300

perf annotate: Factor out get/free_srcline()

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

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 40c39c3..1f13615 100644
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
index c6fd187..d48297d 100644
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
index e6fc38a..cca03831 100644
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
index 97cf3ef..b7e0ef0 100644
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
index 0000000..7e92cca
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
index 7fd840b..7c8b43f 100644
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
