Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaCYRR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:17:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55605 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaCYRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 06/81] xfs: ensure correct timestamp updates from truncate
Date: Tue, 25 Mar 2014 10:15:19 -0700
Message-Id: <1395767794-5012-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit fe60a8a0919eeee862054137fed49f00b710d9cd upstream.

The VFS doesn't set the proper ATTR_CTIME and ATTR_MTIME values for
truncate, so filesystems have to manually add them.  The
introduction of xfs_setattr_time accidentally broke this special
case an caused a regression in generic/313.  Fix this by removing
the local mask variable in xfs_setattr_size so that we only have a
single place to keep the attribute information.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/xfs/xfs_iops.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ca9ecaa..152411e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -706,7 +706,6 @@ xfs_setattr_size(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
-	int			mask = iattr->ia_valid;
 	xfs_off_t		oldsize, newsize;
 	struct xfs_trans	*tp;
 	int			error;
@@ -726,8 +725,8 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
 	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -741,7 +740,7 @@ xfs_setattr_size(
 	 * Short circuit the truncate case for zero length files.
 	 */
 	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
-		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
+		if (!(iattr->ia_valid & (ATTR_CTIME|ATTR_MTIME)))
 			goto out_unlock;
 
 		/*
@@ -832,10 +831,11 @@ xfs_setattr_size(
 	 * these flags set.  For all other operations the VFS set these flags
 	 * explicitly if it wants a timestamp update.
 	 */
-	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
+	if (newsize != oldsize &&
+	    !(iattr->ia_valid & (ATTR_CTIME | ATTR_MTIME))) {
 		iattr->ia_ctime = iattr->ia_mtime =
 			current_fs_time(inode->i_sb);
-		mask |= ATTR_CTIME | ATTR_MTIME;
+		iattr->ia_valid |= ATTR_CTIME | ATTR_MTIME;
 	}
 
 	/*
@@ -874,15 +874,15 @@ xfs_setattr_size(
 	/*
 	 * Change file access modes.
 	 */
-	if (mask & ATTR_MODE)
+	if (iattr->ia_valid & ATTR_MODE)
 		xfs_setattr_mode(tp, ip, iattr);
 
-	if (mask & ATTR_CTIME) {
+	if (iattr->ia_valid & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
 		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
 	}
-	if (mask & ATTR_MTIME) {
+	if (iattr->ia_valid & ATTR_MTIME) {
 		inode->i_mtime = iattr->ia_mtime;
 		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
 		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-- 
1.8.3.2

