Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaIZEzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:55:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:57067 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbaIZEy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:54:56 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/4] f2fs: clean up f2fs_ioctl functions
Date: Thu, 25 Sep 2014 21:54:46 -0700
Message-Id: <1411707287-21760-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.9.3 (Apple Git-50)
In-Reply-To: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
References: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up f2fs_ioctl functions for better readability.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 168 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 90 insertions(+), 78 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d7528c4..d203668 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -805,6 +805,93 @@ static inline __u32 f2fs_mask_flags(umode_t mode, __u32 flags)
 		return flags & F2FS_OTHER_FLMASK;
 }
 
+static int f2fs_ioc_getflags(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	unsigned int flags = fi->i_flags & FS_FL_USER_VISIBLE;
+	return put_user(flags, (int __user *)arg);
+}
+
+static int f2fs_ioc_setflags(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	unsigned int flags = fi->i_flags & FS_FL_USER_VISIBLE;
+	unsigned int oldflags;
+	int ret;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	if (!inode_owner_or_capable(inode)) {
+		ret = -EACCES;
+		goto out;
+	}
+
+	if (get_user(flags, (int __user *)arg)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	flags = f2fs_mask_flags(inode->i_mode, flags);
+
+	mutex_lock(&inode->i_mutex);
+
+	oldflags = fi->i_flags;
+
+	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+		if (!capable(CAP_LINUX_IMMUTABLE)) {
+			mutex_unlock(&inode->i_mutex);
+			ret = -EPERM;
+			goto out;
+		}
+	}
+
+	flags = flags & FS_FL_USER_MODIFIABLE;
+	flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
+	fi->i_flags = flags;
+	mutex_unlock(&inode->i_mutex);
+
+	f2fs_set_inode_flags(inode);
+	inode->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(inode);
+out:
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
+static int f2fs_ioc_fitrim(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct super_block *sb = inode->i_sb;
+	struct request_queue *q = bdev_get_queue(sb->s_bdev);
+	struct fstrim_range range;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!blk_queue_discard(q))
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&range, (struct fstrim_range __user *)arg,
+				sizeof(range)))
+		return -EFAULT;
+
+	range.minlen = max((unsigned int)range.minlen,
+				q->limits.discard_granularity);
+	ret = f2fs_trim_fs(F2FS_SB(sb), &range);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user((struct fstrim_range __user *)arg, &range,
+				sizeof(range)))
+		return -EFAULT;
+	return 0;
+}
+
 static int f2fs_ioc_atomic_write(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -858,92 +945,17 @@ static int f2fs_ioc_atomic_commit(struct file *filp, unsigned long arg)
 
 long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file_inode(filp);
-	struct f2fs_inode_info *fi = F2FS_I(inode);
-	unsigned int flags;
-	int ret;
-
 	switch (cmd) {
 	case F2FS_IOC_GETFLAGS:
-		flags = fi->i_flags & FS_FL_USER_VISIBLE;
-		return put_user(flags, (int __user *) arg);
+		return f2fs_ioc_getflags(filp, arg);
 	case F2FS_IOC_SETFLAGS:
-	{
-		unsigned int oldflags;
-
-		ret = mnt_want_write_file(filp);
-		if (ret)
-			return ret;
-
-		if (!inode_owner_or_capable(inode)) {
-			ret = -EACCES;
-			goto out;
-		}
-
-		if (get_user(flags, (int __user *) arg)) {
-			ret = -EFAULT;
-			goto out;
-		}
-
-		flags = f2fs_mask_flags(inode->i_mode, flags);
-
-		mutex_lock(&inode->i_mutex);
-
-		oldflags = fi->i_flags;
-
-		if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
-			if (!capable(CAP_LINUX_IMMUTABLE)) {
-				mutex_unlock(&inode->i_mutex);
-				ret = -EPERM;
-				goto out;
-			}
-		}
-
-		flags = flags & FS_FL_USER_MODIFIABLE;
-		flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
-		fi->i_flags = flags;
-		mutex_unlock(&inode->i_mutex);
-
-		f2fs_set_inode_flags(inode);
-		inode->i_ctime = CURRENT_TIME;
-		mark_inode_dirty(inode);
-out:
-		mnt_drop_write_file(filp);
-		return ret;
-	}
+		return f2fs_ioc_setflags(filp, arg);
 	case F2FS_IOC_ATOMIC_WRITE:
 		return f2fs_ioc_atomic_write(filp, arg);
 	case F2FS_IOC_ATOMIC_COMMIT:
 		return f2fs_ioc_atomic_commit(filp, arg);
 	case FITRIM:
-	{
-		struct super_block *sb = inode->i_sb;
-		struct request_queue *q = bdev_get_queue(sb->s_bdev);
-		struct fstrim_range range;
-		int ret = 0;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (!blk_queue_discard(q))
-			return -EOPNOTSUPP;
-
-		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
-					sizeof(range)))
-			return -EFAULT;
-
-		range.minlen = max((unsigned int)range.minlen,
-				   q->limits.discard_granularity);
-		ret = f2fs_trim_fs(F2FS_SB(sb), &range);
-		if (ret < 0)
-			return ret;
-
-		if (copy_to_user((struct fstrim_range __user *)arg, &range,
-					sizeof(range)))
-			return -EFAULT;
-
-		return 0;
-	}
+		return f2fs_ioc_fitrim(filp, arg);
 	default:
 		return -ENOTTY;
 	}
-- 
1.9.3 (Apple Git-50)

