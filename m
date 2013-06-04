Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3FDONj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:13:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab3FDOIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 56/70] xfs: kill suid/sgid through the truncate path.
Date: Tue,  4 Jun 2013 15:07:12 +0100
Message-Id: <1370354846-14213-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 2962f5a5dcc56f69cbf62121a7be67cc15d6940b upstream.

XFS has failed to kill suid/sgid bits correctly when truncating
files of non-zero size since commit c4ed4243 ("xfs: split
xfs_setattr") introduced in the 3.1 kernel. Fix it.

Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

(cherry picked from commit 56c19e89b38618390addfc743d822f99519055c6)
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/xfs/xfs_iops.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1a25fd8..1ad330c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -454,6 +454,28 @@ xfs_vn_getattr(
 	return 0;
 }
 
+static void
+xfs_setattr_mode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct iattr		*iattr)
+{
+	struct inode	*inode = VFS_I(ip);
+	umode_t		mode = iattr->ia_mode;
+
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		mode &= ~S_ISGID;
+
+	ip->i_d.di_mode &= S_IFMT;
+	ip->i_d.di_mode |= mode & ~S_IFMT;
+
+	inode->i_mode &= S_IFMT;
+	inode->i_mode |= mode & ~S_IFMT;
+}
+
 int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
@@ -605,18 +627,8 @@ xfs_setattr_nonsize(
 	/*
 	 * Change file access modes.
 	 */
-	if (mask & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= mode & ~S_IFMT;
-	}
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
 
 	/*
 	 * Change file access or modified times.
@@ -713,9 +725,8 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
 	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -856,6 +867,12 @@ xfs_setattr_size(
 		xfs_iflags_set(ip, XFS_ITRUNCATED);
 	}
 
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
+
 	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-- 
1.8.1.2

