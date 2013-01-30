Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3A3Or0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:47:26 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54435
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755408Ab3A3OrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/21] perf tools: Stop using 'self' in map.[ch]
Date: Wed, 30 Jan 2013 11:46:44 -0300
Message-Id: <1359557222-17547-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As suggested by tglx, 'self' should be replaced by something that is
more useful.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vse2c54m0yahx6p79tmoel03@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 118 +++++++++++++++++++++++++-------------------------
 tools/perf/util/map.h |  24 +++++-----
 2 files changed, 70 insertions(+), 72 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ff94425..b6b1636 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -29,29 +29,29 @@ static inline int is_no_dso_memory(const char *filename)
 	       !strcmp(filename, "[heap]");
 }
 
-void map__init(struct map *self, enum map_type type,
+void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso)
 {
-	self->type     = type;
-	self->start    = start;
-	self->end      = end;
-	self->pgoff    = pgoff;
-	self->dso      = dso;
-	self->map_ip   = map__map_ip;
-	self->unmap_ip = map__unmap_ip;
-	RB_CLEAR_NODE(&self->rb_node);
-	self->groups   = NULL;
-	self->referenced = false;
-	self->erange_warned = false;
+	map->type     = type;
+	map->start    = start;
+	map->end      = end;
+	map->pgoff    = pgoff;
+	map->dso      = dso;
+	map->map_ip   = map__map_ip;
+	map->unmap_ip = map__unmap_ip;
+	RB_CLEAR_NODE(&map->rb_node);
+	map->groups   = NULL;
+	map->referenced = false;
+	map->erange_warned = false;
 }
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, char *filename,
 		     enum map_type type)
 {
-	struct map *self = malloc(sizeof(*self));
+	struct map *map = malloc(sizeof(*map));
 
-	if (self != NULL) {
+	if (map != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
 		int anon, no_dso, vdso;
@@ -74,10 +74,10 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		if (dso == NULL)
 			goto out_delete;
 
-		map__init(self, type, start, start + len, pgoff, dso);
+		map__init(map, type, start, start + len, pgoff, dso);
 
 		if (anon || no_dso) {
-			self->map_ip = self->unmap_ip = identity__map_ip;
+			map->map_ip = map->unmap_ip = identity__map_ip;
 
 			/*
 			 * Set memory without DSO as loaded. All map__find_*
@@ -85,12 +85,12 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			 * unnecessary map__load warning.
 			 */
 			if (no_dso)
-				dso__set_loaded(dso, self->type);
+				dso__set_loaded(dso, map->type);
 		}
 	}
-	return self;
+	return map;
 out_delete:
-	free(self);
+	free(map);
 	return NULL;
 }
 
@@ -113,48 +113,48 @@ struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return map;
 }
 
-void map__delete(struct map *self)
+void map__delete(struct map *map)
 {
-	free(self);
+	free(map);
 }
 
-void map__fixup_start(struct map *self)
+void map__fixup_start(struct map *map)
 {
-	struct rb_root *symbols = &self->dso->symbols[self->type];
+	struct rb_root *symbols = &map->dso->symbols[map->type];
 	struct rb_node *nd = rb_first(symbols);
 	if (nd != NULL) {
 		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
-		self->start = sym->start;
+		map->start = sym->start;
 	}
 }
 
-void map__fixup_end(struct map *self)
+void map__fixup_end(struct map *map)
 {
-	struct rb_root *symbols = &self->dso->symbols[self->type];
+	struct rb_root *symbols = &map->dso->symbols[map->type];
 	struct rb_node *nd = rb_last(symbols);
 	if (nd != NULL) {
 		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
-		self->end = sym->end;
+		map->end = sym->end;
 	}
 }
 
 #define DSO__DELETED "(deleted)"
 
-int map__load(struct map *self, symbol_filter_t filter)
+int map__load(struct map *map, symbol_filter_t filter)
 {
-	const char *name = self->dso->long_name;
+	const char *name = map->dso->long_name;
 	int nr;
 
-	if (dso__loaded(self->dso, self->type))
+	if (dso__loaded(map->dso, map->type))
 		return 0;
 
-	nr = dso__load(self->dso, self, filter);
+	nr = dso__load(map->dso, map, filter);
 	if (nr < 0) {
-		if (self->dso->has_build_id) {
+		if (map->dso->has_build_id) {
 			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
-			build_id__sprintf(self->dso->build_id,
-					  sizeof(self->dso->build_id),
+			build_id__sprintf(map->dso->build_id,
+					  sizeof(map->dso->build_id),
 					  sbuild_id);
 			pr_warning("%s with build id %s not found",
 				   name, sbuild_id);
@@ -184,43 +184,41 @@ int map__load(struct map *self, symbol_filter_t filter)
 	 * Only applies to the kernel, as its symtabs aren't relative like the
 	 * module ones.
 	 */
-	if (self->dso->kernel)
-		map__reloc_vmlinux(self);
+	if (map->dso->kernel)
+		map__reloc_vmlinux(map);
 
 	return 0;
 }
 
-struct symbol *map__find_symbol(struct map *self, u64 addr,
+struct symbol *map__find_symbol(struct map *map, u64 addr,
 				symbol_filter_t filter)
 {
-	if (map__load(self, filter) < 0)
+	if (map__load(map, filter) < 0)
 		return NULL;
 
-	return dso__find_symbol(self->dso, self->type, addr);
+	return dso__find_symbol(map->dso, map->type, addr);
 }
 
-struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
 					symbol_filter_t filter)
 {
-	if (map__load(self, filter) < 0)
+	if (map__load(map, filter) < 0)
 		return NULL;
 
-	if (!dso__sorted_by_name(self->dso, self->type))
-		dso__sort_by_name(self->dso, self->type);
+	if (!dso__sorted_by_name(map->dso, map->type))
+		dso__sort_by_name(map->dso, map->type);
 
-	return dso__find_symbol_by_name(self->dso, self->type, name);
+	return dso__find_symbol_by_name(map->dso, map->type, name);
 }
 
-struct map *map__clone(struct map *self)
+struct map *map__clone(struct map *map)
 {
-	struct map *map = malloc(sizeof(*self));
+	struct map *clone = malloc(sizeof(*clone));
 
-	if (!map)
-		return NULL;
+	if (clone != NULL)
+		memcpy(clone, map, sizeof(*clone));
 
-	memcpy(map, self, sizeof(*self));
-
-	return map;
+	return clone;
 }
 
 int map__overlap(struct map *l, struct map *r)
@@ -237,10 +235,10 @@ int map__overlap(struct map *l, struct map *r)
 	return 0;
 }
 
-size_t map__fprintf(struct map *self, FILE *fp)
+size_t map__fprintf(struct map *map, FILE *fp)
 {
 	return fprintf(fp, " %" PRIx64 "-%" PRIx64 " %" PRIx64 " %s\n",
-		       self->start, self->end, self->pgoff, self->dso->name);
+		       map->start, map->end, map->pgoff, map->dso->name);
 }
 
 size_t map__fprintf_dsoname(struct map *map, FILE *fp)
@@ -528,9 +526,9 @@ static u64 map__reloc_unmap_ip(struct map *map, u64 ip)
 	return ip - (s64)map->pgoff;
 }
 
-void map__reloc_vmlinux(struct map *self)
+void map__reloc_vmlinux(struct map *map)
 {
-	struct kmap *kmap = map__kmap(self);
+	struct kmap *kmap = map__kmap(map);
 	s64 reloc;
 
 	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->unrelocated_addr)
@@ -542,9 +540,9 @@ void map__reloc_vmlinux(struct map *self)
 	if (!reloc)
 		return;
 
-	self->map_ip   = map__reloc_map_ip;
-	self->unmap_ip = map__reloc_unmap_ip;
-	self->pgoff    = reloc;
+	map->map_ip   = map__reloc_map_ip;
+	map->unmap_ip = map__reloc_unmap_ip;
+	map->pgoff    = reloc;
 }
 
 void maps__insert(struct rb_root *maps, struct map *map)
@@ -567,9 +565,9 @@ void maps__insert(struct rb_root *maps, struct map *map)
 	rb_insert_color(&map->rb_node, maps);
 }
 
-void maps__remove(struct rb_root *self, struct map *map)
+void maps__remove(struct rb_root *maps, struct map *map)
 {
-	rb_erase(&map->rb_node, self);
+	rb_erase(&map->rb_node, maps);
 }
 
 struct map *maps__find(struct rb_root *maps, u64 ip)
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index bcb39e2..a887f2c 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -57,9 +57,9 @@ struct map_groups {
 	struct machine	 *machine;
 };
 
-static inline struct kmap *map__kmap(struct map *self)
+static inline struct kmap *map__kmap(struct map *map)
 {
-	return (struct kmap *)(self + 1);
+	return (struct kmap *)(map + 1);
 }
 
 static inline u64 map__map_ip(struct map *map, u64 ip)
@@ -85,27 +85,27 @@ struct symbol;
 
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
-void map__init(struct map *self, enum map_type type,
+void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, char *filename,
 		     enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
-void map__delete(struct map *self);
-struct map *map__clone(struct map *self);
+void map__delete(struct map *map);
+struct map *map__clone(struct map *map);
 int map__overlap(struct map *l, struct map *r);
-size_t map__fprintf(struct map *self, FILE *fp);
+size_t map__fprintf(struct map *map, FILE *fp);
 size_t map__fprintf_dsoname(struct map *map, FILE *fp);
 
-int map__load(struct map *self, symbol_filter_t filter);
-struct symbol *map__find_symbol(struct map *self,
+int map__load(struct map *map, symbol_filter_t filter);
+struct symbol *map__find_symbol(struct map *map,
 				u64 addr, symbol_filter_t filter);
-struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+struct symbol *map__find_symbol_by_name(struct map *map, const char *name,
 					symbol_filter_t filter);
-void map__fixup_start(struct map *self);
-void map__fixup_end(struct map *self);
+void map__fixup_start(struct map *map);
+void map__fixup_end(struct map *map);
 
-void map__reloc_vmlinux(struct map *self);
+void map__reloc_vmlinux(struct map *map);
 
 size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp);
-- 
1.8.1.1.361.gec3ae6e

