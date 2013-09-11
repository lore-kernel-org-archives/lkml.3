Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3IKFLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:11:25 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60655 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3IKFJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:09:38 -0400
X-AuditID: 9c93017e-b7c00ae000002eb6-6d-522ffb0e0996
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/9] perf tools: Pass dso instead of dso_name to get_srcline()
Date: Wed, 11 Sep 2013 14:09:30 +0900
Message-Id: <1378876173-13363-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

This is a preparation of next change.  No functional changes are
intended.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 11 ++++-------
 tools/perf/util/dso.h      |  1 +
 tools/perf/util/sort.c     |  2 +-
 tools/perf/util/srcline.c  |  4 +++-
 tools/perf/util/util.h     |  4 +++-
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e51c8360f2ad..f7bdc01d10bb 100644
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
index b793053335d6..477b3b68daf4 100644
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
index 113aa92b1191..58cfe69d3a6c 100644
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
index 8c99d732960c..f1b1b0764b1c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -284,7 +284,9 @@ void get_term_dimensions(struct winsize *ws);
 
 #define SRCLINE_UNKNOWN  ((char *) "??:0")
 
-char *get_srcline(const char *dso_name, unsigned long addr);
+struct dso;
+
+char *get_srcline(struct dso *dso, unsigned long addr);
 void free_srcline(char *srcline);
 
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.7.11.7

