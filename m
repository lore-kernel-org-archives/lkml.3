Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3KFNtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:49:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46388 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab3KFNsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:46 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v6 10/11] VFS hot tracking, xfs: Add hot tracking support
Date: Wed,  6 Nov 2013 21:45:43 +0800
Message-Id: <1383745544-391-11-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-5806-0000-0000-00002355CDFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Connect up the VFS hot tracking support so XFS filesystem
can make use of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1fa0584..c6bbf31 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -184,6 +184,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
+#define XFS_MOUNT_HOTTRACK      (1ULL << 1)     /* hot tracking */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 15188cc..a2667f9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -62,6 +62,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/parser.h>
+#include <linux/hot_tracking.h>
 
 static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
@@ -115,6 +116,7 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed logging disabled */
 #define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
 #define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
+#define MNTOPT_HOTTRACK    "hot_track"  /* hot tracking */
 
 /*
  * Table driven mount option parser.
@@ -381,6 +383,8 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		} else if (!strcmp(this_char, MNTOPT_HOTTRACK)) {
+			mp->m_flags |= XFS_MOUNT_HOTTRACK;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			xfs_warn(mp,
 	"ihashsize no longer used, option is deprecated.");
@@ -504,6 +508,7 @@ xfs_showargs(
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
 		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
+		{ XFS_MOUNT_HOTTRACK,		"," MNTOPT_HOTTRACK },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
@@ -1046,6 +1051,9 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	if (mp->m_flags & XFS_MOUNT_HOTTRACK)
+		hot_track_exit(sb);
+
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
@@ -1501,8 +1509,18 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
+	if (mp->m_flags & XFS_MOUNT_HOTTRACK) {
+		error = hot_track_init(sb);
+		if (error)
+			goto out_free_root;
+	}
+
 	return 0;
 
+ out_free_root:
+	dput(sb->s_root);
+	sb->s_root = NULL;
+
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
-- 
1.7.11.7

