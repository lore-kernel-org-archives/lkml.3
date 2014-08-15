Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaHOQuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:50:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:44613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaHOQuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:50:20 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/18] perf probe: Warn user to rebuild target with debuginfo
Date: Fri, 15 Aug 2014 13:49:46 -0300
Message-Id: <1408121403-11919-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Warn user to rebuild target with debuginfo when the perf probe fails to
find debug information in the target binary.

Without this, perf probe just reports the failure, but it's no hint for
users. This gives more hint for users.

Without this:

  $ strip perf
  $ ./perf probe -x perf -L argv_split
  Failed to open debuginfo file.
    Error: Failed to show lines.

With this:

  $ strip perf
  $ ./perf probe -x perf -L argv_split
  The /home/fedora/ksrc/linux-3/tools/perf/perf file has no debug information.
  Rebuild with -g, or install an appropriate debuginfo package.
    Error: Failed to show lines.

The "rebuild with ..." part changes to "rebuild with CONFIG_DEBUG_INFO"
if the target is the kernel or a kernel module.

Suggested-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140815014432.29869.57941.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 784ea42ad8cb..ac15ff780009 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -258,21 +258,33 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 #ifdef HAVE_DWARF_SUPPORT
 
 /* Open new debuginfo of given module */
-static struct debuginfo *open_debuginfo(const char *module)
+static struct debuginfo *open_debuginfo(const char *module, bool silent)
 {
 	const char *path = module;
+	struct debuginfo *ret;
 
 	if (!module || !strchr(module, '/')) {
 		path = kernel_get_module_path(module);
 		if (!path) {
-			pr_err("Failed to find path of %s module.\n",
-			       module ?: "kernel");
+			if (!silent)
+				pr_err("Failed to find path of %s module.\n",
+				       module ?: "kernel");
 			return NULL;
 		}
 	}
-	return debuginfo__new(path);
+	ret = debuginfo__new(path);
+	if (!ret && !silent) {
+		pr_warning("The %s file has no debug information.\n", path);
+		if (!module || !strtailcmp(path, ".ko"))
+			pr_warning("Rebuild with CONFIG_DEBUG_INFO=y, ");
+		else
+			pr_warning("Rebuild with -g, ");
+		pr_warning("or install an appropriate debuginfo package.\n");
+	}
+	return ret;
 }
 
+
 static int get_text_start_address(const char *exec, unsigned long *address)
 {
 	Elf *elf;
@@ -333,15 +345,13 @@ static int find_perf_probe_point_from_dwarf(struct probe_trace_point *tp,
 	pr_debug("try to find information at %" PRIx64 " in %s\n", addr,
 		 tp->module ? : "kernel");
 
-	dinfo = open_debuginfo(tp->module);
+	dinfo = open_debuginfo(tp->module, verbose == 0);
 	if (dinfo) {
 		ret = debuginfo__find_probe_point(dinfo,
 						 (unsigned long)addr, pp);
 		debuginfo__delete(dinfo);
-	} else {
-		pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n", addr);
+	} else
 		ret = -ENOENT;
-	}
 
 	if (ret > 0) {
 		pp->retprobe = tp->retprobe;
@@ -457,13 +467,11 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	struct debuginfo *dinfo;
 	int ntevs, ret = 0;
 
-	dinfo = open_debuginfo(target);
+	dinfo = open_debuginfo(target, !need_dwarf);
 
 	if (!dinfo) {
-		if (need_dwarf) {
-			pr_warning("Failed to open debuginfo file.\n");
+		if (need_dwarf)
 			return -ENOENT;
-		}
 		pr_debug("Could not open debuginfo. Try to use symbols.\n");
 		return 0;
 	}
@@ -620,11 +628,9 @@ static int __show_line_range(struct line_range *lr, const char *module)
 	char *tmp;
 
 	/* Search a line range */
-	dinfo = open_debuginfo(module);
-	if (!dinfo) {
-		pr_warning("Failed to open debuginfo file.\n");
+	dinfo = open_debuginfo(module, false);
+	if (!dinfo)
 		return -ENOENT;
-	}
 
 	ret = debuginfo__find_line_range(dinfo, lr);
 	debuginfo__delete(dinfo);
@@ -772,9 +778,8 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	if (ret < 0)
 		return ret;
 
-	dinfo = open_debuginfo(module);
+	dinfo = open_debuginfo(module, false);
 	if (!dinfo) {
-		pr_warning("Failed to open debuginfo file.\n");
 		ret = -ENOENT;
 		goto out;
 	}
-- 
1.9.3

