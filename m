Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaGLLOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:14:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59466 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaGLLOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:14:45 -0400
X-AuditID: cbfee61b-f79f86d00000144c-33-53c118a20338
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: support ->rename2()
Date: Sat, 12 Jul 2014 19:13:54 +0800
Message-id: <000c01cf9dc2$7855d120$69017360$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+dsz8bBcrcLXy4QgGp1QSxpCeP6g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd1FEgeDDV52Sltc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	Lx9fZSlYrVPxcsFp1gbGJSpdjJwcEgImElve/WCBsMUkLtxbz9bFyMUhJDCdUWLNtkVQzg9G
	iRV3FzCCVLEJqEgs7/jPBGKLCHhJTNp/AqybWSBT4l7TDGYQWxho6pJbR8BqWARUJR5+fwRW
	wytgKXHs7SdmCFtQ4sfke1C9WhLrdx5ngrDlJTavecsMcZGCxI6zrxkhdulJ3HqwkBmiRlxi
	45FbLBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZweD+T
	3sG4qsHiEKMAB6MSD2+B4oFgIdbEsuLK3EOMEhzMSiK8/3gOBgvxpiRWVqUW5ccXleakFh9i
	lOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg7D53u9VO83+GU/fdbl7+hIS0LRPeHTKV
	9mCvjA6qLrpjfIVhR97bnIy7y0Mk9vEz7bHdva3f+MOE5I1v2mfdeXh2Vjan8dt++8VRoX3h
	h+K3vmKNW3fi39X1X8J2v/7KdcPmYIoq45wFHzfEed8TC57Kx/TW8Mb7O3kCr7/ONRWYGm+Q
	k3TDVomlOCPRUIu5qDgRAJ36TMlrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now new interface ->rename2() is added to VFS, here are related description:
https://lkml.org/lkml/2014/2/7/873
https://lkml.org/lkml/2014/2/7/758

This patch adds function f2fs_rename2() to support ->rename2() including
handling both RENAME_EXCHANGE and RENAME_NOREPLACE flag.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/namei.c | 164 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1b3cae0..27b0377 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -485,6 +485,169 @@ out:
 	return err;
 }
 
+static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct super_block *sb = old_dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct page *old_dir_page, *new_dir_page;
+	struct page *old_page, *new_page;
+	struct f2fs_dir_entry *old_dir_entry = NULL, *new_dir_entry = NULL;
+	struct f2fs_dir_entry *old_entry, *new_entry;
+	int old_nlink = 0, new_nlink = 0;
+	int err = -ENOENT;
+
+	f2fs_balance_fs(sbi);
+
+	old_entry = f2fs_find_entry(old_dir, &old_dentry->d_name, &old_page);
+	if (!old_entry)
+		goto out;
+
+	new_entry = f2fs_find_entry(new_dir, &new_dentry->d_name, &new_page);
+	if (!new_entry)
+		goto out_old;
+
+	/* prepare for updating ".." directory entry info later */
+	if (old_dir != new_dir) {
+		if (S_ISDIR(old_inode->i_mode)) {
+			err = -EIO;
+			old_dir_entry = f2fs_parent_dir(old_inode,
+							&old_dir_page);
+			if (!old_dir_entry)
+				goto out_new;
+		}
+
+		if (S_ISDIR(new_inode->i_mode)) {
+			err = -EIO;
+			new_dir_entry = f2fs_parent_dir(new_inode,
+							&new_dir_page);
+			if (!new_dir_entry)
+				goto out_old_dir;
+		}
+	}
+
+	/*
+	 * If cross rename between file and directory those are not
+	 * in the same directory, we will inc nlink of file's parent
+	 * later, so we should check upper boundary of its nlink.
+	 */
+	if ((!old_dir_entry || !new_dir_entry) &&
+				old_dir_entry != new_dir_entry) {
+		old_nlink = old_dir_entry ? -1 : 1;
+		new_nlink = -old_nlink;
+		err = -EMLINK;
+		if ((old_nlink > 0 && old_inode->i_nlink >= F2FS_LINK_MAX) ||
+			(new_nlink > 0 && new_inode->i_nlink >= F2FS_LINK_MAX))
+			goto out_new_dir;
+	}
+
+	f2fs_lock_op(sbi);
+
+	err = update_dent_inode(old_inode, &new_dentry->d_name);
+	if (err)
+		goto out_unlock;
+
+	err = update_dent_inode(new_inode, &old_dentry->d_name);
+	if (err)
+		goto out_undo;
+
+	/* update ".." directory entry info of old dentry */
+	if (old_dir_entry)
+		f2fs_set_link(old_inode, old_dir_entry, old_dir_page, new_dir);
+
+	/* update ".." directory entry info of new dentry */
+	if (new_dir_entry)
+		f2fs_set_link(new_inode, new_dir_entry, new_dir_page, old_dir);
+
+	/* update directory entry info of old dir inode */
+	f2fs_set_link(old_dir, old_entry, old_page, new_inode);
+
+	down_write(&F2FS_I(old_inode)->i_sem);
+	file_lost_pino(old_inode);
+	up_write(&F2FS_I(old_inode)->i_sem);
+
+	update_inode_page(old_inode);
+
+	old_dir->i_ctime = CURRENT_TIME;
+	if (old_nlink) {
+		down_write(&F2FS_I(old_dir)->i_sem);
+		if (old_nlink < 0)
+			drop_nlink(old_dir);
+		else
+			inc_nlink(old_dir);
+		up_write(&F2FS_I(old_dir)->i_sem);
+	}
+	mark_inode_dirty(old_dir);
+	update_inode_page(old_dir);
+
+	/* update directory entry info of new dir inode */
+	f2fs_set_link(new_dir, new_entry, new_page, old_inode);
+
+	down_write(&F2FS_I(new_inode)->i_sem);
+	file_lost_pino(new_inode);
+	up_write(&F2FS_I(new_inode)->i_sem);
+
+	update_inode_page(new_inode);
+
+	new_dir->i_ctime = CURRENT_TIME;
+	if (new_nlink) {
+		down_write(&F2FS_I(new_dir)->i_sem);
+		if (new_nlink < 0)
+			drop_nlink(new_dir);
+		else
+			inc_nlink(new_dir);
+		up_write(&F2FS_I(new_dir)->i_sem);
+	}
+	mark_inode_dirty(new_dir);
+	update_inode_page(new_dir);
+
+	f2fs_unlock_op(sbi);
+	return 0;
+out_undo:
+	/* Still we may fail to recover name info of f2fs_inode here */
+	update_dent_inode(old_inode, &old_dentry->d_name);
+out_unlock:
+	f2fs_unlock_op(sbi);
+out_new_dir:
+	if (new_dir_entry) {
+		kunmap(new_dir_page);
+		f2fs_put_page(new_dir_page, 0);
+	}
+out_old_dir:
+	if (old_dir_entry) {
+		kunmap(old_dir_page);
+		f2fs_put_page(old_dir_page, 0);
+	}
+out_new:
+	kunmap(new_page);
+	f2fs_put_page(new_page, 0);
+out_old:
+	kunmap(old_page);
+	f2fs_put_page(old_page, 0);
+out:
+	return err;
+}
+
+static int f2fs_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
+{
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
+		return -EINVAL;
+
+	if (flags & RENAME_EXCHANGE) {
+		return f2fs_cross_rename(old_dir, old_dentry,
+					 new_dir, new_dentry);
+	}
+	/*
+	 * VFS has already handled the new dentry existence case,
+	 * here, we just deal with "RENAME_NOREPLACE" as regular rename.
+	 */
+	return f2fs_rename(old_dir, old_dentry, new_dir, new_dentry);
+}
+
 static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
@@ -542,6 +705,7 @@ const struct inode_operations f2fs_dir_inode_operations = {
 	.rmdir		= f2fs_rmdir,
 	.mknod		= f2fs_mknod,
 	.rename		= f2fs_rename,
+	.rename2	= f2fs_rename2,
 	.tmpfile	= f2fs_tmpfile,
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
-- 
2.0.1.474.g72c7794


