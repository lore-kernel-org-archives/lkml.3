Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbbAWMhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:37:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39463 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbbAWMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:37:09 -0500
X-AuditID: cbfee61a-f79c06d000004e71-1d-54c240733d6d
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: add F2FS_IOC_GETVERSION support
Date: Fri, 23 Jan 2015 20:36:04 +0800
Message-id: <000601d03709$4c803b90$e580b2b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA3CJa/M7h06Zy9RH2GyM3gdVJZ8Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd1ih0MhBqc2S1hc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49OChcwF
	X3gqll+NbGB8ytXFyMkhIWAi8XtzCxuELSZx4d56MFtIYDqjxPLjhl2MXED2D0aJ9wdPs4Mk
	2ARUJJZ3/GcCsUUEvCQm7T/BAmIzC3hINHZ8ZwWxhQUcJN5cfcAIYrMIqEp0P5oEFucVsJR4
	dXMpM4QtKPFj8j2oXi2J9TuPM0HY8hKb17xlhjhIQWLH2deMELv0JLov7mOHqBGX2HjkFssE
	RoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNDPpHYwrmyw
	OMQowMGoxMPbsOVgiBBrYllxZe4hRgkOZiURXmvNQyFCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eZXs20KEBNITS1KzU1MLUotgskwcnFINjC77Pe89v9N0Qai7J1JPJHat4M35LeauCcx3Kl89
	SQ9hcpxR+i306OWPrk/ffZk/0cFTtKL40StB/cBnGzZ9Y9mydqnYkYlte9fUP93y8A9bNN+U
	pyczzTqfHI71PTXXe19ZUtcN5gdTt+7VPS74+Oy/KV8VWkvlFqQ5nol8E1Ko/Ssu2PTbsm1K
	LMUZiYZazEXFiQBmvP2zZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch we add the FS_IOC_GETVERSION ioctl for getting i_generation from
inode, after that, users can list file's generation number by using "lsattr -v".

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h | 1 +
 fs/f2fs/file.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c2cf040..92e0b3a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -202,6 +202,7 @@ static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int size,
  */
 #define F2FS_IOC_GETFLAGS		FS_IOC_GETFLAGS
 #define F2FS_IOC_SETFLAGS		FS_IOC_SETFLAGS
+#define F2FS_IOC_GETVERSION		FS_IOC_GETVERSION
 
 #define F2FS_IOCTL_MAGIC		0xf5
 #define F2FS_IOC_START_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 1)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0d88a28..5cbbc9a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -926,6 +926,13 @@ out:
 	return ret;
 }
 
+static int f2fs_ioc_getversion(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+
+	return put_user(inode->i_generation, (int __user *)arg);
+}
+
 static int f2fs_ioc_start_atomic_write(struct file *filp)
 {
 	struct inode *inode = file_inode(filp);
@@ -1096,6 +1103,8 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_getflags(filp, arg);
 	case F2FS_IOC_SETFLAGS:
 		return f2fs_ioc_setflags(filp, arg);
+	case F2FS_IOC_GETVERSION:
+		return f2fs_ioc_getversion(filp, arg);
 	case F2FS_IOC_START_ATOMIC_WRITE:
 		return f2fs_ioc_start_atomic_write(filp);
 	case F2FS_IOC_COMMIT_ATOMIC_WRITE:
-- 
2.2.1


