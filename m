Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbaKMXO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:14:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:10610 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933920AbaKMXO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:14:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,380,1413270000"; 
   d="scan'208";a="622079760"
From: Andi Kleen <andi@firstfloor.org>
To: acme@kernel.org
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] tools, perf: Fix symbol offset fallback path in get_srcline
Date: Thu, 13 Nov 2014 15:12:42 -0800
Message-Id: <1415920362-22793-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[This is a bug fix over the earlier branch callstack patchkit]

get_srcline has a fallback path when it cannot find the line
number for an address: it returns sym+offset.

The normal line number resolution process uses the al_addr,
which is the address relative to the start of the DSO.
However to compute the offset from the symbol we need the
absolute address.

Since the dso start offset is not easily available here just
pass it in from the caller.

In theory it would be tempting to move the 2objdump conversion
call into get_srcline, but I think that would slow down
annotate quite a bit which caches it, so I didn't do it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/annotate.c  | 3 ++-
 tools/perf/util/callchain.c | 2 +-
 tools/perf/util/map.c       | 3 ++-
 tools/perf/util/sort.c      | 6 ++++--
 tools/perf/util/srcline.c   | 6 +++---
 tools/perf/util/util.h      | 2 +-
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9837adf..acb3a4e9 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1190,7 +1190,8 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			goto next;
 
 		offset = start + i;
-		src_line->path = get_srcline(map->dso, offset, NULL, false);
+		src_line->path = get_srcline(map->dso, offset, NULL, false,
+					     sym->start + i);
 		insert_source_line(&tmp_root, src_line);
 
 	next:
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index cf524a3..00c9891 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -824,7 +824,7 @@ char *callchain_list__sym_name(struct callchain_list *cl,
 			cl->srcline = get_srcline(cl->ms.map->dso,
 						  map__rip_2objdump(cl->ms.map,
 								    cl->ip),
-						  cl->ms.sym, false);
+						  cl->ms.sym, false, cl->ip);
 		if (cl->srcline)
 			printed = scnprintf(bf, bfsize, "%s %s",
 					cl->ms.sym->name, cl->srcline);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 62ca9f2..5550f7a 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -360,7 +360,8 @@ int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
 
 	if (map && map->dso) {
 		srcline = get_srcline(map->dso,
-				      map__rip_2objdump(map, addr), NULL, true);
+				      map__rip_2objdump(map, addr), NULL, true,
+				      addr);
 		if (srcline != SRCLINE_UNKNOWN)
 			ret = fprintf(fp, "%s%s", prefix, srcline);
 		free_srcline(srcline);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 95efaaf..d89e5d3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -292,7 +292,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 			struct map *map = left->ms.map;
 			left->srcline = get_srcline(map->dso,
 					   map__rip_2objdump(map, left->ip),
-						    left->ms.sym, true);
+						    left->ms.sym, true,
+						    left->ip);
 		}
 	}
 	if (!right->srcline) {
@@ -302,7 +303,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 			struct map *map = right->ms.map;
 			right->srcline = get_srcline(map->dso,
 					     map__rip_2objdump(map, right->ip),
-						     right->ms.sym, true);
+						     right->ms.sym, true,
+						     right->ip);
 		}
 	}
 	return strcmp(right->srcline, left->srcline);
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 36a7aff..7f5a8e8 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -252,7 +252,7 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
 #define A2L_FAIL_LIMIT 123
 
 char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
-		  bool show_sym)
+		  bool show_sym, unsigned long abs_addr)
 {
 	char *file = NULL;
 	unsigned line = 0;
@@ -293,9 +293,9 @@ out:
 	}
 	if (sym) {
 		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
-					addr - sym->start) < 0)
+					abs_addr - sym->start) < 0)
 			return SRCLINE_UNKNOWN;
-	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, abs_addr) < 0)
 		return SRCLINE_UNKNOWN;
 	return srcline;
 }
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 921c48b..2ed8536 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -341,7 +341,7 @@ struct dso;
 struct symbol;
 
 char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
-		  bool show_sym);
+		  bool show_sym, unsigned long abs_addr);
 void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
-- 
1.9.3

