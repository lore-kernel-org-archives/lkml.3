Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaIRNam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:30:42 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:48214 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaIRNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:30:37 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v3 2/2] perf tool: iterate DSOs with rbtree instead of list
Date: Thu, 18 Sep 2014 09:30:21 -0400
Message-Id: <1411047021-38823-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1411047021-38823-1-git-send-email-Waiman.Long@hp.com>
References: <1411047021-38823-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the iteration process for DSOs from using the
list_head to rbtree. As a result, the node field in the DSO structure
can be eliminated. The user_dsos and kernel_dsos fields of the machine
structure are now rb_root.

The changes in this patch are mainly in one of the following 4
categories:

 1) Change list_head to rb_root and list to root
 2) Change list_for_each_entry*() to
    rbtree_postorder_for_each_entry_safe() and add a temporary variable
    needed by the rbtree macro
 3) Initialize the modified fields accordingly
 4) Remove the global dso__root variable and use root to replace
    dso__root

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 tools/perf/util/dso.c         |   47 +++++++++++++++++-----------------------
 tools/perf/util/dso.h         |   23 ++++++++++++++------
 tools/perf/util/header.c      |   36 +++++++++++++++---------------
 tools/perf/util/machine.c     |   14 +++++-------
 tools/perf/util/machine.h     |    4 +-
 tools/perf/util/probe-event.c |    4 +-
 tools/perf/util/symbol-elf.c  |    2 +-
 7 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 6293f89..7597d88 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -652,11 +652,6 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 }
 
 /*
- * RB root of DSOs sorted by the long name
- */
-struct rb_root dso__root = { NULL };
-
-/*
  * Find a matching entry and/or link current entry to RB tree.
  * Either one of the dso or name parameter must be non-NULL or the
  * function will not work.
@@ -829,7 +824,6 @@ struct dso *dso__new(const char *name)
 		dso->needs_swap = DSO_SWAP__UNSET;
 		dso->rb_root = NULL;
 		RB_CLEAR_NODE(&dso->rb_node);
-		INIT_LIST_HEAD(&dso->node);
 		INIT_LIST_HEAD(&dso->data.open_entry);
 	}
 
@@ -907,12 +901,12 @@ int dso__kernel_module_get_build_id(struct dso *dso,
 	return 0;
 }
 
-bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
+bool __dsos__read_build_ids(struct rb_root *root, bool with_hits)
 {
 	bool have_build_id = false;
-	struct dso *pos;
+	struct dso *pos, *n;
 
-	list_for_each_entry(pos, head, node) {
+	dso__for_each_entry_safe(pos, n, root) {
 		if (with_hits && !pos->hit)
 			continue;
 		if (pos->has_build_id) {
@@ -929,34 +923,33 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
 	return have_build_id;
 }
 
-void dsos__add(struct list_head *head, struct dso *dso)
+void dsos__add(struct rb_root *root, struct dso *dso)
 {
-	list_add_tail(&dso->node, head);
-	dso__findlink_by_longname(&dso__root, dso, NULL);
-	dso->rb_root = &dso__root;
+	dso__findlink_by_longname(root, dso, NULL);
+	dso->rb_root = root;
 }
 
-struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_short)
+struct dso *dsos__find(const struct rb_root *root, const char *name, bool cmp_short)
 {
-	struct dso *pos;
-
 	if (cmp_short) {
-		list_for_each_entry(pos, head, node)
+		struct dso *pos, *n;
+
+		dso__for_each_entry_safe(pos, n, root)
 			if (strcmp(pos->short_name, name) == 0)
 				return pos;
 		return NULL;
 	}
-	return dso__find_by_longname(&dso__root, name);
+	return dso__find_by_longname((struct rb_root *)root, name);
 }
 
-struct dso *__dsos__findnew(struct list_head *head, const char *name)
+struct dso *__dsos__findnew(struct rb_root *root, const char *name)
 {
-	struct dso *dso = dsos__find(head, name, false);
+	struct dso *dso = dsos__find(root, name, false);
 
 	if (!dso) {
 		dso = dso__new(name);
 		if (dso != NULL) {
-			dsos__add(head, dso);
+			dsos__add(root, dso);
 			dso__set_basename(dso);
 		}
 	}
@@ -964,13 +957,13 @@ struct dso *__dsos__findnew(struct list_head *head, const char *name)
 	return dso;
 }
 
-size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
+size_t __dsos__fprintf_buildid(struct rb_root *root, FILE *fp,
 			       bool (skip)(struct dso *dso, int parm), int parm)
 {
-	struct dso *pos;
+	struct dso *pos, *n;
 	size_t ret = 0;
 
-	list_for_each_entry(pos, head, node) {
+	dso__for_each_entry_safe(pos, n, root) {
 		if (skip && skip(pos, parm))
 			continue;
 		ret += dso__fprintf_buildid(pos, fp);
@@ -979,12 +972,12 @@ size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
 	return ret;
 }
 
-size_t __dsos__fprintf(struct list_head *head, FILE *fp)
+size_t __dsos__fprintf(struct rb_root *root, FILE *fp)
 {
-	struct dso *pos;
+	struct dso *pos, *n;
 	size_t ret = 0;
 
-	list_for_each_entry(pos, head, node) {
+	dso__for_each_entry_safe(pos, n, root) {
 		int i;
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			ret += dso__fprintf(pos, i, fp);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 75cda1d..23fff82 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -91,7 +91,6 @@ struct dso_cache {
 };
 
 struct dso {
-	struct list_head node;
 	struct rb_node   rb_node;	/* rbtree sorted by long name */
 	struct rb_root   *rb_root;	/* pointer to rbtree root */
 	struct rb_root	 symbols[MAP__NR_TYPES];
@@ -143,6 +142,16 @@ struct dso {
 #define dso__for_each_symbol(dso, pos, n, type)	\
 	symbols__for_each_entry(&(dso)->symbols[(type)], pos, n)
 
+/*
+ * dso__for_each_entry_safe - iterate over all the dso entries in the rbtree
+ *
+ * @root: the rbtree root pointer
+ * @pos : the 'struct dso *' to use as a loop cursor
+ * @n   : the 'struct dso *' to use as a temporary storage
+ */
+#define dso__for_each_entry_safe(root, pos, n) \
+	rbtree_postorder_for_each_entry_safe(root, pos, n, rb_node)
+
 static inline void dso__set_loaded(struct dso *dso, enum map_type type)
 {
 	dso->loaded |= (1 << type);
@@ -226,15 +235,15 @@ struct map *dso__new_map(const char *name);
 struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 				const char *short_name, int dso_type);
 
-void dsos__add(struct list_head *head, struct dso *dso);
-struct dso *dsos__find(const struct list_head *head, const char *name,
+void dsos__add(struct rb_root *root, struct dso *dso);
+struct dso *dsos__find(const struct rb_root *root, const char *name,
 		       bool cmp_short);
-struct dso *__dsos__findnew(struct list_head *head, const char *name);
-bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
+struct dso *__dsos__findnew(struct rb_root *root, const char *name);
+bool __dsos__read_build_ids(struct rb_root *root, bool with_hits);
 
-size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
+size_t __dsos__fprintf_buildid(struct rb_root *root, FILE *fp,
 			       bool (skip)(struct dso *dso, int parm), int parm);
-size_t __dsos__fprintf(struct list_head *head, FILE *fp);
+size_t __dsos__fprintf(struct rb_root *root, FILE *fp);
 
 size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
 size_t dso__fprintf_symbols_by_name(struct dso *dso,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 158c787..636c183 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -171,10 +171,10 @@ perf_header__set_cmdline(int argc, const char **argv)
 	return 0;
 }
 
-#define dsos__for_each_with_build_id(pos, head)	\
-	list_for_each_entry(pos, head, node)	\
-		if (!pos->has_build_id)		\
-			continue;		\
+#define dsos__for_each_with_build_id(pos, n, root)	\
+	dso__for_each_entry_safe(pos, n, root)		\
+		if (!pos->has_build_id)			\
+			continue;			\
 		else
 
 static int write_buildid(const char *name, size_t name_len, u8 *build_id,
@@ -200,11 +200,11 @@ static int write_buildid(const char *name, size_t name_len, u8 *build_id,
 	return write_padded(fd, name, name_len + 1, len);
 }
 
-static int __dsos__hit_all(struct list_head *head)
+static int __dsos__hit_all(struct rb_root *root)
 {
-	struct dso *pos;
+	struct dso *pos, *n;
 
-	list_for_each_entry(pos, head, node)
+	dso__for_each_entry_safe(pos, n, root)
 		pos->hit = true;
 
 	return 0;
@@ -241,14 +241,14 @@ int dsos__hit_all(struct perf_session *session)
 	return 0;
 }
 
-static int __dsos__write_buildid_table(struct list_head *head,
+static int __dsos__write_buildid_table(struct rb_root *root,
 				       struct machine *machine,
 				       pid_t pid, u16 misc, int fd)
 {
 	char nm[PATH_MAX];
-	struct dso *pos;
+	struct dso *pos, *n;
 
-	dsos__for_each_with_build_id(pos, head) {
+	dsos__for_each_with_build_id(pos, n, root) {
 		int err;
 		const char *name;
 		size_t name_len;
@@ -440,13 +440,13 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 				     debugdir, is_kallsyms, is_vdso);
 }
 
-static int __dsos__cache_build_ids(struct list_head *head,
+static int __dsos__cache_build_ids(struct rb_root *root,
 				   struct machine *machine, const char *debugdir)
 {
-	struct dso *pos;
+	struct dso *pos, *n;
 	int err = 0;
 
-	dsos__for_each_with_build_id(pos, head)
+	dsos__for_each_with_build_id(pos, n, root)
 		if (dso__cache_build_id(pos, machine, debugdir))
 			err = -1;
 
@@ -1548,7 +1548,7 @@ static int __event_process_build_id(struct build_id_event *bev,
 				    struct perf_session *session)
 {
 	int err = -1;
-	struct list_head *head;
+	struct rb_root *root;
 	struct machine *machine;
 	u16 misc;
 	struct dso *dso;
@@ -1563,22 +1563,22 @@ static int __event_process_build_id(struct build_id_event *bev,
 	switch (misc) {
 	case PERF_RECORD_MISC_KERNEL:
 		dso_type = DSO_TYPE_KERNEL;
-		head = &machine->kernel_dsos;
+		root = &machine->kernel_dsos;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
 		dso_type = DSO_TYPE_GUEST_KERNEL;
-		head = &machine->kernel_dsos;
+		root = &machine->kernel_dsos;
 		break;
 	case PERF_RECORD_MISC_USER:
 	case PERF_RECORD_MISC_GUEST_USER:
 		dso_type = DSO_TYPE_USER;
-		head = &machine->user_dsos;
+		root = &machine->user_dsos;
 		break;
 	default:
 		goto out;
 	}
 
-	dso = __dsos__findnew(head, filename);
+	dso = __dsos__findnew(root, filename);
 	if (dso != NULL) {
 		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 16bba9f..317f50b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -17,8 +17,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
 	map_groups__init(&machine->kmaps);
 	RB_CLEAR_NODE(&machine->rb_node);
-	INIT_LIST_HEAD(&machine->user_dsos);
-	INIT_LIST_HEAD(&machine->kernel_dsos);
+	machine->user_dsos = RB_ROOT;
+	machine->kernel_dsos = RB_ROOT;
 
 	machine->threads = RB_ROOT;
 	INIT_LIST_HEAD(&machine->dead_threads);
@@ -70,14 +70,12 @@ out_delete:
 	return NULL;
 }
 
-static void dsos__delete(struct list_head *dsos)
+static void dsos__delete(struct rb_root *dsos)
 {
 	struct dso *pos, *n;
 
-	list_for_each_entry_safe(pos, n, dsos, node) {
-		list_del(&pos->node);
+	dso__for_each_entry_safe(pos, n, dsos)
 		dso__delete(pos);
-	}
 }
 
 void machine__delete_dead_threads(struct machine *machine)
@@ -963,9 +961,9 @@ static void machine__set_kernel_mmap_len(struct machine *machine,
 
 static bool machine__uses_kcore(struct machine *machine)
 {
-	struct dso *dso;
+	struct dso *dso, *n;
 
-	list_for_each_entry(dso, &machine->kernel_dsos, node) {
+	dso__for_each_entry_safe(dso, n, &machine->kernel_dsos) {
 		if (dso__is_kcore(dso))
 			return true;
 	}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index b972824..c75ce9e 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -31,8 +31,8 @@ struct machine {
 	struct list_head  dead_threads;
 	struct thread	  *last_match;
 	struct vdso_info  *vdso_info;
-	struct list_head  user_dsos;
-	struct list_head  kernel_dsos;
+	struct rb_root	  user_dsos;
+	struct rb_root	  kernel_dsos;
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
 	symbol_filter_t	  symbol_filter;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9a0a183..b093d25 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -179,12 +179,12 @@ static struct map *kernel_get_module_map(const char *module)
 
 static struct dso *kernel_get_module_dso(const char *module)
 {
-	struct dso *dso;
+	struct dso *dso, *n;
 	struct map *map;
 	const char *vmlinux_name;
 
 	if (module) {
-		list_for_each_entry(dso, &host_machine->kernel_dsos, node) {
+		dso__for_each_entry_safe(dso, n, &host_machine->kernel_dsos) {
 			if (strncmp(dso->short_name + 1, module,
 				    dso->short_name_len - 2) == 0)
 				goto found;
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index d753499..97b0d18 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -916,7 +916,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 				}
 				curr_dso->symtab_type = dso->symtab_type;
 				map_groups__insert(kmap->kmaps, curr_map);
-				dsos__add(&dso->node, curr_dso);
+				dsos__add(dso->rb_root, curr_dso);
 				dso__set_loaded(curr_dso, map->type);
 			} else
 				curr_dso = curr_map->dso;
-- 
1.7.1

