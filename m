Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaBVSBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:01:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaBVSB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:01:29 -0500
Date: Sat, 22 Feb 2014 10:01:09 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-8f33f7deac485a61f38aa690b85489322a4d958e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dave.long@linaro.org, hpa@zytor.com, mingo@kernel.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20140206053220.29635.81819.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053220.29635.81819.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Show appropriate symbol for ref_reloc_sym based kprobes
Git-Commit-ID: 8f33f7deac485a61f38aa690b85489322a4d958e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f33f7deac485a61f38aa690b85489322a4d958e
Gitweb:     http://git.kernel.org/tip/8f33f7deac485a61f38aa690b85489322a4d958e
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 6 Feb 2014 05:32:20 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:51 -0300

perf probe: Show appropriate symbol for ref_reloc_sym based kprobes

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
index 8e34c8d..f86820c 100644
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
