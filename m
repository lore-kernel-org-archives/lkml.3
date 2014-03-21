Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbaCUCEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:04:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38372 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965053AbaCUCDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:03:17 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-97-532b9dd99329
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: introduce fi->i_sem to protect fi's info
Date: Fri, 21 Mar 2014 11:01:13 +0900
Message-id: <1395367275-1674-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zfd1bc7WDDRZeYbS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+P+oU7GgkaDihNb
	LjA3MM5U72Lk5JAQMJFYvXAHK4QtJnHh3nq2LkYuDiGBZYwSX+58YYYp+nlxBVRiOqPE5f8v
	WSGcTiaJkzc+ATkcHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQBLCAs4SN5e3g9ks
	AqoSPXNegNm8Am4Sr76+YIfYpi2x7flEsGYJgdtsEhu3bmSDaBCQ+Db5EAvIMgkBWYlNB6Cu
	k5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQoJw4g7G+wesDzEmA42b
	yCwlmpwPDOK8knhDYzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamA8tfLawoXhTe9e5cpzTHN4b1gofnhvQvvzZbYi9yuOurHezFzPf1L325HqvVlHolW8
	Ts9Zu1lJxTq77PKki38uPbXSPfx0Y3ahsO9NgzN+0ncPK89ewXJCQtdlmutvqeaco5PSpopO
	3dBmzLlm60ov/plLZGdvu5fApuntuyA5+5rQXf5Fmx6uV2Ipzkg01GIuKk4EAO012sNYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd2bc7WDDf7dsrS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj/qFOxoJGg4oTWy4wNzDOVO9i5OSQEDCR+HlxBRuELSZx4d56IJuLQ0hg
	OqPE5f8vWSGcTiaJkzc+ATkcHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQBLCAs4S
	N5e3g9ksAqoSPXNegNm8Am4Sr76+YIfYpi2x7flExgmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBIf4M+kdjKsaLA4xCnAwKvHwVnBqBwuxJpYVV+YeYpTgYFYS4X3dDRTiTUms
	rEotyo8vKs1JLT7EmAy0fSKzlGhyPjD+8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBMUD2gaibhoss394N99VP3fwj/JzV6pdE2jkrddV7dza9dGlZZ1Rv
	N/VP3v4VQcp3zQ2sH/+Jd+WYIco6/aPt9YoqnxO7PZdOcfbqTOmWbjoi5nd/O8+8CpbJ8xNL
	N1fL3mOL9D+z6vrbhJke1zK2ZpnFuv6dKa18t2Tx710qG9dqpQXt/fyaXYmlOCPRUIu5qDgR
	AEAyWk21AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces fi->i_sem to protect fi's info that includes xattr_ver,
pino, i_nlink.
This enables to remove i_mutex during f2fs_sync_file, resulting in performance
improvement when a number of fsync calls are triggered from many concurrent
threads.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c   |  6 ++++++
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/file.c  | 14 ++++++++++----
 fs/f2fs/namei.c |  7 +++++++
 fs/f2fs/super.c |  1 +
 fs/f2fs/xattr.c |  3 +++
 6 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 7c9b17c..972fd0e 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -493,6 +493,7 @@ start:
 add_dentry:
 	f2fs_wait_on_page_writeback(dentry_page, DATA);
 
+	down_write(&F2FS_I(inode)->i_sem);
 	page = init_inode_metadata(inode, dir, name);
 	if (IS_ERR(page)) {
 		err = PTR_ERR(page);
@@ -515,6 +516,8 @@ add_dentry:
 
 	update_parent_metadata(dir, inode, current_depth);
 fail:
+	up_write(&F2FS_I(inode)->i_sem);
+
 	if (is_inode_flag_set(F2FS_I(dir), FI_UPDATE_DIR)) {
 		update_inode_page(dir);
 		clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
@@ -559,6 +562,8 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	if (inode) {
 		struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 
+		down_write(&F2FS_I(inode)->i_sem);
+
 		if (S_ISDIR(inode->i_mode)) {
 			drop_nlink(dir);
 			update_inode_page(dir);
@@ -569,6 +574,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 			drop_nlink(inode);
 			i_size_write(inode, 0);
 		}
+		up_write(&F2FS_I(inode)->i_sem);
 		update_inode_page(inode);
 
 		if (inode->i_nlink == 0)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 05c6524..469779a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -210,6 +210,7 @@ struct f2fs_inode_info {
 
 	/* Use below internally in f2fs*/
 	unsigned long flags;		/* use to pass per-file flags */
+	struct rw_semaphore i_sem;	/* protect fi info */
 	atomic_t dirty_dents;		/* # of dirty dentry pages */
 	f2fs_hash_t chash;		/* hash value of given file name */
 	unsigned int clevel;		/* maximum level of given file name */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e755ee5..a9474cd 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -111,6 +111,7 @@ static int get_parent_ino(struct inode *inode, nid_t *pino)
 int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
+	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int ret = 0;
 	bool need_cp = false;
@@ -133,7 +134,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	/* guarantee free sections for fsync */
 	f2fs_balance_fs(sbi);
 
-	mutex_lock(&inode->i_mutex);
+	down_read(&fi->i_sem);
 
 	/*
 	 * Both of fdatasync() and fsync() are able to be recovered from
@@ -150,21 +151,27 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	else if (F2FS_I(inode)->xattr_ver == cur_cp_version(F2FS_CKPT(sbi)))
 		need_cp = true;
 
+	up_read(&fi->i_sem);
+
 	if (need_cp) {
 		nid_t pino;
 
-		F2FS_I(inode)->xattr_ver = 0;
-
 		/* all the dirty node pages should be flushed for POR */
 		ret = f2fs_sync_fs(inode->i_sb, 1);
+
+		down_write(&fi->i_sem);
+		F2FS_I(inode)->xattr_ver = 0;
 		if (file_wrong_pino(inode) && inode->i_nlink == 1 &&
 					get_parent_ino(inode, &pino)) {
 			F2FS_I(inode)->i_pino = pino;
 			file_got_pino(inode);
+			up_write(&fi->i_sem);
 			mark_inode_dirty_sync(inode);
 			ret = f2fs_write_inode(inode, NULL);
 			if (ret)
 				goto out;
+		} else {
+			up_write(&fi->i_sem);
 		}
 	} else {
 		/* if there is no written node page, write its inode page */
@@ -180,7 +187,6 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	}
 out:
-	mutex_unlock(&inode->i_mutex);
 	trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
 	return ret;
 }
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 397d459..0cea874 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -424,12 +424,17 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 
 		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
+		down_write(&F2FS_I(old_inode)->i_sem);
 		F2FS_I(old_inode)->i_pino = new_dir->i_ino;
+		up_write(&F2FS_I(old_inode)->i_sem);
 
 		new_inode->i_ctime = CURRENT_TIME;
+		down_write(&F2FS_I(new_inode)->i_sem);
 		if (old_dir_entry)
 			drop_nlink(new_inode);
 		drop_nlink(new_inode);
+		up_write(&F2FS_I(new_inode)->i_sem);
+
 		mark_inode_dirty(new_inode);
 
 		if (!new_inode->i_nlink)
@@ -459,7 +464,9 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (old_dir != new_dir) {
 			f2fs_set_link(old_inode, old_dir_entry,
 						old_dir_page, new_dir);
+			down_write(&F2FS_I(old_inode)->i_sem);
 			F2FS_I(old_inode)->i_pino = new_dir->i_ino;
+			up_write(&F2FS_I(old_inode)->i_sem);
 			update_inode_page(old_inode);
 		} else {
 			kunmap(old_dir_page);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 34c47b2..89ea046 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -360,6 +360,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	fi->i_current_depth = 1;
 	fi->i_advise = 0;
 	rwlock_init(&fi->ext.ext_lock);
+	init_rwsem(&fi->i_sem);
 
 	set_inode_flag(fi, FI_NEW_INODE);
 
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 89d0422..8419130 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -590,7 +590,10 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 	f2fs_balance_fs(sbi);
 
 	f2fs_lock_op(sbi);
+	/* protect xattr_ver */
+	down_write(&F2FS_I(inode)->i_sem);
 	err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage);
+	up_write(&F2FS_I(inode)->i_sem);
 	f2fs_unlock_op(sbi);
 
 	return err;
-- 
1.8.4.474.g128a96c

