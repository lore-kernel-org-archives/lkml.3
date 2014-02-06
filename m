Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaBFFcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:32:33 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44353 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaBFFcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:32:31 -0500
Subject: [PATCH -tip v3 11/11] perf probe: Support distro-style debuginfo
 for uprobe
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 06 Feb 2014 05:32:27 +0000
Message-ID: <20140206053227.29635.54434.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support distro-style debuginfo supported by dso for setting
uprobes. Note that this tries to find a debuginfo file based
on the real path of the target binary. If the debuginfo is
not correctly installed on the system, this can not find it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c  |    9 +++------
 tools/perf/util/probe-finder.c |   41 ++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/probe-finder.h |    1 +
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
 


