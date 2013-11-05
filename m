Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3KEUKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:10:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38837 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab3KEUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf fs: Add procfs support
Date: Tue,  5 Nov 2013 17:09:59 -0300
Message-Id: <1383682201-19399-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383682201-19399-1-git-send-email-acme@infradead.org>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding procfs support into fs class.

The interface function:
  const char *procfs__mountpoint(void);

provides existing mountpoint path for procfs.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383660887-1734-3-git-send-email-jolsa@redhat.com
[ Fixup namespace ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/fs.c                  | 16 ++++++++++++++--
 tools/perf/util/fs.h                  |  1 +
 tools/perf/util/include/linux/magic.h |  4 ++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
index 77bac4e4c115..f5be1f26e724 100644
--- a/tools/perf/util/fs.c
+++ b/tools/perf/util/fs.c
@@ -9,6 +9,11 @@ static const char * const sysfs__fs_known_mountpoints[] = {
 	0,
 };
 
+static const char * const procfs__known_mountpoints[] = {
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
 
 static struct fs fs__entries[] = {
@@ -27,6 +33,11 @@ static struct fs fs__entries[] = {
 		.mounts	= sysfs__fs_known_mountpoints,
 		.magic	= SYSFS_MAGIC,
 	},
+	[FS__PROCFS] = {
+		.name	= "proc",
+		.mounts	= procfs__known_mountpoints,
+		.magic	= PROC_SUPER_MAGIC,
+	},
 };
 
 static bool fs__read_mounts(struct fs *fs)
@@ -104,4 +115,5 @@ const char *name##__mountpoint(void)	\
 	return fs__mountpoint(idx);	\
 }
 
-FS__MOUNTPOINT(sysfs, FS__SYSFS);
+FS__MOUNTPOINT(sysfs,  FS__SYSFS);
+FS__MOUNTPOINT(procfs, FS__PROCFS);
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
index a7561c83c33c..5e09ce1bab0e 100644
--- a/tools/perf/util/fs.h
+++ b/tools/perf/util/fs.h
@@ -2,5 +2,6 @@
 #define __PERF_FS
 
 const char *sysfs__mountpoint(void);
+const char *procfs__mountpoint(void);
 
 #endif /* __PERF_FS */
diff --git a/tools/perf/util/include/linux/magic.h b/tools/perf/util/include/linux/magic.h
index 58b64ed4da12..07d63cf3e0f6 100644
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
1.8.1.4

