Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaKVVCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 16:02:00 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32945 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKVVB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 16:01:57 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Miklos Szeredi <miklos@szeredi.hu>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        fuse-devel@lists.sourceforge.net (open list:FUSE: FILESYSTEM...),
        linux-kernel@vger.kernel.org (open list),
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/6] fs/fuse: support compiling out splice
Date: Sat, 22 Nov 2014 21:59:59 +0100
Message-Id: <1416690001-20817-5-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416690001-20817-1-git-send-email-pieter@boesman.nl>
References: <1416690001-20817-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from fuse when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/fuse/dev.c      | 4 ++--
 include/linux/fs.h | 6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ca88731..f8f92a4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1291,7 +1291,7 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 	return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
 }
 
-static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
+static ssize_t __maybe_unused fuse_dev_splice_read(struct file *in, loff_t *ppos,
 				    struct pipe_inode_info *pipe,
 				    size_t len, unsigned int flags)
 {
@@ -2144,7 +2144,7 @@ const struct file_operations fuse_dev_operations = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= fuse_dev_read,
-	.splice_read	= fuse_dev_splice_read,
+	.splice_read	= __splice_p(fuse_dev_splice_read),
 	.write		= do_sync_write,
 	.aio_write	= fuse_dev_write,
 	.splice_write	= fuse_dev_splice_write,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a957d43..04c0975 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2443,6 +2443,12 @@ extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 			int datasync);
 extern void block_sync_page(struct page *page);
 
+#ifdef CONFIG_SYSCALL_SPLICE
+#define __splice_p(x) x
+#else
+#define __splice_p(x) NULL
+#endif
+
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
-- 
1.9.1

