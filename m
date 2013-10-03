Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab3JCGUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:20:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41572 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3JCGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:20:17 -0400
Date: Thu, 03 Oct 2013 07:20:16 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 17/17] RCU'd vfsmounts
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


_very_ preliminary, barely tested.
    
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 0ff4bae..3b79d15 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -123,6 +123,7 @@ static void adfs_put_super(struct super_block *sb)
 	for (i = 0; i < asb->s_map_size; i++)
 		brelse(asb->s_map[i].dm_bh);
 	kfree(asb->s_map);
+	synchronize_rcu();
 	kfree(asb);
 	sb->s_fs_info = NULL;
 }
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index b104726..07599e2 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -62,6 +62,7 @@ void autofs4_kill_sb(struct super_block *sb)
 	/* Free wait queues, close pipe */
 	autofs4_catatonic_mode(sbi);
 
+	synchronize_rcu();
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a279ffc..e0305ae 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3779,6 +3779,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 
 	bdi_destroy(&cifs_sb->bdi);
 	kfree(cifs_sb->mountdata);
+	synchronize_rcu();
 	unload_nls(cifs_sb->local_nls);
 	kfree(cifs_sb);
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index d888223..ae74923 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1075,116 +1075,6 @@ void shrink_dcache_sb(struct super_block *sb)
 EXPORT_SYMBOL(shrink_dcache_sb);
 
 /*
- * destroy a single subtree of dentries for unmount
- * - see the comments on shrink_dcache_for_umount() for a description of the
- *   locking
- */
-static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
-{
-	struct dentry *parent;
-
-	BUG_ON(!IS_ROOT(dentry));
-
-	for (;;) {
-		/* descend to the first leaf in the current subtree */
-		while (!list_empty(&dentry->d_subdirs))
-			dentry = list_entry(dentry->d_subdirs.next,
-					    struct dentry, d_u.d_child);
-
-		/* consume the dentries from this leaf up through its parents
-		 * until we find one with children or run out altogether */
-		do {
-			struct inode *inode;
-
-			/*
-			 * inform the fs that this dentry is about to be
-			 * unhashed and destroyed.
-			 */
-			if ((dentry->d_flags & DCACHE_OP_PRUNE) &&
-			    !d_unhashed(dentry))
-				dentry->d_op->d_prune(dentry);
-
-			dentry_lru_del(dentry);
-			__d_shrink(dentry);
-
-			if (dentry->d_lockref.count != 0) {
-				printk(KERN_ERR
-				       "BUG: Dentry %p{i=%lx,n=%s}"
-				       " still in use (%d)"
-				       " [unmount of %s %s]\n",
-				       dentry,
-				       dentry->d_inode ?
-				       dentry->d_inode->i_ino : 0UL,
-				       dentry->d_name.name,
-				       dentry->d_lockref.count,
-				       dentry->d_sb->s_type->name,
-				       dentry->d_sb->s_id);
-				BUG();
-			}
-
-			if (IS_ROOT(dentry)) {
-				parent = NULL;
-				list_del(&dentry->d_u.d_child);
-			} else {
-				parent = dentry->d_parent;
-				parent->d_lockref.count--;
-				list_del(&dentry->d_u.d_child);
-			}
-
-			inode = dentry->d_inode;
-			if (inode) {
-				dentry->d_inode = NULL;
-				hlist_del_init(&dentry->d_alias);
-				if (dentry->d_op && dentry->d_op->d_iput)
-					dentry->d_op->d_iput(dentry, inode);
-				else
-					iput(inode);
-			}
-
-			d_free(dentry);
-
-			/* finished when we fall off the top of the tree,
-			 * otherwise we ascend to the parent and move to the
-			 * next sibling if there is one */
-			if (!parent)
-				return;
-			dentry = parent;
-		} while (list_empty(&dentry->d_subdirs));
-
-		dentry = list_entry(dentry->d_subdirs.next,
-				    struct dentry, d_u.d_child);
-	}
-}
-
-/*
- * destroy the dentries attached to a superblock on unmounting
- * - we don't need to use dentry->d_lock because:
- *   - the superblock is detached from all mountings and open files, so the
- *     dentry trees will not be rearranged by the VFS
- *   - s_umount is write-locked, so the memory pressure shrinker will ignore
- *     any dentries belonging to this superblock that it comes across
- *   - the filesystem itself is no longer permitted to rearrange the dentries
- *     in this superblock
- */
-void shrink_dcache_for_umount(struct super_block *sb)
-{
-	struct dentry *dentry;
-
-	if (down_read_trylock(&sb->s_umount))
-		BUG();
-
-	dentry = sb->s_root;
-	sb->s_root = NULL;
-	dentry->d_lockref.count--;
-	shrink_dcache_for_umount_subtree(dentry);
-
-	while (!hlist_bl_empty(&sb->s_anon)) {
-		dentry = hlist_bl_entry(hlist_bl_first(&sb->s_anon), struct dentry, d_hash);
-		shrink_dcache_for_umount_subtree(dentry);
-	}
-}
-
-/*
  * This tries to ascend one level of parenthood, but
  * we can race with renaming, so we need to re-check
  * the parenthood after dropping the lock and check
@@ -1478,6 +1368,90 @@ void shrink_dcache_parent(struct dentry *parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+static enum d_walk_ret umount_collect(void *_data, struct dentry *dentry)
+{
+	struct select_data *data = _data;
+	enum d_walk_ret ret = D_WALK_CONTINUE;
+
+	if (dentry->d_lockref.count) {
+		dentry_lru_del(dentry);
+		if (likely(!list_empty(&dentry->d_subdirs)))
+			goto out;
+		if (dentry == data->start && dentry->d_lockref.count == 1)
+			goto out;
+		printk(KERN_ERR
+		       "BUG: Dentry %p{i=%lx,n=%s}"
+		       " still in use (%d)"
+		       " [unmount of %s %s]\n",
+		       dentry,
+		       dentry->d_inode ?
+		       dentry->d_inode->i_ino : 0UL,
+		       dentry->d_name.name,
+		       dentry->d_lockref.count,
+		       dentry->d_sb->s_type->name,
+		       dentry->d_sb->s_id);
+		BUG();
+	} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
+		/*
+		 * We can't use d_lru_shrink_move() because we
+		 * need to get the global LRU lock and do the
+		 * LRU accounting.
+		 */
+		d_lru_del(dentry);
+		d_shrink_add(dentry, &data->dispose);
+		data->found++;
+		ret = D_WALK_NORETRY;
+	}
+out:
+	if (data->found && need_resched())
+		ret = D_WALK_QUIT;
+	return ret;
+}
+
+/*
+ * destroy the dentries attached to a superblock on unmounting
+ */
+void shrink_dcache_for_umount(struct super_block *sb)
+{
+	struct dentry *dentry;
+
+	if (down_read_trylock(&sb->s_umount))
+		BUG();
+
+	dentry = sb->s_root;
+	sb->s_root = NULL;
+	for (;;) {
+		struct select_data data;
+
+		INIT_LIST_HEAD(&data.dispose);
+		data.start = dentry;
+		data.found = 0;
+
+		d_walk(dentry, &data, umount_collect, NULL);
+		if (!data.found)
+			break;
+
+		shrink_dentry_list(&data.dispose);
+		cond_resched();
+	}
+	d_drop(dentry);
+	dput(dentry);
+
+	while (!hlist_bl_empty(&sb->s_anon)) {
+		struct select_data data;
+		dentry = hlist_bl_entry(hlist_bl_first(&sb->s_anon), struct dentry, d_hash);
+
+		INIT_LIST_HEAD(&data.dispose);
+		data.start = NULL;
+		data.found = 0;
+
+		d_walk(dentry, &data, umount_collect, NULL);
+		if (data.found)
+			shrink_dentry_list(&data.dispose);
+		cond_resched();
+	}
+}
+
 static enum d_walk_ret check_and_collect(void *_data, struct dentry *dentry)
 {
 	struct select_data *data = _data;
@@ -2885,24 +2859,28 @@ static int prepend_path(const struct path *path,
 	struct vfsmount *vfsmnt = path->mnt;
 	struct mount *mnt = real_mount(vfsmnt);
 	int error = 0;
-	unsigned seq = 0;
+	unsigned seq, m_seq = 0;
 	char *bptr;
 	int blen;
 
-	br_read_lock(&vfsmount_lock);
 	rcu_read_lock();
+restart_mnt:
+	read_seqbegin_or_lock(&mount_lock, &m_seq);
+	seq = 0;
 restart:
 	bptr = *buffer;
 	blen = *buflen;
+	error = 0;
 	read_seqbegin_or_lock(&rename_lock, &seq);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
+			struct mount *parent = ACCESS_ONCE(mnt->mnt_parent);
 			/* Global root? */
-			if (mnt_has_parent(mnt)) {
-				dentry = mnt->mnt_mountpoint;
-				mnt = mnt->mnt_parent;
+			if (mnt != parent) {
+				dentry = ACCESS_ONCE(mnt->mnt_mountpoint);
+				mnt = parent;
 				vfsmnt = &mnt->mnt;
 				continue;
 			}
@@ -2936,7 +2914,11 @@ restart:
 		goto restart;
 	}
 	done_seqretry(&rename_lock, seq);
-	br_read_unlock(&vfsmount_lock);
+	if (need_seqretry(&mount_lock, m_seq)) {
+		m_seq = 1;
+		goto restart_mnt;
+	}
+	done_seqretry(&mount_lock, m_seq);
 
 	if (error >= 0 && bptr == *buffer) {
 		if (--blen < 0)
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0062da2..3d297e6 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -557,6 +557,7 @@ static void fat_put_super(struct super_block *sb)
 	iput(sbi->fsinfo_inode);
 	iput(sbi->fat_inode);
 
+	synchronize_rcu();
 	unload_nls(sbi->nls_disk);
 	unload_nls(sbi->nls_io);
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index a8ce6da..2dfd2b4 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -387,6 +387,7 @@ static void fuse_put_super(struct super_block *sb)
 	mutex_unlock(&fuse_mutex);
 	fuse_bdi_destroy(fc);
 
+	synchronize_rcu();
 	fuse_conn_put(fc);
 }
 
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 4334cda..2946c6b 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -109,6 +109,7 @@ static void hpfs_put_super(struct super_block *s)
 	unmark_dirty(s);
 	hpfs_unlock(s);
 
+	synchronize_rcu();
 	kfree(sbi->sb_cp_table);
 	kfree(sbi->sb_bmp_dir);
 	s->s_fs_info = NULL;
diff --git a/fs/mount.h b/fs/mount.h
index f086607..d64c594 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -1,7 +1,6 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
-#include <linux/lglock.h>
 
 struct mnt_namespace {
 	atomic_t		count;
@@ -30,6 +29,7 @@ struct mount {
 	struct mount *mnt_parent;
 	struct dentry *mnt_mountpoint;
 	struct vfsmount mnt;
+	struct rcu_head mnt_rcu;
 #ifdef CONFIG_SMP
 	struct mnt_pcp __percpu *mnt_pcp;
 #else
@@ -80,21 +80,23 @@ static inline int is_mounted(struct vfsmount *mnt)
 extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *);
 extern struct mount *__lookup_mnt_last(struct vfsmount *, struct dentry *);
 
+extern bool legitimize_mnt(struct vfsmount *, unsigned);
+
 static inline void get_mnt_ns(struct mnt_namespace *ns)
 {
 	atomic_inc(&ns->count);
 }
 
-extern struct lglock vfsmount_lock;
+extern seqlock_t mount_lock;
 
 static inline void lock_mount_hash(void)
 {
-	br_write_lock(&vfsmount_lock);
+	write_seqlock(&mount_lock);
 }
 
 static inline void unlock_mount_hash(void)
 {
-	br_write_unlock(&vfsmount_lock);
+	write_sequnlock(&mount_lock);
 }
 
 struct proc_mounts {
diff --git a/fs/namei.c b/fs/namei.c
index 1f844fb..4b4310a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -482,18 +482,6 @@ EXPORT_SYMBOL(path_put);
  * to restart the path walk from the beginning in ref-walk mode.
  */
 
-static inline void lock_rcu_walk(void)
-{
-	br_read_lock(&vfsmount_lock);
-	rcu_read_lock();
-}
-
-static inline void unlock_rcu_walk(void)
-{
-	rcu_read_unlock();
-	br_read_unlock(&vfsmount_lock);
-}
-
 /**
  * unlazy_walk - try to switch to ref-walk mode.
  * @nd: nameidata pathwalk data
@@ -512,26 +500,23 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 
 	/*
-	 * Get a reference to the parent first: we're
-	 * going to make "path_put(nd->path)" valid in
-	 * non-RCU context for "terminate_walk()".
-	 *
-	 * If this doesn't work, return immediately with
-	 * RCU walking still active (and then we will do
-	 * the RCU walk cleanup in terminate_walk()).
+	 * After legitimizing the bastards, terminate_walk()
+	 * will do the right thing for non-RCU mode, and all our
+	 * subsequent exit cases should rcu_read_unlock()
+	 * before returning.  Do vfsmount first; if dentry
+	 * can't be legitimized, just set nd->path.dentry to NULL
+	 * and rely on dput(NULL) being a no-op.
 	 */
-	if (!lockref_get_not_dead(&parent->d_lockref))
+	if (!legitimize_mnt(nd->path.mnt, nd->m_seq))
 		return -ECHILD;
-
-	/*
-	 * After the mntget(), we terminate_walk() will do
-	 * the right thing for non-RCU mode, and all our
-	 * subsequent exit cases should unlock_rcu_walk()
-	 * before returning.
-	 */
-	mntget(nd->path.mnt);
 	nd->flags &= ~LOOKUP_RCU;
 
+	if (!lockref_get_not_dead(&parent->d_lockref)) {
+		nd->path.dentry = NULL;	
+		rcu_read_unlock();
+		return -ECHILD;
+	}
+
 	/*
 	 * For a negative lookup, the lookup sequence point is the parents
 	 * sequence point, and it only needs to revalidate the parent dentry.
@@ -566,17 +551,17 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 		spin_unlock(&fs->lock);
 	}
 
-	unlock_rcu_walk();
+	rcu_read_unlock();
 	return 0;
 
 unlock_and_drop_dentry:
 	spin_unlock(&fs->lock);
 drop_dentry:
-	unlock_rcu_walk();
+	rcu_read_unlock();
 	dput(dentry);
 	goto drop_root_mnt;
 out:
-	unlock_rcu_walk();
+	rcu_read_unlock();
 drop_root_mnt:
 	if (!(nd->flags & LOOKUP_ROOT))
 		nd->root.mnt = NULL;
@@ -608,17 +593,22 @@ static int complete_walk(struct nameidata *nd)
 		if (!(nd->flags & LOOKUP_ROOT))
 			nd->root.mnt = NULL;
 
+		if (!legitimize_mnt(nd->path.mnt, nd->m_seq)) {
+			rcu_read_unlock();
+			return -ECHILD;
+		}
 		if (unlikely(!lockref_get_not_dead(&dentry->d_lockref))) {
-			unlock_rcu_walk();
+			rcu_read_unlock();
+			mntput(nd->path.mnt);
 			return -ECHILD;
 		}
 		if (read_seqcount_retry(&dentry->d_seq, nd->seq)) {
-			unlock_rcu_walk();
+			rcu_read_unlock();
 			dput(dentry);
+			mntput(nd->path.mnt);
 			return -ECHILD;
 		}
-		mntget(nd->path.mnt);
-		unlock_rcu_walk();
+		rcu_read_unlock();
 	}
 
 	if (likely(!(nd->flags & LOOKUP_JUMPED)))
@@ -909,15 +899,15 @@ int follow_up(struct path *path)
 	struct mount *parent;
 	struct dentry *mountpoint;
 
-	br_read_lock(&vfsmount_lock);
+	read_seqlock_excl(&mount_lock);
 	parent = mnt->mnt_parent;
 	if (parent == mnt) {
-		br_read_unlock(&vfsmount_lock);
+		read_sequnlock_excl(&mount_lock);
 		return 0;
 	}
 	mntget(&parent->mnt);
 	mountpoint = dget(mnt->mnt_mountpoint);
-	br_read_unlock(&vfsmount_lock);
+	read_sequnlock_excl(&mount_lock);
 	dput(path->dentry);
 	path->dentry = mountpoint;
 	mntput(path->mnt);
@@ -1048,8 +1038,8 @@ static int follow_managed(struct path *path, unsigned flags)
 
 			/* Something is mounted on this dentry in another
 			 * namespace and/or whatever was mounted there in this
-			 * namespace got unmounted before we managed to get the
-			 * vfsmount_lock */
+			 * namespace got unmounted before lookup_mnt() could
+			 * get it */
 		}
 
 		/* Handle an automount point */
@@ -1174,7 +1164,7 @@ failed:
 	nd->flags &= ~LOOKUP_RCU;
 	if (!(nd->flags & LOOKUP_ROOT))
 		nd->root.mnt = NULL;
-	unlock_rcu_walk();
+	rcu_read_unlock();
 	return -ECHILD;
 }
 
@@ -1501,7 +1491,7 @@ static void terminate_walk(struct nameidata *nd)
 		nd->flags &= ~LOOKUP_RCU;
 		if (!(nd->flags & LOOKUP_ROOT))
 			nd->root.mnt = NULL;
-		unlock_rcu_walk();
+		rcu_read_unlock();
 	}
 }
 
@@ -1862,7 +1852,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		nd->path = nd->root;
 		nd->inode = inode;
 		if (flags & LOOKUP_RCU) {
-			lock_rcu_walk();
+			rcu_read_lock();
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 		} else {
 			path_get(&nd->path);
@@ -1872,9 +1862,10 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 
 	nd->root.mnt = NULL;
 
+	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*name=='/') {
 		if (flags & LOOKUP_RCU) {
-			lock_rcu_walk();
+			rcu_read_lock();
 			set_root_rcu(nd);
 		} else {
 			set_root(nd);
@@ -1886,7 +1877,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			struct fs_struct *fs = current->fs;
 			unsigned seq;
 
-			lock_rcu_walk();
+			rcu_read_lock();
 
 			do {
 				seq = read_seqcount_begin(&fs->seq);
@@ -1918,7 +1909,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			if (f.need_put)
 				*fp = f.file;
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
-			lock_rcu_walk();
+			rcu_read_lock();
 		} else {
 			path_get(&nd->path);
 			fdput(f);
diff --git a/fs/namespace.c b/fs/namespace.c
index 8ae16b9f..1711536 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -53,7 +53,7 @@ EXPORT_SYMBOL_GPL(fs_kobj);
  * It should be taken for write in all cases where the vfsmount
  * tree or hash is modified or when a vfsmount structure is modified.
  */
-DEFINE_BRLOCK(vfsmount_lock);
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(mount_lock);
 
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
@@ -547,16 +547,38 @@ static void free_vfsmnt(struct mount *mnt)
 	kmem_cache_free(mnt_cache, mnt);
 }
 
+/* call under rcu_read_lock */
+bool legitimize_mnt(struct vfsmount *bastard, unsigned seq)
+{
+	struct mount *mnt;
+	if (read_seqretry(&mount_lock, seq))
+		return false;
+	if (bastard == NULL)
+		return true;
+	mnt = real_mount(bastard);
+	mnt_add_count(mnt, 1);
+	if (likely(!read_seqretry(&mount_lock, seq)))
+		return true;
+	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
+		mnt_add_count(mnt, -1);
+		return false;
+	}
+	rcu_read_unlock();
+	mntput(bastard);
+	rcu_read_lock();
+	return false;
+}
+
 /*
  * find the first mount at @dentry on vfsmount @mnt.
- * vfsmount_lock must be held for read or write.
+ * call under rcu_read_lock()
  */
 struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
 {
 	struct list_head *head = mount_hashtable + hash(mnt, dentry);
 	struct mount *p;
 
-	list_for_each_entry(p, head, mnt_hash)
+	list_for_each_entry_rcu(p, head, mnt_hash)
 		if (&p->mnt_parent->mnt == mnt && p->mnt_mountpoint == dentry)
 			return p;
 	return NULL;
@@ -564,7 +586,7 @@ struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
 
 /*
  * find the last mount at @dentry on vfsmount @mnt.
- * vfsmount_lock must be held for read or write.
+ * mount_lock must be held.
  */
 struct mount *__lookup_mnt_last(struct vfsmount *mnt, struct dentry *dentry)
 {
@@ -596,17 +618,17 @@ struct mount *__lookup_mnt_last(struct vfsmount *mnt, struct dentry *dentry)
 struct vfsmount *lookup_mnt(struct path *path)
 {
 	struct mount *child_mnt;
+	struct vfsmount *m;
+	unsigned seq;
 
-	br_read_lock(&vfsmount_lock);
-	child_mnt = __lookup_mnt(path->mnt, path->dentry);
-	if (child_mnt) {
-		mnt_add_count(child_mnt, 1);
-		br_read_unlock(&vfsmount_lock);
-		return &child_mnt->mnt;
-	} else {
-		br_read_unlock(&vfsmount_lock);
-		return NULL;
-	}
+	rcu_read_lock();
+	do {
+		seq = read_seqbegin(&mount_lock);
+		child_mnt = __lookup_mnt(path->mnt, path->dentry);
+		m = child_mnt ? &child_mnt->mnt : NULL;
+	} while (!legitimize_mnt(m, seq));
+	rcu_read_unlock();
+	return m;
 }
 
 static struct mountpoint *new_mountpoint(struct dentry *dentry)
@@ -874,38 +896,47 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	return ERR_PTR(err);
 }
 
+static void delayed_free(struct rcu_head *head)
+{
+	struct mount *mnt = container_of(head, struct mount, mnt_rcu);
+	kfree(mnt->mnt_devname);
+#ifdef CONFIG_SMP
+	free_percpu(mnt->mnt_pcp);
+#endif
+	kmem_cache_free(mnt_cache, mnt);
+}
+
 static void mntput_no_expire(struct mount *mnt)
 {
 put_again:
-#ifdef CONFIG_SMP
-	br_read_lock(&vfsmount_lock);
-	if (likely(mnt->mnt_ns)) {
-		/* shouldn't be the last one */
-		mnt_add_count(mnt, -1);
-		br_read_unlock(&vfsmount_lock);
+	rcu_read_lock();
+	mnt_add_count(mnt, -1);
+	smp_mb();
+	if (likely(mnt->mnt_ns)) { /* shouldn't be the last one */
+		rcu_read_unlock();
 		return;
 	}
-	br_read_unlock(&vfsmount_lock);
-
 	lock_mount_hash();
-	mnt_add_count(mnt, -1);
 	if (mnt_get_count(mnt)) {
+		rcu_read_unlock();
 		unlock_mount_hash();
 		return;
 	}
-#else
-	mnt_add_count(mnt, -1);
-	if (likely(mnt_get_count(mnt)))
-		return;
-	lock_mount_hash();
-#endif
 	if (unlikely(mnt->mnt_pinned)) {
 		mnt_add_count(mnt, mnt->mnt_pinned + 1);
 		mnt->mnt_pinned = 0;
+		rcu_read_unlock();
 		unlock_mount_hash();
 		acct_auto_close_mnt(&mnt->mnt);
 		goto put_again;
 	}
+	if (unlikely(mnt->mnt.mnt_flags & MNT_DOOMED)) {
+		rcu_read_unlock();
+		unlock_mount_hash();
+		return;
+	}
+	mnt->mnt.mnt_flags |= MNT_DOOMED;
+	rcu_read_unlock();
 
 	list_del(&mnt->mnt_instance);
 	unlock_mount_hash();
@@ -924,7 +955,8 @@ put_again:
 	fsnotify_vfsmount_delete(&mnt->mnt);
 	dput(mnt->mnt.mnt_root);
 	deactivate_super(mnt->mnt.mnt_sb);
-	free_vfsmnt(mnt);
+	mnt_free_id(mnt);
+	call_rcu(&mnt->mnt_rcu, delayed_free);
 }
 
 void mntput(struct vfsmount *mnt)
@@ -1137,6 +1169,8 @@ static void namespace_unlock(void)
 	list_splice_init(&unmounted, &head);
 	up_write(&namespace_sem);
 
+	synchronize_rcu();
+
 	while (!list_empty(&head)) {
 		mnt = list_first_entry(&head, struct mount, mnt_hash);
 		list_del_init(&mnt->mnt_hash);
@@ -1152,10 +1186,13 @@ static inline void namespace_lock(void)
 }
 
 /*
- * vfsmount lock must be held for write
+ * mount_lock must be held
  * namespace_sem must be held for write
+ * how = 0 => just this tree, don't propagate
+ * how = 1 => propagate; we know that nobody else has reference to any victims
+ * how = 2 => lazy umount
  */
-void umount_tree(struct mount *mnt, int propagate)
+void umount_tree(struct mount *mnt, int how)
 {
 	LIST_HEAD(tmp_list);
 	struct mount *p;
@@ -1163,7 +1200,7 @@ void umount_tree(struct mount *mnt, int propagate)
 	for (p = mnt; p; p = next_mnt(p, mnt))
 		list_move(&p->mnt_hash, &tmp_list);
 
-	if (propagate)
+	if (how)
 		propagate_umount(&tmp_list);
 
 	list_for_each_entry(p, &tmp_list, mnt_hash) {
@@ -1171,6 +1208,8 @@ void umount_tree(struct mount *mnt, int propagate)
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
 		p->mnt_ns = NULL;
+		if (how < 2)
+			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
 		list_del_init(&p->mnt_child);
 		if (mnt_has_parent(p)) {
 			put_mountpoint(p->mnt_mp);
@@ -1262,14 +1301,18 @@ static int do_umount(struct mount *mnt, int flags)
 	lock_mount_hash();
 	event++;
 
-	if (!(flags & MNT_DETACH))
-		shrink_submounts(mnt);
-
-	retval = -EBUSY;
-	if (flags & MNT_DETACH || !propagate_mount_busy(mnt, 2)) {
+	if (flags & MNT_DETACH) {
 		if (!list_empty(&mnt->mnt_list))
-			umount_tree(mnt, 1);
+			umount_tree(mnt, 2);
 		retval = 0;
+	} else {
+		shrink_submounts(mnt);
+		retval = -EBUSY;
+		if (!propagate_mount_busy(mnt, 2)) {
+			if (!list_empty(&mnt->mnt_list))
+				umount_tree(mnt, 1);
+			retval = 0;
+		}
 	}
 	unlock_mount_hash();
 	namespace_unlock();
@@ -1955,7 +1998,7 @@ static int do_add_mount(struct mount *newmnt, struct path *path, int mnt_flags)
 	struct mount *parent;
 	int err;
 
-	mnt_flags &= ~(MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL);
+	mnt_flags &= ~(MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL | MNT_DOOMED | MNT_SYNC_UMOUNT);
 
 	mp = lock_mount(path);
 	if (IS_ERR(mp))
@@ -2172,7 +2215,7 @@ resume:
  * process a list of expirable mountpoints with the intent of discarding any
  * submounts of a specific parent mountpoint
  *
- * vfsmount_lock must be held for write
+ * mount_lock must be held for write
  */
 static void shrink_submounts(struct mount *mnt)
 {
@@ -2558,7 +2601,7 @@ out_type:
 /*
  * Return true if path is reachable from root
  *
- * namespace_sem or vfsmount_lock is held
+ * namespace_sem or mount_lock is held
  */
 bool is_path_reachable(struct mount *mnt, struct dentry *dentry,
 			 const struct path *root)
@@ -2573,9 +2616,9 @@ bool is_path_reachable(struct mount *mnt, struct dentry *dentry,
 int path_is_under(struct path *path1, struct path *path2)
 {
 	int res;
-	br_read_lock(&vfsmount_lock);
+	read_seqlock_excl(&mount_lock);
 	res = is_path_reachable(real_mount(path1->mnt), path1->dentry, path2);
-	br_read_unlock(&vfsmount_lock);
+	read_sequnlock_excl(&mount_lock);
 	return res;
 }
 EXPORT_SYMBOL(path_is_under);
@@ -2748,8 +2791,6 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mountpoint_hashtable[u]);
 
-	br_lock_init(&vfsmount_lock);
-
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
@@ -2783,6 +2824,7 @@ struct vfsmount *kern_mount_data(struct file_system_type *type, void *data)
 		 * we unmount before file sys is unregistered
 		*/
 		real_mount(mnt)->mnt_ns = MNT_NS_INTERNAL;
+		smp_wmb();
 	}
 	return mnt;
 }
@@ -2792,9 +2834,8 @@ void kern_unmount(struct vfsmount *mnt)
 {
 	/* release long term mount so mount point can be released */
 	if (!IS_ERR_OR_NULL(mnt)) {
-		lock_mount_hash();
 		real_mount(mnt)->mnt_ns = NULL;
-		unlock_mount_hash();
+		smp_mb();
 		mntput(mnt);
 	}
 }
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 4659da6..5539b5b 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -792,6 +792,7 @@ static void ncp_put_super(struct super_block *sb)
 
 	ncp_stop_tasks(server);
 
+	synchronize_rcu();
 #ifdef CONFIG_NCPFS_NLS
 	/* unload the NLS charsets */
 	unload_nls(server->nls_vol);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 87dbcbe..8d1e094 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -148,6 +148,7 @@ static void proc_kill_sb(struct super_block *sb)
 	if (ns->proc_self)
 		dput(ns->proc_self);
 	kill_anon_super(sb);
+	synchronize_rcu();	/* might be an overkill */
 	put_pid_ns(ns);
 }
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 38cd98f..371d346 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -49,6 +49,8 @@ struct mnt_namespace;
 
 #define MNT_LOCK_READONLY	0x400000
 #define MNT_LOCKED		0x800000
+#define MNT_DOOMED		0x1000000
+#define MNT_SYNC_UMOUNT		0x2000000
 
 struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 8e47bc7..492de72 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -16,7 +16,7 @@ struct nameidata {
 	struct path	root;
 	struct inode	*inode; /* path.dentry.d_inode */
 	unsigned int	flags;
-	unsigned	seq;
+	unsigned	seq, m_seq;
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
