Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3LSMlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:41:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44855 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab3LSL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>,
        Kees Cook <keescook@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 091/208] xfs: add capability check to free eofblocks ioctl
Date: Thu, 19 Dec 2013 11:53:09 +0000
Message-Id: <1387454106-19326-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dwight Engen <dwight.engen@oracle.com>

commit 8c567a7fab6e086a0284eee2db82348521e7120c upstream.

Check for CAP_SYS_ADMIN since the caller can truncate preallocated
blocks from files they do not own nor have write access to. A more
fine grained access check was considered: require the caller to
specify their own uid/gid and to use inode_permission to check for
write, but this would not catch the case of an inode not reachable
via path traversal from the callers mount namespace.

Add check for read-only filesystem to free eofblocks ioctl.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Cc: Kees Cook <keescook@google.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/xfs/xfs_ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6e2bca5..bccd2a3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1612,6 +1612,12 @@ xfs_file_ioctl(
 	case XFS_IOC_FREE_EOFBLOCKS: {
 		struct xfs_eofblocks eofb;
 
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			return -XFS_ERROR(EROFS);
+
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
 
-- 
1.8.3.2

