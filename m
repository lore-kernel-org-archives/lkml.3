Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaBRVJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:09:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35701 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaBRVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/32] perf probe: Support distro-style debuginfo for uprobe
Date: Tue, 18 Feb 2014 18:08:51 -0300
Message-Id: <1392757731-32619-33-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
index 42bec67aaa38..0d1542f33d87 100644
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
index 4f6e277c457c..df0238654698 100644
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
index 3fc597365ce6..92590b2c7e1c 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -30,6 +30,7 @@ struct debuginfo {
 	Dwarf_Addr	bias;
 };
 
+/* This also tries to open distro debuginfo */
 extern struct debuginfo *debuginfo__new(const char *path);
 extern void debuginfo__delete(struct debuginfo *dbg);
 
-- 
1.8.1.4

