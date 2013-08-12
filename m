Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3HLKVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:21:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3HLKVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:21:44 -0400
Date: Mon, 12 Aug 2013 03:21:00 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-39b12f7812710e9a5896805d96812b3ede7491e8@git.kernel.org>
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
In-Reply-To: <1375875537-4509-4-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Make it possible to read object code from vmlinux
Git-Commit-ID: 39b12f7812710e9a5896805d96812b3ede7491e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:21:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39b12f7812710e9a5896805d96812b3ede7491e8
Gitweb:     http://git.kernel.org/tip/39b12f7812710e9a5896805d96812b3ede7491e8
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:47 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:31 -0300

perf tools: Make it possible to read object code from vmlinux

The new "object code reading" test shows that it is not possible to read
object code from vmlinux.  That is because the mappings do not map to
the dso.  This patch fixes that.

A side-effect of changing the kernel map is that the "reloc" offset must
be taken into account.  As a result of that separate map functions for
relocation are no longer needed.

Also fixing up the maps to match the symbols no longer makes sense and
so is not done.

The vmlinux dso data_type is now set to either DSO_BINARY_TYPE__VMLINUX
or DSO_BINARY_TYPE__GUEST_VMLINUX as approprite, which enables the
correct file name to be determined by dso__binary_type_file().

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
Link: http://lkml.kernel.org/r/1375875537-4509-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c        |   4 +-
 tools/perf/util/dso.h        |   8 ++++
 tools/perf/util/machine.c    |   4 +-
 tools/perf/util/map.c        |  35 ---------------
 tools/perf/util/symbol-elf.c | 100 +++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/symbol.c     |  22 +++++-----
 6 files changed, 112 insertions(+), 61 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index c4374f0..121583d 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -78,6 +78,8 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 			 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
 		break;
 
+	case DSO_BINARY_TYPE__VMLINUX:
+	case DSO_BINARY_TYPE__GUEST_VMLINUX:
 	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
 		snprintf(file, size, "%s%s",
 			 symbol_conf.symfs, dso->long_name);
@@ -95,9 +97,7 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 
 	default:
 	case DSO_BINARY_TYPE__KALLSYMS:
-	case DSO_BINARY_TYPE__VMLINUX:
 	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
-	case DSO_BINARY_TYPE__GUEST_VMLINUX:
 	case DSO_BINARY_TYPE__JAVA_JIT:
 	case DSO_BINARY_TYPE__NOT_FOUND:
 		ret = -1;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index d51aaf2..02aadaf 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/rbtree.h>
+#include <stdbool.h>
 #include "types.h"
 #include "map.h"
 
@@ -146,4 +147,11 @@ size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
 size_t dso__fprintf_symbols_by_name(struct dso *dso,
 				    enum map_type type, FILE *fp);
 size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp);
+
+static inline bool dso__is_vmlinux(struct dso *dso)
+{
+	return dso->data_type == DSO_BINARY_TYPE__VMLINUX ||
+	       dso->data_type == DSO_BINARY_TYPE__GUEST_VMLINUX;
+}
+
 #endif /* __PERF_DSO */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f9f9d63..dc35dcf 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -628,10 +628,8 @@ int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 	struct map *map = machine->vmlinux_maps[type];
 	int ret = dso__load_vmlinux_path(map->dso, map, filter);
 
-	if (ret > 0) {
+	if (ret > 0)
 		dso__set_loaded(map->dso, type);
-		map__reloc_vmlinux(map);
-	}
 
 	return ret;
 }
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 8bcdf9e..5f662a3 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -182,12 +182,6 @@ int map__load(struct map *map, symbol_filter_t filter)
 #endif
 		return -1;
 	}
-	/*
-	 * Only applies to the kernel, as its symtabs aren't relative like the
-	 * module ones.
-	 */
-	if (map->dso->kernel)
-		map__reloc_vmlinux(map);
 
 	return 0;
 }
@@ -513,35 +507,6 @@ int map_groups__clone(struct map_groups *mg,
 	return 0;
 }
 
-static u64 map__reloc_map_ip(struct map *map, u64 ip)
-{
-	return ip + (s64)map->pgoff;
-}
-
-static u64 map__reloc_unmap_ip(struct map *map, u64 ip)
-{
-	return ip - (s64)map->pgoff;
-}
-
-void map__reloc_vmlinux(struct map *map)
-{
-	struct kmap *kmap = map__kmap(map);
-	s64 reloc;
-
-	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->unrelocated_addr)
-		return;
-
-	reloc = (kmap->ref_reloc_sym->unrelocated_addr -
-		 kmap->ref_reloc_sym->addr);
-
-	if (!reloc)
-		return;
-
-	map->map_ip   = map__reloc_map_ip;
-	map->unmap_ip = map__reloc_unmap_ip;
-	map->pgoff    = reloc;
-}
-
 void maps__insert(struct rb_root *maps, struct map *map)
 {
 	struct rb_node **p = &maps->rb_node;
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 4b12bf8..ed6f443 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -603,7 +603,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
 	} else {
-		ss->adjust_symbols = 0;
+		ss->adjust_symbols = ehdr.e_type == ET_EXEC;
 	}
 
 	ss->name   = strdup(name);
@@ -624,6 +624,37 @@ out_close:
 	return err;
 }
 
+/**
+ * ref_reloc_sym_not_found - has kernel relocation symbol been found.
+ * @kmap: kernel maps and relocation reference symbol
+ *
+ * This function returns %true if we are dealing with the kernel maps and the
+ * relocation reference symbol has not yet been found.  Otherwise %false is
+ * returned.
+ */
+static bool ref_reloc_sym_not_found(struct kmap *kmap)
+{
+	return kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
+	       !kmap->ref_reloc_sym->unrelocated_addr;
+}
+
+/**
+ * ref_reloc - kernel relocation offset.
+ * @kmap: kernel maps and relocation reference symbol
+ *
+ * This function returns the offset of kernel addresses as determined by using
+ * the relocation reference symbol i.e. if the kernel has not been relocated
+ * then the return value is zero.
+ */
+static u64 ref_reloc(struct kmap *kmap)
+{
+	if (kmap && kmap->ref_reloc_sym &&
+	    kmap->ref_reloc_sym->unrelocated_addr)
+		return kmap->ref_reloc_sym->addr -
+		       kmap->ref_reloc_sym->unrelocated_addr;
+	return 0;
+}
+
 int dso__load_sym(struct dso *dso, struct map *map,
 		  struct symsrc *syms_ss, struct symsrc *runtime_ss,
 		  symbol_filter_t filter, int kmodule)
@@ -642,6 +673,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	Elf_Scn *sec, *sec_strndx;
 	Elf *elf;
 	int nr = 0;
+	bool remap_kernel = false, adjust_kernel_syms = false;
 
 	dso->symtab_type = syms_ss->type;
 
@@ -681,7 +713,31 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	dso->adjust_symbols = runtime_ss->adjust_symbols;
+
+	/*
+	 * The kernel relocation symbol is needed in advance in order to adjust
+	 * kernel maps correctly.
+	 */
+	if (ref_reloc_sym_not_found(kmap)) {
+		elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
+			const char *elf_name = elf_sym__name(&sym, symstrs);
+
+			if (strcmp(elf_name, kmap->ref_reloc_sym->name))
+				continue;
+			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
+			break;
+		}
+	}
+
+	dso->adjust_symbols = runtime_ss->adjust_symbols || ref_reloc(kmap);
+	/*
+	 * Initial kernel and module mappings do not map to the dso.  For
+	 * function mappings, flag the fixups.
+	 */
+	if (map->type == MAP__FUNCTION && (dso->kernel || kmodule)) {
+		remap_kernel = true;
+		adjust_kernel_syms = dso->adjust_symbols;
+	}
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
 		const char *elf_name = elf_sym__name(&sym, symstrs);
@@ -690,10 +746,6 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		const char *section_name;
 		bool used_opd = false;
 
-		if (kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
-		    strcmp(elf_name, kmap->ref_reloc_sym->name) == 0)
-			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
-
 		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
 
@@ -745,15 +797,37 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		    (sym.st_value & 1))
 			--sym.st_value;
 
-		if (dso->kernel != DSO_TYPE_USER || kmodule) {
+		if (dso->kernel || kmodule) {
 			char dso_name[PATH_MAX];
 
+			/* Adjust symbol to map to file offset */
+			if (adjust_kernel_syms)
+				sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+
 			if (strcmp(section_name,
 				   (curr_dso->short_name +
 				    dso->short_name_len)) == 0)
 				goto new_symbol;
 
 			if (strcmp(section_name, ".text") == 0) {
+				/*
+				 * The initial kernel mapping is based on
+				 * kallsyms and identity maps.  Overwrite it to
+				 * map to the kernel dso.
+				 */
+				if (remap_kernel && dso->kernel) {
+					remap_kernel = false;
+					map->start = shdr.sh_addr +
+						     ref_reloc(kmap);
+					map->end = map->start + shdr.sh_size;
+					map->pgoff = shdr.sh_offset;
+					map->map_ip = map__map_ip;
+					map->unmap_ip = map__unmap_ip;
+					/* Ensure maps are correctly ordered */
+					map_groups__remove(kmap->kmaps, map);
+					map_groups__insert(kmap->kmaps, map);
+				}
+
 				curr_map = map;
 				curr_dso = dso;
 				goto new_symbol;
@@ -781,8 +855,16 @@ int dso__load_sym(struct dso *dso, struct map *map,
 					dso__delete(curr_dso);
 					goto out_elf_end;
 				}
-				curr_map->map_ip = identity__map_ip;
-				curr_map->unmap_ip = identity__map_ip;
+				if (adjust_kernel_syms) {
+					curr_map->start = shdr.sh_addr +
+							  ref_reloc(kmap);
+					curr_map->end = curr_map->start +
+							shdr.sh_size;
+					curr_map->pgoff = shdr.sh_offset;
+				} else {
+					curr_map->map_ip = identity__map_ip;
+					curr_map->unmap_ip = identity__map_ip;
+				}
 				curr_dso->symtab_type = dso->symtab_type;
 				map_groups__insert(kmap->kmaps, curr_map);
 				dsos__add(&dso->node, curr_dso);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ea62ecd..04300dd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -917,6 +917,10 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	symsrc__destroy(&ss);
 
 	if (err > 0) {
+		if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+			dso->data_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
+		else
+			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
 		dso__set_long_name(dso, (char *)vmlinux);
 		dso__set_loaded(dso, map->type);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
@@ -989,7 +993,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 			dso__set_long_name(dso,
 					   strdup(symbol_conf.vmlinux_name));
 			dso->lname_alloc = 1;
-			goto out_fixup;
+			return err;
 		}
 		return err;
 	}
@@ -997,7 +1001,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 	if (vmlinux_path != NULL) {
 		err = dso__load_vmlinux_path(dso, map, filter);
 		if (err > 0)
-			goto out_fixup;
+			return err;
 	}
 
 	/* do not try local files if a symfs was given */
@@ -1058,7 +1062,6 @@ do_kallsyms:
 
 	if (err > 0) {
 		dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
-out_fixup:
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
@@ -1089,7 +1092,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 		if (symbol_conf.default_guest_vmlinux_name != NULL) {
 			err = dso__load_vmlinux(dso, map,
 				symbol_conf.default_guest_vmlinux_name, filter);
-			goto out_try_fixup;
+			return err;
 		}
 
 		kallsyms_filename = symbol_conf.default_guest_kallsyms;
@@ -1101,15 +1104,10 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 	}
 
 	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
-	if (err > 0)
-		pr_debug("Using %s for symbols\n", kallsyms_filename);
-
-out_try_fixup:
 	if (err > 0) {
-		if (kallsyms_filename != NULL) {
-			machine__mmap_name(machine, path, sizeof(path));
-			dso__set_long_name(dso, strdup(path));
-		}
+		pr_debug("Using %s for symbols\n", kallsyms_filename);
+		machine__mmap_name(machine, path, sizeof(path));
+		dso__set_long_name(dso, strdup(path));
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
