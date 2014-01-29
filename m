Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaA2JQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:16:28 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38041 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaA2JPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:15:10 -0500
Subject: [PATCH -tip v2 7/8] perf-probe: Show source-level or symbol-level
 info for uprobes
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 29 Jan 2014 09:15:06 +0000
Message-ID: <20140129091506.22141.98800.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show source-level or symbol-level information for uprobe events.

Without this change;
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d110 in /kbuild/ksrc/linux-3/tools/perf/perf)

With this change;
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on dso__load_vmlinux@util/symbol.c in /kbuild/ksrc/linux-3/tools/perf/perf)

Changes from v1:
 - Rewrite the code based on new series.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |  241 ++++++++++++++++++++++++++---------------
 1 file changed, 150 insertions(+), 91 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 8db172a..1d6ced1 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -222,38 +222,6 @@ out:
 	return ret;
 }
 
-static int convert_to_perf_probe_point(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
-{
-	struct symbol *sym;
-	struct map *map;
-	u64 addr;
-
-	/* _stext based probe point is solved to absolute address */
-	if (tp->symbol && strcmp(tp->symbol, "_stext") == 0) {
-		sym = __find_kernel_function_by_name(tp->symbol, &map);
-		if (!sym)
-			goto failed;
-		addr = map->unmap_ip(map, sym->start + tp->offset);
-		sym = __find_kernel_function(addr, &map);
-		if (!sym)
-			goto failed;
-		pp->function = strdup(sym->name);
-		pp->offset = addr - map->unmap_ip(map, sym->start);
-	} else {
-failed:
-		pp->function = strdup(tp->symbol);
-		pp->offset = tp->offset;
-	}
-
-	if (pp->function == NULL)
-		return -ENOMEM;
-
-	pp->retprobe = tp->retprobe;
-
-	return 0;
-}
-
 #ifdef HAVE_DWARF_SUPPORT
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
@@ -275,48 +243,6 @@ static struct debuginfo *open_debuginfo(const char *module)
 	return debuginfo__new(path);
 }
 
-/*
- * Convert trace point to probe point with debuginfo
- * Currently only handles kprobes.
- */
-static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
-{
-	struct symbol *sym;
-	struct map *map;
-	u64 addr;
-	int ret = -ENOENT;
-	struct debuginfo *dinfo;
-
-	sym = __find_kernel_function_by_name(tp->symbol, &map);
-	if (sym) {
-		addr = map->unmap_ip(map, sym->start + tp->offset);
-		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
-			 tp->offset, addr);
-
-		dinfo = debuginfo__new_online_kernel(addr);
-		if (!dinfo)	/* For kaslr kernel */
-			dinfo = open_debuginfo(tp->module);
-		if (dinfo) {
-			ret = debuginfo__find_probe_point(dinfo,
-						 (unsigned long)addr, pp);
-			debuginfo__delete(dinfo);
-		} else {
-			pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n",
-				 addr);
-			ret = -ENOENT;
-		}
-	}
-	if (ret <= 0) {
-		pr_debug("Failed to find corresponding probes from "
-			 "debuginfo. Use kprobe event information.\n");
-		return convert_to_perf_probe_point(tp, pp);
-	}
-	pp->retprobe = tp->retprobe;
-
-	return 0;
-}
-
 static int get_text_start_address(const char *exec, unsigned long *address)
 {
 	Elf *elf;
@@ -345,6 +271,62 @@ out:
 	return ret;
 }
 
+/*
+ * Convert trace point to probe point with debuginfo
+ */
+static int find_perf_probe_point_from_dwarf(struct probe_trace_point *tp,
+					    struct perf_probe_point *pp,
+					    bool is_kprobe)
+{
+	struct symbol *sym;
+	struct map *map;
+	int ret = -ENOENT;
+	struct debuginfo *dinfo = NULL;
+	unsigned long stext = 0;
+	u64 addr = tp->address;
+
+	/* convert the address to dwarf address */
+	if (!is_kprobe) {
+		if (!addr) {
+			ret = -EINVAL;
+			goto error;
+		}
+		ret = get_text_start_address(tp->module, &stext);
+		if (ret < 0)
+			goto error;
+		addr += stext;
+	} else {
+		sym = __find_kernel_function_by_name(tp->symbol, &map);
+		if (!sym)
+			goto error;
+		addr = map->unmap_ip(map, sym->start + tp->offset);
+	}
+
+	pr_debug("try to find information at %" PRIx64 " in %s\n", addr,
+		 tp->module ? : "kernel");
+
+	if (is_kprobe)
+		dinfo = debuginfo__new_online_kernel(addr);
+	if (!dinfo)	/* For kaslr kernel and uprobes */
+		dinfo = open_debuginfo(tp->module);
+
+	if (dinfo) {
+		ret = debuginfo__find_probe_point(dinfo, (unsigned long)addr, pp);
+		debuginfo__delete(dinfo);
+	} else {
+		pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n", addr);
+		ret = -ENOENT;
+	}
+
+	if (ret > 0) {
+		pp->retprobe = tp->retprobe;
+		return 0;
+	}
+error:
+	pr_debug("Failed to find corresponding probes from debuginfo.\n");
+	return ret ? : -ENOENT;
+}
+
 static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 					  int ntevs, const char *exec)
 {
@@ -798,10 +780,12 @@ out:
 
 #else	/* !HAVE_DWARF_SUPPORT */
 
-static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
+static int
+find_perf_probe_point_from_dwarf(struct probe_trace_point *tp __maybe_unused,
+				 struct perf_probe_point *pp __maybe_unused,
+				 bool is_kprobe __maybe_unused)
 {
-	return convert_to_perf_probe_point(tp, pp);
+	return -ENOSYS;
 }
 
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
@@ -1328,16 +1312,21 @@ static int parse_probe_trace_command(const char *cmd,
 	} else
 		p = argv[1];
 	fmt1_str = strtok_r(p, "+", &fmt);
-	tp->symbol = strdup(fmt1_str);
-	if (tp->symbol == NULL) {
-		ret = -ENOMEM;
-		goto out;
+	if (fmt1_str[0] == '0')	/* only the address started with 0x */
+		tp->address = strtoul(fmt1_str, NULL, 0);
+	else {
+		/* Only the symbol-based probe has offset */
+		tp->symbol = strdup(fmt1_str);
+		if (tp->symbol == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		fmt2_str = strtok_r(NULL, "", &fmt);
+		if (fmt2_str == NULL)
+			tp->offset = 0;
+		else
+			tp->offset = strtoul(fmt2_str, NULL, 10);
 	}
-	fmt2_str = strtok_r(NULL, "", &fmt);
-	if (fmt2_str == NULL)
-		tp->offset = 0;
-	else
-		tp->offset = strtoul(fmt2_str, NULL, 10);
 
 	tev->nargs = argc - 2;
 	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
@@ -1608,6 +1597,80 @@ error:
 	return NULL;
 }
 
+static int find_perf_probe_point_from_map(struct probe_trace_point *tp,
+					  struct perf_probe_point *pp,
+					  bool is_kprobe)
+{
+	struct symbol *sym = NULL;
+	struct map *map;
+	u64 addr;
+	int ret = -ENOENT;
+
+	/* _stext based probe point is solved to absolute address */
+	if (tp->symbol && strcmp(tp->symbol, "_stext") == 0) {
+		sym = __find_kernel_function_by_name(tp->symbol, &map);
+		if (!sym)
+			goto out;
+		addr = map->unmap_ip(map, sym->start + tp->offset);
+		sym = __find_kernel_function(addr, &map);
+	} else if (!is_kprobe) {
+		map = dso__new_map(tp->module);
+		if (!map)
+			goto out;
+		addr = tp->address;
+		sym = map__find_symbol(map, addr, NULL);
+	}
+	if (!sym)
+		goto out;
+
+	pp->retprobe = tp->retprobe;
+	pp->offset = addr - map->unmap_ip(map, sym->start);
+	pp->function = strdup(sym->name);
+	ret = pp->function ? 0 : -ENOMEM;
+
+out:
+	if (map && !is_kprobe) {
+		dso__delete(map->dso);
+		map__delete(map);
+	}
+
+	return ret;
+}
+
+static int convert_to_perf_probe_point(struct probe_trace_point *tp,
+					struct perf_probe_point *pp,
+					bool is_kprobe)
+{
+	char buf[128];
+	int ret;
+
+	ret = find_perf_probe_point_from_dwarf(tp, pp, is_kprobe);
+	if (!ret)
+		return 0;
+	ret = find_perf_probe_point_from_map(tp, pp, is_kprobe);
+	if (!ret)
+		return 0;
+
+	pr_debug("Failed to find probe point from both of dwarf and map.\n");
+
+	if (tp->symbol) {
+		pp->function = strdup(tp->symbol);
+		pp->offset = tp->offset;
+	} else if (!tp->module && !is_kprobe) {
+		ret = e_snprintf(buf, 128, "0x%" PRIx64, (u64)tp->address);
+		if (ret < 0)
+			return ret;
+		pp->function = strdup(buf);
+		pp->offset = 0;
+	}
+	if (pp->function == NULL)
+		return -ENOMEM;
+
+	pp->retprobe = tp->retprobe;
+
+	return 0;
+}
+
 static int convert_to_perf_probe_event(struct probe_trace_event *tev,
 			       struct perf_probe_event *pev, bool is_kprobe)
 {
@@ -1621,11 +1684,7 @@ static int convert_to_perf_probe_event(struct probe_trace_event *tev,
 		return -ENOMEM;
 
 	/* Convert trace_point to probe_point */
-	if (is_kprobe)
-		ret = kprobe_convert_to_perf_probe(&tev->point, &pev->point);
-	else
-		ret = convert_to_perf_probe_point(&tev->point, &pev->point);
-
+	ret = convert_to_perf_probe_point(&tev->point, &pev->point, is_kprobe);
 	if (ret < 0)
 		return ret;
 


