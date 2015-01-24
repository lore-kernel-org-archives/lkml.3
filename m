Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbbAXSPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:15:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:8390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754204AbbAXSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:14:51 -0500
Message-Id: <20150124181448.680347393@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 24 Jan 2015 13:13:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/5] tools lib api fs: Add tracefs mount helper functions
References: <20150124181330.195149364@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tools-lib-api-fs-Add-tracefs-mount-helper-functions.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Since tracefs will now hold the event directory for perf, and
even though by default, debugfs still mounts tracefs on the
debugfs/tracing directory, the system admin may now choose to not
mount debugfs and instead just mount tracefs instead.

Having tracefs helper functions will facilitate having perf look
for tracefs first, and then try debugfs as a fallback.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/api/Makefile     |  2 ++
 tools/lib/api/fs/tracefs.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/api/fs/tracefs.h | 29 +++++++++++++++++++
 3 files changed, 102 insertions(+)
 create mode 100644 tools/lib/api/fs/tracefs.c
 create mode 100644 tools/lib/api/fs/tracefs.h

diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index 22b2f15d7255..212aa4fd65a0 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -9,12 +9,14 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += fs/debugfs.h
+LIB_H += fs/tracefs.h
 LIB_H += fs/findfs.h
 LIB_H += fs/fs.h
 # See comment below about piggybacking...
 LIB_H += fd/array.h
 
 LIB_OBJS += $(OUTPUT)fs/debugfs.o
+LIB_OBJS += $(OUTPUT)fs/tracefs.o
 LIB_OBJS += $(OUTPUT)fs/findfs.o
 LIB_OBJS += $(OUTPUT)fs/fs.o
 # XXX piggybacking here, need to introduce libapikfd, or rename this
diff --git a/tools/lib/api/fs/tracefs.c b/tools/lib/api/fs/tracefs.c
new file mode 100644
index 000000000000..bdaf54142c5d
--- /dev/null
+++ b/tools/lib/api/fs/tracefs.c
@@ -0,0 +1,71 @@
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <sys/vfs.h>
+#include <sys/mount.h>
+#include <linux/kernel.h>
+
+#include "tracefs.h"
+#include "findfs.h"
+
+#ifndef TRACEFS_DEFAULT_PATH
+#define TRACEFS_DEFAULT_PATH		"/sys/kernel/tracing"
+#endif
+
+char tracefs_mountpoint[PATH_MAX + 1] = TRACEFS_DEFAULT_PATH;
+
+static const char * const tracefs_known_mountpoints[] = {
+	TRACEFS_DEFAULT_PATH,
+	"/sys/kernel/debug/tracing",
+	"/tracing",
+	"/trace",
+	0,
+};
+
+static bool tracefs_found;
+
+/* find the path to the mounted tracefs */
+const char *tracefs_find_mountpoint(void)
+{
+	if (tracefs_found)
+		return (const char *)tracefs_mountpoint;
+
+	return find_mountpoint("tracefs", (long) TRACEFS_MAGIC,
+			       tracefs_mountpoint, PATH_MAX + 1,
+			       tracefs_known_mountpoints);
+}
+
+/* verify that a mountpoint is actually a tracefs instance */
+
+int tracefs_valid_mountpoint(const char *tracefs)
+{
+	return valid_mountpoint(tracefs, (long) TRACEFS_MAGIC);
+}
+
+/* mount the tracefs somewhere if it's not mounted */
+char *tracefs_mount(const char *mountpoint)
+{
+	/* see if it's already mounted */
+	if (tracefs_find_mountpoint())
+		goto out;
+
+	/* if not mounted and no argument */
+	if (mountpoint == NULL) {
+		/* see if environment variable set */
+		mountpoint = getenv(PERF_TRACEFS_ENVIRONMENT);
+		/* if no environment variable, use default */
+		if (mountpoint == NULL)
+			mountpoint = TRACEFS_DEFAULT_PATH;
+	}
+
+	if (mount(NULL, mountpoint, "tracefs", 0, NULL) < 0)
+		return NULL;
+
+	/* save the mountpoint */
+	tracefs_found = true;
+	strncpy(tracefs_mountpoint, mountpoint, sizeof(tracefs_mountpoint));
+out:
+	return tracefs_mountpoint;
+}
diff --git a/tools/lib/api/fs/tracefs.h b/tools/lib/api/fs/tracefs.h
new file mode 100644
index 000000000000..576206500e15
--- /dev/null
+++ b/tools/lib/api/fs/tracefs.h
@@ -0,0 +1,29 @@
+#ifndef __API_TRACEFS_H__
+#define __API_TRACEFS_H__
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+/*
+ * On most systems <limits.h> would have given us this, but  not on some systems
+ * (e.g. GNU/Hurd).
+ */
+#ifndef PATH_MAX
+#define PATH_MAX 4096
+#endif
+
+#ifndef TRACEFS_MAGIC
+#define TRACEFS_MAGIC          0x74726163
+#endif
+
+#ifndef PERF_TRACEFS_ENVIRONMENT
+#define PERF_TRACEFS_ENVIRONMENT "PERF_TRACEFS_DIR"
+#endif
+
+const char *tracefs_find_mountpoint(void);
+int tracefs_valid_mountpoint(const char *debugfs);
+char *tracefs_mount(const char *mountpoint);
+
+extern char tracefs_mountpoint[];
+
+#endif /* __API_DEBUGFS_H__ */
-- 
2.1.4


