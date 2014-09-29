Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaI2UHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:07:44 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:42810 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaI2UHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:07:40 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v5 1/2] perf tool: encapsulate dsos list head into struct dsos
Date: Mon, 29 Sep 2014 16:07:28 -0400
Message-Id: <1412021249-19201-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1412021249-19201-1-git-send-email-Waiman.Long@hp.com>
References: <1412021249-19201-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a precursor patch to enable long name searching of DSOs
using the rbtree. In this patch, a new dsos structure is created
which contains only a list head structure for the moment. The new
dsos structure is used, in turn, in the machine structure for the
user_dsos and kernel_dsos fields. Only the following 3 dsos functions
are modified to accept the new dsos structure parameter instead
of list_head:
 - dsos__add()
 - dsos__find()
 - __dsos__findnew()

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 tools/perf/util/dso.c         |   17 +++++++++--------
 tools/perf/util/dso.h         |    8 +++++---
 tools/perf/util/header.c      |   32 ++++++++++++++++++--------------
 tools/perf/util/machine.c     |   24 ++++++++++++------------
 tools/perf/util/machine.h     |   11 +++++++++--
 tools/perf/util/probe-event.c |    3 ++-
 tools/perf/util/symbol-elf.c  |    7 ++++++-
 7 files changed, 61 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 55e39dc..901a58f 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -851,35 +851,36 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
 	return have_build_id;
 }
 
-void dsos__add(struct list_head *head, struct dso *dso)
+void dsos__add(struct dsos *dsos, struct dso *dso)
 {
-	list_add_tail(&dso->node, head);
+	list_add_tail(&dso->node, &dsos->head);
 }
 
-struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_short)
+struct dso *dsos__find(const struct dsos *dsos, const char *name,
+		       bool cmp_short)
 {
 	struct dso *pos;
 
 	if (cmp_short) {
-		list_for_each_entry(pos, head, node)
+		list_for_each_entry(pos, &dsos->head, node)
 			if (strcmp(pos->short_name, name) == 0)
 				return pos;
 		return NULL;
 	}
-	list_for_each_entry(pos, head, node)
+	list_for_each_entry(pos, &dsos->head, node)
 		if (strcmp(pos->long_name, name) == 0)
 			return pos;
 	return NULL;
 }
 
-struct dso *__dsos__findnew(struct list_head *head, const char *name)
+struct dso *__dsos__findnew(struct dsos *dsos, const char *name)
 {
-	struct dso *dso = dsos__find(head, name, false);
+	struct dso *dso = dsos__find(dsos, name, false);
 
 	if (!dso) {
 		dso = dso__new(name);
 		if (dso != NULL) {
-			dsos__add(head, dso);
+			dsos__add(dsos, dso);
 			dso__set_basename(dso);
 		}
 	}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 5e463c0..91eec17 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -90,6 +90,8 @@ struct dso_cache {
 	char data[0];
 };
 
+struct dsos;
+
 struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
@@ -224,10 +226,10 @@ struct map *dso__new_map(const char *name);
 struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 				const char *short_name, int dso_type);
 
-void dsos__add(struct list_head *head, struct dso *dso);
-struct dso *dsos__find(const struct list_head *head, const char *name,
+void dsos__add(struct dsos *dsos, struct dso *dso);
+struct dso *dsos__find(const struct dsos *dsos, const char *name,
 		       bool cmp_short);
-struct dso *__dsos__findnew(struct list_head *head, const char *name);
+struct dso *__dsos__findnew(struct dsos *dsos, const char *name);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 
 size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 158c787..ce0de00 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -214,11 +214,11 @@ static int machine__hit_all_dsos(struct machine *machine)
 {
 	int err;
 
-	err = __dsos__hit_all(&machine->kernel_dsos);
+	err = __dsos__hit_all(&machine->kernel_dsos.head);
 	if (err)
 		return err;
 
-	return __dsos__hit_all(&machine->user_dsos);
+	return __dsos__hit_all(&machine->user_dsos.head);
 }
 
 int dsos__hit_all(struct perf_session *session)
@@ -288,11 +288,12 @@ static int machine__write_buildid_table(struct machine *machine, int fd)
 		umisc = PERF_RECORD_MISC_GUEST_USER;
 	}
 
-	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine,
+	err = __dsos__write_buildid_table(&machine->kernel_dsos.head, machine,
 					  machine->pid, kmisc, fd);
 	if (err == 0)
-		err = __dsos__write_buildid_table(&machine->user_dsos, machine,
-						  machine->pid, umisc, fd);
+		err = __dsos__write_buildid_table(&machine->user_dsos.head,
+						  machine, machine->pid, umisc,
+						  fd);
 	return err;
 }
 
@@ -455,9 +456,10 @@ static int __dsos__cache_build_ids(struct list_head *head,
 
 static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
 {
-	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, machine,
+	int ret = __dsos__cache_build_ids(&machine->kernel_dsos.head, machine,
 					  debugdir);
-	ret |= __dsos__cache_build_ids(&machine->user_dsos, machine, debugdir);
+	ret |= __dsos__cache_build_ids(&machine->user_dsos.head, machine,
+				       debugdir);
 	return ret;
 }
 
@@ -483,8 +485,10 @@ static int perf_session__cache_build_ids(struct perf_session *session)
 
 static bool machine__read_build_ids(struct machine *machine, bool with_hits)
 {
-	bool ret = __dsos__read_build_ids(&machine->kernel_dsos, with_hits);
-	ret |= __dsos__read_build_ids(&machine->user_dsos, with_hits);
+	bool ret;
+
+	ret  = __dsos__read_build_ids(&machine->kernel_dsos.head, with_hits);
+	ret |= __dsos__read_build_ids(&machine->user_dsos.head, with_hits);
 	return ret;
 }
 
@@ -1548,7 +1552,7 @@ static int __event_process_build_id(struct build_id_event *bev,
 				    struct perf_session *session)
 {
 	int err = -1;
-	struct list_head *head;
+	struct dsos *dsos;
 	struct machine *machine;
 	u16 misc;
 	struct dso *dso;
@@ -1563,22 +1567,22 @@ static int __event_process_build_id(struct build_id_event *bev,
 	switch (misc) {
 	case PERF_RECORD_MISC_KERNEL:
 		dso_type = DSO_TYPE_KERNEL;
-		head = &machine->kernel_dsos;
+		dsos = &machine->kernel_dsos;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
 		dso_type = DSO_TYPE_GUEST_KERNEL;
-		head = &machine->kernel_dsos;
+		dsos = &machine->kernel_dsos;
 		break;
 	case PERF_RECORD_MISC_USER:
 	case PERF_RECORD_MISC_GUEST_USER:
 		dso_type = DSO_TYPE_USER;
-		head = &machine->user_dsos;
+		dsos = &machine->user_dsos;
 		break;
 	default:
 		goto out;
 	}
 
-	dso = __dsos__findnew(head, filename);
+	dso = __dsos__findnew(dsos, filename);
 	if (dso != NULL) {
 		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ec38b..49a75ec 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -17,8 +17,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
 	map_groups__init(&machine->kmaps);
 	RB_CLEAR_NODE(&machine->rb_node);
-	INIT_LIST_HEAD(&machine->user_dsos);
-	INIT_LIST_HEAD(&machine->kernel_dsos);
+	INIT_LIST_HEAD(&machine->user_dsos.head);
+	INIT_LIST_HEAD(&machine->kernel_dsos.head);
 
 	machine->threads = RB_ROOT;
 	INIT_LIST_HEAD(&machine->dead_threads);
@@ -72,11 +72,11 @@ out_delete:
 	return NULL;
 }
 
-static void dsos__delete(struct list_head *dsos)
+static void dsos__delete(struct dsos *dsos)
 {
 	struct dso *pos, *n;
 
-	list_for_each_entry_safe(pos, n, dsos, node) {
+	list_for_each_entry_safe(pos, n, &dsos->head, node) {
 		list_del(&pos->node);
 		dso__delete(pos);
 	}
@@ -477,23 +477,23 @@ struct map *machine__new_module(struct machine *machine, u64 start,
 size_t machines__fprintf_dsos(struct machines *machines, FILE *fp)
 {
 	struct rb_node *nd;
-	size_t ret = __dsos__fprintf(&machines->host.kernel_dsos, fp) +
-		     __dsos__fprintf(&machines->host.user_dsos, fp);
+	size_t ret = __dsos__fprintf(&machines->host.kernel_dsos.head, fp) +
+		     __dsos__fprintf(&machines->host.user_dsos.head, fp);
 
 	for (nd = rb_first(&machines->guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
-		ret += __dsos__fprintf(&pos->user_dsos, fp);
+		ret += __dsos__fprintf(&pos->kernel_dsos.head, fp);
+		ret += __dsos__fprintf(&pos->user_dsos.head, fp);
 	}
 
 	return ret;
 }
 
-size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
+size_t machine__fprintf_dsos_buildid(struct machine *m, FILE *fp,
 				     bool (skip)(struct dso *dso, int parm), int parm)
 {
-	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, skip, parm) +
-	       __dsos__fprintf_buildid(&machine->user_dsos, fp, skip, parm);
+	return __dsos__fprintf_buildid(&m->kernel_dsos.head, fp, skip, parm) +
+	       __dsos__fprintf_buildid(&m->user_dsos.head, fp, skip, parm);
 }
 
 size_t machines__fprintf_dsos_buildid(struct machines *machines, FILE *fp,
@@ -994,7 +994,7 @@ static bool machine__uses_kcore(struct machine *machine)
 {
 	struct dso *dso;
 
-	list_for_each_entry(dso, &machine->kernel_dsos, node) {
+	list_for_each_entry(dso, &machine->kernel_dsos.head, node) {
 		if (dso__is_kcore(dso))
 			return true;
 	}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 6a6bcc1..37b3487 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -22,6 +22,13 @@ extern const char *ref_reloc_sym_names[];
 
 struct vdso_info;
 
+/*
+ * DSOs are put into a list for fast iteration.
+ */
+struct dsos {
+	struct list_head head;
+};
+
 struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
@@ -32,8 +39,8 @@ struct machine {
 	struct list_head  dead_threads;
 	struct thread	  *last_match;
 	struct vdso_info  *vdso_info;
-	struct list_head  user_dsos;
-	struct list_head  kernel_dsos;
+	struct dsos	  user_dsos;
+	struct dsos	  kernel_dsos;
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
 	u64		  kernel_start;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index be37b5a..c150ca4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -184,7 +184,8 @@ static struct dso *kernel_get_module_dso(const char *module)
 	const char *vmlinux_name;
 
 	if (module) {
-		list_for_each_entry(dso, &host_machine->kernel_dsos, node) {
+		list_for_each_entry(dso, &host_machine->kernel_dsos.head,
+				    node) {
 			if (strncmp(dso->short_name + 1, module,
 				    dso->short_name_len - 2) == 0)
 				goto found;
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 2a92e10..1e23a5b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -6,6 +6,7 @@
 #include <inttypes.h>
 
 #include "symbol.h"
+#include "machine.h"
 #include "vdso.h"
 #include <symbol/kallsyms.h>
 #include "debug.h"
@@ -929,7 +930,11 @@ int dso__load_sym(struct dso *dso, struct map *map,
 				}
 				curr_dso->symtab_type = dso->symtab_type;
 				map_groups__insert(kmap->kmaps, curr_map);
-				dsos__add(&dso->node, curr_dso);
+				/*
+				 * The new DSO should go to the kernel DSOS
+				 */
+				dsos__add(&map->groups->machine->kernel_dsos,
+					  curr_dso);
 				dso__set_loaded(curr_dso, map->type);
 			} else
 				curr_dso = curr_map->dso;
-- 
1.7.1

