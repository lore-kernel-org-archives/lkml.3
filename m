Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3KEOPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:15:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab3KEOPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:15:20 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf tools: Add procfs support into fs object
Date: Tue,  5 Nov 2013 15:14:46 +0100
Message-Id: <1383660887-1734-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383660887-1734-1-git-send-email-jolsa@redhat.com>
References: <1383660887-1734-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding procfs support into fs object.

The interface function:
  const char *procfs_find_mountpoint(void);

provides valid mountpoint path for procfs.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/fs.c                  | 16 ++++++++++++++--
 tools/perf/util/fs.h                  |  1 +
 tools/perf/util/include/linux/magic.h |  4 ++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
index ff7066c..604f64e 100644
--- a/tools/perf/util/fs.c
+++ b/tools/perf/util/fs.c
@@ -9,6 +9,11 @@ static const char * const sysfs_known_mountpoints[] = {
 	0,
 };
 
+static const char * const procfs_known_mountpoints[] = {
+	"/proc",
+	0,
+};
+
 struct fs {
 	const char		*name;
 	const char * const	*mounts;
@@ -18,7 +23,8 @@ struct fs {
 };
 
 enum {
-	FS__SYSFS = 0,
+	FS__SYSFS  = 0,
+	FS__PROCFS = 1,
 };
 
 static struct fs fs_entries[] = {
@@ -27,6 +33,11 @@ static struct fs fs_entries[] = {
 		.mounts	= sysfs_known_mountpoints,
 		.magic	= SYSFS_MAGIC,
 	},
+	[FS__PROCFS] = {
+		.name	= "proc",
+		.mounts	= procfs_known_mountpoints,
+		.magic	= PROC_SUPER_MAGIC,
+	},
 };
 
 static bool read_mounts(struct fs *fs)
@@ -104,4 +115,5 @@ const char *name##_find_mountpoint(void)	\
 	return find_mountpoint(idx);		\
 }
 
-FIND_MOUNTPOINT(sysfs, FS__SYSFS);
+FIND_MOUNTPOINT(sysfs,  FS__SYSFS);
+FIND_MOUNTPOINT(procfs, FS__PROCFS);
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
index 082edbd..bc6556f 100644
--- a/tools/perf/util/fs.h
+++ b/tools/perf/util/fs.h
@@ -2,5 +2,6 @@
 #define __PERF_FS
 
 const char *sysfs_find_mountpoint(void);
+const char *procfs_find_mountpoint(void);
 
 #endif /* __PERF_FS */
diff --git a/tools/perf/util/include/linux/magic.h b/tools/perf/util/include/linux/magic.h
index 58b64ed..07d63cf 100644
--- a/tools/perf/util/include/linux/magic.h
+++ b/tools/perf/util/include/linux/magic.h
@@ -9,4 +9,8 @@
 #define SYSFS_MAGIC            0x62656572
 #endif
 
+#ifndef PROC_SUPER_MAGIC
+#define PROC_SUPER_MAGIC       0x9fa0
+#endif
+
 #endif
-- 
1.8.3.1

