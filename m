Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3HLKW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:22:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48022 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3HLKWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:21 -0400
Date: Mon, 12 Aug 2013 03:21:32 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-8e0cf965f95edd41df11cca50b92b4cb6ea8d80a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375875537-4509-8-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Add support for reading from /proc/
 kcore
Git-Commit-ID: 8e0cf965f95edd41df11cca50b92b4cb6ea8d80a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:21:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e0cf965f95edd41df11cca50b92b4cb6ea8d80a
Gitweb:     http://git.kernel.org/tip/8e0cf965f95edd41df11cca50b92b4cb6ea8d80a
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:51 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:33 -0300

perf symbols: Add support for reading from /proc/kcore

In the absence of vmlinux, perf tools uses kallsyms for symbols.  If the
user has access, now also map to /proc/kcore.

The dso data_type is now set to either DSO_BINARY_TYPE__KCORE or
DSO_BINARY_TYPE__GUEST_KCORE as approprite.

This patch breaks the "vmlinux symtab matches kallsyms" test.  That is
fixed in a following patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c            |   5 +
 tools/perf/util/dso.h            |   8 ++
 tools/perf/util/machine.c        |  16 +++
 tools/perf/util/map.c            |  18 ++++
 tools/perf/util/map.h            |  13 +++
 tools/perf/util/symbol-elf.c     |  51 +++++++++
 tools/perf/util/symbol-minimal.c |   7 ++
 tools/perf/util/symbol.c         | 227 ++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/symbol.h         |   5 +
 9 files changed, 347 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 1955804..e3c1ff8 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -95,6 +95,11 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 			 dso->long_name);
 		break;
 
+	case DSO_BINARY_TYPE__KCORE:
+	case DSO_BINARY_TYPE__GUEST_KCORE:
+		snprintf(file, size, "%s", dso->long_name);
+		break;
+
 	default:
 	case DSO_BINARY_TYPE__KALLSYMS:
 	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 735a837..b793053 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -21,6 +21,8 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__KCORE,
+	DSO_BINARY_TYPE__GUEST_KCORE,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
@@ -155,4 +157,10 @@ static inline bool dso__is_vmlinux(struct dso *dso)
 	       dso->data_type == DSO_BINARY_TYPE__GUEST_VMLINUX;
 }
 
+static inline bool dso__is_kcore(struct dso *dso)
+{
+	return dso->data_type == DSO_BINARY_TYPE__KCORE ||
+	       dso->data_type == DSO_BINARY_TYPE__GUEST_KCORE;
+}
+
 #endif /* __PERF_DSO */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index dc35dcf..ef3b49c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -856,6 +856,18 @@ static void machine__set_kernel_mmap_len(struct machine *machine,
 	}
 }
 
+static bool machine__uses_kcore(struct machine *machine)
+{
+	struct dso *dso;
+
+	list_for_each_entry(dso, &machine->kernel_dsos, node) {
+		if (dso__is_kcore(dso))
+			return true;
+	}
+
+	return false;
+}
+
 static int machine__process_kernel_mmap_event(struct machine *machine,
 					      union perf_event *event)
 {
@@ -864,6 +876,10 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 	enum dso_kernel_type kernel_type;
 	bool is_kernel_mmap;
 
+	/* If we have maps from kcore then we do not need or want any others */
+	if (machine__uses_kcore(machine))
+		return 0;
+
 	machine__mmap_name(machine, kmmap_prefix, sizeof(kmmap_prefix));
 	if (machine__is_host(machine))
 		kernel_type = DSO_TYPE_KERNEL;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 4d599fe..9e8304c 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -555,3 +555,21 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 
 	return NULL;
 }
+
+struct map *maps__first(struct rb_root *maps)
+{
+	struct rb_node *first = rb_first(maps);
+
+	if (first)
+		return rb_entry(first, struct map, rb_node);
+	return NULL;
+}
+
+struct map *maps__next(struct map *map)
+{
+	struct rb_node *next = rb_next(&map->rb_node);
+
+	if (next)
+		return rb_entry(next, struct map, rb_node);
+	return NULL;
+}
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index a887f2c..2cc93cb 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -112,6 +112,8 @@ size_t __map_groups__fprintf_maps(struct map_groups *mg,
 void maps__insert(struct rb_root *maps, struct map *map);
 void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
+struct map *maps__first(struct rb_root *maps);
+struct map *maps__next(struct map *map);
 void map_groups__init(struct map_groups *mg);
 void map_groups__exit(struct map_groups *mg);
 int map_groups__clone(struct map_groups *mg,
@@ -139,6 +141,17 @@ static inline struct map *map_groups__find(struct map_groups *mg,
 	return maps__find(&mg->maps[type], addr);
 }
 
+static inline struct map *map_groups__first(struct map_groups *mg,
+					    enum map_type type)
+{
+	return maps__first(&mg->maps[type]);
+}
+
+static inline struct map *map_groups__next(struct map *map)
+{
+	return maps__next(map);
+}
+
 struct symbol *map_groups__find_symbol(struct map_groups *mg,
 				       enum map_type type, u64 addr,
 				       struct map **mapp,
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3eaa7b4..a7b9ab5 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -951,6 +951,57 @@ out_elf_end:
 	return err;
 }
 
+static int elf_read_maps(Elf *elf, bool exe, mapfn_t mapfn, void *data)
+{
+	GElf_Phdr phdr;
+	size_t i, phdrnum;
+	int err;
+	u64 sz;
+
+	if (elf_getphdrnum(elf, &phdrnum))
+		return -1;
+
+	for (i = 0; i < phdrnum; i++) {
+		if (gelf_getphdr(elf, i, &phdr) == NULL)
+			return -1;
+		if (phdr.p_type != PT_LOAD)
+			continue;
+		if (exe) {
+			if (!(phdr.p_flags & PF_X))
+				continue;
+		} else {
+			if (!(phdr.p_flags & PF_R))
+				continue;
+		}
+		sz = min(phdr.p_memsz, phdr.p_filesz);
+		if (!sz)
+			continue;
+		err = mapfn(phdr.p_vaddr, sz, phdr.p_offset, data);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int file__read_maps(int fd, bool exe, mapfn_t mapfn, void *data,
+		    bool *is_64_bit)
+{
+	int err;
+	Elf *elf;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		return -1;
+
+	if (is_64_bit)
+		*is_64_bit = (gelf_getclass(elf) == ELFCLASS64);
+
+	err = elf_read_maps(elf, exe, mapfn, data);
+
+	elf_end(elf);
+	return err;
+}
+
 void symbol__elf_init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index a7390cd..3a802c3 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -301,6 +301,13 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 	return 0;
 }
 
+int file__read_maps(int fd __maybe_unused, bool exe __maybe_unused,
+		    mapfn_t mapfn __maybe_unused, void *data __maybe_unused,
+		    bool *is_64_bit __maybe_unused)
+{
+	return -1;
+}
+
 void symbol__elf_init(void)
 {
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b9056a8..77f3b95 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -327,6 +327,16 @@ static struct symbol *symbols__find(struct rb_root *symbols, u64 ip)
 	return NULL;
 }
 
+static struct symbol *symbols__first(struct rb_root *symbols)
+{
+	struct rb_node *n = rb_first(symbols);
+
+	if (n)
+		return rb_entry(n, struct symbol, rb_node);
+
+	return NULL;
+}
+
 struct symbol_name_rb_node {
 	struct rb_node	rb_node;
 	struct symbol	sym;
@@ -397,6 +407,11 @@ struct symbol *dso__find_symbol(struct dso *dso,
 	return symbols__find(&dso->symbols[type], addr);
 }
 
+struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
+{
+	return symbols__first(&dso->symbols[type]);
+}
+
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name)
 {
@@ -533,6 +548,53 @@ static int dso__load_all_kallsyms(struct dso *dso, const char *filename,
 	return kallsyms__parse(filename, &args, map__process_kallsym_symbol);
 }
 
+static int dso__split_kallsyms_for_kcore(struct dso *dso, struct map *map,
+					 symbol_filter_t filter)
+{
+	struct map_groups *kmaps = map__kmap(map)->kmaps;
+	struct map *curr_map;
+	struct symbol *pos;
+	int count = 0, moved = 0;
+	struct rb_root *root = &dso->symbols[map->type];
+	struct rb_node *next = rb_first(root);
+
+	while (next) {
+		char *module;
+
+		pos = rb_entry(next, struct symbol, rb_node);
+		next = rb_next(&pos->rb_node);
+
+		module = strchr(pos->name, '\t');
+		if (module)
+			*module = '\0';
+
+		curr_map = map_groups__find(kmaps, map->type, pos->start);
+
+		if (!curr_map || (filter && filter(curr_map, pos))) {
+			rb_erase(&pos->rb_node, root);
+			symbol__delete(pos);
+		} else {
+			pos->start -= curr_map->start - curr_map->pgoff;
+			if (pos->end)
+				pos->end -= curr_map->start - curr_map->pgoff;
+			if (curr_map != map) {
+				rb_erase(&pos->rb_node, root);
+				symbols__insert(
+					&curr_map->dso->symbols[curr_map->type],
+					pos);
+				++moved;
+			} else {
+				++count;
+			}
+		}
+	}
+
+	/* Symbols have been adjusted */
+	dso->adjust_symbols = 1;
+
+	return count + moved;
+}
+
 /*
  * Split the symbols into maps, making sure there are no overlaps, i.e. the
  * kernel range is broken in several maps, named [kernel].N, as we don't have
@@ -674,6 +736,161 @@ bool symbol__restricted_filename(const char *filename,
 	return restricted;
 }
 
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
+/*
+ * If kallsyms is referenced by name then we look for kcore in the same
+ * directory.
+ */
+static bool kcore_filename_from_kallsyms_filename(char *kcore_filename,
+						  const char *kallsyms_filename)
+{
+	char *name;
+
+	strcpy(kcore_filename, kallsyms_filename);
+	name = strrchr(kcore_filename, '/');
+	if (!name)
+		return false;
+
+	if (!strcmp(name, "/kallsyms")) {
+		strcpy(name, "/kcore");
+		return true;
+	}
+
+	return false;
+}
+
+static int dso__load_kcore(struct dso *dso, struct map *map,
+			   const char *kallsyms_filename)
+{
+	struct map_groups *kmaps = map__kmap(map)->kmaps;
+	struct machine *machine = kmaps->machine;
+	struct kcore_mapfn_data md;
+	struct map *old_map, *new_map, *replacement_map = NULL;
+	bool is_64_bit;
+	int err, fd;
+	char kcore_filename[PATH_MAX];
+	struct symbol *sym;
+
+	/* This function requires that the map is the kernel map */
+	if (map != machine->vmlinux_maps[map->type])
+		return -EINVAL;
+
+	if (!kcore_filename_from_kallsyms_filename(kcore_filename,
+						   kallsyms_filename))
+		return -EINVAL;
+
+	md.dso = dso;
+	md.type = map->type;
+	INIT_LIST_HEAD(&md.maps);
+
+	fd = open(kcore_filename, O_RDONLY);
+	if (fd < 0)
+		return -EINVAL;
+
+	/* Read new maps into temporary lists */
+	err = file__read_maps(fd, md.type == MAP__FUNCTION, kcore_mapfn, &md,
+			      &is_64_bit);
+	if (err)
+		goto out_err;
+
+	if (list_empty(&md.maps)) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	/* Remove old maps */
+	old_map = map_groups__first(kmaps, map->type);
+	while (old_map) {
+		struct map *next = map_groups__next(old_map);
+
+		if (old_map != map)
+			map_groups__remove(kmaps, old_map);
+		old_map = next;
+	}
+
+	/* Find the kernel map using the first symbol */
+	sym = dso__first_symbol(dso, map->type);
+	list_for_each_entry(new_map, &md.maps, node) {
+		if (sym && sym->start >= new_map->start &&
+		    sym->start < new_map->end) {
+			replacement_map = new_map;
+			break;
+		}
+	}
+
+	if (!replacement_map)
+		replacement_map = list_entry(md.maps.next, struct map, node);
+
+	/* Add new maps */
+	while (!list_empty(&md.maps)) {
+		new_map = list_entry(md.maps.next, struct map, node);
+		list_del(&new_map->node);
+		if (new_map == replacement_map) {
+			map->start	= new_map->start;
+			map->end	= new_map->end;
+			map->pgoff	= new_map->pgoff;
+			map->map_ip	= new_map->map_ip;
+			map->unmap_ip	= new_map->unmap_ip;
+			map__delete(new_map);
+			/* Ensure maps are correctly ordered */
+			map_groups__remove(kmaps, map);
+			map_groups__insert(kmaps, map);
+		} else {
+			map_groups__insert(kmaps, new_map);
+		}
+	}
+
+	/*
+	 * Set the data type and long name so that kcore can be read via
+	 * dso__data_read_addr().
+	 */
+	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+		dso->data_type = DSO_BINARY_TYPE__GUEST_KCORE;
+	else
+		dso->data_type = DSO_BINARY_TYPE__KCORE;
+	dso__set_long_name(dso, strdup(kcore_filename));
+
+	close(fd);
+
+	if (map->type == MAP__FUNCTION)
+		pr_debug("Using %s for kernel object code\n", kcore_filename);
+	else
+		pr_debug("Using %s for kernel data\n", kcore_filename);
+
+	return 0;
+
+out_err:
+	while (!list_empty(&md.maps)) {
+		map = list_entry(md.maps.next, struct map, node);
+		list_del(&map->node);
+		map__delete(map);
+	}
+	close(fd);
+	return -EINVAL;
+}
+
 int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
@@ -691,7 +908,10 @@ int dso__load_kallsyms(struct dso *dso, const char *filename,
 	else
 		dso->symtab_type = DSO_BINARY_TYPE__KALLSYMS;
 
-	return dso__split_kallsyms(dso, map, filter);
+	if (!dso__load_kcore(dso, map, filename))
+		return dso__split_kallsyms_for_kcore(dso, map, filter);
+	else
+		return dso__split_kallsyms(dso, map, filter);
 }
 
 static int dso__load_perf_map(struct dso *dso, struct map *map,
@@ -1065,7 +1285,7 @@ do_kallsyms:
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	free(kallsyms_allocated_filename);
 
-	if (err > 0) {
+	if (err > 0 && !dso__is_kcore(dso)) {
 		dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
 		map__fixup_start(map);
 		map__fixup_end(map);
@@ -1109,8 +1329,9 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 	}
 
 	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
-	if (err > 0) {
+	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
+	if (err > 0 && !dso__is_kcore(dso)) {
 		machine__mmap_name(machine, path, sizeof(path));
 		dso__set_long_name(dso, strdup(path));
 		map__fixup_start(map);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5f720dc..fd5b70e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -215,6 +215,7 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
+struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
@@ -247,4 +248,8 @@ void symbols__fixup_duplicate(struct rb_root *symbols);
 void symbols__fixup_end(struct rb_root *symbols);
 void __map_groups__fixup_end(struct map_groups *mg, enum map_type type);
 
+typedef int (*mapfn_t)(u64 start, u64 len, u64 pgoff, void *data);
+int file__read_maps(int fd, bool exe, mapfn_t mapfn, void *data,
+		    bool *is_64_bit);
+
 #endif /* __PERF_SYMBOL */
