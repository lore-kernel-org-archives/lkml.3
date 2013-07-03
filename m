Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab3GCUUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:20:11 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16803 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321Ab3GCUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:19:37 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 03/25] dcache: Enable lockless update of d_count in dentry structure
Date: Wed,  3 Jul 2013 16:19:01 -0400
Message-Id: <1372882741-22563-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372882741-22563-1-git-send-email-Waiman.Long@hp.com>
References: <1372882741-22563-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code takes the dentry's d_lock lock whenever the d_count
reference count is being updated. In reality, nothing big really
happens until d_count goes to 0 in dput(). So it is not necessary
to take the lock if the reference count won't go to 0. On the other
hand, there are cases where d_count should not be updated or was not
expected to be updated while d_lock was acquired by another thread.

To use the new lockref infrastructure to do lockless reference count
update, the d_lock and d_count field of the dentry structure was
combined into a new d_lockcnt field. To access the new spinlock and
reference count fields, a number of helper functions were added to
the dcache.h header file.

The offsets of the new d_lockcnt field are at byte 72 and 88 for
32-bit and 64-bit SMP systems respectively. In both cases, they are
8-byte aligned and their combination into a single 8-byte word will
not introduce a hole that increase the size of the dentry structure.

This patch has a particular big impact on the short workload of the
AIM7 benchmark with ramdisk filesystem. The table below show the
performance improvement to the JPM (jobs per minutes) throughput
due to this patch on an 8-socket 80-core x86-64 system with a 3.10
kernel in a 1/2/4/8 node configuration by using numactl to restrict
the execution of the workload on certain nodes.

+-----------------+----------------+-----------------+----------+
|  Configuration  |    Mean JPM    |    Mean JPM     | % Change |
|                 | Rate w/o patch | Rate with patch |          |
+-----------------+---------------------------------------------+
|                 |              User Range 10 - 100            |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1650355     |     5191497     | +214.6%  |
| 4 nodes, HT off |    1665137     |     5204267     | +212.5%  |
| 2 nodes, HT off |    1667552     |     3815637     | +128.8%  |
| 1 node , HT off |    2442998     |     2352103     |   -3.7%  |
+-----------------+---------------------------------------------+
|                 |              User Range 200 - 1000          |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1008604     |     5972142     | +492.1%  |
| 4 nodes, HT off |    1317284     |     7190302     | +445.8%  |
| 2 nodes, HT off |    1048363     |     4516400     | +330.8%  |
| 1 node , HT off |    2461802     |     2466583     |   +0.2%  |
+-----------------+---------------------------------------------+
|                 |              User Range 1100 - 2000         |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |     995149     |     6424182     | +545.6%  |
| 4 nodes, HT off |    1313386     |     7012193     | +433.9%  |
| 2 nodes, HT off |    1041411     |     4478519     | +330.0%  |
| 1 node , HT off |    2511186     |     2482650     |   -1.1%  |
+-----------------+----------------+-----------------+----------+

It can be seen that with 20 CPUs (2 nodes) or more, this patch can
significantly improve the short workload performance. With only 1
node, the performance is similar with or without the patch. The short
workload also scales pretty well up to 4 nodes with this patch.

The following table shows the short workload performance difference
of the original 3.10 kernel versus the one with the patch but have
SPINLOCK_REFCOUNT config variable disabled.

+-----------------+----------------+-----------------+----------+
|  Configuration  |    Mean JPM    |    Mean JPM     | % Change |
|                 | Rate w/o patch | Rate with patch |          |
+-----------------+---------------------------------------------+
|                 |              User Range 10 - 100            |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1650355     |     1634232     |   -1.0%  |
| 4 nodes, HT off |    1665137     |     1675791     |   +0.6%  |
| 2 nodes, HT off |    1667552     |     2985552     |  +79.0%  |
| 1 node , HT off |    2442998     |     2396091     |   -1.9%  |
+-----------------+---------------------------------------------+
|                 |              User Range 200 - 1000          |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1008604     |     1005153     |   -0.3%  |
| 4 nodes, HT off |    1317284     |     1330782     |   +1.0%  |
| 2 nodes, HT off |    1048363     |     2056871     |  +96.2%  |
| 1 node , HT off |    2461802     |     2463877     |   +0.1%  |
+-----------------+---------------------------------------------+
|                 |              User Range 1100 - 2000         |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |     995149     |      991157     |   -0.4%  |
| 4 nodes, HT off |    1313386     |     1321806     |   +0.6%  |
| 2 nodes, HT off |    1041411     |     2032808     |  +95.2%  |
| 1 node , HT off |    2511186     |     2483815     |   -1.1%  |
+-----------------+----------------+-----------------+----------+

There are some abnormalities in the original 3.10 2-node data. Ignoring
that, the performance difference for the other node counts, if any,
is insignificant.

A perf call-graph report of the short workload at 1500 users
without the patch on the same 8-node machine indicates that about
78% of the workload's total time were spent in the _raw_spin_lock()
function. Almost all of which can be attributed to the following 2
kernel functions:
 1. dget_parent (49.91%)
 2. dput (49.89%)

The relevant perf report lines are:
+  78.37%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
+   0.09%    reaim  [kernel.kallsyms]     [k] dput
+   0.05%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irq
+   0.00%    reaim  [kernel.kallsyms]     [k] dget_parent

With this patch installed, the new perf report lines are:
+  19.65%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
+   3.94%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
+   2.47%    reaim  [kernel.kallsyms]     [k] lockref_get_not_zero
+   0.62%    reaim  [kernel.kallsyms]     [k] lockref_put_or_locked
+   0.36%    reaim  [kernel.kallsyms]     [k] dput
+   0.31%    reaim  [kernel.kallsyms]     [k] lockref_get
+   0.02%    reaim  [kernel.kallsyms]     [k] dget_parent

-   3.94%    reaim  [kernel.kallsyms]     [k] _raw_spin_lock
   - _raw_spin_lock
      + 32.86% SyS_getcwd
      + 31.99% d_path
      + 4.81% prepend_path
      + 4.14% __rcu_process_callbacks
      + 3.73% complete_walk
      + 2.31% dget_parent
      + 1.99% unlazy_walk
      + 1.44% do_anonymous_page
      + 1.22% lockref_put_or_locked
      + 1.16% sem_lock
      + 0.95% task_rq_lock
      + 0.89% selinux_inode_free_security
      + 0.89% process_backlog
      + 0.79% enqueue_to_backlog
      + 0.72% unix_dgram_sendmsg
      + 0.69% unix_stream_sendmsg

The lockref_put_or_locked used up only 1.22% of the _raw_spin_lock
time while dget_parent used only 2.31%.

This impact of this patch on other AIM7 workloads were much more
modest.  The table below show the mean %change due to this patch on
the same 8-socket system with a 3.10 kernel.

+--------------+---------------+----------------+-----------------+
|   Workload   | mean % change | mean % change  | mean % change   |
|              | 10-100 users  | 200-1000 users | 1100-2000 users |
+--------------+---------------+----------------+-----------------+
| alltests     |     -0.2%     |     +0.5%      |     -0.3%       |
| five_sec     |     +2.5%     |     -4.2%      |     -4.7%       |
| fserver      |     +1.7%     |     +1.6%      |     +0.3%       |
| high_systime |     +0.1%     |     +1.4%      |     +5.5%       |
| new_fserver  |     +0.4%     |     +1.2%      |     +0.3%       |
| shared       |     +0.8%     |     -0.3%      |      0.0%       |
+--------------+---------------+----------------+-----------------+

There are slight drops in performance for the five_sec workload,
but slight increase in the high_systime workload.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c            |  324 +++++++++++++++++++++++++-----------------------
 include/linux/dcache.h |   52 ++++++--
 2 files changed, 207 insertions(+), 169 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f09b908..d3a1693 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -42,6 +42,9 @@
 
 /*
  * Usage:
+ * d_lock  - an alias to the spinlock in d_lockcnt
+ * d_count - an alias to the reference count in d_lockcnt
+ *
  * dcache->d_inode->i_lock protects:
  *   - i_dentry, d_alias, d_inode of aliases
  * dcache_hash_bucket lock protects:
@@ -229,7 +232,7 @@ static void __d_free(struct rcu_head *head)
  */
 static void d_free(struct dentry *dentry)
 {
-	BUG_ON(dentry->d_count);
+	BUG_ON(d_ret_count(dentry));
 	this_cpu_dec(nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
@@ -250,7 +253,7 @@ static void d_free(struct dentry *dentry)
  */
 static inline void dentry_rcuwalk_barrier(struct dentry *dentry)
 {
-	assert_spin_locked(&dentry->d_lock);
+	assert_spin_locked(&d_ret_lock(dentry));
 	/* Go through a barrier */
 	write_seqcount_barrier(&dentry->d_seq);
 }
@@ -261,14 +264,14 @@ static inline void dentry_rcuwalk_barrier(struct dentry *dentry)
  * and is unhashed.
  */
 static void dentry_iput(struct dentry * dentry)
-	__releases(dentry->d_lock)
+	__releases(d_ret_lock(dentry))
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
 		dentry->d_inode = NULL;
 		hlist_del_init(&dentry->d_alias);
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
@@ -277,7 +280,7 @@ static void dentry_iput(struct dentry * dentry)
 		else
 			iput(inode);
 	} else {
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	}
 }
 
@@ -286,14 +289,14 @@ static void dentry_iput(struct dentry * dentry)
  * d_iput() operation if defined. dentry remains in-use.
  */
 static void dentry_unlink_inode(struct dentry * dentry)
-	__releases(dentry->d_lock)
+	__releases(d_ret_lock(dentry))
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	dentry->d_inode = NULL;
 	hlist_del_init(&dentry->d_alias);
 	dentry_rcuwalk_barrier(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	spin_unlock(&inode->i_lock);
 	if (!inode->i_nlink)
 		fsnotify_inoderemove(inode);
@@ -359,12 +362,12 @@ static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
  *
  * If this is the root of the dentry tree, return NULL.
  *
- * dentry->d_lock and parent->d_lock must be held by caller, and are dropped by
- * d_kill.
+ * d_ret_lock(dentry) and d_ret_lock(parent) must be held by caller,
+ * and are dropped by d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
-	__releases(dentry->d_lock)
-	__releases(parent->d_lock)
+	__releases(d_ret_lock(dentry))
+	__releases(d_ret_lock(parent))
 	__releases(dentry->d_inode->i_lock)
 {
 	list_del(&dentry->d_u.d_child);
@@ -374,7 +377,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	 */
 	dentry->d_flags |= DCACHE_DENTRY_KILLED;
 	if (parent)
-		spin_unlock(&parent->d_lock);
+		d_unlock(parent);
 	dentry_iput(dentry);
 	/*
 	 * dentry_iput drops the locks, at which point nobody (except
@@ -386,7 +389,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 
 /*
  * Unhash a dentry without inserting an RCU walk barrier or checking that
- * dentry->d_lock is locked.  The caller must take care of that, if
+ * d_ret_lock(dentry) is locked.  The caller must take care of that, if
  * appropriate.
  */
 static void __d_shrink(struct dentry *dentry)
@@ -418,7 +421,7 @@ static void __d_shrink(struct dentry *dentry)
  * d_drop() is used mainly for stuff that wants to invalidate a dentry for some
  * reason (NFS timeouts or autofs deletes).
  *
- * __d_drop requires dentry->d_lock.
+ * __d_drop requires d_ret_lock(dentry)
  */
 void __d_drop(struct dentry *dentry)
 {
@@ -431,20 +434,20 @@ EXPORT_SYMBOL(__d_drop);
 
 void d_drop(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 EXPORT_SYMBOL(d_drop);
 
 /*
  * Finish off a dentry we've decided to kill.
- * dentry->d_lock must be held, returns with it unlocked.
+ * d_ret_lock(dentry) must be held, returns with it unlocked.
  * If ref is non-zero, then decrement the refcount too.
  * Returns dentry requiring refcount drop, or NULL if we're done.
  */
 static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
-	__releases(dentry->d_lock)
+	__releases(d_ret_lock(dentry))
 {
 	struct inode *inode;
 	struct dentry *parent;
@@ -452,7 +455,7 @@ static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		cpu_relax();
 		return dentry; /* try again with same dentry */
 	}
@@ -460,14 +463,14 @@ relock:
 		parent = NULL;
 	else
 		parent = dentry->d_parent;
-	if (parent && !spin_trylock(&parent->d_lock)) {
+	if (parent && !d_trylock(parent)) {
 		if (inode)
 			spin_unlock(&inode->i_lock);
 		goto relock;
 	}
 
 	if (ref)
-		dentry->d_count--;
+		d_ret_count(dentry)--;
 	/*
 	 * inform the fs via d_prune that this dentry is about to be
 	 * unhashed and destroyed.
@@ -513,13 +516,15 @@ void dput(struct dentry *dentry)
 		return;
 
 repeat:
-	if (dentry->d_count == 1)
+	if (d_ret_count(dentry) == 1)
 		might_sleep();
-	spin_lock(&dentry->d_lock);
-	BUG_ON(!dentry->d_count);
-	if (dentry->d_count > 1) {
-		dentry->d_count--;
-		spin_unlock(&dentry->d_lock);
+	if (lockref_put_or_locked(&dentry->d_lockcnt))
+		return;
+	/* dentry's lock taken */
+	BUG_ON(!d_ret_count(dentry));
+	if (d_ret_count(dentry) > 1) {
+		d_ret_count(dentry)--;
+		d_unlock(dentry);
 		return;
 	}
 
@@ -535,8 +540,8 @@ repeat:
 	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
 
-	dentry->d_count--;
-	spin_unlock(&dentry->d_lock);
+	d_ret_count(dentry)--;
+	d_unlock(dentry);
 	return;
 
 kill_it:
@@ -563,9 +568,9 @@ int d_invalidate(struct dentry * dentry)
 	/*
 	 * If it's already been dropped, return OK.
 	 */
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (d_unhashed(dentry)) {
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		return 0;
 	}
 	/*
@@ -573,9 +578,9 @@ int d_invalidate(struct dentry * dentry)
 	 * to get rid of unused child entries.
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		shrink_dcache_parent(dentry);
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 	}
 
 	/*
@@ -590,15 +595,15 @@ int d_invalidate(struct dentry * dentry)
 	 * We also need to leave mountpoints alone,
 	 * directory or not.
 	 */
-	if (dentry->d_count > 1 && dentry->d_inode) {
+	if (d_ret_count(dentry) > 1 && dentry->d_inode) {
 		if (S_ISDIR(dentry->d_inode->i_mode) || d_mountpoint(dentry)) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			return -EBUSY;
 		}
 	}
 
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return 0;
 }
 EXPORT_SYMBOL(d_invalidate);
@@ -606,37 +611,41 @@ EXPORT_SYMBOL(d_invalidate);
 /* This must be called with d_lock held */
 static inline void __dget_dlock(struct dentry *dentry)
 {
-	dentry->d_count++;
+	d_ret_count(dentry)++;
 }
 
 static inline void __dget(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
-	__dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
+	lockref_get(&dentry->d_lockcnt);
 }
 
 struct dentry *dget_parent(struct dentry *dentry)
 {
 	struct dentry *ret;
 
+	rcu_read_lock();
+	ret = rcu_dereference(dentry->d_parent);
+	if (lockref_get_not_zero(&ret->d_lockcnt)) {
+		rcu_read_unlock();
+		return ret;
+	}
 repeat:
 	/*
 	 * Don't need rcu_dereference because we re-check it was correct under
 	 * the lock.
 	 */
-	rcu_read_lock();
-	ret = dentry->d_parent;
-	spin_lock(&ret->d_lock);
+	ret = ACCESS_ONCE(dentry->d_parent);
+	d_lock(ret);
 	if (unlikely(ret != dentry->d_parent)) {
-		spin_unlock(&ret->d_lock);
+		d_unlock(ret);
 		rcu_read_unlock();
+		rcu_read_lock();
 		goto repeat;
 	}
 	rcu_read_unlock();
-	BUG_ON(!ret->d_count);
-	ret->d_count++;
-	spin_unlock(&ret->d_lock);
+	BUG_ON(!d_ret_count(ret));
+	d_ret_count(ret)++;
+	d_unlock(ret);
 	return ret;
 }
 EXPORT_SYMBOL(dget_parent);
@@ -664,31 +673,31 @@ static struct dentry *__d_find_alias(struct inode *inode, int want_discon)
 again:
 	discon_alias = NULL;
 	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
-		spin_lock(&alias->d_lock);
+		d_lock(alias);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				discon_alias = alias;
 			} else if (!want_discon) {
 				__dget_dlock(alias);
-				spin_unlock(&alias->d_lock);
+				d_unlock(alias);
 				return alias;
 			}
 		}
-		spin_unlock(&alias->d_lock);
+		d_unlock(alias);
 	}
 	if (discon_alias) {
 		alias = discon_alias;
-		spin_lock(&alias->d_lock);
+		d_lock(alias);
 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				__dget_dlock(alias);
-				spin_unlock(&alias->d_lock);
+				d_unlock(alias);
 				return alias;
 			}
 		}
-		spin_unlock(&alias->d_lock);
+		d_unlock(alias);
 		goto again;
 	}
 	return NULL;
@@ -717,16 +726,16 @@ void d_prune_aliases(struct inode *inode)
 restart:
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		spin_lock(&dentry->d_lock);
-		if (!dentry->d_count) {
+		d_lock(dentry);
+		if (!d_ret_count(dentry)) {
 			__dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			spin_unlock(&inode->i_lock);
 			dput(dentry);
 			goto restart;
 		}
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	}
 	spin_unlock(&inode->i_lock);
 }
@@ -734,13 +743,13 @@ EXPORT_SYMBOL(d_prune_aliases);
 
 /*
  * Try to throw away a dentry - free the inode, dput the parent.
- * Requires dentry->d_lock is held, and dentry->d_count == 0.
- * Releases dentry->d_lock.
+ * Requires d_ret_lock(dentry) is held, and dentry->d_count == 0.
+ * Releases d_ret_lock(dentry)
  *
  * This may fail if locks cannot be acquired no problem, just try again.
  */
 static void try_prune_one_dentry(struct dentry *dentry)
-	__releases(dentry->d_lock)
+	__releases(d_ret_lock(dentry))
 {
 	struct dentry *parent;
 
@@ -763,10 +772,10 @@ static void try_prune_one_dentry(struct dentry *dentry)
 	/* Prune ancestors. */
 	dentry = parent;
 	while (dentry) {
-		spin_lock(&dentry->d_lock);
-		if (dentry->d_count > 1) {
-			dentry->d_count--;
-			spin_unlock(&dentry->d_lock);
+		d_lock(dentry);
+		if (d_ret_count(dentry) > 1) {
+			d_ret_count(dentry)--;
+			d_unlock(dentry);
 			return;
 		}
 		dentry = dentry_kill(dentry, 1);
@@ -782,9 +791,9 @@ static void shrink_dentry_list(struct list_head *list)
 		dentry = list_entry_rcu(list->prev, struct dentry, d_lru);
 		if (&dentry->d_lru == list)
 			break; /* empty */
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		if (dentry != list_entry(list->prev, struct dentry, d_lru)) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			continue;
 		}
 
@@ -793,9 +802,9 @@ static void shrink_dentry_list(struct list_head *list)
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
-		if (dentry->d_count) {
+		if (d_ret_count(dentry)) {
 			dentry_lru_del(dentry);
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			continue;
 		}
 
@@ -833,7 +842,7 @@ relock:
 				struct dentry, d_lru);
 		BUG_ON(dentry->d_sb != sb);
 
-		if (!spin_trylock(&dentry->d_lock)) {
+		if (!d_trylock(dentry)) {
 			spin_unlock(&dcache_lru_lock);
 			cpu_relax();
 			goto relock;
@@ -842,11 +851,11 @@ relock:
 		if (dentry->d_flags & DCACHE_REFERENCED) {
 			dentry->d_flags &= ~DCACHE_REFERENCED;
 			list_move(&dentry->d_lru, &referenced);
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
 			dentry->d_flags |= DCACHE_SHRINK_LIST;
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			if (!--count)
 				break;
 		}
@@ -913,7 +922,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 			dentry_lru_del(dentry);
 			__d_shrink(dentry);
 
-			if (dentry->d_count != 0) {
+			if (d_ret_count(dentry) != 0) {
 				printk(KERN_ERR
 				       "BUG: Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
@@ -922,7 +931,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				       dentry->d_inode ?
 				       dentry->d_inode->i_ino : 0UL,
 				       dentry->d_name.name,
-				       dentry->d_count,
+				       d_ret_count(dentry),
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
 				BUG();
@@ -933,7 +942,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				list_del(&dentry->d_u.d_child);
 			} else {
 				parent = dentry->d_parent;
-				parent->d_count--;
+				d_ret_count(parent)--;
 				list_del(&dentry->d_u.d_child);
 			}
 
@@ -964,7 +973,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 
 /*
  * destroy the dentries attached to a superblock on unmounting
- * - we don't need to use dentry->d_lock because:
+ * - we don't need to use d_ret_lock(dentry) because:
  *   - the superblock is detached from all mountings and open files, so the
  *     dentry trees will not be rearranged by the VFS
  *   - s_umount is write-locked, so the memory pressure shrinker will ignore
@@ -981,7 +990,7 @@ void shrink_dcache_for_umount(struct super_block *sb)
 
 	dentry = sb->s_root;
 	sb->s_root = NULL;
-	dentry->d_count--;
+	d_ret_count(dentry)--;
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_bl_empty(&sb->s_anon)) {
@@ -1001,8 +1010,8 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
 	struct dentry *new = old->d_parent;
 
 	rcu_read_lock();
-	spin_unlock(&old->d_lock);
-	spin_lock(&new->d_lock);
+	d_unlock(old);
+	d_lock(new);
 
 	/*
 	 * might go back up the wrong parent if we have had a rename
@@ -1011,7 +1020,7 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
 	if (new != old->d_parent ||
 		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
-		spin_unlock(&new->d_lock);
+		d_unlock(new);
 		new = NULL;
 	}
 	rcu_read_unlock();
@@ -1045,7 +1054,7 @@ again:
 
 	if (d_mountpoint(parent))
 		goto positive;
-	spin_lock(&this_parent->d_lock);
+	d_lock(this_parent);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -1054,21 +1063,22 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		d_lock_nested(dentry, DENTRY_D_LOCK_NESTED);
 		/* Have we found a mount point ? */
 		if (d_mountpoint(dentry)) {
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&this_parent->d_lock);
+			d_unlock(dentry);
+			d_unlock(this_parent);
 			goto positive;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			d_unlock(this_parent);
+			spin_release(&d_ret_lock(dentry).dep_map, 1, _RET_IP_);
 			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&d_ret_lock(this_parent).dep_map,
+				     0, 1, _RET_IP_);
 			goto repeat;
 		}
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
@@ -1081,7 +1091,7 @@ resume:
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
+	d_unlock(this_parent);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
@@ -1128,7 +1138,7 @@ static int select_parent(struct dentry *parent, struct list_head *dispose)
 	seq = read_seqbegin(&rename_lock);
 again:
 	this_parent = parent;
-	spin_lock(&this_parent->d_lock);
+	d_lock(this_parent);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -1137,7 +1147,7 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		d_lock_nested(dentry, DENTRY_D_LOCK_NESTED);
 
 		/*
 		 * move only zero ref count dentries to the dispose list.
@@ -1147,7 +1157,7 @@ resume:
 		 * loop in shrink_dcache_parent() might not make any progress
 		 * and loop forever.
 		 */
-		if (dentry->d_count) {
+		if (d_ret_count(dentry)) {
 			dentry_lru_del(dentry);
 		} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
 			dentry_lru_move_list(dentry, dispose);
@@ -1160,7 +1170,7 @@ resume:
 		 * the rest.
 		 */
 		if (found && need_resched()) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			goto out;
 		}
 
@@ -1168,14 +1178,15 @@ resume:
 		 * Descend a level if the d_subdirs list is non-empty.
 		 */
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			d_unlock(this_parent);
+			spin_release(&d_ret_lock(dentry).dep_map, 1, _RET_IP_);
 			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&d_ret_lock(this_parent).dep_map,
+				     0, 1, _RET_IP_);
 			goto repeat;
 		}
 
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
@@ -1189,7 +1200,7 @@ resume:
 		goto resume;
 	}
 out:
-	spin_unlock(&this_parent->d_lock);
+	d_unlock(this_parent);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
@@ -1269,9 +1280,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	smp_wmb();
 	dentry->d_name.name = dname;
 
-	dentry->d_count = 1;
+	d_ret_count(dentry) = 1;
 	dentry->d_flags = 0;
-	spin_lock_init(&dentry->d_lock);
+	spin_lock_init(&d_ret_lock(dentry));
 	seqcount_init(&dentry->d_seq);
 	dentry->d_inode = NULL;
 	dentry->d_parent = dentry;
@@ -1305,7 +1316,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	if (!dentry)
 		return NULL;
 
-	spin_lock(&parent->d_lock);
+	d_lock(parent);
 	/*
 	 * don't need child lock because it is not subject
 	 * to concurrency here
@@ -1313,7 +1324,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	__dget_dlock(parent);
 	dentry->d_parent = parent;
 	list_add(&dentry->d_u.d_child, &parent->d_subdirs);
-	spin_unlock(&parent->d_lock);
+	d_unlock(parent);
 
 	return dentry;
 }
@@ -1368,7 +1379,7 @@ EXPORT_SYMBOL(d_set_d_op);
 
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (inode) {
 		if (unlikely(IS_AUTOMOUNT(inode)))
 			dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
@@ -1376,7 +1387,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	}
 	dentry->d_inode = inode;
 	dentry_rcuwalk_barrier(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	fsnotify_d_instantiate(dentry, inode);
 }
 
@@ -1438,7 +1449,7 @@ static struct dentry *__d_instantiate_unique(struct dentry *entry,
 
 	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		/*
-		 * Don't need alias->d_lock here, because aliases with
+		 * Don't need d_ret_lock(alias) here, because aliases with
 		 * d_parent == entry->d_parent are not subject to name or
 		 * parent changes, because the parent inode i_mutex is held.
 		 */
@@ -1576,14 +1587,14 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	}
 
 	/* attach a disconnected dentry */
-	spin_lock(&tmp->d_lock);
+	d_lock(tmp);
 	tmp->d_inode = inode;
 	tmp->d_flags |= DCACHE_DISCONNECTED;
 	hlist_add_head(&tmp->d_alias, &inode->i_dentry);
 	hlist_bl_lock(&tmp->d_sb->s_anon);
 	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
 	hlist_bl_unlock(&tmp->d_sb->s_anon);
-	spin_unlock(&tmp->d_lock);
+	d_unlock(tmp);
 	spin_unlock(&inode->i_lock);
 	security_d_instantiate(tmp, inode);
 
@@ -1946,7 +1957,7 @@ struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
 		if (dentry->d_name.hash != hash)
 			continue;
 
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		if (dentry->d_parent != parent)
 			goto next;
 		if (d_unhashed(dentry))
@@ -1970,12 +1981,12 @@ struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
 				goto next;
 		}
 
-		dentry->d_count++;
+		d_ret_count(dentry)++;
 		found = dentry;
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		break;
 next:
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
  	}
  	rcu_read_unlock();
 
@@ -2021,17 +2032,17 @@ int d_validate(struct dentry *dentry, struct dentry *dparent)
 {
 	struct dentry *child;
 
-	spin_lock(&dparent->d_lock);
+	d_lock(dparent);
 	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
 		if (dentry == child) {
-			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+			d_lock_nested(dentry, DENTRY_D_LOCK_NESTED);
 			__dget_dlock(dentry);
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dparent->d_lock);
+			d_unlock(dentry);
+			d_unlock(dparent);
 			return 1;
 		}
 	}
-	spin_unlock(&dparent->d_lock);
+	d_unlock(dparent);
 
 	return 0;
 }
@@ -2066,12 +2077,12 @@ void d_delete(struct dentry * dentry)
 	 * Are we the only user?
 	 */
 again:
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	inode = dentry->d_inode;
 	isdir = S_ISDIR(inode->i_mode);
-	if (dentry->d_count == 1) {
+	if (d_ret_count(dentry) == 1) {
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			cpu_relax();
 			goto again;
 		}
@@ -2084,7 +2095,7 @@ again:
 	if (!d_unhashed(dentry))
 		__d_drop(dentry);
 
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -2113,9 +2124,9 @@ static void _d_rehash(struct dentry * entry)
  
 void d_rehash(struct dentry * entry)
 {
-	spin_lock(&entry->d_lock);
+	d_lock(entry);
 	_d_rehash(entry);
-	spin_unlock(&entry->d_lock);
+	d_unlock(entry);
 }
 EXPORT_SYMBOL(d_rehash);
 
@@ -2138,11 +2149,11 @@ void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
 	BUG_ON(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex));
 	BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives this */
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	write_seqcount_begin(&dentry->d_seq);
 	memcpy((unsigned char *)dentry->d_name.name, name->name, name->len);
 	write_seqcount_end(&dentry->d_seq);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 EXPORT_SYMBOL(dentry_update_name_case);
 
@@ -2190,27 +2201,27 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
 static void dentry_lock_for_move(struct dentry *dentry, struct dentry *target)
 {
 	/*
-	 * XXXX: do we really need to take target->d_lock?
+	 * XXXX: do we really need to take d_ret_lock(target)?
 	 */
 	if (IS_ROOT(dentry) || dentry->d_parent == target->d_parent)
-		spin_lock(&target->d_parent->d_lock);
+		d_lock(target->d_parent);
 	else {
 		if (d_ancestor(dentry->d_parent, target->d_parent)) {
-			spin_lock(&dentry->d_parent->d_lock);
-			spin_lock_nested(&target->d_parent->d_lock,
+			d_lock(dentry->d_parent);
+			d_lock_nested(target->d_parent,
 						DENTRY_D_LOCK_NESTED);
 		} else {
-			spin_lock(&target->d_parent->d_lock);
-			spin_lock_nested(&dentry->d_parent->d_lock,
+			d_lock(target->d_parent);
+			d_lock_nested(dentry->d_parent,
 						DENTRY_D_LOCK_NESTED);
 		}
 	}
 	if (target < dentry) {
-		spin_lock_nested(&target->d_lock, 2);
-		spin_lock_nested(&dentry->d_lock, 3);
+		d_lock_nested(target, 2);
+		d_lock_nested(dentry, 3);
 	} else {
-		spin_lock_nested(&dentry->d_lock, 2);
-		spin_lock_nested(&target->d_lock, 3);
+		d_lock_nested(dentry, 2);
+		d_lock_nested(target, 3);
 	}
 }
 
@@ -2218,9 +2229,9 @@ static void dentry_unlock_parents_for_move(struct dentry *dentry,
 					struct dentry *target)
 {
 	if (target->d_parent != dentry->d_parent)
-		spin_unlock(&dentry->d_parent->d_lock);
+		d_unlock(dentry->d_parent);
 	if (target->d_parent != target)
-		spin_unlock(&target->d_parent->d_lock);
+		d_unlock(target->d_parent);
 }
 
 /*
@@ -2294,9 +2305,9 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
 	write_seqcount_end(&dentry->d_seq);
 
 	dentry_unlock_parents_for_move(dentry, target);
-	spin_unlock(&target->d_lock);
+	d_unlock(target);
 	fsnotify_d_move(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 /*
@@ -2378,7 +2389,7 @@ out_err:
 /*
  * Prepare an anonymous dentry for life in the superblock's dentry tree as a
  * named dentry in place of the dentry to be replaced.
- * returns with anon->d_lock held!
+ * returns with d_ret_lock(anon) held!
  */
 static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 {
@@ -2403,9 +2414,9 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	write_seqcount_end(&anon->d_seq);
 
 	dentry_unlock_parents_for_move(anon, dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 
-	/* anon->d_lock still locked, returns locked */
+	/* d_ret_lock(anon) still locked, returns locked */
 	anon->d_flags &= ~DCACHE_DISCONNECTED;
 }
 
@@ -2480,10 +2491,10 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 	else
 		BUG_ON(!d_unhashed(actual));
 
-	spin_lock(&actual->d_lock);
+	d_lock(actual);
 found:
 	_d_rehash(actual);
-	spin_unlock(&actual->d_lock);
+	d_unlock(actual);
 	spin_unlock(&inode->i_lock);
 out_nolock:
 	if (actual == dentry) {
@@ -2544,9 +2555,9 @@ static int prepend_path(const struct path *path,
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		error = prepend_name(buffer, buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		if (!error)
 			error = prepend(buffer, buflen, "/", 1);
 		if (error)
@@ -2744,9 +2755,9 @@ static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 		int error;
 
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		error = prepend_name(&end, &buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 		if (error != 0 || prepend(&end, &buflen, "/", 1) != 0)
 			goto Elong;
 
@@ -2914,7 +2925,7 @@ void d_genocide(struct dentry *root)
 	seq = read_seqbegin(&rename_lock);
 again:
 	this_parent = root;
-	spin_lock(&this_parent->d_lock);
+	d_lock(this_parent);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -2923,29 +2934,30 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		d_lock_nested(dentry, DENTRY_D_LOCK_NESTED);
 		if (d_unhashed(dentry) || !dentry->d_inode) {
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			continue;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			d_unlock(this_parent);
+			spin_release(&d_ret_lock(dentry).dep_map, 1, _RET_IP_);
 			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&d_ret_lock(this_parent).dep_map,
+				     0, 1, _RET_IP_);
 			goto repeat;
 		}
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
 			dentry->d_flags |= DCACHE_GENOCIDE;
-			dentry->d_count--;
+			d_ret_count(dentry)--;
 		}
-		spin_unlock(&dentry->d_lock);
+		d_unlock(dentry);
 	}
 	if (this_parent != root) {
 		struct dentry *child = this_parent;
 		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
 			this_parent->d_flags |= DCACHE_GENOCIDE;
-			this_parent->d_count--;
+			d_ret_count(this_parent)--;
 		}
 		this_parent = try_to_ascend(this_parent, locked, seq);
 		if (!this_parent)
@@ -2953,7 +2965,7 @@ resume:
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
+	d_unlock(this_parent);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1a6bb81..52af188 100644
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
@@ -132,7 +132,7 @@ struct dentry {
 };
 
 /*
- * dentry->d_lock spinlock nesting subclasses:
+ * d_ret_lock(dentry) spinlock nesting subclasses:
  *
  * 0: normal
  * 1: nested
@@ -303,6 +303,10 @@ extern struct dentry *__d_lookup_rcu(const struct dentry *parent,
 				const struct qstr *name,
 				unsigned *seq, struct inode *inode);
 
+/* Return the embedded spinlock and reference count */
+#define	d_ret_lock(dentry)	lockref_ret_lock(&(dentry)->d_lockcnt)
+#define	d_ret_count(dentry)	lockref_ret_count(&(dentry)->d_lockcnt)
+
 /**
  * __d_rcu_to_refcount - take a refcount on dentry if sequence check is ok
  * @dentry: dentry to take a ref on
@@ -316,10 +320,10 @@ static inline int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq)
 {
 	int ret = 0;
 
-	assert_spin_locked(&dentry->d_lock);
+	assert_spin_locked(&d_ret_lock(dentry));
 	if (!read_seqcount_retry(&dentry->d_seq, seq)) {
 		ret = 1;
-		dentry->d_count++;
+		d_ret_count(dentry)++;
 	}
 
 	return ret;
@@ -342,6 +346,31 @@ extern char *dentry_path(struct dentry *, char *, int);
 /* Allocation counts.. */
 
 /**
+ *	d_lock, d_lock_nested, d_trylock, d_unlock
+ *		- lock and unlock the embedding spinlock
+ *	@dentry: dentry to be locked or unlocked
+ */
+static inline void d_lock(struct dentry *dentry)
+{
+	lockref_lock(&dentry->d_lockcnt);
+}
+
+static inline void d_lock_nested(struct dentry *dentry, int subclass)
+{
+	lockref_lock_nested(&dentry->d_lockcnt, subclass);
+}
+
+static inline int d_trylock(struct dentry *dentry)
+{
+	return lockref_trylock(&dentry->d_lockcnt);
+}
+
+static inline void d_unlock(struct dentry *dentry)
+{
+	lockref_unlock(&dentry->d_lockcnt);
+}
+
+/**
  *	dget, dget_dlock -	get a reference to a dentry
  *	@dentry: dentry to get a reference to
  *
@@ -352,17 +381,14 @@ extern char *dentry_path(struct dentry *, char *, int);
 static inline struct dentry *dget_dlock(struct dentry *dentry)
 {
 	if (dentry)
-		dentry->d_count++;
+		d_ret_count(dentry)++;
 	return dentry;
 }
 
 static inline struct dentry *dget(struct dentry *dentry)
 {
-	if (dentry) {
-		spin_lock(&dentry->d_lock);
-		dget_dlock(dentry);
-		spin_unlock(&dentry->d_lock);
-	}
+	if (dentry)
+		lockref_get(&dentry->d_lockcnt);
 	return dentry;
 }
 
@@ -392,9 +418,9 @@ static inline int cant_mount(struct dentry *dentry)
 
 static inline void dont_mount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	dentry->d_flags |= DCACHE_CANT_MOUNT;
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 extern void dput(struct dentry *);
-- 
1.7.1

