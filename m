Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbbA2Kom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:44:42 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754271AbbA2I7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:50 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 175/176] move d_rcu from overlapping d_child to overlapping d_alias
Date: Wed, 28 Jan 2015 15:30:05 +0100
Message-Id: <f544f36115f5d86d70d338f1a5bc841dfd65eed3.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 946e51f2bf37f1656916eb75bd0742ba33983c28 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/platforms/cell/spufs/inode.c       |  2 +-
 drivers/staging/lustre/lustre/llite/dcache.c    |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
 drivers/staging/lustre/lustre/llite/namei.c     |  8 ++--
 fs/affs/amigaffs.c                              |  2 +-
 fs/autofs4/expire.c                             | 12 +++---
 fs/autofs4/root.c                               |  2 +-
 fs/ceph/dir.c                                   |  8 ++--
 fs/ceph/inode.c                                 |  6 +--
 fs/cifs/inode.c                                 |  2 +-
 fs/coda/cache.c                                 |  2 +-
 fs/dcache.c                                     | 56 ++++++++++++-------------
 fs/debugfs/inode.c                              |  4 +-
 fs/exportfs/expfs.c                             |  2 +-
 fs/libfs.c                                      | 12 +++---
 fs/ncpfs/dir.c                                  |  2 +-
 fs/ncpfs/ncplib_kernel.h                        |  4 +-
 fs/nfs/getroot.c                                |  2 +-
 fs/notify/fsnotify.c                            |  4 +-
 fs/ocfs2/dcache.c                               |  2 +-
 include/linux/dcache.h                          |  8 ++--
 kernel/cgroup.c                                 |  2 +-
 kernel/trace/trace.c                            |  4 +-
 kernel/trace/trace_events.c                     |  2 +-
 security/selinux/selinuxfs.c                    |  6 +--
 25 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 87ba7cf99cd7..65d633f20d37 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -164,7 +164,7 @@ static void spufs_prune_dir(struct dentry *dir)
 	struct dentry *dentry, *tmp;
 
 	mutex_lock(&dir->d_inode->i_mutex);
-	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
+	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_child) {
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
 			dget_dlock(dentry);
diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index e7629be39739..c6ca9ca8eab4 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -278,7 +278,7 @@ void ll_invalidate_aliases(struct inode *inode)
 	       inode->i_ino, inode->i_generation, inode);
 
 	ll_lock_dcache(inode);
-	ll_d_hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
+	ll_d_hlist_for_each_entry(dentry, p, &inode->i_dentry, d_u.d_alias) {
 		CDEBUG(D_DENTRY, "dentry in drop %.*s (%p) parent %p "
 		       "inode %p flags %d\n", dentry->d_name.len,
 		       dentry->d_name.name, dentry, dentry->d_parent,
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index b868c2bd58d2..04313298df4a 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -665,7 +665,7 @@ void lustre_dump_dentry(struct dentry *dentry, int recur)
 		return;
 
 	list_for_each(tmp, &dentry->d_subdirs) {
-		struct dentry *d = list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *d = list_entry(tmp, struct dentry, d_child);
 		lustre_dump_dentry(d, recur - 1);
 	}
 }
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 34815b550e71..cd90a6539555 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -175,14 +175,14 @@ static void ll_invalidate_negative_children(struct inode *dir)
 	struct ll_d_hlist_node *p;
 
 	ll_lock_dcache(dir);
-	ll_d_hlist_for_each_entry(dentry, p, &dir->i_dentry, d_alias) {
+	ll_d_hlist_for_each_entry(dentry, p, &dir->i_dentry, d_u.d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!list_empty(&dentry->d_subdirs)) {
 			struct dentry *child;
 
 			list_for_each_entry_safe(child, tmp_subdir,
 						 &dentry->d_subdirs,
-						 d_u.d_child) {
+						 d_child) {
 				if (child->d_inode == NULL)
 					d_lustre_invalidate(child, 1);
 			}
@@ -363,7 +363,7 @@ static struct dentry *ll_find_alias(struct inode *inode, struct dentry *dentry)
 	discon_alias = invalid_alias = NULL;
 
 	ll_lock_dcache(inode);
-	ll_d_hlist_for_each_entry(alias, p, &inode->i_dentry, d_alias) {
+	ll_d_hlist_for_each_entry(alias, p, &inode->i_dentry, d_u.d_alias) {
 		LASSERT(alias != dentry);
 
 		spin_lock(&alias->d_lock);
@@ -953,7 +953,7 @@ static void ll_get_child_fid(struct inode * dir, struct qstr *name,
 {
 	struct dentry *parent, *child;
 
-	parent = ll_d_hlist_entry(dir->i_dentry, struct dentry, d_alias);
+	parent = ll_d_hlist_entry(dir->i_dentry, struct dentry, d_u.d_alias);
 	child = d_lookup(parent, name);
 	if (child) {
 		if (child->d_inode)
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index d9a43674cb94..9cca0ea4e479 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -126,7 +126,7 @@ affs_fix_dcache(struct inode *inode, u32 entry_ino)
 {
 	struct dentry *dentry;
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		if (entry_ino == (u32)(long)dentry->d_fsdata) {
 			dentry->d_fsdata = (void *)inode->i_ino;
 			break;
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 3d9d3f5d5dda..d096316533da 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -91,7 +91,7 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 	spin_lock(&root->d_lock);
 
 	if (prev)
-		next = prev->d_u.d_child.next;
+		next = prev->d_child.next;
 	else {
 		prev = dget_dlock(root);
 		next = prev->d_subdirs.next;
@@ -105,13 +105,13 @@ cont:
 		return NULL;
 	}
 
-	q = list_entry(next, struct dentry, d_u.d_child);
+	q = list_entry(next, struct dentry, d_child);
 
 	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Already gone or negative dentry (under construction) - try next */
 	if (!d_count(q) || !simple_positive(q)) {
 		spin_unlock(&q->d_lock);
-		next = q->d_u.d_child.next;
+		next = q->d_child.next;
 		goto cont;
 	}
 	dget_dlock(q);
@@ -161,13 +161,13 @@ again:
 				goto relock;
 			}
 			spin_unlock(&p->d_lock);
-			next = p->d_u.d_child.next;
+			next = p->d_child.next;
 			p = parent;
 			if (next != &parent->d_subdirs)
 				break;
 		}
 	}
-	ret = list_entry(next, struct dentry, d_u.d_child);
+	ret = list_entry(next, struct dentry, d_child);
 
 	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
@@ -447,7 +447,7 @@ found:
 	spin_lock(&sbi->lookup_lock);
 	spin_lock(&expired->d_parent->d_lock);
 	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
-	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
+	list_move(&expired->d_parent->d_subdirs, &expired->d_child);
 	spin_unlock(&expired->d_lock);
 	spin_unlock(&expired->d_parent->d_lock);
 	spin_unlock(&sbi->lookup_lock);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2a69bde8c61d..b3f4794c9f6d 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -655,7 +655,7 @@ static void autofs_clear_leaf_automount_flags(struct dentry *dentry)
 	/* only consider parents below dentrys in the root */
 	if (IS_ROOT(parent->d_parent))
 		return;
-	d_child = &dentry->d_u.d_child;
+	d_child = &dentry->d_child;
 	/* Set parent managed if it's becoming empty */
 	if (d_child->next == &parent->d_subdirs &&
 	    d_child->prev == &parent->d_subdirs)
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 868b61d56cac..ea3de8b719ab 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -103,7 +103,7 @@ static unsigned fpos_off(loff_t p)
 /*
  * When possible, we try to satisfy a readdir by peeking at the
  * dcache.  We make this work by carefully ordering dentries on
- * d_u.d_child when we initially get results back from the MDS, and
+ * d_child when we initially get results back from the MDS, and
  * falling back to a "normal" sync readdir if any dentries in the dir
  * are dropped.
  *
@@ -138,11 +138,11 @@ static int __dcache_readdir(struct file *file, struct dir_context *ctx)
 		p = parent->d_subdirs.prev;
 		dout(" initial p %p/%p\n", p->prev, p->next);
 	} else {
-		p = last->d_u.d_child.prev;
+		p = last->d_child.prev;
 	}
 
 more:
-	dentry = list_entry(p, struct dentry, d_u.d_child);
+	dentry = list_entry(p, struct dentry, d_child);
 	di = ceph_dentry(dentry);
 	while (1) {
 		dout(" p %p/%p %s d_subdirs %p/%p\n", p->prev, p->next,
@@ -164,7 +164,7 @@ more:
 		     !dentry->d_inode ? " null" : "");
 		spin_unlock(&dentry->d_lock);
 		p = p->prev;
-		dentry = list_entry(p, struct dentry, d_u.d_child);
+		dentry = list_entry(p, struct dentry, d_child);
 		di = ceph_dentry(dentry);
 	}
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8549a48115f7..74a479e518d4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -880,9 +880,9 @@ static void ceph_set_dentry_offset(struct dentry *dn)
 
 	spin_lock(&dir->d_lock);
 	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
-	list_move(&dn->d_u.d_child, &dir->d_subdirs);
+	list_move(&dn->d_child, &dir->d_subdirs);
 	dout("set_dentry_offset %p %lld (%p %p)\n", dn, di->offset,
-	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
+	     dn->d_child.prev, dn->d_child.next);
 	spin_unlock(&dn->d_lock);
 	spin_unlock(&dir->d_lock);
 }
@@ -1309,7 +1309,7 @@ retry_lookup:
 			/* reorder parent's d_subdirs */
 			spin_lock(&parent->d_lock);
 			spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
-			list_move(&dn->d_u.d_child, &parent->d_subdirs);
+			list_move(&dn->d_child, &parent->d_subdirs);
 			spin_unlock(&dn->d_lock);
 			spin_unlock(&parent->d_lock);
 		}
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2a93255c0150..ab9f992ca479 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -874,7 +874,7 @@ inode_has_hashed_dentries(struct inode *inode)
 	struct dentry *dentry;
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
 			spin_unlock(&inode->i_lock);
 			return true;
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 1da168c61d35..9bc1147a6c5d 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -92,7 +92,7 @@ static void coda_flag_children(struct dentry *parent, int flag)
 	struct dentry *de;
 
 	spin_lock(&parent->d_lock);
-	list_for_each_entry(de, &parent->d_subdirs, d_u.d_child) {
+	list_for_each_entry(de, &parent->d_subdirs, d_child) {
 		/* don't know what to do with negative dentries */
 		if (de->d_inode ) 
 			coda_flag_inode(de->d_inode, flag);
diff --git a/fs/dcache.c b/fs/dcache.c
index d449b1aed5ad..09f7a612ba7f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -44,7 +44,7 @@
 /*
  * Usage:
  * dcache->d_inode->i_lock protects:
- *   - i_dentry, d_alias, d_inode of aliases
+ *   - i_dentry, d_u.d_alias, d_inode of aliases
  * dcache_hash_bucket lock protects:
  *   - the dcache hash table
  * s_anon bl list spinlock protects:
@@ -59,7 +59,7 @@
  *   - d_unhashed()
  *   - d_parent and d_subdirs
  *   - childrens' d_child and d_parent
- *   - d_alias, d_inode
+ *   - d_u.d_alias, d_inode
  *
  * Ordering:
  * dentry->d_inode->i_lock
@@ -268,7 +268,6 @@ static void __d_free(struct rcu_head *head)
 {
 	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);
 
-	WARN_ON(!hlist_unhashed(&dentry->d_alias));
 	if (dname_external(dentry))
 		kfree(dentry->d_name.name);
 	kmem_cache_free(dentry_cache, dentry); 
@@ -276,6 +275,7 @@ static void __d_free(struct rcu_head *head)
 
 static void dentry_free(struct dentry *dentry)
 {
+	WARN_ON(!hlist_unhashed(&dentry->d_u.d_alias));
 	/* if dentry was never visible to RCU, immediate free is OK */
 	if (!(dentry->d_flags & DCACHE_RCUACCESS))
 		__d_free(&dentry->d_u.d_rcu);
@@ -309,7 +309,7 @@ static void dentry_iput(struct dentry * dentry)
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
 		dentry->d_inode = NULL;
-		hlist_del_init(&dentry->d_alias);
+		hlist_del_init(&dentry->d_u.d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
@@ -333,7 +333,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	dentry->d_inode = NULL;
-	hlist_del_init(&dentry->d_alias);
+	hlist_del_init(&dentry->d_u.d_alias);
 	dentry_rcuwalk_barrier(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
@@ -488,7 +488,7 @@ static void __dentry_kill(struct dentry *dentry)
 	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
-	list_del(&dentry->d_u.d_child);
+	list_del(&dentry->d_child);
 	/*
 	 * Inform d_walk() that we are no longer attached to the
 	 * dentry tree
@@ -772,7 +772,7 @@ static struct dentry *__d_find_alias(struct inode *inode, int want_discon)
 
 again:
 	discon_alias = NULL;
-	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
 		spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
@@ -825,7 +825,7 @@ void d_prune_aliases(struct inode *inode)
 	struct dentry *dentry;
 restart:
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_lockref.count) {
 			/*
@@ -1110,7 +1110,7 @@ repeat:
 resume:
 	while (next != &this_parent->d_subdirs) {
 		struct list_head *tmp = next;
-		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
+		struct dentry *dentry = list_entry(tmp, struct dentry, d_child);
 		next = tmp->next;
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
@@ -1162,7 +1162,7 @@ resume:
 			goto rename_retry;
 		}
 		rcu_read_unlock();
-		next = child->d_u.d_child.next;
+		next = child->d_child.next;
 		goto resume;
 	}
 	if (need_seqretry(&rename_lock, seq)) {
@@ -1497,8 +1497,8 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	INIT_HLIST_BL_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
-	INIT_HLIST_NODE(&dentry->d_alias);
-	INIT_LIST_HEAD(&dentry->d_u.d_child);
+	INIT_HLIST_NODE(&dentry->d_u.d_alias);
+	INIT_LIST_HEAD(&dentry->d_child);
 	d_set_d_op(dentry, dentry->d_sb->s_d_op);
 
 	this_cpu_inc(nr_dentry);
@@ -1528,7 +1528,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	 */
 	__dget_dlock(parent);
 	dentry->d_parent = parent;
-	list_add(&dentry->d_u.d_child, &parent->d_subdirs);
+	list_add(&dentry->d_child, &parent->d_subdirs);
 	spin_unlock(&parent->d_lock);
 
 	return dentry;
@@ -1588,7 +1588,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	if (inode) {
 		if (unlikely(IS_AUTOMOUNT(inode)))
 			dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
-		hlist_add_head(&dentry->d_alias, &inode->i_dentry);
+		hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
 	}
 	dentry->d_inode = inode;
 	dentry_rcuwalk_barrier(dentry);
@@ -1613,7 +1613,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
  
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
-	BUG_ON(!hlist_unhashed(&entry->d_alias));
+	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
 	if (inode)
 		spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
@@ -1652,7 +1652,7 @@ static struct dentry *__d_instantiate_unique(struct dentry *entry,
 		return NULL;
 	}
 
-	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
 		/*
 		 * Don't need alias->d_lock here, because aliases with
 		 * d_parent == entry->d_parent are not subject to name or
@@ -1678,7 +1678,7 @@ struct dentry *d_instantiate_unique(struct dentry *entry, struct inode *inode)
 {
 	struct dentry *result;
 
-	BUG_ON(!hlist_unhashed(&entry->d_alias));
+	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
 
 	if (inode)
 		spin_lock(&inode->i_lock);
@@ -1721,7 +1721,7 @@ static struct dentry * __d_find_any_alias(struct inode *inode)
 
 	if (hlist_empty(&inode->i_dentry))
 		return NULL;
-	alias = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
+	alias = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
 	__dget(alias);
 	return alias;
 }
@@ -1795,7 +1795,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	spin_lock(&tmp->d_lock);
 	tmp->d_inode = inode;
 	tmp->d_flags |= DCACHE_DISCONNECTED;
-	hlist_add_head(&tmp->d_alias, &inode->i_dentry);
+	hlist_add_head(&tmp->d_u.d_alias, &inode->i_dentry);
 	hlist_bl_lock(&tmp->d_sb->s_anon);
 	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
 	hlist_bl_unlock(&tmp->d_sb->s_anon);
@@ -2238,7 +2238,7 @@ int d_validate(struct dentry *dentry, struct dentry *dparent)
 	struct dentry *child;
 
 	spin_lock(&dparent->d_lock);
-	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
+	list_for_each_entry(child, &dparent->d_subdirs, d_child) {
 		if (dentry == child) {
 			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 			__dget_dlock(dentry);
@@ -2485,8 +2485,8 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
 	/* Unhash the target: dput() will then get rid of it */
 	__d_drop(target);
 
-	list_del(&dentry->d_u.d_child);
-	list_del(&target->d_u.d_child);
+	list_del(&dentry->d_child);
+	list_del(&target->d_child);
 
 	/* Switch the names.. */
 	switch_names(dentry, target);
@@ -2496,15 +2496,15 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
 	if (IS_ROOT(dentry)) {
 		dentry->d_parent = target->d_parent;
 		target->d_parent = target;
-		INIT_LIST_HEAD(&target->d_u.d_child);
+		INIT_LIST_HEAD(&target->d_child);
 	} else {
 		swap(dentry->d_parent, target->d_parent);
 
 		/* And add them back to the (new) parent lists */
-		list_add(&target->d_u.d_child, &target->d_parent->d_subdirs);
+		list_add(&target->d_child, &target->d_parent->d_subdirs);
 	}
 
-	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
+	list_add(&dentry->d_child, &dentry->d_parent->d_subdirs);
 
 	write_seqcount_end(&target->d_seq);
 	write_seqcount_end(&dentry->d_seq);
@@ -2611,9 +2611,9 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	swap(dentry->d_name.hash, anon->d_name.hash);
 
 	dentry->d_parent = dentry;
-	list_del_init(&dentry->d_u.d_child);
+	list_del_init(&dentry->d_child);
 	anon->d_parent = dparent;
-	list_move(&anon->d_u.d_child, &dparent->d_subdirs);
+	list_move(&anon->d_child, &dparent->d_subdirs);
 
 	write_seqcount_end(&dentry->d_seq);
 	write_seqcount_end(&anon->d_seq);
@@ -3241,7 +3241,7 @@ void d_tmpfile(struct dentry *dentry, struct inode *inode)
 {
 	inode_dec_link_count(inode);
 	BUG_ON(dentry->d_name.name != dentry->d_iname ||
-		!hlist_unhashed(&dentry->d_alias) ||
+		!hlist_unhashed(&dentry->d_u.d_alias) ||
 		!d_unlinked(dentry));
 	spin_lock(&dentry->d_parent->d_lock);
 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 15761957cc3f..f3784dd57353 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -549,10 +549,10 @@ void debugfs_remove_recursive(struct dentry *dentry)
 	/*
 	 * The parent->d_subdirs is protected by the d_lock. Outside that
 	 * lock, the child can be unlinked and set to be freed which can
-	 * use the d_u.d_child as the rcu head and corrupt this list.
+	 * use the d_child as the rcu head and corrupt this list.
 	 */
 	spin_lock(&parent->d_lock);
-	list_for_each_entry(child, &parent->d_subdirs, d_u.d_child) {
+	list_for_each_entry(child, &parent->d_subdirs, d_child) {
 		if (!debugfs_positive(child))
 			continue;
 
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index c43fe9b39ff2..b75f1742ddf9 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -50,7 +50,7 @@ find_acceptable_alias(struct dentry *result,
 
 	inode = result->d_inode;
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		dget(dentry);
 		spin_unlock(&inode->i_lock);
 		if (toput)
diff --git a/fs/libfs.c b/fs/libfs.c
index 193e0c29fb94..80d18955c322 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -105,18 +105,18 @@ loff_t dcache_dir_lseek(struct file *file, loff_t offset, int whence)
 
 			spin_lock(&dentry->d_lock);
 			/* d_lock not required for cursor */
-			list_del(&cursor->d_u.d_child);
+			list_del(&cursor->d_child);
 			p = dentry->d_subdirs.next;
 			while (n && p != &dentry->d_subdirs) {
 				struct dentry *next;
-				next = list_entry(p, struct dentry, d_u.d_child);
+				next = list_entry(p, struct dentry, d_child);
 				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (simple_positive(next))
 					n--;
 				spin_unlock(&next->d_lock);
 				p = p->next;
 			}
-			list_add_tail(&cursor->d_u.d_child, p);
+			list_add_tail(&cursor->d_child, p);
 			spin_unlock(&dentry->d_lock);
 		}
 	}
@@ -140,7 +140,7 @@ int dcache_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct dentry *cursor = file->private_data;
-	struct list_head *p, *q = &cursor->d_u.d_child;
+	struct list_head *p, *q = &cursor->d_child;
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
@@ -149,7 +149,7 @@ int dcache_readdir(struct file *file, struct dir_context *ctx)
 		list_move(q, &dentry->d_subdirs);
 
 	for (p = q->next; p != &dentry->d_subdirs; p = p->next) {
-		struct dentry *next = list_entry(p, struct dentry, d_u.d_child);
+		struct dentry *next = list_entry(p, struct dentry, d_child);
 		spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 		if (!simple_positive(next)) {
 			spin_unlock(&next->d_lock);
@@ -270,7 +270,7 @@ int simple_empty(struct dentry *dentry)
 	int ret = 0;
 
 	spin_lock(&dentry->d_lock);
-	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+	list_for_each_entry(child, &dentry->d_subdirs, d_child) {
 		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
 			spin_unlock(&child->d_lock);
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 3be047474bfc..0686002ccd1c 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -407,7 +407,7 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
-		dent = list_entry(next, struct dentry, d_u.d_child);
+		dent = list_entry(next, struct dentry, d_child);
 		if ((unsigned long)dent->d_fsdata == fpos) {
 			if (dent->d_inode)
 				dget(dent);
diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 32c06587351a..6d5e7c56c79d 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -194,7 +194,7 @@ ncp_renew_dentries(struct dentry *parent)
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
-		dentry = list_entry(next, struct dentry, d_u.d_child);
+		dentry = list_entry(next, struct dentry, d_child);
 
 		if (dentry->d_fsdata == NULL)
 			ncp_age_dentry(server, dentry);
@@ -216,7 +216,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
-		dentry = list_entry(next, struct dentry, d_u.d_child);
+		dentry = list_entry(next, struct dentry, d_child);
 		dentry->d_fsdata = NULL;
 		ncp_age_dentry(server, dentry);
 		next = next->next;
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 66984a9aafaa..5b8ab0e444f9 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -58,7 +58,7 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
 		 */
 		spin_lock(&sb->s_root->d_inode->i_lock);
 		spin_lock(&sb->s_root->d_lock);
-		hlist_del_init(&sb->s_root->d_alias);
+		hlist_del_init(&sb->s_root->d_u.d_alias);
 		spin_unlock(&sb->s_root->d_lock);
 		spin_unlock(&sb->s_root->d_inode->i_lock);
 	}
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 4bb21d67d9b1..a3153e2d0f1f 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -63,14 +63,14 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 	spin_lock(&inode->i_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
-	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
 		struct dentry *child;
 
 		/* run all of the children of the original inode and fix their
 		 * d_flags to indicate parental interest (their parent is the
 		 * original inode) */
 		spin_lock(&alias->d_lock);
-		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
+		list_for_each_entry(child, &alias->d_subdirs, d_child) {
 			if (!child->d_inode)
 				continue;
 
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e2e05a106beb..92edcfc23c1c 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -172,7 +172,7 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
 	struct dentry *dentry;
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
 			trace_ocfs2_find_local_alias(dentry->d_name.len,
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index cbde0540d4dd..53c1b60a29a0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -122,15 +122,15 @@ struct dentry {
 	void *d_fsdata;			/* fs-specific data */
 
 	struct list_head d_lru;		/* LRU list */
+	struct list_head d_child;	/* child of parent list */
+	struct list_head d_subdirs;	/* our children */
 	/*
-	 * d_child and d_rcu can share memory
+	 * d_alias and d_rcu can share memory
 	 */
 	union {
-		struct list_head d_child;	/* child of parent list */
+		struct hlist_node d_alias;	/* inode alias list */
 	 	struct rcu_head d_rcu;
 	} d_u;
-	struct list_head d_subdirs;	/* our children */
-	struct hlist_node d_alias;	/* inode alias list */
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c204fdb85d8..5d9d542c0bb5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1012,7 +1012,7 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
 	parent = dentry->d_parent;
 	spin_lock(&parent->d_lock);
 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-	list_del_init(&dentry->d_u.d_child);
+	list_del_init(&dentry->d_child);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&parent->d_lock);
 	remove_dir(dentry);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dcdf4e682dd4..691a8ea6f472 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6063,7 +6063,7 @@ static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t m
 	int ret;
 
 	/* Paranoid: Make sure the parent is the "instances" directory */
-	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
+	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
 	if (WARN_ON_ONCE(parent != trace_instance_dir))
 		return -ENOENT;
 
@@ -6090,7 +6090,7 @@ static int instance_rmdir(struct inode *inode, struct dentry *dentry)
 	int ret;
 
 	/* Paranoid: Make sure the parent is the "instances" directory */
-	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
+	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
 	if (WARN_ON_ONCE(parent != trace_instance_dir))
 		return -ENOENT;
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index bc1bd20f7942..be15da87b390 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -427,7 +427,7 @@ static void remove_event_file_dir(struct ftrace_event_file *file)
 
 	if (dir) {
 		spin_lock(&dir->d_lock);	/* probably unneeded */
-		list_for_each_entry(child, &dir->d_subdirs, d_u.d_child) {
+		list_for_each_entry(child, &dir->d_subdirs, d_child) {
 			if (child->d_inode)	/* probably unneeded */
 				child->d_inode->i_private = NULL;
 		}
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ff427733c290..86f969437f5d 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1190,7 +1190,7 @@ static void sel_remove_entries(struct dentry *de)
 	spin_lock(&de->d_lock);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
-		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
+		struct dentry *d = list_entry(node, struct dentry, d_child);
 
 		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
@@ -1664,12 +1664,12 @@ static void sel_remove_classes(void)
 
 	list_for_each(class_node, &class_dir->d_subdirs) {
 		struct dentry *class_subdir = list_entry(class_node,
-					struct dentry, d_u.d_child);
+					struct dentry, d_child);
 		struct list_head *class_subdir_node;
 
 		list_for_each(class_subdir_node, &class_subdir->d_subdirs) {
 			struct dentry *d = list_entry(class_subdir_node,
-						struct dentry, d_u.d_child);
+						struct dentry, d_child);
 
 			if (d->d_inode)
 				if (d->d_inode->i_mode & S_IFDIR)
-- 
2.2.2

