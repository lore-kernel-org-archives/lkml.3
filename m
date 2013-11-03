Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3KCJyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:54:10 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:52421 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3KCJyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:54:03 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/39] sysfs, kernfs: no need to kern_mount() sysfs from sysfs_init()
Date: Sun,  3 Nov 2013 04:53:10 -0500
Message-Id: <1383472398-17812-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been very long since sysfs depended on vfs to keep track of
internal states and whether sysfs is mounted or not doesn't make any
difference to sysfs's internal operation.

In addition to init and filesystem type registration, sysfs_init()
invokes kern_mount() to create in-kernel mount of sysfs.  This
internal mounting doesn't server any purpose anymore.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/mount.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index fcbe5e8..0c80f03 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -24,7 +24,6 @@
 #include "sysfs.h"
 
 
-static struct vfsmount *sysfs_mnt;
 struct kmem_cache *sysfs_dir_cachep;
 
 static const struct super_operations sysfs_ops = {
@@ -153,34 +152,26 @@ static struct file_system_type sysfs_fs_type = {
 
 int __init sysfs_init(void)
 {
-	int err = -ENOMEM;
+	int err;
 
 	sysfs_dir_cachep = kmem_cache_create("sysfs_dir_cache",
 					      sizeof(struct sysfs_dirent),
 					      0, 0, NULL);
 	if (!sysfs_dir_cachep)
-		goto out;
+		return -ENOMEM;
 
 	err = sysfs_inode_init();
 	if (err)
 		goto out_err;
 
 	err = register_filesystem(&sysfs_fs_type);
-	if (!err) {
-		sysfs_mnt = kern_mount(&sysfs_fs_type);
-		if (IS_ERR(sysfs_mnt)) {
-			printk(KERN_ERR "sysfs: could not mount!\n");
-			err = PTR_ERR(sysfs_mnt);
-			sysfs_mnt = NULL;
-			unregister_filesystem(&sysfs_fs_type);
-			goto out_err;
-		}
-	} else
+	if (err)
 		goto out_err;
-out:
-	return err;
+
+	return 0;
+
 out_err:
 	kmem_cache_destroy(sysfs_dir_cachep);
 	sysfs_dir_cachep = NULL;
-	goto out;
+	return err;
 }
-- 
1.8.3.1

