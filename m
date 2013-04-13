Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3DMKoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:44:03 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49901 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3DMKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:44:01 -0400
Message-ID: <51693542.6080808@gmail.com>
Date: Sat, 13 Apr 2013 12:36:50 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] fsfreeze: added new file_start_write_killable
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace file_start_write with file_start_write_killable where
possible.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 drivers/block/loop.c |    4 +++-
 fs/aio.c             |    7 +++++--
 fs/coda/file.c       |    4 +++-
 fs/read_write.c      |   28 +++++++++++++++++-----------
 fs/splice.c          |    4 +++-
 include/linux/fs.h   |   17 +++++++++++++++++
 6 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index be9a101..2c0d0a3 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -230,7 +230,9 @@ static int __do_lo_send_write(struct file *file,
 	ssize_t bw;
 	mm_segment_t old_fs = get_fs();
 
-	file_start_write(file);
+	bw = file_start_write_killable(file);
+	if (bw < 0)
+		return bw;
 	set_fs(get_ds());
 	bw = file->f_op->write(file, buf, len, &pos);
 	set_fs(old_fs);
diff --git a/fs/aio.c b/fs/aio.c
index 5b7ed78..5deddf5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1103,8 +1103,11 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb, int rw, aio_rw_op *rw_op)
 	if (iocb->ki_pos < 0)
 		return -EINVAL;
 
-	if (rw == WRITE)
-		file_start_write(file);
+	if (rw == WRITE) {
+		ret = file_start_write_killable(file);
+		if (ret < 0)
+			return ret;
+	}
 	do {
 		ret = rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
 			    iocb->ki_nr_segs - iocb->ki_cur_seg,
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 380b798..c5708d0 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -79,7 +79,9 @@ coda_file_write(struct file *coda_file, const char __user *buf, size_t count, lo
 		return -EINVAL;
 
 	host_inode = file_inode(host_file);
-	file_start_write(host_file);
+	ret = file_start_write_killable(host_file);
+	if (ret < 0)
+		return ret;
 	mutex_lock(&coda_inode->i_mutex);
 
 	ret = host_file->f_op->write(host_file, buf, count, ppos);
diff --git a/fs/read_write.c b/fs/read_write.c
index 7eb7ef3..ed9006f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -438,17 +438,19 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 	ret = rw_verify_area(WRITE, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
-		file_start_write(file);
-		if (file->f_op->write)
-			ret = file->f_op->write(file, buf, count, pos);
-		else
-			ret = do_sync_write(file, buf, count, pos);
+		ret = file_start_write_killable(file);
 		if (ret > 0) {
-			fsnotify_modify(file);
-			add_wchar(current, ret);
+			if (file->f_op->write)
+				ret = file->f_op->write(file, buf, count, pos);
+			else
+				ret = do_sync_write(file, buf, count, pos);
+			if (ret > 0) {
+				fsnotify_modify(file);
+				add_wchar(current, ret);
+			}
+			inc_syscw(current);
+			file_end_write(file);
 		}
-		inc_syscw(current);
-		file_end_write(file);
 	}
 
 	return ret;
@@ -718,7 +720,9 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	} else {
 		fn = (io_fn_t)file->f_op->write;
 		fnv = file->f_op->aio_write;
-		file_start_write(file);
+		ret = file_start_write_killable(file);
+		if (ret < 0)
+			goto out;
 	}
 
 	if (fnv)
@@ -898,7 +902,9 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 	} else {
 		fn = (io_fn_t)file->f_op->write;
 		fnv = file->f_op->aio_write;
-		file_start_write(file);
+		ret = file_start_write_killable(file);
+		if (ret < 0)
+			goto out;
 	}
 
 	if (fnv)
diff --git a/fs/splice.c b/fs/splice.c
index e6b2559..b37c30e 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1115,7 +1115,9 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	else
 		splice_write = default_file_splice_write;
 
-	file_start_write(out);
+	ret = file_start_write_killable(out);
+	if (ret < 0)
+		return ret;
 	ret = splice_write(pipe, out, ppos, len, flags);
 	file_end_write(out);
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c8b7325..998ec2a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1404,6 +1404,16 @@ static inline void sb_start_write(struct super_block *sb)
 	__sb_start_write(sb, SB_FREEZE_WRITE, FREEZE_WAIT);
 }
 
+/**
+ * sb_start_write_killable - get write access to a superblock
+ * @sb: the super we write to
+ *
+ */
+static inline int sb_start_write_killable(struct super_block *sb)
+{
+	return __sb_start_write(sb, SB_FREEZE_WRITE, FREEZE_WAIT_KILLABLE);
+}
+
 static inline int sb_start_write_trylock(struct super_block *sb)
 {
 	return __sb_start_write(sb, SB_FREEZE_WRITE, FREEZE_NOWAIT);
@@ -2227,6 +2237,13 @@ static inline struct inode *file_inode(struct file *f)
 	return f->f_inode;
 }
 
+static inline int file_start_write_killable(struct file *file)
+{
+	if (!S_ISREG(file_inode(file)->i_mode))
+		return 1;
+	return sb_start_write_killable(file_inode(file)->i_sb);
+}
+
 static inline void file_start_write(struct file *file)
 {
 	if (!S_ISREG(file_inode(file)->i_mode))
-- 
1.7.3.4
