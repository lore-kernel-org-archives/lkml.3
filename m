Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaK0Itu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:42698 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbaK0Itr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:47 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 76/91] ext4: propagate errors up to ext4_find_entry()'s callers
Date: Thu, 27 Nov 2014 16:42:59 +0800
Message-Id: <1417077794-9299-76-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 36de928641ee48b2078d3fe9514242aaa2f92013 upstream.

If we run into some kind of error, such as ENOMEM, while calling
ext4_getblk() or ext4_dx_find_entry(), we need to make sure this error
gets propagated up to ext4_find_entry() and then to its callers.  This
way, transient errors such as ENOMEM can get propagated to the VFS.
This is important so that the system calls return the appropriate
error, and also so that in the case of ext4_lookup(), we return an
error instead of a NULL inode, since that will result in a negative
dentry cache entry that will stick around long past the OOM condition
which caused a transient ENOMEM error.

Google-Bug-Id: #17142205

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[lizf: Backported to 3.4:
- adjust context
- s/old.bh/old_bh/g
- s/new.bh/new_bh/g
- drop the changes to ext4_find_delete_entry() and ext4_cross_rename()
- add return value check for one more exr4_find_entry() in ext4_rename()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/ext4.h  |  2 +-
 fs/ext4/namei.c | 31 ++++++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2922486..521ba9d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1674,7 +1674,7 @@ ext4_group_first_block_no(struct super_block *sb, ext4_group_t group_no)
 /*
  * Special error return code only used by dx_probe() and its callers.
  */
-#define ERR_BAD_DX_DIR	-75000
+#define ERR_BAD_DX_DIR	(-(MAX_ERRNO - 1))
 
 void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 			ext4_group_t *blockgrpp, ext4_grpblk_t *offsetp);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 54ad9a5..a2efbda 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -861,7 +861,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 				   buffer */
 	int num = 0;
 	ext4_lblk_t  nblocks;
-	int i, err;
+	int i, err = 0;
 	int namelen;
 
 	*res_dir = NULL;
@@ -886,7 +886,11 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		 * return.  Otherwise, fall back to doing a search the
 		 * old fashioned way.
 		 */
-		if (bh || (err != ERR_BAD_DX_DIR))
+		if (err == -ENOENT)
+			return NULL;
+		if (err && err != ERR_BAD_DX_DIR)
+			return ERR_PTR(err);
+		if (bh)
 			return bh;
 		dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
 			       "falling back\n"));
@@ -917,6 +921,11 @@ restart:
 				}
 				num++;
 				bh = ext4_getblk(NULL, dir, b++, 0, &err);
+				if (unlikely(err)) {
+					if (ra_max == 0)
+						return ERR_PTR(err);
+					break;
+				}
 				bh_use[ra_max] = bh;
 				if (bh)
 					ll_rw_block(READ | REQ_META | REQ_PRIO,
@@ -1026,6 +1035,8 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 		return ERR_PTR(-ENAMETOOLONG);
 
 	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	if (IS_ERR(bh))
+		return (struct dentry *) bh;
 	inode = NULL;
 	if (bh) {
 		__u32 ino = le32_to_cpu(de->inode);
@@ -1063,6 +1074,8 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	struct buffer_head *bh;
 
 	bh = ext4_find_entry(child->d_inode, &dotdot, &de);
+	if (IS_ERR(bh))
+		return (struct dentry *) bh;
 	if (!bh)
 		return ERR_PTR(-ENOENT);
 	ino = le32_to_cpu(de->inode);
@@ -2137,6 +2150,8 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 
 	retval = -ENOENT;
 	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	if (!bh)
 		goto end_rmdir;
 
@@ -2202,6 +2217,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 
 	retval = -ENOENT;
 	bh = ext4_find_entry(dir, &dentry->d_name, &de);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	if (!bh)
 		goto end_unlink;
 
@@ -2418,6 +2435,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ext4_handle_sync(handle);
 
 	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de);
+	if (IS_ERR(old_bh))
+		return PTR_ERR(old_bh);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -2431,6 +2450,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	new_inode = new_dentry->d_inode;
 	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name, &new_de);
+	if (IS_ERR(new_bh)) {
+		retval = PTR_ERR(new_bh);
+		goto end_rename;
+	}
 	if (new_bh) {
 		if (!new_inode) {
 			brelse(new_bh);
@@ -2509,7 +2532,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct ext4_dir_entry_2 *old_de2;
 
 		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de2);
-		if (old_bh2) {
+		if (IS_ERR(old_bh2)) {
+			retval = PTR_ERR(old_bh2);
+		} else if (old_bh2) {
 			retval = ext4_delete_entry(handle, old_dir,
 						   old_de2, old_bh2);
 			brelse(old_bh2);
-- 
1.9.1

