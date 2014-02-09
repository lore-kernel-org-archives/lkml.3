Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaBIIBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:01:25 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34951 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaBIIBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:01:24 -0500
Date: Sun, 9 Feb 2014 09:01:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140209080118.GA17003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 2737fce8bc8dea2852289df29b4f92e6a7fb7c91 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Tooling fixes, mostly related to the KASLR fallout, but also other 
fixes.

 Thanks,

	Ingo

------------------>
Adrian Hunter (9):
      perf symbols: Fix symbol annotation for relocated kernel
      perf tools: Add kallsyms__get_function_start()
      perf machine: Add machine__get_kallsyms_filename()
      perf machine: Set up ref_reloc_sym in machine__create_kernel_maps()
      perf record: Get ref_reloc_sym from kernel map
      perf symbols: Prevent the use of kcore if the kernel has moved
      perf tests: No need to set up ref_reloc_sym
      perf tools: Adjust kallsyms for relocated kernel
      perf buildid-cache: Check relocation when checking for existing kcore

Avi Kivity (1):
      perf tools: Demangle kernel and kernel module symbols too

Baruch Siach (1):
      perf/doc: Remove mention of non-existent set_perf_event_pending() from design.txt

Francesco Fusco (1):
      perf tools: Fix include for non x86 architectures

Peter Zijlstra (1):
      perf tools: Fix AAAAARGH64 memory barriers


 tools/perf/builtin-buildid-cache.c  | 33 ++++++++++++++++---
 tools/perf/builtin-record.c         | 10 ++----
 tools/perf/design.txt               |  1 -
 tools/perf/perf.h                   |  4 +--
 tools/perf/tests/vmlinux-kallsyms.c | 10 ------
 tools/perf/util/event.c             | 36 ++++++++++----------
 tools/perf/util/event.h             |  6 ++--
 tools/perf/util/include/asm/hash.h  |  6 ++++
 tools/perf/util/machine.c           | 42 +++++++++++++++++++-----
 tools/perf/util/machine.h           |  2 ++
 tools/perf/util/map.c               |  5 +--
 tools/perf/util/map.h               |  1 +
 tools/perf/util/symbol-elf.c        |  4 ++-
 tools/perf/util/symbol.c            | 65 +++++++++++++++++++++++++++++++++----
 14 files changed, 162 insertions(+), 63 deletions(-)
 create mode 100644 tools/perf/util/include/asm/hash.h

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index cfede86..b22dbb1 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -63,11 +63,35 @@ static int build_id_cache__kcore_dir(char *dir, size_t sz)
 	return 0;
 }
 
+static bool same_kallsyms_reloc(const char *from_dir, char *to_dir)
+{
+	char from[PATH_MAX];
+	char to[PATH_MAX];
+	const char *name;
+	u64 addr1 = 0, addr2 = 0;
+	int i;
+
+	scnprintf(from, sizeof(from), "%s/kallsyms", from_dir);
+	scnprintf(to, sizeof(to), "%s/kallsyms", to_dir);
+
+	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
+		addr1 = kallsyms__get_function_start(from, name);
+		if (addr1)
+			break;
+	}
+
+	if (name)
+		addr2 = kallsyms__get_function_start(to, name);
+
+	return addr1 == addr2;
+}
+
 static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
 					  size_t to_dir_sz)
 {
 	char from[PATH_MAX];
 	char to[PATH_MAX];
+	char to_subdir[PATH_MAX];
 	struct dirent *dent;
 	int ret = -1;
 	DIR *d;
@@ -86,10 +110,11 @@ static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
 			continue;
 		scnprintf(to, sizeof(to), "%s/%s/modules", to_dir,
 			  dent->d_name);
-		if (!compare_proc_modules(from, to)) {
-			scnprintf(to, sizeof(to), "%s/%s", to_dir,
-				  dent->d_name);
-			strlcpy(to_dir, to, to_dir_sz);
+		scnprintf(to_subdir, sizeof(to_subdir), "%s/%s",
+			  to_dir, dent->d_name);
+		if (!compare_proc_modules(from, to) &&
+		    same_kallsyms_reloc(from_dir, to_subdir)) {
+			strlcpy(to_dir, to_subdir, to_dir_sz);
 			ret = 0;
 			break;
 		}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3c394bf..af47531 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -287,10 +287,7 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 * have no _text sometimes.
 	 */
 	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-						 machine, "_text");
-	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-							 machine, "_stext");
+						 machine);
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
@@ -457,10 +454,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	}
 
 	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-						 machine, "_text");
-	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-							 machine, "_stext");
+						 machine);
 	if (err < 0)
 		pr_err("Couldn't record kernel reference relocation symbol\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 67e5d0c..63a0e6f 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -454,7 +454,6 @@ So to start with, in order to add HAVE_PERF_EVENTS to your Kconfig, you
 will need at least this:
 	- asm/perf_event.h - a basic stub will suffice at first
 	- support for atomic64 types (and associated helper functions)
-	- set_perf_event_pending() implemented
 
 If your architecture does have hardware capabilities, you can override the
 weak stub hw_perf_event_init() to register hardware counters.
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 7daa806..e84fa26 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -100,8 +100,8 @@
 
 #ifdef __aarch64__
 #define mb()		asm volatile("dmb ish" ::: "memory")
-#define wmb()		asm volatile("dmb ishld" ::: "memory")
-#define rmb()		asm volatile("dmb ishst" ::: "memory")
+#define wmb()		asm volatile("dmb ishst" ::: "memory")
+#define rmb()		asm volatile("dmb ishld" ::: "memory")
 #define cpu_relax()	asm volatile("yield" ::: "memory")
 #endif
 
diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index 2bd13ed..3d90880 100644
--- a/tools/perf/tests/vmlinux-kallsyms.c
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -26,7 +26,6 @@ int test__vmlinux_matches_kallsyms(void)
 	struct map *kallsyms_map, *vmlinux_map;
 	struct machine kallsyms, vmlinux;
 	enum map_type type = MAP__FUNCTION;
-	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
 	u64 mem_start, mem_end;
 
 	/*
@@ -70,14 +69,6 @@ int test__vmlinux_matches_kallsyms(void)
 	 */
 	kallsyms_map = machine__kernel_map(&kallsyms, type);
 
-	sym = map__find_symbol_by_name(kallsyms_map, ref_reloc_sym.name, NULL);
-	if (sym == NULL) {
-		pr_debug("dso__find_symbol_by_name ");
-		goto out;
-	}
-
-	ref_reloc_sym.addr = UM(sym->start);
-
 	/*
 	 * Step 5:
 	 *
@@ -89,7 +80,6 @@ int test__vmlinux_matches_kallsyms(void)
 	}
 
 	vmlinux_map = machine__kernel_map(&vmlinux, type);
-	map__kmap(vmlinux_map)->ref_reloc_sym = &ref_reloc_sym;
 
 	/*
 	 * Step 6:
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1fc1c2f..b0f3ca8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -470,23 +470,32 @@ static int find_symbol_cb(void *arg, const char *name, char type,
 	return 1;
 }
 
+u64 kallsyms__get_function_start(const char *kallsyms_filename,
+				 const char *symbol_name)
+{
+	struct process_symbol_args args = { .name = symbol_name, };
+
+	if (kallsyms__parse(kallsyms_filename, &args, find_symbol_cb) <= 0)
+		return 0;
+
+	return args.start;
+}
+
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
-				       struct machine *machine,
-				       const char *symbol_name)
+				       struct machine *machine)
 {
 	size_t size;
-	const char *filename, *mmap_name;
-	char path[PATH_MAX];
+	const char *mmap_name;
 	char name_buff[PATH_MAX];
 	struct map *map;
+	struct kmap *kmap;
 	int err;
 	/*
 	 * We should get this from /sys/kernel/sections/.text, but till that is
 	 * available use this, and after it is use this as a fallback for older
 	 * kernels.
 	 */
-	struct process_symbol_args args = { .name = symbol_name, };
 	union perf_event *event = zalloc((sizeof(event->mmap) +
 					  machine->id_hdr_size));
 	if (event == NULL) {
@@ -502,30 +511,19 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 		 * see kernel/perf_event.c __perf_event_mmap
 		 */
 		event->header.misc = PERF_RECORD_MISC_KERNEL;
-		filename = "/proc/kallsyms";
 	} else {
 		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
-		if (machine__is_default_guest(machine))
-			filename = (char *) symbol_conf.default_guest_kallsyms;
-		else {
-			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-			filename = path;
-		}
-	}
-
-	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0) {
-		free(event);
-		return -ENOENT;
 	}
 
 	map = machine->vmlinux_maps[MAP__FUNCTION];
+	kmap = map__kmap(map);
 	size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
-			"%s%s", mmap_name, symbol_name) + 1;
+			"%s%s", mmap_name, kmap->ref_reloc_sym->name) + 1;
 	size = PERF_ALIGN(size, sizeof(u64));
 	event->mmap.header.type = PERF_RECORD_MMAP;
 	event->mmap.header.size = (sizeof(event->mmap) -
 			(sizeof(event->mmap.filename) - size) + machine->id_hdr_size);
-	event->mmap.pgoff = args.start;
+	event->mmap.pgoff = kmap->ref_reloc_sym->addr;
 	event->mmap.start = map->start;
 	event->mmap.len   = map->end - event->mmap.start;
 	event->mmap.pid   = machine->pid;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index faf6e21..851fa06 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -214,8 +214,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 				   struct machine *machine, bool mmap_data);
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
-				       struct machine *machine,
-				       const char *symbol_name);
+				       struct machine *machine);
 
 int perf_event__synthesize_modules(struct perf_tool *tool,
 				   perf_event__handler_t process,
@@ -279,4 +278,7 @@ size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
 
+u64 kallsyms__get_function_start(const char *kallsyms_filename,
+				 const char *symbol_name);
+
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/include/asm/hash.h b/tools/perf/util/include/asm/hash.h
new file mode 100644
index 0000000..d82b170b
--- /dev/null
+++ b/tools/perf/util/include/asm/hash.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_HASH_H
+#define __ASM_GENERIC_HASH_H
+
+/* Stub */
+
+#endif /* __ASM_GENERIC_HASH_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ded7459..c872991 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -496,19 +496,22 @@ static int symbol__in_kernel(void *arg, const char *name,
 	return 1;
 }
 
+static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
+					   size_t bufsz)
+{
+	if (machine__is_default_guest(machine))
+		scnprintf(buf, bufsz, "%s", symbol_conf.default_guest_kallsyms);
+	else
+		scnprintf(buf, bufsz, "%s/proc/kallsyms", machine->root_dir);
+}
+
 /* Figure out the start address of kernel map from /proc/kallsyms */
 static u64 machine__get_kernel_start_addr(struct machine *machine)
 {
-	const char *filename;
-	char path[PATH_MAX];
+	char filename[PATH_MAX];
 	struct process_args args;
 
-	if (machine__is_default_guest(machine))
-		filename = (char *)symbol_conf.default_guest_kallsyms;
-	else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-		filename = path;
-	}
+	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return 0;
@@ -829,9 +832,25 @@ static int machine__create_modules(struct machine *machine)
 	return 0;
 }
 
+const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
+
 int machine__create_kernel_maps(struct machine *machine)
 {
 	struct dso *kernel = machine__get_kernel(machine);
+	char filename[PATH_MAX];
+	const char *name;
+	u64 addr = 0;
+	int i;
+
+	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
+
+	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
+		addr = kallsyms__get_function_start(filename, name);
+		if (addr)
+			break;
+	}
+	if (!addr)
+		return -1;
 
 	if (kernel == NULL ||
 	    __machine__create_kernel_maps(machine, kernel) < 0)
@@ -850,6 +869,13 @@ int machine__create_kernel_maps(struct machine *machine)
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
 	map_groups__fixup_end(&machine->kmaps);
+
+	if (maps__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps, name,
+					     addr)) {
+		machine__destroy_kernel_maps(machine);
+		return -1;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 4771330..f77e91e 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -18,6 +18,8 @@ union perf_event;
 #define	HOST_KERNEL_ID			(-1)
 #define	DEFAULT_GUEST_KERNEL_ID		(0)
 
+extern const char *ref_reloc_sym_names[];
+
 struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 3b97513..39cd2d0 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -39,6 +39,7 @@ void map__init(struct map *map, enum map_type type,
 	map->start    = start;
 	map->end      = end;
 	map->pgoff    = pgoff;
+	map->reloc    = 0;
 	map->dso      = dso;
 	map->map_ip   = map__map_ip;
 	map->unmap_ip = map__unmap_ip;
@@ -288,7 +289,7 @@ u64 map__rip_2objdump(struct map *map, u64 rip)
 	if (map->dso->rel)
 		return rip - map->pgoff;
 
-	return map->unmap_ip(map, rip);
+	return map->unmap_ip(map, rip) - map->reloc;
 }
 
 /**
@@ -311,7 +312,7 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
 	if (map->dso->rel)
 		return map->unmap_ip(map, ip + map->pgoff);
 
-	return ip;
+	return ip + map->reloc;
 }
 
 void map_groups__init(struct map_groups *mg)
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 18068c6..257e513 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -36,6 +36,7 @@ struct map {
 	bool			erange_warned;
 	u32			priv;
 	u64			pgoff;
+	u64			reloc;
 	u32			maj, min; /* only valid for MMAP2 record */
 	u64			ino;      /* only valid for MMAP2 record */
 	u64			ino_generation;/* only valid for MMAP2 record */
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 7594567..3e9f336 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -751,6 +751,8 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			if (strcmp(elf_name, kmap->ref_reloc_sym->name))
 				continue;
 			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
+			map->reloc = kmap->ref_reloc_sym->addr -
+				     kmap->ref_reloc_sym->unrelocated_addr;
 			break;
 		}
 	}
@@ -922,6 +924,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 				  (u64)shdr.sh_offset);
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
+new_symbol:
 		/*
 		 * We need to figure out if the object was created from C++ sources
 		 * DWARF DW_compile_unit has this, but we don't always have access
@@ -933,7 +936,6 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			if (demangled != NULL)
 				elf_name = demangled;
 		}
-new_symbol:
 		f = symbol__new(sym.st_value, sym.st_size,
 				GELF_ST_BIND(sym.st_info), elf_name);
 		free(demangled);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 39ce9ad..a9d758a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -627,7 +627,7 @@ static int dso__split_kallsyms_for_kcore(struct dso *dso, struct map *map,
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int dso__split_kallsyms(struct dso *dso, struct map *map,
+static int dso__split_kallsyms(struct dso *dso, struct map *map, u64 delta,
 			       symbol_filter_t filter)
 {
 	struct map_groups *kmaps = map__kmap(map)->kmaps;
@@ -692,6 +692,12 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *ndso;
 
+			if (delta) {
+				/* Kernel was relocated at boot time */
+				pos->start -= delta;
+				pos->end -= delta;
+			}
+
 			if (count == 0) {
 				curr_map = map;
 				goto filter_symbol;
@@ -721,6 +727,10 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
 			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
+		} else if (delta) {
+			/* Kernel was relocated at boot time */
+			pos->start -= delta;
+			pos->end -= delta;
 		}
 filter_symbol:
 		if (filter && filter(curr_map, pos)) {
@@ -976,6 +986,23 @@ static int validate_kcore_modules(const char *kallsyms_filename,
 	return 0;
 }
 
+static int validate_kcore_addresses(const char *kallsyms_filename,
+				    struct map *map)
+{
+	struct kmap *kmap = map__kmap(map);
+
+	if (kmap->ref_reloc_sym && kmap->ref_reloc_sym->name) {
+		u64 start;
+
+		start = kallsyms__get_function_start(kallsyms_filename,
+						     kmap->ref_reloc_sym->name);
+		if (start != kmap->ref_reloc_sym->addr)
+			return -EINVAL;
+	}
+
+	return validate_kcore_modules(kallsyms_filename, map);
+}
+
 struct kcore_mapfn_data {
 	struct dso *dso;
 	enum map_type type;
@@ -1019,8 +1046,8 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 					     kallsyms_filename))
 		return -EINVAL;
 
-	/* All modules must be present at their original addresses */
-	if (validate_kcore_modules(kallsyms_filename, map))
+	/* Modules and kernel must be present at their original addresses */
+	if (validate_kcore_addresses(kallsyms_filename, map))
 		return -EINVAL;
 
 	md.dso = dso;
@@ -1113,15 +1140,41 @@ out_err:
 	return -EINVAL;
 }
 
+/*
+ * If the kernel is relocated at boot time, kallsyms won't match.  Compute the
+ * delta based on the relocation reference symbol.
+ */
+static int kallsyms__delta(struct map *map, const char *filename, u64 *delta)
+{
+	struct kmap *kmap = map__kmap(map);
+	u64 addr;
+
+	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->name)
+		return 0;
+
+	addr = kallsyms__get_function_start(filename,
+					    kmap->ref_reloc_sym->name);
+	if (!addr)
+		return -1;
+
+	*delta = addr - kmap->ref_reloc_sym->addr;
+	return 0;
+}
+
 int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
+	u64 delta = 0;
+
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return -1;
 
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
+	if (kallsyms__delta(map, filename, &delta))
+		return -1;
+
 	symbols__fixup_duplicate(&dso->symbols[map->type]);
 	symbols__fixup_end(&dso->symbols[map->type]);
 
@@ -1133,7 +1186,7 @@ int dso__load_kallsyms(struct dso *dso, const char *filename,
 	if (!dso__load_kcore(dso, map, filename))
 		return dso__split_kallsyms_for_kcore(dso, map, filter);
 	else
-		return dso__split_kallsyms(dso, map, filter);
+		return dso__split_kallsyms(dso, map, delta, filter);
 }
 
 static int dso__load_perf_map(struct dso *dso, struct map *map,
@@ -1424,7 +1477,7 @@ static int find_matching_kcore(struct map *map, char *dir, size_t dir_sz)
 			continue;
 		scnprintf(kallsyms_filename, sizeof(kallsyms_filename),
 			  "%s/%s/kallsyms", dir, dent->d_name);
-		if (!validate_kcore_modules(kallsyms_filename, map)) {
+		if (!validate_kcore_addresses(kallsyms_filename, map)) {
 			strlcpy(dir, kallsyms_filename, dir_sz);
 			ret = 0;
 			break;
@@ -1479,7 +1532,7 @@ static char *dso__find_kallsyms(struct dso *dso, struct map *map)
 		if (fd != -1) {
 			close(fd);
 			/* If module maps match go with /proc/kallsyms */
-			if (!validate_kcore_modules("/proc/kallsyms", map))
+			if (!validate_kcore_addresses("/proc/kallsyms", map))
 				goto proc_kallsyms;
 		}
 
