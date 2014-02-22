Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaBVSBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:01:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaBVSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:01:09 -0500
Date: Sat, 22 Feb 2014 10:00:47 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-dfef99cd0b2c8abafb571e5992ce954135be5f40@git.kernel.org>
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
In-Reply-To: <20140206053216.29635.22584.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053216.29635.22584.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Use ref_reloc_sym based address instead of the symbol name
Git-Commit-ID: dfef99cd0b2c8abafb571e5992ce954135be5f40
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

Commit-ID:  dfef99cd0b2c8abafb571e5992ce954135be5f40
Gitweb:     http://git.kernel.org/tip/dfef99cd0b2c8abafb571e5992ce954135be5f40
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 6 Feb 2014 05:32:16 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:51 -0300

perf probe: Use ref_reloc_sym based address instead of the symbol name

Since several local symbols can have same name (e.g. t_show), we need to
use the relative address from the symbol referred by kmap->ref_reloc_sym
instead of the target symbol name itself.

Because the kernel address space layout randomize (kASLR) changes the
absolute address of kernel symbols, we can't rely on the absolute
address.

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
for kprobe-tracer, and it isn't implemented yet.

One more note, this allows us to put events on correct
address, but --list option should be updated to show
correct corresponding source code.

Changes from v2:
  - Refer kmap->ref_reloc_sym instead of "_stext".
  - Refer map->reloc to catch up the kASLR perf fix.

Changes from v1:
  - Use _stext relative address instead of actual
    absolute address recorded in debuginfo.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053216.29635.22584.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 58 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index de9fe90..1ce2cb9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -383,6 +383,51 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 	return ret;
 }
 
+static struct ref_reloc_sym *__kernel_get_ref_reloc_sym(void)
+{
+	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
+	struct kmap *kmap;
+
+	kmap = map__kmap(host_machine->vmlinux_maps[MAP__FUNCTION]);
+	return kmap->ref_reloc_sym;
+}
+
+/* Post processing the probe events */
+static int post_process_probe_trace_events(struct probe_trace_event *tevs,
+					   int ntevs, const char *module,
+					   bool uprobe)
+{
+	struct ref_reloc_sym *reloc_sym;
+	char *tmp;
+	int i;
+
+	if (uprobe)
+		return add_exec_to_probe_trace_events(tevs, ntevs, module);
+
+	/* Note that currently ref_reloc_sym based probe is not for drivers */
+	if (module)
+		return add_module_to_probe_trace_events(tevs, ntevs, module);
+
+	reloc_sym = __kernel_get_ref_reloc_sym();
+	if (!reloc_sym) {
+		pr_warning("Relocated base symbol is not found!\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ntevs; i++) {
+		if (tevs[i].point.address) {
+			tmp = strdup(reloc_sym->name);
+			if (!tmp)
+				return -ENOMEM;
+			free(tevs[i].point.symbol);
+			tevs[i].point.symbol = tmp;
+			tevs[i].point.offset = tevs[i].point.address -
+					       reloc_sym->unrelocated_addr;
+		}
+	}
+	return 0;
+}
+
 static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 {
 	int i;
@@ -411,21 +456,16 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
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
