Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbbANLSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:18:25 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64327 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbbANLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:18:23 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 2/4] perf tools: Add link argument to dso__find_symbol_by_name()
Date: Wed, 14 Jan 2015 20:18:06 +0900
Message-Id: <1421234288-22758-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a dso contains multiple symbols which have same name, current
dso__find_symbol_by_name() only finds an one of them and there's no way
to get the all symbols without going through the rbtree.

So add the new link argument to dso__find_symbol_by_name() to remember
current symbol position and returns next symbol if it provided.  For the
first call the link should be NULL and the returned symbol should be
used as link to the next call.  It will return NULL if there's no symbol
that has given name anymore.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/map.c |  2 +-
 tools/perf/util/map.c        |  7 ++++---
 tools/perf/util/map.h        |  3 ++-
 tools/perf/util/symbol.c     | 41 ++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/symbol.h     |  2 +-
 5 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index b11639f33682..577c1c249abc 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -55,7 +55,7 @@ static int map_browser__search(struct map_browser *browser)
 		u64 addr = strtoull(target, NULL, 16);
 		sym = map__find_symbol(browser->map, addr, NULL);
 	} else
-		sym = map__find_symbol_by_name(browser->map, target, NULL);
+		sym = map__find_symbol_by_name(browser->map, target, NULL, NULL);
 
 	if (sym != NULL) {
 		u32 *idx = symbol__browser_index(sym);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 62ca9f2607d5..8c49aa69f6de 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -302,7 +302,8 @@ struct symbol *map__find_symbol(struct map *map, u64 addr,
 }
 
 struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
-					symbol_filter_t filter)
+					symbol_filter_t filter,
+					struct symbol *link)
 {
 	if (map__load(map, filter) < 0)
 		return NULL;
@@ -310,7 +311,7 @@ struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
 	if (!dso__sorted_by_name(map->dso, map->type))
 		dso__sort_by_name(map->dso, map->type);
 
-	return dso__find_symbol_by_name(map->dso, map->type, name);
+	return dso__find_symbol_by_name(map->dso, map->type, name, link);
 }
 
 struct map *map__clone(struct map *map)
@@ -542,7 +543,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 
 	for (nd = rb_first(&mg->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
-		struct symbol *sym = map__find_symbol_by_name(pos, name, filter);
+		struct symbol *sym = map__find_symbol_by_name(pos, name, filter, NULL);
 
 		if (sym == NULL)
 			continue;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 6951a9d42339..1e8e5a4dd080 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -137,7 +137,8 @@ int map__load(struct map *map, symbol_filter_t filter);
 struct symbol *map__find_symbol(struct map *map,
 				u64 addr, symbol_filter_t filter);
 struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
-					symbol_filter_t filter);
+					symbol_filter_t filter,
+					struct symbol *link);
 void map__fixup_start(struct map *map);
 void map__fixup_end(struct map *map);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c24c5b83156c..2d546f7ce84e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -396,6 +396,7 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 					    const char *name)
 {
 	struct rb_node *n;
+	struct symbol_name_rb_node *s;
 
 	if (symbols == NULL)
 		return NULL;
@@ -403,7 +404,6 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 	n = symbols->rb_node;
 
 	while (n) {
-		struct symbol_name_rb_node *s;
 		int cmp;
 
 		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
@@ -414,10 +414,24 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 		else if (cmp > 0)
 			n = n->rb_right;
 		else
-			return &s->sym;
+			break;
 	}
 
-	return NULL;
+	if (n == NULL)
+		return NULL;
+
+	/* return first symbol that has same name (if any) */
+	for (n = rb_prev(n); n; n = rb_prev(n)) {
+		struct symbol_name_rb_node *tmp;
+
+		tmp = rb_entry(n, struct symbol_name_rb_node, rb_node);
+		if (strcmp(tmp->sym.name, s->sym.name))
+			break;
+
+		s = tmp;
+	}
+
+	return &s->sym;
 }
 
 struct symbol *dso__find_symbol(struct dso *dso,
@@ -436,10 +450,27 @@ struct symbol *dso__next_symbol(struct symbol *sym)
 	return symbols__next(sym);
 }
 
+/*
+ * When @link is NULL, returns first symbol that matched with @name.
+ * Otherwise, returns next symbol after @link in case some (local) symbols
+ * have same name, or NULL.
+ */
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
-					const char *name)
+					const char *name, struct symbol *link)
 {
-	return symbols__find_by_name(&dso->symbol_names[type], name);
+	struct rb_node *n;
+	struct symbol_name_rb_node *s;
+
+	if (link == NULL)
+		return symbols__find_by_name(&dso->symbol_names[type], name);
+
+	s = container_of(link, struct symbol_name_rb_node, sym);
+	n = rb_prev(&s->rb_node);
+	if (n == NULL)
+		return NULL;
+
+	s = rb_entry(n, struct symbol_name_rb_node, rb_node);
+	return strcmp(s->sym.name, name) ? NULL : &s->sym;
 }
 
 void dso__sort_by_name(struct dso *dso, enum map_type type)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 9d602e9c6f59..895de3587b61 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -230,7 +230,7 @@ int dso__load_kallsyms(struct dso *dso, const char *filename, struct map *map,
 struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
-					const char *name);
+					const char *name, struct symbol *link);
 
 struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 struct symbol *dso__next_symbol(struct symbol *sym);
-- 
2.2.1

