Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaBVSBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:01:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41236 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaBVSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:01:39 -0500
Date: Sat, 22 Feb 2014 10:01:20 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-5a6f63145491f905de1c5c6c46c5cd62c004d0d1@git.kernel.org>
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
In-Reply-To: <20140206053223.29635.51280.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053223.29635.51280.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Show source-level or symbol-level info for uprobes
Git-Commit-ID: 5a6f63145491f905de1c5c6c46c5cd62c004d0d1
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

Commit-ID:  5a6f63145491f905de1c5c6c46c5cd62c004d0d1
Gitweb:     http://git.kernel.org/tip/5a6f63145491f905de1c5c6c46c5cd62c004d0d1
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 6 Feb 2014 05:32:23 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:51 -0300

perf probe: Show source-level or symbol-level info for uprobes

Show source-level or symbol-level information for uprobe events.

Without this change;
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d110 in /kbuild/ksrc/linux-3/tools/perf/perf)

With this change;
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on dso__load_vmlinux@util/symbol.c in /kbuild/ksrc/linux-3/tools/perf/perf)

Changes from v2:
 - Update according to previous patches.

Changes from v1:
 - Rewrite the code based on new series.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053223.29635.51280.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 227 +++++++++++++++++++++++++++---------------
 1 file changed, 144 insertions(+), 83 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f86820c..3c35b7a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -249,34 +249,6 @@ out:
 	return ret;
 }
 
-static int convert_to_perf_probe_point(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
-{
-	struct symbol *sym;
-	struct map *map;
-	u64 addr = kernel_get_symbol_address_by_name(tp->symbol, true);
-
-	if (addr) {
-		addr += tp->offset;
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
@@ -298,44 +270,6 @@ static struct debuginfo *open_debuginfo(const char *module)
 	return debuginfo__new(path);
 }
 
-/*
- * Convert trace point to probe point with debuginfo
- * Currently only handles kprobes.
- */
-static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
-{
-	u64 addr = 0;
-	int ret = -ENOENT;
-	struct debuginfo *dinfo;
-
-	addr = kernel_get_symbol_address_by_name(tp->symbol, false);
-	if (addr) {
-		addr += tp->offset;
-		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
-			 tp->offset, addr);
-
-		dinfo = open_debuginfo(tp->module);
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
@@ -364,6 +298,57 @@ out:
 	return ret;
 }
 
+/*
+ * Convert trace point to probe point with debuginfo
+ */
+static int find_perf_probe_point_from_dwarf(struct probe_trace_point *tp,
+					    struct perf_probe_point *pp,
+					    bool is_kprobe)
+{
+	struct debuginfo *dinfo = NULL;
+	unsigned long stext = 0;
+	u64 addr = tp->address;
+	int ret = -ENOENT;
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
+		addr = kernel_get_symbol_address_by_name(tp->symbol, false);
+		if (addr == 0)
+			goto error;
+		addr += tp->offset;
+	}
+
+	pr_debug("try to find information at %" PRIx64 " in %s\n", addr,
+		 tp->module ? : "kernel");
+
+	dinfo = open_debuginfo(tp->module);
+	if (dinfo) {
+		ret = debuginfo__find_probe_point(dinfo,
+						 (unsigned long)addr, pp);
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
@@ -815,10 +800,12 @@ out:
 
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
@@ -1343,16 +1330,21 @@ static int parse_probe_trace_command(const char *cmd,
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
@@ -1623,6 +1615,79 @@ error:
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
+	if (!is_kprobe) {
+		map = dso__new_map(tp->module);
+		if (!map)
+			goto out;
+		addr = tp->address;
+		sym = map__find_symbol(map, addr, NULL);
+	} else {
+		addr = kernel_get_symbol_address_by_name(tp->symbol, true);
+		if (addr) {
+			addr += tp->offset;
+			sym = __find_kernel_function(addr, &map);
+		}
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
@@ -1636,11 +1701,7 @@ static int convert_to_perf_probe_event(struct probe_trace_event *tev,
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
 
