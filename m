Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbbAIBkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 20:40:13 -0500
Received: from mail.kernel.org ([198.145.29.136]:48120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbbAIBkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 20:40:12 -0500
Date: Thu, 8 Jan 2015 17:40:06 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 2/6 v2] f2fs: support goingdown for fs shutdown
Message-ID: <20150109014006.GA79749@jaegeuk-mac02>
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
 <1420740661-72288-2-git-send-email-jaegeuk@kernel.org>
 <54AEE06C.90806@sandeen.net>
 <20150108201843.GA74570@jaegeuk-mac02>
 <54AEE98D.5010103@sandeen.net>
 <20150108205416.GE25000@dastard>
 <20150108211853.GB74570@jaegeuk-mac02>
 <20150108220412.GI25000@dastard>
 <20150108221630.GA76957@jaegeuk-mac02>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108221630.GA76957@jaegeuk-mac02>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o introduce FS_IOC_GOINGDOWN ioctl
 o introduce three options: FS_GOING_DOWN_FULLSYNC, FS_GOING_DOWN_METASYNC,
   and FS_GOING_DOWN_NOSYNC

This patch add an ioctl to shutdown f2fs, which stops all the further block
writes after this point.

The ioctl, FS_IOC_GOINGDOWN, provides the following three options.

1. FS_GOING_DOWN_FULLSYNC
 : this will flush all the data and dentry blocks, and do checkpoint before
 shutdown.

2. FS_GOING_DOWN_METASYNC
 : this will do checkpoint before shutdown.

3. FS_GOING_DOWN_NOSYNC
 : this will trigger shutdown as is.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c          | 37 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |  8 ++++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5df3367..474fb91 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1020,6 +1020,41 @@ static int f2fs_ioc_abort_volatile_write(struct file *filp)
 	return ret;
 }
 
+static int f2fs_ioc_goingdown(struct file *filp, unsigned long arg)
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
+	case FS_IOC_GOINGDOWN:
+		return f2fs_ioc_goingdown(filp, arg);
 	case FITRIM:
 		return f2fs_ioc_fitrim(filp, arg);
 	default:
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3735fa0..f37c699 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -157,6 +157,7 @@ struct inodes_stat_t {
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#define FS_IOC_GOINGDOWN	_IOR('X', 125, __u32)	/* shutdown */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -205,4 +206,11 @@ struct inodes_stat_t {
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/*
+ * Flags for going down operation used by FS_IOC_GOINGDOWN
+ */
+#define FS_GOING_DOWN_FULLSYNC	0x0	/* going down with full sync */
+#define FS_GOING_DOWN_METASYNC	0x1	/* going down with metadata */
+#define FS_GOING_DOWN_NOSYNC	0x2	/* going down */
+
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.1.1

