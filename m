Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbaE2Fkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:40:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbaE2Eet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.14 023/140] dont bother with {get,put}_write_access() on non-regular files
Date: Wed, 28 May 2014 21:32:42 -0700
Message-Id: <20140529043052.331237082@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit dd20908a8a06b22c171f6c3fcdbdbd65bed07505 upstream.

it's pointless and actually leads to wrong behaviour in at least one
moderately convoluted case (pipe(), close one end, try to get to
another via /proc/*/fd and run into ETXTBUSY).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/file_table.c |    4 ++--
 fs/open.c       |   26 +++++++-------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -209,10 +209,10 @@ static void drop_file_write_access(struc
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
 
@@ -690,12 +679,11 @@ static int do_dentry_open(struct file *f
 
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
@@ -742,7 +730,6 @@ static int do_dentry_open(struct file *f
 cleanup_all:
 	fops_put(f->f_op);
 	if (f->f_mode & FMODE_WRITE) {
-		put_write_access(inode);
 		if (!special_file(inode->i_mode)) {
 			/*
 			 * We don't consider this a real
@@ -750,6 +737,7 @@ cleanup_all:
 			 * because it all happenend right
 			 * here, so just reset the state.
 			 */
+			put_write_access(inode);
 			file_reset_write(f);
 			__mnt_drop_write(f->f_path.mnt);
 		}


