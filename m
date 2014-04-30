Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaD3EEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:04:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47300 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaD3EEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:04:39 -0400
Date: Wed, 30 Apr 2014 05:04:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430040436.GO18016@ZenIV.linux.org.uk>
References: <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
 <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 07:56:13PM -0700, Linus Torvalds wrote:
> On Tue, Apr 29, 2014 at 7:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK, aggregate diff follows, more readable splitup (3 commits) attached.
> > It seems to survive beating here; testing, review and comments are
> > welcome.
> 
> Miklos, did you have some particular load that triggered this, or was
> it just some reports? It would be really good to get this patch some
> stress-testing.
> 
> I like how the patch removes more lines than it adds, but apart from
> that it's hard to read the patch (even the split-out ones) and say
> anything more about it. I think this needs a *lot* of testing.

FWIW, the first two are really straightforward expanding the function
into its only callsite.  The last needs more splitup.  Not sure if the
following is good enough, but it ought to be at least somewhat cleaner.
Combined change is identical to the original, so it doesn't invalidate
the testing so far...

>From 895aeb48465bbf78803fd11dee2556d010ada23a Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 15:45:28 -0400
Subject: [PATCH 1/6] fold d_kill() and d_free()

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
Subject: [PATCH 2/6] fold try_prune_one_dentry()

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


>From d250553b1ca7d4c9b0544b4b6a3cdf5e2a3dd147 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 23:40:14 -0400
Subject: [PATCH 3/6] new helper: dentry_free()

The part of old d_free() that dealt with actual freeing of dentry.
Taken out of dentry_kill() into a separate function.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a5540d4..dab7db1 100644
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
@@ -513,11 +522,7 @@ relock:
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	/* if dentry was never visible to RCU, immediate free is OK */
-	if (!(dentry->d_flags & DCACHE_RCUACCESS))
-		__d_free(&dentry->d_u.d_rcu);
-	else
-		call_rcu(&dentry->d_u.d_rcu, __d_free);
+	dentry_free(dentry);
 	return parent;
 }
 
-- 
1.7.10.4


>From 2f2c6a0a4153054f2b3b44011ffbe8e4bae1a1e1 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 23:42:52 -0400
Subject: [PATCH 4/6] expand the call of dentry_lru_del() in dentry_kill()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index dab7db1..e482775 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -501,7 +501,12 @@ relock:
 	if ((dentry->d_flags & DCACHE_OP_PRUNE) && !d_unhashed(dentry))
 		dentry->d_op->d_prune(dentry);
 
-	dentry_lru_del(dentry);
+	if (dentry->d_flags & DCACHE_LRU_LIST) {
+		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
+			d_lru_del(dentry);
+		else
+			d_shrink_del(dentry);
+	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
 	list_del(&dentry->d_u.d_child);
-- 
1.7.10.4


>From 1d1c5bc3cff207847a2643d85442d25adcf9041a Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 23:52:05 -0400
Subject: [PATCH 5/6] Don't try to remove from shrink list we don't own

So far it's just been local equivalent transformations.  Now the meat of that
thing: dentry_kill() has two kinds of call sites - ones that had just
dropped the last reference (dput(), killing ancestors in shrink_dentry_list())
and one where the victim had sat on shrink list with zero refcount.  We already
have a flag telling which kind it is (unlock_on_failure).  What we want to do
is to avoid d_shrink_del() in the first kind of dentry_kill().  We do, however,
want everything except the actual freeing still done as we would in mainline.
So we need to deal with two new situations - the first kind of dentry_kill()
finding a dentry on shrink list (result of laziness in dget(); we had it on
shrink list with refcount 1) and the second kind finding a dentry that is
currently being killed by the first kind.  What we do is this:

* add another list in shrink_dentry_list() ('morgue'), pass it to the second
kind of dentry_kill(), which will move dentry there, drop locks and do nothing
else if it finds that the dentry is in process of being killed; we detect that
by seeing DCACHE_DENTRY_KILLED already set.
* have the first kind skip removal from shrink list and actual freeing
if dentry was on the shrink list; in that case instead of freeing the victim
just mark it DCACHE_MAY_FREE and wake free_wq.
* once shrink_dentry_list() has dealt with the entire list it has been given,
morgue will contain the ones that had triggered "don't free them yet" path in
dentry_kill(dentry, 1, ...).  They are going to acquire DCACHE_MAY_FREE once
dentry_kill() is through with them, so just wait for that (on free_wq) and
free them.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c            |   40 ++++++++++++++++++++++++++++++++++------
 include/linux/dcache.h |    2 ++
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index e482775..f0773f6 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -457,6 +457,8 @@ void d_drop(struct dentry *dentry)
 }
 EXPORT_SYMBOL(d_drop);
 
+static DECLARE_WAIT_QUEUE_HEAD(free_wq);
+
 /*
  * Finish off a dentry we've decided to kill.
  * dentry->d_lock must be held, returns with it unlocked.
@@ -464,11 +466,12 @@ EXPORT_SYMBOL(d_drop);
  * Returns dentry requiring refcount drop, or NULL if we're done.
  */
 static struct dentry *
-dentry_kill(struct dentry *dentry, int unlock_on_failure)
+dentry_kill(struct dentry *dentry, int unlock_on_failure, struct list_head *morgue)
 	__releases(dentry->d_lock)
 {
 	struct inode *inode;
 	struct dentry *parent;
+	bool can_free = true;
 
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
@@ -489,6 +492,15 @@ relock:
 		goto relock;
 	}
 
+	if (unlikely(morgue && dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+		list_move(&dentry->d_lru, morgue);
+		if (parent)
+			spin_unlock(&parent->d_lock);
+		if (inode)
+			spin_unlock(&inode->i_lock);
+		spin_unlock(&dentry->d_lock);
+		return parent;
+	}
 	/*
 	 * The dentry is now unrecoverably dead to the world.
 	 */
@@ -504,8 +516,10 @@ relock:
 	if (dentry->d_flags & DCACHE_LRU_LIST) {
 		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
 			d_lru_del(dentry);
-		else
+		else if (!unlock_on_failure)
 			d_shrink_del(dentry);
+		else
+			can_free = false;
 	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
@@ -527,7 +541,14 @@ relock:
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	dentry_free(dentry);
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
 
@@ -584,7 +605,7 @@ repeat:
 	return;
 
 kill_it:
-	dentry = dentry_kill(dentry, 1);
+	dentry = dentry_kill(dentry, 1, NULL);
 	if (dentry)
 		goto repeat;
 }
@@ -800,6 +821,7 @@ EXPORT_SYMBOL(d_prune_aliases);
 static void shrink_dentry_list(struct list_head *list)
 {
 	struct dentry *dentry, *parent;
+	LIST_HEAD(morgue);
 
 	rcu_read_lock();
 	for (;;) {
@@ -835,7 +857,7 @@ static void shrink_dentry_list(struct list_head *list)
 		}
 		rcu_read_unlock();
 
-		parent = dentry_kill(dentry, 0);
+		parent = dentry_kill(dentry, 0, &morgue);
 		/*
 		 * If dentry_kill returns NULL, we have nothing more to do.
 		 */
@@ -862,10 +884,16 @@ static void shrink_dentry_list(struct list_head *list)
 		 */
 		dentry = parent;
 		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
-			dentry = dentry_kill(dentry, 1);
+			dentry = dentry_kill(dentry, 1, NULL);
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


>From 3b9afa6f49ec53bf45067584d5baf567a0aa5105 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 23:57:14 -0400
Subject: [PATCH 6/6] clean up afterwards

a) dentry_kill() arguments are redundant - unlock_on_failure == !!morgue
b) the second kind of dentry_kill() can see dentry on process of being
killed only after it's been unlocked by dentry_iput(), so inode is
guaranteed to be NULL in that case
c) the first kind of dentry_kill can't see DCACHE_DENTRY_KILLED at all
(it's only set when refcount reaches zero and is unable to grow back;
the first kind is done right after having dropped the recount to zero).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f0773f6..a83b933 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -466,7 +466,7 @@ static DECLARE_WAIT_QUEUE_HEAD(free_wq);
  * Returns dentry requiring refcount drop, or NULL if we're done.
  */
 static struct dentry *
-dentry_kill(struct dentry *dentry, int unlock_on_failure, struct list_head *morgue)
+dentry_kill(struct dentry *dentry, struct list_head *morgue)
 	__releases(dentry->d_lock)
 {
 	struct inode *inode;
@@ -476,7 +476,7 @@ dentry_kill(struct dentry *dentry, int unlock_on_failure, struct list_head *morg
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		if (unlock_on_failure) {
+		if (!morgue) {
 			spin_unlock(&dentry->d_lock);
 			cpu_relax();
 		}
@@ -492,12 +492,12 @@ relock:
 		goto relock;
 	}
 
-	if (unlikely(morgue && dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+	if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+		/* morgue must be non-NULL */
 		list_move(&dentry->d_lru, morgue);
 		if (parent)
 			spin_unlock(&parent->d_lock);
-		if (inode)
-			spin_unlock(&inode->i_lock);
+		/* inode must be NULL */
 		spin_unlock(&dentry->d_lock);
 		return parent;
 	}
@@ -516,7 +516,7 @@ relock:
 	if (dentry->d_flags & DCACHE_LRU_LIST) {
 		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
 			d_lru_del(dentry);
-		else if (!unlock_on_failure)
+		else if (morgue)
 			d_shrink_del(dentry);
 		else
 			can_free = false;
@@ -605,7 +605,7 @@ repeat:
 	return;
 
 kill_it:
-	dentry = dentry_kill(dentry, 1, NULL);
+	dentry = dentry_kill(dentry, NULL);
 	if (dentry)
 		goto repeat;
 }
@@ -857,7 +857,7 @@ static void shrink_dentry_list(struct list_head *list)
 		}
 		rcu_read_unlock();
 
-		parent = dentry_kill(dentry, 0, &morgue);
+		parent = dentry_kill(dentry, &morgue);
 		/*
 		 * If dentry_kill returns NULL, we have nothing more to do.
 		 */
@@ -884,7 +884,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 */
 		dentry = parent;
 		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
-			dentry = dentry_kill(dentry, 1, NULL);
+			dentry = dentry_kill(dentry, NULL);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
1.7.10.4

