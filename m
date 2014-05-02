Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaEBPsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:48:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbaEBPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 117/151] don't bother with {get,put}_write_access() on non-regular files
Date: Fri,  2 May 2014 08:38:25 -0700
Message-Id: <1399045139-4531-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit dd20908a8a06b22c171f6c3fcdbdbd65bed07505 upstream.

it's pointless and actually leads to wrong behaviour in at least one
moderately convoluted case (pipe(), close one end, try to get to
another via /proc/*/fd and run into ETXTBUSY).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/file_table.c |  4 ++--
 fs/open.c       | 26 +++++++-------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 5fff903..0e5202f 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -208,10 +208,10 @@ static void drop_file_write_access(struct file *file)
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
index 4b3e1ed..159f3e7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -641,23 +641,12 @@ out:
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
 
@@ -690,12 +679,11 @@ static int do_dentry_open(struct file *f,
 
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
@@ -738,7 +726,6 @@ static int do_dentry_open(struct file *f,
 cleanup_all:
 	fops_put(f->f_op);
 	if (f->f_mode & FMODE_WRITE) {
-		put_write_access(inode);
 		if (!special_file(inode->i_mode)) {
 			/*
 			 * We don't consider this a real
@@ -746,6 +733,7 @@ cleanup_all:
 			 * because it all happenend right
 			 * here, so just reset the state.
 			 */
+			put_write_access(inode);
 			file_reset_write(f);
 			__mnt_drop_write(f->f_path.mnt);
 		}
-- 
1.9.1

