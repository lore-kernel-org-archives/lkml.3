Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3KFFoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:44:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3KFFof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:44:35 -0500
Date: Tue, 5 Nov 2013 21:44:11 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a9862418547e818aa5842840aecfa81d733b97e9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1383660887-1734-3-git-send-email-jolsa@redhat.com>
References: <1383660887-1734-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf fs: Add procfs support
Git-Commit-ID: a9862418547e818aa5842840aecfa81d733b97e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 05 Nov 2013 21:44:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9862418547e818aa5842840aecfa81d733b97e9
Gitweb:     http://git.kernel.org/tip/a9862418547e818aa5842840aecfa81d733b97e9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 5 Nov 2013 15:14:46 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Nov 2013 15:15:07 -0300

perf fs: Add procfs support

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
index 77bac4e..f5be1f2 100644
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
index a7561c8..5e09ce1 100644
--- a/tools/perf/util/fs.h
+++ b/tools/perf/util/fs.h
@@ -2,5 +2,6 @@
 #define __PERF_FS
 
 const char *sysfs__mountpoint(void);
+const char *procfs__mountpoint(void);
 
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
