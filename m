Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab3FEVfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab3FEVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Ben Myers <bpm@sgi.com>
Subject: [ 062/127] xfs: kill suid/sgid through the truncate path.
Date: Wed,  5 Jun 2013 14:33:49 -0700
Message-Id: <20130605213225.016944483@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_iops.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -455,6 +455,28 @@ xfs_vn_getattr(
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
@@ -606,18 +628,8 @@ xfs_setattr_nonsize(
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
@@ -714,9 +726,8 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
 	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -860,6 +871,12 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
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


