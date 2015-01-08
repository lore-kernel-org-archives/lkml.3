Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbbAHSLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:11:11 -0500
Received: from mail.kernel.org ([198.145.29.136]:58415 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbbAHSLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:11:08 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/6] f2fs: support goingdown for fs shutdown
Date: Thu,  8 Jan 2015 10:10:57 -0800
Message-Id: <1420740661-72288-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an ioctl to shutdown f2fs, which stops all the further block
writes after this point.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/file.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ba30218..febad35 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -209,6 +209,7 @@ static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int size,
 #define F2FS_IOC_START_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 3)
 #define F2FS_IOC_RELEASE_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 4)
 #define F2FS_IOC_ABORT_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 5)
+#define F2FS_IOC_GOINGDOWN		_IO(F2FS_IOCTL_MAGIC, 6)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5df3367..de2f669 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1020,6 +1020,18 @@ static int f2fs_ioc_abort_volatile_write(struct file *filp)
 	return ret;
 }
 
+static int f2fs_ioc_goingdown(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	f2fs_stop_checkpoint(sbi);
+	return 0;
+}
+
 static int f2fs_ioc_fitrim(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1067,6 +1079,8 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_release_volatile_write(filp);
 	case F2FS_IOC_ABORT_VOLATILE_WRITE:
 		return f2fs_ioc_abort_volatile_write(filp);
+	case F2FS_IOC_GOINGDOWN:
+		return f2fs_ioc_goingdown(filp);
 	case FITRIM:
 		return f2fs_ioc_fitrim(filp, arg);
 	default:
-- 
2.1.1

