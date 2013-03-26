Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab3CZXk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:40:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3CZWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Subject: [ 34/98] saner proc_get_inode() calling conventions
Date: Tue, 26 Mar 2013 15:42:23 -0700
Message-Id: <20130326224245.964137277@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit d3d009cb965eae7e002ea5badf603ea8f4c34915 upstream.

Make it drop the pde in *all* cases when no new reference to it is
put into an inode - both when an inode had already been set up
(as we were already doing) and when inode allocation has failed.
Makes for simpler logics in callers...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/generic.c |   21 +++++++--------------
 fs/proc/inode.c   |   10 +++-------
 2 files changed, 10 insertions(+), 21 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -412,8 +412,7 @@ static const struct dentry_operations pr
 struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		struct dentry *dentry)
 {
-	struct inode *inode = NULL;
-	int error = -ENOENT;
+	struct inode *inode;
 
 	spin_lock(&proc_subdir_lock);
 	for (de = de->subdir; de ; de = de->next) {
@@ -422,22 +421,16 @@ struct dentry *proc_lookup_de(struct pro
 		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
-			error = -ENOMEM;
 			inode = proc_get_inode(dir->i_sb, de);
-			goto out_unlock;
+			if (!inode)
+				return ERR_PTR(-ENOMEM);
+			d_set_d_op(dentry, &proc_dentry_operations);
+			d_add(dentry, inode);
+			return NULL;
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
-out_unlock:
-
-	if (inode) {
-		d_set_d_op(dentry, &proc_dentry_operations);
-		d_add(dentry, inode);
-		return NULL;
-	}
-	if (de)
-		pde_put(de);
-	return ERR_PTR(error);
+	return ERR_PTR(-ENOENT);
 }
 
 struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -445,12 +445,9 @@ static const struct file_operations proc
 
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
-	struct inode * inode;
+	struct inode *inode = iget_locked(sb, de->low_ino);
 
-	inode = iget_locked(sb, de->low_ino);
-	if (!inode)
-		return NULL;
-	if (inode->i_state & I_NEW) {
+	if (inode && (inode->i_state & I_NEW)) {
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->pde = de;
 
@@ -482,7 +479,7 @@ struct inode *proc_get_inode(struct supe
 	} else
 	       pde_put(de);
 	return inode;
-}			
+}
 
 int proc_fill_super(struct super_block *s)
 {
@@ -499,6 +496,5 @@ int proc_fill_super(struct super_block *
 		return 0;
 
 	printk("proc_read_super: get root inode failed\n");
-	pde_put(&proc_root);
 	return -ENOMEM;
 }


