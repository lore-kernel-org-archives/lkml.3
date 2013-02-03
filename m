Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3BCPCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:02:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988Ab3BCO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:15 -0500
Message-Id: <20130203144653.522072397@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 107/128] NFS: Dont silently fail setattr() requests on mountpoints
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/namespace.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index dd057bc..fc8dc20 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -177,11 +177,31 @@ out_nofree:
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


