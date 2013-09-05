Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935666Ab3IEJpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:50 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:36527 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935615Ab3IEJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 09/11] fuse: use d_materialise_unique()
Date: Thu,  5 Sep 2013 11:44:42 +0200
Message-Id: <1378374284-1484-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use d_materialise_unique() instead of d_splice_alias().  This allows dentry
subtrees to be moved to a new place if there moved, even if something is
referencing a dentry in the subtree (open fd, cwd, etc..).

This will also allow us to drop a subtree if it is found to be replaced by
something else.  In this case the disconnected subtree can later be
reconnected to its new location.

d_materialise_unique() ensures that a directory entry only ever has one
alias.  We keep fc->inst_mutex around the calls for d_materialise_unique()
on directories to prevent a race with mkdir "stealing" the inode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c | 69 ++++++++++++++++++++++-------------------------------------
 1 file changed, 26 insertions(+), 43 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 72a5d5b..131d14b 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -267,26 +267,6 @@ int fuse_valid_type(int m)
 		S_ISBLK(m) || S_ISFIFO(m) || S_ISSOCK(m);
 }
 
-/*
- * Add a directory inode to a dentry, ensuring that no other dentry
- * refers to this inode.  Called with fc->inst_mutex.
- */
-static struct dentry *fuse_d_add_directory(struct dentry *entry,
-					   struct inode *inode)
-{
-	struct dentry *alias = d_find_alias(inode);
-	if (alias && !(alias->d_flags & DCACHE_DISCONNECTED)) {
-		/* This tries to shrink the subtree below alias */
-		fuse_invalidate_entry(alias);
-		dput(alias);
-		if (!hlist_empty(&inode->i_dentry))
-			return ERR_PTR(-EBUSY);
-	} else {
-		dput(alias);
-	}
-	return d_splice_alias(inode, entry);
-}
-
 int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode)
 {
@@ -345,6 +325,24 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 	return err;
 }
 
+static struct dentry *fuse_materialise_dentry(struct dentry *dentry,
+					      struct inode *inode)
+{
+	struct dentry *newent;
+
+	if (inode && S_ISDIR(inode->i_mode)) {
+		struct fuse_conn *fc = get_fuse_conn(inode);
+
+		mutex_lock(&fc->inst_mutex);
+		newent = d_materialise_unique(dentry, inode);
+		mutex_unlock(&fc->inst_mutex);
+	} else {
+		newent = d_materialise_unique(dentry, inode);
+	}
+
+	return newent;
+}
+
 static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 				  unsigned int flags)
 {
@@ -352,7 +350,6 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outarg;
 	struct inode *inode;
 	struct dentry *newent;
-	struct fuse_conn *fc = get_fuse_conn(dir);
 	bool outarg_valid = true;
 
 	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
@@ -368,16 +365,10 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	if (inode && get_node_id(inode) == FUSE_ROOT_ID)
 		goto out_iput;
 
-	if (inode && S_ISDIR(inode->i_mode)) {
-		mutex_lock(&fc->inst_mutex);
-		newent = fuse_d_add_directory(entry, inode);
-		mutex_unlock(&fc->inst_mutex);
-		err = PTR_ERR(newent);
-		if (IS_ERR(newent))
-			goto out_iput;
-	} else {
-		newent = d_splice_alias(inode, entry);
-	}
+	newent = fuse_materialise_dentry(entry, inode);
+	err = PTR_ERR(newent);
+	if (IS_ERR(newent))
+		goto out_err;
 
 	entry = newent ? newent : entry;
 	if (outarg_valid)
@@ -1275,18 +1266,10 @@ static int fuse_direntplus_link(struct file *file,
 	if (!inode)
 		goto out;
 
-	if (S_ISDIR(inode->i_mode)) {
-		mutex_lock(&fc->inst_mutex);
-		alias = fuse_d_add_directory(dentry, inode);
-		mutex_unlock(&fc->inst_mutex);
-		err = PTR_ERR(alias);
-		if (IS_ERR(alias)) {
-			iput(inode);
-			goto out;
-		}
-	} else {
-		alias = d_splice_alias(inode, dentry);
-	}
+	alias = fuse_materialise_dentry(dentry, inode);
+	err = PTR_ERR(alias);
+	if (IS_ERR(alias))
+		goto out;
 
 	if (alias) {
 		dput(dentry);
-- 
1.8.1.4

