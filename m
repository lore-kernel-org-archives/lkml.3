Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3IVKQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:16:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:37121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3IVKQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:16:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,956,1371106800"; 
   d="scan'208";a="405354148"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 09/10] perf buildid-cache: add ability to add kcore to the cache
Date: Sun, 22 Sep 2013 13:22:17 +0300
Message-Id: <1379845338-29637-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
References: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcore can be used to view the running kernel object code.
However, kcore changes as modules are loaded and unloaded,
and when the kernel decides to modify its own code.
Consequently it is useful to create a copy of kcore at a
particular time.  Unlike vmlinux, kcore is not unique
for a given build-id.  And in addition, the kallsyms
and modules files are also needed.  The tool therefore
creates a directory:

	~/.debug/[kernel.kcore]/<build-id>/<YYYYmmddHHMMSShh>

which contains: kcore, kallsyms and modules.

Note that the copied kcore contains only code sections.
See the kcore_copy() function for how that is determined.

The tool will not make additional copies of kcore if there
is already one with the same modules at the same addresses.

Currently, perf tools will not look for kcore in the cache.
That is addressed in another patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt |  12 +
 tools/perf/builtin-buildid-cache.c              | 146 +++++++++-
 tools/perf/util/symbol-elf.c                    | 358 ++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c                |   6 +
 tools/perf/util/symbol.c                        |  41 +++
 tools/perf/util/symbol.h                        |   3 +
 6 files changed, 565 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index e9a8349..c3c0d5e 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -21,6 +21,18 @@ OPTIONS
 -a::
 --add=::
         Add specified file to the cache.
+-k::
+--kcore::
+        Add specified kcore file to the cache. For the current host that is
+        /proc/kcore which requires root permissions to read. Be aware that
+        running 'perf buildid-cache' as root will update root's build-id cache
+        not the user's. Use the -v option to see where the file is created.
+        Note that the copied file contains only code sections not the whole core
+        image. Note also that files "kallsyms" and "modules" must also be in the
+        same directory and are also copied.  kcore will not be added if there
+        is already a kcore in the cache (with the same build-id) that has the
+        same modules at the same addresses.  Use the -v option to see if a copy
+        of kcore is actually made.
 -r::
 --remove=::
         Remove specified file from the cache.
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index c96c8fa..03ff06e 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -6,6 +6,11 @@
  * Copyright (C) 2010, Red Hat Inc.
  * Copyright (C) 2010, Arnaldo Carvalho de Melo <acme@redhat.com>
  */
+#include <sys/types.h>
+#include <sys/time.h>
+#include <time.h>
+#include <dirent.h>
+#include <unistd.h>
 #include "builtin.h"
 #include "perf.h"
 #include "util/cache.h"
@@ -17,6 +22,138 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
+static int build_id_cache__kcore_buildid(const char *proc_dir, char *sbuildid)
+{
+	char root_dir[PATH_MAX];
+	char notes[PATH_MAX];
+	u8 build_id[BUILD_ID_SIZE];
+	char *p;
+
+	strncpy(root_dir, proc_dir, sizeof(root_dir));
+
+	p = strrchr(root_dir, '/');
+	if (!p)
+		return -1;
+	*p = '\0';
+
+	snprintf(notes, sizeof(notes), "%s/sys/kernel/notes", root_dir);
+
+	if (sysfs__read_build_id(notes, build_id, sizeof(build_id)))
+		return -1;
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuildid);
+
+	return 0;
+}
+
+static int build_id_cache__kcore_dir(char *dir, size_t sz)
+{
+	struct timeval tv;
+	struct tm tm;
+	char dt[32];
+
+	if (gettimeofday(&tv, NULL) || !localtime_r(&tv.tv_sec, &tm))
+		return -1;
+
+	if (!strftime(dt, sizeof(dt), "%Y%m%d%H%M%S", &tm))
+		return -1;
+
+	snprintf(dir, sz, "%s%02u", dt, (unsigned)tv.tv_usec / 10000);
+
+	return 0;
+}
+
+static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
+					  size_t to_dir_sz)
+{
+	char from[PATH_MAX];
+	char to[PATH_MAX];
+	struct dirent *dent;
+	int ret = -1;
+	DIR *d;
+
+	d = opendir(to_dir);
+	if (!d)
+		return -1;
+
+	snprintf(from, sizeof(from), "%s/modules", from_dir);
+
+	while (1) {
+		dent = readdir(d);
+		if (!dent)
+			break;
+		if (dent->d_type != DT_DIR)
+			continue;
+		snprintf(to, sizeof(to), "%s/%s/modules", to_dir, dent->d_name);
+		if (!compare_proc_modules(from, to)) {
+			snprintf(to, sizeof(to), "%s/%s", to_dir, dent->d_name);
+			strncpy(to_dir, to, to_dir_sz);
+			ret = 0;
+			break;
+		}
+	}
+
+	closedir(d);
+
+	return ret;
+}
+
+static int build_id_cache__add_kcore(const char *filename, const char *debugdir)
+{
+	char dir[32], sbuildid[BUILD_ID_SIZE * 2 + 1];
+	char from_dir[PATH_MAX], to_dir[PATH_MAX];
+	char *p;
+
+	strncpy(from_dir, filename, sizeof(from_dir));
+
+	p = strrchr(from_dir, '/');
+	if (!p || strcmp(p + 1, "kcore"))
+		return -1;
+	*p = '\0';
+
+	if (build_id_cache__kcore_buildid(from_dir, sbuildid))
+		return -1;
+
+	snprintf(to_dir, sizeof(to_dir), "%s/[kernel.kcore]/%s",
+		 debugdir, sbuildid);
+
+	if (!build_id_cache__kcore_existing(from_dir, to_dir, sizeof(to_dir))) {
+		pr_debug("same kcore found in %s\n", to_dir);
+		return 0;
+	}
+
+	if (build_id_cache__kcore_dir(dir, sizeof(dir)))
+		return -1;
+
+	snprintf(to_dir, sizeof(to_dir), "%s/[kernel.kcore]/%s/%s",
+		 debugdir, sbuildid, dir);
+
+	if (mkdir_p(to_dir, 0755))
+		return -1;
+
+	if (kcore_copy(from_dir, to_dir)) {
+		/* Remove YYYYmmddHHMMSShh directory */
+		if (!rmdir(to_dir)) {
+			p = strrchr(to_dir, '/');
+			if (p)
+				*p = '\0';
+			/* Try to remove buildid directory */
+			if (!rmdir(to_dir)) {
+				p = strrchr(to_dir, '/');
+				if (p)
+					*p = '\0';
+				/* Try to remove [kernel.kcore] directory */
+				rmdir(to_dir);
+			}
+		}
+		return -1;
+	}
+
+	pr_debug("kcore added to build-id cache directory %s\n", to_dir);
+
+	return 0;
+}
+
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -130,11 +267,14 @@ int cmd_buildid_cache(int argc, const char **argv,
 	char const *add_name_list_str = NULL,
 		   *remove_name_list_str = NULL,
 		   *missing_filename = NULL,
-		   *update_name_list_str = NULL;
+		   *update_name_list_str = NULL,
+		   *kcore_filename;
 
 	const struct option buildid_cache_options[] = {
 	OPT_STRING('a', "add", &add_name_list_str,
 		   "file list", "file(s) to add"),
+	OPT_STRING('k', "kcore", &kcore_filename,
+		   "file", "kcore file to add"),
 	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
 		    "file(s) to remove"),
 	OPT_STRING('M', "missing", &missing_filename, "file",
@@ -217,5 +357,9 @@ int cmd_buildid_cache(int argc, const char **argv,
 		}
 	}
 
+	if (kcore_filename &&
+	    build_id_cache__add_kcore(kcore_filename, debugdir))
+		pr_warning("Couldn't add %s\n", kcore_filename);
+
 	return ret;
 }
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 79b27fc7..62f272b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1178,6 +1178,364 @@ static off_t kcore_write(struct kcore *kcore)
 	return elf_update(kcore->elf, ELF_C_WRITE);
 }
 
+struct phdr_data {
+	off_t offset;
+	u64 addr;
+	u64 len;
+};
+
+struct kcore_copy_info {
+	u64 stext;
+	u64 etext;
+	u64 first_symbol;
+	u64 last_symbol;
+	u64 first_module;
+	u64 last_module_symbol;
+	struct phdr_data kernel_map;
+	struct phdr_data modules_map;
+};
+
+static int kcore_copy__process_kallsyms(void *arg, const char *name, char type,
+					u64 start)
+{
+	struct kcore_copy_info *kci = arg;
+
+	if (!symbol_type__is_a(type, MAP__FUNCTION))
+		return 0;
+
+	if (strchr(name, '[')) {
+		if (start > kci->last_module_symbol)
+			kci->last_module_symbol = start;
+		return 0;
+	}
+
+	if (!kci->first_symbol || start < kci->first_symbol)
+		kci->first_symbol = start;
+
+	if (!kci->last_symbol || start > kci->last_symbol)
+		kci->last_symbol = start;
+
+	if (!strcmp(name, "_stext")) {
+		kci->stext = start;
+		return 0;
+	}
+
+	if (!strcmp(name, "_etext")) {
+		kci->etext = start;
+		return 0;
+	}
+
+	return 0;
+}
+
+static int kcore_copy__parse_kallsyms(const char *dir,
+				      struct kcore_copy_info *kci)
+{
+	char kallsyms_filename[PATH_MAX];
+
+	snprintf(kallsyms_filename, PATH_MAX, "%s/kallsyms", dir);
+
+	if (symbol__restricted_filename(kallsyms_filename, "/proc/kallsyms"))
+		return -1;
+
+	if (kallsyms__parse(kallsyms_filename, kci,
+			    kcore_copy__process_kallsyms) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int kcore_copy__process_modules(void *arg,
+				       const char *name __maybe_unused,
+				       u64 start)
+{
+	struct kcore_copy_info *kci = arg;
+
+	if (!kci->first_module || start < kci->first_module)
+		kci->first_module = start;
+
+	return 0;
+}
+
+static int kcore_copy__parse_modules(const char *dir,
+				     struct kcore_copy_info *kci)
+{
+	char modules_filename[PATH_MAX];
+
+	snprintf(modules_filename, PATH_MAX, "%s/modules", dir);
+
+	if (symbol__restricted_filename(modules_filename, "/proc/modules"))
+		return -1;
+
+	if (modules__parse(modules_filename, kci,
+			   kcore_copy__process_modules) < 0)
+		return -1;
+
+	return 0;
+}
+
+static void kcore_copy__map(struct phdr_data *p, u64 start, u64 end, u64 pgoff,
+			    u64 s, u64 e)
+{
+	if (p->addr || s < start || s >= end)
+		return;
+
+	p->addr = s;
+	p->offset = (s - start) + pgoff;
+	p->len = e < end ? e - s : end - s;
+}
+
+static int kcore_copy__read_map(u64 start, u64 len, u64 pgoff, void *data)
+{
+	struct kcore_copy_info *kci = data;
+	u64 end = start + len;
+
+	kcore_copy__map(&kci->kernel_map, start, end, pgoff, kci->stext,
+			kci->etext);
+
+	kcore_copy__map(&kci->modules_map, start, end, pgoff, kci->first_module,
+			kci->last_module_symbol);
+
+	return 0;
+}
+
+static int kcore_copy__read_maps(Elf *elf, struct kcore_copy_info *kci)
+{
+	if (elf_read_maps(elf, true, kcore_copy__read_map, kci) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int kcore_copy__calc_maps(const char *dir, Elf *elf,
+				 struct kcore_copy_info *kci)
+{
+	if (kcore_copy__parse_kallsyms(dir, kci))
+		return -1;
+
+	if (kcore_copy__parse_modules(dir, kci))
+		return -1;
+
+	if (kci->stext)
+		kci->stext = round_down(kci->stext, page_size);
+	else
+		kci->stext = round_down(kci->first_symbol, page_size);
+
+	if (kci->etext) {
+		kci->etext = round_up(kci->etext, page_size);
+	} else if (kci->last_symbol) {
+		kci->etext = round_up(kci->last_symbol, page_size);
+		kci->etext += page_size;
+	}
+
+	kci->first_module = round_down(kci->first_module, page_size);
+
+	if (kci->last_module_symbol) {
+		kci->last_module_symbol = round_up(kci->last_module_symbol,
+						   page_size);
+		kci->last_module_symbol += page_size;
+	}
+
+	if (!kci->stext || !kci->etext)
+		return -1;
+
+	if (kci->first_module && !kci->last_module_symbol)
+		return -1;
+
+	return kcore_copy__read_maps(elf, kci);
+}
+
+static int kcore_copy__copy_file(const char *from_dir, const char *to_dir,
+				 const char *name)
+{
+	char from_filename[PATH_MAX];
+	char to_filename[PATH_MAX];
+
+	snprintf(from_filename, PATH_MAX, "%s/%s", from_dir, name);
+	snprintf(to_filename, PATH_MAX, "%s/%s", to_dir, name);
+
+	return copyfile_mode(from_filename, to_filename, 0400);
+}
+
+static int kcore_copy__unlink(const char *dir, const char *name)
+{
+	char filename[PATH_MAX];
+
+	snprintf(filename, PATH_MAX, "%s/%s", dir, name);
+
+	return unlink(filename);
+}
+
+static int kcore_copy__compare_fds(int from, int to)
+{
+	char buf_from[page_size];
+	char buf_to[page_size];
+	ssize_t ret;
+	size_t len, n;
+
+	while (1) {
+		/* Use read because mmap won't work on proc files */
+		ret = read(from, buf_from, page_size);
+		if (ret < 0)
+			return -1;
+
+		if (!ret)
+			return 0;
+
+		n = ret;
+		len = ret;
+		while (n) {
+			ret = read(to, buf_to, n);
+			if (ret <= 0)
+				return -1;
+			n -= ret;
+		}
+
+		if (memcmp(buf_from, buf_to, len))
+			return -1;
+	}
+}
+
+static int kcore_copy__compare_files(const char *from_filename,
+				     const char *to_filename)
+{
+	int from, to, err = -1;
+
+	from = open(from_filename, O_RDONLY);
+	if (from < 0)
+		return -1;
+
+	to = open(to_filename, O_RDONLY);
+	if (to < 0)
+		goto out_close_from;
+
+	err = kcore_copy__compare_fds(from, to);
+
+	close(to);
+out_close_from:
+	close(from);
+	return err;
+}
+
+static int kcore_copy__compare_file(const char *from_dir, const char *to_dir,
+				    const char *name)
+{
+	char from_filename[PATH_MAX];
+	char to_filename[PATH_MAX];
+
+	snprintf(from_filename, PATH_MAX, "%s/%s", from_dir, name);
+	snprintf(to_filename, PATH_MAX, "%s/%s", to_dir, name);
+
+	return kcore_copy__compare_files(from_filename, to_filename);
+}
+
+/**
+ * kcore_copy - copy kallsyms, modules and kcore from one directory to another.
+ * @from_dir: from directory
+ * @to_dir: to directory
+ *
+ * This function copies kallsyms, modules and kcore files from one directory to
+ * another.  kallsyms and modules are copied entirely.  Only code segments are
+ * copied from kcore.  It is assumed that two segments suffice: one for the
+ * kernel proper and one for all the modules.  The code segments are determined
+ * from kallsyms and modules files.  The kernel map starts at _stext or the
+ * lowest function symbol, and ends at _etext or the highest function symbol.
+ * The module map starts at the lowest module address and ends at the highest
+ * module symbol.  Start addresses are rounded down to the nearest page.  End
+ * addresses are rounded up to the nearest page.  An extra page is added to the
+ * highest kernel symbol and highest module symbol to, hopefully, encompass that
+ * symbol too.  Because it contains only code sections, the resulting kcore is
+ * unusual.  One significant peculiarity is that the mapping (start -> pgoff)
+ * is not the same for the kernel map and the modules map.  That happens because
+ * the data is copied adjacently whereas the original kcore has gaps.  Finally,
+ * kallsyms and modules files are compared with their copies to check that
+ * modules have not been loaded or unloaded while the copies were taking place.
+ *
+ * Return: %0 on success, %-1 on failure.
+ */
+int kcore_copy(const char *from_dir, const char *to_dir)
+{
+	struct kcore kcore;
+	struct kcore extract;
+	size_t count = 2;
+	int index = 0, err = -1;
+	off_t offset = page_size, sz, modules_offset = 0;
+	struct kcore_copy_info kci = {0};
+	char kcore_filename[PATH_MAX];
+	char extract_filename[PATH_MAX];
+
+	if (kcore_copy__copy_file(from_dir, to_dir, "kallsyms"))
+		return -1;
+
+	if (kcore_copy__copy_file(from_dir, to_dir, "modules"))
+		goto out_unlink_kallsyms;
+
+	snprintf(kcore_filename, PATH_MAX, "%s/kcore", from_dir);
+	snprintf(extract_filename, PATH_MAX, "%s/kcore", to_dir);
+
+	if (kcore_open(kcore_filename, &kcore))
+		goto out_unlink_modules;
+
+	if (kcore_copy__calc_maps(from_dir, kcore.elf, &kci))
+		goto out_kcore_close;
+
+	if (kcore_new(extract_filename, &extract, kcore.elfclass, false))
+		goto out_kcore_close;
+
+	if (!kci.modules_map.addr)
+		count -= 1;
+
+	if (kcore_copy_hdr(&kcore, &extract, count))
+		goto out_extract_close;
+
+	if (kcore_add_phdr(&extract, index++, offset, kci.kernel_map.addr,
+			   kci.kernel_map.len))
+		goto out_extract_close;
+
+	if (kci.modules_map.addr) {
+		modules_offset = offset + kci.kernel_map.len;
+		if (kcore_add_phdr(&extract, index, modules_offset,
+				   kci.modules_map.addr, kci.modules_map.len))
+			goto out_extract_close;
+	}
+
+	sz = kcore_write(&extract);
+	if (sz < 0 || sz > offset)
+		goto out_extract_close;
+
+	if (copy_bytes(kcore.fd, kci.kernel_map.offset, extract.fd, offset,
+		       kci.kernel_map.len))
+		goto out_extract_close;
+
+	if (modules_offset && copy_bytes(kcore.fd, kci.modules_map.offset,
+					 extract.fd, modules_offset,
+					 kci.modules_map.len))
+		goto out_extract_close;
+
+	if (kcore_copy__compare_file(from_dir, to_dir, "modules"))
+		goto out_extract_close;
+
+	if (kcore_copy__compare_file(from_dir, to_dir, "kallsyms"))
+		goto out_extract_close;
+
+	err = 0;
+
+out_extract_close:
+	kcore_close(&extract);
+	if (err)
+		unlink(extract_filename);
+out_kcore_close:
+	kcore_close(&kcore);
+out_unlink_modules:
+	if (err)
+		kcore_copy__unlink(to_dir, "modules");
+out_unlink_kallsyms:
+	if (err)
+		kcore_copy__unlink(to_dir, "kallsyms");
+
+	return err;
+}
+
 int create_kcore_extract(struct kcore_extract *kce)
 {
 	struct kcore kcore;
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 0330163..172d25c 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -317,6 +317,12 @@ void delete_kcore_extract(struct kcore_extract *kce __maybe_unused)
 {
 }
 
+int kcore_copy(const char *from_dir __maybe_unused,
+	       const char *to_dir __maybe_unused)
+{
+	return -1;
+}
+
 void symbol__elf_init(void)
 {
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 668dbc3..43b2c85 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -891,6 +891,47 @@ static int read_proc_modules(const char *filename, struct rb_root *modules)
 	return 0;
 }
 
+int compare_proc_modules(const char *from, const char *to)
+{
+	struct rb_root from_modules = RB_ROOT;
+	struct rb_root to_modules = RB_ROOT;
+	struct rb_node *from_node, *to_node;
+	struct module_info *from_m, *to_m;
+	int ret = -1;
+
+	if (read_proc_modules(from, &from_modules))
+		return -1;
+
+	if (read_proc_modules(to, &to_modules))
+		goto out_delete_from;
+
+	from_node = rb_first(&from_modules);
+	to_node = rb_first(&to_modules);
+	while (from_node) {
+		if (!to_node)
+			break;
+
+		from_m = rb_entry(from_node, struct module_info, rb_node);
+		to_m = rb_entry(to_node, struct module_info, rb_node);
+
+		if (from_m->start != to_m->start ||
+		    strcmp(from_m->name, to_m->name))
+			break;
+
+		from_node = rb_next(from_node);
+		to_node = rb_next(to_node);
+	}
+
+	if (!from_node && !to_node)
+		ret = 0;
+
+	delete_modules(&to_modules);
+out_delete_from:
+	delete_modules(&from_modules);
+
+	return ret;
+}
+
 static int do_validate_kcore_modules(const char *filename, struct map *map,
 				  struct map_groups *kmaps)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 54f3ed0..2f1a187 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -270,4 +270,7 @@ struct kcore_extract {
 int create_kcore_extract(struct kcore_extract *kce);
 void delete_kcore_extract(struct kcore_extract *kce);
 
+int kcore_copy(const char *from_dir, const char *to_dir);
+int compare_proc_modules(const char *from, const char *to);
+
 #endif /* __PERF_SYMBOL */
-- 
1.7.11.7

