Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab3LHOF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:05:57 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39902 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3LHOFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:05:53 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v4 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Date: Sun,  8 Dec 2013 23:05:44 +0900
Message-Id: <1386511544-3676-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate.
updated detailed semantics in comments.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |   24 +++++++++++++++++++++---
 include/uapi/linux/falloc.h |   21 +++++++++++++++++++++
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 4b3e1ed..4a923a5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -231,7 +231,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
@@ -239,11 +240,20 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    !(mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
+	/* Collapse range should only be used exclusively. */
+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
+	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	/* It's not possible punch hole on append only file */
-	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
+	/*
+	 * It's not possible to punch hole or perform collapse range
+	 * on append only file
+	 */
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
+	    && IS_APPEND(inode))
 		return -EPERM;
 
 	if (IS_IMMUTABLE(inode))
@@ -271,6 +281,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
 		return -EFBIG;
 
+	/*
+	 * There is no need to overlap collapse range with EOF, in which case
+	 * it is effectively a truncate operation
+	 */
+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
+	    (offset + len >= i_size_read(inode)))
+		return -EINVAL;
+
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 990c4cc..5b214cc 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -5,5 +5,26 @@
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
 #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
 
+/*
+ * FALLOC_FL_COLLAPSE_RANGE is used to remove a range of a file
+ * without leaving a hole in the file. The contents of the file beyond
+ * the range being removed is appended to the start offset of the range
+ * being removed (i.e. the hole that was punched is "collapsed"),
+ * resulting in a file layout that looks like the range that was
+ * removed never existed. As such collapsing a range of a file changes
+ * the size of the file, reducing it by the same length of the range
+ * that has been removed by the operation.
+ *
+ * Different filesystems may implement different limitations on the
+ * granularity of the operation. Most will limit operations to
+ * filesystem block size boundaries, but this boundary may be larger or
+ * smaller depending on the filesystem and/or the configuration of the
+ * filesystem or file.
+ *
+ * Attempting to collapse a range that crosses the end of the file is
+ * considered an illegal operation - just use ftruncate(2) if you need
+ * to collapse a range that crosses EOF.
+ */
+#define FALLOC_FL_COLLAPSE_RANGE	0x08
 
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.9.5

