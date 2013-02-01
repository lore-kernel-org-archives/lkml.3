Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822Ab3BAKvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:51:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:39369 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422775Ab3BAKve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:51:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 27/33] NFS: Dont silently fail setattr() requests on mountpoints
Date: Fri,  1 Feb 2013 11:49:32 +0100
Message-Id: <20130201104726.581911153@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/namespace.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -253,11 +253,31 @@ out_nofree:
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


