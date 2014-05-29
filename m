Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935AbaE2ONc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:13:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59388 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933256AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 028/103] don't bother with {get,put}_write_access() on non-regular files
Date: Thu, 29 May 2014 15:48:13 +0200
Message-Id: <92e9ead530eccbfcc408c60ddb6d40ec4d952119.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dd20908a8a06b22c171f6c3fcdbdbd65bed07505 upstream.

it's pointless and actually leads to wrong behaviour in at least one
moderately convoluted case (pipe(), close one end, try to get to
another via /proc/*/fd and run into ETXTBUSY).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/file_table.c |  4 ++--
 fs/open.c       | 26 +++++++-------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index e900ca518635..05e2ac19b6c4 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -211,10 +211,10 @@ static void drop_file_write_access(struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 
-	put_write_access(inode);
-
 	if (special_file(inode->i_mode))
 		return;
+
+	put_write_access(inode);
 	if (file_check_writeable(file) != 0)
 		return;
 	__mnt_drop_write(mnt);
diff --git a/fs/open.c b/fs/open.c
index d420331ca32a..730a5870895d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -627,23 +627,12 @@ out:
 static inline int __get_file_write_access(struct inode *inode,
 					  struct vfsmount *mnt)
 {
-	int error;
-	error = get_write_access(inode);
+	int error = get_write_access(inode);
 	if (error)
 		return error;
-	/*
-	 * Do not take mount writer counts on
-	 * special files since no writes to
-	 * the mount itself will occur.
-	 */
-	if (!special_file(inode->i_mode)) {
-		/*
-		 * Balanced in __fput()
-		 */
-		error = __mnt_want_write(mnt);
-		if (error)
-			put_write_access(inode);
-	}
+	error = __mnt_want_write(mnt);
+	if (error)
+		put_write_access(inode);
 	return error;
 }
 
@@ -676,12 +665,11 @@ static int do_dentry_open(struct file *f,
 
 	path_get(&f->f_path);
 	inode = f->f_inode = f->f_path.dentry->d_inode;
-	if (f->f_mode & FMODE_WRITE) {
+	if (f->f_mode & FMODE_WRITE && !special_file(inode->i_mode)) {
 		error = __get_file_write_access(inode, f->f_path.mnt);
 		if (error)
 			goto cleanup_file;
-		if (!special_file(inode->i_mode))
-			file_take_write(f);
+		file_take_write(f);
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -722,7 +710,6 @@ cleanup_all:
 	fops_put(f->f_op);
 	file_sb_list_del(f);
 	if (f->f_mode & FMODE_WRITE) {
-		put_write_access(inode);
 		if (!special_file(inode->i_mode)) {
 			/*
 			 * We don't consider this a real
@@ -730,6 +717,7 @@ cleanup_all:
 			 * because it all happenend right
 			 * here, so just reset the state.
 			 */
+			put_write_access(inode);
 			file_reset_write(f);
 			__mnt_drop_write(f->f_path.mnt);
 		}
-- 
1.9.3

