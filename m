Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaAWCaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:30:08 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40737 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbaAWCaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:30:05 -0500
Subject: [PATCH -tip 7/8] perf-probe: Show source-level or symbol-level info
 for uprobes
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 23 Jan 2014 02:30:01 +0000
Message-ID: <20140123023001.7206.95762.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |  149 ++++++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 61 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index bf1d73b..84c1807 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -224,42 +224,6 @@ out:
 	return ret;
 }
 
-static int convert_to_perf_probe_point(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
-{
-	char buf[128];
-	int ret;
-	struct symbol *sym;
-	struct map *map;
-	u64 addr;
-
-	if (!tp->symbol) {
-		sym = __find_kernel_function(tp->address, &map);
-		if (sym) {
-			pp->function = strdup(sym->name);
-			addr = map->unmap_ip(map, sym->start);
-			pp->offset = tp->address - addr;
-		} else {
-			ret = e_snprintf(buf, 128, "0x%" PRIx64,
-					 (u64)tp->address);
-			if (ret < 0)
-				return ret;
-			pp->function = strdup(buf);
-			pp->offset = 0;
-		}
-	} else {
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
@@ -285,8 +249,9 @@ static struct debuginfo *open_debuginfo(const char *module)
  * Convert trace point to probe point with debuginfo
  * Currently only handles kprobes.
  */
-static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
+static int find_perf_probe_point_from_dwarf(struct probe_trace_point *tp,
+					    struct perf_probe_point *pp,
+					    bool is_kprobe)
 {
 	struct symbol *sym;
 	struct map *map;
@@ -306,7 +271,11 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	pr_debug("try to find information at %" PRIx64 " in %s\n", addr,
 		 tp->module ? : "kernel");
 
-	dinfo = debuginfo__new_online_kernel(addr);
+	if (is_kprobe)
+		dinfo = debuginfo__new_online_kernel(addr);
+	else
+		dinfo = open_debuginfo(tp->module);
+
 	if (dinfo) {
 		ret = debuginfo__find_probe_point(dinfo,
 						 (unsigned long)addr, pp);
@@ -319,9 +288,8 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 
 	if (ret <= 0) {
 error:
-		pr_debug("Failed to find corresponding probes from "
-			 "debuginfo. Use kprobe event information.\n");
-		return convert_to_perf_probe_point(tp, pp);
+		pr_debug("Failed to find corresponding probes from debuginfo.\n");
+		return ret ? : -ENOENT;
 	}
 	pp->retprobe = tp->retprobe;
 
@@ -776,21 +744,12 @@ out:
 
 #else	/* !HAVE_DWARF_SUPPORT */
 
-static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
+static int
+find_perf_probe_point_from_dwarf(struct probe_trace_point *tp __maybe_unused,
+				 struct perf_probe_point *pp __maybe_unused,
+				 bool is_kprobe __maybe_unused)
 {
-	struct symbol *sym;
-
-	if (tp->symbol) {
-		sym = __find_kernel_function_by_name(tp->symbol, NULL);
-		if (!sym) {
-			pr_err("Failed to find symbol %s in kernel.\n",
-				tp->symbol);
-			return -ENOENT;
-		}
-	}
-
-	return convert_to_perf_probe_point(tp, pp);
+	return -ENOSYS;
 }
 
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
@@ -1609,6 +1568,78 @@ error:
 	return NULL;
 }
 
+static int find_perf_probe_point_from_map(struct probe_trace_point *tp,
+					  struct perf_probe_point *pp,
+					  bool is_kprobe)
+{
+	struct symbol *sym = NULL;
+	struct map *map = NULL;
+	u64 addr;
+	int ret = 0;
+
+	if (is_kprobe)
+		sym = __find_kernel_function(tp->address, &map);
+	else if (tp->module) {
+		map = dso__new_map(tp->module);
+		if (map)
+			sym = map__find_symbol(map, tp->address, NULL);
+	}
+
+	if (!sym) {
+		pr_debug("Failed to find symbol at %lx from map.\n",
+			 tp->address);
+		ret = -ENOMEM;
+	} else {
+		addr = map->unmap_ip(map, sym->start);
+		pp->offset = tp->address - addr;
+		pp->function = strdup(sym->name);
+		if (!pp->function)
+			ret = -ENOMEM;
+	}
+
+	if (map && !is_kprobe) {
+		dso__delete(map->dso);
+		map__delete(map);
+	}
+	pp->retprobe = tp->retprobe;
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
+	if (!tp->symbol) {
+		ret = find_perf_probe_point_from_map(tp, pp, is_kprobe);
+		if (!ret)
+			return 0;
+	}
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
@@ -1622,11 +1653,7 @@ static int convert_to_perf_probe_event(struct probe_trace_event *tev,
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
 


