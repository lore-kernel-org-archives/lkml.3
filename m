Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab3BEWS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:18:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48197 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab3BEWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 72/93] NFS: Don't silently fail setattr() requests on mountpoints
Date: Tue,  5 Feb 2013 20:07:01 -0200
Message-Id: <1360102042-10732-73-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit ab225417825963b6dc66be7ea80f94ac1378dfdf upstream.

Ensure that any setattr and getattr requests for junctions and/or
mountpoints are sent to the server. Ever since commit
0ec26fd0698 (vfs: automount should ignore LOOKUP_FOLLOW), we have
silently dropped any setattr requests to a server-side mountpoint.
For referrals, we have silently dropped both getattr and setattr
requests.

This patch restores the original behaviour for setattr on mountpoints,
and tries to do the same for referrals, provided that we have a
filehandle...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/namespace.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index bacd772..95954e6 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -175,11 +175,31 @@ out_nofree:
 	return mnt;
 }
 
+static int
+nfs_namespace_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+{
+	if (NFS_FH(dentry->d_inode)->size != 0)
+		return nfs_getattr(mnt, dentry, stat);
+	generic_fillattr(dentry->d_inode, stat);
+	return 0;
+}
+
+static int
+nfs_namespace_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	if (NFS_FH(dentry->d_inode)->size != 0)
+		return nfs_setattr(dentry, attr);
+	return -EACCES;
+}
+
 const struct inode_operations nfs_mountpoint_inode_operations = {
 	.getattr	= nfs_getattr,
+	.setattr	= nfs_setattr,
 };
 
 const struct inode_operations nfs_referral_inode_operations = {
+	.getattr	= nfs_namespace_getattr,
+	.setattr	= nfs_namespace_setattr,
 };
 
 static void nfs_expire_automounts(struct work_struct *work)
-- 
1.7.9.5

