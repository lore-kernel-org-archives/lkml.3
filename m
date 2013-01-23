Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3AWQR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:17:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40855 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3AWQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:17:27 -0500
Date: Wed, 23 Jan 2013 16:17:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, dhowells@redhat.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Subject: Re: [PATCH] proc: avoid extra pde_put() in proc_fill_super()
Message-ID: <20130123161715.GX4939@ZenIV.linux.org.uk>
References: <20130122170100.11323.13045.stgit@maximpc.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122170100.11323.13045.stgit@maximpc.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 09:03:26PM +0400, Maxim Patlasov wrote:
> If proc_get_inode() succeeded, but d_make_root() failed, pde_put() for
> proc_root will be called twice: the first time due to iput() called from
> d_make_root() and the second time directly in the end of proc_fill_super().

I don't like that solution, TBH.  How about making proc_get_inode() call
pde_put() on failure instead?  Note that it already does so if inode had
been found in icache, so this will just make the refcounting consistent.
Completely untested patch follows:

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 76ddae8..8b487e5 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -413,31 +413,24 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		struct dentry *dentry)
 {
 	struct inode *inode = NULL;
-	int error = -ENOENT;
 
 	spin_lock(&proc_subdir_lock);
 	for (de = de->subdir; de ; de = de->next) {
 		if (de->namelen != dentry->d_name.len)
 			continue;
-		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
-			pde_get(de);
-			spin_unlock(&proc_subdir_lock);
-			error = -ENOMEM;
-			inode = proc_get_inode(dir->i_sb, de);
-			goto out_unlock;
-		}
-	}
-	spin_unlock(&proc_subdir_lock);
-out_unlock:
-
-	if (inode) {
+		if (memcmp(dentry->d_name.name, de->name, de->namelen))
+			continue;
+		pde_get(de);
+		spin_unlock(&proc_subdir_lock);
+		inode = proc_get_inode(dir->i_sb, de);
+		if (!inode)
+			return ERR_PTR(-ENOMEM);
 		d_set_d_op(dentry, &proc_dentry_operations);
 		d_add(dentry, inode);
 		return NULL;
 	}
-	if (de)
-		pde_put(de);
-	return ERR_PTR(error);
+	spin_unlock(&proc_subdir_lock);
+	return ERR_PTR(-ENOENT);
 }
 
 struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 439ae688..e2bbe20 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -448,9 +448,7 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 	struct inode * inode;
 
 	inode = iget_locked(sb, de->low_ino);
-	if (!inode)
-		return NULL;
-	if (inode->i_state & I_NEW) {
+	if (inode && inode->i_state & I_NEW) {
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->pde = de;
 
@@ -499,6 +497,5 @@ int proc_fill_super(struct super_block *s)
 		return 0;
 
 	printk("proc_read_super: get root inode failed\n");
-	pde_put(&proc_root);
 	return -ENOMEM;
 }
