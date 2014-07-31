Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaGaRYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:24:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:11698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaGaRXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:23:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="581800598"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/9] tools, perf: Make get_srcline fall back to sym+offset
Date: Thu, 31 Jul 2014 10:17:07 -0700
Message-Id: <1406827029-7991-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
References: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When the source line is not found fall back to sym + offset.
This is generally much more useful than a raw address.
For this we need to pass in the symbol from the caller.
For some callers it's awkward to compute, so we stay
at the old behaviour.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/annotate.c  |  2 +-
 tools/perf/util/callchain.c |  3 ++-
 tools/perf/util/map.c       |  2 +-
 tools/perf/util/sort.c      |  6 ++++--
 tools/perf/util/srcline.c   | 12 +++++++++---
 tools/perf/util/util.h      |  4 +++-
 6 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 12997ff..363b0c1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1187,7 +1187,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			goto next;
 
 		offset = start + i;
-		src_line->path = get_srcline(map->dso, offset);
+		src_line->path = get_srcline(map->dso, offset, NULL, false);
 		insert_source_line(&tmp_root, src_line);
 
 	next:
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 8e75b35..efb1f4f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -690,7 +690,8 @@ char *callchain_list__sym_name(struct callchain_list *cl,
 		    cl->ms.map && !cl->srcline)
 			cl->srcline = get_srcline(cl->ms.map->dso,
 						  map__rip_2objdump(cl->ms.map,
-								    cl->ip));
+								    cl->ip),
+						  cl->ms.sym, false);
 		if (cl->srcline)
 			printed = scnprintf(bf, bfsize, "%s %s",
 					cl->ms.sym->name, cl->srcline);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 31b8905..76910f8 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -359,7 +359,7 @@ int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
 
 	if (map && map->dso) {
 		srcline = get_srcline(map->dso,
-				      map__rip_2objdump(map, addr));
+				      map__rip_2objdump(map, addr), NULL, true);
 		if (srcline != SRCLINE_UNKNOWN)
 			ret = fprintf(fp, "%s%s", prefix, srcline);
 		free_srcline(srcline);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 58b4a92..9f49646 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -286,7 +286,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 		else {
 			struct map *map = left->ms.map;
 			left->srcline = get_srcline(map->dso,
-					    map__rip_2objdump(map, left->ip));
+					   map__rip_2objdump(map, left->ip),
+						    left->ms.sym, true);
 		}
 	}
 	if (!right->srcline) {
@@ -295,7 +296,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 		else {
 			struct map *map = right->ms.map;
 			right->srcline = get_srcline(map->dso,
-					    map__rip_2objdump(map, right->ip));
+					     map__rip_2objdump(map, right->ip),
+						     right->ms.sym, true);
 		}
 	}
 	return strcmp(right->srcline, left->srcline);
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index ac877f9..36a7aff 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -8,12 +8,13 @@
 #include "util/util.h"
 #include "util/debug.h"
 
+#include "symbol.h"
+
 #ifdef HAVE_LIBBFD_SUPPORT
 
 /*
  * Implement addr2line using libbfd.
  */
-#define PACKAGE "perf"
 #include <bfd.h>
 
 struct a2l_data {
@@ -250,7 +251,8 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
  */
 #define A2L_FAIL_LIMIT 123
 
-char *get_srcline(struct dso *dso, unsigned long addr)
+char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+		  bool show_sym)
 {
 	char *file = NULL;
 	unsigned line = 0;
@@ -289,7 +291,11 @@ out:
 		dso->has_srcline = 0;
 		dso__free_a2l(dso);
 	}
-	if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+	if (sym) {
+		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
+					addr - sym->start) < 0)
+			return SRCLINE_UNKNOWN;
+	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
 		return SRCLINE_UNKNOWN;
 	return srcline;
 }
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6686436..0086323 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -318,8 +318,10 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags);
 #define SRCLINE_UNKNOWN  ((char *) "??:0")
 
 struct dso;
+struct symbol;
 
-char *get_srcline(struct dso *dso, unsigned long addr);
+char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+		  bool show_sym);
 void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
-- 
1.9.3

