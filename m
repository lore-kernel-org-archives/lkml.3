Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaGNVrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbaGNVrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:47:08 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/5] perf tools: Remove verbose from functions prototypes
Date: Mon, 14 Jul 2014 23:46:47 +0200
Message-Id: <1405374411-29012-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
References: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use verbose as an global object in following fuunctions:
  __map_groups__fprintf_maps
  __map_groups__fprintf_removed_maps
  map_groups__fprintf_maps
  map_groups__fprintf

Also making map_groups__fprintf_maps static.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/stdio/hist.c |  2 +-
 tools/perf/util/map.c      | 24 ++++++++++++------------
 tools/perf/util/map.h      |  9 ++++-----
 tools/perf/util/thread.c   |  4 ++--
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 90122abd3721..40af0acb4fe9 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -479,7 +479,7 @@ print_entries:
 
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(h->thread->mg,
-						   MAP__FUNCTION, verbose, fp);
+						   MAP__FUNCTION, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
 	}
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 25c571f4cba6..49f5f37e0fe3 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -12,6 +12,7 @@
 #include "vdso.h"
 #include "build-id.h"
 #include "util.h"
+#include "debug.h"
 #include <linux/string.h>
 
 const char *map_type__name[MAP__NR_TYPES] = {
@@ -554,8 +555,8 @@ int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
 	return ams->sym ? 0 : -1;
 }
 
-size_t __map_groups__fprintf_maps(struct map_groups *mg,
-				  enum map_type type, int verbose, FILE *fp)
+size_t __map_groups__fprintf_maps(struct map_groups *mg, enum map_type type,
+				  FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -573,17 +574,16 @@ size_t __map_groups__fprintf_maps(struct map_groups *mg,
 	return printed;
 }
 
-size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp)
+static size_t map_groups__fprintf_maps(struct map_groups *mg, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_maps(mg, i, verbose, fp);
+		printed += __map_groups__fprintf_maps(mg, i, fp);
 	return printed;
 }
 
 static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
-						 enum map_type type,
-						 int verbose, FILE *fp)
+						 enum map_type type, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
@@ -600,23 +600,23 @@ static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
 }
 
 static size_t map_groups__fprintf_removed_maps(struct map_groups *mg,
-					       int verbose, FILE *fp)
+					       FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_removed_maps(mg, i, verbose, fp);
+		printed += __map_groups__fprintf_removed_maps(mg, i, fp);
 	return printed;
 }
 
-size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp)
+size_t map_groups__fprintf(struct map_groups *mg, FILE *fp)
 {
-	size_t printed = map_groups__fprintf_maps(mg, verbose, fp);
+	size_t printed = map_groups__fprintf_maps(mg, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + map_groups__fprintf_removed_maps(mg, verbose, fp);
+	return printed + map_groups__fprintf_removed_maps(mg, fp);
 }
 
 int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
-				   int verbose, FILE *fp)
+				   FILE *fp)
 {
 	struct rb_root *root = &mg->maps[map->type];
 	struct rb_node *next = rb_first(root);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 7758c72522ef..b57d49a6fef3 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -141,8 +141,8 @@ void map__fixup_end(struct map *map);
 
 void map__reloc_vmlinux(struct map *map);
 
-size_t __map_groups__fprintf_maps(struct map_groups *mg,
-				  enum map_type type, int verbose, FILE *fp);
+size_t __map_groups__fprintf_maps(struct map_groups *mg, enum map_type type,
+				  FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
 void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
@@ -152,8 +152,7 @@ void map_groups__init(struct map_groups *mg);
 void map_groups__exit(struct map_groups *mg);
 int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type);
-size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp);
-size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp);
+size_t map_groups__fprintf(struct map_groups *mg, FILE *fp);
 
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
 				     u64 addr);
@@ -210,7 +209,7 @@ struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 }
 
 int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
-				   int verbose, FILE *fp);
+				   FILE *fp);
 
 struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 2fde0d5e40b5..200f499293ca 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -127,12 +127,12 @@ int thread__comm_len(struct thread *thread)
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
 	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_str(thread)) +
-	       map_groups__fprintf(thread->mg, verbose, fp);
+	       map_groups__fprintf(thread->mg, fp);
 }
 
 void thread__insert_map(struct thread *thread, struct map *map)
 {
-	map_groups__fixup_overlappings(thread->mg, map, verbose, stderr);
+	map_groups__fixup_overlappings(thread->mg, map, stderr);
 	map_groups__insert(thread->mg, map);
 }
 
-- 
1.8.3.1

