Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3IRMLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:11:35 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62583 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3IRMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:11:33 -0400
Date: Wed, 18 Sep 2013 14:12:04 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: introduce d_instantiate_no_diralias()
Message-ID: <20130918121204.GC31733@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

This is for next (3.13), could you please ack it or take it through your tree?

Thanks,
Miklos

----
Subject: vfs: introduce d_instantiate_no_diralias()
From: Miklos Szeredi <mszeredi@suse.cz>

...which just returns -EBUSY if a directory alias would be created.

This is to be used by fuse mkdir to make sure that a buggy or malicious
userspace filesystem doesn't do anything nasty.  Previously fuse used a
private mutex for this purpose, which can now go away.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c            |   26 ++++++++++++++++++++++++++
 fs/fuse/dir.c          |   42 +++++++-----------------------------------
 fs/fuse/fuse_i.h       |    3 ---
 fs/fuse/inode.c        |    2 --
 include/linux/dcache.h |    1 +
 5 files changed, 34 insertions(+), 40 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1801,6 +1801,32 @@ struct dentry *d_instantiate_unique(stru
 
 EXPORT_SYMBOL(d_instantiate_unique);
 
+/**
+ * d_instantiate_no_diralias - instantiate a non-aliased dentry
+ * @entry: dentry to complete
+ * @inode: inode to attach to this dentry
+ *
+ * Fill in inode information in the entry.  If a directory alias is found, then
+ * return an error.  Together with d_materialise_unique() this guarantees that a
+ * directory inode may never have more than one alias.
+ */
+int d_instantiate_no_diralias(struct dentry *entry, struct inode *inode)
+{
+	BUG_ON(!hlist_unhashed(&entry->d_alias));
+
+	spin_lock(&inode->i_lock);
+	if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry)) {
+		spin_unlock(&inode->i_lock);
+		return -EBUSY;
+	}
+	__d_instantiate(entry, inode);
+	spin_unlock(&inode->i_lock);
+	security_d_instantiate(entry, inode);
+
+	return 0;
+}
+EXPORT_SYMBOL(d_instantiate_no_diralias);
+
 struct dentry *d_make_root(struct inode *root_inode)
 {
 	struct dentry *res = NULL;
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -337,24 +337,6 @@ int fuse_lookup_name(struct super_block
 	return err;
 }
 
-static struct dentry *fuse_materialise_dentry(struct dentry *dentry,
-					      struct inode *inode)
-{
-	struct dentry *newent;
-
-	if (inode && S_ISDIR(inode->i_mode)) {
-		struct fuse_conn *fc = get_fuse_conn(inode);
-
-		mutex_lock(&fc->inst_mutex);
-		newent = d_materialise_unique(dentry, inode);
-		mutex_unlock(&fc->inst_mutex);
-	} else {
-		newent = d_materialise_unique(dentry, inode);
-	}
-
-	return newent;
-}
-
 static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 				  unsigned int flags)
 {
@@ -377,7 +359,7 @@ static struct dentry *fuse_lookup(struct
 	if (inode && get_node_id(inode) == FUSE_ROOT_ID)
 		goto out_iput;
 
-	newent = fuse_materialise_dentry(entry, inode);
+	newent = d_materialise_unique(entry, inode);
 	err = PTR_ERR(newent);
 	if (IS_ERR(newent))
 		goto out_err;
@@ -596,21 +578,11 @@ static int create_new_entry(struct fuse_
 	}
 	kfree(forget);
 
-	if (S_ISDIR(inode->i_mode)) {
-		struct dentry *alias;
-		mutex_lock(&fc->inst_mutex);
-		alias = d_find_alias(inode);
-		if (alias) {
-			/* New directory must have moved since mkdir */
-			mutex_unlock(&fc->inst_mutex);
-			dput(alias);
-			iput(inode);
-			return -EBUSY;
-		}
-		d_instantiate(entry, inode);
-		mutex_unlock(&fc->inst_mutex);
-	} else
-		d_instantiate(entry, inode);
+	err = d_instantiate_no_diralias(entry, inode);
+	if (err) {
+		iput(inode);
+		return err;
+	}
 
 	fuse_change_entry_timeout(entry, &outarg);
 	fuse_invalidate_attr(dir);
@@ -1280,7 +1252,7 @@ static int fuse_direntplus_link(struct f
 	if (!inode)
 		goto out;
 
-	alias = fuse_materialise_dentry(dentry, inode);
+	alias = d_materialise_unique(dentry, inode);
 	err = PTR_ERR(alias);
 	if (IS_ERR(alias))
 		goto out;
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -372,9 +372,6 @@ struct fuse_conn {
 	/** Lock protecting accessess to  members of this structure */
 	spinlock_t lock;
 
-	/** Mutex protecting against directory alias creation */
-	struct mutex inst_mutex;
-
 	/** Refcount */
 	atomic_t count;
 
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -565,7 +565,6 @@ void fuse_conn_init(struct fuse_conn *fc
 {
 	memset(fc, 0, sizeof(*fc));
 	spin_lock_init(&fc->lock);
-	mutex_init(&fc->inst_mutex);
 	init_rwsem(&fc->killsb);
 	atomic_set(&fc->count, 1);
 	init_waitqueue_head(&fc->waitq);
@@ -596,7 +595,6 @@ void fuse_conn_put(struct fuse_conn *fc)
 	if (atomic_dec_and_test(&fc->count)) {
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
-		mutex_destroy(&fc->inst_mutex);
 		fc->release(fc);
 	}
 }
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -224,6 +224,7 @@ static inline int dname_external(const s
 extern void d_instantiate(struct dentry *, struct inode *);
 extern struct dentry * d_instantiate_unique(struct dentry *, struct inode *);
 extern struct dentry * d_materialise_unique(struct dentry *, struct inode *);
+extern int d_instantiate_no_diralias(struct dentry *, struct inode *);
 extern void __d_drop(struct dentry *dentry);
 extern void d_drop(struct dentry *dentry);
 extern void d_delete(struct dentry *);
