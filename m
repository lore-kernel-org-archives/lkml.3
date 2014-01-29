Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaA2JPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:15:13 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43027 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaA2JPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:15:04 -0500
Subject: [PATCH -tip v2 4/8] perf-probe: Use _stext based address instead of
 the symbol name
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 29 Jan 2014 09:14:59 +0000
Message-ID: <20140129091459.22141.29467.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since several local symbols can have same name (e.g. t_show),
we need to use the relative address from _stext instead of
the target symbol name. Because the kernel address space layout
randomize (kaslr) changes the absolute address of kernel symbols,
we can't relay on the absolute address.
Note that this works only with debuginfo.

E.g. without this change;
  ----
  # ./perf probe -a "t_show \$vars"
  Added new events:
    probe:t_show         (on t_show with $vars)
    probe:t_show_1       (on t_show with $vars)
    probe:t_show_2       (on t_show with $vars)
    probe:t_show_3       (on t_show with $vars)

  You can now use it in all perf tools, such as:

          perf record -e probe:t_show_3 -aR sleep 1
  ----
OK, we have 4 different t_show()s. All functions have
different arguments as below;
  ----
  # cat /sys/kernel/debug/tracing/kprobe_events
  p:probe/t_show t_show m=%di:u64 v=%si:u64
  p:probe/t_show_1 t_show m=%di:u64 v=%si:u64 t=%si:u64
  p:probe/t_show_2 t_show m=%di:u64 v=%si:u64 fmt=%si:u64
  p:probe/t_show_3 t_show m=%di:u64 v=%si:u64 file=%si:u64
  ----
However, all of them have been put on the *same* address.
  ----
  # cat /sys/kernel/debug/kprobes/list
  ffffffff810d9720  k  t_show+0x0    [DISABLED]
  ffffffff810d9720  k  t_show+0x0    [DISABLED]
  ffffffff810d9720  k  t_show+0x0    [DISABLED]
  ffffffff810d9720  k  t_show+0x0    [DISABLED]
  ----

With this change;
  ----
  # ./perf probe -a "t_show \$vars"
  Added new events:
    probe:t_show         (on t_show with $vars)
    probe:t_show_1       (on t_show with $vars)
    probe:t_show_2       (on t_show with $vars)
    probe:t_show_3       (on t_show with $vars)

  You can now use it in all perf tools, such as:

          perf record -e probe:t_show_3 -aR sleep 1

  # cat /sys/kernel/debug/tracing/kprobe_events
  p:probe/t_show _stext+889880 m=%di:u64 v=%si:u64
  p:probe/t_show_1 _stext+928568 m=%di:u64 v=%si:u64 t=%si:u64
  p:probe/t_show_2 _stext+969512 m=%di:u64 v=%si:u64 fmt=%si:u64
  p:probe/t_show_3 _stext+1001416 m=%di:u64 v=%si:u64 file=%si:u64

  # cat /sys/kernel/debug/kprobes/list
  ffffffffb50d95e0  k  t_show+0x0    [DISABLED]
  ffffffffb50e2d00  k  t_show+0x0    [DISABLED]
  ffffffffb50f4990  k  t_show+0x0    [DISABLED]
  ffffffffb50eccf0  k  t_show+0x0    [DISABLED]
  ----
This time, each event is put in different address
correctly.

Note that currently this doesn't support address-based
probe on modules (thus the probes on modules are symbol
based), since it requires relative address probe syntax
for kprobe-tracer, and it doesn't implemented yet.

One more note, this allows us to put events on correct
address, but --list option should be updated to show
correct corresponding source code.

Changes from v1:
  - Use _stext relative address instead of actual
    absolute address recorded in debuginfo.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |   51 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4a9f43b..120954b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -387,6 +387,44 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 	return ret;
 }
 
+/* Post processing the probe events */
+static int post_process_probe_trace_events(struct probe_trace_event *tevs,
+					   int ntevs, const char *module,
+					   bool uprobe)
+{
+	struct symbol *sym;
+	struct map *map;
+	unsigned long stext = 0;
+	char *tmp;
+	int i;
+
+	if (uprobe)
+		return add_exec_to_probe_trace_events(tevs, ntevs, module);
+
+	/* Note that currently _stext based probe is not for drivers */
+	if (module)
+		return add_module_to_probe_trace_events(tevs, ntevs, module);
+
+	sym = __find_kernel_function_by_name("_stext", &map);
+	if (!sym) {
+		pr_debug("Failed to find _stext. Use original symbol name.\n");
+		return 0;
+	}
+	stext = map->unmap_ip(map, sym->start);
+
+	for (i = 0; i < ntevs; i++) {
+		if (tevs[i].point.address) {
+			tmp = strdup("_stext");
+			if (!tmp)
+				return -ENOMEM;
+			free(tevs[i].point.symbol);
+			tevs[i].point.symbol = tmp;
+			tevs[i].point.offset = tevs[i].point.address - stext;
+		}
+	}
+	return 0;
+}
+
 static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 {
 	int i;
@@ -415,21 +453,16 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 		return 0;
 	}
 
+	pr_debug("Try to find probe point from debuginfo.\n");
 	/* Searching trace events corresponding to a probe event */
 	ntevs = debuginfo__find_trace_events(dinfo, pev, tevs, max_tevs);
 
 	debuginfo__delete(dinfo);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
-		pr_debug("find %d probe_trace_events.\n", ntevs);
-		if (target) {
-			if (pev->uprobes)
-				ret = add_exec_to_probe_trace_events(*tevs,
-						 ntevs, target);
-			else
-				ret = add_module_to_probe_trace_events(*tevs,
-						 ntevs, target);
-		}
+		pr_debug("Found %d probe_trace_events.\n", ntevs);
+		ret = post_process_probe_trace_events(*tevs, ntevs,
+							target, pev->uprobes);
 		if (ret < 0) {
 			clear_probe_trace_events(*tevs, ntevs);
 			zfree(tevs);


