Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaKCH2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:28:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59096 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaKCH2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:28:02 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/8] perf tools: Preparation for compressed kernel module support
Date: Mon,  3 Nov 2014 16:27:51 +0900
Message-Id: <1414999678-31377-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic support to handle compressed kernel module as
some distro (such as Archlinux) carries on it now.  The actual work
using compression library will be added later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c        | 74 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dso.h        |  7 +++++
 tools/perf/util/machine.c    | 19 +++++++++++-
 tools/perf/util/symbol-elf.c | 35 ++++++++++++++++++++-
 tools/perf/util/symbol.c     |  8 ++++-
 5 files changed, 140 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 0247acfdfaca..3293e2e21814 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -21,8 +21,10 @@ char dso__symtab_origin(const struct dso *dso)
 		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]		= 'b',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]		= 'd',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]		= 'K',
+		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP]	= 'm',
 		[DSO_BINARY_TYPE__GUEST_KALLSYMS]		= 'g',
 		[DSO_BINARY_TYPE__GUEST_KMODULE]		= 'G',
+		[DSO_BINARY_TYPE__GUEST_KMODULE_COMP]		= 'M',
 		[DSO_BINARY_TYPE__GUEST_VMLINUX]		= 'V',
 	};
 
@@ -112,11 +114,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
 		break;
 
 	case DSO_BINARY_TYPE__GUEST_KMODULE:
+	case DSO_BINARY_TYPE__GUEST_KMODULE_COMP:
 		path__join3(filename, size, symbol_conf.symfs,
 			    root_dir, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP:
 		__symbol__join_symfs(filename, size, dso->long_name);
 		break;
 
@@ -137,6 +141,76 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	return ret;
 }
 
+static int decompress_dummy(const char *input __maybe_unused,
+			    int output __maybe_unused)
+{
+	return -1;
+}
+
+static const struct {
+	const char *fmt;
+	int (*decompress)(const char *input, int output);
+} compressions[] = {
+	{ "gz", decompress_dummy },
+};
+
+bool is_supported_compression(const char *ext)
+{
+	unsigned i;
+
+	for (i = 0; i < ARRAY_SIZE(compressions); i++) {
+		if (!strcmp(ext, compressions[i].fmt))
+			return true;
+	}
+	return false;
+}
+
+bool is_kmodule_extension(const char *ext)
+{
+	if (!strcmp(ext, "ko"))
+		return true;
+
+	if (ext[2] == '\0' || (ext[2] == '.' && is_supported_compression(ext+3)))
+		return true;
+
+	return false;
+}
+
+bool is_kernel_module(const char *pathname, bool *compressed)
+{
+	const char *ext = strrchr(pathname, '.');
+
+	if (ext == NULL)
+		return false;
+
+	if (is_supported_compression(ext + 1)) {
+		if (compressed)
+			*compressed = true;
+		ext -= 3;
+	} else if (compressed)
+		*compressed = false;
+
+	return is_kmodule_extension(ext + 1);
+}
+
+bool decompress_to_file(const char *ext, const char *filename, int output_fd)
+{
+	unsigned i;
+
+	for (i = 0; i < ARRAY_SIZE(compressions); i++) {
+		if (!strcmp(ext, compressions[i].fmt))
+			return !compressions[i].decompress(filename,
+							   output_fd);
+	}
+	return false;
+}
+
+bool dso__needs_decompress(struct dso *dso)
+{
+	return dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE_COMP;
+}
+
 /*
  * Global list of open DSOs and the counter.
  */
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index a316e4af321f..3782c82c6e44 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -22,7 +22,9 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
+	DSO_BINARY_TYPE__GUEST_KMODULE_COMP,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP,
 	DSO_BINARY_TYPE__KCORE,
 	DSO_BINARY_TYPE__GUEST_KCORE,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
@@ -185,6 +187,11 @@ int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
 char dso__symtab_origin(const struct dso *dso);
 int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
 				   char *root_dir, char *filename, size_t size);
+bool is_supported_compression(const char *ext);
+bool is_kmodule_extension(const char *ext);
+bool is_kernel_module(const char *pathname, bool *compressed);
+bool decompress_to_file(const char *ext, const char *filename, int output_fd);
+bool dso__needs_decompress(struct dso *dso);
 
 /*
  * The dso__data_* external interface provides following functions:
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 51a630301afa..946c7d62cb6e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -464,6 +464,7 @@ struct map *machine__new_module(struct machine *machine, u64 start,
 {
 	struct map *map;
 	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, filename);
+	bool compressed;
 
 	if (dso == NULL)
 		return NULL;
@@ -476,6 +477,11 @@ struct map *machine__new_module(struct machine *machine, u64 start,
 		dso->symtab_type = DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE;
 	else
 		dso->symtab_type = DSO_BINARY_TYPE__GUEST_KMODULE;
+
+	/* _KMODULE_COMP should be next to _KMODULE */
+	if (is_kernel_module(filename, &compressed) && compressed)
+		dso->symtab_type++;
+
 	map_groups__insert(&machine->kmaps, map);
 	return map;
 }
@@ -861,8 +867,14 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 			struct map *map;
 			char *long_name;
 
-			if (dot == NULL || strcmp(dot, ".ko"))
+			if (dot == NULL)
 				continue;
+
+			/* On some system, modules are compressed like .ko.gz */
+			if (is_supported_compression(dot + 1) &&
+			    is_kmodule_extension(dot - 2))
+				dot -= 3;
+
 			snprintf(dso_name, sizeof(dso_name), "[%.*s]",
 				 (int)(dot - dent->d_name), dent->d_name);
 
@@ -1044,6 +1056,11 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 			dot = strrchr(name, '.');
 			if (dot == NULL)
 				goto out_problem;
+			/* On some system, modules are compressed like .ko.gz */
+			if (is_supported_compression(dot + 1))
+				dot -= 3;
+			if (!is_kmodule_extension(dot + 1))
+				goto out_problem;
 			snprintf(short_module_name, sizeof(short_module_name),
 					"[%.*s]", (int)(dot - name), name);
 			strxfrchar(short_module_name, '-', '_');
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 1e23a5bfb044..efc7eb6b8f0f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -546,6 +546,35 @@ static int dso__swap_init(struct dso *dso, unsigned char eidata)
 	return 0;
 }
 
+static int decompress_kmodule(struct dso *dso, const char *name,
+			      enum dso_binary_type type)
+{
+	int fd;
+	const char *ext = strrchr(name, '.');
+	char tmpbuf[] = "/tmp/perf-kmod-XXXXXX";
+
+	if ((type != DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP &&
+	     type != DSO_BINARY_TYPE__GUEST_KMODULE_COMP) ||
+	    type != dso->symtab_type)
+		return -1;
+
+	if (!ext || !is_supported_compression(ext + 1))
+		return -1;
+
+	fd = mkstemp(tmpbuf);
+	if (fd < 0)
+		return -1;
+
+	if (!decompress_to_file(ext + 1, name, fd)) {
+		close(fd);
+		fd = -1;
+	}
+
+	unlink(tmpbuf);
+
+	return fd;
+}
+
 bool symsrc__possibly_runtime(struct symsrc *ss)
 {
 	return ss->dynsym || ss->opdsec;
@@ -571,7 +600,11 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 	Elf *elf;
 	int fd;
 
-	fd = open(name, O_RDONLY);
+	if (dso__needs_decompress(dso))
+		fd = decompress_kmodule(dso, name, type);
+	else
+		fd = open(name, O_RDONLY);
+
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 078331140d8c..c69915c9d5bc 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -51,7 +51,9 @@ static enum dso_binary_type binary_type_symtab[] = {
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
+	DSO_BINARY_TYPE__GUEST_KMODULE_COMP,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
@@ -1300,7 +1302,9 @@ static bool dso__is_compatible_symtab_type(struct dso *dso, bool kmod,
 		return dso->kernel == DSO_TYPE_GUEST_KERNEL;
 
 	case DSO_BINARY_TYPE__GUEST_KMODULE:
+	case DSO_BINARY_TYPE__GUEST_KMODULE_COMP:
 	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP:
 		/*
 		 * kernel modules know their symtab type - it's set when
 		 * creating a module dso in machine__new_module().
@@ -1368,7 +1372,9 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 		return -1;
 
 	kmod = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
-		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
+		dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE_COMP;
 
 	/*
 	 * Iterate over candidate debug images.
-- 
2.1.2

