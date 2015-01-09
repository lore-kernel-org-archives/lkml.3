Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbbAIJfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:35:04 -0500
Received: from mail.kernel.org ([198.145.29.136]:58816 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbbAIJe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:34:58 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, xfs@oss.sgi.com
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] f2fs: support fs shutdown
Date: Fri,  9 Jan 2015 01:34:36 -0800
Message-Id: <1420796076-82847-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420796076-82847-1-git-send-email-jaegeuk@kernel.org>
References: <1420796076-82847-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an ioctl to shutdown f2fs, which stops all the further block
writes after this point.

The ioctl, FS_IOC_SHUTDOWN, provides the following three options.

1. FS_GOING_DOWN_FULLSYNC
 : this will flush all the data and dentry blocks, and do checkpoint before
 shutdown.

2. FS_GOING_DOWN_METASYNC
 : this will do checkpoint before shutdown.

3. FS_GOING_DOWN_NOSYNC
 : this will trigger shutdown as is.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5df3367..a7114858 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1020,6 +1020,41 @@ static int f2fs_ioc_abort_volatile_write(struct file *filp)
 	return ret;
 }
 
+static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct super_block *sb = sbi->sb;
+	__u32 in;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (get_user(in, (__u32 __user *)arg))
+		return -EFAULT;
+
+	switch (in) {
+	case FS_GOING_DOWN_FULLSYNC:
+		sb = freeze_bdev(sb->s_bdev);
+		if (sb && !IS_ERR(sb)) {
+			f2fs_stop_checkpoint(sbi);
+			thaw_bdev(sb->s_bdev, sb);
+		}
+		break;
+	case FS_GOING_DOWN_METASYNC:
+		/* do checkpoint only */
+		f2fs_sync_fs(sb, 1);
+		f2fs_stop_checkpoint(sbi);
+		break;
+	case FS_GOING_DOWN_NOSYNC:
+		f2fs_stop_checkpoint(sbi);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int f2fs_ioc_fitrim(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1067,6 +1102,8 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_release_volatile_write(filp);
 	case F2FS_IOC_ABORT_VOLATILE_WRITE:
 		return f2fs_ioc_abort_volatile_write(filp);
+	case FS_IOC_SHUTDOWN:
+		return f2fs_ioc_shutdown(filp, arg);
 	case FITRIM:
 		return f2fs_ioc_fitrim(filp, arg);
 	default:
-- 
2.1.1

