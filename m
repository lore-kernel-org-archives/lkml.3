Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3HFDNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:13:41 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46673 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3HFDNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:13:08 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v7 3/4] dcache: replace d_lock/d_count by d_lockcnt
Date: Mon,  5 Aug 2013 23:12:38 -0400
Message-Id: <1375758759-29629-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the d_lock and d_count fields of the dentry
data structure by the combined d_lockcnt structure. A d_lock macro
is defined to remap the old d_lock name to the new d_lockcnt.lock
name. This is needed as a lot of files use the d_lock spinlock.

Read accesses to d_count are replaced by the d_count() helper
function. Write accesses to d_count are replaced by the new
d_lockcnt.refcnt name. Other than that, there is no other functional
change in this patch.

The offsets of the new d_lockcnt field are at byte 72 and 88 for
32-bit and 64-bit SMP systems respectively. In both cases, they are
8-byte aligned and their combination into a single 8-byte word will
not introduce a hole that increase the size of the dentry structure.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c            |   54 ++++++++++++++++++++++++------------------------
 fs/namei.c             |    6 ++--
 include/linux/dcache.h |   15 ++++++++----
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 87bdb53..3adb6aa 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -54,7 +54,7 @@
  *   - d_flags
  *   - d_name
  *   - d_lru
- *   - d_count
+ *   - d_lockcnt.refcnt
  *   - d_unhashed()
  *   - d_parent and d_subdirs
  *   - childrens' d_child and d_parent
@@ -229,7 +229,7 @@ static void __d_free(struct rcu_head *head)
  */
 static void d_free(struct dentry *dentry)
 {
-	BUG_ON(dentry->d_count);
+	BUG_ON(d_count(dentry));
 	this_cpu_dec(nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
@@ -467,7 +467,7 @@ relock:
 	}
 
 	if (ref)
-		dentry->d_count--;
+		dentry->d_lockcnt.refcnt--;
 	/*
 	 * inform the fs via d_prune that this dentry is about to be
 	 * unhashed and destroyed.
@@ -513,12 +513,12 @@ void dput(struct dentry *dentry)
 		return;
 
 repeat:
-	if (dentry->d_count == 1)
+	if (d_count(dentry) == 1)
 		might_sleep();
 	spin_lock(&dentry->d_lock);
-	BUG_ON(!dentry->d_count);
-	if (dentry->d_count > 1) {
-		dentry->d_count--;
+	BUG_ON(!d_count(dentry));
+	if (d_count(dentry) > 1) {
+		dentry->d_lockcnt.refcnt--;
 		spin_unlock(&dentry->d_lock);
 		return;
 	}
@@ -535,7 +535,7 @@ repeat:
 	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
 
-	dentry->d_count--;
+	dentry->d_lockcnt.refcnt--;
 	spin_unlock(&dentry->d_lock);
 	return;
 
@@ -590,7 +590,7 @@ int d_invalidate(struct dentry * dentry)
 	 * We also need to leave mountpoints alone,
 	 * directory or not.
 	 */
-	if (dentry->d_count > 1 && dentry->d_inode) {
+	if (d_count(dentry) > 1 && dentry->d_inode) {
 		if (S_ISDIR(dentry->d_inode->i_mode) || d_mountpoint(dentry)) {
 			spin_unlock(&dentry->d_lock);
 			return -EBUSY;
@@ -606,7 +606,7 @@ EXPORT_SYMBOL(d_invalidate);
 /* This must be called with d_lock held */
 static inline void __dget_dlock(struct dentry *dentry)
 {
-	dentry->d_count++;
+	dentry->d_lockcnt.refcnt++;
 }
 
 static inline void __dget(struct dentry *dentry)
@@ -634,8 +634,8 @@ repeat:
 		goto repeat;
 	}
 	rcu_read_unlock();
-	BUG_ON(!ret->d_count);
-	ret->d_count++;
+	BUG_ON(!d_count(ret));
+	ret->d_lockcnt.refcnt++;
 	spin_unlock(&ret->d_lock);
 	return ret;
 }
@@ -718,7 +718,7 @@ restart:
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
-		if (!dentry->d_count) {
+		if (!d_count(dentry)) {
 			__dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
@@ -734,7 +734,7 @@ EXPORT_SYMBOL(d_prune_aliases);
 
 /*
  * Try to throw away a dentry - free the inode, dput the parent.
- * Requires dentry->d_lock is held, and dentry->d_count == 0.
+ * Requires dentry->d_lock is held, and dentry->d_lockcnt.refcnt == 0.
  * Releases dentry->d_lock.
  *
  * This may fail if locks cannot be acquired no problem, just try again.
@@ -764,8 +764,8 @@ static void try_prune_one_dentry(struct dentry *dentry)
 	dentry = parent;
 	while (dentry) {
 		spin_lock(&dentry->d_lock);
-		if (dentry->d_count > 1) {
-			dentry->d_count--;
+		if (d_count(dentry) > 1) {
+			dentry->d_lockcnt.refcnt--;
 			spin_unlock(&dentry->d_lock);
 			return;
 		}
@@ -793,7 +793,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
-		if (dentry->d_count) {
+		if (d_count(dentry)) {
 			dentry_lru_del(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
@@ -913,7 +913,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 			dentry_lru_del(dentry);
 			__d_shrink(dentry);
 
-			if (dentry->d_count != 0) {
+			if (d_count(dentry) != 0) {
 				printk(KERN_ERR
 				       "BUG: Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
@@ -922,7 +922,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				       dentry->d_inode ?
 				       dentry->d_inode->i_ino : 0UL,
 				       dentry->d_name.name,
-				       dentry->d_count,
+				       d_count(dentry),
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
 				BUG();
@@ -933,7 +933,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				list_del(&dentry->d_u.d_child);
 			} else {
 				parent = dentry->d_parent;
-				parent->d_count--;
+				parent->d_lockcnt.refcnt--;
 				list_del(&dentry->d_u.d_child);
 			}
 
@@ -981,7 +981,7 @@ void shrink_dcache_for_umount(struct super_block *sb)
 
 	dentry = sb->s_root;
 	sb->s_root = NULL;
-	dentry->d_count--;
+	dentry->d_lockcnt.refcnt--;
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_bl_empty(&sb->s_anon)) {
@@ -1147,7 +1147,7 @@ resume:
 		 * loop in shrink_dcache_parent() might not make any progress
 		 * and loop forever.
 		 */
-		if (dentry->d_count) {
+		if (d_count(dentry)) {
 			dentry_lru_del(dentry);
 		} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
 			dentry_lru_move_list(dentry, dispose);
@@ -1269,7 +1269,7 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	smp_wmb();
 	dentry->d_name.name = dname;
 
-	dentry->d_count = 1;
+	dentry->d_lockcnt.refcnt = 1;
 	dentry->d_flags = 0;
 	spin_lock_init(&dentry->d_lock);
 	seqcount_init(&dentry->d_seq);
@@ -1970,7 +1970,7 @@ struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
 				goto next;
 		}
 
-		dentry->d_count++;
+		dentry->d_lockcnt.refcnt++;
 		found = dentry;
 		spin_unlock(&dentry->d_lock);
 		break;
@@ -2069,7 +2069,7 @@ again:
 	spin_lock(&dentry->d_lock);
 	inode = dentry->d_inode;
 	isdir = S_ISDIR(inode->i_mode);
-	if (dentry->d_count == 1) {
+	if (d_count(dentry) == 1) {
 		if (!spin_trylock(&inode->i_lock)) {
 			spin_unlock(&dentry->d_lock);
 			cpu_relax();
@@ -2937,7 +2937,7 @@ resume:
 		}
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
 			dentry->d_flags |= DCACHE_GENOCIDE;
-			dentry->d_count--;
+			dentry->d_lockcnt.refcnt--;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
@@ -2945,7 +2945,7 @@ resume:
 		struct dentry *child = this_parent;
 		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
 			this_parent->d_flags |= DCACHE_GENOCIDE;
-			this_parent->d_count--;
+			this_parent->d_lockcnt.refcnt--;
 		}
 		this_parent = try_to_ascend(this_parent, locked, seq);
 		if (!this_parent)
diff --git a/fs/namei.c b/fs/namei.c
index 8b61d10..28e5152 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -536,8 +536,8 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 		 * a reference at this point.
 		 */
 		BUG_ON(!IS_ROOT(dentry) && dentry->d_parent != parent);
-		BUG_ON(!parent->d_count);
-		parent->d_count++;
+		BUG_ON(!d_count(parent));
+		parent->d_lockcnt.refcnt++;
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&parent->d_lock);
@@ -3327,7 +3327,7 @@ void dentry_unhash(struct dentry *dentry)
 {
 	shrink_dcache_parent(dentry);
 	spin_lock(&dentry->d_lock);
-	if (dentry->d_count == 1)
+	if (d_count(dentry) == 1)
 		__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index b90337c..20e6f2e 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -9,6 +9,7 @@
 #include <linux/seqlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock_refcount.h>
 
 struct nameidata;
 struct path;
@@ -112,8 +113,7 @@ struct dentry {
 	unsigned char d_iname[DNAME_INLINE_LEN];	/* small names */
 
 	/* Ref lookup also touches following */
-	unsigned int d_count;		/* protected by d_lock */
-	spinlock_t d_lock;		/* per dentry lock */
+	struct lockref d_lockcnt;	/* per dentry lock & count */
 	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	unsigned long d_time;		/* used by d_revalidate */
@@ -132,6 +132,11 @@ struct dentry {
 };
 
 /*
+ * Define macros to access the name-changed spinlock
+ */
+#define d_lock	d_lockcnt.lock
+
+/*
  * dentry->d_lock spinlock nesting subclasses:
  *
  * 0: normal
@@ -318,7 +323,7 @@ static inline int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq)
 	assert_spin_locked(&dentry->d_lock);
 	if (!read_seqcount_retry(&dentry->d_seq, seq)) {
 		ret = 1;
-		dentry->d_count++;
+		dentry->d_lockcnt.refcnt++;
 	}
 
 	return ret;
@@ -326,7 +331,7 @@ static inline int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq)
 
 static inline unsigned d_count(const struct dentry *dentry)
 {
-	return dentry->d_count;
+	return dentry->d_lockcnt.refcnt;
 }
 
 /* validate "insecure" dentry pointer */
@@ -356,7 +361,7 @@ extern char *dentry_path(struct dentry *, char *, int);
 static inline struct dentry *dget_dlock(struct dentry *dentry)
 {
 	if (dentry)
-		dentry->d_count++;
+		dentry->d_lockcnt.refcnt++;
 	return dentry;
 }
 
-- 
1.7.1

