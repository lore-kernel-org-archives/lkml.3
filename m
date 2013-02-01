Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704Ab3BANMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:12:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:45226 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422653Ab3BANMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:12:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 53/89] NFS: Fix error reporting in nfs_xdev_mount
Date: Fri,  1 Feb 2013 14:08:08 +0100
Message-Id: <20130201130211.310468494@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit dee972b967ae111ad5705733de17a3bfc4632311 upstream.

Currently, nfs_xdev_mount converts all errors from clone_server() to
ENOMEM, which can then leak to userspace (for instance to 'mount'). Fix that.
Also ensure that if nfs_fs_mount_common() returns an error, we
don't dprintk(0)...

The regression originated in commit 3d176e3fe4f6dc379b252bf43e2e146a8f7caf01
(NFS: Use nfs_fs_mount_common() for xdev mounts)

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/super.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2576,27 +2576,23 @@ nfs_xdev_mount(struct file_system_type *
 	struct nfs_server *server;
 	struct dentry *mntroot = ERR_PTR(-ENOMEM);
 	struct nfs_subversion *nfs_mod = NFS_SB(data->sb)->nfs_client->cl_nfs_mod;
-	int error;
 
-	dprintk("--> nfs_xdev_mount_common()\n");
+	dprintk("--> nfs_xdev_mount()\n");
 
 	mount_info.mntfh = mount_info.cloned->fh;
 
 	/* create a new volume representation */
 	server = nfs_mod->rpc_ops->clone_server(NFS_SB(data->sb), data->fh, data->fattr, data->authflavor);
-	if (IS_ERR(server)) {
-		error = PTR_ERR(server);
-		goto out_err;
-	}
-
-	mntroot = nfs_fs_mount_common(server, flags, dev_name, &mount_info, nfs_mod);
-	dprintk("<-- nfs_xdev_mount_common() = 0\n");
-out:
-	return mntroot;
 
-out_err:
-	dprintk("<-- nfs_xdev_mount_common() = %d [error]\n", error);
-	goto out;
+	if (IS_ERR(server))
+		mntroot = ERR_CAST(server);
+	else
+		mntroot = nfs_fs_mount_common(server, flags,
+				dev_name, &mount_info, nfs_mod);
+
+	dprintk("<-- nfs_xdev_mount() = %ld\n",
+			IS_ERR(mntroot) ? PTR_ERR(mntroot) : 0L);
+	return mntroot;
 }
 
 #if IS_ENABLED(CONFIG_NFS_V4)


