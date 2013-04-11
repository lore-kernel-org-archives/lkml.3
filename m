Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab3DKUhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:37:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3DKU0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:03 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mCC50CTUwn0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hUKpO72txPgA:10 a=drOt6m5kAAAA:8 a=9Mm2SWXSqSrqiVlimS8A:9 a=jeBq3FmKZ4MA:10 a=0Wn0coYJn3Pm24_W:21 a=giUEh9k9tyE4-1BS:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202551.266631095@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 031/171 ] saner proc_get_inode() calling conventions
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0031-saner-proc_get_inode-calling-conventions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit d3d009cb965eae7e002ea5badf603ea8f4c34915 ]

Make it drop the pde in *all* cases when no new reference to it is
put into an inode - both when an inode had already been set up
(as we were already doing) and when inode allocation has failed.
Makes for simpler logics in callers...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/proc/generic.c |   21 +++++++--------------
 fs/proc/inode.c   |    9 +++------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b3647fe..dcd2b05 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -417,8 +417,7 @@ static const struct dentry_operations proc_dentry_operations =
 struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		struct dentry *dentry)
 {
-	struct inode *inode = NULL;
-	int error = -ENOENT;
+	struct inode *inode;
 
 	spin_lock(&proc_subdir_lock);
 	for (de = de->subdir; de ; de = de->next) {
@@ -427,22 +426,16 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
-			error = -EINVAL;
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
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..710e28f 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -443,12 +443,9 @@ static const struct file_operations proc_reg_file_ops_no_compat = {
 
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
 		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
@@ -481,7 +478,7 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 	} else
 	       pde_put(de);
 	return inode;
-}			
+}
 
 int proc_fill_super(struct super_block *s)
 {
-- 
1.7.10.4


