Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161559Ab3LFWIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:08:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:61000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431Ab3LFVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>,
        Kees Cook <keescook@google.com>
Subject: [PATCH 3.10 42/58] xfs: add capability check to free eofblocks ioctl
Date: Fri,  6 Dec 2013 13:52:13 -0800
Message-Id: <20131206214848.794009398@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

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
 


