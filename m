Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaBVSCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:02:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaBVSCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:02:02 -0500
Date: Sat, 22 Feb 2014 10:01:43 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-a15ad2f5360c821f030c53266ebf467738249c68@git.kernel.org>
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
In-Reply-To: <20140206053227.29635.54434.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053227.29635.54434.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Support distro-style debuginfo for uprobe
Git-Commit-ID: a15ad2f5360c821f030c53266ebf467738249c68
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

Commit-ID:  a15ad2f5360c821f030c53266ebf467738249c68
Gitweb:     http://git.kernel.org/tip/a15ad2f5360c821f030c53266ebf467738249c68
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 6 Feb 2014 05:32:27 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:38:44 -0300

perf probe: Support distro-style debuginfo for uprobe

Support distro-style debuginfo supported by dso for setting uprobes.
Note that this tries to find a debuginfo file based on the real path of
the target binary. If the debuginfo is not correctly installed on the
system, this can not find it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053227.29635.54434.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |  9 +++------
 tools/perf/util/probe-finder.c | 41 +++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/probe-finder.h |  1 +
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 42bec67..0d1542f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -256,17 +256,14 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 }
 
 #ifdef HAVE_DWARF_SUPPORT
+
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
-	const char *path;
+	const char *path = module;
 
-	/* A file path -- this is an offline module */
-	if (module && strchr(module, '/'))
-		path = module;
-	else {
+	if (!module || !strchr(module, '/')) {
 		path = kernel_get_module_path(module);
-
 		if (!path) {
 			pr_err("Failed to find path of %s module.\n",
 			       module ?: "kernel");
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 4f6e277..df02386 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -34,6 +34,7 @@
 
 #include <linux/bitops.h>
 #include "event.h"
+#include "dso.h"
 #include "debug.h"
 #include "intlist.h"
 #include "util.h"
@@ -89,7 +90,7 @@ error:
 	return -ENOENT;
 }
 
-struct debuginfo *debuginfo__new(const char *path)
+static struct debuginfo *__debuginfo__new(const char *path)
 {
 	struct debuginfo *dbg = zalloc(sizeof(*dbg));
 	if (!dbg)
@@ -97,10 +98,46 @@ struct debuginfo *debuginfo__new(const char *path)
 
 	if (debuginfo__init_offline_dwarf(dbg, path) < 0)
 		zfree(&dbg);
-
+	if (dbg)
+		pr_debug("Open Debuginfo file: %s\n", path);
 	return dbg;
 }
 
+enum dso_binary_type distro_dwarf_types[] = {
+	DSO_BINARY_TYPE__FEDORA_DEBUGINFO,
+	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
+	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
+	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
+	DSO_BINARY_TYPE__NOT_FOUND,
+};
+
+struct debuginfo *debuginfo__new(const char *path)
+{
+	enum dso_binary_type *type;
+	char buf[PATH_MAX], nil = '\0';
+	struct dso *dso;
+	struct debuginfo *dinfo = NULL;
+
+	/* Try to open distro debuginfo files */
+	dso = dso__new(path);
+	if (!dso)
+		goto out;
+
+	for (type = distro_dwarf_types;
+	     !dinfo && *type != DSO_BINARY_TYPE__NOT_FOUND;
+	     type++) {
+		if (dso__read_binary_type_filename(dso, *type, &nil,
+						   buf, PATH_MAX) < 0)
+			continue;
+		dinfo = __debuginfo__new(buf);
+	}
+	dso__delete(dso);
+
+out:
+	/* if failed to open all distro debuginfo, open given binary */
+	return dinfo ? : __debuginfo__new(path);
+}
+
 void debuginfo__delete(struct debuginfo *dbg)
 {
 	if (dbg) {
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 3fc5973..92590b2 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -30,6 +30,7 @@ struct debuginfo {
 	Dwarf_Addr	bias;
 };
 
+/* This also tries to open distro debuginfo */
 extern struct debuginfo *debuginfo__new(const char *path);
 extern void debuginfo__delete(struct debuginfo *dbg);
 
