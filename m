Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525Ab3GCUVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:40 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:24458 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508Ab3GCUVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:37 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 13/25] vfs: Change how dentry's d_lock and d_count fields are accessed
Date: Wed,  3 Jul 2013 16:21:24 -0400
Message-Id: <1372882884-22949-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that use
the d_lock and d_count fields of the dentry structure need to be
changed accordingly.  All the d_lock's spin_lock() and spin_unlock()
calls are replaced by the corresponding d_lock() and d_unlock() calls.
References to d_count are replaced by the d_ret_count() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcookies.c     |    8 ++++----
 fs/fs-writeback.c |    4 ++--
 fs/libfs.c        |   36 ++++++++++++++++++------------------
 fs/namei.c        |   28 ++++++++++++++--------------
 fs/namespace.c    |   10 +++++-----
 5 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/fs/dcookies.c b/fs/dcookies.c
index ab5954b..fa674e8 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -99,9 +99,9 @@ static struct dcookie_struct *alloc_dcookie(struct path *path)
 		return NULL;
 
 	d = path->dentry;
-	spin_lock(&d->d_lock);
+	d_lock(d);
 	d->d_flags |= DCACHE_COOKIE;
-	spin_unlock(&d->d_lock);
+	d_unlock(d);
 
 	dcs->path = *path;
 	path_get(path);
@@ -272,9 +272,9 @@ static void free_dcookie(struct dcookie_struct * dcs)
 {
 	struct dentry *d = dcs->path.dentry;
 
-	spin_lock(&d->d_lock);
+	d_lock(d);
 	d->d_flags &= ~DCACHE_COOKIE;
-	spin_unlock(&d->d_lock);
+	d_unlock(d);
 
 	path_put(&dcs->path);
 	kmem_cache_free(dcookie_cache, dcs);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3be5718..a8d95d6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1073,7 +1073,7 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 
 		dentry = d_find_alias(inode);
 		if (dentry) {
-			spin_lock(&dentry->d_lock);
+			d_lock(dentry);
 			name = (const char *) dentry->d_name.name;
 		}
 		printk(KERN_DEBUG
@@ -1081,7 +1081,7 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 		       current->comm, task_pid_nr(current), inode->i_ino,
 		       name, inode->i_sb->s_id);
 		if (dentry) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			dput(dentry);
 		}
 	}
diff --git a/fs/libfs.c b/fs/libfs.c
index 916da8c..5cba740 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -102,21 +102,21 @@ loff_t dcache_dir_lseek(struct file *file, loff_t offset, int whence)
 			struct dentry *cursor = file->private_data;
 			loff_t n = file->f_pos - 2;
 
-			spin_lock(&dentry->d_lock);
+			d_lock(dentry);
 			/* d_lock not required for cursor */
 			list_del(&cursor->d_u.d_child);
 			p = dentry->d_subdirs.next;
 			while (n && p != &dentry->d_subdirs) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				d_lock_nested(next, DENTRY_D_LOCK_NESTED);
 				if (simple_positive(next))
 					n--;
-				spin_unlock(&next->d_lock);
+				d_unlock(next);
 				p = p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -159,35 +159,35 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			i++;
 			/* fallthrough */
 		default:
-			spin_lock(&dentry->d_lock);
+			d_lock(dentry);
 			if (filp->f_pos == 2)
 				list_move(q, &dentry->d_subdirs);
 
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				d_lock_nested(next, DENTRY_D_LOCK_NESTED);
 				if (!simple_positive(next)) {
-					spin_unlock(&next->d_lock);
+					d_unlock(next);
 					continue;
 				}
 
-				spin_unlock(&next->d_lock);
-				spin_unlock(&dentry->d_lock);
+				d_unlock(next);
+				d_unlock(dentry);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
 					    next->d_inode->i_ino, 
 					    dt_type(next->d_inode)) < 0)
 					return 0;
-				spin_lock(&dentry->d_lock);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				d_lock(dentry);
+				d_lock_nested(next, DENTRY_D_LOCK_NESTED);
 				/* next is still alive */
 				list_move(q, p);
-				spin_unlock(&next->d_lock);
+				d_unlock(next);
 				p = q;
 				filp->f_pos++;
 			}
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 	}
 	return 0;
 }
@@ -288,18 +288,18 @@ int simple_empty(struct dentry *dentry)
 	struct dentry *child;
 	int ret = 0;
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
-		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+		d_lock_nested(child, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
-			spin_unlock(&child->d_lock);
+			d_unlock(child);
 			goto out;
 		}
-		spin_unlock(&child->d_lock);
+		d_unlock(child);
 	}
 	ret = 1;
 out:
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return ret;
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 9ed9361..848cb78 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -518,7 +518,7 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 				nd->root.dentry != fs->root.dentry)
 			goto err_root;
 	}
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 	if (!dentry) {
 		if (!__d_rcu_to_refcount(parent, nd->seq))
 			goto err_parent;
@@ -526,7 +526,7 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 	} else {
 		if (dentry->d_parent != parent)
 			goto err_parent;
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		d_lock_nested(dentry, DENTRY_D_LOCK_NESTED);
 		if (!__d_rcu_to_refcount(dentry, nd->seq))
 			goto err_child;
 		/*
@@ -536,11 +536,11 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 		 * a reference at this point.
 		 */
 		BUG_ON(!IS_ROOT(dentry) && dentry->d_parent != parent);
-		BUG_ON(!parent->d_count);
-		parent->d_count++;
-		spin_unlock(&dentry->d_lock);
+		BUG_ON(!d_ret_count(parent));
+		d_ret_count(parent)++;
+		d_unlock(dentry);
 	}
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 	if (want_root) {
 		path_get(&nd->root);
 		spin_unlock(&fs->lock);
@@ -552,9 +552,9 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 	return 0;
 
 err_child:
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 err_parent:
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 err_root:
 	if (want_root)
 		spin_unlock(&fs->lock);
@@ -585,14 +585,14 @@ static int complete_walk(struct nameidata *nd)
 		nd->flags &= ~LOOKUP_RCU;
 		if (!(nd->flags & LOOKUP_ROOT))
 			nd->root.mnt = NULL;
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		if (unlikely(!__d_rcu_to_refcount(dentry, nd->seq))) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			unlock_rcu_walk();
 			return -ECHILD;
 		}
 		BUG_ON(nd->inode != dentry->d_inode);
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		mntget(nd->path.mnt);
 		unlock_rcu_walk();
 	}
@@ -3279,10 +3279,10 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 void dentry_unhash(struct dentry *dentry)
 {
 	shrink_dcache_parent(dentry);
-	spin_lock(&dentry->d_lock);
-	if (dentry->d_count == 1)
+	d_lock(dentry);
+	if (d_ret_count(dentry) == 1)
 		__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
diff --git a/fs/namespace.c b/fs/namespace.c
index 7b1ca9b..a6bfdc6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -626,14 +626,14 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 	if (!mp)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (d_unlinked(dentry)) {
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		kfree(mp);
 		return ERR_PTR(-ENOENT);
 	}
 	dentry->d_flags |= DCACHE_MOUNTED;
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
 	list_add(&mp->m_hash, chain);
@@ -644,9 +644,9 @@ static void put_mountpoint(struct mountpoint *mp)
 {
 	if (!--mp->m_count) {
 		struct dentry *dentry = mp->m_dentry;
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		dentry->d_flags &= ~DCACHE_MOUNTED;
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		list_del(&mp->m_hash);
 		kfree(mp);
 	}
-- 
1.7.1

