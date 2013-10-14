Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab3JNUex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:34:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38868 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab3JNUDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 096/161] perf annotate: Pass dso instead of dso_name to get_srcline()
Date: Mon, 14 Oct 2013 17:01:25 -0300
Message-Id: <1381780950-25642-97-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

This is a preparation of next change.  No functional changes are
intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 11 ++++-------
 tools/perf/util/dso.h      |  1 +
 tools/perf/util/sort.c     |  2 +-
 tools/perf/util/srcline.c  |  4 +++-
 tools/perf/util/util.h     |  4 +++-
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d48297d77e19..d73e8008aada 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1081,8 +1081,7 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 /* Get the filename:line for the colored entries */
 static int symbol__get_source_line(struct symbol *sym, struct map *map,
 				   struct perf_evsel *evsel,
-				   struct rb_root *root, int len,
-				   const char *filename)
+				   struct rb_root *root, int len)
 {
 	u64 start;
 	int i, k;
@@ -1131,7 +1130,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			goto next;
 
 		offset = start + i;
-		src_line->path = get_srcline(filename, offset);
+		src_line->path = get_srcline(map->dso, offset);
 		insert_source_line(&tmp_root, src_line);
 
 	next:
@@ -1338,7 +1337,6 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map,
 			 bool full_paths, int min_pcnt, int max_lines)
 {
 	struct dso *dso = map->dso;
-	const char *filename = dso->long_name;
 	struct rb_root source_line = RB_ROOT;
 	u64 len;
 
@@ -1348,9 +1346,8 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map,
 	len = symbol__size(sym);
 
 	if (print_lines) {
-		symbol__get_source_line(sym, map, evsel, &source_line,
-					len, filename);
-		print_summary(&source_line, filename);
+		symbol__get_source_line(sym, map, evsel, &source_line, len);
+		print_summary(&source_line, dso->long_name);
 	}
 
 	symbol__annotate_printf(sym, map, evsel, full_paths,
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index dbd9241ea290..72eedd65fc2d 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -6,6 +6,7 @@
 #include <stdbool.h>
 #include "types.h"
 #include "map.h"
+#include "build-id.h"
 
 enum dso_binary_type {
 	DSO_BINARY_TYPE__KALLSYMS = 0,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d4435939c774..f732120e8bc6 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -259,7 +259,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!self->ms.map)
 		goto out_ip;
 
-	path = get_srcline(self->ms.map->dso->long_name, self->ip);
+	path = get_srcline(self->ms.map->dso, self->ip);
 	self->srcline = path;
 
 out_path:
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 777f91880cdb..c736d9428cf2 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -4,6 +4,7 @@
 
 #include <linux/kernel.h>
 
+#include "util/dso.h"
 #include "util/util.h"
 #include "util/debug.h"
 
@@ -53,11 +54,12 @@ out:
 	return ret;
 }
 
-char *get_srcline(const char *dso_name, unsigned long addr)
+char *get_srcline(struct dso *dso, unsigned long addr)
 {
 	char *file;
 	unsigned line;
 	char *srcline = SRCLINE_UNKNOWN;
+	char *dso_name = dso->long_name;
 	size_t size;
 
 	if (dso_name[0] == '[')
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7c8b43fa8898..1f06ba44cd53 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -300,6 +300,8 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags);
 
 #define SRCLINE_UNKNOWN  ((char *) "??:0")
 
-char *get_srcline(const char *dso_name, unsigned long addr);
+struct dso;
+
+char *get_srcline(struct dso *dso, unsigned long addr);
 void free_srcline(char *srcline);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.4

