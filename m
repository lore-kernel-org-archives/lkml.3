Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487AbaLKV1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:44467 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965130AbaLKV1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:25 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/18] tools lib fs: Adopt filename__read_int from tools/perf/
Date: Thu, 11 Dec 2014 18:26:02 -0300
Message-Id: <1418333166-15429-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be useful for new helpers to read sysctl values.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/fs.c  | 21 +++++++++++++++++++++
 tools/lib/api/fs/fs.h  |  2 ++
 tools/perf/util/util.c | 17 -----------------
 tools/perf/util/util.h |  1 -
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index c1b49c36a951..b8d0df8878d1 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -7,6 +7,10 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/vfs.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
 
 #include "debugfs.h"
 #include "fs.h"
@@ -163,3 +167,20 @@ const char *name##__mountpoint(void)	\
 
 FS__MOUNTPOINT(sysfs,  FS__SYSFS);
 FS__MOUNTPOINT(procfs, FS__PROCFS);
+
+int filename__read_int(const char *filename, int *value)
+{
+	char line[64];
+	int fd = open(filename, O_RDONLY), err = -1;
+
+	if (fd < 0)
+		return -1;
+
+	if (read(fd, line, sizeof(line)) > 0) {
+		*value = atoi(line);
+		err = 0;
+	}
+
+	close(fd);
+	return err;
+}
diff --git a/tools/lib/api/fs/fs.h b/tools/lib/api/fs/fs.h
index cb7049551f33..4d0aef6e7163 100644
--- a/tools/lib/api/fs/fs.h
+++ b/tools/lib/api/fs/fs.h
@@ -11,4 +11,6 @@
 
 const char *sysfs__mountpoint(void);
 const char *procfs__mountpoint(void);
+
+int filename__read_int(const char *filename, int *value);
 #endif /* __API_FS__ */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index d5eab3f3323f..41125e5b011e 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -442,23 +442,6 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags)
 	return (unsigned long) -1;
 }
 
-int filename__read_int(const char *filename, int *value)
-{
-	char line[64];
-	int fd = open(filename, O_RDONLY), err = -1;
-
-	if (fd < 0)
-		return -1;
-
-	if (read(fd, line, sizeof(line)) > 0) {
-		*value = atoi(line);
-		err = 0;
-	}
-
-	close(fd);
-	return err;
-}
-
 int filename__read_str(const char *filename, char **buf, size_t *sizep)
 {
 	size_t size = 0, alloc_size = 0;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index abc445ee4f60..008b361b1758 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -343,7 +343,6 @@ char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
 		  bool show_sym);
 void free_srcline(char *srcline);
 
-int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
 int perf_event_paranoid(void);
 
-- 
1.9.3

