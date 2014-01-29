Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaA2JRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:17:17 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49226 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaA2JPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:15:07 -0500
Subject: [PATCH -tip v2 6/8] perf-probe: Show appropriate symbol for _stext
 based kprobes
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 29 Jan 2014 09:15:04 +0000
Message-ID: <20140129091504.22141.58965.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show appropriate symbol for _stext based kprobes instead
of _stext+offset when perf-probe -l runs without debuginfo.

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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b35f047..8db172a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -125,6 +125,11 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
 						     NULL);
 }
 
+static struct symbol *__find_kernel_function(u64 addr, struct map **mapp)
+{
+	return machine__find_kernel_function(host_machine, addr, mapp, NULL);
+}
+
 static struct map *kernel_get_module_map(const char *module)
 {
 	struct rb_node *nd;
@@ -220,12 +225,30 @@ out:
 static int convert_to_perf_probe_point(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
-	pp->function = strdup(tp->symbol);
+	struct symbol *sym;
+	struct map *map;
+	u64 addr;
+
+	/* _stext based probe point is solved to absolute address */
+	if (tp->symbol && strcmp(tp->symbol, "_stext") == 0) {
+		sym = __find_kernel_function_by_name(tp->symbol, &map);
+		if (!sym)
+			goto failed;
+		addr = map->unmap_ip(map, sym->start + tp->offset);
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


