Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161381Ab3DECjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 22:39:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61663 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161368Ab3DECjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 22:39:10 -0400
X-AuditID: 9c930179-b7b2aae000000518-85-515e394c6ef1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, OSDepend <osdepend@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] perf probe: Enhance error message on non-kprobeable functions
Date: Fri,  5 Apr 2013 11:39:05 +0900
Message-Id: <1365129545-11689-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some of kernel functions are not allowed to be used by kprobes for
some reason, so they're marked as __kprobe on the source code and
reside on ".kprobes.text" section.

However normal users which only see /proc/kallsyms don't know about
them and would get only general error message when tried to add a
probe on such function.

  $ sudo ./perf probe do_page_fault
  Failed to find path of kernel module.
  Added new event:
  Failed to write event: Invalid argument
    Error: Failed to add events. (-1)

This patch enhance it by checking the special kprobes section address
and if to-be-probed function address is in the section, it would print
like this:

  $ sudo ./perf probe do_page_fault
  Failed to find path of kernel module.
  Added new event:
  Failed to write event: kprobes is not allowed for this function.
    Error: Failed to add events. (-1)

Cc: OSDepend <osdepend@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-event.c | 47 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index aa04bf9c9ad7..3a49c47eb77c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -112,6 +112,38 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
 						     NULL);
 }
 
+static bool check_kprobes_section(const char *name)
+{
+	struct symbol *sym;
+	static uint64_t kprobes_start, kprobes_end;
+
+	if (!kprobes_start) {
+		sym = __find_kernel_function_by_name("__kprobes_text_start",
+						     NULL);
+		if (sym == NULL)
+			return false;
+		kprobes_start = sym->start;
+
+		sym = __find_kernel_function_by_name("__kprobes_text_end",
+						     NULL);
+		if (sym == NULL) {
+			/* invalidate start address too */
+			kprobes_start = 0;
+			return false;
+		}
+		kprobes_end = sym->start;
+		pr_debug("kprobes section: %#"PRIx64"-%#"PRIx64"\n",
+			 kprobes_start, kprobes_end);
+	}
+
+	sym = __find_kernel_function_by_name(name, NULL);
+	if (sym) {
+		if (kprobes_start <= sym->start && sym->end <= kprobes_end)
+			return true;
+	}
+	return false;
+}
+
 static struct map *kernel_get_module_map(const char *module)
 {
 	struct rb_node *nd;
@@ -1773,9 +1805,18 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 	pr_debug("Writing event: %s\n", buf);
 	if (!probe_event_dry_run) {
 		ret = write(fd, buf, strlen(buf));
-		if (ret <= 0)
-			pr_warning("Failed to write event: %s\n",
-				   strerror(errno));
+		if (ret <= 0) {
+			char errbuf[512];
+
+			/* save original error string before it's overwritten */
+			strerror_r(errno, errbuf, sizeof(errbuf));
+
+			if (!tev->uprobes && check_kprobes_section(tev->event)) {
+				scnprintf(errbuf, sizeof(errbuf),
+					  "kprobes is not allowed for this function.");
+			}
+			pr_warning("Failed to write event: %s\n", errbuf);
+		}
 	}
 	free(buf);
 	return ret;
-- 
1.7.11.7

