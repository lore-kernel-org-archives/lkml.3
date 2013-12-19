Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3LSX15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:27:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22129 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3LSX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:27:55 -0500
Date: Thu, 19 Dec 2013 15:27:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH] fuse: Fix IOC_[GS]ETFLAGS argument size brokenness
Message-ID: <20131219232739.GA10192@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOC_[GS]ETFLAGS ioctls, despite being defined to take a "long"
parameter, actually take "int" parameters.  FUSE unfortunately assumed
that the ioctl definitions never lie, and transfers a long's worth of
data in and out of userspace, which causes stack smashing in chattr,
and other bugs elsewhere.

So, special-case this in FUSE, and document this int/long quirk in
include/uapi/linux/fs.h.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/fuse/file.c          |   11 +++++++++++
 include/uapi/linux/fs.h |    1 +
 2 files changed, 12 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7e70506..5fa8181 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2385,6 +2385,17 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		iov->iov_base = (void __user *)arg;
 		iov->iov_len = _IOC_SIZE(cmd);
 
+		/*
+		 * The IOC_[GS]ETFLAGS ioctls take int parameters even though
+		 * the ioctl definition specifies long.  Userland has been
+		 * expecting int for ages (and chattr segfaults on FUSE
+		 * filesystems), so special case that here.  The IOC32
+		 * variants were declared with int, so they don't need this.
+		 */
+		if (cmd == FS_IOC_GETFLAGS || cmd == FS_IOC_SETFLAGS) {
+			iov->iov_len = sizeof(int);
+		}
+
 		if (_IOC_DIR(cmd) & _IOC_WRITE) {
 			in_iov = iov;
 			in_iovs = 1;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 6c28b61..bc8aa8e 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -154,6 +154,7 @@ struct inodes_stat_t {
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
 
+/* IOC_[GS]ETFLAGS take an int argument despite being defined to take long. */
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
