Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaHRIWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:22:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHRIW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:22:27 -0400
Date: Mon, 18 Aug 2014 01:21:37 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-92561cb7883194714475c7a7775a11a9c40f75cb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, acme@kernel.org, namhyung@gmail.com,
        brendan.d.gregg@gmail.com, jolsa@redhat.com,
        masami.hiramatsu.pt@hitachi.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, acme@kernel.org, brendan.d.gregg@gmail.com,
        namhyung@gmail.com, jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <20140815014432.29869.57941.stgit@kbuild-fedora.novalocal>
References: <20140815014432.29869.57941.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Warn user to rebuild target with debuginfo
Git-Commit-ID: 92561cb7883194714475c7a7775a11a9c40f75cb
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

Commit-ID:  92561cb7883194714475c7a7775a11a9c40f75cb
Gitweb:     http://git.kernel.org/tip/92561cb7883194714475c7a7775a11a9c40f75cb
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 15 Aug 2014 01:44:32 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:32:43 -0300

perf probe: Warn user to rebuild target with debuginfo

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
index 784ea42..ac15ff7 100644
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
