Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaAWCbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:31:16 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51880 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbaAWCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:30:00 -0500
Subject: [PATCH -tip 5/8] perf-probe: Show source level information for
 address only kprobes
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 23 Jan 2014 02:29:57 +0000
Message-ID: <20140123022957.7206.56546.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the source code level information for address only kprobe
events. Currently the perf probe shows such information only
for symbol-based probes. With this change, perf-probe correctly
parses the address-based events and tries to find the actual
lines of code from the debuginfo.

E.g. without this patch;

# ./perf probe -l
  probe:t_show         (on 0xffffffff810d9720 with m v)
  probe:t_show_1       (on 0xffffffff810e2e40 with m v t)
  probe:t_show_2       (on 0xffffffff810ece30 with m v fmt)
  probe:t_show_3       (on 0xffffffff810f4ad0 with m v file)

With this patch;

# ./perf probe -l
  probe:t_show         (on t_show@linux-3/kernel/trace/ftrace.c with m v)
  probe:t_show_1       (on t_show@linux-3/kernel/trace/trace.c with m v t)
  probe:t_show_2       (on t_show@kernel/trace/trace_printk.c with m v fmt)
  probe:t_show_3       (on t_show@kernel/trace/trace_events.c with m v file)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |   87 ++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 92ab688..3470934 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -153,7 +153,7 @@ static struct dso *kernel_get_module_dso(const char *module)
 	struct map *map;
 	const char *vmlinux_name;
 
-	if (module) {
+	if (module && strcmp(module, "kernel") != 0) {
 		list_for_each_entry(dso, &host_machine->kernel_dsos, node) {
 			if (strncmp(dso->short_name + 1, module,
 				    dso->short_name_len - 2) == 0)
@@ -220,12 +220,22 @@ out:
 static int convert_to_perf_probe_point(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
-	pp->function = strdup(tp->symbol);
+	char buf[128];
+	int ret;
 
+	if (tp->symbol) {
+		pp->function = strdup(tp->symbol);
+		pp->offset = tp->offset;
+	} else {
+		ret = e_snprintf(buf, 128, "0x%" PRIx64, (u64)tp->address);
+		if (ret < 0)
+			return ret;
+		pp->function = strdup(buf);
+		pp->offset = 0;
+	}
 	if (pp->function == NULL)
 		return -ENOMEM;
 
-	pp->offset = tp->offset;
 	pp->retprobe = tp->retprobe;
 
 	return 0;
@@ -261,28 +271,35 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 {
 	struct symbol *sym;
 	struct map *map;
-	u64 addr;
-	int ret = -ENOENT;
+	u64 addr = tp->address;
+	int ret;
 	struct debuginfo *dinfo;
 
-	sym = __find_kernel_function_by_name(tp->symbol, &map);
-	if (sym) {
+	if (!addr) {
+		sym = __find_kernel_function_by_name(tp->symbol, &map);
+		if (!sym) {
+			ret = -ENOENT;
+			goto error;
+		}
 		addr = map->unmap_ip(map, sym->start + tp->offset);
-		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
-			 tp->offset, addr);
+	}
+
+	pr_debug("try to find information at %" PRIx64 " in %s\n", addr,
+		 tp->module ? : "kernel");
 
-		dinfo = debuginfo__new_online_kernel(addr);
-		if (dinfo) {
-			ret = debuginfo__find_probe_point(dinfo,
+	dinfo = debuginfo__new_online_kernel(addr);
+	if (dinfo) {
+		ret = debuginfo__find_probe_point(dinfo,
 						 (unsigned long)addr, pp);
-			debuginfo__delete(dinfo);
-		} else {
-			pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n",
-				 addr);
-			ret = -ENOENT;
-		}
+		debuginfo__delete(dinfo);
+	} else {
+		pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n",
+			 addr);
+		ret = -ENOENT;
 	}
+
 	if (ret <= 0) {
+error:
 		pr_debug("Failed to find corresponding probes from "
 			 "debuginfo. Use kprobe event information.\n");
 		return convert_to_perf_probe_point(tp, pp);
@@ -745,10 +762,13 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 {
 	struct symbol *sym;
 
-	sym = __find_kernel_function_by_name(tp->symbol, NULL);
-	if (!sym) {
-		pr_err("Failed to find symbol %s in kernel.\n", tp->symbol);
-		return -ENOENT;
+	if (tp->symbol) {
+		sym = __find_kernel_function_by_name(tp->symbol, NULL);
+		if (!sym) {
+			pr_err("Failed to find symbol %s in kernel.\n",
+				tp->symbol);
+			return -ENOENT;
+		}
 	}
 
 	return convert_to_perf_probe_point(tp, pp);
@@ -1278,16 +1298,21 @@ static int parse_probe_trace_command(const char *cmd,
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


