Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaLHGtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:49:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaLHGtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:49:43 -0500
Date: Sun, 7 Dec 2014 22:49:30 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-85c116a6cb91a5c09b7a6c95ffc6a6cbd32cd237@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, ak@linux.intel.com,
        jolsa@redhat.com, acme@redhat.com
Reply-To: hpa@zytor.com, tglx@linutronix.de, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com
In-Reply-To: <1415844328-4884-10-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-10-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Make get_srcline fall back to sym+offset
Git-Commit-ID: 85c116a6cb91a5c09b7a6c95ffc6a6cbd32cd237
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85c116a6cb91a5c09b7a6c95ffc6a6cbd32cd237
Gitweb:     http://git.kernel.org/tip/85c116a6cb91a5c09b7a6c95ffc6a6cbd32cd237
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 12 Nov 2014 18:05:27 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:47 -0300

perf callchain: Make get_srcline fall back to sym+offset

When the source line is not found fall back to sym + offset.  This is
generally much more useful than a raw address.

For this we need to pass in the symbol from the caller.

For some callers it's awkward to compute, so we stay at the old
behaviour.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-10-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c  |  2 +-
 tools/perf/util/callchain.c |  3 ++-
 tools/perf/util/map.c       |  2 +-
 tools/perf/util/sort.c      |  6 ++++--
 tools/perf/util/srcline.c   | 11 +++++++++--
 tools/perf/util/util.h      |  4 +++-
 6 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e5670f1..79999ce 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1192,7 +1192,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			goto next;
 
 		offset = start + i;
-		src_line->path = get_srcline(map->dso, offset);
+		src_line->path = get_srcline(map->dso, offset, NULL, false);
 		insert_source_line(&tmp_root, src_line);
 
 	next:
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index b6624ae..517ed84 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -819,7 +819,8 @@ char *callchain_list__sym_name(struct callchain_list *cl,
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
index 040a785..62ca9f2 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -360,7 +360,7 @@ int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
 
 	if (map && map->dso) {
 		srcline = get_srcline(map->dso,
-				      map__rip_2objdump(map, addr));
+				      map__rip_2objdump(map, addr), NULL, true);
 		if (srcline != SRCLINE_UNKNOWN)
 			ret = fprintf(fp, "%s%s", prefix, srcline);
 		free_srcline(srcline);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 82a5596..9139dda 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -291,7 +291,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 		else {
 			struct map *map = left->ms.map;
 			left->srcline = get_srcline(map->dso,
-					    map__rip_2objdump(map, left->ip));
+					   map__rip_2objdump(map, left->ip),
+						    left->ms.sym, true);
 		}
 	}
 	if (!right->srcline) {
@@ -300,7 +301,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
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
index ac877f9..e73b6a5 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -8,6 +8,8 @@
 #include "util/util.h"
 #include "util/debug.h"
 
+#include "symbol.h"
+
 #ifdef HAVE_LIBBFD_SUPPORT
 
 /*
@@ -250,7 +252,8 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
  */
 #define A2L_FAIL_LIMIT 123
 
-char *get_srcline(struct dso *dso, unsigned long addr)
+char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+		  bool show_sym)
 {
 	char *file = NULL;
 	unsigned line = 0;
@@ -289,7 +292,11 @@ out:
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
index 76d23d8..419bee0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -337,8 +337,10 @@ static inline int path__join3(char *bf, size_t size,
 }
 
 struct dso;
+struct symbol;
 
-char *get_srcline(struct dso *dso, unsigned long addr);
+char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+		  bool show_sym);
 void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
