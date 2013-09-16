Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3IPKqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:46:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:47741 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab3IPKqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:46:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,914,1371106800"; 
   d="scan'208";a="361036329"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/11] perf tools: validate kcore module addresses
Date: Mon, 16 Sep 2013 13:52:45 +0300
Message-Id: <1379328772-21214-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379328772-21214-1-git-send-email-adrian.hunter@intel.com>
References: <1379328772-21214-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before using kcore we need to check that modules are
in memory at the same addresses that they were when
data was recorded.

This is done because, while we could remap symbols
to different addresses, the object code linkages
would still be different which would provide an
erroneous view of the object code.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 194 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 173 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1926292..eb9bd45 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -797,51 +797,199 @@ bool symbol__restricted_filename(const char *filename,
 	return restricted;
 }
 
-struct kcore_mapfn_data {
-	struct dso *dso;
-	enum map_type type;
-	struct list_head maps;
+struct module_info {
+	struct rb_node rb_node;
+	char *name;
+	u64 start;
 };
 
-static int kcore_mapfn(u64 start, u64 len, u64 pgoff, void *data)
+static void add_module(struct module_info *mi, struct rb_root *modules)
 {
-	struct kcore_mapfn_data *md = data;
-	struct map *map;
+	struct rb_node **p = &modules->rb_node;
+	struct rb_node *parent = NULL;
+	struct module_info *m;
 
-	map = map__new2(start, md->dso, md->type);
-	if (map == NULL)
+	while (*p != NULL) {
+		parent = *p;
+		m = rb_entry(parent, struct module_info, rb_node);
+		if (strcmp(mi->name, m->name) < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&mi->rb_node, parent, p);
+	rb_insert_color(&mi->rb_node, modules);
+}
+
+static void delete_modules(struct rb_root *modules)
+{
+	struct module_info *mi;
+	struct rb_node *next = rb_first(modules);
+
+	while (next) {
+		mi = rb_entry(next, struct module_info, rb_node);
+		next = rb_next(&mi->rb_node);
+		rb_erase(&mi->rb_node, modules);
+		free(mi->name);
+		free(mi);
+	}
+}
+
+static struct module_info *find_module(const char *name,
+				       struct rb_root *modules)
+{
+	struct rb_node *n = modules->rb_node;
+
+	while (n) {
+		struct module_info *m;
+		int cmp;
+
+		m = rb_entry(n, struct module_info, rb_node);
+		cmp = strcmp(name, m->name);
+		if (cmp < 0)
+			n = n->rb_left;
+		else if (cmp > 0)
+			n = n->rb_right;
+		else
+			return m;
+	}
+
+	return NULL;
+}
+
+static int __read_proc_modules(void *arg, const char *name, u64 start)
+{
+	struct rb_root *modules = arg;
+	struct module_info *mi;
+
+	mi = zalloc(sizeof(struct module_info));
+	if (!mi)
 		return -ENOMEM;
 
-	map->end = map->start + len;
-	map->pgoff = pgoff;
+	mi->name = strdup(name);
+	mi->start = start;
 
-	list_add(&map->node, &md->maps);
+	add_module(mi, modules);
+
+	if (!mi->name)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int read_proc_modules(const char *filename, struct rb_root *modules)
+{
+	if (symbol__restricted_filename(filename, "/proc/modules"))
+		return -1;
+
+	if (modules__parse(filename, modules, __read_proc_modules)) {
+		delete_modules(modules);
+		return -1;
+	}
 
 	return 0;
 }
 
+static int do_validate_kcore_modules(const char *filename, struct map *map,
+				  struct map_groups *kmaps)
+{
+	struct rb_root modules = RB_ROOT;
+	struct map *old_map;
+	int err;
+
+	err = read_proc_modules(filename, &modules);
+	if (err)
+		return err;
+
+	old_map = map_groups__first(kmaps, map->type);
+	while (old_map) {
+		struct map *next = map_groups__next(old_map);
+		struct module_info *mi;
+
+		if (old_map == map || old_map->start == map->start) {
+			/* The kernel map */
+			old_map = next;
+			continue;
+		}
+
+		/* Module must be in memory at the same address */
+		mi = find_module(old_map->dso->short_name, &modules);
+		if (!mi || mi->start != old_map->start) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		old_map = next;
+	}
+out:
+	delete_modules(&modules);
+	return err;
+}
+
 /*
- * If kallsyms is referenced by name then we look for kcore in the same
+ * If kallsyms is referenced by name then we look for filename in the same
  * directory.
  */
-static bool kcore_filename_from_kallsyms_filename(char *kcore_filename,
-						  const char *kallsyms_filename)
+static bool filename_from_kallsyms_filename(char *filename,
+					    const char *basename,
+					    const char *kallsyms_filename)
 {
 	char *name;
 
-	strcpy(kcore_filename, kallsyms_filename);
-	name = strrchr(kcore_filename, '/');
+	strcpy(filename, kallsyms_filename);
+	name = strrchr(filename, '/');
 	if (!name)
 		return false;
 
-	if (!strcmp(name, "/kallsyms")) {
-		strcpy(name, "/kcore");
+	name += 1;
+
+	if (!strcmp(name, "kallsyms")) {
+		strcpy(name, basename);
 		return true;
 	}
 
 	return false;
 }
 
+static int validate_kcore_modules(const char *kallsyms_filename,
+				  struct map *map)
+{
+	struct map_groups *kmaps = map__kmap(map)->kmaps;
+	char modules_filename[PATH_MAX];
+
+	if (!filename_from_kallsyms_filename(modules_filename, "modules",
+					     kallsyms_filename))
+		return -EINVAL;
+
+	if (do_validate_kcore_modules(modules_filename, map, kmaps))
+		return -EINVAL;
+
+	return 0;
+}
+
+struct kcore_mapfn_data {
+	struct dso *dso;
+	enum map_type type;
+	struct list_head maps;
+};
+
+static int kcore_mapfn(u64 start, u64 len, u64 pgoff, void *data)
+{
+	struct kcore_mapfn_data *md = data;
+	struct map *map;
+
+	map = map__new2(start, md->dso, md->type);
+	if (map == NULL)
+		return -ENOMEM;
+
+	map->end = map->start + len;
+	map->pgoff = pgoff;
+
+	list_add(&map->node, &md->maps);
+
+	return 0;
+}
+
 static int dso__load_kcore(struct dso *dso, struct map *map,
 			   const char *kallsyms_filename)
 {
@@ -858,8 +1006,12 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 	if (map != machine->vmlinux_maps[map->type])
 		return -EINVAL;
 
-	if (!kcore_filename_from_kallsyms_filename(kcore_filename,
-						   kallsyms_filename))
+	if (!filename_from_kallsyms_filename(kcore_filename, "kcore",
+					     kallsyms_filename))
+		return -EINVAL;
+
+	/* All modules must be present at their original addresses */
+	if (validate_kcore_modules(kallsyms_filename, map))
 		return -EINVAL;
 
 	md.dso = dso;
-- 
1.7.11.7

