Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaBRVOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:14:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35713 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaBRVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 28/32] perf probe: Find given address from offline dwarf
Date: Tue, 18 Feb 2014 18:08:47 -0300
Message-Id: <1392757731-32619-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Find the given address from offline dwarfs instead of online kernel
dwarfs.

On the KASLR enabled kernel, the kernel text section is loaded with
random offset, and the debuginfo__new_online_kernel can't handle it. So
let's move to the offline dwarf loader instead of using the online dwarf
loader.

As a result, since we don't need debuginfo__new_online_kernel any more,
this also removes the functions related to that.

Without this change;

  # ./perf probe -l
    probe:t_show         (on _stext+901288 with m v)
    probe:t_show_1       (on _stext+939624 with m v t)
    probe:t_show_2       (on _stext+980296 with m v fmt)
    probe:t_show_3       (on _stext+1014392 with m v file)

With this change;

  # ./perf probe -l
    probe:t_show         (on t_show@linux-3/kernel/trace/ftrace.c with m v)
    probe:t_show_1       (on t_show@linux-3/kernel/trace/trace.c with m v t)
    probe:t_show_2       (on t_show@kernel/trace/trace_printk.c with m v fmt)
    probe:t_show_3       (on t_show@kernel/trace/trace_events.c with m v file)

Changes from v2:
 - Instead of retrying, directly opens offline dwarf.
 - Remove debuginfo__new_online_kernel and related functions.
 - Refer map->reloc to get the correct address of a symbol.
 - Add a special case for handling ref_reloc_sym based address.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053218.29635.74821.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  | 40 +++++++++++++-------
 tools/perf/util/probe-finder.c | 86 ------------------------------------------
 tools/perf/util/probe-finder.h |  1 -
 3 files changed, 26 insertions(+), 101 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1ce2cb9845b6..8e34c8d47813 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -248,6 +248,18 @@ static struct debuginfo *open_debuginfo(const char *module)
 	return debuginfo__new(path);
 }
 
+static struct ref_reloc_sym *__kernel_get_ref_reloc_sym(void)
+{
+	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
+	struct kmap *kmap;
+
+	if (map__load(host_machine->vmlinux_maps[MAP__FUNCTION], NULL) < 0)
+		return NULL;
+
+	kmap = map__kmap(host_machine->vmlinux_maps[MAP__FUNCTION]);
+	return kmap->ref_reloc_sym;
+}
+
 /*
  * Convert trace point to probe point with debuginfo
  * Currently only handles kprobes.
@@ -256,18 +268,27 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
 	struct symbol *sym;
+	struct ref_reloc_sym *reloc_sym;
 	struct map *map;
-	u64 addr;
+	u64 addr = 0;
 	int ret = -ENOENT;
 	struct debuginfo *dinfo;
 
-	sym = __find_kernel_function_by_name(tp->symbol, &map);
-	if (sym) {
-		addr = map->unmap_ip(map, sym->start + tp->offset);
+	/* ref_reloc_sym is just a label. Need a special fix*/
+	reloc_sym = __kernel_get_ref_reloc_sym();
+	if (reloc_sym && strcmp(tp->symbol, reloc_sym->name) == 0)
+		addr = reloc_sym->unrelocated_addr + tp->offset;
+	else {
+		sym = __find_kernel_function_by_name(tp->symbol, &map);
+		if (sym)
+			addr = map->unmap_ip(map, sym->start + tp->offset) -
+				map->reloc;
+	}
+	if (addr) {
 		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
 			 tp->offset, addr);
 
-		dinfo = debuginfo__new_online_kernel(addr);
+		dinfo = open_debuginfo(tp->module);
 		if (dinfo) {
 			ret = debuginfo__find_probe_point(dinfo,
 						 (unsigned long)addr, pp);
@@ -383,15 +404,6 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 	return ret;
 }
 
-static struct ref_reloc_sym *__kernel_get_ref_reloc_sym(void)
-{
-	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
-	struct kmap *kmap;
-
-	kmap = map__kmap(host_machine->vmlinux_maps[MAP__FUNCTION]);
-	return kmap->ref_reloc_sym;
-}
-
 /* Post processing the probe events */
 static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 					   int ntevs, const char *module,
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e5e589fdef9b..4f6e277c457c 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -89,79 +89,6 @@ error:
 	return -ENOENT;
 }
 
-#if _ELFUTILS_PREREQ(0, 148)
-/* This method is buggy if elfutils is older than 0.148 */
-static int __linux_kernel_find_elf(Dwfl_Module *mod,
-				   void **userdata,
-				   const char *module_name,
-				   Dwarf_Addr base,
-				   char **file_name, Elf **elfp)
-{
-	int fd;
-	const char *path = kernel_get_module_path(module_name);
-
-	pr_debug2("Use file %s for %s\n", path, module_name);
-	if (path) {
-		fd = open(path, O_RDONLY);
-		if (fd >= 0) {
-			*file_name = strdup(path);
-			return fd;
-		}
-	}
-	/* If failed, try to call standard method */
-	return dwfl_linux_kernel_find_elf(mod, userdata, module_name, base,
-					  file_name, elfp);
-}
-
-static const Dwfl_Callbacks kernel_callbacks = {
-	.find_debuginfo = dwfl_standard_find_debuginfo,
-	.debuginfo_path = &debuginfo_path,
-
-	.find_elf = __linux_kernel_find_elf,
-	.section_address = dwfl_linux_kernel_module_section_address,
-};
-
-/* Get a Dwarf from live kernel image */
-static int debuginfo__init_online_kernel_dwarf(struct debuginfo *dbg,
-					       Dwarf_Addr addr)
-{
-	dbg->dwfl = dwfl_begin(&kernel_callbacks);
-	if (!dbg->dwfl)
-		return -EINVAL;
-
-	/* Load the kernel dwarves: Don't care the result here */
-	dwfl_linux_kernel_report_kernel(dbg->dwfl);
-	dwfl_linux_kernel_report_modules(dbg->dwfl);
-
-	dbg->dbg = dwfl_addrdwarf(dbg->dwfl, addr, &dbg->bias);
-	/* Here, check whether we could get a real dwarf */
-	if (!dbg->dbg) {
-		pr_debug("Failed to find kernel dwarf at %lx\n",
-			 (unsigned long)addr);
-		dwfl_end(dbg->dwfl);
-		memset(dbg, 0, sizeof(*dbg));
-		return -ENOENT;
-	}
-
-	return 0;
-}
-#else
-/* With older elfutils, this just support kernel module... */
-static int debuginfo__init_online_kernel_dwarf(struct debuginfo *dbg,
-					       Dwarf_Addr addr __maybe_unused)
-{
-	const char *path = kernel_get_module_path("kernel");
-
-	if (!path) {
-		pr_err("Failed to find vmlinux path\n");
-		return -ENOENT;
-	}
-
-	pr_debug2("Use file %s for debuginfo\n", path);
-	return debuginfo__init_offline_dwarf(dbg, path);
-}
-#endif
-
 struct debuginfo *debuginfo__new(const char *path)
 {
 	struct debuginfo *dbg = zalloc(sizeof(*dbg));
@@ -174,19 +101,6 @@ struct debuginfo *debuginfo__new(const char *path)
 	return dbg;
 }
 
-struct debuginfo *debuginfo__new_online_kernel(unsigned long addr)
-{
-	struct debuginfo *dbg = zalloc(sizeof(*dbg));
-
-	if (!dbg)
-		return NULL;
-
-	if (debuginfo__init_online_kernel_dwarf(dbg, (Dwarf_Addr)addr) < 0)
-		zfree(&dbg);
-
-	return dbg;
-}
-
 void debuginfo__delete(struct debuginfo *dbg)
 {
 	if (dbg) {
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 592c4dac3be9..3fc597365ce6 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -31,7 +31,6 @@ struct debuginfo {
 };
 
 extern struct debuginfo *debuginfo__new(const char *path);
-extern struct debuginfo *debuginfo__new_online_kernel(unsigned long addr);
 extern void debuginfo__delete(struct debuginfo *dbg);
 
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
-- 
1.8.1.4

