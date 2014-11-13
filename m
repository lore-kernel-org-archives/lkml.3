Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398AbaKMVZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:25:20 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52659 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934043AbaKMVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:25:18 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 02/56] moved kernel_write out of splice translation unit
Date: Thu, 13 Nov 2014 22:22:39 +0100
Message-Id: <1415913813-362-3-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_write shares infrastructure with the read_write translation unit but not
with the splice translation unit. Grouping kernel_write with the read_write
translation unit is more logical. It also paves the way to compiling out the
splice group of syscalls for embedded systems that do not need them.

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/read_write.c | 16 ++++++++++++++++
 fs/splice.c     | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3f7f04d..4361261 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1189,3 +1189,19 @@ COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
 }
 #endif
 
+ssize_t kernel_write(struct file *file, const char *buf, size_t count,
+			    loff_t pos)
+{
+	mm_segment_t old_fs;
+	ssize_t res;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	/* The cast to a user pointer is valid due to the set_fs() */
+	res = vfs_write(file, (__force const char __user *)buf, count, &pos);
+	set_fs(old_fs);
+
+	return res;
+}
+EXPORT_SYMBOL(kernel_write);
+
diff --git a/fs/splice.c b/fs/splice.c
index c1a2861..44b201b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -583,22 +583,6 @@ static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
 	return res;
 }
 
-ssize_t kernel_write(struct file *file, const char *buf, size_t count,
-			    loff_t pos)
-{
-	mm_segment_t old_fs;
-	ssize_t res;
-
-	old_fs = get_fs();
-	set_fs(get_ds());
-	/* The cast to a user pointer is valid due to the set_fs() */
-	res = vfs_write(file, (__force const char __user *)buf, count, &pos);
-	set_fs(old_fs);
-
-	return res;
-}
-EXPORT_SYMBOL(kernel_write);
-
 ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
-- 
1.9.1

