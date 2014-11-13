Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbaKMV3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:54 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59971 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794AbaKMV3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:51 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel@lists.sourceforge.net (open list:FUSE: FILESYSTEM...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 23/56] fs/fuse: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:00 +0100
Message-Id: <1415913813-362-24-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from fuse when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/fuse/dev.c  | 8 ++++++--
 fs/fuse/file.c | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ca88731..c082b72 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1291,6 +1291,7 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 	return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 				    struct pipe_inode_info *pipe,
 				    size_t len, unsigned int flags)
@@ -1368,6 +1369,7 @@ out:
 	kfree(bufs);
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static int fuse_notify_poll(struct fuse_conn *fc, unsigned int size,
 			    struct fuse_copy_state *cs)
@@ -1894,6 +1896,7 @@ static ssize_t fuse_dev_write(struct kiocb *iocb, const struct iovec *iov,
 	return fuse_dev_do_write(fc, &cs, iov_length(iov, nr_segs));
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 				     struct file *out, loff_t *ppos,
 				     size_t len, unsigned int flags)
@@ -1971,6 +1974,7 @@ out:
 	kfree(bufs);
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static unsigned fuse_dev_poll(struct file *file, poll_table *wait)
 {
@@ -2144,10 +2148,10 @@ const struct file_operations fuse_dev_operations = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= fuse_dev_read,
-	.splice_read	= fuse_dev_splice_read,
+	SPLICE_READ_INIT(fuse_dev_splice_read)
 	.write		= do_sync_write,
 	.aio_write	= fuse_dev_write,
-	.splice_write	= fuse_dev_splice_write,
+	SPLICE_WRITE_INIT(fuse_dev_splice_write)
 	.poll		= fuse_dev_poll,
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 912061a..97f060a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3042,7 +3042,7 @@ static const struct file_operations fuse_file_operations = {
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.unlocked_ioctl	= fuse_file_ioctl,
 	.compat_ioctl	= fuse_file_compat_ioctl,
 	.poll		= fuse_file_poll,
-- 
1.9.1

