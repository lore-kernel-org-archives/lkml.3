Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab3BEWMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:12:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3BEWMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 71/93] NFS: Fix error reporting in nfs_xdev_mount
Date: Tue,  5 Feb 2013 20:07:00 -0200
Message-Id: <1360102042-10732-72-git-send-email-herton.krzesinski@canonical.com>
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

commit dee972b967ae111ad5705733de17a3bfc4632311 upstream.

Currently, nfs_xdev_mount converts all errors from clone_server() to
ENOMEM, which can then leak to userspace (for instance to 'mount'). Fix that.
Also ensure that if nfs_fs_mount_common() returns an error, we
don't dprintk(0)...

The regression originated in commit 3d176e3fe4f6dc379b252bf43e2e146a8f7caf01
(NFS: Use nfs_fs_mount_common() for xdev mounts)

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[ herton: backport for 3.5:
  * don't change dprintk to print nfs_xdev_mount as we are still in
    nfs_xdev_mount_common
  * differing clone_server/nfs_fs_mount_common (function call and
    arguments), keep the same calls as in 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/super.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 2292f7e..f3cc9b6 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2541,7 +2541,6 @@ nfs_xdev_mount_common(struct file_system_type *fs_type, int flags,
 	struct nfs_clone_mount *data = mount_info->cloned;
 	struct nfs_server *server;
 	struct dentry *mntroot = ERR_PTR(-ENOMEM);
-	int error;
 
 	dprintk("--> nfs_xdev_mount_common()\n");
 
@@ -2549,19 +2548,15 @@ nfs_xdev_mount_common(struct file_system_type *fs_type, int flags,
 
 	/* create a new volume representation */
 	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, data->authflavor);
-	if (IS_ERR(server)) {
-		error = PTR_ERR(server);
-		goto out_err;
-	}
+	if (IS_ERR(server))
+		mntroot = ERR_CAST(server);
+	else
+		mntroot = nfs_fs_mount_common(fs_type, server, flags,
+				dev_name, mount_info);
 
-	mntroot = nfs_fs_mount_common(fs_type, server, flags, dev_name, mount_info);
-	dprintk("<-- nfs_xdev_mount_common() = 0\n");
-out:
+	dprintk("<-- nfs_xdev_mount_common() = %ld\n",
+			IS_ERR(mntroot) ? PTR_ERR(mntroot) : 0L);
 	return mntroot;
-
-out_err:
-	dprintk("<-- nfs_xdev_mount_common() = %d [error]\n", error);
-	goto out;
 }
 
 /*
-- 
1.7.9.5

