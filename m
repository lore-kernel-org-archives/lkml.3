Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3AXMJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:09:01 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:5299 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3AXMIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:08:53 -0500
Subject: Re: [PATCH] proc: avoid extra pde_put() in proc_fill_super()
To: viro@zeniv.linux.org.uk
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Date: Thu, 24 Jan 2013 16:08:28 +0400
Message-ID: <20130124113842.19298.15835.stgit@maximpc.sw.ru>
In-Reply-To: <20130123161715.GX4939@ZenIV.linux.org.uk>
References: <20130123161715.GX4939@ZenIV.linux.org.uk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

01/23/2013 08:17 PM, Al Viro wrote:
> On Tue, Jan 22, 2013 at 09:03:26PM +0400, Maxim Patlasov wrote:
>> If proc_get_inode() succeeded, but d_make_root() failed, pde_put() for
>> proc_root will be called twice: the first time due to iput() called from
>> d_make_root() and the second time directly in the end of proc_fill_super().
>
> I don't like that solution, TBH.  How about making proc_get_inode() call
> pde_put() on failure instead?  Note that it already does so if inode had
> been found in icache, so this will just make the refcounting consistent.
> Completely untested patch follows:

The patch looks correct and its idea is very reasonable. I agree, it makes
refcounting consistent. Also, proc_lookup_de() is simplified. But your patch
misses a few (minor) bits implemented in mine:

 * add KERN_ERR to printk
 * s/proc_read_super/proc_fill_super in message string(s)
 * avoid misleading user ("get root inode failed") if getting inode succeeded,
   but allocating dentry failed.

The thing I don't like in your patch is mixing one-line fix (removal pde_put()
from proc_fill_super()) with general cleanup of proc_get_inode() and friends.
I'd suggest to apply your cleanup patch on top of my bugfix patch. Below is
your patch (essentially unmodified, excepting very last hunk) in the form
to be applied on top of my patch.

Thanks,
Maxim

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
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
index c7f8b24..99a9eb7 100644
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
 
@@ -499,7 +497,6 @@ int proc_fill_super(struct super_block *s)
 	root_inode = proc_get_inode(s, &proc_root);
 	if (!root_inode) {
 		printk(KERN_ERR "proc_fill_super: get root inode failed\n");
-		pde_put(&proc_root);
 		return -ENOMEM;
 	}
 

