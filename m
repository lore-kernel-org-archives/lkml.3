Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab3ENPXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:23:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3ENPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:23:16 -0400
Message-ID: <519256D8.9000807@canonical.com>
Date: Tue, 14 May 2013 10:23:04 -0500
From: Dave Chiluk <chiluk@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org
Subject: ncpfs [Regression] rmdir and rm -rf fail with device busy
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rmdir and or rm -rf are failing on an ncpfs mounted directory.

for example
root@precise:/mnt/ncp# mkdir a ; rmdir a
rmdir: failed to remove `a': Device or resource busy


I bisected the change that introduced the regression to .
commit 1d2ef5901483004d74947bbf78d5146c24038fe7 which follows.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
diff --git a/fs/namei.c b/fs/namei.c
index b52bc68..f478836 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2616,6 +2616,7 @@ int vfs_rmdir(struct inode *dir, struct dentry
*dentry)
        if (!dir->i_op->rmdir)
                return -EPERM;

+       dget(dentry);
        mutex_lock(&dentry->d_inode->i_mutex);

        error = -EBUSY;
@@ -2636,6 +2637,7 @@ int vfs_rmdir(struct inode *dir, struct dentry
*dentry)

 out:
        mutex_unlock(&dentry->d_inode->i_mutex);
+       dput(dentry);
        if (!error)
                d_delete(dentry);
        return error;
@@ -3025,6 +3027,7 @@ static int vfs_rename_dir(struct inode *old_dir,
struct dentry
        if (error)
                return error;

+       dget(new_dentry);
        if (target)
                mutex_lock(&target->i_mutex);

@@ -3045,6 +3048,7 @@ static int vfs_rename_dir(struct inode *old_dir,
struct dentry
 out:
        if (target)
                mutex_unlock(&target->i_mutex);
+       dput(new_dentry);
        if (!error)
                if (!(old_dir->i_sb->s_type->fs_flags &
FS_RENAME_DOES_D_MOVE))
                        d_move(old_dentry,new_dentry);
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Unfortunately this looks like a good patch.

So I narrowed down the the error path to the following two lines
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 8163260..5701aed 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1035,8 +1035,6 @@ static int ncp_rmdir(struct inode *dir, struct
dentry *dentry)
         */
        dentry_unhash(dentry);
        error = -EBUSY;
-       if (!d_unhashed(dentry))
-               goto out;

        len = sizeof(__name);
        error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
However these are necessary as without them, the directory can be
removed when it is actually in use.

So does anyone have any suggestions on how to fix this?

Thanks,
Dave.
