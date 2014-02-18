Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBRVM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:12:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35726 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaBRVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:12 -0500
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
Subject: [PATCH 29/32] perf probe: Show appropriate symbol for ref_reloc_sym based kprobes
Date: Tue, 18 Feb 2014 18:08:48 -0300
Message-Id: <1392757731-32619-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Show appropriate symbol for ref_reloc_sym based kprobes instead of
refpoint+offset when perf-probe -l runs without debuginfo.

Without this change:
  # ./perf probe -l
    probe:t_show         (on _stext+889880 with m v)
    probe:t_show_1       (on _stext+928568 with m v t)
    probe:t_show_2       (on _stext+969512 with m v fmt)
    probe:t_show_3       (on _stext+1001416 with m v file)

With this change:
  # ./perf probe -l
    probe:t_show         (on t_show with m v)
    probe:t_show_1       (on t_show with m v t)
    probe:t_show_2       (on t_show with m v fmt)
    probe:t_show_3       (on t_show with m v file)

Changes from v2:
 - Check ref_reloc_sym to find correct unrelocated address.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053220.29635.81819.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 83 ++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 8e34c8d47813..f86820c39ea4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -121,6 +121,42 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
 						     NULL);
 }
 
+static struct symbol *__find_kernel_function(u64 addr, struct map **mapp)
+{
+	return machine__find_kernel_function(host_machine, addr, mapp, NULL);
+}
+
+static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
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
+static u64 kernel_get_symbol_address_by_name(const char *name, bool reloc)
+{
+	struct ref_reloc_sym *reloc_sym;
+	struct symbol *sym;
+	struct map *map;
+
+	/* ref_reloc_sym is just a label. Need a special fix*/
+	reloc_sym = kernel_get_ref_reloc_sym();
+	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
+		return (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
+	else {
+		sym = __find_kernel_function_by_name(name, &map);
+		if (sym)
+			return map->unmap_ip(map, sym->start) -
+				(reloc) ? 0 : map->reloc;
+	}
+	return 0;
+}
+
 static struct map *kernel_get_module_map(const char *module)
 {
 	struct rb_node *nd;
@@ -216,12 +252,26 @@ out:
 static int convert_to_perf_probe_point(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
-	pp->function = strdup(tp->symbol);
+	struct symbol *sym;
+	struct map *map;
+	u64 addr = kernel_get_symbol_address_by_name(tp->symbol, true);
+
+	if (addr) {
+		addr += tp->offset;
+		sym = __find_kernel_function(addr, &map);
+		if (!sym)
+			goto failed;
+		pp->function = strdup(sym->name);
+		pp->offset = addr - map->unmap_ip(map, sym->start);
+	} else {
+failed:
+		pp->function = strdup(tp->symbol);
+		pp->offset = tp->offset;
+	}
 
 	if (pp->function == NULL)
 		return -ENOMEM;
 
-	pp->offset = tp->offset;
 	pp->retprobe = tp->retprobe;
 
 	return 0;
@@ -248,18 +298,6 @@ static struct debuginfo *open_debuginfo(const char *module)
 	return debuginfo__new(path);
 }
 
-static struct ref_reloc_sym *__kernel_get_ref_reloc_sym(void)
-{
-	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
-	struct kmap *kmap;
-
-	if (map__load(host_machine->vmlinux_maps[MAP__FUNCTION], NULL) < 0)
-		return NULL;
-
-	kmap = map__kmap(host_machine->vmlinux_maps[MAP__FUNCTION]);
-	return kmap->ref_reloc_sym;
-}
-
 /*
  * Convert trace point to probe point with debuginfo
  * Currently only handles kprobes.
@@ -267,24 +305,13 @@ static struct ref_reloc_sym *__kernel_get_ref_reloc_sym(void)
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
-	struct symbol *sym;
-	struct ref_reloc_sym *reloc_sym;
-	struct map *map;
 	u64 addr = 0;
 	int ret = -ENOENT;
 	struct debuginfo *dinfo;
 
-	/* ref_reloc_sym is just a label. Need a special fix*/
-	reloc_sym = __kernel_get_ref_reloc_sym();
-	if (reloc_sym && strcmp(tp->symbol, reloc_sym->name) == 0)
-		addr = reloc_sym->unrelocated_addr + tp->offset;
-	else {
-		sym = __find_kernel_function_by_name(tp->symbol, &map);
-		if (sym)
-			addr = map->unmap_ip(map, sym->start + tp->offset) -
-				map->reloc;
-	}
+	addr = kernel_get_symbol_address_by_name(tp->symbol, false);
 	if (addr) {
+		addr += tp->offset;
 		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
 			 tp->offset, addr);
 
@@ -420,7 +447,7 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 	if (module)
 		return add_module_to_probe_trace_events(tevs, ntevs, module);
 
-	reloc_sym = __kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym();
 	if (!reloc_sym) {
 		pr_warning("Relocated base symbol is not found!\n");
 		return -EINVAL;
-- 
1.8.1.4

