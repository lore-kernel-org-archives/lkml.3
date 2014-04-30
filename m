Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaD3Cbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:31:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47249 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaD3Cbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:31:47 -0400
Date: Wed, 30 Apr 2014 03:31:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430023142.GN18016@ZenIV.linux.org.uk>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
 <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2NLGdgz3UMHa/lqP"
Content-Disposition: inline
In-Reply-To: <20140429232013.GM18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 12:20:13AM +0100, Al Viro wrote:
> On Tue, Apr 29, 2014 at 04:04:11PM -0700, Linus Torvalds wrote:
> > But at a minimum, we have "d_op->d_prune()" that would now be possibly
> > be called for the old dentry *after* a new dentry has been allocated.
> > Not to mention the inode not having been dropped. So it looks like a
> > disaster where the filesystem now ends up having concurrent "live"
> > dentries for the same entry.  Even if one of them is on its way out,
> > it's still visible to the filesystem. That makes me very
> > uncomfortable.
> > 
> > I'm starting to think that Miklos' original patch (perhaps with the
> > spinlock split to at least be one per superblock) is the most
> > straightforward approach after all. It's annoying having to add locks
> > here, but the whole pruning path should not be a hotpath, so maybe
> > it's not actually a big deal.
> 
> FWIW, my solution is more or less working; I'll give more local beating
> and post it... 

OK, aggregate diff follows, more readable splitup (3 commits) attached.
It seems to survive beating here; testing, review and comments are
welcome.

diff --git a/fs/dcache.c b/fs/dcache.c
index 494a9def..a83b933 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -246,16 +246,8 @@ static void __d_free(struct rcu_head *head)
 	kmem_cache_free(dentry_cache, dentry); 
 }
 
-/*
- * no locks, please.
- */
-static void d_free(struct dentry *dentry)
+static void dentry_free(struct dentry *dentry)
 {
-	BUG_ON((int)dentry->d_lockref.count > 0);
-	this_cpu_dec(nr_dentry);
-	if (dentry->d_op && dentry->d_op->d_release)
-		dentry->d_op->d_release(dentry);
-
 	/* if dentry was never visible to RCU, immediate free is OK */
 	if (!(dentry->d_flags & DCACHE_RCUACCESS))
 		__d_free(&dentry->d_u.d_rcu);
@@ -420,40 +412,6 @@ static void dentry_lru_del(struct dentry *dentry)
 }
 
 /**
- * d_kill - kill dentry and return parent
- * @dentry: dentry to kill
- * @parent: parent dentry
- *
- * The dentry must already be unhashed and removed from the LRU.
- *
- * If this is the root of the dentry tree, return NULL.
- *
- * dentry->d_lock and parent->d_lock must be held by caller, and are dropped by
- * d_kill.
- */
-static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
-	__releases(dentry->d_lock)
-	__releases(parent->d_lock)
-	__releases(dentry->d_inode->i_lock)
-{
-	list_del(&dentry->d_u.d_child);
-	/*
-	 * Inform d_walk() that we are no longer attached to the
-	 * dentry tree
-	 */
-	dentry->d_flags |= DCACHE_DENTRY_KILLED;
-	if (parent)
-		spin_unlock(&parent->d_lock);
-	dentry_iput(dentry);
-	/*
-	 * dentry_iput drops the locks, at which point nobody (except
-	 * transient RCU lookups) can reach this dentry.
-	 */
-	d_free(dentry);
-	return parent;
-}
-
-/**
  * d_drop - drop a dentry
  * @dentry: dentry to drop
  *
@@ -499,6 +457,8 @@ void d_drop(struct dentry *dentry)
 }
 EXPORT_SYMBOL(d_drop);
 
+static DECLARE_WAIT_QUEUE_HEAD(free_wq);
+
 /*
  * Finish off a dentry we've decided to kill.
  * dentry->d_lock must be held, returns with it unlocked.
@@ -506,16 +466,17 @@ EXPORT_SYMBOL(d_drop);
  * Returns dentry requiring refcount drop, or NULL if we're done.
  */
 static struct dentry *
-dentry_kill(struct dentry *dentry, int unlock_on_failure)
+dentry_kill(struct dentry *dentry, struct list_head *morgue)
 	__releases(dentry->d_lock)
 {
 	struct inode *inode;
 	struct dentry *parent;
+	bool can_free = true;
 
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		if (unlock_on_failure) {
+		if (!morgue) {
 			spin_unlock(&dentry->d_lock);
 			cpu_relax();
 		}
@@ -531,6 +492,15 @@ relock:
 		goto relock;
 	}
 
+	if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+		/* morgue must be non-NULL */
+		list_move(&dentry->d_lru, morgue);
+		if (parent)
+			spin_unlock(&parent->d_lock);
+		/* inode must be NULL */
+		spin_unlock(&dentry->d_lock);
+		return parent;
+	}
 	/*
 	 * The dentry is now unrecoverably dead to the world.
 	 */
@@ -543,10 +513,43 @@ relock:
 	if ((dentry->d_flags & DCACHE_OP_PRUNE) && !d_unhashed(dentry))
 		dentry->d_op->d_prune(dentry);
 
-	dentry_lru_del(dentry);
+	if (dentry->d_flags & DCACHE_LRU_LIST) {
+		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
+			d_lru_del(dentry);
+		else if (morgue)
+			d_shrink_del(dentry);
+		else
+			can_free = false;
+	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
-	return d_kill(dentry, parent);
+	list_del(&dentry->d_u.d_child);
+	/*
+	 * Inform d_walk() that we are no longer attached to the
+	 * dentry tree
+	 */
+	dentry->d_flags |= DCACHE_DENTRY_KILLED;
+	if (parent)
+		spin_unlock(&parent->d_lock);
+	dentry_iput(dentry);
+	/*
+	 * dentry_iput drops the locks, at which point nobody (except
+	 * transient RCU lookups) can reach this dentry.
+	 */
+	BUG_ON((int)dentry->d_lockref.count > 0);
+	this_cpu_dec(nr_dentry);
+	if (dentry->d_op && dentry->d_op->d_release)
+		dentry->d_op->d_release(dentry);
+
+	if (likely(can_free)) {
+		dentry_free(dentry);
+	} else {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_MAY_FREE;
+		spin_unlock(&dentry->d_lock);
+		wake_up(&free_wq);
+	}
+	return parent;
 }
 
 /* 
@@ -602,7 +605,7 @@ repeat:
 	return;
 
 kill_it:
-	dentry = dentry_kill(dentry, 1);
+	dentry = dentry_kill(dentry, NULL);
 	if (dentry)
 		goto repeat;
 }
@@ -815,47 +818,10 @@ restart:
 }
 EXPORT_SYMBOL(d_prune_aliases);
 
-/*
- * Try to throw away a dentry - free the inode, dput the parent.
- * Requires dentry->d_lock is held, and dentry->d_count == 0.
- * Releases dentry->d_lock.
- *
- * This may fail if locks cannot be acquired no problem, just try again.
- */
-static struct dentry * try_prune_one_dentry(struct dentry *dentry)
-	__releases(dentry->d_lock)
-{
-	struct dentry *parent;
-
-	parent = dentry_kill(dentry, 0);
-	/*
-	 * If dentry_kill returns NULL, we have nothing more to do.
-	 * if it returns the same dentry, trylocks failed. In either
-	 * case, just loop again.
-	 *
-	 * Otherwise, we need to prune ancestors too. This is necessary
-	 * to prevent quadratic behavior of shrink_dcache_parent(), but
-	 * is also expected to be beneficial in reducing dentry cache
-	 * fragmentation.
-	 */
-	if (!parent)
-		return NULL;
-	if (parent == dentry)
-		return dentry;
-
-	/* Prune ancestors. */
-	dentry = parent;
-	while (dentry) {
-		if (lockref_put_or_lock(&dentry->d_lockref))
-			return NULL;
-		dentry = dentry_kill(dentry, 1);
-	}
-	return NULL;
-}
-
 static void shrink_dentry_list(struct list_head *list)
 {
-	struct dentry *dentry;
+	struct dentry *dentry, *parent;
+	LIST_HEAD(morgue);
 
 	rcu_read_lock();
 	for (;;) {
@@ -891,24 +857,43 @@ static void shrink_dentry_list(struct list_head *list)
 		}
 		rcu_read_unlock();
 
+		parent = dentry_kill(dentry, &morgue);
 		/*
-		 * If 'try_to_prune()' returns a dentry, it will
-		 * be the same one we passed in, and d_lock will
-		 * have been held the whole time, so it will not
-		 * have been added to any other lists. We failed
-		 * to get the inode lock.
-		 *
-		 * We just add it back to the shrink list.
+		 * If dentry_kill returns NULL, we have nothing more to do.
 		 */
-		dentry = try_prune_one_dentry(dentry);
-
-		rcu_read_lock();
-		if (dentry) {
+		if (!parent) {
+			rcu_read_lock();
+			continue;
+		}
+		if (unlikely(parent == dentry)) {
+			/*
+			 * trylocks have failed and d_lock has been held the
+			 * whole time, so it could not have been added to any
+			 * other lists. Just add it back to the shrink list.
+			 */
+			rcu_read_lock();
 			d_shrink_add(dentry, list);
 			spin_unlock(&dentry->d_lock);
+			continue;
 		}
+		/*
+		 * We need to prune ancestors too. This is necessary to prevent
+		 * quadratic behavior of shrink_dcache_parent(), but is also
+		 * expected to be beneficial in reducing dentry cache
+		 * fragmentation.
+		 */
+		dentry = parent;
+		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
+			dentry = dentry_kill(dentry, NULL);
+		rcu_read_lock();
 	}
 	rcu_read_unlock();
+	while (unlikely(!list_empty(&morgue))) {
+		dentry = list_first_entry(&morgue, struct dentry, d_lru);
+		list_del_init(&dentry->d_lru);
+		wait_event(free_wq, dentry->d_flags & DCACHE_MAY_FREE);
+		dentry_free(dentry);
+	}
 }
 
 static enum lru_status
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 3b9bfdb..3c7ec32 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -221,6 +221,8 @@ struct dentry_operations {
 #define DCACHE_SYMLINK_TYPE		0x00300000 /* Symlink */
 #define DCACHE_FILE_TYPE		0x00400000 /* Other file type */
 
+#define DCACHE_MAY_FREE			0x00800000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(const struct dentry *dentry)

--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=mb2

>From 895aeb48465bbf78803fd11dee2556d010ada23a Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 15:45:28 -0400
Subject: [PATCH 1/3] fold d_kill() and d_free()
Status: O
Content-Length: 2893
Lines: 109

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |   76 +++++++++++++++++++----------------------------------------
 1 file changed, 24 insertions(+), 52 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 494a9def..9b15c5c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -246,23 +246,6 @@ static void __d_free(struct rcu_head *head)
 	kmem_cache_free(dentry_cache, dentry); 
 }
 
-/*
- * no locks, please.
- */
-static void d_free(struct dentry *dentry)
-{
-	BUG_ON((int)dentry->d_lockref.count > 0);
-	this_cpu_dec(nr_dentry);
-	if (dentry->d_op && dentry->d_op->d_release)
-		dentry->d_op->d_release(dentry);
-
-	/* if dentry was never visible to RCU, immediate free is OK */
-	if (!(dentry->d_flags & DCACHE_RCUACCESS))
-		__d_free(&dentry->d_u.d_rcu);
-	else
-		call_rcu(&dentry->d_u.d_rcu, __d_free);
-}
-
 /**
  * dentry_rcuwalk_barrier - invalidate in-progress rcu-walk lookups
  * @dentry: the target dentry
@@ -420,40 +403,6 @@ static void dentry_lru_del(struct dentry *dentry)
 }
 
 /**
- * d_kill - kill dentry and return parent
- * @dentry: dentry to kill
- * @parent: parent dentry
- *
- * The dentry must already be unhashed and removed from the LRU.
- *
- * If this is the root of the dentry tree, return NULL.
- *
- * dentry->d_lock and parent->d_lock must be held by caller, and are dropped by
- * d_kill.
- */
-static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
-	__releases(dentry->d_lock)
-	__releases(parent->d_lock)
-	__releases(dentry->d_inode->i_lock)
-{
-	list_del(&dentry->d_u.d_child);
-	/*
-	 * Inform d_walk() that we are no longer attached to the
-	 * dentry tree
-	 */
-	dentry->d_flags |= DCACHE_DENTRY_KILLED;
-	if (parent)
-		spin_unlock(&parent->d_lock);
-	dentry_iput(dentry);
-	/*
-	 * dentry_iput drops the locks, at which point nobody (except
-	 * transient RCU lookups) can reach this dentry.
-	 */
-	d_free(dentry);
-	return parent;
-}
-
-/**
  * d_drop - drop a dentry
  * @dentry: dentry to drop
  *
@@ -546,7 +495,30 @@ relock:
 	dentry_lru_del(dentry);
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
-	return d_kill(dentry, parent);
+	list_del(&dentry->d_u.d_child);
+	/*
+	 * Inform d_walk() that we are no longer attached to the
+	 * dentry tree
+	 */
+	dentry->d_flags |= DCACHE_DENTRY_KILLED;
+	if (parent)
+		spin_unlock(&parent->d_lock);
+	dentry_iput(dentry);
+	/*
+	 * dentry_iput drops the locks, at which point nobody (except
+	 * transient RCU lookups) can reach this dentry.
+	 */
+	BUG_ON((int)dentry->d_lockref.count > 0);
+	this_cpu_dec(nr_dentry);
+	if (dentry->d_op && dentry->d_op->d_release)
+		dentry->d_op->d_release(dentry);
+
+	/* if dentry was never visible to RCU, immediate free is OK */
+	if (!(dentry->d_flags & DCACHE_RCUACCESS))
+		__d_free(&dentry->d_u.d_rcu);
+	else
+		call_rcu(&dentry->d_u.d_rcu, __d_free);
+	return parent;
 }
 
 /* 
-- 
1.7.10.4


>From aff934c47717be0216c9e2c10a2e8ca0f829bb54 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 16:13:18 -0400
Subject: [PATCH 2/3] fold try_prune_one_dentry()
Status: O
Content-Length: 2944
Lines: 108

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |   75 ++++++++++++++++++++---------------------------------------
 1 file changed, 25 insertions(+), 50 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9b15c5c..a5540d4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -787,47 +787,9 @@ restart:
 }
 EXPORT_SYMBOL(d_prune_aliases);
 
-/*
- * Try to throw away a dentry - free the inode, dput the parent.
- * Requires dentry->d_lock is held, and dentry->d_count == 0.
- * Releases dentry->d_lock.
- *
- * This may fail if locks cannot be acquired no problem, just try again.
- */
-static struct dentry * try_prune_one_dentry(struct dentry *dentry)
-	__releases(dentry->d_lock)
-{
-	struct dentry *parent;
-
-	parent = dentry_kill(dentry, 0);
-	/*
-	 * If dentry_kill returns NULL, we have nothing more to do.
-	 * if it returns the same dentry, trylocks failed. In either
-	 * case, just loop again.
-	 *
-	 * Otherwise, we need to prune ancestors too. This is necessary
-	 * to prevent quadratic behavior of shrink_dcache_parent(), but
-	 * is also expected to be beneficial in reducing dentry cache
-	 * fragmentation.
-	 */
-	if (!parent)
-		return NULL;
-	if (parent == dentry)
-		return dentry;
-
-	/* Prune ancestors. */
-	dentry = parent;
-	while (dentry) {
-		if (lockref_put_or_lock(&dentry->d_lockref))
-			return NULL;
-		dentry = dentry_kill(dentry, 1);
-	}
-	return NULL;
-}
-
 static void shrink_dentry_list(struct list_head *list)
 {
-	struct dentry *dentry;
+	struct dentry *dentry, *parent;
 
 	rcu_read_lock();
 	for (;;) {
@@ -863,22 +825,35 @@ static void shrink_dentry_list(struct list_head *list)
 		}
 		rcu_read_unlock();
 
+		parent = dentry_kill(dentry, 0);
 		/*
-		 * If 'try_to_prune()' returns a dentry, it will
-		 * be the same one we passed in, and d_lock will
-		 * have been held the whole time, so it will not
-		 * have been added to any other lists. We failed
-		 * to get the inode lock.
-		 *
-		 * We just add it back to the shrink list.
+		 * If dentry_kill returns NULL, we have nothing more to do.
 		 */
-		dentry = try_prune_one_dentry(dentry);
-
-		rcu_read_lock();
-		if (dentry) {
+		if (!parent) {
+			rcu_read_lock();
+			continue;
+		}
+		if (unlikely(parent == dentry)) {
+			/*
+			 * trylocks have failed and d_lock has been held the
+			 * whole time, so it could not have been added to any
+			 * other lists. Just add it back to the shrink list.
+			 */
+			rcu_read_lock();
 			d_shrink_add(dentry, list);
 			spin_unlock(&dentry->d_lock);
+			continue;
 		}
+		/*
+		 * We need to prune ancestors too. This is necessary to prevent
+		 * quadratic behavior of shrink_dcache_parent(), but is also
+		 * expected to be beneficial in reducing dentry cache
+		 * fragmentation.
+		 */
+		dentry = parent;
+		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
+			dentry = dentry_kill(dentry, 1);
+		rcu_read_lock();
 	}
 	rcu_read_unlock();
 }
-- 
1.7.10.4


>From 68fa8c9758d609094cc6a6004a8765ce0ea8052d Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 17:00:27 -0400
Subject: [PATCH 3/3] don't evict from shrink list on dentry_kill(dentry, 1)
Status: O
Content-Length: 4620
Lines: 168

let shrinker deal with that and with actual freeing of such dentries

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c            |   60 +++++++++++++++++++++++++++++++++++++++---------
 include/linux/dcache.h |    2 ++
 2 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a5540d4..a83b933 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -246,6 +246,15 @@ static void __d_free(struct rcu_head *head)
 	kmem_cache_free(dentry_cache, dentry); 
 }
 
+static void dentry_free(struct dentry *dentry)
+{
+	/* if dentry was never visible to RCU, immediate free is OK */
+	if (!(dentry->d_flags & DCACHE_RCUACCESS))
+		__d_free(&dentry->d_u.d_rcu);
+	else
+		call_rcu(&dentry->d_u.d_rcu, __d_free);
+}
+
 /**
  * dentry_rcuwalk_barrier - invalidate in-progress rcu-walk lookups
  * @dentry: the target dentry
@@ -448,6 +457,8 @@ void d_drop(struct dentry *dentry)
 }
 EXPORT_SYMBOL(d_drop);
 
+static DECLARE_WAIT_QUEUE_HEAD(free_wq);
+
 /*
  * Finish off a dentry we've decided to kill.
  * dentry->d_lock must be held, returns with it unlocked.
@@ -455,16 +466,17 @@ EXPORT_SYMBOL(d_drop);
  * Returns dentry requiring refcount drop, or NULL if we're done.
  */
 static struct dentry *
-dentry_kill(struct dentry *dentry, int unlock_on_failure)
+dentry_kill(struct dentry *dentry, struct list_head *morgue)
 	__releases(dentry->d_lock)
 {
 	struct inode *inode;
 	struct dentry *parent;
+	bool can_free = true;
 
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		if (unlock_on_failure) {
+		if (!morgue) {
 			spin_unlock(&dentry->d_lock);
 			cpu_relax();
 		}
@@ -480,6 +492,15 @@ relock:
 		goto relock;
 	}
 
+	if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+		/* morgue must be non-NULL */
+		list_move(&dentry->d_lru, morgue);
+		if (parent)
+			spin_unlock(&parent->d_lock);
+		/* inode must be NULL */
+		spin_unlock(&dentry->d_lock);
+		return parent;
+	}
 	/*
 	 * The dentry is now unrecoverably dead to the world.
 	 */
@@ -492,7 +513,14 @@ relock:
 	if ((dentry->d_flags & DCACHE_OP_PRUNE) && !d_unhashed(dentry))
 		dentry->d_op->d_prune(dentry);
 
-	dentry_lru_del(dentry);
+	if (dentry->d_flags & DCACHE_LRU_LIST) {
+		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
+			d_lru_del(dentry);
+		else if (morgue)
+			d_shrink_del(dentry);
+		else
+			can_free = false;
+	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
 	list_del(&dentry->d_u.d_child);
@@ -513,11 +541,14 @@ relock:
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	/* if dentry was never visible to RCU, immediate free is OK */
-	if (!(dentry->d_flags & DCACHE_RCUACCESS))
-		__d_free(&dentry->d_u.d_rcu);
-	else
-		call_rcu(&dentry->d_u.d_rcu, __d_free);
+	if (likely(can_free)) {
+		dentry_free(dentry);
+	} else {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_MAY_FREE;
+		spin_unlock(&dentry->d_lock);
+		wake_up(&free_wq);
+	}
 	return parent;
 }
 
@@ -574,7 +605,7 @@ repeat:
 	return;
 
 kill_it:
-	dentry = dentry_kill(dentry, 1);
+	dentry = dentry_kill(dentry, NULL);
 	if (dentry)
 		goto repeat;
 }
@@ -790,6 +821,7 @@ EXPORT_SYMBOL(d_prune_aliases);
 static void shrink_dentry_list(struct list_head *list)
 {
 	struct dentry *dentry, *parent;
+	LIST_HEAD(morgue);
 
 	rcu_read_lock();
 	for (;;) {
@@ -825,7 +857,7 @@ static void shrink_dentry_list(struct list_head *list)
 		}
 		rcu_read_unlock();
 
-		parent = dentry_kill(dentry, 0);
+		parent = dentry_kill(dentry, &morgue);
 		/*
 		 * If dentry_kill returns NULL, we have nothing more to do.
 		 */
@@ -852,10 +884,16 @@ static void shrink_dentry_list(struct list_head *list)
 		 */
 		dentry = parent;
 		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
-			dentry = dentry_kill(dentry, 1);
+			dentry = dentry_kill(dentry, NULL);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
+	while (unlikely(!list_empty(&morgue))) {
+		dentry = list_first_entry(&morgue, struct dentry, d_lru);
+		list_del_init(&dentry->d_lru);
+		wait_event(free_wq, dentry->d_flags & DCACHE_MAY_FREE);
+		dentry_free(dentry);
+	}
 }
 
 static enum lru_status
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 3b9bfdb..3c7ec32 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -221,6 +221,8 @@ struct dentry_operations {
 #define DCACHE_SYMLINK_TYPE		0x00300000 /* Symlink */
 #define DCACHE_FILE_TYPE		0x00400000 /* Other file type */
 
+#define DCACHE_MAY_FREE			0x00800000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(const struct dentry *dentry)
-- 
1.7.10.4


--2NLGdgz3UMHa/lqP--
