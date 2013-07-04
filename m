Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3GDQYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:24:02 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34841 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3GDQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:23:59 -0400
Message-ID: <51D59FEE.6080301@gmail.com>
Date: Thu, 04 Jul 2013 18:16:46 +0200
From: Gmail <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        codalist@TELEMANN.coda.cs.cmu.edu
Subject: [PATCH 2/4] fsfreeze: added new file_start_write_killable
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace file_start_write with file_start_write_killable where
possible.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 drivers/block/loop.c |    4 +++-
 fs/aio.c             |    8 ++++++--
 fs/coda/file.c       |    4 +++-
 fs/read_write.c      |   38 ++++++++++++++++++++++----------------
 fs/splice.c          |    4 +++-
 include/linux/fs.h   |   17 +++++++++++++++++
 6 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d92d50f..c4f0b7b 100644
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
index 2bbcacf..9e18b80 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -915,8 +915,12 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb, int rw, aio_rw_op *rw_op)
 	if (iocb->ki_pos < 0)
 		return -EINVAL;
 
-	if (rw == WRITE)
-		file_start_write(file);
+	if (rw == WRITE) {
+		ret = file_start_write_killable(file);
+		if (ret < 0)
+			return ret;
+	}
+
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
index 0343000..f0393fe 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -439,21 +439,23 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 		return -EFAULT;
 
 	ret = rw_verify_area(WRITE, file, pos, count);
-	if (ret >= 0) {
-		count = ret;
-		file_start_write(file);
-		if (file->f_op->write)
-			ret = file->f_op->write(file, buf, count, pos);
-		else
-			ret = do_sync_write(file, buf, count, pos);
-		if (ret > 0) {
-			fsnotify_modify(file);
-			add_wchar(current, ret);
-		}
-		inc_syscw(current);
-		file_end_write(file);
+	if (ret < 0)
+		goto out;
+	count = ret;
+	ret = file_start_write_killable(file);
+	if (ret < 0)
+		goto out;
+	if (file->f_op->write)
+		ret = file->f_op->write(file, buf, count, pos);
+	else
+		ret = do_sync_write(file, buf, count, pos);
+	if (ret > 0) {
+		fsnotify_modify(file);
+		add_wchar(current, ret);
 	}
-
+	inc_syscw(current);
+	file_end_write(file);
+out:
 	return ret;
 }
 
@@ -721,7 +723,9 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	} else {
 		fn = (io_fn_t)file->f_op->write;
 		fnv = file->f_op->aio_write;
-		file_start_write(file);
+		ret = file_start_write_killable(file);
+		if (ret < 0)
+			goto out;
 	}
 
 	if (fnv)
@@ -901,7 +905,9 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
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
index 1c75053..9bd3326 100644
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
